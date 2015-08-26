Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9379B7F47
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 00:24:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 834E4304043
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 22:24:34 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id QXMaq6EIDMo6DMeV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 22:24:33 -0700 (PDT)
Date: Tue, 25 Aug 2015 22:24:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 07/11] xfs_repair: force not-so-bad bmbt blocks back
	through the verifier
Message-ID: <20150826052430.GA10043@birch.djwong.org>
References: <20150826003220.23973.59731.stgit@birch.djwong.org>
	<20150826003305.23973.65768.stgit@birch.djwong.org>
	<20150826005447.GS714@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150826005447.GS714@dastard>
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
Cc: xfs@oss.sgi.com

If during prefetch we encounter a bmbt block that fails the CRC check
due to corruption in the unused part of the block, force the buffer
back through the non-prefetch verifiers later so that the CRC is
updated.  Otherwise, the bad checksum goes unfixed and the kernel will
still flag the bmbt block as invalid.

v2: Halt all readahead on the bmapbt if any of its blocks produce an
error.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/prefetch.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/repair/prefetch.c b/repair/prefetch.c
index 1de3ec0..32ec55e 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -276,6 +276,18 @@ pf_scan_lbtree(
 
 	XFS_BUF_SET_PRIORITY(bp, isadir ? B_DIR_BMAP : B_BMAP);
 
+	/*
+	 * If the verifier flagged a problem with the buffer, we can't trust
+	 * its contents for the purposes of reading ahead.  Stop prefetching
+	 * the tree and mark the buffer unchecked so that the next read of the
+	 * buffer will retain the error status and be acted upon appropriately.
+	 */
+	if (bp->b_error) {
+		bp->b_flags |= LIBXFS_B_UNCHECKED;
+		libxfs_putbuf(bp);
+		return 0;
+	}
+
 	rc = (*func)(XFS_BUF_TO_BLOCK(bp), level - 1, isadir, args);
 
 	libxfs_putbuf(bp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
