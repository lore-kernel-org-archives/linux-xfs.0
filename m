Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96D4CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiLaA4h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:56:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiLaA4g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:56:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2937DCF3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:56:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9EBB61D62
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:56:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FB5C433EF;
        Sat, 31 Dec 2022 00:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448195;
        bh=nUKn8OT90+Yf5ulmGrXOtPvYIxa0iwqoTsIHCeZv++w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qEW2kShgOcPIzWJLfif/Lk4xXD0tw1SsVoZz6g1yP1Ul3rXPUMz8KczSOq3/Hvip5
         lhV0DD206uIDvE397TXgv9ZmqQYgHyvrolpNRosFB3QSQqaKcmCr8S3gwfPlMX632S
         opsepWsYryJK3UoEhClN4GljNPn636g1u87JKsKOpRJ2yFSA+myWPWUYOmu7TKW/qA
         gZvIXyZBizmj/8g0stw6VmhG/UlAd+w5kMrsdY3rgAqkYGMtrXClhOSava/rFPu5vR
         nVips29HqskgEyl+353Ka/LhQyuTZpf5/ng3XbPqJFwuF1i4Nl60SvpFHvq/HCr5Uj
         LfmfGNTcvTA5Q==
Subject: [PATCHSET v1.0 0/3] xfs: refactor realtime meta inode locking
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:48 -0800
Message-ID: <167243866880.712531.9794913817759933297.stgit@magnolia>
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

Replace all the open-coded locking of realtime metadata inodes with a
single rtlock function that can lock all the pieces that the caller
wants in a single call.  This will be important for maintaining correct
locking order later when we start adding more realtime metadata inodes.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refactor-rt-locking

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=refactor-rt-locking
---
 fs/xfs/libxfs/xfs_bmap.c     |    7 +----
 fs/xfs/libxfs/xfs_rtbitmap.c |   57 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtbitmap.h |   17 ++++++++++++
 fs/xfs/scrub/common.c        |    9 +++---
 fs/xfs/scrub/fscounters.c    |    4 +--
 fs/xfs/xfs_bmap_util.c       |    5 +--
 fs/xfs/xfs_fsmap.c           |    4 +--
 fs/xfs/xfs_inode.c           |    3 +-
 fs/xfs/xfs_inode.h           |   13 +++------
 fs/xfs/xfs_rtalloc.c         |   62 ++++++++++++++++++++++++++++++------------
 10 files changed, 135 insertions(+), 46 deletions(-)

