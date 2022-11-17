Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD479C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 03:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbiKQDNl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Nov 2022 22:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234476AbiKQDNj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Nov 2022 22:13:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E355615A33
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2022 19:13:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 809E46207E
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 03:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF98C433C1;
        Thu, 17 Nov 2022 03:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668654815;
        bh=FnctTkyB3cvYYzfQPaI0niC8tEhh5aYcmHWS7owkLdM=;
        h=Date:From:To:Cc:Subject:From;
        b=lGbQEYZX6QG33Pcj4x6NrM4w3doW5L16HN9apLNv8JmPCheDCbfjb403DmmvxqI4C
         8ibnAyBjMOKvrNuOch3Kps1KzcIKD/oAyOO1WxmVduXDqdD3nCY0uGJjwlhPkglH2n
         Tlm4qPRmlLKppkpkgnb53YnwQ/8SpZ6eMEhOg/uI5ILvXAKWcEGIa9P/ui7o5KDTvW
         R8+RL6LgByeNVJd2dqgI+vIB1vW01uz9an64V3CBV/uvLLnzEdFqrMzmwL+bJChzsi
         AtIi8ZXCnSPNUeT+tMm5oH8xXay8b2veg7qhPUCgm7r4Y6P0zaNk2EluH05DvdgwLI
         EUEt3tJy5wUug==
Date:   Wed, 16 Nov 2022 19:13:35 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [GIT PULL 5/7] xfs: enhance fs summary counter scrubber
Message-ID: <166865411790.2381691.6594401591217870651.stg-ugh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

Please pull this branch with changes for xfs for 6.2-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 5f369dc5b4eb2becbdfd08924dcaf00e391f4ea1:

xfs: make rtbitmap ILOCKing consistent when scanning the rt bitmap file (2022-11-16 15:25:03 -0800)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-fscounters-enhancements-6.2_2022-11-16

for you to fetch changes up to e74331d6fa2c21a8ecccfe0648dad5193b83defe:

xfs: online checking of the free rt extent count (2022-11-16 15:25:03 -0800)

----------------------------------------------------------------
xfs: enhance fs summary counter scrubber

This series makes two changes to the fs summary counter scrubber: first,
we should mark the scrub incomplete when we can't read the AG headers.
Second, it fixes a functionality gap where we don't actually check the
free rt extent count.

v23.2: fix pointless inline

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: skip fscounters comparisons when the scan is incomplete
xfs: online checking of the free rt extent count

fs/xfs/scrub/fscounters.c | 107 ++++++++++++++++++++++++++++++++++++++++++++--
fs/xfs/scrub/scrub.h      |   8 ----
2 files changed, 104 insertions(+), 11 deletions(-)
