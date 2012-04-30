Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3ULQrvS036672 for <xfs@oss.sgi.com>; Mon, 30 Apr 2012 16:26:53 -0500
Received: from fieldses.org (fieldses.org [174.143.236.118]) by cuda.sgi.com
	with ESMTP id P7UZAjZZsVAwHRiq (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 30 Apr 2012 14:26:51 -0700 (PDT)
Date: Mon, 30 Apr 2012 17:26:49 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: detecting case-insensitivity
Message-ID: <20120430212649.GB22323@fieldses.org>
References: <20120407140029.GA24090@fieldses.org>
	<20120411200335.GD28816@infradead.org>
	<20120411203735.GB31706@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120411203735.GB31706@fieldses.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Apr 11, 2012 at 04:37:35PM -0400, J. Bruce Fields wrote:
> On Wed, Apr 11, 2012 at 04:03:35PM -0400, Christoph Hellwig wrote:
> > Can you add a new s_feature_flags instead of s_flags which is shared
> > with the mount user ABI?  MS_I_VERSION should also move there.
> 
> I was wondering about that.  Yes, that makes a lot more sense, I'll work
> on it.

Just something like this?

--b.

>From a77af075724487a62f344cf4dccf4ce1b8324c48 Mon Sep 17 00:00:00 2001
From: "J. Bruce Fields" <bfields@redhat.com>
Date: Mon, 30 Apr 2012 16:43:57 -0400
Subject: [PATCH 1/2] vfs: move MS_I_VERSION to new s_feature_flags field

This is a property of the file system rather than a mount flag (even if
it happens that ext4 uses a mount option to turn i_version updating on
and off.)

We expect there to be other such flags.

Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/ext4/super.c    |    4 ++--
 include/linux/fs.h |   12 ++++++++----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6da1935..003648d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1483,7 +1483,7 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		sbi->s_mount_flags |= EXT4_MF_FS_ABORTED;
 		return 1;
 	case Opt_i_version:
-		sb->s_flags |= MS_I_VERSION;
+		sb->s_feature_flags |= SF_I_VERSION;
 		return 1;
 	case Opt_journal_dev:
 		if (is_remount) {
@@ -1749,7 +1749,7 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
 		SEQ_OPTS_PRINT("min_batch_time=%u", sbi->s_min_batch_time);
 	if (nodefs || sbi->s_max_batch_time != EXT4_DEF_MAX_BATCH_TIME)
 		SEQ_OPTS_PRINT("max_batch_time=%u", sbi->s_max_batch_time);
-	if (sb->s_flags & MS_I_VERSION)
+	if (sb->s_flags & SF_I_VERSION)
 		SEQ_OPTS_PUTS("i_version");
 	if (nodefs || sbi->s_stripe)
 		SEQ_OPTS_PRINT("stripe=%lu", sbi->s_stripe);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 99cbb1f..1b0eef8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -212,7 +212,7 @@ struct inodes_stat_t {
 #define MS_SHARED	(1<<20)	/* change to shared */
 #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
-#define MS_I_VERSION	(1<<23) /* Update inode I_version field */
+/* Free bit */
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
 #define MS_NOSEC	(1<<28)
 #define MS_BORN		(1<<29)
@@ -222,7 +222,7 @@ struct inodes_stat_t {
 /*
  * Superblock flags that can be altered by MS_REMOUNT
  */
-#define MS_RMT_MASK	(MS_RDONLY|MS_SYNCHRONOUS|MS_MANDLOCK|MS_I_VERSION)
+#define MS_RMT_MASK	(MS_RDONLY|MS_SYNCHRONOUS|MS_MANDLOCK)
 
 /*
  * Old magic mount flag and mask
@@ -230,6 +230,9 @@ struct inodes_stat_t {
 #define MS_MGC_VAL 0xC0ED0000
 #define MS_MGC_MSK 0xffff0000
 
+/* Superblock feature flags: */
+#define SF_I_VERSION	(1<<0)	/* Update inode i_version field */
+
 /* Inode flags - they have nothing to superblock flags now */
 
 #define S_SYNC		1	/* Writes are synced at once */
@@ -268,7 +271,7 @@ struct inodes_stat_t {
 					((inode)->i_flags & (S_SYNC|S_DIRSYNC)))
 #define IS_MANDLOCK(inode)	__IS_FLG(inode, MS_MANDLOCK)
 #define IS_NOATIME(inode)   __IS_FLG(inode, MS_RDONLY|MS_NOATIME)
-#define IS_I_VERSION(inode)   __IS_FLG(inode, MS_I_VERSION)
+#define IS_I_VERSION(inode)  ((inode)->i_sb->s_flags & SF_I_VERSION)
 
 #define IS_NOQUOTA(inode)	((inode)->i_flags & S_NOQUOTA)
 #define IS_APPEND(inode)	((inode)->i_flags & S_APPEND)
@@ -1428,7 +1431,8 @@ struct super_block {
 	const struct dquot_operations	*dq_op;
 	const struct quotactl_ops	*s_qcop;
 	const struct export_operations *s_export_op;
-	unsigned long		s_flags;
+	unsigned long		s_flags; /* mount flags */
+	unsigned int		s_feature_flags;
 	unsigned long		s_magic;
 	struct dentry		*s_root;
 	struct rw_semaphore	s_umount;
-- 
1.7.7.6


>From 52e25728d2df7608a553dc0713544927adeb3be2 Mon Sep 17 00:00:00 2001
From: "J. Bruce Fields" <bfields@redhat.com>
Date: Mon, 30 Apr 2012 16:58:31 -0400
Subject: [PATCH 2/2] nfsd4: let nfsv4 clients know when an xfs fs is
 case-insensitive

OK, really I suppose this could be two patches, one for xfs, one for
nfsd.

The value currently returned by nfsd is really stupid: if we were going
to return a constant value, "case sensitive" would be a better bet!  Or
we could just choose not to support this attribute at all.

Note xfs's support isn't exactly what the NFSv4 spec would like, as it
doesn't handle utf-8.  Oh well.

Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/nfsd/nfs4xdr.c  |    2 +-
 fs/xfs/xfs_super.c |    2 ++
 include/linux/fs.h |    5 ++++-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 40b1cd4..3ed87b0 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2233,7 +2233,7 @@ out_acl:
 	if (bmval0 & FATTR4_WORD0_CASE_INSENSITIVE) {
 		if ((buflen -= 4) < 0)
 			goto out_resource;
-		WRITE32(1);
+		WRITE32(IS_CASE_INSENSITIVE(dentry->d_inode) ? 1 : 0);
 	}
 	if (bmval0 & FATTR4_WORD0_CASE_PRESERVING) {
 		if ((buflen -= 4) < 0)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index dab9a5f..69dafab 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1361,6 +1361,8 @@ xfs_fs_fill_super(
 	sb->s_max_links = XFS_MAXLINK;
 	sb->s_time_gran = 1;
 	set_posix_acl_flag(sb);
+	if (xfs_sb_version_hasasciici(&mp->m_sb))
+		sb->s_feature_flags |= SF_CASE_INSENSITIVE;
 
 	error = xfs_mountfs(mp);
 	if (error)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1b0eef8..61d49ad 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -231,7 +231,8 @@ struct inodes_stat_t {
 #define MS_MGC_MSK 0xffff0000
 
 /* Superblock feature flags: */
-#define SF_I_VERSION	(1<<0)	/* Update inode i_version field */
+#define SF_I_VERSION		(1<< 0)	/* Update inode i_version field */
+#define SF_CASE_INSENSITIVE	(1<< 1)
 
 /* Inode flags - they have nothing to superblock flags now */
 
@@ -286,6 +287,8 @@ struct inodes_stat_t {
 #define IS_AUTOMOUNT(inode)	((inode)->i_flags & S_AUTOMOUNT)
 #define IS_NOSEC(inode)		((inode)->i_flags & S_NOSEC)
 
+#define IS_CASE_INSENSITIVE(inode) ((inode)->i_sb->s_feature_flags & SF_CASE_INSENSITIVE)
+
 /* the read-only stuff doesn't really belong here, but any other place is
    probably as bad and I don't want to create yet another include file. */
 
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
