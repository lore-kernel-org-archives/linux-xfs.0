Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4084E7F52
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 09:07:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2F90D30407A
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 07:07:48 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1E15Y1ZO7OXez4CP for
	<xfs@oss.sgi.com>; Wed, 20 Feb 2013 07:07:46 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1KF7koc022255
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 10:07:46 -0500
Received: from bfoster.bfoster (dhcp-189-135.bos.redhat.com [10.16.189.135])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r1KF7jxG007691
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 10:07:46 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 1/6] xfs: reorganize xfs_iomap_prealloc_size to remove
	indentation
Date: Wed, 20 Feb 2013 10:10:14 -0500
Message-Id: <1361373019-30891-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1361373019-30891-1-git-send-email-bfoster@redhat.com>
References: <1361373019-30891-1-git-send-email-bfoster@redhat.com>
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

The majority of xfs_iomap_prealloc_size() executes within the
check for lack of default I/O size. Reverse the logic to remove the
extra indentation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_iomap.c |   63 ++++++++++++++++++++++++++-------------------------
 1 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 912d83d..d914419 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -381,42 +381,43 @@ xfs_iomap_prealloc_size(
 	int			nimaps)
 {
 	xfs_fsblock_t		alloc_blocks = 0;
+	int			shift = 0;
+	int64_t			freesp;
 
 	alloc_blocks = xfs_iomap_eof_prealloc_initial_size(mp, ip, offset,
 							   imap, nimaps);
-	if (alloc_blocks > 0) {
-		int shift = 0;
-		int64_t freesp;
-
-		alloc_blocks = XFS_FILEOFF_MIN(MAXEXTLEN,
-					rounddown_pow_of_two(alloc_blocks));
-
-		xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
-		freesp = mp->m_sb.sb_fdblocks;
-		if (freesp < mp->m_low_space[XFS_LOWSP_5_PCNT]) {
-			shift = 2;
-			if (freesp < mp->m_low_space[XFS_LOWSP_4_PCNT])
-				shift++;
-			if (freesp < mp->m_low_space[XFS_LOWSP_3_PCNT])
-				shift++;
-			if (freesp < mp->m_low_space[XFS_LOWSP_2_PCNT])
-				shift++;
-			if (freesp < mp->m_low_space[XFS_LOWSP_1_PCNT])
-				shift++;
-		}
-		if (shift)
-			alloc_blocks >>= shift;
-
-		/*
-		 * If we are still trying to allocate more space than is
-		 * available, squash the prealloc hard. This can happen if we
-		 * have a large file on a small filesystem and the above
-		 * lowspace thresholds are smaller than MAXEXTLEN.
-		 */
-		while (alloc_blocks >= freesp)
-			alloc_blocks >>= 4;
+	if (!alloc_blocks)
+		goto check_writeio;
+
+	alloc_blocks = XFS_FILEOFF_MIN(MAXEXTLEN,
+				rounddown_pow_of_two(alloc_blocks));
+
+	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
+	freesp = mp->m_sb.sb_fdblocks;
+	if (freesp < mp->m_low_space[XFS_LOWSP_5_PCNT]) {
+		shift = 2;
+		if (freesp < mp->m_low_space[XFS_LOWSP_4_PCNT])
+			shift++;
+		if (freesp < mp->m_low_space[XFS_LOWSP_3_PCNT])
+			shift++;
+		if (freesp < mp->m_low_space[XFS_LOWSP_2_PCNT])
+			shift++;
+		if (freesp < mp->m_low_space[XFS_LOWSP_1_PCNT])
+			shift++;
 	}
+	if (shift)
+		alloc_blocks >>= shift;
+
+	/*
+	 * If we are still trying to allocate more space than is
+	 * available, squash the prealloc hard. This can happen if we
+	 * have a large file on a small filesystem and the above
+	 * lowspace thresholds are smaller than MAXEXTLEN.
+	 */
+	while (alloc_blocks >= freesp)
+		alloc_blocks >>= 4;
 
+check_writeio:
 	if (alloc_blocks < mp->m_writeio_blocks)
 		alloc_blocks = mp->m_writeio_blocks;
 
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
