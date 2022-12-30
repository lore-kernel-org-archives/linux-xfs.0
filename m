Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0566DC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235779AbiLaBAR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbiLaBAQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:00:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF1F1C913
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F302B81E0F
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139C6C433D2;
        Sat, 31 Dec 2022 01:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448413;
        bh=HS8HgPlWpUNECKZnA3KOHQpp4cZ09IgLn8zmpUyncrk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SyAoLTbtkStVeNhB/RgOMgUazBEdCKFnc2vFMIgi3NR1qtelXisRIJvMKgv6kY12y
         wskOVnX9yqLFTfPEqUFZ8Bri3Npw5Zsa8E+rWWGke11lyXSIzAgD7QcszgrRzvfRbQ
         /bu0aPgBWLab2MhI7jcpHI9l4NyPOA4r0txOgDV9w18yBd3IviPOdreA8tWS+bhqia
         euJ/ZWhFpIzCFVadCKmfIaZkyCH04eurBmDWcabbPNrPjP1sptjBxGexw9b3qlCZ1Y
         GSr1H1Kg7EvztrAog3bKW1Xies4QM8Xlb4wOUpHhbnphqDJPV+2jfMx41UU01Us3k/
         YP25qTy4OA4JA==
Subject: [PATCHSET v1.0 00/46] libxfs: metadata inode directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:19 -0800
Message-ID: <167243875924.725900.7061782826830118387.stgit@magnolia>
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

Add libxfs code from the kernel, then teach xfs_repair and mkfs to
use the metadir functions to find metadata inodes.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadir

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=metadir

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=metadir
---
 db/check.c                      |   21 +
 db/inode.c                      |    3 
 db/metadump.c                   |   92 ++-
 db/namei.c                      |   43 +
 db/sb.c                         |   43 +
 include/kmem.h                  |    4 
 include/libxfs.h                |    1 
 include/xfs_inode.h             |   13 
 include/xfs_mount.h             |    3 
 include/xfs_trace.h             |   13 
 io/bulkstat.c                   |   16 -
 libfrog/fsgeom.c                |    4 
 libxfs/Makefile                 |    2 
 libxfs/init.c                   |   40 +
 libxfs/inode.c                  |  130 ++++
 libxfs/libxfs_api_defs.h        |   20 +
 libxfs/libxfs_priv.h            |    4 
 libxfs/util.c                   |   75 ++
 libxfs/xfs_format.h             |   51 ++
 libxfs/xfs_fs.h                 |   12 
 libxfs/xfs_health.h             |    4 
 libxfs/xfs_ialloc.c             |   16 -
 libxfs/xfs_ialloc.h             |    2 
 libxfs/xfs_imeta.c              | 1209 +++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_imeta.h              |   94 +++
 libxfs/xfs_inode_buf.c          |   73 ++
 libxfs/xfs_inode_buf.h          |    3 
 libxfs/xfs_inode_util.c         |    4 
 libxfs/xfs_log_rlimit.c         |    9 
 libxfs/xfs_sb.c                 |   35 +
 libxfs/xfs_trans_resv.c         |   74 ++
 libxfs/xfs_trans_resv.h         |    2 
 libxfs/xfs_types.c              |    7 
 man/man2/ioctl_xfs_fsgeometry.2 |    3 
 man/man8/mkfs.xfs.8.in          |   11 
 man/man8/xfs_admin.8            |    9 
 man/man8/xfs_db.8               |   11 
 man/man8/xfs_io.8               |   10 
 man/man8/xfs_protofile.8        |   33 +
 mkfs/Makefile                   |   10 
 mkfs/lts_4.19.conf              |    1 
 mkfs/lts_5.10.conf              |    1 
 mkfs/lts_5.15.conf              |    1 
 mkfs/proto.c                    |  283 +++++++--
 mkfs/xfs_mkfs.c                 |   26 +
 mkfs/xfs_protofile.in           |  152 +++++
 repair/agheader.c               |    7 
 repair/dino_chunks.c            |   58 ++
 repair/dinode.c                 |  173 +++++-
 repair/dinode.h                 |    6 
 repair/dir2.c                   |   77 ++
 repair/globals.c                |    4 
 repair/globals.h                |    4 
 repair/incore.h                 |   50 +-
 repair/incore_ino.c             |    1 
 repair/phase1.c                 |    2 
 repair/phase2.c                 |   76 ++
 repair/phase4.c                 |   21 +
 repair/phase5.c                 |    7 
 repair/phase6.c                 |  853 +++++++++++++++++++++++-----
 repair/protos.h                 |    6 
 repair/sb.c                     |    3 
 repair/scan.c                   |   43 +
 repair/scan.h                   |    7 
 repair/xfs_repair.c             |   88 +++
 scrub/inodes.c                  |    5 
 scrub/inodes.h                  |    5 
 scrub/phase3.c                  |    7 
 scrub/phase5.c                  |    2 
 scrub/phase6.c                  |    2 
 70 files changed, 3785 insertions(+), 395 deletions(-)
 create mode 100644 libxfs/xfs_imeta.c
 create mode 100644 libxfs/xfs_imeta.h
 create mode 100644 man/man8/xfs_protofile.8
 create mode 100644 mkfs/xfs_protofile.in

