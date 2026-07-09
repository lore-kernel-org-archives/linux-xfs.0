Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921C4351C27;
	Thu,  9 Jul 2026 02:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783565265; cv=none; b=owzPphDPY+JWJ2c0ov5PfREqGUQwi/bgDlxxPSXBxDYnrCV5wrQo1vPojMRjtMIOlEeH+CTSnrZ6OVnBqmuZxjF9ytWyXChUQJY+0Krp+THjrGpfO598T7VqMDGs+BysWm7A21ADNQapHF7FfALoDJunGDIel3DPUjGCdHjFSCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783565265; c=relaxed/simple;
	bh=MYlh+5/4RDk/VQbOTGtJplh34pLnTmXSWRmrczPuUDE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UGLUVjNKOKvDX4m0Smv9BFPqwy7o9zCHo9OS1yLblbTHP07XuTS+CFN8bOGiQ8zclUXxUqFF10dVTRxVqOaAocww2T02E72+RQ1gBCxad7YaVX/EiopMUk9GStK6Mov/oAR9JNH4ro/OkkCi6J07zdmICzhW1KHJb3PEkUwEq58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gwfWl258PzYQtjR;
	Thu,  9 Jul 2026 10:47:31 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 521DC4057D;
	Thu,  9 Jul 2026 10:47:37 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCntnLHC09qBBpEAg--.32295S3;
	Thu, 09 Jul 2026 10:47:37 +0800 (CST)
Message-ID: <970e38ef-fcb3-4255-a599-f18acd69cba1@huaweicloud.com>
Date: Thu, 9 Jul 2026 10:47:35 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] iomap: correct the range of a partial dirty clear
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, brauner@kernel.org, hch@infradead.org,
 joannelkoong@gmail.com, yi.zhang@huawei.com, yizhang089@gmail.com,
 yangerkun@huawei.com, yukuai@fnnas.com
References: <20260520030357.679687-1-yi.zhang@huaweicloud.com>
 <20260520030357.679687-2-yi.zhang@huaweicloud.com>
 <20260708214019.GE9368@frogsfrogsfrogs>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260708214019.GE9368@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgCntnLHC09qBBpEAg--.32295S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJw48tFykKry8Jr45ArW3Awb_yoW5Jw48pr
	4fKF45Kr4DXry8uw1IqFWrXF1rKa97JF48GrW3Gwn5WFs8ZFy5KF1v9ay5uFyvkr17AF10
	vF12qry7CrWDAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kK
	e7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
	02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_
	GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	UQ6p9UUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 7/9/2026 5:40 AM, Darrick J. Wong wrote:
> On Wed, May 20, 2026 at 11:03:53AM +0800, Zhang Yi wrote:
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
>> Fixes: 4ce02c679722 ("iomap: Add per-block dirty state tracking to improve performance")
>> Cc: <stable@vger.kernel.org> # v6.6
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> 
> My apologies for the unnecessary delay, I was on vacation when this came
> through and I never saw it. :/
> 
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Thank you for the review!

No worries. The ext4 iomap conversion work is still ongoing, so this isn't
particularly urgent. Now, I think this series is ready to go. Besides,
There is also one more fix patch that I need to send out, but I can send it
separately. :)

Thanks,
Yi.

> 
> --D
> 
>> ---
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
>> +	unsigned int last_blk = (off + len) >> inode->i_blkbits;
>>  	unsigned long flags;
>>  
>> +	if (first_blk >= last_blk)
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

