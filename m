Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49C64CDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:46:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235077AbjJQPqo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344379AbjJQPqa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:46:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF1F19A
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:46:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155FBC433C9;
        Tue, 17 Oct 2023 15:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697557577;
        bh=dckdaI0QpJs/cDyZZhuQCpBKmYKjtPtDVxldmIj5BEY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=WlkkitIWNSOg+r9ygKTVFYOZiythhJAm7Htzaprn7C8FNJWY3xxFVnOhsYtbFYSZY
         DUSaZI3VPKWmIsBNKRI2aSOeTU1Mbsey9shGITLxn2165FgII/9DMCCx629o6ByZ5/
         JOUQ9na+c5ZA6PiaLM/FdbPS5RSfRMneYRJUj/l9PYreP8qmLwJ9yaYacaZXxFn8fZ
         3Q1fv3hrw70tb94fytGYXcVT1AdpGotqUCl89xx33Svz22TGpkkfvpHwx1cT8wuEWB
         ot3OOxQHrQJFFQNLDjwtPzzEFvbdrIkdCn+/eZY0+OQ4/TmlIdfWVspWQiRMnrVED5
         TA+7y+pts+3jA==
Date:   Tue, 17 Oct 2023 08:46:16 -0700
Subject: [PATCHSET RFC v1.1 0/7] xfs: refactor rt extent unit conversions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, osandov@fb.com,
        linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <169755741717.3165781.12142780069035126128.stgit@frogsfrogsfrogs>
In-Reply-To: <169755692527.3152516.2094723855860721089.stg-ugh@frogsfrogsfrogs>
References: <169755692527.3152516.2094723855860721089.stg-ugh@frogsfrogsfrogs>
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

v1.1: various cleanups suggested by hch

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refactor-rt-unit-conversions-6.7
---
 fs/xfs/libxfs/xfs_bmap.c       |   20 +++---
 fs/xfs/libxfs/xfs_rtbitmap.c   |    4 +
 fs/xfs/libxfs/xfs_rtbitmap.h   |  125 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c         |    2 +
 fs/xfs/libxfs/xfs_trans_resv.c |    3 +
 fs/xfs/scrub/inode.c           |    3 +
 fs/xfs/scrub/rtbitmap.c        |   18 ++----
 fs/xfs/scrub/rtsummary.c       |    4 +
 fs/xfs/xfs_bmap_util.c         |   38 +++++-------
 fs/xfs/xfs_fsmap.c             |   13 ++--
 fs/xfs/xfs_inode_item.c        |    3 +
 fs/xfs/xfs_ioctl.c             |    5 +-
 fs/xfs/xfs_linux.h             |   12 ++++
 fs/xfs/xfs_mount.h             |    2 +
 fs/xfs/xfs_rtalloc.c           |    4 +
 fs/xfs/xfs_super.c             |    3 +
 fs/xfs/xfs_trans.c             |    7 ++
 17 files changed, 200 insertions(+), 66 deletions(-)

