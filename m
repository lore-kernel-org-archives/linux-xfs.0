Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78DA2C1586
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 18:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769624922; cv=none; b=Oa5SlM4Hb3uO5+MmGF6alPlS/1Cr3eyurkmV+FZ3QdWHuJgF0OBERnJ9tKuJ3GrT3xkRtnYPbhVjv/nbGQktfOlTZNBzxkZiQdjtSxF5qjU3pH2zcrB1koYHaR7wzd8e9mkACLJR4a6vM7IxQP3WrlLVYpJCSuNJcK48Rzh/Grk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769624922; c=relaxed/simple;
	bh=CdhBpB1ZCtEE4ieyjq9E1Pk0TrArQS2Ka78YbLwQIWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=o0HdnzzTUCNSSdvOVTW1TDBdj3L0w/CG2RReR0dnHkVS2XU5PxWBy/2pJCG6unql4fk+KIi73h8cwjo/pfW/5yVrO3dZ2r3bYbwF8rZjWk41TAPPBqbP9mqdzCG0vOX/kYVqUOi5ZHU0ABwRX12/EwWV+R3nXKJ9+DN3IMUheuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=iYX4NjbP; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="iYX4NjbP"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260128182832epoutp0393f7ee341f6f2410acea2bcbdef8ee95~O_HtS6L5f0383003830epoutp03g
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 18:28:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260128182832epoutp0393f7ee341f6f2410acea2bcbdef8ee95~O_HtS6L5f0383003830epoutp03g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769624912;
	bh=Gv/5Xt5C0T/YMiB+ioPeuN7YCtbrmm2qxsQAlrljD6Y=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=iYX4NjbPBd+DYQo+o5WCO8ERNTfIep1jhDC/a5T/0558AL1eOhPx2dTSPP0HYVg59
	 upTXe94Mc68C/IU48OM7JZGr3JExW+BXPhRAJQ0IxhXdywmLryhM6MLE9YgJfmorbv
	 BPuG46Av8oYzBr+LlRbY2s9Rm6yTPF2PsbzCyIck=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260128182831epcas5p3fde99bd45f69e11c6dce8036e6f425c3~O_HsdlJIA0474704747epcas5p3U;
	Wed, 28 Jan 2026 18:28:31 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.86]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4f1W4G2GGfz6B9m4; Wed, 28 Jan
	2026 18:28:30 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260128182829epcas5p4398956f380795d9a862229c6766da668~O_HrDPcjj1514815148epcas5p4E;
	Wed, 28 Jan 2026 18:28:29 +0000 (GMT)
Received: from [107.111.86.57] (unknown [107.111.86.57]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260128182826epsmtip13b5776ddc5ea3f1f65ffa668a59ca21a~O_HoEqOlZ0743607436epsmtip10;
	Wed, 28 Jan 2026 18:28:26 +0000 (GMT)
Message-ID: <e7413e3b-3fae-4aab-90a1-4a6695156b2e@samsung.com>
Date: Wed, 28 Jan 2026 23:58:25 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] AG aware parallel writeback for XFS
Content-Language: en-US
To: Brian Foster <bfoster@redhat.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	djwong@kernel.org, dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, anuj20.g@samsung.com,
	vishak.g@samsung.com, joshi.k@samsung.com
From: Kundan Kumar <kundan.kumar@samsung.com>
In-Reply-To: <aXN3EtxKFXX8DEbl@bfoster>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260128182829epcas5p4398956f380795d9a862229c6766da668
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4
References: <CGME20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4@epcas5p1.samsung.com>
	<20260116100818.7576-1-kundan.kumar@samsung.com> <aXEvAD5Rf5QLp4Ma@bfoster>
	<ca048ecf-5aec-4a0d-8faf-ad9fcd310e21@samsung.com>
	<aXN3EtxKFXX8DEbl@bfoster>

On 1/23/2026 6:56 PM, Brian Foster wrote:
> On Thu, Jan 22, 2026 at 09:45:05PM +0530, Kundan Kumar wrote:
>>>
>>> Could you provide more detail on how you're testing here? I threw this
>>> at some beefier storage I have around out of curiosity and I'm not
>>> seeing much of a difference. It could be I'm missing some details or
>>> maybe the storage outweighs the processing benefit. But for example, is
>>> this a fio test command being used? Is there preallocation? What type of
>>> storage? Is a particular fs geometry being targeted for this
>>> optimization (i.e. smaller AGs), etc.?
>>
>> Thanks Brian for the detailed review and for taking the time to
>> look through the code.
>>
>> The numbers quoted were from fio buffered write workloads on NVMe
>> (Optane devices), using multiple files placed in different
>> directories mapping to different AGs. Jobs were buffered
>> randwrite with multiple jobs. This can be tested with both
>> fallocate=none or otherwise.
>>
>> Sample script for 12 jobs to 12 directories(AGs) :
>>
>> mkfs.xfs -f -d agcount=12 /dev/nvme0n1
>> mount /dev/nvme0n1 /mnt
>> sync
>> echo 3 > /proc/sys/vm/drop_caches
>>
>> for i in {1..12}; do
>>     mkdir -p /mnt/dir$i
>> done
>>
>> fio job.fio
>>
>> umount /mnt
>> echo 3 > /proc/sys/vm/drop_caches
>>
>> The job file :
>>
>> [global]
>> bs=4k
>> iodepth=32
>> rw=randwrite
>> ioengine=io_uring
>> fallocate=none
>> nrfiles=12
>> numjobs=1
>> size=6G
>> direct=0
>> group_reporting=1
>> create_on_open=1
>> name=test
>>
>> [job1]
>> directory=/mnt/dir1
>>
>> [job2]
>> directory=/mnt/dir2
>> ...
>> ...
>> [job12]
>> directory=/mnt/dir12
>>
> 
> Thanks..
> 
>>>
>>> FWIW, I skimmed through the code a bit and the main thing that kind of
>>> stands out to me is the write time per-folio hinting. Writeback handling
>>> for the overwrite (i.e. non-delalloc) case is basically a single lookup
>>> per mapping under shared inode lock. The question that comes to mind
>>> there is what is the value of per-ag batching as opposed to just adding
>>> generic concurrency? It seems unnecessary to me to take care to shuffle
>>> overwrites into per-ag based workers when the underlying locking is
>>> already shared.
>>>
>>
>> That’s a fair point. For the overwrite (non-delalloc) case, the
>> per-folio AG hinting is not meant to change allocation behavior, and
>> I agree the underlying inode locking remains shared. The primary value
>> I’m seeing there is the ability to partition writeback iteration and
>> submission when dirty data spans multiple AGs.
>> I will try routing overwrite writeback to workers irrespective of AG
>> (e.g. hash/inode based), to compare between generic concurrency vs AG
>> batching.
>>
>>> WRT delalloc, it looks like we're basically taking the inode AG as the
>>> starting point and guessing based on the on-disk AGF free blocks counter
>>> at the time of the write. The delalloc accounting doesn't count against
>>> the AGF, however, so ISTM that in many cases this would just effectively
>>> land on the inode AG for larger delalloc writes. Is that not the case?
>>>
>>> Once we get to delalloc writeback, we're under exclusive inode lock and
>>> fall into the block allocator. The latter trylock iterates the AGs
>>> looking for a good candidate. So what's the advantage of per-ag
>>> splitting delalloc at writeback time if we're sending the same inode to
>>> per-ag workers that all 1. require exclusive inode lock and 2. call into
>>> an allocator that is designed to be scalable (i.e. if one AG is locked
>>> it will just move to the next)?
>>>
>>
>> The intent of per-AG splitting is not to parallelize allocation
>> within a single inode or override allocator behavior, but to
>> partition writeback scheduling so that inodes associated with
>> different AGs are routed to different workers. This implicitly
>> distributes inodes across AG workers, even though each inode’s
>> delalloc conversion remains serialized.
>>
>>> Yet another consideration is how delalloc conversion works at the
>>> xfs_bmapi_convert_delalloc() -> xfs_bmapi_convert_one_delalloc() level.
>>> If you take a look at the latter, we look up the entire delalloc extent
>>> backing the folio under writeback and attempt to allocate it all at once
>>> (not just the blocks backing the folio). So in theory if we were to end
>>> up tagging a sequence of contiguous delalloc backed folios at buffered
>>> write time with different AGs, we're still going to try to allocate all
>>> of that in one AG at writeback time. So the per-ag hinting also sort of
>>> competes with this by shuffling writeback of the same potential extent
>>> into different workers, making it a little hard to try and reason about.
>>>
>>
>> Agreed — delalloc conversion happens at extent granularity, so
>> per-folio AG hints are not meant to steer final allocation. In this
>> series the hints are used purely as writeback scheduling tokens;
>> allocation still occurs once per extent under XFS_ILOCK_EXCL using
>> existing allocator logic. The goal is to partition writeback work and
>> avoid funneling multiple inodes through a single writeback path, not
>> to influence extent placement.
>>
> 
> Yeah.. I realize none of this is really intended to drive allocation
> behavior. The observation that all this per-folio tracking ultimately
> boils down to either sharding based on information we have at writeback
> time (i.e. overwrites) or effectively batching based on on-disk AG state
> at the time of the write is kind of what suggests that the folio
> granular hinting is potentially overkill.
> 
>>> So stepping back it kind of feels to me like the write time hinting has
>>> so much potential for inaccuracy and unpredictability of writeback time
>>> behavior (for the delalloc case), that it makes me wonder if we're
>>> effectively just enabling arbitrary concurrency at writeback time and
>>> perhaps seeing benefit from that. If so, that makes me wonder if the
>>> associated value can be gained by somehow simplifying this to not
>>> require write time hinting at all.
>>>
>>> Have you run any experiments that perhaps rotors inodes to the
>>> individual wb workers based on the inode AG (i.e. basically ignoring all
>>> the write time stuff) by chance? Or anything that otherwise helps
>>> quantify the value of per-ag batching over just basic concurrency? I'd
>>> be interested to see if/how behavior changes with something like that.
>>
>> Yes, inode-AG based routing has been explored as part of earlier
>> higher-level writeback work (link below), where inodes are affined to
>> writeback contexts based on inode AG. That effectively provides
>> generic concurrency and serves as a useful baseline.
>> https://lore.kernel.org/all/20251014120845.2361-1-kundan.kumar@samsung.com/
>>
> 
> Ah, I recall seeing that. A couple questions..
> 
> That link states the following:
> 
> "For XFS, affining inodes to writeback threads resulted in a decline
> in IOPS for certain devices. The issue was caused by AG lock contention
> in xfs_end_io, where multiple writeback threads competed for the same
> AG lock."
> 
> Can you quantify that? It seems like xfs_end_io() mostly cares about
> things like unwritten conversion, COW remapping, etc., so block
> allocation shouldn't be prominent. Is this producing something where
> frequent unwritten conversion results in a lot of bmapbt splits or
> something?
> 

I captured stacks from the contending completion workers and the hotspot
is in the unwritten conversion path
(xfs_end_io() -> xfs_iomap_write_unwritten()). We were repeatedly
contending on the AGF buffer lock via xfs_alloc_fix_freelist() /
xfs_alloc_read_agf() when writeback threads were affined per-inode.
This contention went away once writeback was distributed across
AG-based workers, pointing to reduced AGF hotspotting during unwritten
conversion (rmap/btree updates and freelist fixes), rather than block
allocation in the write path itself.

> Also, how safe is it is to break off writeback tasks at the XFS layer
> like this? For example, is it safe to spread around the wbc to a bunch
> of tasks like this? What about serialization for things like bandwidth
> accounting and whatnot in the core/calling code?  Should the code that
> splits off wq tasks in XFS be responsible to wait for parallel
> submission completion before returning (I didn't see anything doing that
> on a scan, but could have missed it)..?
> 

You are right that core writeback accounting assumes serialized
updates. The current series copies wbc per worker to avoid concurrent
mutation, but that is not sufficient for strict global accounting
semantics.

For this series we only offload the async path
(wbc->sync_mode != WB_SYNC_ALL), so we do not wait for worker completion
before returning from ->writepages(). Sync writeback continues down the
existing iomap_writepages path.

>> The motivation for this series is the complementary case where a
>> single inode’s dirty data spans multiple AGs on aged/fragmented
>> filesystems, where inode-AG affinity breaks down. The folio-level AG
>> hinting here is intended to explore whether finer-grained partitioning
>> provides additional benefit beyond inode-based routing.
>>
> 
> But also I'm not sure I follow the high level goal here. I have the same
> question as Pankaj in that regard.. is this series intended to replace
> the previous bdi level approach, or go along with it somehow? Doing
> something at the bdi level seems like a more natural approach in
> general, so I'm curious why the change in direction.
> 
> Brian
> 

This series is intended to replace the earlier BDI-level approach for
XFS, not to go alongside it. While BDI-level sharding is the more
natural generic mechanism, we saw XFS regressions on some setups when
inodes were affined to wb threads due to completion-side AG contention.

The goal here is to make concurrency an XFS policy decision by routing
writeback using AG-aware folio tags, so we avoid inode-affinity
hotspots and handle cases where a single inode spans multiple AGs on
aged or fragmented filesystems.

If this approach does not hold up across workloads and devices, we can
fall back to the generic BDI sharding model.

- Kundan

