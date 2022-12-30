Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3CC4C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiLaA66 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235677AbiLaA65 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:58:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47BB41C913
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:58:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9D6561D65
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D818C433EF;
        Sat, 31 Dec 2022 00:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448335;
        bh=rIxgfjmvLnACp9gAuhQ8u1cpNFl2QHXe0eT+d6hMdOo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fquyaFI3iO9eTw6h2Lq6DUkiv/WNfYqoRgit679zfHLcRKxJk6OoLRVyBP7Iw4oqa
         SgUDLaDQ/1Zv2V5rYA2aQA7vJi1Nq2uI87huWwAuJaHBsTDBFsP9ruMaIXPkbudxKr
         XsUGeJcJ7rFwlfghcZ9sdNpgdptmnhqMe9Qzx9vAQoPdpd6b32N5IaSgGf3DmO4m3q
         2k30JtDLraDW3z9ZleobSBWqsaC9Q+BWG6dp3N5iZ+L28bx8bK8DNlSRmht/21FlpF
         eWkkk3AXnAVqNlJwDwVQrc5WAQHjUGOF4rtA2A2JCr+eC2R87u9g3s2Bikvwyf0q50
         BxeFS6YFEuScA==
Subject: [PATCHSET v1.0 00/42] xfs: reflink on the realtime device
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:29 -0800
Message-ID: <167243870849.717073.203452386730176902.stgit@magnolia>
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
 fs/xfs/Makefile                      |    3 
 fs/xfs/libxfs/xfs_bmap.c             |   31 +
 fs/xfs/libxfs/xfs_btree.c            |    6 
 fs/xfs/libxfs/xfs_btree.h            |   12 -
 fs/xfs/libxfs/xfs_defer.c            |    1 
 fs/xfs/libxfs/xfs_defer.h            |    1 
 fs/xfs/libxfs/xfs_format.h           |   25 +
 fs/xfs/libxfs/xfs_fs.h               |    4 
 fs/xfs/libxfs/xfs_health.h           |    4 
 fs/xfs/libxfs/xfs_inode_buf.c        |   34 +
 fs/xfs/libxfs/xfs_inode_fork.c       |   13 +
 fs/xfs/libxfs/xfs_log_format.h       |    5 
 fs/xfs/libxfs/xfs_refcount.c         |  315 ++++++++++---
 fs/xfs/libxfs/xfs_refcount.h         |   25 +
 fs/xfs/libxfs/xfs_rmap.c             |   14 +
 fs/xfs/libxfs/xfs_rtgroup.c          |   10 
 fs/xfs/libxfs/xfs_rtgroup.h          |    8 
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |  811 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrefcount_btree.h |  195 ++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.c     |   28 +
 fs/xfs/libxfs/xfs_sb.c               |    8 
 fs/xfs/libxfs/xfs_shared.h           |    2 
 fs/xfs/libxfs/xfs_trans_inode.c      |   14 +
 fs/xfs/libxfs/xfs_trans_resv.c       |   25 +
 fs/xfs/libxfs/xfs_types.h            |    5 
 fs/xfs/scrub/bitmap.h                |   56 ++
 fs/xfs/scrub/bmap.c                  |   28 +
 fs/xfs/scrub/bmap_repair.c           |    3 
 fs/xfs/scrub/common.c                |   40 +-
 fs/xfs/scrub/common.h                |    5 
 fs/xfs/scrub/cow_repair.c            |  212 ++++++++-
 fs/xfs/scrub/health.c                |    1 
 fs/xfs/scrub/inode.c                 |   32 +
 fs/xfs/scrub/inode_repair.c          |   27 +
 fs/xfs/scrub/quota.c                 |    8 
 fs/xfs/scrub/quota_repair.c          |    2 
 fs/xfs/scrub/reap.c                  |  224 +++++++++
 fs/xfs/scrub/reap.h                  |    7 
 fs/xfs/scrub/refcount.c              |    2 
 fs/xfs/scrub/refcount_repair.c       |    4 
 fs/xfs/scrub/repair.c                |   27 +
 fs/xfs/scrub/repair.h                |    9 
 fs/xfs/scrub/rmap_repair.c           |   36 ++
 fs/xfs/scrub/rtbitmap.c              |    2 
 fs/xfs/scrub/rtbitmap_repair.c       |   21 +
 fs/xfs/scrub/rtrefcount.c            |  669 ++++++++++++++++++++++++++++
 fs/xfs/scrub/rtrefcount_repair.c     |  783 +++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rtrmap.c                |   54 ++
 fs/xfs/scrub/rtrmap_repair.c         |  104 ++++
 fs/xfs/scrub/scrub.c                 |    7 
 fs/xfs/scrub/scrub.h                 |   12 +
 fs/xfs/scrub/trace.h                 |  108 ++++-
 fs/xfs/xfs_bmap_util.c               |   66 ++-
 fs/xfs/xfs_buf_item_recover.c        |    4 
 fs/xfs/xfs_fsmap.c                   |   22 +
 fs/xfs/xfs_fsops.c                   |    2 
 fs/xfs/xfs_health.c                  |    4 
 fs/xfs/xfs_inode.c                   |   13 +
 fs/xfs/xfs_inode_item.c              |    2 
 fs/xfs/xfs_inode_item_recover.c      |    5 
 fs/xfs/xfs_ioctl.c                   |   21 +
 fs/xfs/xfs_mount.c                   |    7 
 fs/xfs/xfs_mount.h                   |    9 
 fs/xfs/xfs_ondisk.h                  |    2 
 fs/xfs/xfs_quota.h                   |    6 
 fs/xfs/xfs_refcount_item.c           |   35 +
 fs/xfs/xfs_reflink.c                 |  231 ++++++++--
 fs/xfs/xfs_rtalloc.c                 |  154 ++++++
 fs/xfs/xfs_super.c                   |   19 +
 fs/xfs/xfs_trace.c                   |    9 
 fs/xfs/xfs_trace.h                   |  116 +++--
 fs/xfs/xfs_trans_dquot.c             |   11 
 72 files changed, 4495 insertions(+), 325 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtrefcount_btree.c
 create mode 100644 fs/xfs/libxfs/xfs_rtrefcount_btree.h
 create mode 100644 fs/xfs/scrub/rtrefcount.c
 create mode 100644 fs/xfs/scrub/rtrefcount_repair.c

