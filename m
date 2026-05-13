Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FA11B87C9
	for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 09:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778664841; cv=none; b=aw8BMtYpWgBIc2R4CVQua3qWVfvFe1lpyCQFU8bpSxWSj56S+wLk+Zz4jdp4EH2b/f4POG9km6RNXIP6R4cSyuUAujHA3AW0kEHNnsQh7oTb0a98Q4FoHOhz0JeRtpDyyOrCRZKbR9hvTeX86NrSEalfhXYzi4UpP5B3bWhidhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778664841; c=relaxed/simple;
	bh=WHs1LqPpkWHpPWHnCz1JXZBOCFIlyOAlQxedg/RGqYo=;
	h=Subject:To:References:Cc:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=enQAmGKxFfMwOSwv31GFpxk0BfzXAi0ACtLVkkcISUfmHuPGySdNAGMvREMObRULxnvuFYlwbbqRIm6j5Jw/AXq9zqLpDBa31ZhsyAD9E39izPp8DPgJraDk44A445dDouJhBYKXtuDTL4bNvAkgNhMlJr5r8WJz+NCahfQEVwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gFpCm0mDLzKHMZ1
	for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 17:32:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id F046340578
	for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 17:33:45 +0800 (CST)
Received: from [10.174.178.185] (unknown [10.174.178.185])
	by APP4 (Coremail) with SMTP id gCh0CgD3v1t4RQRqG5mMCA--.18523S3;
	Wed, 13 May 2026 17:33:45 +0800 (CST)
Subject: Re: [bug report] kernel BUG at fs/xfs/xfs_message.c:102!
To: Dave Chinner <dgc@kernel.org>
References: <6A031038.9030708@huaweicloud.com> <agOvHBfTbfQI-PTj@dread>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, hch@lst.de
From: yebin <yebin@huaweicloud.com>
Message-ID: <6A044578.8040807@huaweicloud.com>
Date: Wed, 13 May 2026 17:33:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <agOvHBfTbfQI-PTj@dread>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgD3v1t4RQRqG5mMCA--.18523S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKryrKFyDGF45XrW5Aw1rtFb_yoWfKw4kpF
	ZIkr1UGF4vqw18ZrZ7Aw15XF1rAa1xCF4UJr1Ikr1Iva98Cr1Iqr4DKF4YqFyDurWrCF12
	vF40y34q9w1qyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyCb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/



On 2026/5/13 6:52, Dave Chinner wrote:
> On Tue, May 12, 2026 at 07:34:16PM +0800, yebin wrote:
>> Hello Darrick and all,
>>
>> Recently, I encountered a problem where a BUG was triggered in the write-back process.
>> The detailed problem information is as follows:
>> ```
>> XFS (sde): Corruption of in-memory data (0x8) detected at xfs_trans_mod_sb+0xaa6/0xc60 (fs/xfs/xfs_trans.c:351).  Shutting.
>> XFS (sde): Please unmount the filesystem and rectify the problem(s)
>> XFS: Assertion failed: tp->t_blk_res || tp->t_fdblocks_delta >= 0, file: fs/xfs/xfs_trans.c, line: 610
>> ------------[ cut here ]------------
>> kernel BUG at fs/xfs/xfs_message.c:102!
>> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
>> RIP: 0010:assfail+0x9f/0xb0
>
> What kernel? You've stripped that line out of the stack dump.

The initial issue appeared on the v5.10 kernel and occurred multiple times.
The current stack is a reproduction I made on linux-next based on the
cc13002a9f98 tag: next-20260402.

>
>> Code: fe 84 db 75 20 e8 51 2e 33 fe 0f 0b 5b 5d 41 5c 41 5d c3 cc cc cc cc 48 c7 c7 58 ae 2b 8d e8 08 73 a2 fe eb cc e8 310
>> RSP: 0018:ffffc9000f6372e0 EFLAGS: 00010293
>> RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff838c91a6
>> RDX: ffff8881a856bb00 RSI: ffffffff838c91cf RDI: 0000000000000001
>> RBP: 0000000000000000 R08: 0000000000000001 R09: fffff52001ec6ded
>> R10: 0000000000000001 R11: 0000000000000001 R12: ffffffff8a956520
>> R13: 0000000000000262 R14: 0000000000000000 R15: ffffffffffffffff
>> FS:  00007f7ee1f5b740(0000) GS:ffff88878bb45000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007f0e632788f0 CR3: 00000001b524a000 CR4: 00000000000006f0
>> Call Trace:
>>   <TASK>
>>   xfs_trans_unreserve_and_mod_sb+0xb86/0xd00
>>   __xfs_trans_commit+0x38b/0xe00
>>   xfs_trans_commit+0xeb/0x1a0
>>   xfs_bmapi_convert_one_delalloc+0xbca/0x1270
>>   xfs_bmapi_convert_delalloc+0x101/0x350
>>   xfs_writeback_range+0x76c/0x12d0
>>   iomap_writeback_folio+0x9ed/0x2100
>>   iomap_writepages+0x13c/0x2a0
>>   xfs_vm_writepages+0x278/0x330
>>   do_writepages+0x247/0x5c0
>>   filemap_writeback+0x22c/0x2e0
>>   xfs_file_release+0x442/0x580
>>   __fput+0x407/0xb50
>>   fput_close_sync+0x114/0x210
>>   __x64_sys_close+0x94/0x120
>>   do_syscall_64+0xc4/0xf80
>>   entry_SYSCALL_64_after_hwframe+0x76/0x7e
>> ```
>>
>> After analyzing the above issues, the possible triggering process
>> is as follows:
>> ```
>> xfs_bmapi_convert_delalloc
>>   xfs_bmapi_convert_one_delalloc
>>    xfs_bmapi_allocate
>>     xfs_bmap_add_extent_delay_real
>>      da_old = startblockval(PREV.br_startblock); // da_old = 5
>>      case BMAP_LEFT_FILLING:
>>       ifp->if_nextents++;  // 21 + 1 = 22
>>       if (xfs_bmap_needs_btree(bma->ip, whichfork))  // 22 > 21
>>        xfs_bmap_extents_to_btree     // convert to btree
>>          cur->bc_ino.allocated++;
>>        da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
>>                                 startblockval(PREV.br_startblock) -
>>                                 (bma->cur ? bma->cur->bc_ino.allocated : 0));  // da_new = 5 - 1 = 4
>>        PREV.br_startblock = nullstartblock(da_new); //xfs_bmapi_convert_one_delalloc() return
>>
>>                                                   xfs_bmap_del_extent_real
>>                                                     case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
>>                                                      ifp->if_nextents--;  // 22 - 1 = 21
>>                                                      if (xfs_bmap_needs_btree(ip, whichfork))
>>                                                        xfs_bmap_extents_to_btree
>>                                                      else
>>                                                        xfs_bmap_btree_to_extents  // convert to extents
>
> So your test code is creating a number of fragmented extents to get
> to the edge of btree format conversion, then doing a delalloc
> write() to create a long delalloc extent range, then is alternating
> along the range of the delalloc extent doing:
>
> loop:
> 	sync_file_range(offset, 4096, SYNC_FILE_RANGE_WRITE)
> 	fallocate(PUNCH_HOLE, offset, 4096)
> 	offset += 4096;
>
> And so it is converting a single block at the left edge of the
> delalloc extent to a written extent which triggers a extent -> btree
> conversion, and then you punch out the newly created written extent
> triggering a btree -> extent conversion.
>
> And each time you do this it removes a reserved block from the
> delalloc extent for the btree root block, yes?
>

Yes, this is just a process I designed to facilitate the construction
of this problem. In another case, during the delay extent conversion,
B-tree splitting continuously consumes reserved blocks. Essentially,
this is because the delay extent conversion process is broken down,
which may cause the reserved blocks to be exhausted.
I think that the scenario of conversion between extents and B-trees
may be that the unwritten extents are converted to written extents
after the writeback is complete and then the extents are combined,
causing the B-tree to be converted to an extent. This scenario may
be triggered by normal service operations. In any case, file system
fragmentation is the cause of this problem.

> How realistic is this scenario in an application/production
> environment? I mean, nobody walks through a file syncing data to
> disk one fragmented extent at a time only to immediately remove it
> before writing the next block.
>
> We've known that this is possible for a very long time. I've
> personally known it can happen in carefully constructed test code
> for over 20 years, but I can count on one hand the number of times
> I've actually seen this exhaustion occur in a production system.
>
> The reservation we use here is essentially unchanged since if was
> first introduced in 1994, so time in use tells us that the
> reservation is largely sufficient for production systems. Can you
> describe the situation where you production systems are hitting
> this? What is the application actually doing to trigger this
> problem?
>

The extent reduction is not only triggered in the punch hole scenario.
In all scenarios where extent merging is triggered, the conversion
from B-tree to extent may be performed.

>> ... // Alternate a few times in the middle.
>> da_old = 4
>> da_old = 3
>> da_old = 2
>> da_old = 1
>> ...
>> xfs_bmapi_convert_delalloc
>>   xfs_bmapi_convert_one_delalloc
>>    error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, XFS_TRANS_RESERVE, &tp);  // Both blocks and rtextents are 0
>>     tp = kmem_cache_zalloc(xfs_trans_cache, GFP_KERNEL | __GFP_NOFAIL);
>>     error = xfs_trans_reserve(tp, resp, blocks, rtextents);
>>     if (blocks > 0)
>>      error = xfs_mod_fdblocks(mp, -((int64_t)blocks), rsvd);
>>      tp->t_blk_res += blocks;    // The value of blocks is 0, so the value of tp->t_blk_res is 0
>>     xfs_bmapi_allocate
>>      xfs_bmap_add_extent_delay_real
>>       da_old = startblockval(PREV.br_startblock); // da_old = 0
>>       case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:   // The current delay extent is just exhausted.
>>        ifp->if_nextents++;  // 21 + 1 + 22
>>
>>      if (xfs_bmap_needs_btree(bma->ip, whichfork))  // 22 > 21
>>       error = xfs_bmap_extents_to_btree(bma->tp, bma->ip, &bma->cur, da_old > 0, &tmp_logflags, whichfork);     // Converted to btree. da_old > 0 is false.
>>        args.wasdel = wasdel;   //  wasdel is false
>>        error = xfs_alloc_vextent(&args);
>>         xfs_alloc_ag_vextent(args, 0)
>
> Ok, that's why you stripped the kernel ID out of the stack dump -
> this analysis is from a vendor kernel of some kind. i.e.
> xfs_alloc_ag_vextent() went away in 2023...
>
Sorry, my initial problem analysis was based on the v5.10 kernel version,
and I must have missed updating it during the modification.

> Which begs the question: we fixed some issues with this code back in
> 2024, so does this problem still occur on TOT kernels? e.g. commit
> d69bee6a35d3 ("xfs: fix xfs_bmap_add_extent_delay_real for partial
> conversions") should help address indlen block consumption for
> repeated partial conversions.
>

This patch can solve the issue where the required extra space may not
be reserved in time, leading to a writeback failure. However, it cannot
address the problem caused by the continuous consumption of the reserved
space. After da_old is exhausted, there is currently no replenishment,
and I am wondering whether it is reasonable to maintain the reserved
blocks at the value of xfs_bmap_worst_indlen(). At the same time, da_old
does not subtract the consumed portion, so (da_new - da_old) will be
smaller than the actual value, resulting in less space being reserved
than actually needed.

commit d69bee6a35d3 ("xfs: fix xfs_bmap_add_extent_delay_real for partial
conversions") Here, when there is not enough space, it reserves space from
the reserved block pool. Although the reservation is successful, in theory,
the actual allocation of space may fail due to insufficient space in
xfs_alloc_fix_freelist(). I am not sure if my understanding is correct?

>> Further analysis of this abnormal model shows that because the reserved blocks
>> are continuously consumed, they may eventually exceed the reserved amount. When
>> the space is nearly exhausted, xfs_bmap_extents_to_btree() may fail to allocate
>> blocks, triggering a warning. This failure to allocate additional blocks can lead
>> to issues with normal block allocation.
>
> The TOT code should be recalculating the required indlen for the
> remaining delalloc extent and accounting for indlen block usage
> where it gets depleted. hence the gradual reduction of the indlen
> over repeated left edge conversion and removal triggering repeated
> indlen block consumption should no longer be a problem.
>
> If it is a problem, then we need to make sure we account for it
> correctly, similar to the fix in the above commit and the series it
> was part of.
>
> -Dave.
>

