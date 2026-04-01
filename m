Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1D935C1B1;
	Wed,  1 Apr 2026 15:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775057718; cv=none; b=abUTeWlNGbZxRcumN7UDKE/iGItq59VckCijzy6gyzG+Z4y3hyvo0DGOEYPLWFHbd/QOLRLnfmqCFRQaNmfhaUV81KncGYOUkLp55uJAxK/zxLzMlVRmIV6C8nUY6Hau/tX5PybqFhsD8T3xmwnXUTdLihyJtxiM2giMg9WgVmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775057718; c=relaxed/simple;
	bh=RWxOzvRVwpL7R/NMB+NkAUQl/B2JzFYxoaZT9/L880E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=orX/0dy1qDBJ5B+tTXihYYPsn98/jsCSNdi2bIXxLNpWw6xV+jrTD4Ht+oJVc5+V2SIfXRdF0ryDEA4yR0ys5hU6mmBjZm4egUFS2JA2fPHeJFcZKrllzxuQgF91FBtidCsLKhuJCR12xGKomhSLmVX9Y49/QtF85JtI2uZajYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iKYdOtm/; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iKYdOtm/"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fm8FK0bB1z1XM6J5;
	Wed,  1 Apr 2026 15:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1775057713; x=1777649714; bh=+5WTKPiqOZxtgwD0jfQmoenc
	FtJKXWhfTwDskOZP80c=; b=iKYdOtm/pdApHSTqplLLEatnAw7RcYppx/VteGm2
	do0YMAbTd3x1XUUxNSjsISfvCdg8/Ln9+NEklZSJhOQztsgFiLAXpehoLG0nbEWN
	hHiK493Kq97kshzvRXb2nCKPNmR3UDYW+wc/a5pq5uECR3cTR22pzU+cR1f1dtAW
	L5PWeRm0tUR2j0KNhpPThH4xU8r3ufHYqve0fPCUue5yNuvECs/qdVXI2z9JVM2R
	M0lm6/Ks53Opj5pIeetbpz9+yc/pQQy0XgsXZEoKGykjqIOXHI4ynkl7uZJPwVUH
	v5HGeRsdr9RT1+vR7670sjGNvTSohN4JkXhl5Q7UNRdJiw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7Fg3Tum51IeD; Wed,  1 Apr 2026 15:35:13 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fm8FC47t7z1XM5jn;
	Wed,  1 Apr 2026 15:35:11 +0000 (UTC)
Message-ID: <2065a50d-9029-44a6-9da0-4a2bb896bdb2@acm.org>
Date: Wed, 1 Apr 2026 08:35:10 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] block: factor out a bio_await helper
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>, linux-block@vger.kernel.org,
 linux-xfs@vger.kernel.org
References: <20260401140433.125924-1-hch@lst.de>
 <20260401140433.125924-3-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260401140433.125924-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/1/26 7:03 AM, Christoph Hellwig wrote:
> +/**
> + * bio_await - call a function on a bio, and wait until it completes
> + * @bio:	the bio which describes the I/O
> + * @kick:	function called to "kick off" the bio
> + * @priv:	private data passed to @kick.
> + *
> + * Wait for the bio as well as any bio chained off it after executing the
> + * passed in callback @kick.  The wait for the bio is set up before calling
> + * @kick to ensure that the completion is captured.  If @kick is %NULL,
> + * submit_bio() is used instead to submit the bio.
> + *
> + * Note: this overrides the bi_private and bi_end_io fields in the bio.
> + */
> +void bio_await(struct bio *bio, void *priv,
> +	       void (*kick)(struct bio *bio, void *priv))

Please consider swapping the @priv and @kick arguments because that's
the argument order used elsewhere in the Linux kernel for callback
function pointers and their private data pointer.

>   int submit_bio_wait(struct bio *bio)
>   {
> -	DECLARE_COMPLETION_ONSTACK_MAP(done,
> -			bio->bi_bdev->bd_disk->lockdep_map);
> -
> -	bio->bi_private = &done;
> -	bio->bi_end_io = bio_wait_end_io;
> -	bio->bi_opf |= REQ_SYNC;
> -	submit_bio(bio);
> -	blk_wait_io(&done);
> -
> +	bio_await(bio, NULL, NULL);
>   	return blk_status_to_errno(bio->bi_status);
>   }
>   EXPORT_SYMBOL(submit_bio_wait);

What happened to the bio->bi_opf |= REQ_SYNC statement? Shouldn't that 
statement be preserved?

Otherwise this patch looks good to me.

Thanks,

Bart.
