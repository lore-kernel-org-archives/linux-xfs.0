Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48210 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753165AbeDRCrg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:47:36 -0400
Subject: [PATCH 07/11] xfs_repair: only update in-core extent state after
 scanning full extent
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:47:15 -0700
Message-ID: <152401963554.13319.9264510034231335778.stgit@magnolia>
In-Reply-To: <152401958920.13319.10756339531174871801.stgit@magnolia>
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In process_bmbt_reclist_int, only update the in-core extent state after
clearing the entire extent for conflicts.  If we encounter conflicts
we'll try rebuilding the fork from rmap data and rescanning the fork.
It is essential to avoid polluting the in-memory state with garbage
data so that we don't end up nuking other files needlessly.  Found by
fuzzing recs[1].blockcount = middlebit in xfs/380.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |   30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index ceffc52..c8c1850 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -751,7 +751,6 @@ _("%s fork in ino %" PRIu64 " claims free block %" PRIu64 "\n"),
 				/* fall through ... */
 			case XR_E_INUSE1:	/* seen by rmap */
 			case XR_E_UNKNOWN:
-				set_bmap_ext(agno, agbno, blen, XR_E_INUSE);
 				break;
 
 			case XR_E_BAD_STATE:
@@ -773,7 +772,6 @@ _("%s fork in inode %" PRIu64 " claims metadata block %" PRIu64 "\n"),
 
 			case XR_E_INUSE:
 			case XR_E_MULT:
-				set_bmap_ext(agno, agbno, blen, XR_E_MULT);
 				if (type == XR_INO_DATA &&
 				    xfs_sb_version_hasreflink(&mp->m_sb))
 					break;
@@ -792,6 +790,34 @@ _("%s fork in %s inode %" PRIu64 " claims CoW block %" PRIu64 "\n"),
 				do_error(
 _("illegal state %d in block map %" PRIu64 "\n"),
 					state, b);
+				goto done;
+			}
+		}
+
+		/*
+		 * Update the internal extent map only after we've checked
+		 * every block in this extent.  The first time we reject this
+		 * data fork we'll try to rebuild the bmbt from rmap data.
+		 * After a successful rebuild we'll try this scan again.
+		 * (If the rebuild fails we won't come back here.)
+		 */
+		agbno = XFS_FSB_TO_AGBNO(mp, irec.br_startblock);
+		ebno = agbno + irec.br_blockcount;
+		for (; agbno < ebno; agbno += blen) {
+			state = get_bmap_ext(agno, agbno, ebno, &blen);
+			switch (state)  {
+			case XR_E_FREE:
+			case XR_E_FREE1:
+			case XR_E_INUSE1:
+			case XR_E_UNKNOWN:
+				set_bmap_ext(agno, agbno, blen, XR_E_INUSE);
+				break;
+			case XR_E_INUSE:
+			case XR_E_MULT:
+				set_bmap_ext(agno, agbno, blen, XR_E_MULT);
+				break;
+			default:
+				break;
 			}
 		}
 		if (collect_rmaps) { /* && !check_dups */

