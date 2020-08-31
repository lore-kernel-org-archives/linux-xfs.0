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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 993B8C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FBD9206E3
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:00:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z5iLr8i1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgHaNAx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 09:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgHaNAi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 09:00:38 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6542C061573
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 06:00:36 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id w7so531013pfi.4
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 06:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1NaHAwYD6+xgOubZKgGY9YdvFZIj8ixnT+DR1IdpTgA=;
        b=Z5iLr8i1SYxI1Bq0/MJbzSomnJfR96ACFs/gTdsRbNWvvG5JskY9mGOJ/zL2GLKv9h
         VPwPgB17BYkFz0N/jRMHUgrrqZyZhhzEQDu+8IsLbZBzll3xAk6i0pEueTrVPEgRc8c3
         rtgpTSNhY+j7iM5wDF+bnuzCEmpbskhoV5ab+Tgk2W9NXKv610tHEGAWlVzzUbvbAB25
         TXzwecZOsMeCh0m7I0JKWvDcl3G05hJnlOlzd9cHGwlaVlMCp+znmxao2V12qFN6AOmg
         02v4a104h0Jrbiuq0Rvahg1A/rRc5ztye4FgjbM8WCr2jCSe5J1OZuoFc3XbhVRnTDaF
         0Z6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1NaHAwYD6+xgOubZKgGY9YdvFZIj8ixnT+DR1IdpTgA=;
        b=rFJQQiB0K1vsxRPJuC3imOKA+XbyZtJcdRPjHNdSpPPaqrrrJksyeM8toM5HI+RUK7
         4Rupz3hmAgWPm+WBDOb2XFZC1ExQr3a6jyNrs/7PG1ZVrFTRp85hnYrJ4mZECHsmPC1z
         6KVjXpz+kcV/zurtrcIzEbJ9/stRbMrh8TZWqS6m7+x8MqDKzYpW7eD+txbmYPWXI3rk
         S1sGX0YpjjTA17K8Ua339aPY4lLGcBJZs/JckfteA+SOFtWrsjmCib91EIE6+It/82fT
         rYd8Nj8bzoxfnq2OL88ytFXVW2sbit4OqOMA87skR2j3Tycdl/lp6eNZJDDjiN9ZNfft
         7JVQ==
X-Gm-Message-State: AOAM533gMjibE7R0MWYYKj7wKkMxny2w0fkKUsVKpatAK5kXrRRgLTwG
        0Wd49WIWrd0xY14anwPQ+IVGDlTNtOs=
X-Google-Smtp-Source: ABdhPJxeEqz/5GhL1w/BAAbDLfwFsQylY6TnjSTv8IeWaUsHaWnC2bxj9cf5MpV9Hux3MIXXnEJfuQ==
X-Received: by 2002:aa7:8b01:: with SMTP id f1mr1104443pfd.35.1598878835859;
        Mon, 31 Aug 2020 06:00:35 -0700 (PDT)
Received: from localhost.localdomain ([122.167.36.194])
        by smtp.gmail.com with ESMTPSA id p190sm8296130pfp.9.2020.08.31.06.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 06:00:35 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, david@fromorbit.com,
        darrick.wong@oracle.com, bfoster@redhat.com
Subject: [PATCH 0/3] xfs: Extend per-inode extent counters
Date:   Mon, 31 Aug 2020 18:30:07 +0530
Message-Id: <20200831130010.454-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The commit xfs: fix inode fork extent count overflow
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

I did try in vain to get this done in a seamless way (i.e. setting an
ro-compat flag just in time when extent counter is about to
overflow). The maximum height of data and attr BMBT trees are a
function of maximum number of per-inode data and attr extents
respectively. Due to increase in the maximum value of data/attr
extents, the maximum height of the data/attr BMBT tree increased
causing the dependent log reservation values to increase as well.

Increased log reservation values caused "minimum log reservation size"
check to fail in some scenarios and hence mount syscall would return
with an error. Reducing log reservation values by making the
corresponding calculations more precise is not an option since these
code changes, once percolated to mkfs.xfs, could create filesystems
that won't mount on older kernels (Please refer to the discussion at
https://www.spinics.net/lists/linux-xfs/msg42061.html).

The patchset has been tested by executing xfstests with the following
mkfs.xfs options,
1. -m crc=0 -b size=1k
2. -m crc=0 -b size=4k
3. -m crc=0 -b size=512
4. -m rmapbt=1,reflink=1 -b size=1k
5. -m rmapbt=1,reflink=1 -b size=4k

Each of the above test scenarios were executed on the following
combinations (For V4 FS test scenario, the last combination
i.e. "Patched (enable widextcnt)", was omitted).
|-----------------------------+-----------|
| Xfsprogs                    | Kernel    |
|-----------------------------+-----------|
| Unpatched                   | Patched   |
| Patched (disable widextcnt) | Unpatched |
| Patched (disable widextcnt) | Patched   |
| Patched (enable widextcnt)  | Patched   |
|-----------------------------+-----------|

This patchset is built on top of V3 of "Bail out if transaction can
cause extent count to overflow" patchset.  It can also be obtained
from https://github.com/chandanr/linux.git at branch
xfs-incompat-extend-extcnt-v1.

I will be posting the changes associated with xfsprogs separately.

Chandan Babu R (3):
  xfs: Introduce xfs_iext_max() helper
  xfs: Introduce xfs_dfork_nextents() helper
  xfs: Extend data/attr fork extent counter width

 fs/xfs/libxfs/xfs_bmap.c        | 17 ++++----
 fs/xfs/libxfs/xfs_format.h      | 24 +++++++-----
 fs/xfs/libxfs/xfs_inode_buf.c   | 69 ++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_inode_buf.h   |  6 ++-
 fs/xfs/libxfs/xfs_inode_fork.c  | 10 +++--
 fs/xfs/libxfs/xfs_inode_fork.h  | 19 ++++++++-
 fs/xfs/libxfs/xfs_log_format.h  |  8 ++--
 fs/xfs/libxfs/xfs_types.h       | 10 +++--
 fs/xfs/scrub/inode.c            | 14 ++++---
 fs/xfs/xfs_inode.c              |  2 +-
 fs/xfs/xfs_inode_item.c         | 12 +++++-
 fs/xfs/xfs_inode_item_recover.c | 20 +++++++---
 12 files changed, 153 insertions(+), 58 deletions(-)

-- 
2.28.0

