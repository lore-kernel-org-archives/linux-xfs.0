Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9CB827F37
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 20:12:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8A8318F8052
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 18:12:01 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	dYPRsIqGbCLYN2gp for <xfs@oss.sgi.com>;
	Thu, 16 May 2013 18:12:00 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Ud9Bn-0007LI-7T
	for xfs@oss.sgi.com; Fri, 17 May 2013 11:10:31 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Ud9Bn-0002bk-4H
	for xfs@oss.sgi.com; Fri, 17 May 2013 11:10:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/5] xfs: fix rounding in xfs_free_file_space
Date: Fri, 17 May 2013 11:10:26 +1000
Message-Id: <1368753029-9977-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1368753029-9977-1-git-send-email-david@fromorbit.com>
References: <1368753029-9977-1-git-send-email-david@fromorbit.com>
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

The offset passed into xfs_free_file_space() needs to be rounded
down to a certain size, but the rounding mask is built by a 32 bit
variable. Hence the mask will always mask off the upper 32 bits of
the offset and lead to incorrect writeback and invalidation ranges.

This is not actually exposed as a bug because we writeback and
invalidate from the rounded offset to the end of the file, and hence
the offset we are actually punching a hole out of will always be
covered by the code. This needs fixing, however, if we ever want to
use exact ranges for writeback/invalidation here...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_vnodeops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 1501f4f..0176bb2 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1453,7 +1453,7 @@ xfs_free_file_space(
 	xfs_mount_t		*mp;
 	int			nimap;
 	uint			resblks;
-	uint			rounding;
+	xfs_off_t		rounding;
 	int			rt;
 	xfs_fileoff_t		startoffset_fsb;
 	xfs_trans_t		*tp;
@@ -1482,7 +1482,7 @@ xfs_free_file_space(
 		inode_dio_wait(VFS_I(ip));
 	}
 
-	rounding = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
+	rounding = max_t(xfs_off_t, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
 	ioffset = offset & ~(rounding - 1);
 	error = -filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
 					      ioffset, -1);
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
