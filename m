Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C3C4C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235938AbiLaBCf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbiLaBCf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:02:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228EB1DDF3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:02:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B17BE61D68
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:02:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD57C433D2;
        Sat, 31 Dec 2022 01:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448553;
        bh=xy2MTudIVRk5ObOqx4V4o8BHDWtXctALCdzbJ1Rme8Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XcmprKjNBGu3ptyUZHUJpreHTaGAPVxhfori4CoYnV/4Ang3ac2ellYAGXA1xwK5+
         UDVXcssM/PRHmVCXp2ixtiyWyJScNhipVw/zpWGrExRcbfXKatSGmBwvVIlciedm+9
         +gKQGchgwKJbtcEdAfQth3BQa5DmnadyWe3xn4pjQXm8vM4CdRpoce9mrzM0OEK25g
         M+WAZAUbbEfQ9OMM6vAPqk3jCpXYXvOOZpoafXIr8LKT1iMaEvDTacuHylwqkbhuyQ
         +bXz3u7REjB7jcVEI10vFqdZVpONCGSUdaOP4YT6N/mMOrx8yLtV9onxtIACcBWqAd
         Bv8/2Dj9c6vkw==
Subject: [PATCHSET v1.0 00/41] libxfs: reflink on the realtime device
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:07 -0800
Message-ID: <167243880752.734096.171910706541747310.stgit@magnolia>
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

This patchset enables use of the file data block sharing feature (i.e.
reflink) on the realtime device.  It follows the same basic sequence as
the realtime rmap series -- first a few cleanups; then widening of the
API parameters; and introduction of the new btree format and inode fork
format.  Next comes enabling CoW and remapping for the rt device; new
scrub, repair, and health reporting code; and at the end we implement
some code to lengthen write requests so that rt extents are always CoWed
fully.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-reflink

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-reflink

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-reflink

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-reflink
---
 db/bmroot.c                   |  148 ++++++++
 db/bmroot.h                   |    2 
 db/btblock.c                  |   53 +++
 db/btblock.h                  |    5 
 db/btdump.c                   |   11 +
 db/btheight.c                 |    5 
 db/check.c                    |  326 ++++++++++++++---
 db/field.c                    |   13 +
 db/field.h                    |    5 
 db/inode.c                    |   76 ++++
 db/inode.h                    |    2 
 db/metadump.c                 |  125 ++++++
 db/type.c                     |    5 
 db/type.h                     |    1 
 include/libxfs.h              |    1 
 include/xfs_mount.h           |    9 
 libfrog/scrub.c               |    5 
 libxfs/Makefile               |    2 
 libxfs/defer_item.c           |   20 +
 libxfs/init.c                 |   14 +
 libxfs/libxfs_api_defs.h      |   12 +
 libxfs/xfs_bmap.c             |   31 +-
 libxfs/xfs_btree.c            |    6 
 libxfs/xfs_btree.h            |   12 -
 libxfs/xfs_defer.c            |    1 
 libxfs/xfs_defer.h            |    1 
 libxfs/xfs_format.h           |   25 +
 libxfs/xfs_fs.h               |    4 
 libxfs/xfs_health.h           |    4 
 libxfs/xfs_inode_buf.c        |   34 +-
 libxfs/xfs_inode_fork.c       |   13 +
 libxfs/xfs_log_format.h       |    5 
 libxfs/xfs_refcount.c         |  314 ++++++++++++----
 libxfs/xfs_refcount.h         |   25 +
 libxfs/xfs_rmap.c             |   14 +
 libxfs/xfs_rtgroup.c          |   10 +
 libxfs/xfs_rtgroup.h          |    8 
 libxfs/xfs_rtrefcount_btree.c |  809 +++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrefcount_btree.h |  195 ++++++++++
 libxfs/xfs_rtrmap_btree.c     |   28 +
 libxfs/xfs_sb.c               |    8 
 libxfs/xfs_shared.h           |    2 
 libxfs/xfs_trans_inode.c      |   14 +
 libxfs/xfs_trans_resv.c       |   25 +
 libxfs/xfs_types.h            |    5 
 man/man8/xfs_db.8             |   49 ++
 mkfs/proto.c                  |   44 ++
 mkfs/xfs_mkfs.c               |   79 ++++
 repair/Makefile               |    1 
 repair/agbtree.c              |    4 
 repair/dino_chunks.c          |   11 +
 repair/dinode.c               |  266 ++++++++++++-
 repair/dir2.c                 |    2 
 repair/incore.h               |    1 
 repair/phase2.c               |   75 ++++
 repair/phase4.c               |   30 +-
 repair/phase6.c               |  115 ++++++
 repair/rmap.c                 |  327 ++++++++++++++---
 repair/rmap.h                 |   17 +
 repair/rtrefcount_repair.c    |  248 +++++++++++++
 repair/scan.c                 |  324 ++++++++++++++++
 repair/scan.h                 |   33 ++
 scrub/repair.c                |    1 
 spaceman/health.c             |   10 +
 64 files changed, 3792 insertions(+), 278 deletions(-)
 create mode 100644 libxfs/xfs_rtrefcount_btree.c
 create mode 100644 libxfs/xfs_rtrefcount_btree.h
 create mode 100644 repair/rtrefcount_repair.c

