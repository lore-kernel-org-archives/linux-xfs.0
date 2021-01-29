Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B26F4C433E9
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 02:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69BC164E05
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 02:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhA2CSO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 21:18:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:57468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231237AbhA2CSH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 21:18:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C60EB64DF5;
        Fri, 29 Jan 2021 02:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611886666;
        bh=2EFfCtNzkwALiabd4bJxcCEs/+zRStE7PDIFgCX3goM=;
        h=Subject:From:To:Cc:Date:From;
        b=pCZP/4WvGOUXULPA3vT5L2p1IpLOYONuDsm0Hj1D8RQwwrhu+GYnYJC1fq/diDTAr
         L2/Rb1lNV/0KHFVZimGoxeglZGzg4UAt2q8iuXH25R9oKmy5hocr+EpGu+Q4/C+1s/
         QSblcy7wwQbDGc1PeX8puC0Ebj3VavWt8yDl22RQgi6xHmaOT9G4Ei1TnPTEFgS+rj
         SBywdj6OaILM1FlQszyXUcTTbjFGMhtFBwCXcPtJ90FGN2w5drQm2IAv0L6TJlOnwO
         cr4Q6I24wfOLegz6alMNUxkjl47b7yCE+eJXINvO4g5I+SvElR3qRFVOiGr4K7bctO
         XyMyiIMcFTSBA==
Subject: [PATCHSET v6 00/12] xfs: try harder to reclaim space when we run out
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Thu, 28 Jan 2021 18:17:46 -0800
Message-ID: <161188666613.1943978.971196931920996596.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Historically, when users ran out of space or quota when trying to write
to the filesystem, XFS didn't try very hard to reclaim space that it
might have speculatively allocated for the purpose of speeding up
front-end filesystem operations (appending writes, cow staging).  The
upcoming deferred inactivation series will greatly increase the amount
of allocated space that isn't actively being used to store user data.

Therefore, try to reduce the circumstances where we return EDQUOT or
ENOSPC to userspace by teaching the write paths to try to clear space
and retry the operation one time before giving up.

Previous iterations of this patchset made massive changes to the
codebase, but thanks to the transaction allocation helpers that Brian
pushed for (in the previous patchset) this is mostly no longer
necessary. :)

v2: clean up and rebase against 5.11.
v3: restructure the retry loops per dchinner suggestion
v4: simplify the calling convention of xfs_trans_reserve_quota_nblks
v5: constrain the open-coded 'goto retry' loops to the helpers created
    in the previous patchset
v6: move "xfs: try worst case space reservation upfront in
    xfs_reflink_remap_extent" to this series, open-code the qretry
    helpers in the (now very few) places they are used

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reclaim-space-harder-5.12
---
 fs/xfs/xfs_file.c        |   24 +++---
 fs/xfs/xfs_icache.c      |  184 ++++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_icache.h      |    7 +-
 fs/xfs/xfs_ioctl.c       |   12 +++
 fs/xfs/xfs_iops.c        |   11 +++
 fs/xfs/xfs_quota.h       |   16 ++--
 fs/xfs/xfs_reflink.c     |   30 +++++++-
 fs/xfs/xfs_trace.c       |    1 
 fs/xfs/xfs_trace.h       |   42 +++++++++++
 fs/xfs/xfs_trans.c       |   34 ++++++++-
 fs/xfs/xfs_trans_dquot.c |  116 ++++++++++++++++++++++++++---
 11 files changed, 370 insertions(+), 107 deletions(-)

