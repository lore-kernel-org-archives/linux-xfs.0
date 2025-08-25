Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5F427703A;
	Mon, 25 Aug 2025 15:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756135910; cv=none; b=Aol1GIEQNdXG0s/nm1PAGECIGiGaQ+qqoreR1unEvJgaGVsphKuqRwHGOptKLKtHnsdbH3XNVmP9KrsNiJ8kSCBjPw24STH9gwXIaSuhpL126+29JbFHLomh64SX+bG4ZqlXA2Y+qvtuqOEM7FfitRPCU5Gy4oUEENqsRQTKGfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756135910; c=relaxed/simple;
	bh=zbWkyVXnxMSene78pmXJ8oBGvr2CDEba7oVxMzvFbn0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UP2Sbz9MUoyt9RoY266Z4b4BQ5mLRNVFAhCR/wHPGHBqCGSw3M6jlYaz2wZIBNwSmlJVK7l2kaymoSt8KxQ85zEhKD/qn0xmhNeAyuWTBhXd9alhB9KIf3B2clYMUml5q0xQds2LGj4QkDn/4Pjk2dBIUwKgFODx8s0J/C6ySvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=OzlF7xJ/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Gi2ofYe3; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="OzlF7xJ/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Gi2ofYe3"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 5E58614000FB;
	Mon, 25 Aug 2025 11:31:46 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Mon, 25 Aug 2025 11:31:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1756135906;
	 x=1756222306; bh=pr7xK785ii+AwC3ghCIZynz3XkESPopY5hwOsvD1K8k=; b=
	OzlF7xJ/zWmxrL9MCsyJF5UNTxAGmT1W2RIfjKeN7emldcmt65KB7XGK/YNWhPxw
	RB4UkudIounVrBM/SlTX7W2i5mhjby4GvTnJ9bM6nsONwFHUuGFic55MVXkNVBIO
	G+lIgdRfnp2uwrUXBpz96gn0wO46m36Imo2eRD9DZVkgHuvbNwOEKv2rNAgiYVVn
	u2Ddv429+3Sdn8Js6yVqRNg8qANzTga7RARQgZcaC90aR3I1RMKEtrYDntqFjuNB
	SQfv9/nNmNuK8wegf/Qonon7UksZiVvhnXime2YoLt6FwavRh02ejw7RqmSll6GL
	jCiPVQ51FyI4gSOEfBZrxw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1756135906; x=
	1756222306; bh=pr7xK785ii+AwC3ghCIZynz3XkESPopY5hwOsvD1K8k=; b=G
	i2ofYe3bkmMSMY63SN+UJ3KR+wivBYi7uh64VyV9H3Kai1J9I44Ep/x3PlFBStg4
	VdFnnQjkOmHkSBkBNGGIhgKuf/ijerXAZSr+XLUAPSAq5u8mdYDICHHf1IMf8kN6
	1qrk3U83/IEBAlqeZgrD3sBNkkvZdMY2NJoGE71FShjnoarkdkbrJIjZzyNZXv56
	+qR60KYqlebMCoKoEO8VQ9hNDCCjgL8/JI3L3vc7SVrO7yFnHQdkgHhy/HVB3S7S
	ef1ixp8j8WmUIm2/LlLqsB5in9bvhs7WmFVSpR+FpjV5neexA8a3wZLZ+0bQZuu7
	JnetgxUqAx3oLAOnIBUVg==
X-ME-Sender: <xms:4oGsaAKigpfV9cJjdT0e3EERO6f66tFV8UDmrR-oO0iE7JQVptyYfw>
    <xme:4oGsaD-buT0BzrRuQI5hLx1zp3QnP2nX_1AICygmKOHhqa7gtptKARleV3u02Eddd
    EP-qDorlXlfsXuv_Ww>
X-ME-Received: <xmr:4oGsaJwT4xtMViDOKKIwq_mXJmkqLwjwvlZ8CxGqsbY1yh3CnUwSXbjJimzuBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddujedvjeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpefgrhhitgcu
    ufgrnhguvggvnhcuoehsrghnuggvvghnsehsrghnuggvvghnrdhnvghtqeenucggtffrrg
    htthgvrhhnpeevieekueetfeeujedtheeffedvgeffiedvjeejleffhfeggeejuedtjeeu
    lefhvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hsrghnuggvvghnsehsrghnuggvvghnrdhnvghtpdhnsggprhgtphhtthhopeejpdhmohgu
    vgepshhmthhpohhuthdprhgtphhtthhopehhtghhsehinhhfrhgruggvrggurdhorhhgpd
    hrtghpthhtohepughjfihonhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsrghn
    uggvvghnsehrvgguhhgrthdrtghomhdprhgtphhtthhopehlihhnuhigqdigfhhssehvgh
    gvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepugguohhufihsmhgrsehrvgguhhgr
    thdrtghomhdprhgtphhtthhopegutghhihhnnhgvrhesrhgvughhrghtrdgtohhmpdhrtg
    hpthhtohepshhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:4oGsaA7d97Lu0lJN1eC0hmDjl1yrUIQL9qHIPE-7C5mtMD0UHZhsrA>
    <xmx:4oGsaA-udF-wiVGYTqrsKzONVss-OGhCGJbiAECH4rHhpwH6cgL69g>
    <xmx:4oGsaFpUcIT1q6GuuqtcxPG_pydSudPNxR0OLG3aNteQfJ1b3_P4WA>
    <xmx:4oGsaBrkfZM-nQZ9eCU0hkJAypiDLGSH3NhFFOT49cNFV5KFy5o3Zw>
    <xmx:4oGsaE_6Wh2kIIZEfnpuzGGYLs7Fuc0SkvqgCIjzBQRcqFSNhdzwc1RZ>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 Aug 2025 11:31:45 -0400 (EDT)
Message-ID: <b5e5de1d-5672-495d-b116-8531d66ca356@sandeen.net>
Date: Mon, 25 Aug 2025 10:31:43 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: do not propagate ENODATA disk errors into xattr code
To: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong"
 <djwong@kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 Donald Douwsma <ddouwsma@redhat.com>, Dave Chinner <dchinner@redhat.com>,
 stable@vger.kernel.org
References: <a896ce2b-1c3b-4298-a90c-c2c0e18de4cb@redhat.com>
 <20250822152137.GE7965@frogsfrogsfrogs> <aKwW2gEnQdIdDONk@infradead.org>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <aKwW2gEnQdIdDONk@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/25/25 2:55 AM, Christoph Hellwig wrote:
> On Fri, Aug 22, 2025 at 08:21:37AM -0700, Darrick J. Wong wrote:
>> We only flag corruptions for these two error codes, but ENODATA from the
>> block layer means "critical medium error".  I take that to mean the
>> media has permanently lost whatever was persisted there, right?
> 
> It can also be a write error.  But yes, it's what EIO indidcates in
> general.  Which is why I really think we should be doing something like
> the patch below.  But as I don't have the time to fully shephed this
> I'm not trying to block this hack, even if I think the issue will
> continue to byte us in the future.

Right, as I said we need to do something like what you suggest, which
is 100% fine by me.

I'd just like a safe, very targeted fix merged first, to handle the
currently observed and reported error. A bigger scope change pushed
back to stable kernels has somewhat more risk, and I'd like to avoid
that.

I'll work on something like this, and send another patch that's 
something like "xfs: generalize block device error handling" or
whatever, that effectively reverts the patch proposed by me, and
adds this patch proposed by you.

If it soaks a little and has no regressions, I'd be happy to send the
broader fix back to stable as well.

Thanks,
-Eric

> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index f9ef3b2a332a..0252faf038aa 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1290,6 +1290,22 @@ xfs_bwrite(
>  	return error;
>  }
>  
> +static int
> +xfs_buf_bio_status(
> +	struct bio		*bio)
> +{
> +	switch (bio->bi_status) {
> +	case BLK_STS_OK:
> +		return 0;
> +	case BLK_STS_NOSPC:
> +		return -ENOSPC;
> +	case BLK_STS_OFFLINE:
> +		return -ENODEV;
> +	default:
> +		return -EIO;
> +	}
> +}
> +
>  static void
>  xfs_buf_bio_end_io(
>  	struct bio		*bio)
> @@ -1297,7 +1313,7 @@ xfs_buf_bio_end_io(
>  	struct xfs_buf		*bp = bio->bi_private;
>  
>  	if (bio->bi_status)
> -		xfs_buf_ioerror(bp, blk_status_to_errno(bio->bi_status));
> +		xfs_buf_ioerror(bp, xfs_buf_bio_status(bio));
>  	else if ((bp->b_flags & XBF_WRITE) && (bp->b_flags & XBF_ASYNC) &&
>  		 XFS_TEST_ERROR(false, bp->b_mount, XFS_ERRTAG_BUF_IOERROR))
>  		xfs_buf_ioerror(bp, -EIO);
> 



