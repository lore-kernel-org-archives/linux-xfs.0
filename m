Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51FCBC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Nov 2022 17:22:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiK3RW3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Nov 2022 12:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiK3RW3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Nov 2022 12:22:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BD31B7B4
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 09:22:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0C26B81BE4
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 17:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A937DC433D6;
        Wed, 30 Nov 2022 17:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669828945;
        bh=f09enzyurxoW33RL6fOua1GZfZRLE0PNaxSvpw2phnw=;
        h=Date:From:To:Cc:Subject:From;
        b=sMzSDaTP1B95pFThtJ7GSs5a+2rSpNSDbDKqr4VLOhZP50XTGHMitGIGiMZX7FX3H
         K8EyPROYOvfMljGxlBLspljTm2Z4x4vgMOAGuDFFy7cpnCP89hFc3agZNPHgnBZsgq
         wPyCjNXWuDhmV9tWki96JWnj+aPPqM9bZwUH7bH+e58czb3YwmHGI8/YajjYA79LVJ
         c3nhckotEoeejXIKAGkG1Eq+W5LX8SOkLyiGUq9019yuu8vMd/1ddygSRQV3VAYAOr
         oH9VQ0/k0BVp/A5sxCOX1nmbuvALcqBX41T/iRB7sOYaDAt9sJsqiJQ61TVPU4txG4
         Ww6OWaxRHDp5w==
Date:   Wed, 30 Nov 2022 09:22:25 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [GIT PULL 1/2] xfs: add knobs for testing iomap write race fixes
Message-ID: <166982875086.4097590.2999263519057909822.stg-ugh@magnolia>
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

The following changes since commit 7dd73802f97d2a1602b1cf5c1d6623fb08cb15c5:

Merge tag 'xfs-iomap-stale-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs into xfs-6.2-mergeB (2022-11-28 17:23:58 -0800)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/iomap-write-race-testing-6.2_2022-11-30

for you to fetch changes up to 254e3459285cbf2174350bbc0051e475e1bc5196:

xfs: add debug knob to slow down write for fun (2022-11-28 17:54:49 -0800)

----------------------------------------------------------------
xfs: add knobs for testing iomap write race fixes

This series is a followup to Dave Chinner's series entitled
"xfs, iomap: fix data corruption due to stale cached iomaps".
The two patches here add debugging knobs to introduce artificial delays
into the pagecache write and writeback code to facilitate testing of the
iomap invalidation code.  New tracepoints are also introduced so that
fstests can look for the invalidations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: add debug knob to slow down writeback for fun
xfs: add debug knob to slow down write for fun

fs/xfs/libxfs/xfs_errortag.h |  6 +++-
fs/xfs/xfs_aops.c            | 14 ++++++--
fs/xfs/xfs_error.c           | 19 ++++++++++
fs/xfs/xfs_error.h           | 13 +++++++
fs/xfs/xfs_iomap.c           | 14 ++++++--
fs/xfs/xfs_trace.c           |  2 ++
fs/xfs/xfs_trace.h           | 86 ++++++++++++++++++++++++++++++++++++++++++++
7 files changed, 149 insertions(+), 5 deletions(-)
