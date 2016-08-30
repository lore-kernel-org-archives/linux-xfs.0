Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9FB027CA0
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 22:44:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 71005304043
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 20:44:16 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id wpEoGY7tyJFbFKlV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Aug 2016 20:44:14 -0700 (PDT)
Date: Mon, 29 Aug 2016 20:44:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_repair: don't crash if we run out of space midway
	through rebuilding a btree
Message-ID: <20160830034410.GK22760@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

During btree rebuilding, the cursor setup function checks ext_ptr to
report ENOSPC problems when it grabs the first extent for the btree.
However, subsequent grabs for free space don't check ext_ptr and so we
segfault if there's no space.  Therefore, move the ENOSPC check into
the loop so that we always complain about insufficient space instead
of just crashing.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase5.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/repair/phase5.c b/repair/phase5.c
index b464b56..28aaefe 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -231,8 +231,7 @@ setup_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *curs)
 	 * grab the smallest extent and use it up, then get the
 	 * next smallest.  This mimics the init_*_cursor code.
 	 */
-	if ((ext_ptr =  findfirst_bcnt_extent(agno)) == NULL)
-		do_error(_("error - not enough free space in filesystem\n"));
+	ext_ptr =  findfirst_bcnt_extent(agno);
 
 	agb_ptr = curs->btree_blocks;
 
@@ -240,6 +239,9 @@ setup_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *curs)
 	 * set up the free block array
 	 */
 	while (blocks_allocated < big_extent_len)  {
+		if (!ext_ptr)
+			do_error(
+_("error - not enough free space in filesystem\n"));
 		/*
 		 * use up the extent we've got
 		 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
