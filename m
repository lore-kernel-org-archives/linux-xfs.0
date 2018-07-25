Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56196 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731174AbeGYWe1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Jul 2018 18:34:27 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH, RFC] xfs: completely disable toggling DAX flag via ioctl on
 reg files
Message-ID: <405e182f-0c24-81fe-9d04-1031a8bbac17@redhat.com>
Date: Wed, 25 Jul 2018 14:20:54 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>

742d842 xfs: disable per-inode DAX flag was, I think, intended
as a short-term workaround to avoid races when toggling DAX on
and off of active inodes until mm/ sorted that out.

(It's also a confusing title, as it didn't really disable
per-inode DAX at all.)

However, it has the surprising (to me, at least) result that while
the ioctl succeeds, no behavior changes until the inode is cycled
out of cache and re-read from disk at some unknown later time.
This seems to badly violate the principle of least surprise.

Until said races are properly resolved, it seems most prudent to
disallow modification of the flag on regular files altogether.
We can still allow per-inode DAX flagging via directory inheritance.

Since DAX is still flagged as experimental (in part due to these
concerns) I don't think it's a problem to (temporarily?) break
this interface further.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0ef5ece5634c..94e9e25883cc 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1102,6 +1102,16 @@ xfs_ioctl_setattr_dax_invalidate(
 
 	if (S_ISDIR(inode->i_mode))
 		return 0;
+	/*
+	 * For now, don't allow changing DAX mode on files via ioctl at all.
+	 * See 742d842 xfs: disable per-inode DAX flag, which only disabled
+	 * switching it on "live" inodes, but still set it on disk for the
+	 * next read - which leads to changed behavior only after cycling
+	 * out of cache.  Eliminate this surprising behavior.
+	 * We do still allow setting it as an inheritance flag on directories
+	 * (above) which will then affect newly-created files in the dir.
+	 */
+	return -EINVAL;
 
 	/* lock, flush and invalidate mapping in preparation for flag change */
 	xfs_ilock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
@@ -1359,6 +1369,9 @@ xfs_ioctl_setattr(
 	 * or cancel time, so need to be passed through to
 	 * xfs_ioctl_setattr_get_trans() so it can apply them to the join call
 	 * appropriately.
+	 *
+	 * Note, changing DAX flags on regular files via ioctl is currently
+	 * disallowed by this function, see comments within.
 	 */
 	code = xfs_ioctl_setattr_dax_invalidate(ip, fa, &join_flags);
 	if (code)


