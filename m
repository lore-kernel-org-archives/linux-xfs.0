Return-Path: <SRS0=kyg5=BY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B807CC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 08:09:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 943D12068E
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 08:09:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZamMkwth"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgHNIJk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Aug 2020 04:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgHNIJk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Aug 2020 04:09:40 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232CCC061383
        for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2020 01:09:40 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id r11so4176570pfl.11
        for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2020 01:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zch9OcvnfmuUL7C/4JEtGYWRdUtMt1IZ6FBFW2v/gRE=;
        b=ZamMkwthyX5VogcS5hE0hbElL2K1LNfyGFjCFrPCQrEKsL7s+gsDuUITUX1m0g7UKL
         +F6fIZGHBUPv+CeMt3wxX45qNJgTq/RdpLiK7/hBtd8m31U5g8sG/u6KnZEyi2gaFH3C
         VaBWP3tNxSiv40nGUxWU7Rezc5l760geZRf1aTMJpNdPGDyFZYxWjihBPzmOmsSGAf9+
         qAYhGaRdsCqNggpfGNr8hQAobxBMLiigtKswbIzk5FyteRZ5GZ1KaFRd0nGhw2bhqDmL
         QJ7wEWYgfzNdbEhoPi8TsQm7VmrSRT6TTRDF36wJg0IYU+K/9yylcY7TLOM5ANi7EcUy
         5OuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zch9OcvnfmuUL7C/4JEtGYWRdUtMt1IZ6FBFW2v/gRE=;
        b=TBcssV8u346hoqxo8v41bMV00bcs2uU9AoxIHw0cWpJ8/qiYn8qb21ttVjYYCU7pja
         xSGyYyIcudfXplSGL/eHlMvNu5xh7WYHgRZ+hTPJLXEXw7zMIlw+Z1zwtgfZ8+1Zezbz
         CKpS7NwS1p438OJuT+TFZjLYj6uIHyLul/npeVMceU2sR/c/2jK1Vi1OMfYED6IeSOaV
         X+RYArNoYUikC7bNjxdVaojUmWVS/b2IgW7mbcAEUDyqbYduCHPU5cMdOnkUKynIsjwO
         9OoHLQYd1ZfEZsnaCfbY2sY1vPE8yHOAiKHj0W7JMzBVx2j3ZW7wwUrLLMpVcA0+Mimp
         6nag==
X-Gm-Message-State: AOAM532t/JqSF8icpFLDyfmGvSn7QuRkQrQ2Th9g1MJ6L0tmOwCrP1Va
        jyKxP2SJ4dH82FyXsZqT+GwXcTzaccc=
X-Google-Smtp-Source: ABdhPJwqYqlry9brGCWJuPliIWaBK9kH9Hfl80H7WdcQU2KVceTY/M+TaLPUrnHvmUf1Q9GPy5bjVA==
X-Received: by 2002:aa7:9219:: with SMTP id 25mr1050875pfo.4.1597392579243;
        Fri, 14 Aug 2020 01:09:39 -0700 (PDT)
Received: from localhost.localdomain ([122.179.47.119])
        by smtp.gmail.com with ESMTPSA id z17sm8594289pfq.38.2020.08.14.01.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 01:09:38 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V2 00/10] Bail out if transaction can cause extent count to overflow
Date:   Fri, 14 Aug 2020 13:38:23 +0530
Message-Id: <20200814080833.84760-1-chandanrlinux@gmail.com>
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

   xfsaild/loop0  2035 [003]  9643.390490: probe:xfs_iflush_int: (ffffffffac6225c0) if_nextents=98511 inode=131

3. The incore inode fork extent counter is a signed 32-bit
   quantity. However the on-disk extent counter is an unsigned 16-bit
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
https://github.com/chandanr/linux.git at branch xfs-reserve-extent-count-v2.

Changelog:
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
 fs/xfs/libxfs/xfs_bmap.c       |  8 ++++
 fs/xfs/libxfs/xfs_inode_fork.h | 72 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_trans_resv.c | 33 ++++++++++++++++
 fs/xfs/libxfs/xfs_trans_resv.h |  2 +
 fs/xfs/xfs_bmap_item.c         |  4 ++
 fs/xfs/xfs_bmap_util.c         | 30 ++++++++++++++
 fs/xfs/xfs_dquot.c             |  8 +++-
 fs/xfs/xfs_inode.c             | 27 +++++++++++++
 fs/xfs/xfs_iomap.c             | 10 +++++
 fs/xfs/xfs_reflink.c           | 11 ++++++
 fs/xfs/xfs_rtalloc.c           |  5 +++
 fs/xfs/xfs_symlink.c           |  5 +++
 13 files changed, 227 insertions(+), 1 deletion(-)

-- 
2.28.0

