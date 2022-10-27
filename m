Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD4CDFA3740
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 17:15:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbiJ0RPI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 13:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235573AbiJ0RPF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 13:15:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111BD1B7B7
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 10:15:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D66BB82722
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 17:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC79C433C1;
        Thu, 27 Oct 2022 17:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666890899;
        bh=VY8BIrc3Kovik3WtZtwdZwTmm+jt3eN23Ve6ra5exKQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FzlEtg9wMp4GEoX+SUlRXGvkdYReG+OfZIByhGuV/9SeFU6Fsfe76cikFO8vPSV7h
         I+ohN9fc9uhaUqPXjKr/4PyfPixfdhdMV95V2wTh9dB3UPKPQASgWhqK9VyiSrl8fy
         3cEANvc3nrsnUcbq2Onf6q5XYZscKXc6ANy4Ji4Bmu/DAVKAcu19PkSQAix2HYHpHn
         913IsJM8UvdGUvgKbdZdXPUuC/sn68mXjlTiiAICXiPUmjgY2iTcrtqXg0RZUbYPF6
         gj0A+tOeMMUhfcZibF1RCdLuMC0X6DpLS+GKSYclr5BgaWEpvaLNptftxDf+gTUVP3
         HsSmbfFa31sbA==
Subject: [PATCH 10/12] xfs: fix agblocks check in the cow leftover recovery
 function
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 27 Oct 2022 10:14:59 -0700
Message-ID: <166689089944.3788582.6885104145014798058.stgit@magnolia>
In-Reply-To: <166689084304.3788582.15155501738043912776.stgit@magnolia>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
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
filesystems where agblocks <= XFS_MAX_CRC_AG_BLOCKS, which is why this
ended up in the COW recovery routine.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 608a122eef16..529968b3b9c3 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1811,7 +1811,9 @@ xfs_refcount_recover_cow_leftovers(
 	xfs_fsblock_t			fsb;
 	int				error;
 
-	if (mp->m_sb.sb_agblocks >= XFS_REFC_COW_START)
+	/* reflink filesystems mustn't have AGs larger than 2^31-1 blocks */
+	BUILD_BUG_ON(XFS_MAX_CRC_AG_BLOCKS >= XFS_REFC_COW_START);
+	if (mp->m_sb.sb_agblocks > XFS_MAX_CRC_AG_BLOCKS)
 		return -EOPNOTSUPP;
 
 	INIT_LIST_HEAD(&debris);

