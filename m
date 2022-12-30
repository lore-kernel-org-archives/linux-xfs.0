Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7565C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235915AbiLaBCF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbiLaBCD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:02:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29901DDE4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:02:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D33161D6A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA089C433EF;
        Sat, 31 Dec 2022 01:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448522;
        bh=k6xOT6pr1AAFrr2fvMded4HyUqQMBidgyodbQqU3HzU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=c3lcTPMWEKwS6c4R+LE8fqQH+3/mu4KBv95rgGjj91b8pQxJe/dXGSs1Sgx+dpLK6
         l2EkVClPrSQpu/Ugfqkn6DUnr1N8XQ33AHbIq8U+VxdWK+h8Gc1QPYr1w3mEUdSpyU
         7aiFlEh0DN7L5zW2gjBeGQxPbXMNVc8M47touVuUnFipegR0gc87blisBx4bPz/0DF
         mEtROmMukPHrh6LgwKe4eiaiq5Ccw47N+FDBjdxT8Ck7z2Le2TZyJX9LrHKKFZTnqP
         gbEjjlcQG51RVKJFB0m/nPpamOHHOOBQnHTSZ1AoZ6IeOVGv3wviBmtX97je7DslER
         h/3XDErCj50rw==
Subject: [PATCHSET v1.0 00/41] libxfs: realtime reverse-mapping support
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:55 -0800
Message-ID: <167243879574.732820.4725863402652761218.stgit@magnolia>
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

Add libxfs code from the kernel, then teach the various utilities about
how to access realtime rmapbt information and rebuild it.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-rmap

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-rmap

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-rmap

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-rmap
---
 db/bmroot.c               |  149 ++++++
 db/bmroot.h               |    2 
 db/btblock.c              |  103 ++++
 db/btblock.h              |    5 
 db/btdump.c               |   64 +++
 db/btheight.c             |    5 
 db/check.c                |  203 +++++++++
 db/field.c                |   11 
 db/field.h                |    5 
 db/fsmap.c                |  135 ++++++
 db/inode.c                |  113 +++++
 db/inode.h                |    4 
 db/metadump.c             |  125 +++++
 db/type.c                 |    5 
 db/type.h                 |    1 
 include/libxfs.h          |    2 
 include/xfs_mount.h       |   14 +
 libfrog/scrub.c           |    5 
 libxfs/Makefile           |    2 
 libxfs/defer_item.c       |   28 +
 libxfs/init.c             |   20 -
 libxfs/libxfs_api_defs.h  |   19 +
 libxfs/rdwr.c             |    2 
 libxfs/trans.c            |    1 
 libxfs/xfbtree.c          |    2 
 libxfs/xfs_bmap.c         |   22 +
 libxfs/xfs_btree.c        |  120 +++++
 libxfs/xfs_btree.h        |    7 
 libxfs/xfs_defer.c        |    1 
 libxfs/xfs_defer.h        |    1 
 libxfs/xfs_format.h       |   24 +
 libxfs/xfs_fs.h           |    4 
 libxfs/xfs_health.h       |    4 
 libxfs/xfs_imeta.c        |    6 
 libxfs/xfs_inode_buf.c    |    6 
 libxfs/xfs_inode_fork.c   |   13 +
 libxfs/xfs_log_format.h   |    4 
 libxfs/xfs_refcount.c     |    6 
 libxfs/xfs_rmap.c         |  227 ++++++++--
 libxfs/xfs_rmap.h         |   22 +
 libxfs/xfs_rtgroup.c      |   12 +
 libxfs/xfs_rtgroup.h      |   20 +
 libxfs/xfs_rtrmap_btree.c | 1033 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrmap_btree.h |  218 +++++++++
 libxfs/xfs_sb.c           |    6 
 libxfs/xfs_shared.h       |    2 
 libxfs/xfs_swapext.c      |    4 
 libxfs/xfs_trans_resv.c   |   12 -
 libxfs/xfs_trans_space.h  |   13 +
 libxfs/xfs_types.h        |    5 
 man/man8/xfs_db.8         |   63 +++
 mkfs/proto.c              |   62 +++
 mkfs/xfs_mkfs.c           |   90 ++++
 repair/Makefile           |    1 
 repair/agbtree.c          |    5 
 repair/bmap_repair.c      |  122 +++++
 repair/dino_chunks.c      |   13 +
 repair/dinode.c           |  373 ++++++++++++++--
 repair/dir2.c             |    4 
 repair/incore.h           |    1 
 repair/phase2.c           |   92 ++++
 repair/phase4.c           |   12 +
 repair/phase6.c           |  178 ++++++++
 repair/rmap.c             |  482 +++++++++++++++++----
 repair/rmap.h             |   15 -
 repair/rtrmap_repair.c    |  253 +++++++++++
 repair/scan.c             |  411 +++++++++++++++++-
 repair/scan.h             |   37 ++
 repair/xfs_repair.c       |    8 
 scrub/phase4.c            |   43 ++
 scrub/repair.c            |  124 +++++
 scrub/repair.h            |    5 
 spaceman/health.c         |   10 
 73 files changed, 4949 insertions(+), 272 deletions(-)
 create mode 100644 libxfs/xfs_rtrmap_btree.c
 create mode 100644 libxfs/xfs_rtrmap_btree.h
 create mode 100644 repair/rtrmap_repair.c

