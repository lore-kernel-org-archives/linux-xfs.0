Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:55104 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725910AbfBGFIe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Feb 2019 00:08:34 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1grbv6-0003pN-R4
        for linux-xfs@vger.kernel.org; Thu, 07 Feb 2019 16:08:16 +1100
Received: from dave by discord.disaster.area with local (Exim 4.92-RC5)
        (envelope-from <david@fromorbit.com>)
        id 1grbv6-0006KZ-Pw
        for linux-xfs@vger.kernel.org; Thu, 07 Feb 2019 16:08:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] xfs: Don't free EOF blocks on sync write close
Date: Thu,  7 Feb 2019 16:08:13 +1100
Message-Id: <20190207050813.24271-4-david@fromorbit.com>
In-Reply-To: <20190207050813.24271-1-david@fromorbit.com>
References: <20190207050813.24271-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When we have a workload that does open/read/close in parallel with
other synchronous buffered writes to long term open files, the file
becomes rapidly fragmented. This is due to close() after read
calling xfs_release() and removing the speculative preallocation
beyond EOF.

The existing open/write/close hueristic in xfs_release() does not
catch this as sync writes do not leave delayed allocation blocks
allocated on the inode for later writeback that can be detected in
xfs_release() and hence XFS_IDIRTY_RELEASE never gets set.

Further, the close context here is for a file opened O_RDONLY, and
so /modifying/ the file metadata on close doesn't pass muster.
Fortunately, we can tell in xfs_file_release() whether the release
context was a read-only context, and so we need to communicate this
to xfs_release() so it can do the right thing here and skip EOF
block truncation, hence ensuring that only contexts with write
permissions will remove post-EOF blocks from the file.

Before:

Test 3: Open/read/close loop fragmentation counts

/mnt/scratch/file.0: 150
/mnt/scratch/file.1: 342
/mnt/scratch/file.2: 113
/mnt/scratch/file.3: 165
/mnt/scratch/file.4: 86
/mnt/scratch/file.5: 363
/mnt/scratch/file.6: 129
/mnt/scratch/file.7: 233

After:

Test 3: Open/read/close loop fragmentation counts

/mnt/scratch/file.0: 12
/mnt/scratch/file.1: 12
/mnt/scratch/file.2: 12
/mnt/scratch/file.3: 12
/mnt/scratch/file.4: 12
/mnt/scratch/file.5: 12
/mnt/scratch/file.6: 12
/mnt/scratch/file.7: 12

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 02f76b8e6c03..e2d8a0b7f891 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1023,6 +1023,10 @@ xfs_dir_open(
  * When we release the file, we don't want it to trim EOF blocks for synchronous
  * write contexts as this leads to severe fragmentation when applications do
  * repeated open/appending sync write/close to a file amongst other file IO.
+ *
+ * We also don't want to trim the EOF blocks if it is a read only context. This
+ * prevents open/read/close workloads from removing EOF blocks that other
+ * writers are depending on to prevent fragmentation.
  */
 STATIC int
 xfs_file_release(
@@ -1031,8 +1035,9 @@ xfs_file_release(
 {
 	bool		free_eof_blocks = true;
 
-	if ((file->f_mode & FMODE_WRITE) &&
-	    (file->f_flags & O_DSYNC))
+	if ((file->f_mode & FMODE_WRITE|FMODE_READ) == FMODE_READ)
+		free_eof_blocks = false;
+	else if ((file->f_mode & FMODE_WRITE) && (file->f_flags & O_DSYNC))
 		free_eof_blocks = false;
 
 	return xfs_release(XFS_I(inode), free_eof_blocks);
-- 
2.20.1
