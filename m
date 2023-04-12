Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53492C7619A
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 03:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjDLDts (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 23:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjDLDtr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 23:49:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBDA10C0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 20:49:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDF0C629DF
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 03:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA6BC433D2;
        Wed, 12 Apr 2023 03:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681271385;
        bh=mq4ChGg2tCK4P1Cw1VoitjDRRBFPFFbMgsqMkm3xvYw=;
        h=Date:Subject:From:To:Cc:From;
        b=GRRssJAZIRBPcoAMaZlB6VVxccKCWPsMA2rJg7Pm7lQu2/KcWlRTr3uCnV/u6Ah5Z
         ZQQPIojBjnZinZ0VzRC3rU8h6J7z1eDJE+0d7C61XRT+/dNDOyPxZbUCi2py6CvuK6
         V/ptnITqX2U8+kRTv3gflYrPhpGlrLNOAKmwlpdKUMGXRSgxMBD8+jN11bsoRov7Ab
         m6bAwZyaEnwX+ai/epwbi4EvDJs9mApBNGNf5PItPqCBCdaUL1rdtYWyTAjsl3u5Gg
         HHcy0c4l7F39wQE2s02xadHjWxZ5lbW3/oghLMXW186iBxwm4POrwlEssRYvAVfayY
         tNQOlgfWJFXvQ==
Date:   Tue, 11 Apr 2023 20:49:44 -0700
Subject: [GIT PULL 19/22] xfs: rework online fsck incore bitmap
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@fromorbit.com, djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <168127095543.417736.17628317256060611866.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Please pull this branch with changes for xfs.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 44af6c7e59b12d740809cf25a60c9f90f03e6d20:

xfs: don't load local xattr values during scrub (2023-04-11 19:00:35 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-bitmap-rework-6.4_2023-04-11

for you to fetch changes up to 6772fcc8890ae34595253fcfb8196c1aea65e111:

xfs: convert xbitmap to interval tree (2023-04-11 19:00:36 -0700)

----------------------------------------------------------------
xfs: rework online fsck incore bitmap [v24.5]

In this series, we make some changes to the incore bitmap code: First,
we shorten the prefix to 'xbitmap'.  Then, we rework some utility
functions for later use by online repair and clarify how the walk
functions are supposed to be used.

Finally, we use all these new pieces to convert the incore bitmap to use
an interval tree instead of linked lists.  This lifts the limitation
that callers had to be careful not to set a range that was already set;
and gets us ready for the btree rebuilder functions needing to be able
to set bits in a bitmap and generate maximal contiguous extents for the
set ranges.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs: remove the for_each_xbitmap_ helpers
xfs: drop the _safe behavior from the xbitmap foreach macro
xfs: convert xbitmap to interval tree

fs/xfs/scrub/agheader_repair.c |  99 ++++++-----
fs/xfs/scrub/bitmap.c          | 367 +++++++++++++++++++++++++----------------
fs/xfs/scrub/bitmap.h          |  33 ++--
fs/xfs/scrub/repair.c          | 104 ++++++------
4 files changed, 358 insertions(+), 245 deletions(-)

