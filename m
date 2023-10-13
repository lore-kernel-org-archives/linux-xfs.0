Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20335CDB47E
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Oct 2023 04:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjJMEvT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Oct 2023 00:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjJMEvS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Oct 2023 00:51:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4C7B7
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 21:51:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D67C433C7;
        Fri, 13 Oct 2023 04:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697172676;
        bh=Vc1zePjQ4clD61bgMypzBQE1Fl5e5UyuU62+GRhpTLs=;
        h=From:To:Cc:Subject:Date:From;
        b=HpvTRD4b8YNyofn1zPhqSG9g1ccU4/RVTVPU7UVLxxNDvkqqgiu8fF41+etI4X0H5
         U2jbocrOkzvUEWqS4l8vIkSdLwzTq5e6c7o8IZK+G5aZwlXOJ1oYnq7vUuE68osPD0
         EX6HcGq/kW7e0uOkACukiy5S2MN+JVjRvlbXU9yGqotlB/rINO9x5ezOQx2ZHb0Cbd
         bzVEv0K7qX45fPpRlfSTRDTnv4u9C8NAl4rgqtQhQawWB9a+SExvM8pfaWv2slUmPY
         bxPjJs6IR/36sj+iGrPng7FZOse0c3y7Ve4an+mx6nU4EpJ56/Ys4Ic5oW1dnm9fOT
         8OtN86e8iAVzw==
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandanbabu@kernel.org>
To:     chandanbabu@kernel.org
Cc:     abaci@linux.alibaba.com, djwong@kernel.org, hch@lst.de,
        jiapeng.chong@linux.alibaba.com, jlayton@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        ruansy.fnst@fujitsu.com
Subject: Subject: [ANNOUNCE] xfs-linux: for-next updated to cbc06310c36f
Date:   Fri, 13 Oct 2023 10:15:48 +0530
Message-ID: <87o7h36s72.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

cbc06310c36f xfs: reinstate the old i_version counter as STATX_CHANGE_COOKIE

6 new commits:

Chandan Babu R (1):
      [fa543e65abad] Merge tag 'random-fixes-6.6_2023-10-11' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.6-fixesD

Darrick J. Wong (2):
      [6868b8505c80] xfs: adjust the incore perag block_count when shrinking
      [442177be8c3b] xfs: process free extents to busy list in FIFO order

Jeff Layton (1):
      [cbc06310c36f] xfs: reinstate the old i_version counter as STATX_CHANGE_COOKIE

Jiapeng Chong (1):
      [f93b9300301d] xfs: Remove duplicate include

Shiyang Ruan (1):
      [3c90c01e4934] xfs: correct calculation for agend and blockcount

Code Diffstat:

 fs/xfs/libxfs/xfs_ag.c      | 6 ++++++
 fs/xfs/scrub/xfile.c        | 1 -
 fs/xfs/xfs_extent_busy.c    | 3 ++-
 fs/xfs/xfs_iops.c           | 5 +++++
 fs/xfs/xfs_notify_failure.c | 6 +++---
 5 files changed, 16 insertions(+), 5 deletions(-)
