Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C0B2517AF;
	Wed, 11 Mar 2026 02:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773195452; cv=none; b=PsByJJ8IjDduT2O9Se5Q4q4rlV59EnIEa0nsLqXWC1pnGJuJPfRKZ6Mg4tMwRWd/VYIzFdjodgdDz3KSUL+gJytZAop2fz9Ylb+5zzfOchpez40jLFAaN1Us0enPabHeg4HJYjFGg3JrKrLgTcuFVRVRbzX+4u40UK7wm6M78MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773195452; c=relaxed/simple;
	bh=o6oCv60S4RRCXHCWraKQyOjlmh/+J4/OyQJJvIdsGfQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d2yrY5A3nxlnERoFxuXPzEk+UTAIDeQGSBrT/XSGr4jOmO0cGu53PfP6kbektBzW4K2qDb4cCoMHzH+rS3zMVFHXVAcYaH9lWrb6WiUal0ZSVpxAAESdl5nn/Yvt2hIPKZYX9ja+STN1GAuqcuyAhiMmBHDkagJ8kDkJqSMOFoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fVvX72HlxzKHMqM;
	Wed, 11 Mar 2026 10:17:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 78D1340590;
	Wed, 11 Mar 2026 10:17:27 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgD3+Ni10LBp4uHeAQ--.31859S3;
	Wed, 11 Mar 2026 10:17:27 +0800 (CST)
Message-ID: <1dce8b3b-29ee-4c45-98cb-8882a79c41c2@huaweicloud.com>
Date: Wed, 11 Mar 2026 10:17:25 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iomap: fix incorrect did_zero setting in
 iomap_zero_iter()
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 brauner@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
References: <20260310082250.3535486-1-yi.zhang@huaweicloud.com>
 <20260310221303.GA1770774@frogsfrogsfrogs>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260310221303.GA1770774@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgD3+Ni10LBp4uHeAQ--.31859S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWw1rurW8CrWftw4fXry8Grg_yoW5AF4fpr
	Z7KF4vkFs2q3y7uFn5tF9Fqr1Yyr1rXrW7Wr4UGwn8ZFsY9rWIkr18KayY9F1xJ34fCw1I
	vF4jkas7AF1DAFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 3/11/2026 6:13 AM, Darrick J. Wong wrote:
> On Tue, Mar 10, 2026 at 04:22:50PM +0800, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> The did_zero output parameter was unconditionally set after the loop,
>> which is incorrect. It should only be set when the zeroing operation
>> actually happens, not when IOMAP_F_STALE is set or when
>> IOMAP_F_FOLIO_BATCH is set but !folio causes the loop to break early,
>> or when iomap_iter_advance() returns an error.
>>
>> This causes did_zero to be incorrectly set when zeroing a clean
>> unwritten extent because the loop exits early without actually zeroing
>> any data.
>>
>> Fix it by using a local variable to track whether any folio was actually
>> zeroed, and only set did_zero after the loop if zeroing happened.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> ---
>>  fs/iomap/buffered-io.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
>> index 5297491d5e3e..7a3780242cde 100644
>> --- a/fs/iomap/buffered-io.c
>> +++ b/fs/iomap/buffered-io.c
>> @@ -1537,6 +1537,7 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
>>  		const struct iomap_write_ops *write_ops)
>>  {
>>  	u64 bytes = iomap_length(iter);
>> +	bool zeroed = false;
>>  	int status;
>>  
>>  	do {
>> @@ -1555,6 +1556,8 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
>>  		/* a NULL folio means we're done with a folio batch */
>>  		if (!folio) {
>>  			status = iomap_iter_advance_full(iter);
>> +			if (status)
>> +				return status;
>>  			break;
>>  		}
>>  
>> @@ -1565,6 +1568,7 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
>>  				bytes);
>>  
>>  		folio_zero_range(folio, offset, bytes);
>> +		zeroed = true;
>>  		folio_mark_accessed(folio);
>>  
>>  		ret = iomap_write_end(iter, bytes, bytes, folio);
>> @@ -1574,10 +1578,10 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
>>  
>>  		status = iomap_iter_advance(iter, bytes);
>>  		if (status)
>> -			break;
>> +			return status;
> 
> I think this seems like an unrelated change?  Do any of the callers
> behave differently if iomap_zero_range() returns an error but also sets
> did_zero to true?
> 

In the event of an error return, no caller will be concerned with the
did_zero state. It is only relevant when the operation is successful.
So I think we can just return if some error happens, consistent with
other error-handling practices in this loop.

>>  	} while ((bytes = iomap_length(iter)) > 0);
>>  
>> -	if (did_zero)
>> +	if (did_zero && zeroed)
>>  		*did_zero = true;
> 
> Why not just do:
> 
> 	if (did_zero)
> 		*did_zero = zeroed;
> 
> ?
> 

If we proceed with this approach, when there are mixed extents and the
final iteration of the iomap_zero_range() loop does not zero out any
data, it will clear the flags that were set in previous loop when the
data was zeroed.

Thanks,
Yi.

> --D
> 
>>  	return status;
>>  }
>> -- 
>> 2.52.0
>>
>>

