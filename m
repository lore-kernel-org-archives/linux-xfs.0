Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q29EM0cU236839 for <xfs@oss.sgi.com>; Fri, 9 Mar 2012 08:22:01 -0600
Message-ID: <4F59E7AD.4080903@oracle.com>
Date: Fri, 09 Mar 2012 19:21:17 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [RFC PATCH v1 3/4] cgroup quota: validate and charge  block quota
	for XFS
Reply-To: jeff.liu@oracle.com
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
To: cgroups@vger.kernel.org
Cc: jack@suse.cz, Daniel Lezcano <daniel.lezcano@free.fr>, Christopher Jones <christopher.jones@oracle.com>, Li Zefan <lizf@cn.fujitsu.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, tj@kernel.org, Ben Myers <bpm@sgi.com>, lxc-devel@lists.sourceforge.net, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, tytso@MIT.EDU, Chris Mason <chris.mason@oracle.com>

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_iomap.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 9afa282..c67525e 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -44,6 +44,7 @@
 #include "xfs_iomap.h"
 #include "xfs_trace.h"
 
+#include <linux/quota_cgroup.h>
 
 #define XFS_WRITEIO_ALIGN(mp,off)	(((off) >> mp->m_writeio_log) \
 						<< mp->m_writeio_log)
@@ -140,6 +141,7 @@ xfs_iomap_write_direct(
 	uint		qblocks, resblks, resrtextents;
 	int		committed;
 	int		error;
+	prid_t		prid;
 
 	/*
 	 * Make sure that the dquots are there. This doesn't hold
@@ -152,6 +154,12 @@ xfs_iomap_write_direct(
 	rt = XFS_IS_REALTIME_INODE(ip);
 	extsz = xfs_get_extsz_hint(ip);
 
+	prid = xfs_get_projid(ip);
+	error = quota_cgroup_validate_pquota(QUOTA_NEW_BLOCK, prid,
+					     XFS_FSB_TO_B(mp, extsz));
+	if (error)
+		return error;
+
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	last_fsb = XFS_B_TO_FSB(mp, ((xfs_ufsize_t)(offset + count)));
 	if ((offset + count) > ip->i_size) {
@@ -248,6 +256,9 @@ xfs_iomap_write_direct(
 		goto error_out;
 	}
 
+	quota_cgroup_charge_pquota(QUOTA_NEW_BLOCK, prid,
+				   XFS_FSB_TO_B(mp, extsz));
+
 	return 0;
 
 error0:	/* Cancel bmap, unlock inode, unreserve quota blocks, cancel trans */
@@ -384,6 +395,7 @@ xfs_iomap_write_delay(
 	xfs_bmbt_irec_t imap[XFS_WRITE_IMAPS];
 	int		prealloc, flushed = 0;
 	int		error;
+	prid_t		prid;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
@@ -398,6 +410,11 @@ xfs_iomap_write_delay(
 	extsz = xfs_get_extsz_hint(ip);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 
+	prid = xfs_get_projid(ip);
+	error = quota_cgroup_validate_pquota(QUOTA_NEW_BLOCK, prid,
+					     XFS_FSB_TO_B(mp, extsz));
+	if (error)
+		return error;
 
 	error = xfs_iomap_eof_want_preallocate(mp, ip, offset, count,
 				imap, XFS_WRITE_IMAPS, &prealloc);
@@ -456,6 +473,9 @@ retry:
 		goto retry;
 	}
 
+	quota_cgroup_charge_pquota(QUOTA_NEW_BLOCK, prid,
+				   XFS_FSB_TO_B(mp, extsz));
+
 	if (!(imap[0].br_startblock || XFS_IS_REALTIME_INODE(ip)))
 		return xfs_alert_fsblock_zero(ip, &imap[0]);
 
@@ -490,6 +510,7 @@ xfs_iomap_write_allocate(
 	int		nimaps, committed;
 	int		error = 0;
 	int		nres;
+	prid_t		prid;
 
 	/*
 	 * Make sure that the dquots are there.
@@ -498,6 +519,12 @@ xfs_iomap_write_allocate(
 	if (error)
 		return XFS_ERROR(error);
 
+	prid = xfs_get_projid(ip);
+	error = quota_cgroup_validate_pquota(QUOTA_NEW_BLOCK, prid,
+			XFS_FSB_TO_B(mp, imap->br_blockcount));
+	if (error)
+		return error;
+
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	count_fsb = imap->br_blockcount;
 	map_start_fsb = imap->br_startoff;
@@ -611,6 +638,9 @@ xfs_iomap_write_allocate(
 		    (offset_fsb < (imap->br_startoff +
 				   imap->br_blockcount))) {
 			XFS_STATS_INC(xs_xstrat_quick);
+
+			quota_cgroup_charge_pquota(QUOTA_NEW_BLOCK, prid,
+				XFS_FSB_TO_B(mp, imap->br_blockcount));
 			return 0;
 		}
 
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
