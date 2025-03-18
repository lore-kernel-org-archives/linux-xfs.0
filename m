Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC5BA934
	for <linux-xfs@vger.kernel.org>; Tue, 18 Mar 2025 00:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742257802; cv=none; b=FlthP82nBc3NOcNGQb/zvFaGYRcNk9Bfk36Nsg/Gp8K625xFly3B++zcY2evMvi3yg6pNQ2p8ALJn5Q6Ec+LjklX6daMfvhwS0RBKvyCnydODz542+5HVOpUYueeiA3NCTsXIQbHOgO5/jF2Og87+Ib0tijw8OoLmvc41JxEuTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742257802; c=relaxed/simple;
	bh=QZpoYyL9638q/DexwqlXcRaEfjnldm6FhTutAC86sTU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PCOWKmVQKG21wiOIY6g2DUWRRp0ofhC3pjeS+lZNRN+vql1U4cmU2+cR035loFP1Ep3hWhOA/omVLXBOlZ9x751J/ng3Y1AsUcAYcEPY3QOduXa4CKiR+fxLsMxAEumj7Szg8clzrYvOI6vGSxetHrwVIub1Ni8TALuGNeGspVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=YeHO0LPk; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="YeHO0LPk"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1742257788; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=0k1ZsMYhNcro7wKC/Mugq1h1gDi/QacLE98lxBM8jYI=;
	b=YeHO0LPkjoUpWebDg5aM/56Natd5tvsXPs6hp52tPQtDugBHghNw5VW7ktc1udWxjI5x3t/ynsPE6L/SvI8jZRrMVo0iLAlWnrP17v0+YcLA4jMvCysvdRuy9gl2JIGH2QGPRMGu3NHSB6GWLnKLEXDSsIvKMJEfHFjJaR5D9lY=
Received: from 30.134.66.95(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WRnQir4_1742257786 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 18 Mar 2025 08:29:47 +0800
Message-ID: <b9871ab8-19c1-4708-99f7-3f91f629aeda@linux.alibaba.com>
Date: Tue, 18 Mar 2025 08:29:46 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [report] Unixbench shell1 performance regression
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Zorro Lang <zlang@redhat.com>
References: <0849fc77-1a6e-46f8-a18d-15699f99158e@linux.alibaba.com>
 <Z9dB4nT2a2k0d5vH@dread.disaster.area>
 <fddda0be-3679-46ae-836c-26580a8d55f4@linux.alibaba.com>
 <Z9iJgWf_RL0vlolN@dread.disaster.area>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <Z9iJgWf_RL0vlolN@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2025/3/18 04:43, Dave Chinner wrote:
> On Mon, Mar 17, 2025 at 08:25:16AM +0800, Gao Xiang wrote:
>> Hi Dave,
>>
>> On 2025/3/17 05:25, Dave Chinner wrote:
>>> On Sat, Mar 15, 2025 at 01:19:31AM +0800, Gao Xiang wrote:
>>>> Hi folks,
>>>>
>>>> Days ago, I received a XFS Unixbench[1] shell1 (high-concurrency)
>>>> performance regression during a benchmark comparison between XFS and
>>>> EXT4:  The XFS result was lower than EXT4 by 15% on Linux 6.6.y with
>>>> 144-core aarch64 (64K page size).  Since Unixbench is somewhat important
>>>> to indicate overall system performance for many end users, it's not
>>>> a good result.
>>>
>>> Unixbench isn't really that indicative of typical worklaods on large
>>> core-count machines these days. It's an ancient benchmark, and it's
>>> exceedingly rare that a modern machine is fully loaded with shell
>>> scripts such as the shell1 test is running because it's highly
>>> inefficient to do large scale concurrent processing of data in this
>>> way....
>>>
>>> Indeed, look at the file copy "benchmarks" it runs - the use buffer
>>> sizes of 256, 1024 and 4096 bytes to tell you how well the
>>> filesystem performs. Using sub-page size buffers might have been
>>> common for 1983-era CPUs to get the highest possible file copy
>>> throughput, but these days these are slow paths that we largely
>>> don't optimise for highest throughput. Measuring modern system
>>> scalability via how such operations perform is largely meaningless
>>> because applications don't behave this way anymore....
>>
>> Thanks for your reply!
>>
>> Sigh.  Many customers really care, and they select the whole software
>> stack based on this benchmark.
> 
> People using benchmarks that have no relevance to their
> software/application stack behaviour as the basis of their purchase
> decisions has been happening for decades.

They even know nothing.  Unixbench is already a practice for them,
I cannot argue about that.

> 
>> If they think the results are not good, they might ask us to move away
>> of XFS filesystem.  It's not what I could do anything, you know.
> 
> If they think there is a filesystem better suited to their
> requirements than XFS, then they are free to make that decision
> themselves. We can point out that their selection metrics are
> irrelevant to their actual workload, but in my experience this just
> makes the people running the selection trial more convinced they are
> right and they still make a poor decision....

The problem is not simple like this, what we'd like is to provide
a unique cloud image for users to use.  It's impossible for us to
provide two images for two filesystems.  But Unixbench is still
important for many users, so either we still to XFS or switch back
to EXT4.

> 
>>>> shell1 test[2] basically runs in a loop that it executes commands
>>>> to generate files (sort.$$, od.$$, grep.$$, wc.$$) and then remove
>>>> them.  The testcase lasts for one minute and then show the total number
>>>> of iterations.
>>>>
>>>> While no difference was observed in single-threaded results, it showed
>>>> a noticeable difference above if  `./Run shell1 -c 144 -i 1`  is used.
>>>
>>> I'm betting that the XFS filesystem is small and only has 4 AGs,
>>> and so has very limited concurrency in allocation.
>>>
>>> i.e. you're trying to run a massively concurrent workload on a
>>> filesystem that only has - at best - the ability to do 4 allocations
>>> or frees at a time. Of course it is going to contend on the
>>> allocation group locks....
>>
>> I've adjusted this, from 4 AG to 20 AG.  No real impact.
> 
> Yup, still very limited concurrency considering that you are running
> 144 instances of that workload (which, AFAICT, are all doing
> independent work).  This implies that a couple of hundred AGs would
> be needed to provide sufficient allocation concurrency for this sort
> of workload.

Hmm.. We shipped a unique traditional rootfs image to all users, we
cannot adjust AG numbers according to specific workload like this
because increasing AG numbers is not always good for many other
workloads.

But I could try to use 144 AG and retest again.

> 
>>>> I tried to do some hack to disable defer inode inactivation as below,
>>>> the shell1 benchmark then recovered: XFS (35649.6 -> 37810.9):
>>>>
>>>> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
>>>> index 7b6c026d01a1..d9fb2ef3686a 100644
>>>> --- a/fs/xfs/xfs_icache.c
>>>> +++ b/fs/xfs/xfs_icache.c
>>>> @@ -2059,6 +2059,7 @@ void
>>>>    xfs_inodegc_start(
>>>>    	struct xfs_mount	*mp)
>>>>    {
>>>> +	return;
>>>>    	if (xfs_set_inodegc_enabled(mp))
>>>>    		return;
>>>>
>>>> @@ -2180,6 +2181,12 @@ xfs_inodegc_queue(
>>>>    	ip->i_flags |= XFS_NEED_INACTIVE;
>>>>    	spin_unlock(&ip->i_flags_lock);
>>>>
>>>> +	if (1) {
>>>> +		xfs_iflags_set(ip, XFS_INACTIVATING);
>>>> +		xfs_inodegc_inactivate(ip);
>>>> +		return;
>>>> +	}
>>>
>>> That reintroduces potential deadlock vectors by running blocking
>>> transactions directly from iput() and/or memory reclaim. That's one
>>> of the main reasons we moved inactivation to a background thread -
>>> it gets rid of an entire class of potential deadlock problems....
>>
>> Yeah, I noticed that too, mainly
>> commit 68b957f64fca ("xfs: load uncached unlinked inodes into memory
>> on demand").
> 
> That is not related to the class of deadlocks and issues I'm
> referring to. Running a transaction in memory reclaim context (i.e.
> shrinker evicts the inode from memory) means that memory reclaim now
> blocks on journal space, IO, buffer locks, etc.
> 
> The sort of deadlock that this can cause is a non-transactional
> operation above memory reclaim holding a buffer lock (e.g. bulkstat
> reading the AGI btree), then requiring memory allocation (e.g.
> pulling a AGI btree block into memory) which triggers direct memory
> reclaim, which then tries to inactivate an inode, which then
> (for whatever reason) requires taking a AGI btree block lock....

Yeah, we don't have a context to know AGI lock is locked before.

> 
> That is the class of potential deadlock that background inode
> inactivation avoids completely. It also avoids excessive inode
> eviction latency (important as shrinkers run from direct reclaim
> are supposed to be non-blocking) and other sub-optimal inode
> eviction behaviours from occurring...

I know, what I meant was a direct problem if I hack to revert to
the old way even I don't care about the memory reclaim deadlock.

It seems the in-core unlink list is heavily relied on this feature
too, so I don't have a good way anyway.

Thanks,
Gao Xiang

> 
> -Dave.

