Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 728D9C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 17:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B43C64F13
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 17:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbhBYROe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 12:14:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:42284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230201AbhBYROd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Feb 2021 12:14:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E801164ECE
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 17:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614273232;
        bh=jQAYI2Nxkgerdh0KR0xMmV+gyATKRg+9P+YjlgW1WA4=;
        h=Date:From:To:Subject:From;
        b=gB3EYvO9LgmbpvGde+ElQaLG8fhawrdM2wklti1TfmIg2uiFPgd26esUnDui5w5lN
         orjItCzltvrN7XPQHHtG+p/MIHEZSSDCgaVFG55rlcoqWBRAgpk5JWwtibOLPcwDEO
         O7ftOUq6QFah3emB5sjNm3w9BxZSL9FY8te2zNuRISyHxU7Mq2eIl16wVYC7Hn+00W
         AGwluWmElDi3Z+RHyUl0ytWPwfkbwRrN95IhRKXWYY6R1xvHf65A1/Er6y2cmw2CMV
         0gCSyCe1UUVPn9x2Z6A3VW9HmYcBNPt9c0BhgMak4PWGfy/YjaDmNH1TT+3S49G74O
         AdE+MO9ZMmM0Q==
Date:   Thu, 25 Feb 2021 09:13:51 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 756b1c343333
Message-ID: <20210225171351.GK7272@magnolia>
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
the next update.

The new head of the for-next branch is commit:

756b1c343333 xfs: use current->journal_info for detecting transaction recursion

New Commits:

Brian Foster (1):
      [06058bc40534] xfs: don't reuse busy extents on extent trim

Darrick J. Wong (2):
      [89e0eb8c13bb] xfs: restore speculative_cow_prealloc_lifetime sysctl
      [9febcda6f8d1] xfs: don't nest transactions when scanning for eofblocks

Dave Chinner (1):
      [756b1c343333] xfs: use current->journal_info for detecting transaction recursion


Code Diffstat:

 Documentation/admin-guide/xfs.rst | 16 ++++++++++------
 fs/iomap/buffered-io.c            |  7 -------
 fs/xfs/libxfs/xfs_btree.c         | 12 ++++++++++--
 fs/xfs/xfs_aops.c                 | 17 +++++++++++++++--
 fs/xfs/xfs_extent_busy.c          | 14 --------------
 fs/xfs/xfs_sysctl.c               | 35 ++++++++++++++---------------------
 fs/xfs/xfs_trans.c                | 33 +++++++++++++++------------------
 fs/xfs/xfs_trans.h                | 30 ++++++++++++++++++++++++++++++
 8 files changed, 94 insertions(+), 70 deletions(-)
