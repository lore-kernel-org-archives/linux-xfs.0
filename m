Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9D1427CAE
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 06:52:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6F8F38F8033
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 04:52:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id m2naJRiuOJnV7Tnc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 31 May 2016 04:52:05 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v22 09/22] richacl: Permission check algorithm
Date: Tue, 31 May 2016 13:50:41 +0200
Message-Id: <1464695454-18557-10-git-send-email-agruenba@redhat.com>
In-Reply-To: <1464695454-18557-1-git-send-email-agruenba@redhat.com>
References: <1464695454-18557-1-git-send-email-agruenba@redhat.com>
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

A richacl roughly grants a requested access if the NFSv4 acl in the
richacl grants the requested permissions according to the NFSv4
permission check algorithm and the file mask that applies to the process
includes the requested permissions.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: J. Bruce Fields <bfields@fieldses.org>
---
 fs/richacl.c            | 128 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/richacl.h |   1 +
 2 files changed, 129 insertions(+)

diff --git a/fs/richacl.c b/fs/richacl.c
index 056228f..cb0ef3f 100644
--- a/fs/richacl.c
+++ b/fs/richacl.c
@@ -338,3 +338,131 @@ restart:
 	acl->a_flags &= ~(RICHACL_WRITE_THROUGH | RICHACL_MASKED);
 }
 EXPORT_SYMBOL_GPL(richacl_compute_max_masks);
+
+/**
+ * richacl_permission  -  richacl permission check algorithm
+ * @inode:	inode to check
+ * @acl:	rich acl of the inode
+ * @want:	requested access (MAY_* flags)
+ *
+ * Checks if the current process is granted @mask flags in @acl.
+ */
+int
+richacl_permission(struct inode *inode, const struct richacl *acl,
+		   int want)
+{
+	const struct richace *ace;
+	unsigned int mask = richacl_want_to_mask(want);
+	unsigned int requested = mask, denied = 0;
+	int in_owning_group = in_group_p(inode->i_gid);
+	int in_owner_or_group_class = in_owning_group;
+
+	/*
+	 * A process is
+	 *   - in the owner file class if it owns the file,
+	 *   - in the group file class if it is in the file's owning group or
+	 *     it matches any of the user or group entries, and
+	 *   - in the other file class otherwise.
+	 * The file class is only relevant for determining which file mask to
+	 * apply, which only happens for masked acls.
+	 */
+	if (acl->a_flags & RICHACL_MASKED) {
+		if ((acl->a_flags & RICHACL_WRITE_THROUGH) &&
+		    uid_eq(current_fsuid(), inode->i_uid)) {
+			denied = requested & ~acl->a_owner_mask;
+			goto out;
+		}
+	} else {
+		/*
+		 * When the acl is not masked, there is no need to determine if
+		 * the process is in the group class and we can break out
+		 * earlier of the loop below.
+		 */
+		in_owner_or_group_class = 1;
+	}
+
+	/*
+	 * Check if the acl grants the requested access and determine which
+	 * file class the process is in.
+	 */
+	richacl_for_each_entry(ace, acl) {
+		unsigned int ace_mask = ace->e_mask;
+
+		if (richace_is_inherit_only(ace))
+			continue;
+		if (richace_is_owner(ace)) {
+			if (!uid_eq(current_fsuid(), inode->i_uid))
+				continue;
+			goto entry_matches_owner;
+		} else if (richace_is_group(ace)) {
+			if (!in_owning_group)
+				continue;
+		} else if (richace_is_unix_user(ace)) {
+			if (!uid_eq(current_fsuid(), ace->e_id.uid))
+				continue;
+			if (uid_eq(current_fsuid(), inode->i_uid))
+				goto entry_matches_owner;
+		} else if (richace_is_unix_group(ace)) {
+			if (!in_group_p(ace->e_id.gid))
+				continue;
+		} else
+			goto entry_matches_everyone;
+
+		/*
+		 * Apply the group file mask to entries other than owner@ and
+		 * everyone@ or user entries matching the owner.  This ensures
+		 * that we grant the same permissions as the acl computed by
+		 * richacl_apply_masks().
+		 *
+		 * Without this restriction, the following richacl would grant
+		 * rw access to processes which are both the owner and in the
+		 * owning group, but not to other users in the owning group,
+		 * which could not be represented without masks:
+		 *
+		 *  owner:rw::mask
+		 *  group@:rw::allow
+		 */
+		if ((acl->a_flags & RICHACL_MASKED) && richace_is_allow(ace))
+			ace_mask &= acl->a_group_mask;
+
+entry_matches_owner:
+		/* The process is in the owner or group file class. */
+		in_owner_or_group_class = 1;
+
+entry_matches_everyone:
+		/* Check which mask flags the ACE allows or denies. */
+		if (richace_is_deny(ace))
+			denied |= ace_mask & mask;
+		mask &= ~ace_mask;
+
+		/*
+		 * Keep going until we know which file class
+		 * the process is in.
+		 */
+		if (!mask && in_owner_or_group_class)
+			break;
+	}
+	denied |= mask;
+
+	if (acl->a_flags & RICHACL_MASKED) {
+		/*
+		 * The file class a process is in determines which file mask
+		 * applies.  Check if that file mask also grants the requested
+		 * access.
+		 */
+		if (uid_eq(current_fsuid(), inode->i_uid))
+			denied |= requested & ~acl->a_owner_mask;
+		else if (in_owner_or_group_class)
+			denied |= requested & ~acl->a_group_mask;
+		else {
+			if (acl->a_flags & RICHACL_WRITE_THROUGH)
+				denied = requested & ~acl->a_other_mask;
+			else
+				denied |= requested & ~acl->a_other_mask;
+		}
+	}
+
+out:
+	return denied ? -EACCES : 0;
+}
+EXPORT_SYMBOL_GPL(richacl_permission);
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index 3559b2c..be9fb65 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -179,5 +179,6 @@ extern int richacl_masks_to_mode(const struct richacl *);
 extern unsigned int richacl_mode_to_mask(umode_t);
 extern unsigned int richacl_want_to_mask(unsigned int);
 extern void richacl_compute_max_masks(struct richacl *);
+extern int richacl_permission(struct inode *, const struct richacl *, int);
 
 #endif /* __RICHACL_H */
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
