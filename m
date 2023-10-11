Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C85BCDB470
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 18:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbjJKSBh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 14:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbjJKSBg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:01:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D3693
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:01:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2AE5C433C8;
        Wed, 11 Oct 2023 18:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047292;
        bh=fCSRfNh7eSUb/uQAMaPxvaYWeq24QvyUpY40GiqSavA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=O5yL1DQ3jinSiMd4/q31OScXtBBufk5TBxuqoRO+HnTQnBp5wndvGZVz03lTXHGvW
         3FOUD8+HklAOUjkgf1DRHKGUpf2ZW8K/1roy8dbftDE4k7qLUGfDG3W2fa9EOJ+CXI
         CEBdqACdK6RwihzPepDwHLFldjW9OW9LeVejgrfWa50vdMrBqgABJEyVcwYu4rOlMH
         cAFGpvMAPF7nS+/23WPwaErH47I4KrRjjkfhTsZ174fSWVNyQhN+Kbedf/6++2c2Yg
         LDfGKVgr08EN50/H2iI6j5f5IdVQTOAPcLj5yBcUJU0RQtw9LC5aWb2T3ArWDEyWZf
         ZMuITTr+JAJow==
Date:   Wed, 11 Oct 2023 11:01:32 -0700
Subject: [PATCHSET RFC v1.0 0/7] xfs: refactor rt extent unit conversions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Message-ID: <169704721170.1773611.12311239321983752854.stgit@frogsfrogsfrogs>
In-Reply-To: <20231011175711.GM21298@frogsfrogsfrogs>
References: <20231011175711.GM21298@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series replaces all the open-coded integer division and
multiplication conversions between rt blocks and rt extents with calls
to static inline helpers.  Having cleaned all that up, the helpers are
augmented to skip the expensive operations in favor of bit shifts and
masking if the rt extent size is a power of two.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refactor-rt-unit-conversions

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=refactor-rt-unit-conversions
---
 fs/xfs/libxfs/xfs_bmap.c        |   19 +++-----
 fs/xfs/libxfs/xfs_rtbitmap.c    |    4 +-
 fs/xfs/libxfs/xfs_rtbitmap.h    |   88 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c          |    2 +
 fs/xfs/libxfs/xfs_swapext.c     |    7 ++-
 fs/xfs/libxfs/xfs_trans_inode.c |    1 
 fs/xfs/libxfs/xfs_trans_resv.c  |    3 +
 fs/xfs/scrub/inode.c            |    3 +
 fs/xfs/scrub/inode_repair.c     |    3 +
 fs/xfs/scrub/rtbitmap.c         |   18 +++-----
 fs/xfs/scrub/rtsummary.c        |    4 +-
 fs/xfs/xfs_bmap_util.c          |   38 +++++++----------
 fs/xfs/xfs_fsmap.c              |   14 +++---
 fs/xfs/xfs_inode_item.c         |    3 +
 fs/xfs/xfs_ioctl.c              |    5 +-
 fs/xfs/xfs_linux.h              |   12 +++++
 fs/xfs/xfs_mount.h              |    2 +
 fs/xfs/xfs_rtalloc.c            |   16 ++++---
 fs/xfs/xfs_super.c              |    3 +
 fs/xfs/xfs_trans.c              |    9 +++-
 fs/xfs/xfs_xchgrange.c          |    4 +-
 21 files changed, 180 insertions(+), 78 deletions(-)

