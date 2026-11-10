Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.218
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794300129;
	b=KSGrn6F7cBRD51/N8d/cCP01TVb+OqatxMDBQlcZ+Bq0/Hdd4LG+k1V1OqQA+JOlvTUE
	 0S2g8qO6V0q2t4gH2HSlpfFsMsuWtEczsijlnsA52HcV/6Qo9eBYH9Y4cU2LRjxNTECTQ
	 ifFp0dsy70bZssTLDmPdgzuKGoW66YlqAtfSjhqigkS51ZiacSjy0Z9vUqpjuDzZZ/YIn
	 YWxzGTXabKiKlveUILcAstJzyR9oTTJfQxHRGFtm/Dto7+un2fQhn7Zbc4CmRGUh9z+tz
	 1xs9GCNYckGBf1BSba6BI2JsiC+aVL1KVDWUYYIUndPARDQ/iWN0C50cVza8FA9sYXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794300129;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=i4brgHD7VQEv4fdV28u/B9VtbZT4Ktb9wxX1zeKCj/Q=;
	b=qqzbLibQchxsXyxUIbMrDaXrPSFisVGvFeys5j1Sg0L6V7t8dRcn3Widmq6TSgbmzEE8
	 27SSVrnk2xbw8T7dmeOrZVyfNwY0eV595EUeRi/+xeDnKCf7cQLq3InLoo/rAw8Qs47rr
	 ReJgtsBB+38n67RXb6nyG5Z0UbwyvEqwcHrn7TxyBv5EZODUj+LMxWRMZsrYJsm++/syD
	 xd0a/Y99qEFqgePifPcCs7djOeDANO2gypuK8Uec50TPhwR9+/0lT2BtytS+SbFNREV2S
	 W2NhBRs0XMUQ7bjVS46xaQfNoEcryHN6iJbQB7Xpv4todbd9xGAgTbmWZtmd8LbyN7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=N3tgEyP7;
	arc=none smtp.remote-ip=91.218.175.218
Received: from mta0.migadu.com (out-218.mta0.migadu.com [91.218.175.218])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A25606A334
	for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2026 08:42:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06A25606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=N3tgEyP7
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=MpAEUXW15AK0vZ7aMmJr1Fk1OrZcbJXYROoJ2MHayrg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794300126; v=1; x=1794904926;
 b=N3tgEyP7RxctFPQmoRdYR2r4Te36Wz0U9e2Jct14oyePSp0EbUx9bDvtkzxhbSetWpo1+OP7
 cJy6r2e9T2feyomyfktBlQnPxtQ7baonVCFJ6E39tmLyotgwDwFe1fOP/kNujdeNvZ5mTGUBeoD
 BbxFRpmWO7pzAoD9byh2vOJI=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 6fd72c2406077e29;
	Tue, 10 Nov 2026 08:42:06 +0000
X-Mizu-Trace-ID: 6fd72c2406077e29
X-Migadu-Flow: FLOW_OUT
Message-ID: <f9fd6fc0-8694-45e5-bf00-77bd961ab788@linux.dev>
Date: Tue, 10 Nov 2026 08:42:05 +0000
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] iomap: remove the atomic write length check in
 iomap_dio_bio_iter_one()
To: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20261107-blkdev-atomic-bounce-v1-0-f66344262096@columbia.edu>
 <20261107-blkdev-atomic-bounce-v1-2-f66344262096@columbia.edu>
 <3fc46788-d86d-44c5-8606-385d96fede4d@linux.dev>
 <c27b9521-7c4f-41ff-88f8-55313b5f395c@columbia.edu>
 <4022d4f9-5e2e-45d1-b9b8-208c80f82ecf@linux.dev>
 <21793564-61f4-4d57-b375-1271ad9bc70c@columbia.edu>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <21793564-61f4-4d57-b375-1271ad9bc70c@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/9/26 22:46, Tal Zussman wrote:
>>> What specifically would you want to see tested? I can do an atomic write with
>>> a partially unmapped buffer, with and without stable writes, and check that it
>>> fails and that nothing is written.
>> Just something similar to the blktests case which you added.
>>
> Sounds good, I'll add it to the queue.

Thanks

> 
>> BTW, have you tested this partially-unmapped case for CoW-based atomics
>> on xfs? You can just do that by setting atomic_wr=0
>>
> Yeah, I just tested it. It behaves as expected: returns -EFAULT with the file
> unchanged, both with and without bouncing.
> 
> The single-bio check depends on REQ_ATOMIC, which only the HW atomic path sets,
> so it doesn't apply to CoW writes, both before and after this series.
> 
> In terms of consistency, the unmapped buffer returns -EINVAL on the non-bounce
> HW path (from bio_iov_iter_get_pages()) but -EFAULT for all other paths. That
> should probably be made consistent across HW and SW and bounce vs. non-bounce,
> but that's a separate change.

Yeah, we should fail for the same reason on HW- and CoW-based atomics. I 
would like if any such rules could be documented and we ensure that both 
HW- and CoW-based atomics always fail for non-adherence to the rules.

cheers
