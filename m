Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4913029E0C
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 09:23:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 297028F8040
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 07:23:50 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bssJp8RXAk3sdeXx (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2016 07:23:44 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v17 15/22] richacl: Check if an acl is equivalent to a file
	mode
Date: Mon, 11 Jan 2016 16:21:46 +0100
Message-Id: <1452525713-11348-16-git-send-email-agruenba@redhat.com>
In-Reply-To: <1452525713-11348-1-git-send-email-agruenba@redhat.com>
References: <1452525713-11348-1-git-send-email-agruenba@redhat.com>
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

ACLs are considered equivalent to file modes if they only consist of
owner@, group@, and everyone@ entries, the owner@ permissions do not
depend on whether the owner is a member in the owning group, and no
inheritance flags are set.  This test is used to avoid storing richacls
if the acl can be computed from the file permission bits.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/richacl_base.c       | 104 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/richacl.h |   1 +
 2 files changed, 105 insertions(+)

diff --git a/fs/richacl_base.c b/fs/richacl_base.c
index e4dd779..74e5cb5 100644
--- a/fs/richacl_base.c
+++ b/fs/richacl_base.c
@@ -382,3 +382,107 @@ __richacl_chmod(struct richacl *acl, umode_t mode)
 	return clone;
 }
 EXPORT_SYMBOL_GPL(__richacl_chmod);
+
+/**
+ * richacl_equiv_mode  -  compute the mode equivalent of @acl
+ *
+ * An acl is considered equivalent to a file mode if it only consists of
+ * owner@, group@, and everyone@ entries and the owner@ permissions do not
+ * depend on whether the owner is a member in the owning group.
+ */
+int
+richacl_equiv_mode(const struct richacl *acl, umode_t *mode_p)
+{
+	umode_t mode = *mode_p;
+
+	/*
+	 * The RICHACE_DELETE_CHILD flag is meaningless for non-directories, so
+	 * we ignore it.
+	 */
+	unsigned int x = S_ISDIR(mode) ? 0 : RICHACE_DELETE_CHILD;
+	struct {
+		unsigned int allowed;
+		unsigned int defined;  /* allowed or denied */
+	} owner = {
+		.defined = RICHACE_POSIX_ALWAYS_ALLOWED |
+			   RICHACE_POSIX_OWNER_ALLOWED  | x,
+	}, group = {
+		.defined = RICHACE_POSIX_ALWAYS_ALLOWED | x,
+	}, everyone = {
+		.defined = RICHACE_POSIX_ALWAYS_ALLOWED | x,
+	};
+	const struct richace *ace;
+
+	if (acl->a_flags & ~(RICHACL_WRITE_THROUGH | RICHACL_MASKED))
+		return -1;
+
+	richacl_for_each_entry(ace, acl) {
+		if (ace->e_flags & ~RICHACE_SPECIAL_WHO)
+			return -1;
+
+		if (richace_is_owner(ace) || richace_is_everyone(ace)) {
+			x = ace->e_mask & ~owner.defined;
+			if (richace_is_allow(ace)) {
+				unsigned int group_denied =
+					group.defined & ~group.allowed;
+
+				if (x & group_denied)
+					return -1;
+				owner.allowed |= x;
+			} else /* if (richace_is_deny(ace)) */ {
+				if (x & group.allowed)
+					return -1;
+			}
+			owner.defined |= x;
+
+			if (richace_is_everyone(ace)) {
+				x = ace->e_mask;
+				if (richace_is_allow(ace)) {
+					group.allowed |=
+						x & ~group.defined;
+					everyone.allowed |=
+						x & ~everyone.defined;
+				}
+				group.defined |= x;
+				everyone.defined |= x;
+			}
+		} else if (richace_is_group(ace)) {
+			x = ace->e_mask & ~group.defined;
+			if (richace_is_allow(ace))
+				group.allowed |= x;
+			group.defined |= x;
+		} else
+			return -1;
+	}
+
+	if (group.allowed & ~owner.defined)
+		return -1;
+
+	if (acl->a_flags & RICHACL_MASKED) {
+		if (acl->a_flags & RICHACL_WRITE_THROUGH) {
+			owner.allowed = acl->a_owner_mask;
+			everyone.allowed = acl->a_other_mask;
+		} else {
+			owner.allowed &= acl->a_owner_mask;
+			everyone.allowed &= acl->a_other_mask;
+		}
+		group.allowed &= acl->a_group_mask;
+	}
+
+	mode = (mode & ~S_IRWXUGO) |
+	       (richacl_mask_to_mode(owner.allowed) << 6) |
+	       (richacl_mask_to_mode(group.allowed) << 3) |
+		richacl_mask_to_mode(everyone.allowed);
+
+	/* Mask flags we can ignore */
+	x = S_ISDIR(mode) ? 0 : RICHACE_DELETE_CHILD;
+
+	if (((richacl_mode_to_mask(mode >> 6) ^ owner.allowed)    & ~x) ||
+	    ((richacl_mode_to_mask(mode >> 3) ^ group.allowed)    & ~x) ||
+	    ((richacl_mode_to_mask(mode)      ^ everyone.allowed) & ~x))
+		return -1;
+
+	*mode_p = mode;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(richacl_equiv_mode);
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index a2d5600..b7128bf 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -185,6 +185,7 @@ extern unsigned int richacl_mode_to_mask(umode_t);
 extern unsigned int richacl_want_to_mask(unsigned int);
 extern void richacl_compute_max_masks(struct richacl *);
 extern struct richacl *__richacl_chmod(struct richacl *, umode_t);
+extern int richacl_equiv_mode(const struct richacl *, umode_t *);
 
 /* richacl_inode.c */
 extern int richacl_permission(struct inode *, const struct richacl *, int);
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
