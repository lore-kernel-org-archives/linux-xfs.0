Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6RGI7Dl112084 for <xfs@oss.sgi.com>; Mon, 27 Jul 2009 11:18:07 -0500
Date: Mon, 27 Jul 2009 18:15:25 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 10/12] fs/xfs: Correct redundant test
Message-ID: <Pine.LNX.4.64.0907271815060.2682@ask.diku.dk>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: felixb@sgi.com, xfs-masters@oss.sgi.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

bp was tested for NULL a few lines before, followed by a return, and there
is no intervening modification of its value.

A simplified version of the semantic match that finds this problem is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
expression E;
position p1,p2;
@@

if (x == NULL || ...) { ... when forall
   return ...; }
... when != \(x=E\|x--\|x++\|--x\|++x\|x-=E\|x+=E\|x|=E\|x&=E\|&x\)
(
*x == NULL
|
*x != NULL
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/xfs/xfs_trans_buf.c              |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 8ee2f8c..218829e 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -307,7 +307,7 @@ xfs_trans_read_buf(
 			return (flags & XFS_BUF_TRYLOCK) ?
 					EAGAIN : XFS_ERROR(ENOMEM);
 
-		if ((bp != NULL) && (XFS_BUF_GETERROR(bp) != 0)) {
+		if (XFS_BUF_GETERROR(bp) != 0) {
 			xfs_ioerror_alert("xfs_trans_read_buf", mp,
 					  bp, blkno);
 			error = XFS_BUF_GETERROR(bp);
@@ -315,7 +315,7 @@ xfs_trans_read_buf(
 			return error;
 		}
 #ifdef DEBUG
-		if (xfs_do_error && (bp != NULL)) {
+		if (xfs_do_error) {
 			if (xfs_error_target == target) {
 				if (((xfs_req_num++) % xfs_error_mod) == 0) {
 					xfs_buf_relse(bp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
