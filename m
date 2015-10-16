Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 961347F9C
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 10:22:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 72952304053
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:22:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id f91SOhCSfy5WlRBy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:22:00 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v11 31/48] richacl: Apply the file masks to a richacl
Date: Fri, 16 Oct 2015 17:18:09 +0200
Message-Id: <1445008706-15115-32-git-send-email-agruenba@redhat.com>
In-Reply-To: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
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
index 7e25343..c99274f 100644
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
index 67843a6..3f3445b 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -247,4 +247,7 @@ extern int richacl_permission(struct inode *, const struct richacl *, int);
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
