Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AEDAC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 03:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbiKQDNq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Nov 2022 22:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiKQDNp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Nov 2022 22:13:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3C22A965
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2022 19:13:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA29EB81E97
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 03:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2888C433C1;
        Thu, 17 Nov 2022 03:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668654821;
        bh=LOksEKl8ZhYLJlW1dxtfMxhTE7EB2iRU+XE/2Toi0eI=;
        h=Date:From:To:Cc:Subject:From;
        b=hs3iP8zKrzVsXwSS0EoRjj2SAoOEbKXC5Zq1ITwZGS8c7YmO5FIhlKy63CUjnygz9
         tLQ/vJ3QN2b2zdahsLaX0E2c5m6PjLkrZOq1IxtKugPhucFY4ktoR4oK2yntho08HT
         vC+3llzMq5+7WL+MYdmZB7dsF89puJv0npIQ9ZIByivvzflJ3lygEUn2h3hgZXEE+4
         t0ukOLBVV8UmeQg2ygo/4f/LyrgVrjv/fJQtRvdLp9LT+TZunj1wS2g3b0t/BnLPzV
         SPE8f42yh3CTdmjDP0oUWYpXIq2J7C7KoqdRHAg1enMYLWCmCpNCKT9iez1CDepwdl
         9emUcsWSWJH1g==
Date:   Wed, 16 Nov 2022 19:13:41 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [GIT PULL 6/7] xfs: strengthen file mapping scrub
Message-ID: <166865412045.2381691.2208445647472093272.stg-ugh@magnolia>
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

The following changes since commit e74331d6fa2c21a8ecccfe0648dad5193b83defe:

xfs: online checking of the free rt extent count (2022-11-16 15:25:03 -0800)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-bmap-enhancements-6.2_2022-11-16

for you to fetch changes up to 5eef46358fae1a6018d9f886a3ecd30e843728dd:

xfs: teach scrub to flag non-extents format cow forks (2022-11-16 15:25:05 -0800)

----------------------------------------------------------------
xfs: strengthen file mapping scrub

This series strengthens the file extent mapping scrubber in various
ways, such as confirming that there are enough bmap records to match up
with the rmap records for this file, checking delalloc reservations,
checking for no unwritten extents in metadata files, invalid CoW fork
formats, and weird things like shared CoW fork extents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (6):
xfs: fix perag loop in xchk_bmap_check_rmaps
xfs: teach scrub to check for adjacent bmaps when rmap larger than bmap
xfs: block map scrub should handle incore delalloc reservations
xfs: check quota files for unwritten extents
xfs: check that CoW fork extents are not shared
xfs: teach scrub to flag non-extents format cow forks

fs/xfs/scrub/bmap.c  | 147 +++++++++++++++++++++++++++++++++++++++++----------
fs/xfs/scrub/quota.c |   6 ++-
2 files changed, 123 insertions(+), 30 deletions(-)
