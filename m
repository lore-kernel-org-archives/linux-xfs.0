Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FAEFC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235998AbiLaAzV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235930AbiLaAzV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:55:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA46A13F29
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:55:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B1D1B81DFF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597CAC433D2;
        Sat, 31 Dec 2022 00:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448117;
        bh=875Aeh5iDq8iu8TeQ/KRmIOwoAM54QNeo+6gi4aKhY0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mRHg3HyokYe9slBx+Jl9LMWN995b972vPqtIPenccnwG/IKyNYlJypHQC/AgwSYdM
         oMvLtUCqsk4BrHRaKiNq72HuScK/m/n/Yn3CrQWv/MxAaKfZzAIKZKybbj9UBTjyw4
         DFTRpOOvzDlpAl0YTaiX0oEDfwXhznBQtzMV7jE0fQV2ZsaRLKM3EZpP7kdRIOTJH4
         x4uQdL5rlPuxHgCDqvaX75oTmnIgVHmGmOQ+iVZeDeydAVEIux30WDTqX/8gra6hlk
         KueRcwFPFmEK6OHQ/cnDE1RrVmUVEzGjQoR2KJcp5T325+eWOu854TiXuF78jkX2n0
         qHccnceYG0ssg==
Subject: [PATCHSET v1.0 00/23] xfs: metadata inode directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:24 -0800
Message-ID: <167243864431.708110.1688096566212843499.stgit@magnolia>
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

This series delivers a new feature -- metadata inode directories.  This
is a separate directory tree (rooted in the superblock) that contains
only inodes that contain filesystem metadata.  Different metadata
objects can be looked up with regular paths.

We start by creating xfs_imeta_* functions to mediate access to metadata
inode pointers.  This enables the imeta code to abstract inode pointers,
whether they're the classic five in the superblock, or the much more
complex directory tree.  All current users of metadata inodes (rt+quota)
are converted to use the boilerplate code.

Next, we define the metadir on-disk format, which consists of marking
inodes with a new iflag that says they're metadata.  This we use to
prevent bulkstat and friends from ever getting their hands on fs
metadata.

Finally, we implement metadir operations so that clients can create,
delete, zap, and look up metadata inodes by path.  Beware that much of
this code is only lightly used, because the five current users of
metadata inodes don't tend to change them very often.  This is likely to
change if and when the subvolume and multiple-rt-volume features get
written/merged/etc.

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
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_format.h     |   60 ++
 fs/xfs/libxfs/xfs_fs.h         |   12 
 fs/xfs/libxfs/xfs_health.h     |    4 
 fs/xfs/libxfs/xfs_ialloc.c     |   16 -
 fs/xfs/libxfs/xfs_ialloc.h     |    2 
 fs/xfs/libxfs/xfs_imeta.c      | 1210 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_imeta.h      |   94 +++
 fs/xfs/libxfs/xfs_inode_buf.c  |   73 ++
 fs/xfs/libxfs/xfs_inode_buf.h  |    3 
 fs/xfs/libxfs/xfs_inode_util.c |    4 
 fs/xfs/libxfs/xfs_log_rlimit.c |    9 
 fs/xfs/libxfs/xfs_sb.c         |   35 +
 fs/xfs/libxfs/xfs_trans_resv.c |   74 ++
 fs/xfs/libxfs/xfs_trans_resv.h |    2 
 fs/xfs/libxfs/xfs_types.c      |    7 
 fs/xfs/scrub/agheader.c        |   29 +
 fs/xfs/scrub/common.c          |    7 
 fs/xfs/scrub/dir.c             |    9 
 fs/xfs/scrub/dir_repair.c      |    6 
 fs/xfs/scrub/inode_repair.c    |   10 
 fs/xfs/scrub/nlinks.c          |   12 
 fs/xfs/scrub/nlinks_repair.c   |    2 
 fs/xfs/scrub/parent.c          |   18 +
 fs/xfs/scrub/parent_repair.c   |   37 +
 fs/xfs/scrub/tempfile.c        |   10 
 fs/xfs/xfs_health.c            |    1 
 fs/xfs/xfs_icache.c            |   39 +
 fs/xfs/xfs_inode.c             |  131 ++++
 fs/xfs/xfs_inode.h             |   11 
 fs/xfs/xfs_ioctl.c             |    7 
 fs/xfs/xfs_iops.c              |   34 +
 fs/xfs/xfs_itable.c            |   32 +
 fs/xfs/xfs_itable.h            |    3 
 fs/xfs/xfs_mount.c             |   39 +
 fs/xfs/xfs_mount.h             |    3 
 fs/xfs/xfs_ondisk.h            |    1 
 fs/xfs/xfs_qm.c                |  212 +++++--
 fs/xfs/xfs_qm_syscalls.c       |    4 
 fs/xfs/xfs_rtalloc.c           |   16 -
 fs/xfs/xfs_super.c             |    4 
 fs/xfs/xfs_symlink.c           |    2 
 fs/xfs/xfs_trace.h             |   78 +++
 43 files changed, 2223 insertions(+), 140 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_imeta.c
 create mode 100644 fs/xfs/libxfs/xfs_imeta.h

