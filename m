Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3NehjN067721 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:43 -0600
Message-Id: <20121203144308.943514303@sgi.com>
Date: Mon, 03 Dec 2012 17:42:10 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 02/36] xfs: fix allocation length overflow in
	xfs_bmapi_write()
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=022
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
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Upstream commit: a99ebf43f49f4499ab0e2a8a9132ad6ed6ba2409

When testing the new xfstests --large-fs option that does very large
file preallocations, this assert was tripped deep in
xfs_alloc_vextent():

XFS: Assertion failed: args->minlen <= args->maxlen, file: fs/xfs/xfs_alloc.c, line: 2239

The allocation was trying to allocate a zero length extent because
the lower 32 bits of the allocation length was zero. The remaining
length of the allocation to be done was an exact multiple of 2^32 -
the first case I saw was at 496TB remaining to be allocated.

This turns out to be an overflow when converting the allocation
length (a 64 bit quantity) into the extent length to allocate (a 32
bit quantity), and it requires the length to be allocated an exact
multiple of 2^32 blocks to trip the assert.

Fix it by limiting the extent lenth to allocate to MAXEXTLEN.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

Index: b/fs/xfs/xfs_bmap.c
===================================================================
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -4453,8 +4453,18 @@ xfs_bmapi(
 					xfs_bmbt_get_all(ep, &prev);
 				}
 			} else {
-				alen = (xfs_extlen_t)
-					XFS_FILBLKS_MIN(len, MAXEXTLEN);
+				/*
+				 * There's a 32/64 bit type mismatch between the
+				 * allocation length request (which can be 64
+				 * bits in length) and the bma length request,
+				 * which is xfs_extlen_t and therefore 32 bits.
+				 * Hence we have to check for 32-bit overflows
+				 * and handle them here.
+				 */
+				if (len > (xfs_filblks_t)MAXEXTLEN)
+					alen = MAXEXTLEN;
+				else
+					alen = len;
 				if (!eof)
 					alen = (xfs_extlen_t)
 						XFS_FILBLKS_MIN(alen,


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
