Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0CJcoXu242625 for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 13:38:50 -0600
Subject: [PATCH] xfs_bmap_add_extent_delay_real should set br_startoff
From: Ben Myers <bpm@sgi.com>
Date: Wed, 12 Jan 2011 13:42:28 -0600
Message-ID: <20110112194228.8449.41844.stgit@lady3jane.americas.sgi.com>
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
To: aelder@sgi.com
Cc: xfs@oss.sgi.com

When filling in the middle of a previous delayed allocation, set
br_startoff of the new delay extent to the right to NULLSTARTBLOCK so that
it is ignored by xfs_bmap_extent_to_btree.  This prevents a forced shutdown
when that in-core extent is converted from delay to real and is found to be
already in the btree.  The value is overwritten below.

SGI-PV: 1013221

Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_bmap.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 4111cd3..cd75c77 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -1040,13 +1040,14 @@ xfs_bmap_add_extent_delay_real(
 		 * This case is avoided almost all the time.
 		 */
 		temp = new->br_startoff - PREV.br_startoff;
+		temp2 = PREV.br_startoff + PREV.br_blockcount - new_endoff;
 		trace_xfs_bmap_pre_update(ip, idx, 0, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep, temp);
 		r[0] = *new;
 		r[1].br_state = PREV.br_state;
-		r[1].br_startblock = 0;
+		r[1].br_startblock = nullstartblock(
+				(int)xfs_bmap_worst_indlen(ip, temp2));
 		r[1].br_startoff = new_endoff;
-		temp2 = PREV.br_startoff + PREV.br_blockcount - new_endoff;
 		r[1].br_blockcount = temp2;
 		xfs_iext_insert(ip, idx + 1, 2, &r[0], state);
 		ip->i_df.if_lastex = idx + 1;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
