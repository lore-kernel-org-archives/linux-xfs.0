Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E69A2DEA7B;
	Fri, 15 May 2026 01:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778810285; cv=none; b=eM8AkV9TJmFudNH5Voh3I4xNRk46DlqjISWqRyWtZ0JIspc0XKUDhp8Xr2tdF1msEKuQrD70iULD7cynNBEEi7MO1tKkCFHF5dsLVW8wTiCV1LAl8iXDjHt9LRKH03rIFcdNFGOPv/kK8VZXaQafVuzVgpknRY2RFkeDwKmGIqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778810285; c=relaxed/simple;
	bh=LSLScaH1hv8EiiU2L4yriP/65BrbQnOY4GD+UxH1mHA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NNf3tzR3w/P2P32KILW0Gl3DdHqJtSUGAkKLRWxilnML4EF2Gq+0ixkSz38vGn0Gy5B3Kbi+P1/bcwBxCr+AvcqXSAIyNsvq/q5s6DhcrbpLGMMUXo0HyGM1Be95MbpOIGAwIfi4q+glgQGuJbNkx5LEG2HpE0PjenG2/8M92+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gGr1H1gxBzYQtr9;
	Fri, 15 May 2026 09:57:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 542BF40571;
	Fri, 15 May 2026 09:57:58 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP4 (Coremail) with SMTP id gCh0CgA3_1qlfQZqgABbCQ--.64001S3;
	Fri, 15 May 2026 09:57:58 +0800 (CST)
Message-ID: <1f36aefc-4da0-4e26-b28b-3edf0e466e98@huaweicloud.com>
Date: Fri, 15 May 2026 09:57:57 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] iomap: fix out-of-bounds bitmap_set() with
 zero-length range
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, brauner@kernel.org, djwong@kernel.org,
 hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com,
 yangerkun@huawei.com, yukuai@fnnas.com
References: <20260514062955.1183976-1-yi.zhang@huaweicloud.com>
 <20260514062955.1183976-5-yi.zhang@huaweicloud.com>
 <CAJnrk1bHM9aGXbk+LJYJZrfbtLvbwsqwrJgY2KkT5AyVfBjdrg@mail.gmail.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <CAJnrk1bHM9aGXbk+LJYJZrfbtLvbwsqwrJgY2KkT5AyVfBjdrg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3_1qlfQZqgABbCQ--.64001S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWr47uF4xGFy7WryrCrWfKrg_yoW5GrWrpF
	ZxKFWUKr4qqrZ7Cr1SqFWfXF1Yy3W7Xr4xKFW3G3Z3Ca15Ar95Kr1xuayj9F48GrWUJr1F
	qr1jga43uayjvrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IUb
	mii3UUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 5/14/2026 11:08 PM, Joanne Koong wrote:
> On Wed, May 13, 2026 at 11:35 PM Zhang Yi <yi.zhang@huaweicloud.com> wrote:
>>
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
> 
> Is the Fixes: 4ce02c679722  ("iomap: Add per-block dirty state
> tracking to improve performance") tag needed for this?
> 
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
>>                 struct iomap_folio_state *ifs, size_t off, size_t len)
>>  {
>>         struct inode *inode = folio->mapping->host;
>> -       unsigned int first_blk = off >> inode->i_blkbits;
>> -       unsigned int last_blk = (off + len - 1) >> inode->i_blkbits;
>> -       unsigned int nr_blks = last_blk - first_blk + 1;
>> +       unsigned int first_blk, last_blk;
>>
>> -       bitmap_set(ifs->state, first_blk, nr_blks);
>> +       if (!len)
>> +               return true;
> 
> I think both callers of ifs_set_range_uptodate() use the return value
> to decide whether to mark the folio uptodate or not - does this still
> need to return ifs_is_fully_uptodate(folio, ifs) instead of always
> true?
> 

Yeah, you are right! I missed that, will fix.

Thanks,
Yi.

> Thanks,
> Joanne
> 
>> +
>> +       first_blk = off >> inode->i_blkbits;
>> +       last_blk = (off + len - 1) >> inode->i_blkbits;
>> +       bitmap_set(ifs->state, first_blk, last_blk - first_blk + 1);
>>         return ifs_is_fully_uptodate(folio, ifs);
>>  }

