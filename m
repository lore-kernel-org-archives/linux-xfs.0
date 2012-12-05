Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB5GhQ1H030136 for <xfs@oss.sgi.com>; Wed, 5 Dec 2012 10:43:26 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qmrTSCD1U7rkTL01 for
	<xfs@oss.sgi.com>; Wed, 05 Dec 2012 08:45:50 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qB5Gjl0m016704
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 5 Dec 2012 11:45:48 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id qB5Gjlmw032571
	for <xfs@oss.sgi.com>; Wed, 5 Dec 2012 11:45:47 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/4] xfs: push rounddown_pow_of_two() to after prealloc
	throttle
Date: Wed,  5 Dec 2012 11:47:56 -0500
Message-Id: <1354726078-31793-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1354726078-31793-1-git-send-email-bfoster@redhat.com>
References: <1354726078-31793-1-git-send-email-bfoster@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The round down occurs towards the beginning of the function. Push
it down after throttling has occurred. This is to support adding
further transformations to 'alloc_blocks' that might not preserve
power-of-two alignment (and thus could lead to rounding down
multiple times).

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index bd7c060..d381326 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -329,13 +329,11 @@ xfs_iomap_prealloc_size(
 		goto check_writeio;
 
 	/*
-	 * rounddown_pow_of_two() returns an undefined result
-	 * if we pass in alloc_blocks = 0. Hence the "+ 1" to
-	 * ensure we always pass in a non-zero value.
+	 * MAXEXTLEN is 21 bits, add one to protect against the rounddown
+	 * further down.
 	 */
-	alloc_blocks = XFS_B_TO_FSB(mp, XFS_ISIZE(ip)) + 1;
-	alloc_blocks = XFS_FILEOFF_MIN(MAXEXTLEN,
-				rounddown_pow_of_two(alloc_blocks));
+	alloc_blocks = XFS_FILEOFF_MIN(MAXEXTLEN + 1,
+				XFS_B_TO_FSB(mp, XFS_ISIZE(ip)));
 
 	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
 	freesp = mp->m_sb.sb_fdblocks;
@@ -352,6 +350,8 @@ xfs_iomap_prealloc_size(
 	}
 	if (shift)
 		alloc_blocks >>= shift;
+	if (alloc_blocks)
+		alloc_blocks = rounddown_pow_of_two(alloc_blocks);
 
 check_writeio:
 	if (alloc_blocks < mp->m_writeio_blocks)
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
