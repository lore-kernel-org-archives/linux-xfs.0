Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C43FC433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Nov 2021 14:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1863061245
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Nov 2021 14:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhKEOQa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Nov 2021 10:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbhKEOQa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Nov 2021 10:16:30 -0400
Received: from gwu.lbox.cz (proxybox.linuxbox.cz [IPv6:2a02:8304:2:66::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626AFC061714
        for <linux-xfs@vger.kernel.org>; Fri,  5 Nov 2021 07:13:50 -0700 (PDT)
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
        by gwu.lbox.cz (Sendmail) with ESMTPS id 1A5EDiFs010676
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 5 Nov 2021 15:13:44 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 1A5EDiFs010676
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
        s=default; t=1636121624;
        bh=FGnUFDcGaKGp5ZQxsGjdULB2opCTBHYxvK7QPE0MwHc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RrXpv+DOi0f3CIDBrYDHQYY+YiWcIGwlujwZCiJYGhpCUGKOy5wfMaZTUekkJOvCe
         ZFLDh2hu4yYo0u0dscsHCUj0NLYpX/qjdOGaQqjLRRmG7sx/+vEmAKDQu7u2hIuqiy
         A9YWPr6GwjFVXHI0vp1buYg/tAZ4J4aKn508qX34=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
        by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 1A5EDhMg001987
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 5 Nov 2021 15:13:43 +0100
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
        by pcnci.linuxbox.cz (8.15.2/8.15.2) with SMTP id 1A5EDhUE010598;
        Fri, 5 Nov 2021 15:13:43 +0100
Date:   Fri, 5 Nov 2021 15:13:43 +0100
From:   Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: XFS / xfs_repair - problem reading very large sparse files on
 very large filesystem
Message-ID: <20211105141343.GH32555@pcnci.linuxbox.cz>
References: <20211104090915.GW32555@pcnci.linuxbox.cz>
 <39784566-4696-2391-a6f5-6891c2c7802b@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39784566-4696-2391-a6f5-6891c2c7802b@sandeen.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.85 on 10.76.66.2
X-Scanned-By: MIMEDefang v2.85/SpamAssassin v3.004006 on lbxovapx.linuxbox.cz (nik)
X-Scanned-By: MIMEDefang 2.85 on 10.76.66.10
X-Antivirus: on lbxovapx.linuxbox.cz by Kaspersky antivirus, database version: 2021-11-05T13:09:00
X-Milter-Copy-Status: O
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello Eric,

I'm sorry for late reply.

> I'm guessing they are horrifically fragmented? What does xfs_bmap tell you
> about the number of extents in one of these files?

unfortunately, xfs_bmap blocks on this file too:

[  +0.000321] task:xfs_io          state:D stack:    0 pid:15728 ppid: 15725 flags:0x00000080
[  +0.000333] Call Trace:
[  +0.000161]  __schedule+0x231/0x760
[  +0.000195]  ? page_add_new_anon_rmap+0x9e/0x1f0
[  +0.000207]  schedule+0x3c/0xa0
[  +0.000175]  rwsem_down_write_slowpath+0x32c/0x4e0
[  +0.000216]  ? get_page_from_freelist+0x190d/0x1c60
[  +0.000250]  xfs_ilock_data_map_shared+0x29/0x30 [xfs]
[  +0.000312]  xfs_getbmap+0xe2/0x7b0 [xfs]
[  +0.000197]  ? _cond_resched+0x15/0x30
[  +0.000203]  ? __kmalloc_node+0x4a4/0x4e0
[  +0.000230]  xfs_ioc_getbmap+0xf5/0x270 [xfs]
[  +0.000260]  xfs_file_ioctl+0x4da/0xbc0 [xfs]
[  +0.000205]  ? __mod_memcg_lruvec_state+0x21/0x100
[  +0.000203]  ? page_add_new_anon_rmap+0x9e/0x1f0
[  +0.000209]  ? __raw_spin_unlock+0x5/0x10
[  +0.000188]  ? __handle_mm_fault+0xbb0/0x1410
[  +0.000221]  ? handle_mm_fault+0xd0/0x290
[  +0.000191]  __x64_sys_ioctl+0x84/0xc0
[  +0.000181]  do_syscall_64+0x33/0x40
[  +0.000188]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  +0.000213] RIP: 0033:0x7fdc81f694a7
[  +0.000192] RSP: 002b:00007ffe98c69998 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  +0.000319] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fdc81f694a7
[  +0.000311] RDX: 00000000010d6a00 RSI: ffffffffc0205838 RDI: 0000000000000003
[  +0.000322] RBP: 0000000000000020 R08: 0000000000000000 R09: 0000000000000600
[  +0.000303] R10: 0000000000000048 R11: 0000000000000246 R12: 0000000000000000
[  +0.000310] R13: 00000000010d6a00 R14: 0000000000000000 R15: 0000000000000000


> 
> When it is blocked, where is it blocked?  (try sysrq-w)
[  +0.016252] task:pv              state:D stack:    0 pid:15507 ppid:  1161 flags:0x00004080
[  +0.000373] Call Trace:
[  +0.000177]  __schedule+0x231/0x760
[  +0.000190]  schedule+0x3c/0xa0
[  +0.000175]  schedule_timeout+0x215/0x2b0
[  +0.000197]  ? blk_mq_get_tag+0x244/0x280
[  +0.000201]  __down+0x9b/0xf0
[  +0.000189]  ? blk_mq_complete_request_remote+0x50/0xc0
[  +0.000223]  down+0x3b/0x50
[  +0.000385]  xfs_buf_lock+0x2c/0xb0 [xfs]
[  +0.000259]  xfs_buf_find.isra.32+0x3d9/0x610 [xfs]
[  +0.000275]  xfs_buf_get_map+0x4c/0x2e0 [xfs]
[  +0.000199]  ? submit_bio+0x43/0x160
[  +0.000232]  xfs_buf_read_map+0x55/0x2c0 [xfs]
[  +0.000237]  ? xfs_btree_read_buf_block.constprop.40+0x95/0xd0 [xfs]
[  +0.000328]  xfs_trans_read_buf_map+0x123/0x2d0 [xfs]
[  +0.000279]  ? xfs_btree_read_buf_block.constprop.40+0x95/0xd0 [xfs]
[  +0.000299]  xfs_btree_read_buf_block.constprop.40+0x95/0xd0 [xfs]
[  +0.000301]  xfs_btree_lookup_get_block+0x95/0x170 [xfs]
[  +0.000263]  ? xfs_bmap_validate_extent+0xa0/0xa0 [xfs]
[  +0.000257]  xfs_btree_visit_block+0x85/0xc0 [xfs]
[  +0.000237]  ? xfs_bmap_validate_extent+0xa0/0xa0 [xfs]
[  +0.000263]  xfs_btree_visit_blocks+0x109/0x120 [xfs]
[  +0.000246]  xfs_iread_extents+0x9f/0x170 [xfs]
[  +0.000246]  ? xfs_bmapi_read+0x23b/0x2c0 [xfs]
[  +0.000233]  xfs_bmapi_read+0x23b/0x2c0 [xfs]
[  +0.000214]  ? _cond_resched+0x15/0x30
[  +0.000214]  ? down_write+0xe/0x40
[  +0.000230]  xfs_read_iomap_begin+0xea/0x1e0 [xfs]
[  +0.000228]  iomap_apply+0x94/0x2d0
[  +0.000181]  ? iomap_page_mkwrite_actor+0x70/0x70
[  +0.008736]  ? iomap_page_mkwrite_actor+0x70/0x70
[  +0.000219]  iomap_readahead+0x9a/0x150
[  +0.000207]  ? iomap_page_mkwrite_actor+0x70/0x70
[  +0.000216]  read_pages+0x8e/0x1f0
[  +0.000183]  page_cache_ra_unbounded+0x19d/0x1f0
[  +0.000207]  generic_file_buffered_read+0x3f8/0x800
[  +0.000266]  xfs_file_buffered_aio_read+0x44/0xb0 [xfs]
[  +0.000280]  xfs_file_read_iter+0x68/0xc0 [xfs]
[  +0.000204]  new_sync_read+0x118/0x1a0
[  +0.000195]  vfs_read+0xf1/0x180
[  +0.000173]  ksys_read+0x59/0xd0
[  +0.000187]  do_syscall_64+0x33/0x40
[  +0.000186]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  +0.000215] RIP: 0033:0x7f209bf06b40
[  +0.000179] RSP: 002b:00007ffd9d11aeb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[  +0.000383] RAX: ffffffffffffffda RBX: 00007ffd9d11b0c0 RCX: 00007f209bf06b40
[  +0.000308] RDX: 0000000000020000 RSI: 00007f209c3d9010 RDI: 0000000000000003
[  +0.000309] RBP: 00007ffd9d11b0c4 R08: 0000000000000000 R09: 0000000000000004
[  +0.000308] R10: 00007ffd9d11a2a0 R11: 0000000000000246 R12: 00000000018290d0
[  +0.000318] R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000020000


> 
> >I tried running xfs_repair on the volume, but this seems to behave in
> >very similar way - very quickly it gets into almost stalled state, without
> >almost any progress..
> 
> Perceived performance won't be fixed by repair, but...
> 
> >[root@spbstdnas ~]# xfs_repair -P -t 60 -v -v -v -v /dev/sdk
> >Phase 1 - find and verify superblock...
> >         - max_mem = 154604838, icount = 9664, imem = 37, dblock = 382464425984, dmem = 186750208
> >Memory available for repair (150981MB) may not be sufficient.
> >At least 182422MB is needed to repair this filesystem efficiently
> >If repair fails due to lack of memory, please
> >increase system RAM and/or swap space to at least 364844MB.
> 
> ... it /is/ telling you that it would like a lot more memory to do
> its job.
> 
> >Phase 2 - using internal log
> >         - zero log...
> >zero_log: head block 1454674 tail block 1454674
> >         - scan filesystem freespace and inode maps...
> >         - found root inode chunk
> ...
> >Phase 3 - for each AG...
> >         - scan and clear agi unlinked lists...
> >         - process known inodes and perform inode discovery...
> >         - agno = 0
> >         - agno = 1
> >         - agno = 2
> >
> >
> >         - agno = 3
> >
> >VM has 200GB of RAM, but the xfs_repair does not use more then 1GB,
> >CPU is idle. it just only reads the same slow speed, ~200K/s, 50IOPS.
> 
> Rather than diagnosing repair at this point, let's first see where you're
> blocked when you're reading the sparse files on the filesystem as suggested
> above.
OK.

please let me know, if I could provide any further info

with best regards

nikola ciprich


> 
> -Eric
> 
> >I've carefully checked, and the storage speed is much much faster, checked
> >with blktrace which areas of the volume it is currently reading, and trying
> >fio / dd on them shows it can perform much faster (as well as randomly reading
> >any area of the volume or trying randomread or seq read fio benchmarks)
> >
> >I've found one, very old report pretty much resembling my problem:
> >
> >https://www.spinics.net/lists/xfs/msg06585.html
> >
> >but it is 10 years old and didn't lead to any conclusion.
> >
> >Is it possible there is still some bug common for XFS kernel module and xfs_repair?
> >
> >I tried 5.4.135 and 5.10.31 kernels, xfs_progs 4.5.0 and 5.13.0
> >(OS is x86_64 centos 7)
> >
> >any hints on how could I further debug that?
> >
> >I'd be very gratefull for any help
> >
> >with best regards
> >
> >nikola ciprich
> >
> >
> 

-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28.rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
