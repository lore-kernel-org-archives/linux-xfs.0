Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F875C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6147760E05
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhIOXMw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:12:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229538AbhIOXMt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:12:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8966610A6;
        Wed, 15 Sep 2021 23:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747489;
        bh=Ux4Go8I9vmuTiqAd22YkOMBESyGKZyFVpGOyq8NHrFc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XEJzS/Z2E5e2TmsvH1oFh+T71ouL8C3vzSUzcUMAUufDD1ixKMUjRcDD3TSDs4znb
         kjUHgbWSFZwXTcsnh/ZpvLAPKYYdzl9Vd2MtmwGQ2F2DxAKVBqEOXqF2L5i7ECXvBM
         y4Y8yFh4S8E3iKVC+EB6z6zgM0YS+I78nA70If/0WRISGPzO8y/ou0I9yz06nzKiIr
         7r3JMVH6bpUSW7HC8wnv4T14xzykoegG78DkiMPHKyi8JXhzIYze1Ekq4+FZjoGRuH
         WOsiEvpiRVisTrkLLpIBGFInIbySZVcJxypaA/GHvPka+3mMj5Cy7geA7WrFitu0mK
         099sPiRDbpsaQ==
Subject: [PATCH 54/61] xfs: fix endianness issue in xfs_ag_shrink_space
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:11:29 -0700
Message-ID: <163174748962.350433.2275531433152059158.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: a8f3522c9a1f4a31e93b17f2b5310a2b615f5581

The AGI buffer is in big-endian format, so we must convert the
endianness to CPU format to do any comparisons.

Fixes: 46141dc891f7 ("xfs: introduce xfs_ag_shrink_space()")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ag.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index a1a2d0d9..3e78d253 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -777,6 +777,7 @@ xfs_ag_shrink_space(
 	struct xfs_buf		*agibp, *agfbp;
 	struct xfs_agi		*agi;
 	struct xfs_agf		*agf;
+	xfs_agblock_t		aglen;
 	int			error, err2;
 
 	ASSERT(agno == mp->m_sb.sb_agcount - 1);
@@ -791,14 +792,14 @@ xfs_ag_shrink_space(
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

