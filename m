Return-Path: <SRS0=yyqk=36=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A64C2BA83
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 03:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4180C2086A
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 03:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgBJDCU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Feb 2020 22:02:20 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:59706 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726935AbgBJDCU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 9 Feb 2020 22:02:20 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8014C90011744999FC4A;
        Mon, 10 Feb 2020 11:02:18 +0800 (CST)
Received: from [127.0.0.1] (10.184.213.217) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Mon, 10 Feb 2020
 11:02:09 +0800
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>, <sandeen@redhat.com>,
        <linux-xfs@vger.kernel.org>
CC:     <renxudong1@huawei.com>, "zhangyi (F)" <yi.zhang@huawei.com>
From:   "zhengbin (A)" <zhengbin13@huawei.com>
Subject: Questions about XFS abnormal img mount test
Message-ID: <ea7db6e3-8a3a-a66d-710c-4854c4e5126c@huawei.com>
Date:   Mon, 10 Feb 2020 11:02:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.184.213.217]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

### question
We recently used fuzz(hydra) to test 4.19 stable XFS and automatically generate tmp.img (XFS v5 format, but some metadata is wrong)

Test as follows:
mount tmp.img tmpdir
cp file tmpdir
sync  --> stuck

### cause analysis
This is because tmp.img (only 1 AG) has some problems. Using xfs_repair detect information as follows:

agf_freeblks 0, counted 3224 in ag 0
agf_longest 536874136, counted 3224 in ag 0 
sb_fdblocks 613, counted 3228

The reason sync is blocked is :
xfs_vm_writepages(xfs_address_space_operations--writepages)
  write_cache_pages
    xfs_do_writepage
      xfs_writepage_map
	xfs_map_blocks
          allocate_blocks:
	    error = xfs_iomap_write_allocate
			
xfs_iomap_write_allocate
  while (count_fsb != 0) {
    nimaps = 0;
      while (nimaps == 0) { --> endless loop
	nimaps = 1;
	error = xfs_bmapi_write(..., &nimaps) --> nimaps becomes 0 again

xfs_bmapi_write
  xfs_bmap_alloc
    xfs_bmap_btalloc
      xfs_alloc_vextent
	xfs_alloc_fix_freelist
          xfs_alloc_space_available --> less space than needed

xfs_alloc_space_available
  alloc_len = args->minlen + (args->alignment - 1) + args->minalignslop;
    longest = xfs_alloc_longest_free_extent(pag, min_free, reservation);
    if (longest < alloc_len)
       return false;

    /* do we have enough free space remaining for the allocation? */
    available = (int)(pag->pagf_freeblks + pag->pagf_flcount -
                        reservation - min_free - args->minleft);
    if (available < (int)max(args->total, alloc_len))
      return false;

### solve
1. Detect the above metadata corruption when mounting XFS?
   agf_freeblks 0, counted 3224 in ag 0
   agf_longest 536874136, counted 3224 in ag 0 
   sb_fdblocks 613, counted 3228

2. xfs_repair detection at system boot? If xfs_repair fails, refuse to mount XFS


