Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CD136D513;
	Thu,  9 Jul 2026 02:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783564375; cv=none; b=a9rhQaDmeShpwiuR/b3hvlB1R4e7Drr5rEjMN6gcej8a9tEYZ+e3MBqmTEDX/d02ydW9J3kfVgXbT6DFQSPjfFGWQBfqZdTeQLQi000nEQ3rDqEJDTYh0jv1CUMASuxQwBsqkRsDaZmPWM0gD/cz53jsNaV1xZl2QOeFdn0rB/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783564375; c=relaxed/simple;
	bh=YSOgEhqJnUguf9aF/NtbkzpflOQlwMs2FX87XMu2JWY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LDazW0w/3LYRQ7LmKeztkGJb29i6ly+KFOrNRyK2eTTSslb6h7U3wJz8tf/CPWDeqxX8jdvhdXVajiFfjmuU7r47pz/WA9MHv9mQVpQ9um54nzl1trzge5Z0PMlue33WssPIxX4xl+9oZ3dd+zc/K7DfdGnFxR3U7kCgLCcVVs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gwfBT54vLzYQtht;
	Thu,  9 Jul 2026 10:32:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id B6CE14057B;
	Thu,  9 Jul 2026 10:32:39 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCX8W1FCE9qb9lCAg--.17015S3;
	Thu, 09 Jul 2026 10:32:39 +0800 (CST)
Message-ID: <82e2b175-7961-4133-94f6-209f97cbafe7@huaweicloud.com>
Date: Thu, 9 Jul 2026 10:32:37 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] generic/795: add unaligned boundary test cases for
 WRITE_ZEROES
To: Pankaj Raghav <pankaj.raghav@linux.dev>, Christoph Hellwig <hch@lst.de>
Cc: Pankaj Raghav <p.raghav@samsung.com>, zlang@redhat.com,
 fstests@vger.kernel.org, djwong@kernel.org, yi.zhang@huawei.com,
 linux-xfs@vger.kernel.org
References: <20260703125422.3110429-1-p.raghav@samsung.com>
 <ca21b3c4-e1df-4ba7-8e9c-5d221337c86b@huaweicloud.com>
 <20260707051015.GA13010@lst.de>
 <e52af771-da66-48e3-a6a0-b0c31dc8b3a9@huaweicloud.com>
 <aafea4b8-8e52-421f-92d6-e15bd7767168@linux.dev>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <aafea4b8-8e52-421f-92d6-e15bd7767168@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgCX8W1FCE9qb9lCAg--.17015S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZw4UZF4UXFWrtr18Zw1kZrb_yoW5WFWkpF
	ZrWa45tr4kGr4UGwn7tr1qqr1FyrWfGFWUWr1vqryIvas0kF17KrnIg3y09F92kr4rG3WY
	vF40qFy3A3Z8Z3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVWxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
	k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1veHDUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 7/8/2026 9:21 PM, Pankaj Raghav wrote:
> 
> 
> On 7/7/26 08:38, Zhang Yi wrote:
>> On 7/7/2026 1:10 PM, Christoph Hellwig wrote:
>>> On Tue, Jul 07, 2026 at 11:08:39AM +0800, Zhang Yi wrote:
>>>>> +# WRITE_ZEROES must leave the whole requested range backed by *written*
>>>>> +# (zeroed) extents while preserving the out-of-range bytes of the partial
>>>>> +# boundary units. The possible scenarios are: written_edges, hole_edges,
>>>>> +# unwritten_edges and delalloc_edges.
>>>>
>>>> unwritten_edges needs to distinguish between dirty and clean scenarios.
>>>> The expected result for clean should be tmp.zero, while the expected
>>>> result for dirty should be tmp.pattern.
>>>
>>> Does it?  I'd expect everything in the range to be zeroed, and everything
>>> outside to be left alone, as the dirty state is just an imlementation
>>> detail not visible to the user.
>>
>> Yes, although this detail is not perceptible to the user, the final
>> results of these two scenarios are different.
>>
>> For clean unwritten extents, the portion beyond the range up to the
>> aligned block boundary should be zeroed; otherwise, stale data may be
>> exposed after unwritten-to-written conversion. So the result should
>> be tmp.zero.
>>
>> For dirty unwritten extents, all data outside the inode boundary
>> should be left untouched, so the result should be tmp.pattern.
>>
>>> Similar to other falloc operations,
>>> I'd expect the file system to write back any boundary block first
>>> to make the dirty state difference moot.
>>>
>>
>> In fact, in ext4, for dirty extents (including both dirty delalloc and
>> dirty unwritten extents), they are not written back first. Instead, the
>> unaligned boundary blocks are zeroed out directly, followed by a
>> synchronous write-back before the syscall returns, ensuring the extents
>> are converted to the written state. This point differs from the behavior
>> of XFS.
>>
> 
> I had a similar question as Christoph. But I will include dirty unwritten
> test case as well, as ext4 impl may slightly differ.
> 
> Thanks for the point about the FIEMAP. I will change it to use filefrag.
> 
> I will send the patches soon.

Thank you!

> 
> Btw, I tested ext4 and it failed the test. I assume there is a fix on the way for ext4? And did you
> also test this for bigalloc configuration? I ran into some issues with bigrtalloc (alloc size >
> block size). I am wondering if you hit a similar issue in ext4 for biglloc configs.
> 

Yes, there are issues in the current ext4 that need to be fixed, and I
have already sent out the fixed patch set [1]. I have run several
rounds of this test on my machine, including bigalloc scenarios, and
everything looks fine by now.

After applying this patch set, does the issue you encountered still
exist?

Thanks,
Yi.

[1] https://lore.kernel.org/linux-ext4/20260708062049.1982410-1-yi.zhang@huaweicloud.com/

