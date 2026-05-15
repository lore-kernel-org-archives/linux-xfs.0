Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BC02C21F1;
	Fri, 15 May 2026 01:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778809824; cv=none; b=NyW+TPxbCwXD2RRdQfHEA6qDnR2Xiqyfd5WRn8tlY0VgXWYKfnHm/7cdA0fYmDGDiSwUJszImmf45RrbO07hQ97jl3KStyUVkkKyDTLPEO4G7uKJCANzyPItl0l6XwvAuiVnF0M1UusKAPHNv5gPMp3fPPmsbfGcjR0gXn7ihe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778809824; c=relaxed/simple;
	bh=2DJZwMygqlzaYEF3ZbdwkAdCzPiw4hniT7LKseJDc3g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ItKN97EWJxGibdB3e/pGzIADmndMx0baZ7g4wlSalQ+Y+1PvSo4yDKk1oNp2axoUqoMvUe5P923IMwiDnr7WWztHwxmIg18+9c1DVyzgKJ1bPLWJxv/nzLcD8FECTgngOjy7XbYTZU981ddp2P6p7Nlo61cNLGbZhNenLYtsU4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gGqqt3VG2zKHMRP;
	Fri, 15 May 2026 09:49:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0A1AA4056D;
	Fri, 15 May 2026 09:50:11 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP4 (Coremail) with SMTP id gCh0CgCnb1vRewZq6VRaCQ--.62932S3;
	Fri, 15 May 2026 09:50:10 +0800 (CST)
Message-ID: <827c4380-4251-40af-bc14-207111736464@huaweicloud.com>
Date: Fri, 15 May 2026 09:50:08 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] iomap: fix out-of-bounds bitmap_set() with
 zero-length range
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, brauner@kernel.org, hch@infradead.org,
 yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com,
 yukuai@fnnas.com
References: <20260514062955.1183976-1-yi.zhang@huaweicloud.com>
 <20260514062955.1183976-5-yi.zhang@huaweicloud.com>
 <20260514181053.GB9555@frogsfrogsfrogs>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260514181053.GB9555@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgCnb1vRewZq6VRaCQ--.62932S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWFyxAryUZFyUGrW8AF43Jrb_yoWruF1DpF
	W3KF1UKrWDXryxZr1fXrZ5XFn0y3W7Xr4xGFWxK3Z5Can8ZFyS9r10934YyFW8Cr4xJr1F
	qr1UW347ur18ZrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 5/15/2026 2:10 AM, Darrick J. Wong wrote:
> On Thu, May 14, 2026 at 02:29:55PM +0800, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> ifs_set_range_dirty() and ifs_set_range_uptodate() compute last_blk
>> as (off + len - 1) >> i_blkbits.  When off is 0 and len is 0, the
>> unsigned subtraction underflows to SIZE_MAX, producing a huge
>> last_blk and nr_blks value that causes bitmap_set() to write far
>> beyond the ifs->state allocation.
>>
>> Regarding ifs_set_range_uptodate(), it is temporarily safe because len
>> cannot be passed in as 0. However, for ifs_set_range_dirty() this is
>> reachable from __iomap_write_end(): when copy_folio_from_iter_atomic()
>> returns 0 (e.g. user buffer fault) and the folio is already uptodate,
>> the guard at the top of __iomap_write_end() does not trigger because
>> !folio_test_uptodate() is false, and iomap_set_range_dirty() is called
>> with copied == 0.
>>
>> Add a !len guard to both functions before the computation, so that a
>> zero-length range is a no-op.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> ---
>>  fs/iomap/buffered-io.c | 23 +++++++++++++++--------
>>  1 file changed, 15 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
>> index 27ab33edbdee..6fe5f7e998fd 100644
>> --- a/fs/iomap/buffered-io.c
>> +++ b/fs/iomap/buffered-io.c
>> @@ -67,11 +67,14 @@ static bool ifs_set_range_uptodate(struct folio *folio,
>>  		struct iomap_folio_state *ifs, size_t off, size_t len)
>>  {
>>  	struct inode *inode = folio->mapping->host;
>> -	unsigned int first_blk = off >> inode->i_blkbits;
>> -	unsigned int last_blk = (off + len - 1) >> inode->i_blkbits;
>> -	unsigned int nr_blks = last_blk - first_blk + 1;
>> +	unsigned int first_blk, last_blk;
>>  
>> -	bitmap_set(ifs->state, first_blk, nr_blks);
>> +	if (!len)
>> +		return true;
>> +
>> +	first_blk = off >> inode->i_blkbits;
>> +	last_blk = (off + len - 1) >> inode->i_blkbits;
>> +	bitmap_set(ifs->state, first_blk, last_blk - first_blk + 1);
>>  	return ifs_is_fully_uptodate(folio, ifs);
>>  }
>>  
>> @@ -203,13 +206,17 @@ static void ifs_set_range_dirty(struct folio *folio,
>>  {
>>  	struct inode *inode = folio->mapping->host;
>>  	unsigned int blks_per_folio = i_blocks_per_folio(inode, folio);
>> -	unsigned int first_blk = (off >> inode->i_blkbits);
>> -	unsigned int last_blk = (off + len - 1) >> inode->i_blkbits;
>> -	unsigned int nr_blks = last_blk - first_blk + 1;
>> +	unsigned int first_blk, last_blk;
>>  	unsigned long flags;
>>  
>> +	if (!len)
>> +		return;
>> +
>> +	first_blk = off >> inode->i_blkbits;
>> +	last_blk = (off + len - 1) >> inode->i_blkbits;
>>  	spin_lock_irqsave(&ifs->state_lock, flags);
>> -	bitmap_set(ifs->state, first_blk + blks_per_folio, nr_blks);
>> +	bitmap_set(ifs->state, first_blk + blks_per_folio,
>> +		   last_blk - first_blk + 1);
> 
> I'm curious about the inconsistency in the computations between
> ifs_clear_range_dirty and ifs_set_range_dirty now.  In the function that
> clears dirty bits, off/len are rounded inwards:
> 
> 	unsigned int first_blk = round_up(off, i_blocksize(inode)) >>
> 				 inode->i_blkbits;
> 	unsigned int last_blk = (off + len) >> inode->i_blkbits;
> 	unsigned long flags;
> 
> 	if (first_blk >= last_blk)
> 		return;
> 
> 	spin_lock_irqsave(&ifs->state_lock, flags);
> 	bitmap_clear(ifs->state, first_blk + blks_per_folio,
> 		     last_blk - first_blk);
> 
> but here we're still rounding outwards:
> 
> 	if (!len)
> 		return;
> 
> 	first_blk = off >> inode->i_blkbits;
> 	last_blk = (off + len - 1) >> inode->i_blkbits;
> 	spin_lock_irqsave(&ifs->state_lock, flags);
> 	bitmap_set(ifs->state, first_blk + blks_per_folio,
> 		   last_blk - first_blk + 1);
> 
> That doesn't quite sound right to me without an explanation in the code,
> which currently lacks one.  I *think* the reason for the discrepancy is
> that if we want to dirty part of an fsblock, we need to mark the whole
> block dirty in the ifs so that all the blocks get written out; but when
> we're clearing dirty bits, we want to leave an fsblock dirty if we only
> wrote back part of that fsblock.  Does that sound right?
> 
> --D
> 

Yes, that's right. The primary purpose of clearing the dirty bit is for
invalidating a partial folio(e.g., when punching hole). Only when a full
fsblock has been invalidated can its corresponding dirty bit be cleared.
Write-back operations never seem to write back only part of a fsblock.

I can add comments for them in my next iteration.

Thanks,
Yi.


