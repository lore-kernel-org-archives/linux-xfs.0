Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2D3E57F5F
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 05:11:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1C61530405F
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 03:11:14 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id 3eo889y4UCaxnpqF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2015 03:11:13 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/20] fs: add FL_LAYOUT lease type
Date: Thu, 22 Jan 2015 12:09:49 +0100
Message-Id: <1421925006-24231-4-git-send-email-hch@lst.de>
In-Reply-To: <1421925006-24231-1-git-send-email-hch@lst.de>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

This (ab-)uses the file locking code to allow filesystems to recall
outstanding pNFS layouts on a file.  This new lease type is similar but
not quite the same as FL_DELEG.  A FL_LAYOUT lease can always be granted,
an a per-filesystem lock (XFS iolock for the initial implementation)
ensures not FL_LAYOUT leases granted when we would need to recall them.

Also included are changes that allow multiple outstanding read
leases of different types on the same file as long as they have a
differnt owner.  This wasn't a problem until now as nfsd never set
FL_LEASE leases, and no one else used FL_DELEG leases, but given that
nfsd will also issues FL_LAYOUT leases we will have to handle it now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/locks.c         | 14 ++++++++++----
 include/linux/fs.h | 16 ++++++++++++++++
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 65350a23..6b9772d1 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -137,7 +137,7 @@
 
 #define IS_POSIX(fl)	(fl->fl_flags & FL_POSIX)
 #define IS_FLOCK(fl)	(fl->fl_flags & FL_FLOCK)
-#define IS_LEASE(fl)	(fl->fl_flags & (FL_LEASE|FL_DELEG))
+#define IS_LEASE(fl)	(fl->fl_flags & (FL_LEASE|FL_DELEG|FL_LAYOUT))
 #define IS_OFDLCK(fl)	(fl->fl_flags & FL_OFDLCK)
 
 static bool lease_breaking(struct file_lock *fl)
@@ -1371,6 +1371,8 @@ static void time_out_leases(struct inode *inode, struct list_head *dispose)
 
 static bool leases_conflict(struct file_lock *lease, struct file_lock *breaker)
 {
+	if ((breaker->fl_flags & FL_LAYOUT) != (lease->fl_flags & FL_LAYOUT))
+		return false;
 	if ((breaker->fl_flags & FL_DELEG) && (lease->fl_flags & FL_LEASE))
 		return false;
 	return locks_conflict(breaker, lease);
@@ -1594,11 +1596,14 @@ int fcntl_getlease(struct file *filp)
  * conflict with the lease we're trying to set.
  */
 static int
-check_conflicting_open(const struct dentry *dentry, const long arg)
+check_conflicting_open(const struct dentry *dentry, const long arg, int flags)
 {
 	int ret = 0;
 	struct inode *inode = dentry->d_inode;
 
+	if (flags & FL_LAYOUT)
+		return 0;
+
 	if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
 		return -EAGAIN;
 
@@ -1647,7 +1652,7 @@ generic_add_lease(struct file *filp, long arg, struct file_lock **flp, void **pr
 
 	spin_lock(&ctx->flc_lock);
 	time_out_leases(inode, &dispose);
-	error = check_conflicting_open(dentry, arg);
+	error = check_conflicting_open(dentry, arg, lease->fl_flags);
 	if (error)
 		goto out;
 
@@ -1703,7 +1708,7 @@ generic_add_lease(struct file *filp, long arg, struct file_lock **flp, void **pr
 	 * precedes these checks.
 	 */
 	smp_mb();
-	error = check_conflicting_open(dentry, arg);
+	error = check_conflicting_open(dentry, arg, lease->fl_flags);
 	if (error) {
 		locks_unlink_lock_ctx(lease, &ctx->flc_lease_cnt);
 		goto out;
@@ -1787,6 +1792,7 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp,
 			WARN_ON_ONCE(1);
 			return -ENOLCK;
 		}
+
 		return generic_add_lease(filp, arg, flp, priv);
 	default:
 		return -EINVAL;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f87cb2f..d5658f4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -875,6 +875,7 @@ static inline struct file *get_file(struct file *f)
 #define FL_DOWNGRADE_PENDING	256 /* Lease is being downgraded */
 #define FL_UNLOCK_PENDING	512 /* Lease is being broken */
 #define FL_OFDLCK	1024	/* lock is "owned" by struct file */
+#define FL_LAYOUT	2048	/* outstanding pNFS layout */
 
 /*
  * Special return value from posix_lock_file() and vfs_lock_file() for
@@ -2036,6 +2037,16 @@ static inline int break_deleg_wait(struct inode **delegated_inode)
 	return ret;
 }
 
+static inline int break_layout(struct inode *inode, bool wait)
+{
+	smp_mb();
+	if (inode->i_flctx && !list_empty_careful(&inode->i_flctx->flc_lease))
+		return __break_lease(inode,
+				wait ? O_WRONLY : O_WRONLY | O_NONBLOCK,
+				FL_LAYOUT);
+	return 0;
+}
+
 #else /* !CONFIG_FILE_LOCKING */
 static inline int locks_mandatory_locked(struct file *file)
 {
@@ -2091,6 +2102,11 @@ static inline int break_deleg_wait(struct inode **delegated_inode)
 	return 0;
 }
 
+static inline int break_layout(struct inode *inode, bool wait)
+{
+	return 0;
+}
+
 #endif /* CONFIG_FILE_LOCKING */
 
 /* fs/open.c */
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
