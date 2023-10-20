Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 084BFC0032E
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Oct 2023 22:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjJTWRw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Oct 2023 18:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjJTWRv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2023 18:17:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7551A3
        for <linux-xfs@vger.kernel.org>; Fri, 20 Oct 2023 15:17:50 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7F9C433C7;
        Fri, 20 Oct 2023 22:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697840270;
        bh=4ZvBd5SyY9EKoeTZoMETtGCKy47b+6gHS7t9enHBSvM=;
        h=Date:From:To:Cc:Subject:From;
        b=YU7iXcWjNhkX8xvVhNVtyzrLpQy1fSIkavN39CBF18PiBPvolgCejDP0H3qcsIMwt
         5eUalL/IZvBspnwAoMlKkcOQhrBfp3zctlm+ljWf85DuzeBJAAxNDd9JjtjtCO0/r+
         C64Np8cdQ8m1vaHkE5Fd8UVzbpCmhZe2Q213wbBM4KwRx1xOlwk0Wv7Pw9sINVGEeT
         h6zfr4Y/QwbauDqfTV1c6DRYKSg7A+2VKc80oG+kLCTHeKyzV87smIyRJGNPQ8KmGM
         YQdigqKuruPPAGzEeaT24QaT6D1yivu+sdkRYh6lhwyV1MfAiFf7bih5cU7OKIQ27B
         9UHEOxgfzK+Iw==
Date:   Fri, 20 Oct 2023 15:17:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandanbabu@kernel.org, djwong@kernel.org
Cc:     hch@lst.de, linux-xfs@vger.kernel.org
Subject: [GIT PULL 5/6] xfs: refactor rtbitmap/summary accessors
Message-ID: <169781768277.780878.125720495778403014.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit d0448fe76ac1a9ccbce574577a4c82246d17eec4:

xfs: create helpers for rtbitmap block/wordcount computations (2023-10-18 10:58:58 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/refactor-rtbitmap-accessors-6.7_2023-10-19

for you to fetch changes up to 663b8db7b0256b81152b2f786e45ecf12bdf265f:

xfs: use accessor functions for summary info words (2023-10-18 16:53:00 -0700)

----------------------------------------------------------------
xfs: refactor rtbitmap/summary accessors [v1.2]

Since the rtbitmap and rtsummary accessor functions have proven more
controversial than the rest of the macro refactoring, split the patchset
into two to make review easier.

v1.1: various cleanups suggested by hch
v1.2: rework the accessor functions to reduce the amount of cursor
tracking required, and create explicit bitmap/summary logging
functions

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs: create a helper to handle logging parts of rt bitmap/summary blocks
xfs: use accessor functions for bitmap words
xfs: create helpers for rtsummary block/wordcount computations
xfs: use accessor functions for summary info words

fs/xfs/libxfs/xfs_format.h   |  16 ++++
fs/xfs/libxfs/xfs_rtbitmap.c | 206 +++++++++++++++++++++++--------------------
fs/xfs/libxfs/xfs_rtbitmap.h |  62 ++++++++++++-
fs/xfs/scrub/rtsummary.c     |  32 ++++---
fs/xfs/scrub/trace.c         |   1 +
fs/xfs/scrub/trace.h         |  10 +--
fs/xfs/xfs_ondisk.h          |   4 +
fs/xfs/xfs_rtalloc.c         |  17 ++--
8 files changed, 223 insertions(+), 125 deletions(-)
