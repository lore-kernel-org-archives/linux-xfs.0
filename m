Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0F539EF33;
	Mon,  3 Aug 2026 07:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785741219; cv=none; b=kc4KpSk7otldWXxfQoBjbPO+Re0K2nNGF9t48yMzB4vKpMxP65uptLqTItgVU4W8g4A0HTdQlFUD0AZBCkthZ6Ep28bLRRdIye8MTIsk0m6LOwfZmPo+ABbDmK4xxzDon8fHKme3z3VdNK0V9WU3o+lJ8PA2mitMQtN22qhWqPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785741219; c=relaxed/simple;
	bh=+A6zm7zbh+f47FNuk+f/+aM0sf8xDBNFHvyAhI488lE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=otjpgSMXoDgFBCv4PyS3OJ/UTMGeTACU70JpV9gYpgZw4W/FbAXzYmTgptODDdKJQSen8PO6g322hDq0FfG+9eEsN3ahSVRrXfU2yjQpqeh0eSaK+OxtcSiDvDGPM73mzZkVYzNMOQneNo6QdLSoKI0qDqEuMhU7CfqhP1ZVE0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hD7F42WDgzKHMX1;
	Mon,  3 Aug 2026 15:13:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id EE9C84077E;
	Mon,  3 Aug 2026 15:13:30 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgC3pkWYP3BqSMnFAw--.33588S3;
	Mon, 03 Aug 2026 15:13:30 +0800 (CST)
Message-ID: <a638a8fb-c184-4069-ae33-379ec12cd514@huaweicloud.com>
Date: Mon, 3 Aug 2026 15:13:28 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/5] iomap: support invalidating partial folios
To: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-ext4@vger.kernel.org
Cc: brauner@kernel.org, djwong@kernel.org, hch@infradead.org,
 joannelkoong@gmail.com, "Theodore Y. Ts'o" <tytso@mit.edu>,
 Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 yi.zhang@huawei.com, yizhang089@gmail.com, chengzhihao1@huawei.com,
 yangerkun@huawei.com, yukuai@fnnas.com
References: <20260714082325.325163-1-yi.zhang@huaweicloud.com>
 <20260714082325.325163-3-yi.zhang@huaweicloud.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260714082325.325163-3-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgC3pkWYP3BqSMnFAw--.33588S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Wr4DJr1rGFyrKrW3Cr4kZwb_yoW7ZryUpF
	W7Krs8GrWDGa18Cwn7ua18Xr1Fya4fWFW5CFyfK343AFs8J3Z2kF17t3WY9ay7Jr18Gw40
	qr42vrWkWF1DAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kK
	e7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
	02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_
	GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	UAwIDUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 7/14/2026 4:23 PM, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Current iomap_invalidate_folio() can only invalidate an entire folio. If
> we truncate a partial folio on a filesystem where the block size is
> smaller than the folio size, it will leave behind dirty bits for the
> truncated or punched blocks. During the write-back process, it will
> attempt to map the invalid hole range. Fortunately, this has not caused
> any real problems so far because the ->writeback_range() function
> corrects the length.
> 
> However, the implementation of FALLOC_FL_ZERO_RANGE in ext4 depends on
> the support for invalidating partial folios. When ext4 partially zeroes
> out a dirty and unwritten folio, it does not perform a flush first like
> XFS. Therefore, if the dirty bits of the corresponding area cannot be
> cleared, the zeroed area after writeback remains in the written state
> rather than reverting to the unwritten state. Fix this by supporting
> invalidation of partial folios.

Hi all,

While working on the v5 of the ext4 iomap conversion series[1], I've
observed a rare data inconsistency issue in xfstests generic/127. After
debugging, I found that the root cause lies in the fact that the current
patch does not cover all scenarios when handling partial folio
invalidation during punch hole operations in cases where
block size < folio size. Specifically, the sub-folio dirty state is not
properly cleaned up in all cases. I think we need to discuss the fix,
and I'd like to hear your suggestions.

Root cause:

In both iomap buffered write and mmap write paths, if the write range
covers an entire folio (regardless of whether the folio size is larger
than block size), an ifs (iomap_folio_state) is not allocated
immediately. Instead, it is deferred until writeback time, where it gets
created in iomap_writeback_folio(). This creates a problem: when ext4
performs a punch or zero_range operation on a partial range within such
a dirty folio, there is no way to clear the dirty state for the
corresponding blocks.

This leads to two specific issues:

1. After issuing FALLOC_FL_ZERO_RANGE on a range covering
   dirty+unwritten blocks within a large folio, the dirty state cannot
   be cleared. During subsequent writeback, zeroed data is still
   written back, and the final extent state for those blocks becomes
   written. As a result, the fix from this patch becomes ineffective in
   this case.

2. The aforementioned rare data inconsistency in xfstests generic/127.
   When performing a partial folio punch hole on a dirty large folio,
   truncate_inode_pages_range() zeros the partial folio and then splits
   the folio. This causes an incorrect 'end' offset calculation in
   truncate_inode_pages_range(), which then results in all split folios
   being truncated via truncate_inode_folio(), turning partial valid
   data into zeroes.  For example:

   Suppose we have a large folio of 4 pages, and we punch a range
   starting from the beginning to the middle of the last page.
   truncate_inode_pages_range() will go through two rounds of splitting.
   Normally, if an ifs is present, the split path would hit
   folio_split() -> filemap_release_folio() -> iomap_release_folio(),
   which would intercept the operation and refuse splitting because the
   folio is dirty.

   However, without an ifs, filemap_release_folio() returns early via
   folio_needs_release(), causing the interception to fail. In the first
   round, the folio is split into 3 folios (1, 1, 2). In the second
   round, we expect to split into 4 folios (1, 1, 1, 1). If the second
   split succeeds, everything is fine, because
   truncate_inode_pages_range() calculates end = 3, and only the first 3
   folios are truncated. However, the second split is allowed to fail.
   If it does fail, truncate_inode_pages_range() still uses end = 3 and
   ends up truncating all 3 folios, resulting in data loss.

Now I remember I previously submitted two patches [2] that always
allocated an ifs in the iomap buffered write path and the mmap fault
path for the block size < folio size case. However, Christoph pointed
out that the iomap design intentionally defers ifs allocation to avoid
unnecessary overhead and improve performance, and suggested creating the
ifs in iomap_invalidate_folio() instead [3]. There is a hurdle, though:
iomap_invalidate_folio() is only called when the folio has private data
(in truncate_inode_partial_folio(), folio_needs_release() is called
first to check the private flag). So if we go with this approach, we
need to ensure that folio_invalidate() can be called even when the folio
does not have an ifs.

One relatively simple approach is to always set the AS_RELEASE_ALWAYS
flag on ext4 inodes that go through the iomap path. I don't think this
would introduce significant overhead, but it doesn't feel very generic.

Another approach is to modify truncate_inode_partial_folio(). Regarding
this, I don't want to introduce other magics to achieve this, so perhaps
modify truncate_inode_partial_folio() to check whether
i_blocks_per_folio > 1 before calling folio_invalidate(), and call it if
so.

So, what do people think? Any better idea?

Thanks,
Yi.

[1] https://github.com/zhangyi089/linux/commits/ext4_buffered_iomap_v5-devel13/
[2] https://lore.kernel.org/linux-fsdevel/20240812121159.3775074-4-yi.zhang@huaweicloud.com/
    https://lore.kernel.org/linux-fsdevel/20240812121159.3775074-5-yi.zhang@huaweicloud.com/
[3] https://lore.kernel.org/linux-fsdevel/ZrxBfKi_DpThYo94@infradead.org/

