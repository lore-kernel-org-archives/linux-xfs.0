Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F51EC433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiKICHi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiKICHi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:07:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54875686AD
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:07:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14300B81CE7
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D7AC433C1;
        Wed,  9 Nov 2022 02:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959654;
        bh=cdv03xghOKXO1UB+WVAHBDP5oMZvGGf655qV0dGpNCQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=E7ic39/BZM+ik8aGLRoQwJR4g3NcRv2KE4QWKxYzEMo+HqQRtZm50+c8FZ7TerZFB
         SE3Wmik2yNWrRtlkRbGauNCXDzLST1G4MlO7kIDkC4D05p7X/HyqhnnvY7gPtE1JTv
         STx7yMf42qR+znY/lHvOAR740cFLVB3Lw/4tsuLjxKfYuZ7uxWqRjUF6Di7C6b8Wj5
         mE+3/GK+DoqMQGuu16Pha5TjYc41r2j16LOuDA9E3NuJ59HHE85ZIh7yqy04ZqqXCA
         MigYTV6YGjGm5e2KQcb3kPyCIhF17Bw1bq9x3O3ERGMhAUy+/rKR4LiSBqySxFaakT
         9k2gjWIpwBsBA==
Subject: [PATCH 20/24] xfs: fix agblocks check in the cow leftover recovery
 function
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:07:34 -0800
Message-ID: <166795965431.3761583.15719682752076571294.stgit@magnolia>
In-Reply-To: <166795954256.3761583.3551179546135782562.stgit@magnolia>
References: <166795954256.3761583.3551179546135782562.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 2373f381819de8807fdd19be2d1a06bc62f8e595

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
 libxfs/xfs_refcount.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 179b686792..52983aeef1 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1795,7 +1795,9 @@ xfs_refcount_recover_cow_leftovers(
 	xfs_fsblock_t			fsb;
 	int				error;
 
-	if (mp->m_sb.sb_agblocks >= XFS_REFC_COW_START)
+	/* reflink filesystems mustn't have AGs larger than 2^31-1 blocks */
+	BUILD_BUG_ON(XFS_MAX_CRC_AG_BLOCKS >= XFS_REFC_COW_START);
+	if (mp->m_sb.sb_agblocks > XFS_MAX_CRC_AG_BLOCKS)
 		return -EOPNOTSUPP;
 
 	INIT_LIST_HEAD(&debris);

