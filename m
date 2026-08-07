Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3FE2E764D;
	Fri,  7 Aug 2026 01:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786066076; cv=none; b=VkIVXO1qGmmFgVv7aHkrGX8EobWBNt3Hm1pH4Iv2cLrPeZyAIA2Q9VUVOBW5yq2HfYdCkNtCCaxmLKDyMhajJ7p50sB3ZG2EWYd8IzcJyBvsXQViNqQ4T4In+RxvUceTLHOtP95F6/1Nnog24qY1YdEAPsKqtei8+mumj+fyMCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786066076; c=relaxed/simple;
	bh=lpJTDr3pb/KNQZ/CIQGrWUo8y1y/bM9Y95IqYH9B6dg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HrGdisOc84RHEGEaly9pcuCxxRfXaFjfHHabp+A5b+geSoeCWQz+A1ZAhPuUEVhs9DzAa0TLp0vIp51FKVE2cEZ5y3Yuytqnulf6y5NiYnIIcduzWLNjn/yWF8Dj8AF5kETla7YCz7wB9u4chJngDg3qkVqmWxanXyySkA3OHo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hGRN053BszKHMWl;
	Fri,  7 Aug 2026 09:27:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 68B454058D;
	Fri,  7 Aug 2026 09:27:37 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgA3J0aGNHVqNE6SBQ--.39735S3;
	Fri, 07 Aug 2026 09:27:37 +0800 (CST)
Message-ID: <e2179651-0e18-4e9a-81c0-9b9dc639acfd@huaweicloud.com>
Date: Fri, 7 Aug 2026 09:27:34 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/5] iomap: support invalidating partial folios
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, brauner@kernel.org, djwong@kernel.org,
 hch@infradead.org, joannelkoong@gmail.com, "Theodore Y. Ts'o"
 <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, Matthew Wilcox <willy@infradead.org>,
 ziy@nvidia.com, yi.zhang@huawei.com, yizhang089@gmail.com,
 chengzhihao1@huawei.com, yangerkun@huawei.com, yukuai@fnnas.com
References: <20260714082325.325163-1-yi.zhang@huaweicloud.com>
 <20260714082325.325163-3-yi.zhang@huaweicloud.com>
 <a638a8fb-c184-4069-ae33-379ec12cd514@huaweicloud.com>
 <anH-WKA1coW6wtfG@bfoster>
 <ba0c9502-c9f8-40f7-bfd6-47942eb88dec@huaweicloud.com>
 <anR7Td1iZnQgu6h_@bfoster>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <anR7Td1iZnQgu6h_@bfoster>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgA3J0aGNHVqNE6SBQ--.39735S3
X-Coremail-Antispam: 1UD129KBjvJXoW3GFy8tr47CF17Jr1DKF1kuFg_yoWfKw4DpF
	WUKFn8Kr4DGa18Ar1Iva18Xr1FyrWxJFW5uFyfK3y3CFn09r17KF47Ka4j9a9rZr18Gw40
	qr40vry7WFn8AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVWxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kK
	e7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
	02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_
	WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	jIksgUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 8/6/2026 8:17 PM, Brian Foster wrote:
> On Wed, Aug 05, 2026 at 10:42:50AM +0800, Zhang Yi wrote:
>> On 8/4/2026 10:59 PM, Brian Foster wrote:
>>> On Mon, Aug 03, 2026 at 03:13:28PM +0800, Zhang Yi wrote:
>>>> On 7/14/2026 4:23 PM, Zhang Yi wrote:
>>>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>>>
>>>>> Current iomap_invalidate_folio() can only invalidate an entire folio. If
>>>>> we truncate a partial folio on a filesystem where the block size is
>>>>> smaller than the folio size, it will leave behind dirty bits for the
>>>>> truncated or punched blocks. During the write-back process, it will
>>>>> attempt to map the invalid hole range. Fortunately, this has not caused
>>>>> any real problems so far because the ->writeback_range() function
>>>>> corrects the length.
>>>>>
>>>>> However, the implementation of FALLOC_FL_ZERO_RANGE in ext4 depends on
>>>>> the support for invalidating partial folios. When ext4 partially zeroes
>>>>> out a dirty and unwritten folio, it does not perform a flush first like
>>>>> XFS. Therefore, if the dirty bits of the corresponding area cannot be
>>>>> cleared, the zeroed area after writeback remains in the written state
>>>>> rather than reverting to the unwritten state. Fix this by supporting
>>>>> invalidation of partial folios.
>>>>
>>>> Hi all,
>>>>
>>>> While working on the v5 of the ext4 iomap conversion series[1], I've
>>>> observed a rare data inconsistency issue in xfstests generic/127. After
>>>> debugging, I found that the root cause lies in the fact that the current
>>>> patch does not cover all scenarios when handling partial folio
>>>> invalidation during punch hole operations in cases where
>>>> block size < folio size. Specifically, the sub-folio dirty state is not
>>>> properly cleaned up in all cases. I think we need to discuss the fix,
>>>> and I'd like to hear your suggestions.
>>>>
>>>> Root cause:
>>>>
>>>> In both iomap buffered write and mmap write paths, if the write range
>>>> covers an entire folio (regardless of whether the folio size is larger
>>>> than block size), an ifs (iomap_folio_state) is not allocated
>>>> immediately. Instead, it is deferred until writeback time, where it gets
>>>> created in iomap_writeback_folio(). This creates a problem: when ext4
>>>> performs a punch or zero_range operation on a partial range within such
>>>> a dirty folio, there is no way to clear the dirty state for the
>>>> corresponding blocks.
>>>>
>>>> This leads to two specific issues:
>>>>
>>>> 1. After issuing FALLOC_FL_ZERO_RANGE on a range covering
>>>>    dirty+unwritten blocks within a large folio, the dirty state cannot
>>>>    be cleared. During subsequent writeback, zeroed data is still
>>>>    written back, and the final extent state for those blocks becomes
>>>>    written. As a result, the fix from this patch becomes ineffective in
>>>>    this case.
>>>>
>>>
>>> I suspect this may be (occasionally) the case even with an ifs. IIRC the
>>> folio batch stuff made a tradeoff for just zeroing any folio passed in
>>> from the fs that was determined to be dirty, regardless of whether
>>> underlying block aligned ranges may be unwritten and still clean.
>>>
>>> I think this is relatively harmless so long as the underlying range
>>> returns zeroes from subsequent reads. The caveat may be if there are any
>>> cases where we have a really large folio and some small portion of it is
>>> dirtied and that causes some huge amount of unnecessary zeroing. I'm not
>>> sure if we've hit something like that in practice though..
>>
>> This does seem likely harmless, since at least the user data is as
>> expected. Moreover, the ext4 filesystem itself may retain a small
>> portion of a written extent due to reasons such as the inability to
>> split extents. So I understand that the result should be acceptable.
>>
>> However, from the iomap perspective, it seems that we support sub-folio
>> handling, but not fully - and the traditional buffer_head path does not
>> exhibit this phenomenon, which is somewhat puzzling to me. So I was
>> wandering whether it's necessary to fill this case?
>>
> 
> I don't think there is any inherent requirement to match exact behavior
> between iomap and buffer heads, if that's what you mean?
> 
> Brian

I was just curious about why iomap doesn't always allocate ifs when the
block size is smaller than the folio size. I think Darrick's reply has
answered my question. :)

Now I understand that unless we are indeed facing a severe write
amplification problem, the current situation is acceptable. It's just
that when I add support for ext4, I need to be especially careful about
the side effects it brings, such as concurrent scenarios during punch
hole and writeback, because it could turn blocks that were just punched
into allocated ones again. Apart from the mm bug mentioned below, Apart
from the mm bug mentioned below, I haven't encountered any other issues
outside of ext4 so far.

Thanks,
Yi.

> 
>>>
>>>> 2. The aforementioned rare data inconsistency in xfstests generic/127.
>>>>    When performing a partial folio punch hole on a dirty large folio,
>>>>    truncate_inode_pages_range() zeros the partial folio and then splits
>>>>    the folio. This causes an incorrect 'end' offset calculation in
>>>>    truncate_inode_pages_range(), which then results in all split folios
>>>>    being truncated via truncate_inode_folio(), turning partial valid
>>>>    data into zeroes.  For example:
>>>>
>>>>    Suppose we have a large folio of 4 pages, and we punch a range
>>>>    starting from the beginning to the middle of the last page.
>>>>    truncate_inode_pages_range() will go through two rounds of splitting.
>>>>    Normally, if an ifs is present, the split path would hit
>>>>    folio_split() -> filemap_release_folio() -> iomap_release_folio(),
>>>>    which would intercept the operation and refuse splitting because the
>>>>    folio is dirty.
>>>>
>>>>    However, without an ifs, filemap_release_folio() returns early via
>>>>    folio_needs_release(), causing the interception to fail. In the first
>>>>    round, the folio is split into 3 folios (1, 1, 2). In the second
>>>>    round, we expect to split into 4 folios (1, 1, 1, 1). If the second
>>>>    split succeeds, everything is fine, because
>>>>    truncate_inode_pages_range() calculates end = 3, and only the first 3
>>>>    folios are truncated. However, the second split is allowed to fail.
>>>>    If it does fail, truncate_inode_pages_range() still uses end = 3 and
>>>>    ends up truncating all 3 folios, resulting in data loss.
>>>>
>>>
>>> I was never really a huge fan of the ifs optimization thing, but I don't
>>> recall what the performance benefits really were.
>>>
>>> That aside, doesn't this seem like more of a bug within the
>>> truncate_inode_pages_range() path? It's not clear to me if that's the
>>> only problem wrt iomap, but I'd think if the end offset split down in
>>> truncate_inode_partial_folio() fails, we should be able to return
>>> partial progress or something instead of a true/false for the whole
>>> thing. Would that allow this path to properly update the end index for
>>> the full truncate loop and at least prevent throwing away a folio with
>>> partial data like this?
>>>
>>
>> + Matthew and Zi Yan to CC
>>
>> I suspect this is because most filesystems these days, when splitting
>> large folios, generally carry fs-specific private metadata for sub-folio
>> management, and when a sub-folio is dirty, ->release_folio() will
>> directly return EBUSY. As a result, dirty folios cannot be split because
>> their private data cannot be released, which is why this issue has
>> remained undetected until now. I also do think this does appear to be a
>> bug in truncate_inode_partial_folio(). Matthew and Zi Yan, what do you
>> think of this?
>>
>> Thanks,
>> Yi.
>>
>>> Brian
>>>
>>>> Now I remember I previously submitted two patches [2] that always
>>>> allocated an ifs in the iomap buffered write path and the mmap fault
>>>> path for the block size < folio size case. However, Christoph pointed
>>>> out that the iomap design intentionally defers ifs allocation to avoid
>>>> unnecessary overhead and improve performance, and suggested creating the
>>>> ifs in iomap_invalidate_folio() instead [3]. There is a hurdle, though:
>>>> iomap_invalidate_folio() is only called when the folio has private data
>>>> (in truncate_inode_partial_folio(), folio_needs_release() is called
>>>> first to check the private flag). So if we go with this approach, we
>>>> need to ensure that folio_invalidate() can be called even when the folio
>>>> does not have an ifs.
>>>>
>>>> One relatively simple approach is to always set the AS_RELEASE_ALWAYS
>>>> flag on ext4 inodes that go through the iomap path. I don't think this
>>>> would introduce significant overhead, but it doesn't feel very generic.
>>>>
>>>> Another approach is to modify truncate_inode_partial_folio(). Regarding
>>>> this, I don't want to introduce other magics to achieve this, so perhaps
>>>> modify truncate_inode_partial_folio() to check whether
>>>> i_blocks_per_folio > 1 before calling folio_invalidate(), and call it if
>>>> so.
>>>>
>>>> So, what do people think? Any better idea?
>>>>
>>>> Thanks,
>>>> Yi.
>>>>
>>>> [1] https://github.com/zhangyi089/linux/commits/ext4_buffered_iomap_v5-devel13/
>>>> [2] https://lore.kernel.org/linux-fsdevel/20240812121159.3775074-4-yi.zhang@huaweicloud.com/
>>>>     https://lore.kernel.org/linux-fsdevel/20240812121159.3775074-5-yi.zhang@huaweicloud.com/
>>>> [3] https://lore.kernel.org/linux-fsdevel/ZrxBfKi_DpThYo94@infradead.org/
>>>>
>>>>
>>>
>>>
>>
> 
> 

