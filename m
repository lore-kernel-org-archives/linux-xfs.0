Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794249879;
	b=F3+MgPzFp9aUJq9AO8mCBAnIMIxkA9wlXo/RewcCWU596Xcg8VYOTo4HtXvBMcHsk4EY
	 0i3eayOgpHe17S5MRnMWt0AdVZFAmwRoQRnJzrR0c4bXLfgm5nZA0pRVb/xubxyNsOP7E
	 vjO66s1JM7ck014TZ4h0amyQn+NJv/PV8yMi99lPzFEW2ROV17s1m8wf6EpA+0rGmXXBJ
	 F0/B140m53/yU8qoCWHos5/wMzNJ6iRKPMV+nV+kKsPROVVtot3GcBPh2hfUvILQC7zwt
	 JBOLM+OG9/jA0ZScpswy094iWAjyG1yJ+X/CToneVypJrCGuixMdCsIW8kocMD9S5wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794249879;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=Bwh8vGADWjPBmVfab76LRrb7I0TG/Y5xxN+WzXcgV8c=;
	b=1rlCiRw1wTFUV/zIakGj06UE6TXmET0pWluaWIpD8jOwlFrXGxnfVe6nunsbIzfCrFTh
	 G7lGaGkcfwVayM8jJPN/G217lPVzNbli+hmke1xoijkdkwo1xI4QEkNShKMsYz+E1YtJ0
	 TyFfDf+2DScCUY0DEdafsU57PxIRDng+vi+NJVECAIk5lP+4ADJQbnD24j6SvlG74qZdi
	 +uqciRv8YjfTuEhiP1ONHc5t/o4m9RJRbcF0zIiWPFbxmb/+N7x0i4oVybZ0U7qGjJYj6
	 rYUJGhCD6pUkmCg/IUqsqpWTYqdkJuWzAmrMlBbMl+YKe4G5kkThocCt1hI4usi8NQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=A6H3JcTC;
	arc=none smtp.remote-ip=95.215.58.25
Received: from mta1.migadu.com (out-25.mta1.migadu.com [95.215.58.25])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC31606A321
	for <linux-xfs@vger.kernel.org>; Mon,  9 Nov 2026 18:44:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BC31606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=A6H3JcTC
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=eejodZC9+iYJaqetGqYUSu07t8YAd2/V+1t3zStwLwI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794249876; v=1; x=1794854676;
 b=A6H3JcTC5htqLiYhRXDZjfXACQRFaxlvUYQRreKY7EJX0jrkW6Js56RoUVL4F96nIoTG4x68
 HJDvpI/MVrOQSQHYut+E18rc9OeFYvDLnxKnlJQiiAmCGYjhIXAxbR6Rb1FgbGkYWPOKckztDZp
 N8vFbftLcph0V8HaTDKSD3LM=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 24141ff8b478b109;
	Mon, 09 Nov 2026 18:44:35 +0000
X-Mizu-Trace-ID: 24141ff8b478b109
X-Migadu-Flow: FLOW_OUT
Message-ID: <4022d4f9-5e2e-45d1-b9b8-208c80f82ecf@linux.dev>
Date: Mon, 9 Nov 2026 18:44:34 +0000
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
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <c27b9521-7c4f-41ff-88f8-55313b5f395c@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/9/26 18:34, Tal Zussman wrote:
> 
> 
> On 11/8/26 12:06 PM, John Garry wrote:
>> On 11/8/26 04:24, Tal Zussman wrote:
>>> bio_iov_iter_get_pages() and bio_iov_iter_bounce_write() now fail a
>>> REQ_ATOMIC bio that doesn't cover the whole iterator, so the bio here
>>> always covers iomap_length() and the check can't trigger. Remove the
>>> check.
>>>
>>> Suggested-by: John Garry <john.garry@linux.dev>
>>> Link: https://lore.kernel.org/all/82978d5c-3e08-48e9-bf0a-7913e1cd0507@linux.dev/
>>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>>
>> Reviewed-by: John Garry <john.garry@linux.dev>
>>
> 
> Thanks!
> 
>> This looks ok. But I am just thinking that a CoW-based atomic write does
>> not have the single bio restriction, so we don't need to fail the atomic
>> in this case. However, we should have consistent rules for iovec's
>> whether it's a block device or regular file for ext4 or xfs, so this
>> makes sense.
>>
>> thanks
>>
>> BTW, you could be a real hero and add an xfstests case for this also.
>>
> 
> What specifically would you want to see tested? I can do an atomic write with
> a partially unmapped buffer, with and without stable writes, and check that it
> fails and that nothing is written.

Just something similar to the blktests case which you added.

BTW, have you tested this partially-unmapped case for CoW-based atomics 
on xfs? You can just do that by setting atomic_wr=0

Thanks,
John

> 
>>> ---
>>>    fs/iomap/direct-io.c | 14 --------------
>>>    1 file changed, 14 deletions(-)
>>>
>>> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
>>> index ad041ac3252a..aca7cbaea4af 100644
>>> --- a/fs/iomap/direct-io.c
>>> +++ b/fs/iomap/direct-io.c
>>> @@ -370,15 +370,6 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
>>>    		goto out_put_bio;
>>>    	ret = bio->bi_iter.bi_size;
>>>    
>>> -	/*
>>> -	 * An atomic write bio must cover the complete length.  If it doesn't,
>>> -	 * error out.
>>> -	 */
>>> -	if ((op & REQ_ATOMIC) && WARN_ON_ONCE(ret != iomap_length(iter))) {
>>> -		ret = -EINVAL;
>>> -		goto out_bio_release_pages;
>>> -	}
>>> -
>>>    	if (dio->flags & IOMAP_DIO_WRITE)
>>>    		task_io_account_write(ret);
>>>    	else if ((dio->flags & IOMAP_DIO_USER_BACKED) &&
>>> @@ -393,11 +384,6 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
>>>    	iomap_dio_submit_bio(iter, dio, bio, pos);
>>>    	return ret;
>>>    
>>> -out_bio_release_pages:
>>> -	if (dio->flags & IOMAP_DIO_BOUNCE)
>>> -		bio_free_folios(bio);
>>> -	else
>>> -		bio_release_pages(bio, false);
>>>    out_put_bio:
>>>    	bio_put(bio);
>>>    	return ret;
>>>
>>
> 

