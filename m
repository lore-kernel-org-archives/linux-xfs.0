Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAFDBC83F12
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:11:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbjH2XLD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241139AbjH2XK6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:10:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CFEFD
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 16:10:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C42BC61208
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 23:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F321C433C7;
        Tue, 29 Aug 2023 23:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350655;
        bh=bsE71zZaNsCQdBn7rfuIvMMbUrw2Epv7/e0+h6XbSfw=;
        h=Subject:From:To:Cc:Date:From;
        b=QzVfSJ0NMUWYR5aDIALExws3D+wUC1IfKOytssrb7rn148m6VYWqVgJLxm4XcKiEv
         Vu1hHK2107OOVtNJjNW4rgSj86KBEDeFjMEyp5aLftKxjBHpRIsU2DP5ai2mlrYbRk
         iR3QyKjjQ+w7Nr/6gc4Zb6dvn0skfNR5UElGLkpZtR+FJ8Qhg6CICMC+qedGMvkNjw
         ot3ZKKvwo2fmGmhGXgZkKF3I98S7+SfZE2m4egfJr8wKxpvr+4RYO8jBzeLf56Gf7D
         4x6AC/NeVFqh0ra53FJolY93rd8mTbrlPIv0V7Cby2VGQ238kQRL0yIb/+YeufafRa
         YPCs2rgTDX9Hw==
Subject: [PATCHSET 0/1] xfs: fix EFI recovery livelocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@gmail.com
Cc:     Srikanth C S <srikanth.c.s@oracle.com>,
        Wengang Wang <wen.gang.wang@oracle.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Tue, 29 Aug 2023 16:10:54 -0700
Message-ID: <169335065467.3528394.5454470321177848433.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series fixes a customer-reported transaction reservation bug
introduced ten years ago that could result in livelocks during log
recovery.  Log intent item recovery single-steps each step of a deferred
op chain, which means that each step only needs to allocate one
transaction's worth of space in the log, not an entire chain all at
once.  This single-stepping is critical to unpinning the log tail since
there's nobody else to do it for us.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-efi-recovery-6.6
---
 fs/xfs/libxfs/xfs_log_recover.h |   22 ++++++++++++++++++++++
 fs/xfs/xfs_attr_item.c          |    7 ++++---
 fs/xfs/xfs_bmap_item.c          |    4 +++-
 fs/xfs/xfs_extfree_item.c       |    4 +++-
 fs/xfs/xfs_refcount_item.c      |    6 ++++--
 fs/xfs/xfs_rmap_item.c          |    6 ++++--
 6 files changed, 40 insertions(+), 9 deletions(-)

