Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08ABE1EEA3C
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 03:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778728628; cv=none; b=lPtbW4ISUpv7YzyGM9EtgM+qrUY6QvAO/NDFuUxEtn7Km7P7Be8iaNkfhBNlHAmcyyqoOH4WyKn/XE2klDv4sjbkPlZP5AtWa5a4ZKEqYqxMlzIlSAqlJ+AYkID2RTzOPw56LJizBT32MEF0GCaJ2qUsUweuhta8fZiBudyUvpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778728628; c=relaxed/simple;
	bh=v3YLWpnF79fc0jdGHGrssUY+Jq6CQdSiAofyBxYsiLU=;
	h=Subject:To:References:Cc:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Jl3m9gGrR1Jocbp6illA4Qb8QubrwTTKzERLq5dJONjR9UwntCXihTAXY8AyN8TBzs2aN2X3uoNlioJ+05AXJgqqnX8m60wAq0O2t+bUjL3yUUJhTOS86rfdhod70guZc2j9QPXz0FL72+LIPh/ZDIboNek4uIVxmZhbMG/GAQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gGFpt6qg7zYQtH5
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 11:16:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 70B5B4056E
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 11:16:56 +0800 (CST)
Received: from [10.174.178.185] (unknown [10.174.178.185])
	by APP4 (Coremail) with SMTP id gCh0CgAX31qmPgVqReDmCA--.36415S3;
	Thu, 14 May 2026 11:16:56 +0800 (CST)
Subject: Re: [bug report] kernel BUG at fs/xfs/xfs_message.c:102!
To: Dave Chinner <dgc@kernel.org>
References: <6A031038.9030708@huaweicloud.com> <agOvHBfTbfQI-PTj@dread>
 <6A044578.8040807@huaweicloud.com> <agRuByZS15BgUrGX@dread>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, hch@lst.de
From: yebin <yebin@huaweicloud.com>
Message-ID: <6A053EA6.1040707@huaweicloud.com>
Date: Thu, 14 May 2026 11:16:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <agRuByZS15BgUrGX@dread>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAX31qmPgVqReDmCA--.36415S3
X-Coremail-Antispam: 1UD129KBjvJXoW3CFyxWFW3Ww45WF15Zw48tFb_yoWkJr47pF
	Wak3WUJF4kJw18Wr92vw10qF1Fka1xGr4UGrn8Jr10vasxCFyIqFW7tw4Y9F97urWxC3Wj
	vF4jvF9rCw1DAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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



On 2026/5/13 20:26, Dave Chinner wrote:
> On Wed, May 13, 2026 at 05:33:44PM +0800, yebin wrote:
>>
>>
>> On 2026/5/13 6:52, Dave Chinner wrote:
>>> On Tue, May 12, 2026 at 07:34:16PM +0800, yebin wrote:
>>>> Hello Darrick and all,
>>>>
>>>> Recently, I encountered a problem where a BUG was triggered in the write-back process.
>>>> The detailed problem information is as follows:
>>>> ```
>>>> XFS (sde): Corruption of in-memory data (0x8) detected at xfs_trans_mod_sb+0xaa6/0xc60 (fs/xfs/xfs_trans.c:351).  Shutting.
>>>> XFS (sde): Please unmount the filesystem and rectify the problem(s)
>>>> XFS: Assertion failed: tp->t_blk_res || tp->t_fdblocks_delta >= 0, file: fs/xfs/xfs_trans.c, line: 610
>>>> ------------[ cut here ]------------
>>>> kernel BUG at fs/xfs/xfs_message.c:102!
>>>> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
>>>> RIP: 0010:assfail+0x9f/0xb0
>>>
>>> What kernel? You've stripped that line out of the stack dump.
>>
>> The initial issue appeared on the v5.10 kernel and occurred multiple times.
>> The current stack is a reproduction I made on linux-next based on the
>> cc13002a9f98 tag: next-20260402.
>
> So why strip it out of the debug output? It doesn't encourage people
> to look at the problem when things like this have been obvious
> stripped from the output.
>
> ....
>

This is my fault. I accidentally deleted the version information when
removing unimportant details.

>>> So your test code is creating a number of fragmented extents to get
>>> to the edge of btree format conversion, then doing a delalloc
>>> write() to create a long delalloc extent range, then is alternating
>>> along the range of the delalloc extent doing:
>>>
>>> loop:
>>> 	sync_file_range(offset, 4096, SYNC_FILE_RANGE_WRITE)
>>> 	fallocate(PUNCH_HOLE, offset, 4096)
>>> 	offset += 4096;
>>>
>>> And so it is converting a single block at the left edge of the
>>> delalloc extent to a written extent which triggers a extent -> btree
>>> conversion, and then you punch out the newly created written extent
>>> triggering a btree -> extent conversion.
>>>
>>> And each time you do this it removes a reserved block from the
>>> delalloc extent for the btree root block, yes?
>>>
>>
>> Yes, this is just a process I designed to facilitate the construction
>> of this problem. In another case, during the delay extent conversion,
>> B-tree splitting continuously consumes reserved blocks.
>
> The worst_indlen calculation should be taking blocks needed for
> BMBT tree splits into account.
>
> It expects to consume (extent len / BMBT records per block) leaf
> blocks for the delalloc extent. It then walks back up the bmbt tree,
> calculating how many node blocks will be needed to index all those
> leaf blocks.  IOWs, it reserves all the node blocks it will need for
> splits to index the growing number of leaf blocks.
>
> i.e. by calculating the number of BMBT blocks required to index the
> delalloc extent being converted into individual single block
> extents, it should have taken into account all the blocks needed for
> all the BMBT splits needed to index the range.
>

I agree with your point, but as I mentioned earlier, xfs_bmap_worst_indlen()
calculates the maximum number of additional blocks required for a single
conversion of a delay extent. If the delay extent is split into multiple
conversions, each converting a portion at a time, it may trigger a btree
split each time. For example, if the delay extent has 10 blocks and 5 blocks
are reserved, and each conversion starts from the beginning and converts one
block at a time, each conversion will trigger a btree split. Assuming each
btree split consumes one block, the conversion process of the initial delay
extent with 10 blocks will actually consume an additional 10 blocks, but
only 5 blocks were initially reserved. The calculation method of 'da_new'
does not even consider this exhaustion scenario.

da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
                          startblockval(PREV.br_startblock) -
                          (bma->cur? bma->cur->bc_bmap.allocated : 0));

Each time a re-conversion occurs, the state of the btree/extent may have
changed. In theory, 'da_new' should be maintained at the value of
xfs_bmap_worst_indlen() to be rigorous.

The original algorithm model is based on the assumption that all changes
in the tree are caused by the continuous conversion of the same delay
extent. However, in a production environment, a file may be used in
segments, and the sources of tree changes are not singular.

>> Essentially,
>> this is because the delay extent conversion process is broken down,
>> which may cause the reserved blocks to be exhausted.
>
> As per above, fragmentation by itself shouldn't cause the indlen
> reservation to be exhausted.
>

Yes, file system fragmentation is just a trigger factor.

>> I think that the scenario of conversion between extents and B-trees
>> may be that the unwritten extents are converted to written extents
>> after the writeback is complete and then the extents are combined,
>> causing the B-tree to be converted to an extent.
>
> Yes, I can see how that could occur - it would need contiguous
> physical extent allocation to keep the number of extents in the file
> at the threshold where:
>
> writeback submission
> -> delalloc
>    -> left contiguous unwritten allocation
>      -> nextents++
>        -> extent_to_btree
>
> IO completion
> -> unwritten conversion
>    -> left merge with written extent
>       -> nextents--
>          -> btree_to_extents
>
> But here's the thing: the extent_to_btree conversion does not
> account blocks allocated to indlen blocks stored in the delalloc
> extent. Yes, it uses blocks that were accounting to the superblock
> as reserved delalloc blocks but the btree root block allocation only
> gets accounted to the superblock and not to the new indlen in the
> remaining delalloc extent.
>
> Hence the data fork can bounce back and forth between extents and
> btree forms across allocation and conversion without having any
> impact on the indlen held in the delalloc extent that is slowly
> being allocated and written.
>
> The problem you are seeing is that indlen is being exhausted
> by something, and that results in passing wasdel = false to the
> extents_to_btree() conversion without a block reservation. We don't
> yet have a plausible explanation of why indlen is being exausted in
> the first place - it's not foramt conversion, and it's not "btree
> splits", so how are we getting to indlen = 0 and triggering this
> issue?
>
> e.g. How much of the delalloc extent remains unallocated when da_old
> reaches zero? Is this an off-by-one corner case of having allocated
> the entire delalloc range and so having consumed all the indlen at
> the same time the last allocation needs to convert the data for to
> btree format?
>

I think in the second paragraph of my response, I gave an example that
can explain how inlen is gradually consumed and eventually becomes 0.

>> This scenario may
>> be triggered by normal service operations. In any case, file system
>> fragmentation is the cause of this problem.
>
> I've not seen any evidence that supports this conclusion yet.
>

What I mean is that file system fragmentation is a contributing factor
to the problem, not the root cause.

>>> How realistic is this scenario in an application/production
>>> environment? I mean, nobody walks through a file syncing data to
>>> disk one fragmented extent at a time only to immediately remove it
>>> before writing the next block.
>>>
>>> We've known that this is possible for a very long time. I've
>>> personally known it can happen in carefully constructed test code
>>> for over 20 years, but I can count on one hand the number of times
>>> I've actually seen this exhaustion occur in a production system.
>>>
>>> The reservation we use here is essentially unchanged since if was
>>> first introduced in 1994, so time in use tells us that the
>>> reservation is largely sufficient for production systems. Can you
>>> describe the situation where you production systems are hitting
>>> this? What is the application actually doing to trigger this
>>> problem?
>>>
>>
>> The extent reduction is not only triggered in the punch hole scenario.
>> In all scenarios where extent merging is triggered, the conversion
>> from B-tree to extent may be performed.
>
> Yes, I know. But in writeback scenarios, only unwritten extent
> conversion can cause merges, and that only happens when we have
> contiguous allocations over the delalloc range.
>
> IOWs, it can't happen when the filesystem is fragmented, as it
> requires repeated contiguous allocation to enable left merging.
> Hence large, uncontested free spaces are required to trigger the
> fork format conversion cycling behaviour, but this is irrelevant
> because I don't think the format cycling is the cause of indlen
> exhaustion....
>

I mentioned from the beginning that format conversion is just one
possible scenario. I designed the path to reproduce this issue in
order to better control the construction of the problem. The current
algorithm does not take into account that the source of btree changes
is not limited to the case of a single delay extent being generated.
In such cases, if a delay extent is split into multiple conversions,
it may lead to the exhaustion of the reserved inlen.

>>> Which begs the question: we fixed some issues with this code back in
>>> 2024, so does this problem still occur on TOT kernels? e.g. commit
>>> d69bee6a35d3 ("xfs: fix xfs_bmap_add_extent_delay_real for partial
>>> conversions") should help address indlen block consumption for
>>> repeated partial conversions.
>>>
>>
>> This patch can solve the issue where the required extra space may not
>> be reserved in time, leading to a writeback failure. However, it cannot
>> address the problem caused by the continuous consumption of the reserved
>> space.
>
> OK, but therein lies the issue: what is the mechanism that causes
> the excessive consumption of the indlen blocks? Is the calculation
> wrong, does it leak blocks when we split the delalloc extent, or
> something else?
>

I think the core of the problem lies in the following code logic.
```
xfs_bmap_add_extent_delay_real
      da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
                               startblockval(PREV.br_startblock) -
                               (bma->cur? bma->cur->bc_bmap.allocated : 0));
```
As I mentioned before, the B-tree changes are not caused by the continuous
generation of a delay extent. A specific delay extent, which is partially
converted each time, happens to reach the critical point of B-tree splitting.
This unfortunate delay extent continuously contributes its reserved space,
and finally, the inlen becomes 0.
I say that fragmentation is the cause of this problem because in fragmented
scenarios, the probability of extent merging decreases, and B-tree splitting
becomes more frequent.

> -Dave.
>

