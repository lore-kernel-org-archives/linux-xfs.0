Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CFA33F59E;
	Tue,  7 Apr 2026 15:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775574013; cv=none; b=nTzGYrC7CyUufODDE9UMveq3Yp+ZGX0iGKjU/FLLExi/uOdaz0d0yt3p3vO54MEPTg3R7zFcIw/Xw/sHxTJwakVlbpdg8cftXNFQG6lnZbSQhjXHYwiyy9O/S5c4wEXTwr5Kkszvb6Qg8WZi2tuL4QgAA0fjNx2l/M/l9MmQTfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775574013; c=relaxed/simple;
	bh=Fg/kMmhhRbjJ0m7uh1SYJ7lod4Y/6kq6NfqyBJ49mwE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n6aG/p1VLOWNweuNcBZDLETJwIVD3idOVJpJcSxLZFVcdOL0bSQM0oFDg6l2oruCzKGTv1vjKDfQ+3m2Yrhwxz0078NBdqc7EHbxE2TegBzrVXXHCtGxUnzGx9D6TtrJjki9Ofdn7HMdONJqG0j7D+jvyhfUJfLYr3Xvv4bgFuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NqAgn6p7; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NqAgn6p7"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fqq9y11x3z1XMFjh;
	Tue,  7 Apr 2026 15:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1775574000; x=1778166001; bh=W9tkNxEBxYPxkrILtxeQFiPe
	0qucPnupyHkzIyPwX9Q=; b=NqAgn6p7uYCWnWEXIeA8I54KyXOL3fmYf9TNvFBK
	Jc4Fcc1UHzXb89kLlCWQpgdd3gD/N7cjscSgYOCBsq0GeKdiYc82Y+JIp5kIs7hP
	XGGnpnBFq/DCVUX/Knr0bh4CaMa8atB/GM/ZOzhDJIvxQymJgUraYdpA529hAoje
	MI5aBGHM7fxysBLbaj1uLuDzrextTw/URs638Q5F72GM9gpQm6uzuN0TE+Wi9Ry1
	R8XYnMJSGJ6hziOEJl+GR1JJDOUQS/vgYI3Kqa+P7DuiZbKPySJx2W3RID5R7uYL
	fKPXRJA90J6H8mgmO2t19D592rG3m0uSYpSrr9DP3pqm8w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QqjXz6Ihd8if; Tue,  7 Apr 2026 15:00:00 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fqq9p56xfz1XM6JZ;
	Tue,  7 Apr 2026 14:59:58 +0000 (UTC)
Message-ID: <dbbd5553-1442-4a90-88cd-59348f81cbb7@acm.org>
Date: Tue, 7 Apr 2026 07:59:57 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] block: factor out a bio_await helper
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20260407140538.633364-1-hch@lst.de>
 <20260407140538.633364-4-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260407140538.633364-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/7/26 7:05 AM, Christoph Hellwig wrote:
>   /**
> - * submit_bio_wait - submit a bio, and wait until it completes
> - * @bio: The &struct bio which describes the I/O
> + * bio_await - call a function on a bio, and wait until it completes
> + * @bio:	the bio which describes the I/O
> + * @submit:	function called to submit the bio
> + * @priv:	private data passed to @submit
>    *
> - * Simple wrapper around submit_bio(). Returns 0 on success, or the error from
> - * bio_endio() on failure.
> + * Wait for the bio as well as any bio chained off it after executing the
> + * passed in callback @submit.  The wait for the bio is set up before calling
> + * @submit to ensure that the completion is captured.  If @submit is %NULL,
> + * submit_bio() is used instead to submit the bio.
>    *
> - * WARNING: Unlike to how submit_bio() is usually used, this function does not
> - * result in bio reference to be consumed. The caller must drop the reference
> - * on his own.
> + * Note: this overrides the bi_private and bi_end_io fields in the bio.
>    */
> -int submit_bio_wait(struct bio *bio)
> +void bio_await(struct bio *bio, void *priv,
> +	       void (*submit)(struct bio *bio, void *priv))
>   {
>   	DECLARE_COMPLETION_ONSTACK_MAP(done,
>   			bio->bi_bdev->bd_disk->lockdep_map);
> @@ -1486,13 +1489,37 @@ int submit_bio_wait(struct bio *bio)
>   	bio->bi_private = &done;
>   	bio->bi_end_io = bio_wait_end_io;
>   	bio->bi_opf |= REQ_SYNC;
> -	submit_bio(bio);
> +	if (submit)
> +		submit(bio, priv);
> +	else
> +		submit_bio(bio);
>   	blk_wait_io(&done);
> +}
> +EXPORT_SYMBOL_GPL(bio_await);

[ ... ]

>   void bio_await_chain(struct bio *bio)
>   {
> -	DECLARE_COMPLETION_ONSTACK_MAP(done,
> -			bio->bi_bdev->bd_disk->lockdep_map);
> -
> -	bio->bi_private = &done;
> -	bio->bi_end_io = bio_wait_end_io;
> -	bio_endio(bio);
> -	blk_wait_io(&done);
> +	bio_await(bio, NULL, bio_endio_cb);
>   	bio_put(bio);
>   }
The comment above bio_await() says that the callback function passed as 
third argument submits the bio. The above code passes bio_end_cb as the
"submit" argument. bio_end_cb() does something else than submitting a
bio. How about renaming the "submit" argument of bio_await() into
something else, e.g. "cb" or "callback" to make its role more clear?

Thanks,

Bart.
