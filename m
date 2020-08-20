Return-Path: <SRS0=hW3p=B6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC923C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 05:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF6CD2075E
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 05:44:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PVpUe+QK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725780AbgHTFoI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 01:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgHTFoH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 01:44:07 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DB4C061757
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 22:44:07 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id i10so639281pgk.1
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 22:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mc8iXp81A5zmAZ+XR2IjnrN5ymixSkZDFPnOI5EP/+A=;
        b=PVpUe+QKthISTPWABzHIFOAdTNyG+do6cgxkhejosr+bq55M/8Sg3V2zl8Di0CNCAf
         XeMf9VlAom0Alv+A18JuJO5htVpoK2M4LetCF1W36MNkrR9BFSFbwEFXCSI2K8dSeDoG
         AJdo+Nr6lDL9wV+Yti+Ej9CM+a0cl6pBuZuzlyjQXtrKIeFLideS7ltjXY9Mci8VGYG+
         4lIdREX/Bkv4XWzg4+I1595CBQJktJLYtNs5gcyqigLg5/Et1Rmk+NDgMNdlaLQHBeKN
         Qn82Fc7prMrfyAQ2Qa+5dGkVJJrXuiYMqZKEtfgx10KuOhDkze3fcQUXggbWJJ/ZoJeF
         M5Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mc8iXp81A5zmAZ+XR2IjnrN5ymixSkZDFPnOI5EP/+A=;
        b=EzQaObM4WH1SCHDMVyWhID6F7iViRs2DWU1dAYv7e5Eee8pmqakpmcgt32TplNcia6
         oIctvKAQrpclJJ4iqvypk8i6Hrjez8ogi6LGq1oJNVKl6SzVlMKO32etqUcwHWHimsOT
         gLGKt9xZJUdhzULQ66aK3soBl1uctKqfN6GI+2VE/X3Thh7x+9ccK5ts6rfIu9jk9wVS
         ILjkUao1A0oonaqw4y8sX5Xf9kbxeE1VWjUFliXai5GEsaiLv5kh6GRykvWKouKLO9RR
         djF/WZTmu209HEZKJRYNlD5K2linPbB/cvu+8OySz//vbmbr2HMLD21jtTw/kP4Q4mlV
         I+Ig==
X-Gm-Message-State: AOAM533JiB9muy6Dy1S/HM9d11M/H+7lBrveRj/eaCxujiJbsBEdfRzI
        A5SvrRBzoQm1SedLg3SoEHa7S2HfylI=
X-Google-Smtp-Source: ABdhPJz9HrWfFMXXtzY/Ua/Wh5PiorqxXp9uFyVNXI8M930zmcrXuwfALVsoBUF0g4tso0cziNa9ow==
X-Received: by 2002:a63:920e:: with SMTP id o14mr1334470pgd.367.1597902246694;
        Wed, 19 Aug 2020 22:44:06 -0700 (PDT)
Received: from localhost.localdomain ([122.171.166.150])
        by smtp.gmail.com with ESMTPSA id l4sm1044034pgk.74.2020.08.19.22.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 22:44:05 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org
Subject: [PATCH V3 00/10] Bail out if transaction can cause extent count to overflow
Date:   Thu, 20 Aug 2020 11:13:39 +0530
Message-Id: <20200820054349.5525-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS does not check for possible overflow of per-inode extent counter
fields when adding extents to either data or attr fork.

For e.g.
1. Insert 5 million xattrs (each having a value size of 255 bytes) and
   then delete 50% of them in an alternating manner.

2. On a 4k block sized XFS filesystem instance, the above causes 98511
   extents to be created in the attr fork of the inode.

   xfsaild/loop0  2008 [003]  1475.127209: probe:xfs_inode_to_disk: (ffffffffa43fb6b0) if_nextents=98511 i_ino=131

3. The incore inode fork extent counter is a signed 32-bit
   quantity. However, the on-disk extent counter is an unsigned 16-bit
   quantity and hence cannot hold 98511 extents.

4. The following incorrect value is stored in the xattr extent counter,
   # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
   core.naextents = -32561

This patchset adds a new helper function
(i.e. xfs_iext_count_may_overflow()) to check for overflow of the
per-inode data and xattr extent counters and invokes it before
starting an fs operation (e.g. creating a new directory entry). With
this patchset applied, XFS detects counter overflows and returns with
an error rather than causing a silent corruption.

The patchset has been tested by executing xfstests with the following
mkfs.xfs options,
1. -m crc=0 -b size=1k
2. -m crc=0 -b size=4k
3. -m crc=0 -b size=512
4. -m rmapbt=1,reflink=1 -b size=1k
5. -m rmapbt=1,reflink=1 -b size=4k

The patches can also be obtained from
https://github.com/chandanr/linux.git at branch xfs-reserve-extent-count-v3.

Changelog:
V2 -> V3:
  1. Move the definition of xfs_iext_count_may_overflow() from
     libxfs/xfs_trans_resv.c to libxfs/xfs_inode_fork.c. Also, I tried
     to make xfs_iext_count_may_overflow() an inline function by
     placing the definition in libxfs/xfs_inode_fork.h. However this
     required that the definition of 'struct xfs_inode' be available,
     since xfs_iext_count_may_overflow() uses a 'struct xfs_inode *'
     type variable.
  2. Handle XFS_COW_FORK within xfs_iext_count_may_overflow() by
     returning a success value.
  3. Rename XFS_IEXT_ADD_CNT to XFS_IEXT_ADD_NOSPLIT_CNT. Thanks to
     Darrick for the suggesting the new name.
  4. Expand comments to make use of 80 columns.

V1 -> V2:
  1. Rename helper function from xfs_trans_resv_ext_cnt() to
     xfs_iext_count_may_overflow().
  2. Define and use macros to represent fs operations and the
     corresponding increase in extent count.
  3. Split the patches based on the fs operation being performed.

Chandan Babu R (10):
  xfs: Add helper for checking per-inode extent count overflow
  xfs: Check for extent overflow when trivally adding a new extent
  xfs: Check for extent overflow when deleting an extent
  xfs: Check for extent overflow when adding/removing xattrs
  xfs: Check for extent overflow when adding/removing dir entries
  xfs: Check for extent overflow when writing to unwritten extent
  xfs: Check for extent overflow when inserting a hole
  xfs: Check for extent overflow when moving extent from cow to data
    fork
  xfs: Check for extent overflow when remapping an extent
  xfs: Check for extent overflow when swapping extents

 fs/xfs/libxfs/xfs_attr.c       | 13 ++++++
 fs/xfs/libxfs/xfs_bmap.c       |  6 +++
 fs/xfs/libxfs/xfs_inode_fork.c | 23 +++++++++++
 fs/xfs/libxfs/xfs_inode_fork.h | 75 ++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_item.c         |  4 ++
 fs/xfs/xfs_bmap_util.c         | 30 ++++++++++++++
 fs/xfs/xfs_dquot.c             |  8 +++-
 fs/xfs/xfs_inode.c             | 27 ++++++++++++
 fs/xfs/xfs_iomap.c             | 10 +++++
 fs/xfs/xfs_reflink.c           | 10 +++++
 fs/xfs/xfs_rtalloc.c           |  5 +++
 fs/xfs/xfs_symlink.c           |  5 +++
 12 files changed, 215 insertions(+), 1 deletion(-)

-- 
2.28.0

