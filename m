Return-Path: <SRS0=3UjW=7T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAAEBC433E0
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Jun 2020 08:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B34A2207D0
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Jun 2020 08:28:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DeBs6868"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgFFI2M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 6 Jun 2020 04:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgFFI2I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Jun 2020 04:28:08 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7047DC08C5C2
        for <linux-xfs@vger.kernel.org>; Sat,  6 Jun 2020 01:28:07 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t7so4649256plr.0
        for <linux-xfs@vger.kernel.org>; Sat, 06 Jun 2020 01:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kH70iubb+SrzVt2ggRBRYnaYEXSYyMdi3LLISawmm/g=;
        b=DeBs6868Y1bW2OxzebKPIOa9wuwQd/HcbowMRI/hddeRARwpfKgvPB3YfcJXCueLto
         Xmlc9lQ56QbYeyBgTrFcIF5Sr0KyUf7Nq5BydK4i62Ic5ONHhVwvQsftsEqbf7ngPbdD
         acTFlKhH5zNu7Ea9aACwfH7SQkxGMd9dAO5tWYlBHCwFAnCRd13C6yHpsEQT/ihxb8Ds
         SyYa+OTY6Oylb97m8TtQxbCq5ah1NtmK8z9MmjLTh5g5QVwz+Xm0UV2uL05x8EyVPGyz
         nrdXAbjFW2e/vjSxBrQ0/G+Nec8AK4mMu9IBrKCPhwNBTKad03AfLK9l6B725iGTI7wY
         Nk+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kH70iubb+SrzVt2ggRBRYnaYEXSYyMdi3LLISawmm/g=;
        b=SMcED4psqF+91rz/lS5HpWFGV0WP2wlSDNsXENhu06BoXWs98QXFlvHK6NP3sY0kX4
         cPO182zNLKx3tPj0F2bEdr6EUVTFjm7lhDs1eat1zjF9tU+sPtPE/h3FSkmMON8ntBxu
         H9BwCqdxPYtd/KpycWRZ2Fk4kDFTgNPy/yTDRV4SvTVCDaXJWGZBeTSv0ERxFJZ07xf2
         lxDJrGPUTjpW46G0MXl7+uS9cNAA3pj7Odz2aM7GBRYumUenCDCFDgItbnYkGqE67Fjw
         dmTcPw4HfinfRr+VSI6DT+Nsa1jgn+mfIal3FMvFpiMsrf8Ovme+ka+Ez4HFrZ81yTrs
         pgGA==
X-Gm-Message-State: AOAM533xYiuy9bTj96RdXZ6PS9N6xWhfOfG89J7FktTUGtgSykgDz3P8
        tn1e/feHgLKy1s65HV1wWZvJsStW
X-Google-Smtp-Source: ABdhPJxkLoIZZeVRruMyNeQm3XNCig95Ih+okK1304nvTIJXxjjhRfVn6peOdvyvDE/LzALWAgfuEw==
X-Received: by 2002:a17:90b:915:: with SMTP id bo21mr7159007pjb.52.1591432086162;
        Sat, 06 Jun 2020 01:28:06 -0700 (PDT)
Received: from localhost.localdomain ([122.167.144.243])
        by smtp.gmail.com with ESMTPSA id j3sm1678130pfh.87.2020.06.06.01.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2020 01:28:05 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, david@fromorbit.com,
        darrick.wong@oracle.com, bfoster@redhat.com, hch@infradead.org
Subject: [PATCH 0/7] xfs: Extend per-inode extent counters.
Date:   Sat,  6 Jun 2020 13:57:38 +0530
Message-Id: <20200606082745.15174-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The commit xfs: fix inode fork extent count overflow
(3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08) mentions that 10 billion
per-inode data fork extents should be possible to create. However the
corresponding on-disk field has an signed 32-bit type. Hence this
patchset extends the on-disk field to 64-bit length out of which only
the first 47-bits are valid.

Also, XFS has a per-inode xattr extent counter which is 16 bits
wide. A workload which
1. Creates 1 million 255-byte sized xattrs,
2. Deletes 50% of these xattrs in an alternating manner,
3. Tries to insert 400,000 new 255-byte sized xattrs
causes the following message to be printed on the console,

XFS (loop0): xfs_iflush_int: detected corrupt incore inode 131, total extents = -19916, nblocks = 102937, ptr ffff9ce33b098c00
XFS (loop0): xfs_do_force_shutdown(0x8) called from line 3739 of file fs/xfs/xfs_inode.c. Return address = ffffffffa4a94173

This indicates that we overflowed the 16-bits wide xattr extent
counter.

I have been informed that there are instances where a single file
has > 100 million hardlinks. With parent pointers being stored in xattr,
we will overflow the 16-bits wide xattr extent counter when large
number of hardlinks are created. Hence this patchset extends the
on-disk field to 32-bit length.

This patchset also includes the previously posted "Fix log reservation
calculation for xattr insert operation" patch as a bug fix. It
replaces the xattr set "mount" and "runtime" reservations with just
one static reservation. Hence we don't need the functionality to
calculate maximum sized 'xattr set' reservation separately anymore.

The patches can also be obtained from
https://github.com/chandanr/linux.git at branch xfs-extend-extent-counters.

Chandan Babu R (7):
  xfs: Fix log reservation calculation for xattr insert operation
  xfs: Check for per-inode extent count overflow
  xfs: Compute maximum height of directory BMBT separately
  xfs: Add "Use Dir BMBT height" argument to XFS_BM_MAXLEVELS()
  xfs: Use 2^27 as the maximum number of directory extents
  xfs: Extend data extent counter to 47 bits
  xfs: Extend attr extent counter to 32 bits

 fs/xfs/libxfs/xfs_attr.c        |  11 +--
 fs/xfs/libxfs/xfs_bmap.c        | 118 +++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_bmap.h        |   3 +-
 fs/xfs/libxfs/xfs_bmap_btree.h  |   4 +-
 fs/xfs/libxfs/xfs_format.h      |  49 ++++++++++---
 fs/xfs/libxfs/xfs_inode_buf.c   |  65 ++++++++++++++---
 fs/xfs/libxfs/xfs_inode_buf.h   |   2 +
 fs/xfs/libxfs/xfs_inode_fork.c  | 125 ++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_inode_fork.h  |   2 +
 fs/xfs/libxfs/xfs_log_format.h  |   8 +-
 fs/xfs/libxfs/xfs_log_rlimit.c  |  29 --------
 fs/xfs/libxfs/xfs_trans_resv.c  |  75 +++++++++----------
 fs/xfs/libxfs/xfs_trans_resv.h  |   9 +--
 fs/xfs/libxfs/xfs_trans_space.h |  48 ++++++------
 fs/xfs/libxfs/xfs_types.h       |  11 ++-
 fs/xfs/scrub/inode.c            |  14 ++--
 fs/xfs/xfs_bmap_item.c          |   3 +-
 fs/xfs/xfs_inode.c              |  10 ++-
 fs/xfs/xfs_inode_item.c         |  10 ++-
 fs/xfs/xfs_inode_item_recover.c |  22 +++++-
 fs/xfs/xfs_mount.c              |   5 +-
 fs/xfs/xfs_mount.h              |   1 +
 fs/xfs/xfs_reflink.c            |   4 +-
 23 files changed, 451 insertions(+), 177 deletions(-)

-- 
2.20.1

