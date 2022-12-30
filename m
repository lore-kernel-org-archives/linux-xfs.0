Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CFAAC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235846AbiLaA4X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235815AbiLaA4X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:56:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE8DCF3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:56:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE56AB81E06
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0A1C433D2;
        Sat, 31 Dec 2022 00:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448179;
        bh=v6JcySB9miJFsoUMyNMdov2i+hVmYIuumMCFouxQVts=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EgctiWONcEC4S1bDj9KLUyQqqKvuLEaUsZH0Jw8k3xi49CZDcQ8sQ6C8XZAGa5rWn
         1qcEvLeVNLxs4dUfFQf/Yy4NWPVPVYFGz4wCgTmpOB7MSR5ToOEcu++R5Yhgew+wlU
         dtawfB06AqxJlUID+UwTx6+ihVjcRXbGNfkpSep9Vo9NdQu2sV2TndjT0oUOCaLv6h
         8pee0XL7YpzzcHReAKUlZHFm8TV+pjy5mPD/ALkl3VjW76Pftk0289DBA8FFAFLrn7
         gtrAzz5bV7U6TVqLptq32FBitM6BinbgMqDk5da2pL1/yf0j4TIiHva/JpWRgY0HNb
         JJEbF+1eIt/fQ==
Subject: [PATCHSET v1.0 0/8] xfs: refactor rtbitmap/summary macros
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:44 -0800
Message-ID: <167243866468.712132.9606813674941614562.stgit@magnolia>
In-Reply-To: <Y69UsO7tDT3HcFri@magnolia>
References: <Y69UsO7tDT3HcFri@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In preparation for adding block headers and enforcing endian order in
rtbitmap and rtsummary blocks, replace open-coded geometry computations
and fugly macros with proper helper functions that can be typechecked.
Soon we'll be needing to add more complex logic to the helpers.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refactor-rtbitmap-macros

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=refactor-rtbitmap-macros
---
 fs/xfs/libxfs/xfs_format.h      |   32 ++---
 fs/xfs/libxfs/xfs_rtbitmap.c    |  268 ++++++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_rtbitmap.h    |  133 +++++++++++++++++++
 fs/xfs/libxfs/xfs_trans_resv.c  |    9 +
 fs/xfs/libxfs/xfs_types.h       |    2 
 fs/xfs/scrub/rtsummary.c        |   52 ++++----
 fs/xfs/scrub/rtsummary.h        |    6 -
 fs/xfs/scrub/rtsummary_repair.c |    7 +
 fs/xfs/scrub/trace.c            |    1 
 fs/xfs/scrub/trace.h            |    4 -
 fs/xfs/xfs_ondisk.h             |    4 +
 fs/xfs/xfs_rtalloc.c            |   39 +++---
 12 files changed, 409 insertions(+), 148 deletions(-)

