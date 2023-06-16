Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B29EB64D9
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 01:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjFPBg7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 21:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFPBg6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 21:36:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95E32948
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 18:36:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 457CA61BEA
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2023 01:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A56EC433CA;
        Fri, 16 Jun 2023 01:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686879416;
        bh=BZ5sDkYhBl2ry8piOFCRp+8W/APq6+4iJfAhsIT3x0k=;
        h=Subject:From:To:Cc:Date:From;
        b=n+CgMSSoDYCiNHrHlXU3NGV5ZxG5PiShP+b7dfxi/83BT3WcNFTkVQLyua072hN1I
         mRQxxS8teeY1n7VT6P6OHWZXBcZ3y2FkGE6Yvy1fJUdGsanhfSjPF0suefv6TCKXJH
         RuGyXL3vSirFU7kuNg9HNh8YZhXlEdFfrFPySydtnUuTLs7QIVunXGCJYqCRCmtrIs
         DVjEMLDUkynkvipNWGbaweD/qcDFzMbKqO24xHRP2iGlc7flIBLHb1rVG88JHDIV20
         Xofl2Z7CqEoYKY3p4kfhXanZJS/dasOEmfCohi93s8PoXP6+6yLvvZD/G5d8Ql/9h8
         ulIuxVMP8WB3Q==
Subject: [PATCHSET 0/8] xfsprogs: sync with 6.4
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        kernel test robot <oliver.sang@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Thu, 15 Jun 2023 18:36:56 -0700
Message-ID: <168687941600.831530.8013975214397479444.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Synchronize with libxfs changs in kernel 6.4 and fix anything that
breaks as a result.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-sync-6.4
---
 include/list.h           |    7 +-
 include/xfs_inode.h      |    3 +
 include/xfs_trans.h      |    7 ++
 libfrog/list_sort.c      |   10 +--
 libxfs/defer_item.c      |   74 ++++++++++++---------
 libxfs/libxfs_priv.h     |    4 +
 libxfs/logitem.c         |  165 +++++++++++++++++++++++++++++++++++++++++++++-
 libxfs/trans.c           |   96 +++++++++++++++++++++++++++
 libxfs/util.c            |    4 +
 libxfs/xfs_ag.c          |    5 +
 libxfs/xfs_alloc.c       |   91 ++++++++++++++++++-------
 libxfs/xfs_alloc.h       |    6 +-
 libxfs/xfs_bmap.c        |   10 ++-
 libxfs/xfs_bmap_btree.c  |    7 +-
 libxfs/xfs_ialloc.c      |   24 ++++---
 libxfs/xfs_log_format.h  |    9 ++-
 libxfs/xfs_refcount.c    |   13 +++-
 libxfs/xfs_trans_inode.c |  113 ++------------------------------
 scrub/repair.c           |   12 ++-
 19 files changed, 456 insertions(+), 204 deletions(-)

