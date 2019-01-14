Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40106 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbfANUcL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Jan 2019 15:32:11 -0500
Date: Mon, 14 Jan 2019 12:32:01 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 3/5] xfs: fix off-by-one error in rtbitmap cross-reference
Message-ID: <20190114203201.GA12689@magnolia>
References: <154697976479.2839.3584921201780682011.stgit@magnolia>
 <154697978351.2839.11888108672644284957.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154697978351.2839.11888108672644284957.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, sandeen@sandeen.net
Cc: Brian Foster <bfoster@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix an off-by-one error in the realtime bitmap "is used" cross-reference
helper function if the realtime extent size is a single block.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/rtbitmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 665d4bbb17cc..dbe115b075f7 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -141,9 +141,8 @@ xchk_xref_is_used_rt_space(
 	startext = fsbno;
 	endext = fsbno + len - 1;
 	do_div(startext, sc->mp->m_sb.sb_rextsize);
-	if (do_div(endext, sc->mp->m_sb.sb_rextsize))
-		endext++;
-	extcount = endext - startext;
+	do_div(endext, sc->mp->m_sb.sb_rextsize);
+	extcount = endext - startext + 1;
 	xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 	error = xfs_rtalloc_extent_is_free(sc->mp, sc->tp, startext, extcount,
 			&is_free);
