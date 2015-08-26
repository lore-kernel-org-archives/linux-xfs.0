Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A2D3029E01
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 19:33:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4DCCFAC005
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 17:33:09 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 3s8XIQUNTPJzzcS3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 17:33:08 -0700 (PDT)
Subject: [PATCH 07/11] xfs_repair: force not-so-bad bmbt blocks back through
	the verifier
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Aug 2015 17:33:05 -0700
Message-ID: <20150826003305.23973.65768.stgit@birch.djwong.org>
In-Reply-To: <20150826003220.23973.59731.stgit@birch.djwong.org>
References: <20150826003220.23973.59731.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

If during prefetch we encounter a bmbt block that fails the CRC check
due to corruption in the unused part of the block, force the buffer
back through the non-prefetch verifiers later so that the CRC is
updated.  Otherwise, the bad checksum goes unfixed and the kernel will
still flag the bmbt block as invalid.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/prefetch.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/repair/prefetch.c b/repair/prefetch.c
index 1de3ec0..77d29c8 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -276,6 +276,14 @@ pf_scan_lbtree(
 
 	XFS_BUF_SET_PRIORITY(bp, isadir ? B_DIR_BMAP : B_BMAP);
 
+	/*
+	 * Make this bmbt buffer go back through the verifiers later so that
+	 * we correct checksum errors stemming from bitflips in the unused
+	 * parts of the bmbt block.
+	 */
+	if (bp->b_error == -EFSBADCRC)
+		bp->b_flags |= LIBXFS_B_UNCHECKED;
+
 	rc = (*func)(XFS_BUF_TO_BLOCK(bp), level - 1, isadir, args);
 
 	libxfs_putbuf(bp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
