Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q144U7tR185609 for <xfs@oss.sgi.com>; Fri, 3 Feb 2012 22:30:07 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id w7hUwZVEE9L3FZRI for <xfs@oss.sgi.com>;
	Fri, 03 Feb 2012 20:30:06 -0800 (PST)
Message-ID: <4F2CB44D.4060006@sandeen.net>
Date: Fri, 03 Feb 2012 22:30:05 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 5/8] xfs: Protect xfs_file_aio_write() & xfs_setattr_size()
	with sb_start_write - sb_end_write
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
	<1327091686-23177-6-git-send-email-jack@suse.cz>
In-Reply-To: <1327091686-23177-6-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Alex Elder <elder@kernel.org>, Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On 1/20/12 2:34 PM, Jan Kara wrote:
> Replace racy xfs_wait_for_freeze() check in xfs_file_aio_write() with
> a reliable sb_start_write() - sb_end_write() locking.

Here's what I'm running with now.  With this and my modified
patch6, I can pass xfstests 068 on xfs.

-Eric



diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 7e5bc87..f1cacdc 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -874,11 +874,11 @@ xfs_file_aio_write(
 	if (ocount == 0)
 		return 0;
 
-	xfs_wait_for_freeze(ip->i_mount, SB_FREEZE_WRITE);
-
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
+	sb_start_write(inode->i_sb, SB_FREEZE_WRITE);
+
 	if (unlikely(file->f_flags & O_DIRECT))
 		ret = xfs_file_dio_aio_write(iocb, iovp, nr_segs, pos, ocount);
 	else
@@ -895,6 +895,7 @@ xfs_file_aio_write(
 		if (err < 0)
 			ret = err;
 	}
+	sb_end_write(inode->i_sb, SB_FREEZE_WRITE);
 
 	return ret;
 }
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ab30253..7f3fa17 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -773,6 +773,7 @@ xfs_setattr_size(
 			ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
 			ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
 
+	sb_start_write(inode->i_sb, SB_FREEZE_WRITE);
 	lock_flags = XFS_ILOCK_EXCL;
 	if (!(flags & XFS_ATTR_NOLOCK))
 		lock_flags |= XFS_IOLOCK_EXCL;
@@ -792,6 +793,7 @@ xfs_setattr_size(
 		 * Use the regular setattr path to update the timestamps.
 		 */
 		xfs_iunlock(ip, lock_flags);
+		sb_end_write(inode->i_sb, SB_FREEZE_WRITE);
 		iattr->ia_valid &= ~ATTR_SIZE;
 		return xfs_setattr_nonsize(ip, iattr, 0);
 	}
@@ -938,6 +940,7 @@ xfs_setattr_size(
 out_unlock:
 	if (lock_flags)
 		xfs_iunlock(ip, lock_flags);
+	sb_end_write(inode->i_sb, SB_FREEZE_WRITE);
 	return error;
 
 out_trans_abort:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
