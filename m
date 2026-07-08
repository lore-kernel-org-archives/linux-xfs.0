Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20C3314A65
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2026 13:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783516874; cv=none; b=h9M359BUHDpP36A1zoMls+2zs8VXqwvOJBO2YbBU8m3okTSJOM8PtbH26LI6w7YDDfEbPlHY/ahIH6+bbbevqSUjOMCdGRvjpZWSO7WtsHTGNCd/f0dj6uuPeUQnvqw2vIDggjOfSimLU4oWuUipHvEvAzIZEGd20+b+XkZMmaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783516874; c=relaxed/simple;
	bh=6j3wUJOaZj/s/fdQRA/CO1UJ0kmuAe/kadTnS+esm6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o6pj5WY0e2HxvdJkobOJ4xGv12xHxE58BONghZxbO+ueYLtds0Aa3GlG8cAqGeb0KLBjGjsl88bSVh+aPJPX4SXV9LIt4oR0wrOtgqzqbJi/tlb46iHnCC0Fjx36m3HefC37XbAHcNg58l/vQE7vkgAB+j4THw2C+Oh7dJQKEJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pNKXumOt; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pNKXumOt"
Message-ID: <aafea4b8-8e52-421f-92d6-e15bd7767168@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783516869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t6sm6XAgSC5AwQbaH/rNB1gfme8fYDaqlqOT1L5/w9w=;
	b=pNKXumOtnGmsUHgH1PP8qelsxCRf31emgVobAUjk834icy/nhGR4k0FTjFJc1/hJiZsB5d
	p6JlDoZCUArjlLwY7jXvxjdL2Ko/hzlKL+fAj+8EQiSQ+xf9ZuKdRf5x87kE/gU2zgZmsz
	6ytJH6Atiqz7uv9pI0tffsp7JG3xqoI=
Date: Wed, 8 Jul 2026 15:21:06 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] generic/795: add unaligned boundary test cases for
 WRITE_ZEROES
To: Zhang Yi <yi.zhang@huaweicloud.com>, Christoph Hellwig <hch@lst.de>
Cc: Pankaj Raghav <p.raghav@samsung.com>, zlang@redhat.com,
 fstests@vger.kernel.org, djwong@kernel.org, yi.zhang@huawei.com,
 linux-xfs@vger.kernel.org
References: <20260703125422.3110429-1-p.raghav@samsung.com>
 <ca21b3c4-e1df-4ba7-8e9c-5d221337c86b@huaweicloud.com>
 <20260707051015.GA13010@lst.de>
 <e52af771-da66-48e3-a6a0-b0c31dc8b3a9@huaweicloud.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <e52af771-da66-48e3-a6a0-b0c31dc8b3a9@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 7/7/26 08:38, Zhang Yi wrote:
> On 7/7/2026 1:10 PM, Christoph Hellwig wrote:
>> On Tue, Jul 07, 2026 at 11:08:39AM +0800, Zhang Yi wrote:
>>>> +# WRITE_ZEROES must leave the whole requested range backed by *written*
>>>> +# (zeroed) extents while preserving the out-of-range bytes of the partial
>>>> +# boundary units. The possible scenarios are: written_edges, hole_edges,
>>>> +# unwritten_edges and delalloc_edges.
>>>
>>> unwritten_edges needs to distinguish between dirty and clean scenarios.
>>> The expected result for clean should be tmp.zero, while the expected
>>> result for dirty should be tmp.pattern.
>>
>> Does it?  I'd expect everything in the range to be zeroed, and everything
>> outside to be left alone, as the dirty state is just an imlementation
>> detail not visible to the user.
> 
> Yes, although this detail is not perceptible to the user, the final
> results of these two scenarios are different.
> 
> For clean unwritten extents, the portion beyond the range up to the
> aligned block boundary should be zeroed; otherwise, stale data may be
> exposed after unwritten-to-written conversion. So the result should
> be tmp.zero.
> 
> For dirty unwritten extents, all data outside the inode boundary
> should be left untouched, so the result should be tmp.pattern.
> 
>> Similar to other falloc operations,
>> I'd expect the file system to write back any boundary block first
>> to make the dirty state difference moot.
>>
> 
> In fact, in ext4, for dirty extents (including both dirty delalloc and
> dirty unwritten extents), they are not written back first. Instead, the
> unaligned boundary blocks are zeroed out directly, followed by a
> synchronous write-back before the syscall returns, ensuring the extents
> are converted to the written state. This point differs from the behavior
> of XFS.
> 

I had a similar question as Christoph. But I will include dirty unwritten
test case as well, as ext4 impl may slightly differ.

Thanks for the point about the FIEMAP. I will change it to use filefrag.

I will send the patches soon.

Btw, I tested ext4 and it failed the test. I assume there is a fix on the way for ext4? And did you
also test this for bigalloc configuration? I ran into some issues with bigrtalloc (alloc size >
block size). I am wondering if you hit a similar issue in ext4 for biglloc configs.

--
Pankaj
