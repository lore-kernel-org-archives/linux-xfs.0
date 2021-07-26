Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D707EC4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3DFE603E9
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbhGZLFZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233320AbhGZLFZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 07:05:25 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B1EC061757
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:45:53 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id i1so11216076plr.9
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sKdSOJOexGkuZcOm5PAxQDn69gESiI+M/qrUI6USnvs=;
        b=EgyDdAtkgYWehusApD7M7XsdB85koZXALEeJoKII29fwCArXbeQJBv53au71D24nrO
         4GoIXWcRcL5fyTXrxTwafXfALPgDQ0HBbyNRp9q7Ssnah+Os7wTfG45MqtERiHWN+cIq
         n05fwY6CSpbMjE4dvUvtiVuPlje0cIn6IqRyjS7WaL3J2fk2gTBYgsLW3ZQGq/Jj25Ps
         uJzCousMSbEsaxNt66F8tzR8DRgWV82lrXTm3Gpjk4w4NJ3r+wtbsI45hj1AQrmmdaRx
         G7WuT10TOd0IYUt4FZsUDjtPbyv9JZWnjOdBxHYuTxrEux2oeK2BAXP///VtbkWXFcJz
         xxJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sKdSOJOexGkuZcOm5PAxQDn69gESiI+M/qrUI6USnvs=;
        b=NjcU8Y4mcseYFlmFv2LR51iJSqqKTa3V4SE+GxQvSb4GoWSS/mF62zAyQQki1tgkAl
         hxFUyDw12Pp92b3PoKwoP51QgiSL+C7fYuj5FER5jmExLdtr8NeofKhcy+wYJLOuQNOG
         e0Ismq981awRtpdv+CnRskoUhaR7Hl1qizKX8DhD3MPjXH+8Lkrao3avjblZStTowf+h
         qgmxDI6bVLJRCODdAvt7hZZFHLyppuTjcpl6eJOssoTyqAvP5cMMjO3OyBR7XoRQKVW/
         WPW9OtLf5q7ehRxUccwJi/oanEj52FsGdThU4tPNNUBVeOhSq8tsoodM+yaAGqDEuqHq
         z9cw==
X-Gm-Message-State: AOAM531NpY3LMGCqNFLTtHcNgeUGkX0JZtFX7b6ulBc0qw6JDSXyXcpg
        oA9QO0wnzr5XUDD+4chlPsd34khi/nw=
X-Google-Smtp-Source: ABdhPJzc/ZU3h/EaoU1aXHoou990c2RnaEFxZplnCTNOA4DD9eVrEQpCNqQc4qLd/zEc6V04fUIfzw==
X-Received: by 2002:a05:6a00:124b:b029:358:fcd2:fa37 with SMTP id u11-20020a056a00124bb0290358fcd2fa37mr17303407pfi.35.1627299952499;
        Mon, 26 Jul 2021 04:45:52 -0700 (PDT)
Received: from localhost.localdomain ([122.179.41.55])
        by smtp.gmail.com with ESMTPSA id k8sm50833919pgr.91.2021.07.26.04.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:45:52 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2 00/12] xfs: Extend per-inode extent counters
Date:   Mon, 26 Jul 2021 17:15:29 +0530
Message-Id: <20210726114541.24898-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The commit xfs: fix inode fork extent count overflow
(3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08) mentions that 10 billion
data fork extents should be possible to create. However the
corresponding on-disk field has a signed 32-bit type. Hence this
patchset extends the per-inode data extent counter to 64 bits out of
which 48 bits are used to store the extent count. 

Also, XFS has an attr fork extent counter which is 16 bits wide. A
workload which,
1. Creates 1 million 255-byte sized xattrs,
2. Deletes 50% of these xattrs in an alternating manner,
3. Tries to insert 400,000 new 255-byte sized xattrs
   causes the xattr extent counter to overflow.

Dave tells me that there are instances where a single file has more
than 100 million hardlinks. With parent pointers being stored in
xattrs, we will overflow the signed 16-bits wide xattr extent counter
when large number of hardlinks are created. Hence this patchset
extends the on-disk field to 32-bits.

The following changes are made to accomplish this,
1. A new incompat superblock flag to prevent older kernels from mounting
   the filesystem. This flag has to be set during mkfs time.
2. A new 64-bit inode field is created to hold the data extent
   counter.
3. The existing 32-bit inode data extent counter will be used to hold
   the attr fork extent counter.

The patchset has been tested by executing xfstests with the following
mkfs.xfs options,
1. -m crc=0 -b size=1k
2. -m crc=0 -b size=4k
3. -m crc=0 -b size=512
4. -m rmapbt=1,reflink=1 -b size=1k
5. -m rmapbt=1,reflink=1 -b size=4k

Each of the above test scenarios were executed on the following
combinations (For V4 FS test scenario, the last combination
i.e. "Patched (enable extcnt64bit)", was omitted).
|-------------------------------+-----------|
| Xfsprogs                      | Kernel    |
|-------------------------------+-----------|
| Unpatched                     | Patched   |
| Patched (disable extcnt64bit) | Unpatched |
| Patched (disable extcnt64bit) | Patched   |
| Patched (enable extcnt64bit)  | Patched   |
|-------------------------------+-----------|

I have also written a test (yet to be converted into xfstests format)
to check if the correct extent counter fields are updated with/without
the new incompat flag. I have also fixed some of the existing fstests
to work with the new extent counter fields.

Increasing data extent counter width also causes the maximum height of
BMBT to increase. This requires that the macro XFS_BTREE_MAXLEVELS be
updated with a larger value. However such a change causes the value of
mp->m_rmap_maxlevels to increase which in turn causes log reservation
sizes to increase and hence a modified XFS driver will fail to mount
filesystems created by older versions of mkfs.xfs.

Hence this patchset is built on top of Darrick's btree-dynamic-depth
branch which removes the macro XFS_BTREE_MAXLEVELS and computes
mp->m_rmap_maxlevels based on the size of an AG.

These patches can also be obtained from
https://github.com/chandanr/linux.git at branch
xfs-incompat-extend-extcnt-v2.

I will be posting the changes associated with xfsprogs separately.

Changelog:
V1 -> V2:
1. Rebase patches on top of Darrick's btree-dynamic-depth branch.
2. Add new bulkstat ioctl version to support 64-bit data fork extent
   counter field.
3. Introduce new error tag to verify if the old bulkstat ioctls skip
   reporting inodes with large data fork extent counters.

Chandan Babu R (12):
  xfs: Move extent count limits to xfs_format.h
  xfs: Rename MAXEXTNUM, MAXAEXTNUM to XFS_IFORK_EXTCNT_MAXS32,
    XFS_IFORK_EXTCNT_MAXS16
  xfs: Introduce xfs_iext_max() helper
  xfs: Use xfs_extnum_t instead of basic data types
  xfs: Introduce xfs_dfork_nextents() helper
  xfs: xfs_dfork_nextents: Return extent count via an out argument
  xfs: Rename inode's extent counter fields based on their width
  xfs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits
    respectively
  xfs: Rename XFS_IOC_BULKSTAT to XFS_IOC_BULKSTAT_V5
  xfs: Enable bulkstat ioctl to support 64-bit extent counters
  xfs: Extend per-inode extent counter widths
  xfs: Error tag to test if v5 bulkstat skips inodes with large extent
    count

 fs/xfs/libxfs/xfs_bmap.c        | 21 +++----
 fs/xfs/libxfs/xfs_errortag.h    |  4 +-
 fs/xfs/libxfs/xfs_format.h      | 42 +++++++++++---
 fs/xfs/libxfs/xfs_fs.h          |  9 ++-
 fs/xfs/libxfs/xfs_inode_buf.c   | 82 ++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_inode_buf.h   |  2 +
 fs/xfs/libxfs/xfs_inode_fork.c  | 35 +++++++++---
 fs/xfs/libxfs/xfs_inode_fork.h  | 22 +++++++-
 fs/xfs/libxfs/xfs_log_format.h  |  7 ++-
 fs/xfs/libxfs/xfs_types.h       | 11 +---
 fs/xfs/scrub/attr_repair.c      |  2 +-
 fs/xfs/scrub/inode.c            | 97 ++++++++++++++++++++-------------
 fs/xfs/scrub/inode_repair.c     | 71 +++++++++++++++++-------
 fs/xfs/scrub/trace.h            | 16 +++---
 fs/xfs/xfs_error.c              |  3 +
 fs/xfs/xfs_inode.c              |  4 +-
 fs/xfs/xfs_inode_item.c         | 15 ++++-
 fs/xfs/xfs_inode_item_recover.c | 25 +++++++--
 fs/xfs/xfs_ioctl.c              | 33 +++++++++--
 fs/xfs/xfs_ioctl32.c            |  7 +++
 fs/xfs/xfs_itable.c             | 35 ++++++++++--
 fs/xfs/xfs_itable.h             |  1 +
 fs/xfs/xfs_trace.h              |  6 +-
 23 files changed, 402 insertions(+), 148 deletions(-)

-- 
2.30.2

