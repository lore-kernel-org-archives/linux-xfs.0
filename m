Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9870C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235997AbiLaAzE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235930AbiLaAzD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:55:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD33B1C90A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:55:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68C6D61BCD
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB5FC433D2;
        Sat, 31 Dec 2022 00:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448101;
        bh=5BJ/EvIgaVjv/z2W3ZYXHDsiW+1XciZKSriOGaKYHXw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Mkolo8QF8YJcfAGQuc7t9uPHvLln51T71rry4VYy1QZ49W2Rr0z7DrPfcwYp9PxDg
         0UOhp6Lv+OkSOJHmSe+D3t0EJe9Jng8Sp3Zzkog5gn/o/ZldN7Z1Y5woS/tSif6UgO
         X/eGNq8oy3P1a8E6r2J+ZDc1eZ7lxBRAIkihcWC/HGjk/6RF3x+wPrMpCgl09Cn9VO
         wHae9YCnN+0BI0TMYC9hV6bcnKxcjidxLAc2WoUlG0S2d4kZKm70va77uLIknyz2kb
         OrxvrmbybLeBp0Fk491L1t1UtAv1N4SQgcecKC7TFehWJEBCCOC5u9dAKANR74VBvG
         NwRCFbhjzCu1A==
Subject: [PATCHSET v1.0 00/20] xfs: hoist inode operations to libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:18 -0800
Message-ID: <167243863809.707335.15895322495460356300.stgit@magnolia>
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

This series hoists inode creation, renaming, and deletion operations to
libxfs in anticipation of the metadata inode directory feature, which
maintains a directory tree of metadata inodes.  This will be necessary
for further enhancements to the realtime feature, subvolume support.

There aren't supposed to be any functional changes in this intense
refactoring -- we just split the functions into pieces that are generic
and pieces that are specific to libxfs clients.  As a bonus, we can
remove various open-coded pieces of mkfs.xfs and xfs_repair when this
series gets to xfsprogs.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inode-refactor

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=inode-refactor
---
 fs/xfs/Makefile                 |    1 
 fs/xfs/libxfs/xfs_bmap.c        |   42 +
 fs/xfs/libxfs/xfs_bmap.h        |    3 
 fs/xfs/libxfs/xfs_dir2.c        |  479 +++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h        |   19 +
 fs/xfs/libxfs/xfs_ialloc.c      |   20 +
 fs/xfs/libxfs/xfs_inode_util.c  |  698 ++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h  |   79 +++
 fs/xfs/libxfs/xfs_shared.h      |    7 
 fs/xfs/libxfs/xfs_trans_inode.c |    2 
 fs/xfs/scrub/tempfile.c         |   20 -
 fs/xfs/xfs_inode.c              | 1231 +++++----------------------------------
 fs/xfs/xfs_inode.h              |   46 +
 fs/xfs/xfs_ioctl.c              |   60 --
 fs/xfs/xfs_iops.c               |   51 +-
 fs/xfs/xfs_linux.h              |    2 
 fs/xfs/xfs_qm.c                 |    8 
 fs/xfs/xfs_reflink.h            |   10 
 fs/xfs/xfs_symlink.c            |   22 -
 fs/xfs/xfs_trans.h              |    1 
 20 files changed, 1564 insertions(+), 1237 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_inode_util.c
 create mode 100644 fs/xfs/libxfs/xfs_inode_util.h

