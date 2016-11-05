Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36730 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750935AbcKEAJS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:09:18 -0400
Subject: [PATCH 12/16] libxfs: fix line lengths
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:09:14 -0700
Message-ID: <147830455401.26713.11368437004356317380.stgit@birch.djwong.org>
In-Reply-To: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

Fix some 80-char line length issues.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: Eric Sandeen <sandeen@sandeen.net>
---
 libxfs/xfs_ialloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 5c88b0b..efb37d3 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2338,7 +2338,8 @@ xfs_imap(
 
 		imap->im_blkno = XFS_AGB_TO_DADDR(mp, agno, agbno);
 		imap->im_len = XFS_FSB_TO_BB(mp, 1);
-		imap->im_boffset = (unsigned short)(offset << mp->m_sb.sb_inodelog);
+		imap->im_boffset = (unsigned short)(offset <<
+							mp->m_sb.sb_inodelog);
 		return 0;
 	}
 

