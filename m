Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C442C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbiL3XCU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiL3XCT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:02:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888E415FC1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:02:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F751B81D84
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:02:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B08C433EF;
        Fri, 30 Dec 2022 23:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441336;
        bh=4swFOvwAcdxL04szGm/R6UNYzWO/2Gjaqsky5uSuSKw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SrUHOq0R8pGinc/Ti8ZrNp6wUdel+F31MfxpuyojErcWy0cxx8KYed8IImm1+g9nq
         Cw9O8mD73aOb87iq1SFKroKYeGLg9U+7TiHagU5D7Ym5HV50dW5wyiPb+ZDD7/V9Y8
         3Y0UKg2EDA3k/u1+OAf6AJruyqOaNmUD6tq8AEayZZ8/ZXNS5nZtMgqHQLw24YQOuh
         Jw6b9p+XkbK3FEXfSv0bHU9/GZihYby51FnTieMep32+Y3/HoOvT6KjixQP0+ENFMU
         7P/I4FVLd99WxbMLUr4Rb2y0CrzL5vdY9wP1ZBl83nz/2K4WX+1US7k05uxGCbSf/m
         eyQUL81GoPmmQ==
Subject: [PATCHSET v24.0 0/4] xfs: online repair of quota and rt metadata
 files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:59 -0800
Message-ID: <167243837989.695277.12249962882609806700.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
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

