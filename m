Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3452F7478;
	Fri, 15 May 2026 01:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778808058; cv=none; b=pmXyhrxVmyY2tGkkfbBDIA3peEQ7m0X8+BLezM540STLzMOo5WkYWRWyPoW7oMdd/28EyFTr65W28uZpGiA4Vszt7wmO9IE12JyL+wTOmhbzw6YoL/GRQ7W6aH6ZS5ibO9CVXvGIeZpwteR2XJSLk0j0qbtOxOmgZ/CP771zBwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778808058; c=relaxed/simple;
	bh=UovNujtOCw73zes6xBQtUDPRcWcC2Ozu63IR7zI1LTs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZZZKdILB/vr+D20Gy9GWyb666YKAVw/OEkiKtqY2f9ZQZYbwd0UvYTMSaFRk1KhE/szWeiYyNvkoXd3LDBIj0cNyy0OhtkpyrGKZ4g7RDHErHpAB6SqUl+XZeSPGwqKeKKIVD8fJiUUExtZJNpypQSize9HAWZDY+kR5pYSkkCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gGqBR4TdqzYQtdy;
	Fri, 15 May 2026 09:20:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A8BD34056D;
	Fri, 15 May 2026 09:20:50 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP4 (Coremail) with SMTP id gCh0CgC3f1vudAZqC9RXCQ--.64034S3;
	Fri, 15 May 2026 09:20:48 +0800 (CST)
Message-ID: <2b6e954a-fe6b-4f28-ba88-19ac57ce1b4b@huaweicloud.com>
Date: Fri, 15 May 2026 09:20:46 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] iomap: correct the range of a partial dirty clear
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, brauner@kernel.org, hch@infradead.org,
 yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com,
 yukuai@fnnas.com
References: <20260514062955.1183976-1-yi.zhang@huaweicloud.com>
 <20260514062955.1183976-2-yi.zhang@huaweicloud.com>
 <20260514180320.GA9555@frogsfrogsfrogs>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260514180320.GA9555@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgC3f1vudAZqC9RXCQ--.64034S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXF13WrW8KF1Dury8Wr1UAwb_yoW5AFyfpF
	s3KFs8Kr4DWryxu3Z2grZ5XFyrta9rJF48GrW3Gwn3GF45Zas3KFn7ua15uFWvkr1xAF10
	vF1agry7CrWUZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
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
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUF1
	v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 5/15/2026 2:03 AM, Darrick J. Wong wrote:
> On Thu, May 14, 2026 at 02:29:52PM +0800, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> The block range calculation in ifs_clear_range_dirty() is incorrect when
>> partially clearing a range in a folio. We cannot clear the dirty bit of
>> the first block or the last block if the start or end offset is not
>> blocksize-aligned. This has not yet caused any issues since we always
>> clear a whole folio in iomap_writeback_folio().
>>
>> Fix this by rounding up the first block to blocksize alignment, and
>> calculate the last block by rounding down (using truncation). Correct
>> the nr_blks calculation accordingly.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> 
> Cc: <stable@vger.kernel.org> # v6.6
> Fixes: 4ce02c67972211 ("iomap: Add per-block dirty state tracking to improve performance")
> 
>> ---
>> This is modified from:
>>  https://lore.kernel.org/linux-fsdevel/20240812121159.3775074-2-yi.zhang@huaweicloud.com/
>> Changes:
>>  - Use round_up() instead of DIV_ROUND_UP() to prevent wasted integer
>>    division.
>>
>>  fs/iomap/buffered-io.c | 12 ++++++++----
>>  1 file changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
>> index d7b648421a70..64351a448a8b 100644
>> --- a/fs/iomap/buffered-io.c
>> +++ b/fs/iomap/buffered-io.c
>> @@ -176,13 +176,17 @@ static void ifs_clear_range_dirty(struct folio *folio,
>>  {
>>  	struct inode *inode = folio->mapping->host;
>>  	unsigned int blks_per_folio = i_blocks_per_folio(inode, folio);
>> -	unsigned int first_blk = (off >> inode->i_blkbits);
>> -	unsigned int last_blk = (off + len - 1) >> inode->i_blkbits;
>> -	unsigned int nr_blks = last_blk - first_blk + 1;
>> +	unsigned int first_blk = round_up(off, i_blocksize(inode)) >>
>> +				 inode->i_blkbits;
> 
> Ok, so now we round off up to the next fsblock to compute first_blk...
> 
>> +	unsigned int last_blk = (off + len) >> inode->i_blkbits;
> 
> ...and last_blk (which is really the next block number after the range
> that we're undirtying) is now rounded down.  Presumably off/len have to
> be aligned to fsblock granularity so we'll never have to deal with
> unaligned situations like (off=324,len=1), right?

Yeah, that's right.

> 
>>  	unsigned long flags;
>>  
>> +	if (first_blk >= last_blk)
> 
> Do we need this check?  When would the test actually be true?

Yes, we do. Following your example, when off = 324 and len = 1, we have
first_block = 1 but last_block = 0. In this case, we must add this check
to prevent an inversion when calculating the length to be zeroed out.

Thanks,
Yi.

> 
> --D
> 
>> +		return;
>> +
>>  	spin_lock_irqsave(&ifs->state_lock, flags);
>> -	bitmap_clear(ifs->state, first_blk + blks_per_folio, nr_blks);
>> +	bitmap_clear(ifs->state, first_blk + blks_per_folio,
>> +		     last_blk - first_blk);
>>  	spin_unlock_irqrestore(&ifs->state_lock, flags);
>>  }
>>  
>> -- 
>> 2.52.0
>>
>>
> 

