Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22BB6C7619A
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Apr 2023 00:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjDMAyV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 20:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDMAyU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 20:54:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA24E2717
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 17:54:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6542B62C28
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 00:54:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5E9C433D2;
        Thu, 13 Apr 2023 00:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681347258;
        bh=5ii9kNQkz3TAYMU9RaC3P44U35QpT02ilRul3PInDfM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lGImrND4HRbWug17Xp9Z9sUZHCpA7rcO1vVzkVBFP8YN6hd/wRpGSqPrOki/hps7Y
         TIBU+f9kSbvxTcvg/QWI+znvGwY9Qp7RoONQreZivpQOzLDKrQqjF+gSH35uCXMhF3
         F/9RP2VHLin72aJNODyvbI3PsTrG4QpKYp/aUqoDVNKPNXgDSAil31yrzstyGJfA+k
         f6FZPmwiEp+E1w6/YQnbJJchz77GP61I9lSPMgzsI5z1WXAHuLydUqlx3eta3oUjZv
         evPD2JWT25kfEFS7aeq5BlailvkmLn6Dc+SPxn/EtvLZl2Z6cmcInW86JIaj16Giak
         WEivmdTnbc5qQ==
Date:   Wed, 12 Apr 2023 17:54:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [GIT PULL v2 16/22] xfs: merge bmap records for faster scrubs
Message-ID: <20230413005418.GV360889@frogsfrogsfrogs>
References: <168127095245.417736.9350032118598729884.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168127095245.417736.9350032118598729884.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Please pull this branch with changes for xfs.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 1fc7a0597d237c17b6501f8c33b76d3eaaae9079:

xfs: don't take the MMAPLOCK when scrubbing file metadata (2023-04-11 19:00:22 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-merge-bmap-records-6.4_2023-04-12

for you to fetch changes up to 1e59fdb7d6157ff685a250e0873a015a2b16a4f2:

xfs: don't call xchk_bmap_check_rmaps for btree-format file forks (2023-04-11 19:00:26 -0700)

----------------------------------------------------------------
xfs: merge bmap records for faster scrubs [v24.5]

I started looking into performance problems with the data fork scrubber
in generic/333, and noticed a few things that needed improving.  First,
due to design reasons, it's possible for file forks btrees to contain
multiple contiguous mappings to the same physical space.  Instead of
checking each ondisk mapping individually, it's much faster to combine
them when possible and check the combined mapping because that's fewer
trips through the rmap btree, and we can drop this check-around
behavior that it does when an rmapbt lookup produces a record that
starts before or ends after a particular bmbt mapping.

Second, I noticed that the bmbt scrubber decides to walk every reverse
mapping in the filesystem if the file fork is in btree format.  This is
very costly, and only necessary if the inode repair code had to zap a
fork to convince iget to work.  Constraining the full-rmap scan to this
one case means we can skip it for normal files, which drives the runtime
of this test from 8 hours down to 45 minutes (observed with realtime
reflink and rebuild-all mode.)

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (6):
xfs: change bmap scrubber to store the previous mapping
xfs: accumulate iextent records when checking bmap
xfs: split xchk_bmap_xref_rmap into two functions
xfs: alert the user about data/attr fork mappings that could be merged
xfs: split the xchk_bmap_check_rmaps into a predicate
xfs: don't call xchk_bmap_check_rmaps for btree-format file forks

fs/xfs/libxfs/xfs_bmap.h |   2 +-
fs/xfs/scrub/bmap.c      | 379 ++++++++++++++++++++++++++++++-----------------
2 files changed, 242 insertions(+), 139 deletions(-)

