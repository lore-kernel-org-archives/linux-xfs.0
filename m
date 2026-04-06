Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53B83563CD;
	Mon,  6 Apr 2026 07:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775459299; cv=none; b=q+Dkn7AlARruLDx8+foxKi3N9v0dEzQHlm1nEivmQc85YFsp93w5brbdA/SuAd3zoEFBJ+ioQ67nloZ8+3M5ukaxuE9fsZTkVIEf4Nys3tfUQYn2Dde17mkprugANXuISz13WBvbvLdBo3G+v6QlxdOWkuSVPonlhy1d6EoB5Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775459299; c=relaxed/simple;
	bh=5rQacmt8g/luhV6IGVPugWQjSW1w9TI4N7Nq6P5X7DY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LwV8K9ahHCVjn3543DBMnyzB9eATNK1d1xM7VJHeM36c4Cp0t+NrxpM8wfj0Kv2pnqluReEyPPNNzOgl3w97zqYCjdsvT4jyJeCAVjObe/gPxIT07Zhjazw4IfT/09Cl5iQpTfkpXtr2f23xUAcvhKRP9eV/zxUfZM1+bAf6Qls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eGw2BmvO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eGw2BmvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BCDC4CEF7;
	Mon,  6 Apr 2026 07:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775459299;
	bh=5rQacmt8g/luhV6IGVPugWQjSW1w9TI4N7Nq6P5X7DY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eGw2BmvOgx+IHdq5oyo8x2HgbQX2/QFpma4toFmKxnnG+Bs1Z2LbAVTE2ZmAKlSDR
	 b39Ts0xrN2vuuDH1SWQtgwVMoflXQNXDVGAlSclNa2+Je2DOHBGN0krq2w9qpf5A/w
	 q+/xEtjMuQIbfNrkvk6oxOh6qziSVJtJRovBQ8kepujeew07DKjCqFOItyr9ePyboK
	 E6PtRpy9Ofd/16ya7WDcdEOEg7HWdptaXf765IB+SMZTr69T3edaTbGPfmbSmyuAEn
	 eYQoJk+oPLd32F7HJkmHFNB/x3WN6CLpwBo8KbblodKWnnHSu8SN7MiWb4ii5/WR02
	 QXnfzXxwP+efA==
Message-ID: <2b2998f6-260d-426d-9ea5-1019bdb8c77d@kernel.org>
Date: Mon, 6 Apr 2026 09:08:16 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] block: add a bio_submit_or_kill helper
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20260406055728.472919-1-hch@lst.de>
 <20260406055728.472919-4-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260406055728.472919-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/04/06 7:57, Christoph Hellwig wrote:
> Factor the common logic for the ioctl helpers to either submit a bio or
> end if the process is being killed.  As this is now the only user of
> bio_await_chain, open code that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me. Just one comment below.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> ---
>  block/bio.c     | 23 ++++++++++++++---------
>  block/blk-lib.c | 16 ++--------------
>  block/blk.h     |  2 +-
>  block/ioctl.c   | 11 ++---------
>  4 files changed, 19 insertions(+), 33 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index c7e75d532666..994db354439f 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1520,6 +1520,20 @@ static void bio_endio_cb(struct bio *bio, void *priv)
>  	bio_endio(bio);
>  }
>  
> +/*
> + * Submit @bio synchronously, or call bio_endio on it if the current process
> + * is being killed.
> + */
> +int bio_submit_or_kill(struct bio *bio, unsigned int flags)
> +{
> +	if ((flags & BLKDEV_ZERO_KILLABLE) && fatal_signal_pending(current)) {
> +		bio_await(bio, NULL, bio_endio_cb);
> +		return -EINTR;

This was like this in the previous code, so not big deal, but should we perhaps
return the bio error if there was one ? And return -EINTR if there was no error.


-- 
Damien Le Moal
Western Digital Research
