Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304DEC43461
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 065C7206E3
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:01:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J0eCGajd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgHaNB0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 09:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbgHaNBP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 09:01:15 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F03C061573
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 06:01:14 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x18so1767441pll.6
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 06:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/H2AQdlE9Zs4IXg+p7RSnScU4Gla+WjvRm6hWNZqHFc=;
        b=J0eCGajdQ2PXlOSyyN4+LflJt/ioiQWr0i6WVu7aHIm8n0hY4i53E+yO9CIPL0AA1I
         oYMtVDMAB5HBSJmDtQ4H2rEaw4PD7GZVkxcMVqtaKUb9buF7l/SErIE722w3EbGb06LZ
         C6UGOkQlKCFJh8PUZQ3Nk1oiCB9NHV4gCzBjbZJqeWKvBVoOxqYW+WTSfeXp/Bsf5rK1
         PrxC6FGpH96BpzllhQI1H0Fr/y5WFbWJ+HY2mOGipYfCF5PkGRTE1TbG2hgMZY9G4S6h
         Y4oogR70STej2joUFtRes3gwtSrWvJFqeguJIwVHTcdo6rCyAv4SpmcecxHVSUcWSc3M
         bzFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/H2AQdlE9Zs4IXg+p7RSnScU4Gla+WjvRm6hWNZqHFc=;
        b=CihaOF+0K1O3c9pbuAO5mlX0LBQ83FILn+TFDoyX6R7M5G4q/OlUF7LTb1UtKum+s9
         6tvsT6GN6iCmPm8rZ++1wONJIl3RVR3kMDNwuYtUHa2Qo2NH927HfNT1YVWy9aKSv8Y5
         ydhZpvauesAn2Lh/W1Ce7KxI8Z3n4RmLOQ+CT9NirkO/mXEcSy7aA1Uz3Uf8ksw3QoJM
         clQ/06H6dFo68PIVn6BIK9PsXDZO8o/3Jgrl8Qn8a+iC0wMc0BS/iPTgWlXQkqoAYDRa
         EAzTUVVF0hrNSK96z02OHMjfYcQNzEQC5oRmNpnDYdUWUUdzY1mXwhj96z8Z0LJaGO6I
         seqA==
X-Gm-Message-State: AOAM53291jNAQhXA99cGTswp0U1/JIO3Aqw+pek+pkpiQ56d10kD2kEF
        MWaTpOymedwv8Xju8UpxH2f1uFUp/PE=
X-Google-Smtp-Source: ABdhPJyK7Zd2RjhduCpf4lXIhWfmqsGhBGsdarU/zbdC9BOZip+YeTc4AQlH4NEAlQTAsqE5QSswmg==
X-Received: by 2002:a17:90a:e017:: with SMTP id u23mr1287132pjy.96.1598878873376;
        Mon, 31 Aug 2020 06:01:13 -0700 (PDT)
Received: from localhost.localdomain ([122.167.36.194])
        by smtp.gmail.com with ESMTPSA id o2sm7643220pjh.4.2020.08.31.06.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 06:01:12 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, david@fromorbit.com,
        darrick.wong@oracle.com, bfoster@redhat.com
Subject: [PATCH 0/4] xfsprogs: Extend per-inode extent counters
Date:   Mon, 31 Aug 2020 18:30:58 +0530
Message-Id: <20200831130102.507-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The kernel commit xfs: fix inode fork extent count overflow
(3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08) mentions that 10 billion
data fork extents should be possible to create. However the
corresponding on-disk field has a signed 32-bit type. Hence this
patchset extends the per-inode data extent counter to 47 bits. The
length of 47-bits was chosen because,
Maximum file size = 2^63.
Maximum extent count when using 64k block size = 2^63 / 2^16 = 2^47.

Also, XFS has a per-inode xattr extent counter which is 16 bits
wide. A workload which
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
2. Carve out a new 32-bit field from xfs_dinode->di_pad2[]. This field
   holds the most significant 15 bits of the data extent counter.
3. Carve out a new 16-bit field from xfs_dinode->di_pad2[]. This field
   holds the most significant 16 bits of the attr extent counter.

This patchset can also be obtained from
https://github.com/chandanr/xfsprogs-dev.git at branch
xfs-incompat-extend-extcnt-v1.

Chandan Babu R (4):
  xfsprogs: Introduce xfs_iext_max() helper
  xfsprogs: Introduce xfs_dfork_nextents() helper
  xfsprogs: Extend data/attr fork extent counter width
  xfsprogs: Add wideextcnt mkfs option

 db/bmap.c                  |  8 +--
 db/btdump.c                |  4 +-
 db/check.c                 |  2 +-
 db/field.c                 |  4 --
 db/field.h                 |  2 -
 db/frag.c                  |  8 +--
 db/inode.c                 | 31 +++++++++---
 db/metadump.c              |  4 +-
 include/libxlog.h          |  6 ++-
 libxfs/xfs_bmap.c          | 21 ++++----
 libxfs/xfs_format.h        | 24 +++++----
 libxfs/xfs_inode_buf.c     | 78 +++++++++++++++++++++++-------
 libxfs/xfs_inode_buf.h     |  6 ++-
 libxfs/xfs_inode_fork.c    |  7 +--
 libxfs/xfs_inode_fork.h    | 17 +++++++
 libxfs/xfs_log_format.h    |  8 +--
 libxfs/xfs_types.h         |  6 ++-
 logprint/log_misc.c        | 21 ++++++--
 logprint/log_print_all.c   | 30 +++++++++---
 logprint/log_print_trans.c |  2 +-
 man/man8/mkfs.xfs.8        |  7 +++
 mkfs/xfs_mkfs.c            | 23 +++++++++
 repair/attr_repair.c       |  2 +-
 repair/dinode.c            | 99 ++++++++++++++++++++++----------------
 repair/prefetch.c          |  2 +-
 25 files changed, 292 insertions(+), 130 deletions(-)

-- 
2.28.0

