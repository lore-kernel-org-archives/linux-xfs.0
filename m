Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6D7737F67
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 07:59:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3B23E8F8035
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 05:59:35 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZtQVfjACQJmjLp0C (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 05:59:31 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH v15 00/22] Richacls (Core and Ext4)
Date: Wed, 11 Nov 2015 14:59:21 +0100
Message-Id: <1447250361-5561-1-git-send-email-agruenba@redhat.com>
References: <1447067343-31479-1-git-send-email-agruenba@redhat.com>
	<20151110112943.GA17038@infradead.org>
	<20151111075707.GA23752@infradead.org>
In-Reply-To: <20151111075707.GA23752@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

On Wed, Nov 11, 2015 at 8:57 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Nov 10, 2015 at 01:39:52PM +0100, Andreas Gruenbacher wrote:
>> > It still has the same crappy fs interfaces with lots of boilerplate
>> > code
>>
>> Could you please be more specific so that I can trace this complaint
>> to some actual code?
>
> if (IS_RICHACL())
>         richacl_foo()
> else
>         posix_acl_foo()
>
> for every call from the filesystem is the major one that came to mind.

There are two such places in ext4, ext4_new_acl and ext4_acl_chmod.  Those
could be replaced by function pointers as below, I'm not sure we seriously
want to consider that.

In xfs, we have xfs_acl_chmod which is similar.  xfs_generic_create doesn't
quite follow this pattern.

This seems to be about it though.

Thanks,
Andreas

---
 fs/ext4/ext4.h     | 10 ++++++++++
 fs/ext4/ialloc.c   | 11 +----------
 fs/ext4/inode.c    | 11 +----------
 fs/ext4/super.c    | 30 ++++++++++++++++++++++++++++++
 include/linux/fs.h |  1 +
 5 files changed, 43 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b97a3b1..5ff4556 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3049,6 +3049,16 @@ extern struct mutex ext4__aio_mutex[EXT4_WQ_HASH_SZ];
 extern int ext4_resize_begin(struct super_block *sb);
 extern void ext4_resize_end(struct super_block *sb);
 
+struct ext4_acl_ops {
+	int (*chmod)(struct inode *, umode_t);
+	int (*init_acl)(handle_t *, struct inode *, struct inode *);
+};
+
+static inline const struct ext4_acl_ops *ACL_OPS(struct inode *inode)
+{
+	return inode->i_sb->s_private;
+}
+
 #endif	/* __KERNEL__ */
 
 #endif	/* _EXT4_H */
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 9657b3a..e33646f 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -27,7 +27,6 @@
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
-#include "richacl.h"
 
 #include <trace/events/ext4.h>
 
@@ -698,14 +697,6 @@ out:
 	return ret;
 }
 
-static inline int
-ext4_new_acl(handle_t *handle, struct inode *inode, struct inode *dir)
-{
-	if (IS_RICHACL(dir))
-		return ext4_init_richacl(handle, inode, dir);
-	return ext4_init_acl(handle, inode, dir);
-}
-
 /*
  * There are two policies for allocating an inode.  If the new inode is
  * a directory, then a forward search is made for a block group with both
@@ -1061,7 +1052,7 @@ got:
 	if (err)
 		goto fail_drop;
 
-	err = ext4_new_acl(handle, inode, dir);
+	err = ACL_OPS(inode)->init_acl(handle, inode, dir);
 	if (err)
 		goto fail_free_drop;
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 647f3c3..9f179ee 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -42,7 +42,6 @@
 #include "xattr.h"
 #include "acl.h"
 #include "truncate.h"
-#include "richacl.h"
 
 #include <trace/events/ext4.h>
 
@@ -4639,14 +4638,6 @@ static void ext4_wait_for_tail_page_commit(struct inode *inode)
 	}
 }
 
-static inline int
-ext4_acl_chmod(struct inode *inode, umode_t mode)
-{
-	if (IS_RICHACL(inode))
-		return richacl_chmod(inode, inode->i_mode);
-	return posix_acl_chmod(inode, inode->i_mode);
-}
-
 /*
  * ext4_setattr()
  *
@@ -4815,7 +4806,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 		ext4_orphan_del(NULL, inode);
 
 	if (!rc && (ia_valid & ATTR_MODE))
-		rc = ext4_acl_chmod(inode, inode->i_mode);
+		rc = ACL_OPS(inode)->chmod(inode, inode->i_mode);
 err_out:
 	ext4_std_error(inode->i_sb, error);
 	if (!error)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7457ea8..879bc2c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -49,6 +49,7 @@
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
+#include "richacl.h"
 #include "mballoc.h"
 
 #define CREATE_TRACE_POINTS
@@ -1270,25 +1271,54 @@ static ext4_fsblk_t get_sb_block(void **data)
 	return sb_block;
 }
 
+static int no_chmod_acl(struct inode *inode, umode_t mode)
+{
+	return 0;
+}
+
+static int no_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
+{
+	return 0;
+}
+
+struct ext4_acl_ops no_acl_ops = {
+	.chmod = no_chmod_acl,
+	.init_acl = no_init_acl,
+};
+
+struct ext4_acl_ops ext4_posix_acl_ops = {
+	.chmod = posix_acl_chmod,
+	.init_acl = ext4_init_acl,
+};
+
+struct ext4_acl_ops ext4_richacl_ops = {
+	.chmod = richacl_chmod,
+	.init_acl = ext4_init_richacl,
+};
+
 static int enable_acl(struct super_block *sb)
 {
 	sb->s_flags &= ~(MS_POSIXACL | MS_RICHACL);
+	sb->s_private = &no_acl_ops;
 	if (test_opt(sb, ACL)) {
 		if (EXT4_HAS_INCOMPAT_FEATURE(sb,
 					      EXT4_FEATURE_INCOMPAT_RICHACL)) {
 #ifdef CONFIG_EXT4_FS_RICHACL
 			sb->s_flags |= MS_RICHACL;
+			sb->s_private = &ext4_richacl_ops;
 #else
 			return -EOPNOTSUPP;
 #endif
 		} else {
 #ifdef CONFIG_EXT4_FS_POSIX_ACL
 			sb->s_flags |= MS_POSIXACL;
+			sb->s_private = &ext4_posix_acl_ops;
 #else
 			return -EOPNOTSUPP;
 #endif
 		}
 	}
+
 	return 0;
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 05fb943..5803bf6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1324,6 +1324,7 @@ struct super_block {
 	void                    *s_security;
 #endif
 	const struct xattr_handler **s_xattr;
+	const void *s_private;
 
 	struct hlist_bl_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 	struct list_head	s_mounts;	/* list of mounts; _not_ for fs use */
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
