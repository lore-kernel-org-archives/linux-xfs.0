Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBADCC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 03:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbiKQDNe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Nov 2022 22:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234004AbiKQDNc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Nov 2022 22:13:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6769FBE31
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2022 19:13:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 029A66207B
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 03:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B99C433D6;
        Thu, 17 Nov 2022 03:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668654810;
        bh=7B5aSIVtJsIA1lwZYq73R/FyGUpSWmjmoiEnsNmV8Xk=;
        h=Date:From:To:Cc:Subject:From;
        b=GUCLYwTF1BiBjeY1WbVb1gQhwRtCpGPwR2c7M4C5ht4ynepjUxx77qm8QPOLtS013
         Un8TcThNiR3qdMZrQ2ju0BldM5NRe7XmohTxnY/YiqCKNRM7JxTmTL0lyp2yM1qHsZ
         nXFpywrlBT62tcL+VSWv/Qh0tK+vVzigq+bDcuORWhV0e+NfaQvVjXdLRwq7Vs0fQc
         PKWKekyEjT9Lbxj++UykXCRh/wKybgabQeJcl81ulpXEUUNqUpwwSknYIDQzBhyhPN
         QufnOjzFGq6tZyTB0XrwxdZNTFjBUvYhvi4hyEJ/X9XoyGZYksVXOnE/VexOns2SbR
         8JyU4wbBLbq4w==
Date:   Wed, 16 Nov 2022 19:13:29 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [GIT PULL 4/7] xfs: improve rt metadata use for scrub
Message-ID: <166865411531.2381691.16629270315712295691.stg-ugh@magnolia>
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

The following changes since commit 93b0c58ed04b6cbe45354f23bb5628fff31f9084:

xfs: don't return -EFSCORRUPTED from repair when resources cannot be grabbed (2022-11-16 15:25:03 -0800)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-fix-rtmeta-ilocking-6.2_2022-11-16

for you to fetch changes up to 5f369dc5b4eb2becbdfd08924dcaf00e391f4ea1:

xfs: make rtbitmap ILOCKing consistent when scanning the rt bitmap file (2022-11-16 15:25:03 -0800)

----------------------------------------------------------------
xfs: improve rt metadata use for scrub

This short series makes some small changes to the way we handle the
realtime metadata inodes.  First, we now make sure that the bitmap and
summary file forks are always loaded at mount time so that every
scrubber won't have to call xfs_iread_extents.  This won't be easy if
we're, say, cross-referencing realtime space allocations.  The second
change makes the ILOCK annotations more consistent with the rest of XFS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: load rtbitmap and rtsummary extent mapping btrees at mount time
xfs: make rtbitmap ILOCKing consistent when scanning the rt bitmap file

fs/xfs/xfs_fsmap.c   |  4 ++--
fs/xfs/xfs_rtalloc.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++------
2 files changed, 56 insertions(+), 8 deletions(-)
