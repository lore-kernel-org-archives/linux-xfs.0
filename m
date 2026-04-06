Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719EB3090D7;
	Mon,  6 Apr 2026 05:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775454650; cv=none; b=aQ0Oe7pLu9yK8zSG6lysx1oR+hhXtS8mBWmYtFKa8UErY/dDNgLbjxWwuCLwiI3SgHyy7AQIgm/vMBEL4V3VNrVi3aYG0kGtpPOxixo/aMeaZd4A73+4uid0ynkEX9S+Wz0h3MDH4Zm9YnUQDbkDEseePZiflQEqRTzu0GgiIbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775454650; c=relaxed/simple;
	bh=MqUe67pBXehro4mrTG8+pxAOJ7TWBp7YPlua05vDqo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tjvuWA+lEOtD7lmjtR1mg6XJhsWFOD7vmD7HYA6rAFcEeQNNaa3E2pnl0bQYWgp3sKiISaXib8MKPbGXpGBdiFctgEpo+gO+rbfdvSDr8UfFgwhuPdESIRYqBvbvWWoV1TQDaYckzvui4w+w7S3Nesf7TIb2iXY6wtTG1o3ctVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AA20768BFE; Mon,  6 Apr 2026 07:50:44 +0200 (CEST)
Date: Mon, 6 Apr 2026 07:50:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] block: factor out a bio_await helper
Message-ID: <20260406055044.GB16443@lst.de>
References: <20260401140433.125924-1-hch@lst.de> <20260401140433.125924-3-hch@lst.de> <2065a50d-9029-44a6-9da0-4a2bb896bdb2@acm.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2065a50d-9029-44a6-9da0-4a2bb896bdb2@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 01, 2026 at 08:35:10AM -0700, Bart Van Assche wrote:
>
> On 4/1/26 7:03 AM, Christoph Hellwig wrote:
>> +/**
>> + * bio_await - call a function on a bio, and wait until it completes
>> + * @bio:	the bio which describes the I/O
>> + * @kick:	function called to "kick off" the bio
>> + * @priv:	private data passed to @kick.
>> + *
>> + * Wait for the bio as well as any bio chained off it after executing the
>> + * passed in callback @kick.  The wait for the bio is set up before calling
>> + * @kick to ensure that the completion is captured.  If @kick is %NULL,
>> + * submit_bio() is used instead to submit the bio.
>> + *
>> + * Note: this overrides the bi_private and bi_end_io fields in the bio.
>> + */
>> +void bio_await(struct bio *bio, void *priv,
>> +	       void (*kick)(struct bio *bio, void *priv))
>
> Please consider swapping the @priv and @kick arguments because that's
> the argument order used elsewhere in the Linux kernel for callback
> function pointers and their private data pointer.

We have plenty of examples for both variants.  And the version here
generates objectively better code, because it keeps the arguments passed
on in the same registers.

> What happened to the bio->bi_opf |= REQ_SYNC statement? Shouldn't that 
> statement be preserved?

Yes.

