Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CDAC47F60
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 23:34:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 90C9D8F8040
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 21:34:50 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id DWE0IYsjRMigbScs (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Nov 2014 21:34:49 -0800 (PST)
From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH-v3 3/6] vfs: don't let the dirty time inodes get more than a
	day stale
Date: Tue, 25 Nov 2014 00:34:31 -0500
Message-Id: <1416893674-419-4-git-send-email-tytso@mit.edu>
In-Reply-To: <1416893674-419-1-git-send-email-tytso@mit.edu>
References: <1416893674-419-1-git-send-email-tytso@mit.edu>
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
To: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>

Guarantee that the on-disk timestamps will be no more than 24 hours
stale.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/fs-writeback.c  |  1 +
 fs/inode.c         | 28 +++++++++++++++++++++++-----
 include/linux/fs.h |  1 +
 3 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index ce7de22..eb04277 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1141,6 +1141,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 	if (flags & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
 		trace_writeback_dirty_inode_start(inode, flags);
 
+		inode->i_ts_dirty_day = 0;
 		if (sb->s_op->dirty_inode)
 			sb->s_op->dirty_inode(inode, flags);
 
diff --git a/fs/inode.c b/fs/inode.c
index 2093a84..34a443f 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1511,6 +1511,8 @@ static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
  */
 static int update_time(struct inode *inode, struct timespec *time, int flags)
 {
+	struct timespec uptime;
+	unsigned short daycode;
 	int ret;
 
 	if (inode->i_op->update_time) {
@@ -1525,17 +1527,33 @@ static int update_time(struct inode *inode, struct timespec *time, int flags)
 		if (flags & S_CTIME)
 			inode->i_ctime = *time;
 		if (flags & S_MTIME)
-			inode->i_mtime = *time;
+		inode->i_mtime = *time;
 	}
+	/*
+	 * If i_ts_dirty_day is zero, then either we have not deferred
+	 * timestamp updates, or the system has been up for less than
+	 * a day (so days_since_boot is zero), so we defer timestamp
+	 * updates in that case and set the I_DIRTY_TIME flag.  If a
+	 * day or more has passed, then i_ts_dirty_day will be
+	 * different from days_since_boot, and then we should update
+	 * the on-disk inode and then we can clear i_ts_dirty_day.
+	 */
 	if ((inode->i_sb->s_flags & MS_LAZYTIME) &&
 	    !(flags & S_VERSION)) {
 		if (inode->i_state & I_DIRTY_TIME)
 			return 0;
-		spin_lock(&inode->i_lock);
-		inode->i_state |= I_DIRTY_TIME;
-		spin_unlock(&inode->i_lock);
-		return 0;
+		get_monotonic_boottime(&uptime);
+		daycode = div_u64(uptime.tv_sec, (HZ * 86400));
+		if (!inode->i_ts_dirty_day ||
+		    inode->i_ts_dirty_day == daycode) {
+			spin_lock(&inode->i_lock);
+			inode->i_state |= I_DIRTY_TIME;
+			spin_unlock(&inode->i_lock);
+			inode->i_ts_dirty_day = daycode;
+			return 0;
+		}
 	}
+	inode->i_ts_dirty_day = 0;
 	if (inode->i_op->write_time)
 		return inode->i_op->write_time(inode);
 	mark_inode_dirty_sync(inode);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 489b2f2..e3574cd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -575,6 +575,7 @@ struct inode {
 	struct timespec		i_ctime;
 	spinlock_t		i_lock;	/* i_blocks, i_bytes, maybe i_size */
 	unsigned short          i_bytes;
+	unsigned short		i_ts_dirty_day;
 	unsigned int		i_blkbits;
 	blkcnt_t		i_blocks;
 
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
