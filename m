Return-Path: <SRS0=EDo9=V4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13077C32751
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Jul 2019 11:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E11E920693
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Jul 2019 11:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfGaLtt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Jul 2019 07:49:49 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:55517 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726232AbfGaLtt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 07:49:49 -0400
X-IronPort-AV: E=Sophos;i="5.64,330,1559491200"; 
   d="scan'208";a="72591477"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 31 Jul 2019 19:49:45 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id B85DD4B4041E;
        Wed, 31 Jul 2019 19:49:42 +0800 (CST)
Received: from iridescent.g08.fujitsu.local (10.167.225.140) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.439.0; Wed, 31 Jul 2019 19:49:49 +0800
From:   Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
To:     <linux-xfs@vger.kernel.org>, <linux-nvdimm@lists.01.org>,
        <darrick.wong@oracle.com>
CC:     <linux-kernel@vger.kernel.org>, <rgoldwyn@suse.de>,
        <gujx@cn.fujitsu.com>, <david@fromorbit.com>,
        <qi.fuli@fujitsu.com>, <caoj.fnst@cn.fujitsu.com>,
        <ruansy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 0/7] xfs: add reflink & dedupe support for fsdax.
Date:   Wed, 31 Jul 2019 19:49:28 +0800
Message-ID: <20190731114935.11030-1-ruansy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.17.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [10.167.225.140]
X-yoursite-MailScanner-ID: B85DD4B4041E.A6D27
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
Message-ID: <20190731114928.POD4m-lrLyaMvK8HF5Ixq_LB3fzenFcJMRagzpdyp60@z>

This patchset aims to take care of this issue to make reflink and dedupe
work correctly in XFS.

It is based on Goldwyn's patchsets: "v4 Btrfs dax support" and "Btrfs
iomap".  I picked up some patches related and made a few fix to make it
basically works fine.

For dax framework: 
  1. adapt to the latest change in iomap.

For XFS:
  1. report the source address and set IOMAP_COW type for those write
     operations that need COW.
  2. update extent list at the end.
  3. add file contents comparison function based on dax framework.
  4. use xfs_break_layouts() to support dax.


Goldwyn Rodrigues (3):
  dax: replace mmap entry in case of CoW
  fs: dedup file range to use a compare function
  dax: memcpy before zeroing range

Shiyang Ruan (4):
  dax: Introduce dax_copy_edges() for COW.
  dax: copy data before write.
  xfs: Add COW handle for fsdax.
  xfs: Add dedupe support for fsdax.

 fs/btrfs/ioctl.c      |  11 ++-
 fs/dax.c              | 203 ++++++++++++++++++++++++++++++++++++++----
 fs/iomap.c            |   9 +-
 fs/ocfs2/file.c       |   2 +-
 fs/read_write.c       |  11 +--
 fs/xfs/xfs_iomap.c    |  42 +++++----
 fs/xfs/xfs_reflink.c  |  84 +++++++++--------
 include/linux/dax.h   |  15 ++--
 include/linux/fs.h    |   8 +-
 include/linux/iomap.h |   6 ++
 10 files changed, 294 insertions(+), 97 deletions(-)

-- 
2.17.0



