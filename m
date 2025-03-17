Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A1D2FB2
	for <linux-xfs@vger.kernel.org>; Mon, 17 Mar 2025 00:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742171135; cv=none; b=pamGco1cteIpGmbjJNf2olNj4v/LoCdyNXXINnaI+HF0HRsWuiJSs+rhepfyuwh2bNg9iCs61Ld1KK9LaQDPU+bWsRzIkI7l355n0FND+bJoXh5VpoyJ+yof170D2zKjzWUhN1WNTFupEamVc0p5OhsQlTvsxAB9JwFKkuo/Ol8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742171135; c=relaxed/simple;
	bh=2WL8Ke2eCG4Jo/sZK68XiciDXSVLdkWkTtTaoZK/iUk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ep3DyKNfgEM+ivCihfPBgYm852wDmXR6w5xmyOIC2AEH+/s7znhpSfuB8SzNrCkCYnnMO523i9816tdNnr1zk2MjkSSftDZa1F03xE3Z45nzvv2mAyO3iUmV1L/Rt2KhA/zrIyeaDGfpY6Nu/+YBbS7pEDbbtxOO+htQgryKzuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=YTC13QFr; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="YTC13QFr"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1742171124; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=3C5TEtEWnL/HxfGzgzYQYQFKcIGYPRwA/oXYyPTg55M=;
	b=YTC13QFrIJBb5SMZpOsQJRotfKUw6SRNZH4qPNiWtsTwGt5kYbpKBZex5ng2u0fe4F2qP5ro1qOSpqzquvpVhMqSTa/GPwAXBKfAwrnrnLGqrMDrTul95VDeaaUtV6S1SeZnVqoZBOQcDBEp3MFFdJIcvXH5KFR2QDHJFtgoyh4=
Received: from 30.134.66.95(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WRX5ljM_1742171118 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 17 Mar 2025 08:25:23 +0800
Message-ID: <fddda0be-3679-46ae-836c-26580a8d55f4@linux.alibaba.com>
Date: Mon, 17 Mar 2025 08:25:16 +0800
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
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <Z9dB4nT2a2k0d5vH@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave,

On 2025/3/17 05:25, Dave Chinner wrote:
> On Sat, Mar 15, 2025 at 01:19:31AM +0800, Gao Xiang wrote:
>> Hi folks,
>>
>> Days ago, I received a XFS Unixbench[1] shell1 (high-concurrency)
>> performance regression during a benchmark comparison between XFS and
>> EXT4:  The XFS result was lower than EXT4 by 15% on Linux 6.6.y with
>> 144-core aarch64 (64K page size).  Since Unixbench is somewhat important
>> to indicate overall system performance for many end users, it's not
>> a good result.
> 
> Unixbench isn't really that indicative of typical worklaods on large
> core-count machines these days. It's an ancient benchmark, and it's
> exceedingly rare that a modern machine is fully loaded with shell
> scripts such as the shell1 test is running because it's highly
> inefficient to do large scale concurrent processing of data in this
> way....
> 
> Indeed, look at the file copy "benchmarks" it runs - the use buffer
> sizes of 256, 1024 and 4096 bytes to tell you how well the
> filesystem performs. Using sub-page size buffers might have been
> common for 1983-era CPUs to get the highest possible file copy
> throughput, but these days these are slow paths that we largely
> don't optimise for highest throughput. Measuring modern system
> scalability via how such operations perform is largely meaningless
> because applications don't behave this way anymore....

Thanks for your reply!

Sigh.  Many customers really care, and they select the whole software
stack based on this benchmark.

If they think the results are not good, they might ask us to move away
of XFS filesystem.  It's not what I could do anything, you know.

> 
>> shell1 test[2] basically runs in a loop that it executes commands
>> to generate files (sort.$$, od.$$, grep.$$, wc.$$) and then remove
>> them.  The testcase lasts for one minute and then show the total number
>> of iterations.
>>
>> While no difference was observed in single-threaded results, it showed
>> a noticeable difference above if  `./Run shell1 -c 144 -i 1`  is used.
> 
> I'm betting that the XFS filesystem is small and only has 4 AGs,
> and so has very limited concurrency in allocation.
> 
> i.e. you're trying to run a massively concurrent workload on a
> filesystem that only has - at best - the ability to do 4 allocations
> or frees at a time. Of course it is going to contend on the
> allocation group locks....

I've adjusted this, from 4 AG to 20 AG.  No real impact.

> 
>> The original report was on aarch64, but I could still reproduce some
>> difference on Linux 6.13 with a X86 physical machine:
>>
>> Intel(R) Xeon(R) Platinum 8331C CPU @ 2.50GHz * 96 cores
>> 512 GiB memory
>>
>> XFS (35649.6) is still lower than EXT4 (37146.0) by 4% and
>> the kconfig is attached.
>>
>> However, I don't observe much difference on 5.10.y kernels.  After
>> collecting some off-CPU trace, I found there are many new agi buf
>> lock waits compared with the correspoinding 5.10.y trace, as below:
> 
> Yes, because background inactivation can increase the contention on
> AGF/AGI buffer locks when there is insufficient concurrency in the
> filesystem layout. It is rare, however, that any workload other that
> benchmarks generate enough load and/or concurrency to reach the
> thresholds where such lock breakdown occurs.
> 
>> I tried to do some hack to disable defer inode inactivation as below,
>> the shell1 benchmark then recovered: XFS (35649.6 -> 37810.9):
>>
>> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
>> index 7b6c026d01a1..d9fb2ef3686a 100644
>> --- a/fs/xfs/xfs_icache.c
>> +++ b/fs/xfs/xfs_icache.c
>> @@ -2059,6 +2059,7 @@ void
>>   xfs_inodegc_start(
>>   	struct xfs_mount	*mp)
>>   {
>> +	return;
>>   	if (xfs_set_inodegc_enabled(mp))
>>   		return;
>>
>> @@ -2180,6 +2181,12 @@ xfs_inodegc_queue(
>>   	ip->i_flags |= XFS_NEED_INACTIVE;
>>   	spin_unlock(&ip->i_flags_lock);
>>
>> +	if (1) {
>> +		xfs_iflags_set(ip, XFS_INACTIVATING);
>> +		xfs_inodegc_inactivate(ip);
>> +		return;
>> +	}
> 
> That reintroduces potential deadlock vectors by running blocking
> transactions directly from iput() and/or memory reclaim. That's one
> of the main reasons we moved inactivation to a background thread -
> it gets rid of an entire class of potential deadlock problems....

Yeah, I noticed that too, mainly
commit 68b957f64fca ("xfs: load uncached unlinked inodes into memory
on demand").

Thanks,
Gao Xiang

> 
> -Dave.

