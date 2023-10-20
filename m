Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 254C0C0032E
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Oct 2023 22:17:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjJTWRs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Oct 2023 18:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjJTWRr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2023 18:17:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100DCD63
        for <linux-xfs@vger.kernel.org>; Fri, 20 Oct 2023 15:17:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24C9C433C8;
        Fri, 20 Oct 2023 22:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697840265;
        bh=8pHWfKghjXGL9H4nPuSCWe3/UuOPbYNgAZ15/xw5omE=;
        h=Date:From:To:Cc:Subject:From;
        b=RQ1Xkr6FqQNPjYOIRXIEToATX90GxQifbNd9/dNqcsc0C427YQHgKuV68HVSRztH+
         5ZD+vseYVC8GT7pDRraLqW16lOZCLHiD4EaBq0TVQrCHgmE6odFaz9i24IQjNmCoXM
         Mn7SSHUOVz3rAKoZhJjYq3WeroJQAZsAqN35cWB6HeVoKMoO66ygBtsSOfxY91ejLM
         iaajjTehZbW4HynGWZQo4sQ+I9rk4ti8lNZpQdhiZpI72MbHmeJ4JbIbpEVl1UDz9I
         5OoLmdbxHArke5EOzb8GH04eTGhOGtrEo1qNXYt3mQQY6Lba1NSq8JpEg2vJJANsVq
         vFZz5GAHwjXrw==
Date:   Fri, 20 Oct 2023 15:17:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandanbabu@kernel.org, djwong@kernel.org
Cc:     hch@lst.de, linux-xfs@vger.kernel.org
Subject: [GIT PULL 4/6] xfs: refactor rtbitmap/summary macros
Message-ID: <169781768181.780878.1129014342842627388.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Chandan,

Please pull this branch with changes for xfs for 6.7-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit ef5a83b7e597038d1c734ddb4bc00638082c2bf1:

xfs: use shifting and masking when converting rt extents, if possible (2023-10-17 16:26:25 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/refactor-rtbitmap-macros-6.7_2023-10-19

for you to fetch changes up to d0448fe76ac1a9ccbce574577a4c82246d17eec4:

xfs: create helpers for rtbitmap block/wordcount computations (2023-10-18 10:58:58 -0700)

----------------------------------------------------------------
xfs: refactor rtbitmap/summary macros [v1.1]

In preparation for adding block headers and enforcing endian order in
rtbitmap and rtsummary blocks, replace open-coded geometry computations
and fugly macros with proper helper functions that can be typechecked.
Soon we'll be needing to add more complex logic to the helpers.

v1.1: various cleanups suggested by hch

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (5):
xfs: convert the rtbitmap block and bit macros to static inline functions
xfs: remove XFS_BLOCKWSIZE and XFS_BLOCKWMASK macros
xfs: convert open-coded xfs_rtword_t pointer accesses to helper
xfs: convert rt summary macros to helpers
xfs: create helpers for rtbitmap block/wordcount computations

fs/xfs/libxfs/xfs_format.h     |  16 +----
fs/xfs/libxfs/xfs_rtbitmap.c   | 142 +++++++++++++++++++++++++----------------
fs/xfs/libxfs/xfs_rtbitmap.h   | 100 +++++++++++++++++++++++++++++
fs/xfs/libxfs/xfs_trans_resv.c |   9 +--
fs/xfs/libxfs/xfs_types.h      |   2 +
fs/xfs/scrub/rtsummary.c       |  23 +++----
fs/xfs/xfs_rtalloc.c           |  22 +++----
7 files changed, 218 insertions(+), 96 deletions(-)
