Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB86CECAAA1
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Oct 2022 23:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiJ3Xm3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Oct 2022 19:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJ3Xm2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Oct 2022 19:42:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182219FEA
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 16:42:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5D857CE10A0
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 23:42:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98798C433C1;
        Sun, 30 Oct 2022 23:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667173344;
        bh=naiOt5IRbzCLFYI5MbBjrOoiuE4ySOcmwRmN+BXd50M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SESD1HE5UEj2GSVGMDZem99HzXydr1+miV8rWqMvd3N2rtyFlaCTMKtQVrRukrfJ8
         cgYhgaHG6JEK2LzDiJCYOqbM+2izh2MFrg5Sw/spiFGRw4DRqY2TNV/ocqksIpPG3i
         kR5RaGGgU4KR9Y5+fSLNaN+h7uFden51Z0k1OqtKHZil64t/VhcivZpkxoJB5GcX2e
         hVuHY1mHShRORqRx02T0UYaUd25LB0YbjnWzbs2S7pd9ZmIPvkA43YBPXfQQ9sZXgs
         O2dJ0s0ULlbq7s+UIdZ4pDvc915EDdVQXlIJXOeepBrgxzLzG0yOHZRzI17G6gLUU5
         xHRha+RbB1FCQ==
Subject: [PATCH 11/13] xfs: fix agblocks check in the cow leftover recovery
 function
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Sun, 30 Oct 2022 16:42:24 -0700
Message-ID: <166717334414.417886.14860084113730107058.stgit@magnolia>
In-Reply-To: <166717328145.417886.10627661186183843873.stgit@magnolia>
References: <166717328145.417886.10627661186183843873.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

As we've seen, refcount records use the upper bit of the rc_startblock
field to ensure that all the refcount records are at the right side of
the refcount btree.  This works because an AG is never allowed to have
more than (1U << 31) blocks in it.  If we ever encounter a filesystem
claiming to have that many blocks, we absolutely do not want reflink
touching it at all.

However, this test at the start of xfs_refcount_recover_cow_leftovers is
slightly incorrect -- it /should/ be checking that agblocks isn't larger
than the XFS_MAX_CRC_AG_BLOCKS constant, and it should check that the
constant is never large enough to conflict with that CoW flag.

Note that the V5 superblock verifier has not historically rejected
filesystems where agblocks >= XFS_MAX_CRC_AG_BLOCKS, which is why this
ended up in the COW recovery routine.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_refcount.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 27ed4c10d0d0..ad0fb6a7177b 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1796,7 +1796,9 @@ xfs_refcount_recover_cow_leftovers(
 	xfs_fsblock_t			fsb;
 	int				error;
 
-	if (mp->m_sb.sb_agblocks >= XFS_REFC_COW_START)
+	/* reflink filesystems mustn't have AGs larger than 2^31-1 blocks */
+	BUILD_BUG_ON(XFS_MAX_CRC_AG_BLOCKS >= XFS_REFC_COW_START);
+	if (mp->m_sb.sb_agblocks > XFS_MAX_CRC_AG_BLOCKS)
 		return -EOPNOTSUPP;
 
 	INIT_LIST_HEAD(&debris);

