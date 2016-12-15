Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23565 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753971AbcLOSL4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Dec 2016 13:11:56 -0500
Subject: [PATCH 2/3] xfs_repair: fix bogus rmapbt record owner check
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 15 Dec 2016 10:11:51 -0800
Message-ID: <148182551170.24784.17780632480854888664.stgit@birch.djwong.org>
In-Reply-To: <148182550558.24784.5628335536185073955.stgit@birch.djwong.org>
References: <148182550558.24784.5628335536185073955.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
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

