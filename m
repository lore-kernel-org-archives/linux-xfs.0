Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A415C7619A
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Apr 2023 00:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjDMAta (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 20:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDMAt3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 20:49:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73707E6E
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 17:49:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E5E063362
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 00:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C864C433D2;
        Thu, 13 Apr 2023 00:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681346967;
        bh=T+N67IeFKsHSTYGtUjfpV6YHilE0kSQlZBiI+diy40A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uVoiLEMypLjrbxm15+uoufydUa1wiZULIojRYjabGE01x91AWX77OfRXNJKatgjjO
         Xz9W5jdzRyxRg4fcYeoBVmHd8T/qhNoYKeh+MAgcCkcdApN/m0eCFwaLqKLUBS09fA
         dfPrqB7tqdQE+TBtsultM2sc9Of4betGP0uNTA1r2euzAK4U5ioWWFKvlkfOMD1pv7
         yo6rlTBKv1ohPs/XX1AI8PDaMEzK7PVQsgsZlBdfbFDrfbY+67W786AOuDCX8n/1vG
         3otvnvQPXeWDmeirvwPjx9vL9otfdrm8t0BUYi/UjXbp67+07jsH5VCMCWw5sM3HB+
         YL1fMLpfyf+uw==
Date:   Wed, 12 Apr 2023 17:49:26 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com
Cc:     dchinner@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: [GIT PULL 13/22] xfs: fix iget usage in directory scrub
Message-ID: <20230413004926.GR360889@frogsfrogsfrogs>
References: <168127094955.417736.8034002722203014684.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168127094955.417736.8034002722203014684.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Please pull this branch with changes for xfs.  My topic branch
management scripts neglected to ensure that the pull requests were
sorted in patch order, hence the order is wrong and the pull requests
are empty because I must have reshuffled the stgit patches and forgot to
update the topic guide file.  Sigh.  I hate how maintainers have to
build basic patch management and CI s*****themselves**.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 30f8ee5e7e0ccce396dff209c6cbce49d0d7e167:

xfs: ensure that single-owner file blocks are not owned by others (2023-04-11 19:00:16 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-dir-iget-fixes-6.4_2023-04-12

for you to fetch changes up to 6bb9209ceebb07fd07cec25af04eed1809c654de:

xfs: always check the existence of a dirent's child inode (2023-04-11 19:00:18 -0700)

----------------------------------------------------------------
xfs: fix iget usage in directory scrub [v24.5]

In this series, we fix some problems with how the directory scrubber
grabs child inodes.  First, we want to reduce EDEADLOCK returns by
replacing fixed-iteration loops with interruptible trylock loops.
Second, we add UNTRUSTED to the child iget call so that we can detect a
dirent that points to an unallocated inode.  Third, we fix a bug where
we weren't checking the inode pointed to by dotdot entries at all.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs: use the directory name hash function for dir scrubbing
xfs: streamline the directory iteration code for scrub
xfs: xfs_iget in the directory scrubber needs to use UNTRUSTED
xfs: always check the existence of a dirent's child inode

fs/xfs/Makefile        |   1 +
fs/xfs/scrub/dir.c     | 246 +++++++++++---------------------
fs/xfs/scrub/parent.c  |  73 +++-------
fs/xfs/scrub/readdir.c | 375 +++++++++++++++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/readdir.h |  19 +++
5 files changed, 497 insertions(+), 217 deletions(-)
create mode 100644 fs/xfs/scrub/readdir.c
create mode 100644 fs/xfs/scrub/readdir.h

