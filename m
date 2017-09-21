Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58118 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751550AbdIUNZy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2017 09:25:54 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8LDPITY006608
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 09:25:54 -0400
Received: from e23smtp02.au.ibm.com (e23smtp02.au.ibm.com [202.81.31.144])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2d4e1h0vfn-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 09:25:52 -0400
Received: from localhost
        by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 21 Sep 2017 23:24:28 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
        by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v8LDOQIx37683202
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 23:24:26 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
        by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v8LDOHF4017935
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 23:24:17 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: slab corruption in generic/388
Date: Thu, 21 Sep 2017 18:55:13 +0530
In-Reply-To: <20170920145740.GA9685@infradead.org>
References: <20170920145740.GA9685@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2217708.1p8Y42FqGG@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>

On Wednesday, September 20, 2017 8:27:40 PM IST Christoph Hellwig wrote:
> Recently I've a few of these warnings in generic/388 with a 4k
> filesystem on x86_64, v5 file system with reflink and rmap
> enabled but otherwise defaults.  If someones got and idea where
> this might be from I'm curious, otherwise I'll add it to my TODO list.

I am able to recreate it on my ppc64 box as well. I will root cause the issue
and fix it.

=============================================================================
BUG xfs_rui_item (Tainted: G    B          ): Poison overwritten
-----------------------------------------------------------------------------

INFO: 0xc000000105d15f0b-0xc000000105d15f0b. First byte 0x6a instead of 0x6b
INFO: Allocated in .kmem_zone_alloc+0xcc/0x180 age=64 cpu=0 pid=2189
        .__slab_alloc+0x24/0x50
        .kmem_cache_alloc+0x124/0x350
        .kmem_zone_alloc+0xcc/0x180
        .xfs_rui_init+0x3c/0xe0
        .xfs_rmap_update_create_intent+0x34/0x120
        .xfs_defer_intake_work+0x64/0x1d0
        .xfs_defer_finish+0xa4/0x5b0
        .xfs_iomap_write_allocate+0x1cc/0x420
        .xfs_map_blocks+0x2c4/0x490
        .xfs_do_writepage+0x408/0x830
        .write_cache_pages+0x270/0x5f0
        .xfs_vm_writepages+0xe8/0x140
        .do_writepages+0x44/0xd0
        .__writeback_single_inode+0x5c/0x550
        .writeback_sb_inodes+0x2b8/0x580
        .__writeback_inodes_wb+0xd4/0x140
INFO: Freed in .xfs_rui_item_free+0x28/0x60 age=64 cpu=0 pid=2189
        .kmem_cache_free+0x118/0x2a0
        .xfs_rui_item_free+0x28/0x60
        .xfs_trans_free_items+0xd4/0x160
        .__xfs_trans_commit+0xc8/0x350
        .xfs_trans_roll+0x44/0x80
        .xfs_defer_trans_roll+0x6c/0x240
        .xfs_defer_finish+0xb0/0x5b0
        .xfs_iomap_write_allocate+0x1cc/0x420
        .xfs_map_blocks+0x2c4/0x490
        .xfs_do_writepage+0x408/0x830
        .write_cache_pages+0x270/0x5f0
        .xfs_vm_writepages+0xe8/0x140
        .do_writepages+0x44/0xd0
        .__writeback_single_inode+0x5c/0x550
        .writeback_sb_inodes+0x2b8/0x580
        .__writeback_inodes_wb+0xd4/0x140
INFO: Slab 0xf000000000417440 objects=65 used=65 fp=0x          (null) flags=0x3ffff800000100
INFO: Object 0xc000000105d15e88 @offset=24200 fp=0xc000000105d19998

Redzone c000000105d15e80: bb bb bb bb bb bb bb bb                          ........
Object c000000105d15e88: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000000105d15e98: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000000105d15ea8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000000105d15eb8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk

-- 
chandan

