Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B2CEC77B6C
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Apr 2023 00:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjDMAvp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 20:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjDMAvo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 20:51:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D397687
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 17:51:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0844862E1D
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 00:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609F3C433EF;
        Thu, 13 Apr 2023 00:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681347102;
        bh=eh3c0p/66EywHhk3vTqu6KrLtx6tSFKFcfjoH5dVSXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O1eBZaTaIu3Kf2fF/qZzWsJ1epbKbCMFAAtkhXej22/vDK3ANH9Ih4QWc0l35nn8R
         KIYI2R38e6OeNoKCqYpK3N47LLw+reMuYJIeci2BamuVzfZBEuXuQEw2dlV4V52Cjd
         kzlVPsKPesOkaCmBvimdWvYhNeOvwjzO2rga3cjBqVxnWjog0mwxkhWsZdEfHw84PN
         IbMJezeHmKBXdc1ePmo+bkCaTC+zMIngCv4j3h5TlLiAmbmMPqlCppSGB+uMQ8bVgT
         jhBKNAZMmnP6TwGD/xLiqe1iF16FjqLtsRkxscJsaFjD5UrGfM/OpZ5Le3604fniuQ
         CVIb8olgeuG8Q==
Date:   Wed, 12 Apr 2023 17:51:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com
Cc:     dchinner@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL 13/22] xfs: fix iget usage in directory scrub
Message-ID: <20230413005141.GT360889@frogsfrogsfrogs>
References: <168127094955.417736.8034002722203014684.stg-ugh@frogsfrogsfrogs>
 <20230413004926.GR360889@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413004926.GR360889@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

...and of course this was supposed to be tagged v2 but I got distracted
because I'm editing pull requests by hand to try to make threading work
properlyish even though the order of the pull requests has changed and
FML.

--D

On Wed, Apr 12, 2023 at 05:49:26PM -0700, Darrick J. Wong wrote:
> Hi Dave,
> 
> Please pull this branch with changes for xfs.  My topic branch
> management scripts neglected to ensure that the pull requests were
> sorted in patch order, hence the order is wrong and the pull requests
> are empty because I must have reshuffled the stgit patches and forgot to
> update the topic guide file.  Sigh.  I hate how maintainers have to
> build basic patch management and CI s*****themselves**.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> --D
> 
> The following changes since commit 30f8ee5e7e0ccce396dff209c6cbce49d0d7e167:
> 
> xfs: ensure that single-owner file blocks are not owned by others (2023-04-11 19:00:16 -0700)
> 
> are available in the Git repository at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-dir-iget-fixes-6.4_2023-04-12
> 
> for you to fetch changes up to 6bb9209ceebb07fd07cec25af04eed1809c654de:
> 
> xfs: always check the existence of a dirent's child inode (2023-04-11 19:00:18 -0700)
> 
> ----------------------------------------------------------------
> xfs: fix iget usage in directory scrub [v24.5]
> 
> In this series, we fix some problems with how the directory scrubber
> grabs child inodes.  First, we want to reduce EDEADLOCK returns by
> replacing fixed-iteration loops with interruptible trylock loops.
> Second, we add UNTRUSTED to the child iget call so that we can detect a
> dirent that points to an unallocated inode.  Third, we fix a bug where
> we weren't checking the inode pointed to by dotdot entries at all.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> ----------------------------------------------------------------
> Darrick J. Wong (4):
> xfs: use the directory name hash function for dir scrubbing
> xfs: streamline the directory iteration code for scrub
> xfs: xfs_iget in the directory scrubber needs to use UNTRUSTED
> xfs: always check the existence of a dirent's child inode
> 
> fs/xfs/Makefile        |   1 +
> fs/xfs/scrub/dir.c     | 246 +++++++++++---------------------
> fs/xfs/scrub/parent.c  |  73 +++-------
> fs/xfs/scrub/readdir.c | 375 +++++++++++++++++++++++++++++++++++++++++++++++++
> fs/xfs/scrub/readdir.h |  19 +++
> 5 files changed, 497 insertions(+), 217 deletions(-)
> create mode 100644 fs/xfs/scrub/readdir.c
> create mode 100644 fs/xfs/scrub/readdir.h
> 
