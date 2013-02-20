Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 946E67F63
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 09:07:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2355BAC004
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 07:07:47 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ljinn1ISLleDbhKs for
	<xfs@oss.sgi.com>; Wed, 20 Feb 2013 07:07:46 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1KF7kKC024509
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 10:07:46 -0500
Received: from bfoster.bfoster (dhcp-189-135.bos.redhat.com [10.16.189.135])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r1KF7jYr007694
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 10:07:46 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 2/6] xfs: push rounddown_pow_of_two() to after prealloc
	throttle
Date: Wed, 20 Feb 2013 10:10:15 -0500
Message-Id: <1361373019-30891-3-git-send-email-bfoster@redhat.com>
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

The round down occurs towards the beginning of the function. Push
it down after throttling has occurred. This is to support adding
further transformations to 'alloc_blocks' that might not preserve
power-of-two alignment (and thus could lead to rounding down
multiple times).

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_iomap.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index d914419..daa08f6 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -389,8 +389,15 @@ xfs_iomap_prealloc_size(
 	if (!alloc_blocks)
 		goto check_writeio;
 
-	alloc_blocks = XFS_FILEOFF_MIN(MAXEXTLEN,
-				rounddown_pow_of_two(alloc_blocks));
+	/*
+	 * MAXEXTLEN is not a power of two value but we round the prealloc down
+	 * to the nearest power of two value after throttling. To prevent the
+	 * round down from unconditionally reducing the maximum supported prealloc
+	 * size, we round up first, apply appropriate throttling, round down and
+	 * cap the value to MAXEXTLEN.
+	 */
+	alloc_blocks = XFS_FILEOFF_MIN(roundup_pow_of_two(MAXEXTLEN),
+				       alloc_blocks);
 
 	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
 	freesp = mp->m_sb.sb_fdblocks;
@@ -407,6 +414,14 @@ xfs_iomap_prealloc_size(
 	}
 	if (shift)
 		alloc_blocks >>= shift;
+	/*
+	 * rounddown_pow_of_two() returns an undefined result if we pass in
+	 * alloc_blocks = 0.
+	 */
+	if (alloc_blocks)
+		alloc_blocks = rounddown_pow_of_two(alloc_blocks);
+	if (alloc_blocks > MAXEXTLEN)
+		alloc_blocks = MAXEXTLEN;
 
 	/*
 	 * If we are still trying to allocate more space than is
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
