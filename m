Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D28E67CAB
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 00:19:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C374D304043
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 22:19:02 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	7iN0f2tKR3RXvpt3 for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 22:18:57 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVCUN-0000ML-Lu
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVCUN-0005H8-LD
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/14] xfs: stop holding ILOCK over filldir callbacks
Date: Mon, 15 Feb 2016 17:18:24 +1100
Message-Id: <1455517105-20033-14-git-send-email-david@fromorbit.com>
In-Reply-To: <1455517105-20033-1-git-send-email-david@fromorbit.com>
References: <1455517105-20033-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit dbad7c993053d8f482a5f76270a93307537efd8e

The recent change to the readdir locking made in 40194ec ("xfs:
reinstate the ilock in xfs_readdir") for CXFS directory sanity was
probably the wrong thing to do. Deep in the readdir code we
can take page faults in the filldir callback, and so taking a page
fault while holding an inode ilock creates a new set of locking
issues that lockdep warns all over the place about.

The locking order for regular inodes w.r.t. page faults is io_lock
-> pagefault -> mmap_sem -> ilock. The directory readdir code now
triggers ilock -> page fault -> mmap_sem. While we cannot deadlock
at this point, it inverts all the locking patterns that lockdep
normally sees on XFS inodes, and so triggers lockdep. We worked
around this with commit 93a8614 ("xfs: fix directory inode iolock
lockdep false positive"), but that then just moved the lockdep
warning to deeper in the page fault path and triggered on security
inode locks. Fixing the shmem issue there just moved the lockdep
reports somewhere else, and now we are getting false positives from
filesystem freezing annotations getting confused.

Further, if we enter memory reclaim in a readdir path, we now get
lockdep warning about potential deadlocks because the ilock is held
when we enter reclaim. This, again, is different to a regular file
in that we never allow memory reclaim to run while holding the ilock
for regular files. Hence lockdep now throws
ilock->kmalloc->reclaim->ilock warnings.

Basically, the problem is that the ilock is being used to protect
the directory data and the inode metadata, whereas for a regular
file the iolock protects the data and the ilock protects the
metadata. From the VFS perspective, the i_mutex serialises all
accesses to the directory data, and so not holding the ilock for
readdir doesn't matter. The issue is that CXFS doesn't access
directory data via the VFS, so it has no "data serialisaton"
mechanism. Hence we need to hold the IOLOCK in the correct places to
provide this low level directory data access serialisation.

The ilock can then be used just when the extent list needs to be
read, just like we do for regular files. The directory modification
code can take the iolock exclusive when the ilock is also taken,
and this then ensures that readdir is correct excluded while
modifications are in progress.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_dir2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 383401b..89b4781 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -360,6 +360,7 @@ xfs_dir_lookup(
 	struct xfs_da_args *args;
 	int		rval;
 	int		v;		/* type-checking value */
+	int		lock_mode;
 
 	ASSERT(S_ISDIR(dp->i_d.di_mode));
 	XFS_STATS_INC(dp->i_mount, xs_dir_lookup);
@@ -385,6 +386,7 @@ xfs_dir_lookup(
 	if (ci_name)
 		args->op_flags |= XFS_DA_OP_CILOOKUP;
 
+	lock_mode = xfs_ilock_data_map_shared(dp);
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_lookup(args);
 		goto out_check_rval;
@@ -417,6 +419,7 @@ out_check_rval:
 		}
 	}
 out_free:
+	xfs_iunlock(dp, lock_mode);
 	kmem_free(args);
 	return rval;
 }
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
