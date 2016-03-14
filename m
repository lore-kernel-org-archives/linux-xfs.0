Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A4ABD29E0B
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 09:56:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6B2D48F8040
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 07:56:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RWXmqKv85PGcWqlF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Mar 2016 07:56:03 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v19 08/23] richacl: Compute maximum file masks from an acl
Date: Mon, 14 Mar 2016 15:55:07 +0100
Message-Id: <1457967322-14886-9-git-send-email-agruenba@redhat.com>
In-Reply-To: <1457967322-14886-1-git-send-email-agruenba@redhat.com>
References: <1457967322-14886-1-git-send-email-agruenba@redhat.com>
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
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

Compute upper bound owner, group, and other file masks with as few
permissions as possible without denying any permissions that the NFSv4
acl in a richacl grants.

This algorithm is used when a file inherits an acl at create time and
when an acl is set via a mechanism that does not provide file masks
(such as setting an acl via nfsd).  When user-space sets an acl via
setxattr, the extended attribute already includes the file masks.

Setting an acl also sets the file mode permission bits: they are
determined by the file masks; see richacl_masks_to_mode().

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/richacl_base.c       | 157 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/richacl.h |   1 +
 2 files changed, 158 insertions(+)

diff --git a/fs/richacl_base.c b/fs/richacl_base.c
index d0a4135..056228f 100644
--- a/fs/richacl_base.c
+++ b/fs/richacl_base.c
@@ -181,3 +181,160 @@ richacl_want_to_mask(unsigned int want)
 	return mask;
 }
 EXPORT_SYMBOL_GPL(richacl_want_to_mask);
+
+/*
+ * Note: functions like richacl_allowed_to_who(), richacl_group_class_allowed(),
+ * and richacl_compute_max_masks() iterate through the entire acl in reverse
+ * order as an optimization.
+ *
+ * In the standard algorithm, aces are considered in forward order.  When a
+ * process matches an ace, the permissions in the ace are either allowed or
+ * denied depending on the ace type.  Once a permission has been allowed or
+ * denied, it is no longer considered in further aces.
+ *
+ * By iterating through the acl in reverse order, we can compute the same
+ * result without having to keep track of which permissions have been allowed
+ * and denied already.
+ */
+
+/**
+ * richacl_allowed_to_who  -  permissions allowed to a specific who value
+ *
+ * Compute the maximum mask values allowed to a specific who value, taking
+ * everyone@ aces into account.
+ */
+static unsigned int richacl_allowed_to_who(struct richacl *acl,
+					   struct richace *who)
+{
+	struct richace *ace;
+	unsigned int allowed = 0;
+
+	richacl_for_each_entry_reverse(ace, acl) {
+		if (richace_is_inherit_only(ace))
+			continue;
+		if (richace_is_same_identifier(ace, who) ||
+		    richace_is_everyone(ace)) {
+			if (richace_is_allow(ace))
+				allowed |= ace->e_mask;
+			else if (richace_is_deny(ace))
+				allowed &= ~ace->e_mask;
+		}
+	}
+	return allowed;
+}
+
+/**
+ * richacl_group_class_allowed  -  maximum permissions of the group class
+ *
+ * Compute the maximum mask values allowed to a process in the group class
+ * (i.e., a process which is not the owner but is in the owning group or
+ * matches a user or group acl entry).  This includes permissions granted or
+ * denied by everyone@ aces.
+ *
+ * See richacl_compute_max_masks().
+ */
+static unsigned int richacl_group_class_allowed(struct richacl *acl)
+{
+	struct richace *ace;
+	unsigned int everyone_allowed = 0, group_class_allowed = 0;
+	int had_group_ace = 0;
+
+	richacl_for_each_entry_reverse(ace, acl) {
+		if (richace_is_inherit_only(ace) ||
+		    richace_is_owner(ace))
+			continue;
+
+		if (richace_is_everyone(ace)) {
+			if (richace_is_allow(ace))
+				everyone_allowed |= ace->e_mask;
+			else if (richace_is_deny(ace))
+				everyone_allowed &= ~ace->e_mask;
+		} else {
+			group_class_allowed |=
+				richacl_allowed_to_who(acl, ace);
+
+			if (richace_is_group(ace))
+				had_group_ace = 1;
+		}
+	}
+	/*
+	 * If the acl doesn't contain any group@ aces, richacl_allowed_to_who()
+	 * wasn't called for the owning group.  We could make that call now, but
+	 * we already know the result (everyone_allowed).
+	 */
+	if (!had_group_ace)
+		group_class_allowed |= everyone_allowed;
+	return group_class_allowed;
+}
+
+/**
+ * richacl_compute_max_masks  -  compute upper bound masks
+ *
+ * Computes upper bound owner, group, and other masks so that none of the
+ * permissions allowed by the acl are disabled.
+ *
+ * We don't make assumptions about who the owner is so that the owner can
+ * change with no effect on the file masks or file mode permission bits; this
+ * means that we must assume that all entries can match the owner.
+ */
+void richacl_compute_max_masks(struct richacl *acl)
+{
+	unsigned int gmask = ~0;
+	struct richace *ace;
+
+	/*
+	 * @gmask contains all permissions which the group class is ever
+	 * allowed.  We use it to avoid adding permissions to the group mask
+	 * from everyone@ allow aces which the group class is always denied
+	 * through other aces.  For example, the following acl would otherwise
+	 * result in a group mask of rw:
+	 *
+	 *	group@:w::deny
+	 *	everyone@:rw::allow
+	 *
+	 * Avoid computing @gmask for acls which do not include any group class
+	 * deny aces: in such acls, the group class is never denied any
+	 * permissions from everyone@ allow aces, and the group class cannot
+	 * have fewer permissions than the other class.
+	 */
+
+restart:
+	acl->a_owner_mask = 0;
+	acl->a_group_mask = 0;
+	acl->a_other_mask = 0;
+
+	richacl_for_each_entry_reverse(ace, acl) {
+		if (richace_is_inherit_only(ace))
+			continue;
+
+		if (richace_is_owner(ace)) {
+			if (richace_is_allow(ace))
+				acl->a_owner_mask |= ace->e_mask;
+			else if (richace_is_deny(ace))
+				acl->a_owner_mask &= ~ace->e_mask;
+		} else if (richace_is_everyone(ace)) {
+			if (richace_is_allow(ace)) {
+				acl->a_owner_mask |= ace->e_mask;
+				acl->a_group_mask |= ace->e_mask & gmask;
+				acl->a_other_mask |= ace->e_mask;
+			} else if (richace_is_deny(ace)) {
+				acl->a_owner_mask &= ~ace->e_mask;
+				acl->a_group_mask &= ~ace->e_mask;
+				acl->a_other_mask &= ~ace->e_mask;
+			}
+		} else {
+			if (richace_is_allow(ace)) {
+				acl->a_owner_mask |= ace->e_mask & gmask;
+				acl->a_group_mask |= ace->e_mask & gmask;
+			} else if (richace_is_deny(ace) && gmask == ~0) {
+				gmask = richacl_group_class_allowed(acl);
+				if (likely(gmask != ~0))
+					/* should always be true */
+					goto restart;
+			}
+		}
+	}
+
+	acl->a_flags &= ~(RICHACL_WRITE_THROUGH | RICHACL_MASKED);
+}
+EXPORT_SYMBOL_GPL(richacl_compute_max_masks);
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index 9102ef0..3559b2c 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -178,5 +178,6 @@ extern void richace_copy(struct richace *, const struct richace *);
 extern int richacl_masks_to_mode(const struct richacl *);
 extern unsigned int richacl_mode_to_mask(umode_t);
 extern unsigned int richacl_want_to_mask(unsigned int);
+extern void richacl_compute_max_masks(struct richacl *);
 
 #endif /* __RICHACL_H */
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
