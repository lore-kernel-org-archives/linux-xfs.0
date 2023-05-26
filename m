Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 488B6C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:30:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjEZAas (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjEZAar (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:30:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E1718D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:30:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E83060AAD
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0562C433D2;
        Fri, 26 May 2023 00:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061045;
        bh=4swFOvwAcdxL04szGm/R6UNYzWO/2Gjaqsky5uSuSKw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=WOVmLPfZp4DGTh6iNpQHr8ffQjR0B6OKpzVR6TsHLt8mwFmYS3tS2FfGcY++GcInY
         sF8jlUEw6eg6aBko5U41G2AUWPOFY8ib8YAePqJnUi7kSUofh28wfIN0ZHHxjwa7TP
         kYuCHpTBoGGOcMJb+SMMK+ztjl6+CcD0zsmoZ2Ht/McBY0mDxFi1nXEpky34HI5D+j
         6nRK/iUpyZt5HpTQwFvOVt9OfKP6a/NQDBm0xz/d2Ezqzs9axwiX86FGKykCYkAiWO
         +RH3Q4wWdOQEoniRW/irs2KrKH5AMKRWkJ0Stp1E/QQQNkqphiSlhywXwy25t8aTV/
         in32ka7vecUJw==
Date:   Thu, 25 May 2023 17:30:45 -0700
Subject: [PATCHSET v25.0 0/4] xfs: online repair of quota and rt metadata
 files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506059095.3730797.12158750493561425588.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000020.GJ11620@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

XFS stores quota records and free space bitmap information in files.
Add the necessary infrastructure to enable repairing metadata inodes and
their forks, and then make it so that we can repair the file metadata
for the rtbitmap.  Repairing the bitmap contents (and the summary file)
is left for subsequent patchsets.

We also add the ability to repair file metadata the quota files.  As
part of these repairs, we also reinitialize the ondisk dquot records as
necessary to get the incore dquots working.  We can also correct
obviously bad dquot record attributes, but we leave checking the
resource usage counts for the next patchsets.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-quota

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-quota

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-quota
---
 fs/xfs/Makefile                |    8 +
 fs/xfs/libxfs/xfs_bmap.c       |   39 ++++
 fs/xfs/libxfs/xfs_bmap.h       |    2 
 fs/xfs/scrub/bmap_repair.c     |   17 +-
 fs/xfs/scrub/quota.c           |   11 +
 fs/xfs/scrub/quota.h           |   11 +
 fs/xfs/scrub/quota_repair.c    |  405 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.c          |  151 +++++++++++++++
 fs/xfs/scrub/repair.h          |   22 ++
 fs/xfs/scrub/rtbitmap.c        |   10 +
 fs/xfs/scrub/rtbitmap_repair.c |   56 ++++++
 fs/xfs/scrub/scrub.c           |    8 -
 fs/xfs/scrub/trace.c           |    1 
 fs/xfs/scrub/trace.h           |   28 +++
 fs/xfs/xfs_inode.c             |   24 --
 15 files changed, 761 insertions(+), 32 deletions(-)
 create mode 100644 fs/xfs/scrub/quota.h
 create mode 100644 fs/xfs/scrub/quota_repair.c
 create mode 100644 fs/xfs/scrub/rtbitmap_repair.c

