Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47796 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729104AbfAHUg1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jan 2019 15:36:27 -0500
Subject: [PATCH 3/5] xfs: fix off-by-one error in rtbitmap cross-reference
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 08 Jan 2019 12:36:23 -0800
Message-ID: <154697978351.2839.11888108672644284957.stgit@magnolia>
In-Reply-To: <154697976479.2839.3584921201780682011.stgit@magnolia>
References: <154697976479.2839.3584921201780682011.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix an off-by-one error in the realtime bitmap "is used" cross-reference
helper function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/rtbitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 665d4bbb17cc..5402211f980b 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -143,7 +143,7 @@ xchk_xref_is_used_rt_space(
 	do_div(startext, sc->mp->m_sb.sb_rextsize);
 	if (do_div(endext, sc->mp->m_sb.sb_rextsize))
 		endext++;
-	extcount = endext - startext;
+	extcount = endext - startext + 1;
 	xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 	error = xfs_rtalloc_extent_is_free(sc->mp, sc->tp, startext, extcount,
 			&is_free);
