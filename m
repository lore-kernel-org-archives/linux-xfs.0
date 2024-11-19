Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2031F1C1F32
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 10:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732013086; cv=none; b=n2Dai+NiD+37jWYLTRHL5G2kDKKdpZuX4SnupG6Jt1l+r17rEWH59F9unN4hxdUDFG0PYdXbj2mlaqR+w2eXj8Qg1SbINtP4xr+N3ycDhT9mYCzS/plAXDxwYBL8y+aPMYXSD1MljxuAQj9qFpUF7Ks0Dki2aoqybfN1YkPf7ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732013086; c=relaxed/simple;
	bh=J+N+yhXQwEgmXrGJo1YxAOqwoK6ktgoWi/osPR/36DY=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=anMA85Y/09K/7ON/P21e6Fby8BLMi45asGX8QHh+KFs7/9GiT2x7BVuy6he/pRqvfECJKdYboEcdcQo2w9hVHqJN1t+kRp6Hb8aMxcz0T5DpzK6rXXc4r4n2GjYQHo3rbe0wKCkgEMmtS8qrPXDbcpd3iaZMHjkasobGWnEbGb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com; spf=pass smtp.mailfrom=fastmail.com; dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b=DKmwmn9f; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=IoiUTvdm; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b="DKmwmn9f";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="IoiUTvdm"
Received: from phl-compute-06.internal (phl-compute-06.phl.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 0C9521140146;
	Tue, 19 Nov 2024 05:44:43 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 19 Nov 2024 05:44:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
	cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1732013083; x=1732099483; bh=kR5oDwf7Ok
	6i7qlS8SiyHmrXkOzWn1bO8zbr11DmofA=; b=DKmwmn9fBuR64USDQ1JLfwnc8V
	+SQxVMogZ8Pu+kJoMfnnvsF1cOIxCHn/ag5ckCDnV1Jfe5NjH5BhyNquVLF+fmmC
	7Noy+du9y7QoSsaattC8fBI62+Orzd6QFIMgewS4w5+Y7JgNmOgGyastAbL9Px71
	marmflfWKVN/fzs/B6aW0AAzRV04DQJFhHAE8s98LUmYabgMMVP/T9B38Wuw5C4U
	1pX1w/1RUwo0EfTk/9gjPDUFz7tt3JUBf60iEDT3kguKcMFh3YGbqsC9VL7UnLVy
	pqAdgXv8C0TEWXxNRfcQjMLakya4h7+tWr2IWYRZSob6q1Ypi841B4aRDzsg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1732013083; x=1732099483; bh=kR5oDwf7Ok6i7qlS8SiyHmrXkOzWn1bO8zb
	r11DmofA=; b=IoiUTvdmxIMndrC5jLlUevgWYzpbznuVTbMJUuT6aUUCoK4BWyQ
	5wV3R6vcmtV/B6V6Lkm0/Fn+G+FFQFu6hobQX8M/uVFIFq6iSWcgOWbGt7K5iR5J
	MH32ZGOQqXNvw86Xas9bcXb6cfYEjLoL9xtobMFLWcMnM4K6VGn38g2vfmbNm+JZ
	qX3xECQG2yWLCjK5fad0d5t5WuTHav32CmHM8i3VYRzgHYFtexU8EApH9Evb37Gy
	mG89vof5hWlf8/5IO6u+Ftboh7rl51K84pfC5L04s+UYIf+vQOK+6iue3cVkTzsa
	EZ/ojrkIPcJuVimJQTWBwQgUIo/XM0t81Lg==
X-ME-Sender: <xms:Gmw8Z4fg1GSWS7WaipsSdFyBHpi-EKCRop1_9sAGfSJ4XAsesFNO7A>
    <xme:Gmw8Z6P_xobcKm8mL4QlO8SHiu6ezhCS-g5FAecnTc5n4jYfwt6PUuNZy0VTTXEse
    yjRXnyxzrU81q4oZw>
X-ME-Received: <xmr:Gmw8Z5iiCyjWcdHzzf98cDm3OIIEMnufINH5keuCQOtoXK4m1ASKw-4C7lHYoorvMCHqYMdJQmHTaq7cg-vj8Q9g6DRYKLFoyzZD>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrfedvgddukecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpeffhffvuffkfhggtggujggfsehttdfstddtreejnecu
    hfhrohhmpeflrghnucfrrghluhhsuceojhhprghluhhssehfrghsthhmrghilhdrtghomh
    eqnecuggftrfgrthhtvghrnhepleehtdejudetteethedtheektdfgleffvdeludevfeek
    ieeiveevuedtkeehueehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepjhhprghluhhssehfrghsthhmrghilhdrtghomhdpnhgspghrtghpthht
    ohepvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprggrlhgsvghrshhhsehrvg
    guhhgrthdrtghomhdprhgtphhtthhopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhn
    vghlrdhorhhg
X-ME-Proxy: <xmx:Gmw8Z982DHo0O940lTmhRMinVyygDfdjeFxcLdCgNH4ZHOmZdjnllg>
    <xmx:Gmw8Z0t7VySoj_5cqC7LEX5674uXAF6ezZHypxigQwFW7-tdAUGzpg>
    <xmx:Gmw8Z0F9D0Zy504qCqgERfMjjBfJ93QglfzU1Rqgfy9V7tu8yxJoFQ>
    <xmx:Gmw8ZzNMqgfg1z3epDHbw5KlRTWyEYZP8Mtb_HvgLBMpFKmrkvnMxg>
    <xmx:G2w8Z96GfCg_tIFArxvlNjAIPI37GAOEVpi1-0iZzEHOJ6OeBcz402wj>
Feedback-ID: i01894241:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Nov 2024 05:44:42 -0500 (EST)
Date: Tue, 19 Nov 2024 11:44:40 +0100
From: Jan Palus <jpalus@fastmail.com>
To: Andrey Albershteyn <aalbersh@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_spaceman: add dependency on libhandle target
Message-ID: <36p3n5vqugcyb7bem7v6ch65fbpbpc5hvhjetevp7zbqy7m6nj@sisxajsnscv2>
References: <20241019182320.2164208-1-jpalus@fastmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241019182320.2164208-1-jpalus@fastmail.com>
User-Agent: NeoMutt/20241114

On 19.10.2024 20:23, Jan Palus wrote:
> Fixes: 764d8cb8 ("xfs_spaceman: report file paths")
> Signed-off-by: Jan Palus <jpalus@fastmail.com>
> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index c40728d9..c73aa391 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -97,7 +97,7 @@ quota: libxcmd
>  repair: libxlog libxcmd
>  copy: libxlog
>  mkfs: libxcmd
> -spaceman: libxcmd
> +spaceman: libxcmd libhandle
>  scrub: libhandle libxcmd
>  rtcp: libfrog

Gentle ping on this small, reviewed change.
