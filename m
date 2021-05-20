Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3470AC433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 15:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1438361163
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 15:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhETPkt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 May 2021 11:40:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229978AbhETPkt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 May 2021 11:40:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C6B4610A2
        for <linux-xfs@vger.kernel.org>; Thu, 20 May 2021 15:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621525168;
        bh=LsbKqracXQiV/5j4h9f0DMWyWWCMADyvQVxkpiSmZsI=;
        h=Date:From:To:Subject:From;
        b=FZ9U9jl54UKuAB+JoQjjPt3cYHUvyhv6LEzD7a5CDI5uAOpyxF7REIfSoAt7kddqe
         GOgkaJQJoFPKnrT7/qcnCtrC4GHWOz+0WPElWQ42ziyeujsJIcRCTCYQP3msWZNSl6
         ET42I6i7ih9KqdBV11FX11y1xemRXIuIIS60YepJCxz3y7vD6zkVKaNfEZrFMxii3g
         JqwidfEzI8pAeoJE8dpU/yZnxx/TIwzWSHiyNDQ6ae6Iqg23LSPHu9tuqcaujlbVyq
         4rorBg2GOyWlXLzFL9m6fse44xakt/8TWgiNnqcahY80FBNVXyAYnnZaIDemDXaNUS
         RL40ux9Kh8hjQ==
Date:   Thu, 20 May 2021 08:39:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to e3c2b047475b
Message-ID: <20210520153927.GX9675@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  The fixes branch is based off -rc2 because pmem was
completely broken and bfq was corrupting data in -rc1, and we already
played at torching everyone's QA systems last cycle.  Anyway, next up
are the extent size hint fixes which I didn't get to this week because
of illness.

The new head of the for-next branch is commit:

e3c2b047475b xfs: restore old ioctl definitions

New Commits:

Darrick J. Wong (4):
      [9d5e8492eee0] xfs: adjust rt allocation minlen when extszhint > rtextsize
      [676a659b60af] xfs: retry allocations when locality-based search fails
      [16c9de54dc86] xfs: fix deadlock retry tracepoint arguments
      [e3c2b047475b] xfs: restore old ioctl definitions


Code Diffstat:

 fs/xfs/libxfs/xfs_fs.h |  4 +++
 fs/xfs/scrub/common.c  |  4 ++-
 fs/xfs/xfs_bmap_util.c | 96 ++++++++++++++++++++++++++++++++++++--------------
 3 files changed, 77 insertions(+), 27 deletions(-)
