Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LKI71F173696 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 15:18:08 -0500
Date: Wed, 21 Sep 2011 15:18:06 -0500
From: Alex Elder <aelder@americas.sgi.com>
Message-Id: <201109212018.p8LKI6cF010020@alcatraz.americas.sgi.com>
Subject: [PATCH] xfstests: limit OP_PUNCH_HOLE operations to the file size
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

Before punching a hole in a file, TRIM_OFF_LEN() calls
TRIM_OFF_LEN() in order to make sure the offset and size
used are in a reasonable range.  But currently the range
it's limited to is maxfilelen, which allows the offset
(and therefore offset + len) to be beyond EOF.

Later, do_punch_hole() ignores any request that starts beyond
EOF, so we might as well limit requests to the file size.

It appears that a hole punch request that starts within a
file but whose length extends beyond it is treated simply
as a hole punch up to EOF.  So there's no harm in limiting
the end of a hole punch request to the file size either.

Therefore, use TRIM_OFF_LEN() to put both the the offset
and length of a request within the file size for hole
punch requests.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 ltp/fsx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/ltp/fsx.c
===================================================================
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -1085,7 +1085,7 @@ test(void)
 		break;
 
 	case OP_PUNCH_HOLE:
-		TRIM_OFF_LEN(offset, size, maxfilelen);
+		TRIM_OFF_LEN(offset, size, file_size);
 		do_punch_hole(offset, size);
 		break;
 	default:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
