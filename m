Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68136C4743C
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 22:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4449C6113E
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 22:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbhFUWgw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 18:36:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231669AbhFUWgv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Jun 2021 18:36:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10487600D3
        for <linux-xfs@vger.kernel.org>; Mon, 21 Jun 2021 22:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624314877;
        bh=qUe9Pp02p1Q4MwQkuwP1rbBreCMfb5xP+OUu7+ScsCI=;
        h=Date:From:To:Subject:From;
        b=uSqyPpJ2HrKMB1qpEv+i9HjRCflF87K+N37tGK8HLRe4eVF9Ptd+E+VqYn4Lz1wwL
         3yFwLCju4W8Ao78YNcNrkHoKLy1Rj7PadHbHjHIeRT87I/yKm05AyNNRCKpzvKW6VQ
         D+naAwAB5/GKEhmY55WLbYbAG06YR9b8aSZJRyzOO12dgkewwh8ENLjSYBB/1zNq68
         +BtyA81IDC6sJ2JeD7ltf+lyKc9NTKRKmlwP/xWXeYQpl2h2tWagomCcKGPQ1AZyRi
         AmC16Ac9PO/ik5EMNMis9SejUA8NE2lIDwbYRmCObto+FZP4Hvr44MKgeJviNogpRS
         HzBoBp2waHcWA==
Date:   Mon, 21 Jun 2021 15:34:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix endianness issue in xfs_ag_shrink_space
Message-ID: <20210621223436.GF3619569@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The AGI buffer is in big-endian format, so we must convert the
endianness to CPU format to do any comparisons.

Fixes: 46141dc891f7 ("xfs: introduce xfs_ag_shrink_space()")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index c68a36688474..afff2ab7e9f1 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -510,6 +510,7 @@ xfs_ag_shrink_space(
 	struct xfs_buf		*agibp, *agfbp;
 	struct xfs_agi		*agi;
 	struct xfs_agf		*agf;
+	xfs_agblock_t		aglen;
 	int			error, err2;
 
 	ASSERT(agno == mp->m_sb.sb_agcount - 1);
@@ -524,14 +525,14 @@ xfs_ag_shrink_space(
 		return error;
 
 	agf = agfbp->b_addr;
+	aglen = be32_to_cpu(agi->agi_length);
 	/* some extra paranoid checks before we shrink the ag */
 	if (XFS_IS_CORRUPT(mp, agf->agf_length != agi->agi_length))
 		return -EFSCORRUPTED;
-	if (delta >= agi->agi_length)
+	if (delta >= aglen)
 		return -EINVAL;
 
-	args.fsbno = XFS_AGB_TO_FSB(mp, agno,
-				    be32_to_cpu(agi->agi_length) - delta);
+	args.fsbno = XFS_AGB_TO_FSB(mp, agno, aglen - delta);
 
 	/*
 	 * Disable perag reservations so it doesn't cause the allocation request
