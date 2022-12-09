Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AADE7C4332F
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Dec 2022 13:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiLINBL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Dec 2022 08:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLINBK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Dec 2022 08:01:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDEDA112E
        for <linux-xfs@vger.kernel.org>; Fri,  9 Dec 2022 05:01:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7018962246
        for <linux-xfs@vger.kernel.org>; Fri,  9 Dec 2022 13:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510E9C433F0
        for <linux-xfs@vger.kernel.org>; Fri,  9 Dec 2022 13:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670590868;
        bh=YilXzlrJujIFptVeIlN4/fIjpWZQyAd+J/HODU8kZk0=;
        h=Date:From:To:Subject:From;
        b=b7Em8jdzGTYzb+8hZD/EoI9fa8vShuTdC9WaBTGP/29I6dXnzxY1GCdMy6uMv0nA4
         cxUKAVu2sanyL0xbtKb4MqQjttq7KP5WbWJvqrSohtwSZuBmG/CfOlPI41utUqIH94
         zQxdDo0bdBk9X+J7p+esI5R8Yea24LlQoLGPr4JJqvB1NbavBaBI1EtxCaoeBjqdLl
         fr8C6hTatPVySKzSpHqC52Ac6mgBq0GPsVwa7Zhy9O8wcsCvwYUCaHyevOaRup7OSV
         Q3cLIVCVVElPVUcMZXLTozWhMPCnBDDfgusf9IGcYq+e+ifw1S5PBeiHxG2lmjYffg
         TzJ5eSdfgcovQ==
Date:   Fri, 9 Dec 2022 14:01:05 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs for-next branch updated
Message-ID: <20221209130105.zd442ai4qk5pvmfa@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

This should contain all patches on linux-xfs list with RwB tags, not yet
included in the tree.
If you have patches reviewed on the list, not included here, please let me know.


New head:

2dac91b3d xfs_repair: Fix rmaps_verify_btree() error path

New commits:

Carlos Maiolino (2):
      [fbd9b2363] xfs_repair: Fix check_refcount() error path
      [2dac91b3d] xfs_repair: Fix rmaps_verify_btree() error path

Darrick J. Wong (9):
      [60066f61c] libxfs: consume the xfs_warn mountpoint argument
      [b6fef47a8] misc: add static to various sourcefile-local functions
      [a946664de] misc: add missing includes
      [b84d0823d] xfs_db: fix octal conversion logic
      [e9dea7eff] xfs_db: fix printing of reverse mapping record blockcounts
      [978c3087b] xfs_repair: don't crash on unknown inode parents in dry run mode
      [945c7341d] xfs_repair: retain superblock buffer to avoid write hook deadlock
      [2b9d6f15b] xfs_{db,repair}: fix XFS_REFC_COW_START usage
      [765809a0d] mkfs.xfs: add mkfs config file for the 6.1 LTS kernel

Diffstat:

 db/btblock.c             |  2 +-
 db/check.c               |  4 ++--
 db/namei.c               |  2 +-
 db/write.c               |  4 ++--
 io/pread.c               |  2 +-
 libfrog/linux.c          |  1 +
 libxfs/libxfs_api_defs.h |  2 ++
 libxfs/libxfs_io.h       |  1 +
 libxfs/libxfs_priv.h     |  2 +-
 libxfs/rdwr.c            |  8 ++++++++
 libxfs/util.c            |  1 +
 mkfs/Makefile            |  3 ++-
 mkfs/lts_6.1.conf        | 14 ++++++++++++++
 mkfs/xfs_mkfs.c          |  2 +-
 repair/phase2.c          |  8 ++++++++
 repair/phase6.c          |  9 ++++++++-
 repair/protos.h          |  1 +
 repair/rmap.c            | 43 ++++++++++++++++++++-----------------------
 repair/scan.c            | 22 ++++++++++++++++------
 repair/xfs_repair.c      | 77
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------
 scrub/inodes.c           |  2 +-
 21 files changed, 159 insertions(+), 51 deletions(-)
 create mode 100644 mkfs/lts_6.1.conf


-- 
Carlos Maiolino
