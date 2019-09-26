Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 891B8C4360C
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 14:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B01D222C7
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 14:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfIZOWl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 10:22:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50864 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbfIZOWl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Sep 2019 10:22:41 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7BACA30089A1;
        Thu, 26 Sep 2019 14:22:41 +0000 (UTC)
Received: from localhost (unknown [10.40.205.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 10C1E5D6B0;
        Thu, 26 Sep 2019 14:22:40 +0000 (UTC)
From:   Max Reitz <mreitz@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Max Reitz <mreitz@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: Fix tail rounding in xfs_alloc_file_space()
Date:   Thu, 26 Sep 2019 16:22:38 +0200
Message-Id: <20190926142238.26973-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 26 Sep 2019 14:22:41 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

To ensure that all blocks touched by the range [offset, offset + count)
are allocated, we need to calculate the block count from the difference
of the range end (rounded up) and the range start (rounded down).

Before this patch, we just round up the byte count, which may lead to
unaligned ranges not being fully allocated:

$ touch test_file
$ block_size=$(stat -fc '%S' test_file)
$ fallocate -o $((block_size / 2)) -l $block_size test_file
$ xfs_bmap test_file
test_file:
        0: [0..7]: 1396264..1396271
        1: [8..15]: hole

There should not be a hole there.  Instead, the first two blocks should
be fully allocated.

With this patch applied, the result is something like this:

$ touch test_file
$ block_size=$(stat -fc '%S' test_file)
$ fallocate -o $((block_size / 2)) -l $block_size test_file
$ xfs_bmap test_file
test_file:
        0: [0..15]: 11024..11039

Signed-off-by: Max Reitz <mreitz@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0910cb75b65d..4f443703065e 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -864,6 +864,7 @@ xfs_alloc_file_space(
 	xfs_filblks_t		allocatesize_fsb;
 	xfs_extlen_t		extsz, temp;
 	xfs_fileoff_t		startoffset_fsb;
+	xfs_fileoff_t		endoffset_fsb;
 	int			nimaps;
 	int			quota_flag;
 	int			rt;
@@ -891,7 +892,8 @@ xfs_alloc_file_space(
 	imapp = &imaps[0];
 	nimaps = 1;
 	startoffset_fsb	= XFS_B_TO_FSBT(mp, offset);
-	allocatesize_fsb = XFS_B_TO_FSB(mp, count);
+	endoffset_fsb = XFS_B_TO_FSB(mp, offset + count);
+	allocatesize_fsb = endoffset_fsb - startoffset_fsb;
 
 	/*
 	 * Allocate file space until done or until there is an error
-- 
2.23.0

