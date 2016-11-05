Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51207 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750916AbcKEAIQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:08:16 -0400
Subject: [PATCH 02/16] xfs_repair: fix bogus rmapbt record owner check
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:08:10 -0700
Message-ID: <147830449083.26713.15599439011374416048.stgit@birch.djwong.org>
In-Reply-To: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Make the reverse mapping owner check actually validate inode numbers.

Coverity-id: 1371628
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/scan.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff --git a/repair/scan.c b/repair/scan.c
index 0e13581..b9ef4dc 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1052,8 +1052,12 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 			}
 
 			/* Look for impossible owners. */
-			if (!(owner > 0 || (owner > XFS_RMAP_OWN_MIN &&
-					    owner <= XFS_RMAP_OWN_FS)))
+			if (!((owner > XFS_RMAP_OWN_MIN &&
+			       owner <= XFS_RMAP_OWN_FS) ||
+			      (XFS_INO_TO_AGNO(mp, owner) < mp->m_sb.sb_agcount &&
+			       XFS_AGINO_TO_AGBNO(mp,
+					XFS_INO_TO_AGINO(mp, owner)) <
+					mp->m_sb.sb_agblocks)))
 				do_warn(
 	_("invalid owner in rmap btree record %d (%"PRId64" %u) block %u/%u\n"),
 						i, owner, len, agno, bno);

