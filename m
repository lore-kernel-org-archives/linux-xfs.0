Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E36977F47
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 17:02:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C6A6E8F8052
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 15:02:13 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id HazIGX5fCKCIgBRJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 15:02:11 -0700 (PDT)
Date: Tue, 5 May 2015 15:02:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: enforce imax_pct when we have per-cpu SB accounting
Message-ID: <20150505220208.GC11601@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <xfs@oss.sgi.com>

When per-CPU superblock counters are enabled (i.e. SMP=y), we don't
update the in-core superblock's sb_icount value prior to checking if
we're already at maximum inodes.  Therefore, it's possible for a tight
file creation loop (e.g. "for i in {0..100000}; do touch /mnt/$i;
done") to allocate far more inodes than the administrator specified at
mkfs time.  Fix this by synchronizing the counters every time we think
we need to allocate another chunk of inodes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ialloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 116ef1d..a8aaab6 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -375,6 +375,8 @@ xfs_ialloc_ag_alloc(
 	 * at one time.
 	 */
 	newlen = args.mp->m_ialloc_inos;
+	if (args.mp->m_maxicount)
+		xfs_icsb_sync_counters(args.mp, 0);
 	if (args.mp->m_maxicount &&
 	    args.mp->m_sb.sb_icount + newlen > args.mp->m_maxicount)
 		return -ENOSPC;
@@ -1339,6 +1341,8 @@ xfs_dialloc(
 	 * okalloc so we scan all available agi structures for a free
 	 * inode.
 	 */
+	if (mp->m_maxicount)
+		xfs_icsb_sync_counters(mp, 0);
 	if (mp->m_maxicount &&
 	    mp->m_sb.sb_icount + mp->m_ialloc_inos > mp->m_maxicount) {
 		noroom = 1;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
