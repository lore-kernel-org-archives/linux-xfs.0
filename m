Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 929C97F56
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 15:07:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 72DDD30404E
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 13:07:06 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10]) by
	cuda.sgi.com with ESMTP id WFi1se20bwihGeyv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 30 May 2014 13:07:05 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 11/32] xfs: convert to struct inode_time
Date: Fri, 30 May 2014 22:01:35 +0200
Message-Id: <1401480116-1973111-12-git-send-email-arnd@arndb.de>
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
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
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, hpa@zytor.com, xfs@oss.sgi.com, hch@infradead.org, john.stultz@linaro.org, lftan@altera.com, linux-fsdevel@vger.kernel.org, geert@linux-m68k.org, tglx@linutronix.de, joseph@codesourcery.com

xfs uses unsigned 32-bit seconds for inode timestamps, which will work
for the next 92 years, but the VFS uses struct timespec for timestamps,
which is only good until 2038 on 32-bit CPUs.

This gets us one small step closer to lifting the VFS limit by using
struct inode_time in XFS.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com
---
 fs/xfs/time.h            | 4 ++--
 fs/xfs/xfs_inode.c       | 2 +-
 fs/xfs/xfs_iops.c        | 2 +-
 fs/xfs/xfs_trans_inode.c | 6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/time.h b/fs/xfs/time.h
index 387e695..a490f1b 100644
--- a/fs/xfs/time.h
+++ b/fs/xfs/time.h
@@ -21,14 +21,14 @@
 #include <linux/sched.h>
 #include <linux/time.h>
 
-typedef struct timespec timespec_t;
+typedef struct inode_time timespec_t;
 
 static inline void delay(long ticks)
 {
 	schedule_timeout_uninterruptible(ticks);
 }
 
-static inline void nanotime(struct timespec *tvp)
+static inline void nanotime(struct inode_time *tvp)
 {
 	*tvp = CURRENT_TIME;
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a6115fe..16d5392 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -654,7 +654,7 @@ xfs_ialloc(
 	xfs_inode_t	*ip;
 	uint		flags;
 	int		error;
-	timespec_t	tv;
+	struct inode_time tv;
 
 	/*
 	 * Call the space management code to pick
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 205613a..092ee7c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -956,7 +956,7 @@ xfs_vn_setattr(
 STATIC int
 xfs_vn_update_time(
 	struct inode		*inode,
-	struct timespec		*now,
+	struct inode_time	*now,
 	int			flags)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index 50c3f56..bae2520 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -70,7 +70,7 @@ xfs_trans_ichgtime(
 	int			flags)
 {
 	struct inode		*inode = VFS_I(ip);
-	timespec_t		tv;
+	struct inode_time	tv;
 
 	ASSERT(tp);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
@@ -78,13 +78,13 @@ xfs_trans_ichgtime(
 	tv = current_fs_time(inode->i_sb);
 
 	if ((flags & XFS_ICHGTIME_MOD) &&
-	    !timespec_equal(&inode->i_mtime, &tv)) {
+	    !inode_time_equal(&inode->i_mtime, &tv)) {
 		inode->i_mtime = tv;
 		ip->i_d.di_mtime.t_sec = tv.tv_sec;
 		ip->i_d.di_mtime.t_nsec = tv.tv_nsec;
 	}
 	if ((flags & XFS_ICHGTIME_CHG) &&
-	    !timespec_equal(&inode->i_ctime, &tv)) {
+	    !inode_time_equal(&inode->i_ctime, &tv)) {
 		inode->i_ctime = tv;
 		ip->i_d.di_ctime.t_sec = tv.tv_sec;
 		ip->i_d.di_ctime.t_nsec = tv.tv_nsec;
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
