Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 71CBB29E2C
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 09:21:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6026D8F8033
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 07:21:35 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nEQuG26H7HAHj4jG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2015 07:21:33 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v13 34/51] richacl: Apply the file masks to a richacl
Date: Tue,  3 Nov 2015 16:17:10 +0100
Message-Id: <1446563847-14005-35-git-send-email-agruenba@redhat.com>
In-Reply-To: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>

Put all the pieces of the acl transformation puzzle together for
computing a richacl which has the file masks "applied" so that the
standard nfsv4 access check algorithm can be used on the richacl.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/richacl_compat.c     | 101 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/richacl.h |   3 ++
 2 files changed, 104 insertions(+)

diff --git a/fs/richacl_compat.c b/fs/richacl_compat.c
index 7553f1a..ea3effd 100644
--- a/fs/richacl_compat.c
+++ b/fs/richacl_compat.c
@@ -726,3 +726,104 @@ richacl_isolate_group_class(struct richacl_alloc *alloc, unsigned int deny)
 	}
 	return 0;
 }
+
+/**
+ * __richacl_apply_masks  -  apply the file masks to all aces
+ * @alloc:	acl and number of allocated entries
+ *
+ * Apply the owner mask to owner@ aces, the other mask to
+ * everyone@ aces, and the group mask to all other aces.
+ *
+ * The previous transformations have brought the acl into a
+ * form in which applying the masks will not lead to the
+ * accidental loss of permissions anymore.
+ */
+static int
+__richacl_apply_masks(struct richacl_alloc *alloc, kuid_t owner)
+{
+	struct richace *ace;
+
+	richacl_for_each_entry(ace, alloc->acl) {
+		unsigned int mask;
+
+		if (richace_is_inherit_only(ace) || !richace_is_allow(ace))
+			continue;
+		if (richace_is_owner(ace) ||
+		    (richace_is_unix_user(ace) && uid_eq(owner, ace->e_id.uid)))
+			mask = alloc->acl->a_owner_mask;
+		else if (richace_is_everyone(ace))
+			mask = alloc->acl->a_other_mask;
+		else
+			mask = alloc->acl->a_group_mask;
+		if (richace_change_mask(alloc, &ace, ace->e_mask & mask))
+			return -1;
+	}
+	return 0;
+}
+
+/**
+ * richacl_apply_masks  -  apply the masks to the acl
+ *
+ * Transform @acl so that the standard NFSv4 permission check algorithm (which
+ * is not aware of file masks) will compute the same access decisions as the
+ * richacl permission check algorithm (which looks at the acl and the file
+ * masks).
+ *
+ * This algorithm is split into several steps:
+ *
+ *   - Move everyone@ aces to the end of the acl.  This simplifies the other
+ *     transformations, and allows the everyone@ allow ace at the end of the
+ *     acl to eventually allow permissions to the other class only.
+ *
+ *   - Propagate everyone@ permissions up the acl.  This transformation makes
+ *     sure that the owner and group class aces won't lose any permissions when
+ *     we apply the other mask to the everyone@ allow ace at the end of the acl.
+ *
+ *   - Apply the file masks to all aces.
+ *
+ *   - Make sure everyone is granted the other mask permissions.  This step can
+ *     elevate elevate permissions for the owner and group classes, which is
+ *     corrected later.
+ *
+ *   - Make sure that the group class is not granted any permissions from
+ *     everyone@.
+ *
+ *   - Make sure the owner is granted the owner mask permissions.
+ *
+ *   - Make sure the owner is not granted any permissions beyond the owner
+ *     mask from group class aces or from everyone@.
+ *
+ * NOTE: Depending on the acl and file masks, this algorithm can increase the
+ * number of aces by almost a factor of three in the worst case. This may make
+ * the acl too large for some purposes.
+ */
+int
+richacl_apply_masks(struct richacl **acl, kuid_t owner)
+{
+	if ((*acl)->a_flags & RICHACL_MASKED) {
+		struct richacl_alloc alloc = {
+			.acl = richacl_clone(*acl, GFP_KERNEL),
+			.count = (*acl)->a_count,
+		};
+		unsigned int added = 0;
+
+		if (!alloc.acl)
+			return -ENOMEM;
+		if (richacl_move_everyone_aces_down(&alloc) ||
+		    richacl_propagate_everyone(&alloc) ||
+		    __richacl_apply_masks(&alloc, owner) ||
+		    richacl_set_other_permissions(&alloc, &added) ||
+		    richacl_isolate_group_class(&alloc, added) ||
+		    richacl_set_owner_permissions(&alloc) ||
+		    richacl_isolate_owner_class(&alloc)) {
+			richacl_put(alloc.acl);
+			return -ENOMEM;
+		}
+
+		alloc.acl->a_flags &= ~(RICHACL_WRITE_THROUGH | RICHACL_MASKED);
+		richacl_put(*acl);
+		*acl = alloc.acl;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(richacl_apply_masks);
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index 7cfa64d..3fdfc57 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -205,4 +205,7 @@ extern int richacl_permission(struct inode *, const struct richacl *, int);
 extern int richacl_chmod(struct inode *, umode_t);
 extern struct richacl *richacl_create(umode_t *, struct inode *);
 
+/* richacl_compat.c */
+extern int richacl_apply_masks(struct richacl **, kuid_t);
+
 #endif /* __RICHACL_H */
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
