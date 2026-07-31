Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F0A1D9A70;
	Fri, 31 Jul 2026 01:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785461013; cv=none; b=kov/0HJWFsx2HJvkUhEoajFPXhBFK5QM5okkmQ3fmZnhFhBkSDiz1H0UFY3obCAHBqopbT7V/z6zsdvDTIcuzl1RIGdvPkrY6HVOMIj8RDTLyglrHV74xqSid14N0WmkhGAD/yAaa4ghYOqmVcQjdwhGJltdRm0QPLg6c0OajvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785461013; c=relaxed/simple;
	bh=SYHfTPOMHblSRbVYvhhnOL85Ggh+FrsIMbmdemvvuZs=;
	h=Message-ID:Date:From:MIME-Version:To:CC:Subject:References:
	 In-Reply-To:Content-Type; b=Cg35eQybPepZiPOdRELVNk73ffEqjVqIOT2RqEF1H0RPwcYwDFOJE+dzvC9yKftmeHKebIsPIU6WiwWhu6sfnJT9JedkkF5GJQ5EsEj0nreKQ9DibyQi0+KhApq5eyGmmU4p14EE0fwAJ1LACKIC/Uv+SV3ogjug3LKBeiN1wKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=Dw9xQg1S; arc=none smtp.client-ip=220.197.31.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="Dw9xQg1S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:From:MIME-Version:To:Subject:
	Content-Type; bh=BF6Na6Ku0LPOsj8Vwwvh0x1v3lCEQ31aapXF3EdT6Z4=;
	b=Dw9xQg1SsgmFrqgc8K8cGmZRDGXW1RYNeO+KxuCJPexzicWB0UNrC513QXfpcD
	CKQraeAwzKSnpSm8sgiq5U0OGickCrPtfqy9fEAxTOg8Qpysh5PUF75o4XHv1dk8
	+mFCfGk/v6AoypZEHQq5VU7Kk5pG4IjM4qiePZ8oRkvMc=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3L9T4+Gtq_m4UEw--.14862S2;
	Fri, 31 Jul 2026 09:23:05 +0800 (CST)
Message-ID: <6A6BF8E9.2070604@126.com>
Date: Fri, 31 Jul 2026 09:22:49 +0800
From: Hongling Zeng <zhongling0719@126.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
To: "Darrick J. Wong" <djwong@kernel.org>, 
 Hongling Zeng <zenghongling@kylinos.cn>
CC: cem@kernel.org, chandanrlinux@gmail.com, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] xfs: fix heap buffer overflow in xfs_bmbt_to_bmdr
References: <20260730094824.200669-1-zenghongling@kylinos.cn> <20260730154309.GB3556460@frogsfrogsfrogs>
In-Reply-To: <20260730154309.GB3556460@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3L9T4+Gtq_m4UEw--.14862S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxuF1xXFWUGF4ftr45ArWrKrg_yoW5Cry3pr
	Z7t3Z0kFWvqw4xuFnF9w1rtw15u3ySy3yUCrZxAanxWwn8tr12qF9YkryY9w1jqa1SyrW0
	gFn8AasrWwn8uFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j-3kAUUUUU=
X-CM-SenderInfo: x2kr0wpolqwiqxrzqiyswou0bp/xtbBoBnxwmpr+PknZQAA3I


在 2026年07月30日 23:43, Darrick J. Wong 写道:
> Please take a breath and refrain from sending the same patch three times
> in ninety minutes.  Figure out what you want to change, run it through
> some testing, and only send it once you've stopped finding things to
> tweak.
>
> --D
   Thanks for the feedback. I apologize for the multiple versions - that 
was my mistake in not reviewing thoroughly enough before submitting.

   The v3 patch is in its final form. I would appreciate your review 
when you get a chance.

   Hongling

> On Thu, Jul 30, 2026 at 05:48:24PM +0800, Hongling Zeng wrote:
>> The xfs_bmbt_to_bmdr() function converts an in-memory btree root to
>> on-disk form during log recovery. It uses bb_numrecs from the source
>> to determine memcpy size without validating against the destination
>> fork capacity.
>>
>> Current code:
>>    dmxr = xfs_bmdr_maxrecs(dblocklen, 0);           // destination capacity
>>    ...
>>    dmxr = be16_to_cpu(dblock->bb_numrecs);          // overwrite with source value!
>>    memcpy(..., * dmxr);                              // may overflow destination!
>>
>> If bb_numrecs is larger than the destination fork capacity,
>> memcpy writes beyond the fork buffer, causing heap overflow.
>>
>> Fix by validating bb_numrecs against the destination capacity
>> before using it for memcpy operations.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 8ea5682d0711 ("xfs: refactor log recovery item dispatch for pass2 readhead functions")
>> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
>> ---
>> Change in v3:
>> - Use dmxr for tpp calculation (on-disk format) and nrecs for memcpy (actual records)
>> ---
>> Change in v2:
>> - Ensure memcpy operations consistently use nrecs instead of dmxr.
>> ---
>>   fs/xfs/libxfs/xfs_bmap_btree.c | 12 +++++++++---
>>   1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
>> index 758a4b1ccf5b..a119053d67b5 100644
>> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
>> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
>> @@ -151,6 +151,7 @@ xfs_bmbt_to_bmdr(
>>   	int			dmxr;
>>   	xfs_bmbt_key_t		*fkp;
>>   	__be64			*fpp;
>> +	int                     nrecs;
>>   	xfs_bmbt_key_t		*tkp;
>>   	__be64			*tpp;
>>   
>> @@ -167,14 +168,19 @@ xfs_bmbt_to_bmdr(
>>   	ASSERT(rblock->bb_level != 0);
>>   	dblock->bb_level = rblock->bb_level;
>>   	dblock->bb_numrecs = rblock->bb_numrecs;
>> +
>> +	/* Validate record count against destination fork capacity */
>> +	nrecs = be16_to_cpu(rblock->bb_numrecs);
>>   	dmxr = xfs_bmdr_maxrecs(dblocklen, 0);
>> +	if (nrecs > dmxr)
>> +		return;
>> +
>>   	fkp = xfs_bmbt_key_addr(mp, rblock, 1);
>>   	tkp = xfs_bmdr_key_addr(dblock, 1);
>>   	fpp = xfs_bmap_broot_ptr_addr(mp, rblock, 1, rblocklen);
>>   	tpp = xfs_bmdr_ptr_addr(dblock, 1, dmxr);
>> -	dmxr = be16_to_cpu(dblock->bb_numrecs);
>> -	memcpy(tkp, fkp, sizeof(*fkp) * dmxr);
>> -	memcpy(tpp, fpp, sizeof(*fpp) * dmxr);
>> +	memcpy(tkp, fkp, sizeof(*fkp) * nrecs);
>> +	memcpy(tpp, fpp, sizeof(*fpp) * nrecs);
>>   }
>>   
>>   STATIC struct xfs_btree_cur *
>> -- 
>> 2.25.1
>>
>>

