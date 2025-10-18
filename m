Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5552D2A1CA;
	Sat, 18 Oct 2025 15:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760799716; cv=none; b=G1Ka8goVEVsGGOVWBiSZ6zOwnI/en63b76CWh3vmHH+zSyN/A7TTT7kEhd+h3TRgaFFIndhcdJPpILkpfrEU791bZgpQ0xhLOKSNCJHITyG9FHEB4wC8Q3fcbvEYwk3g0MRLCaXx4MOmzrDjv9rtBtno+EobfM5X8nxtqIhrV14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760799716; c=relaxed/simple;
	bh=mR8WoVrZ4jn9BtVcljFbhfMVIxkHaHtAc3wyQFPMFio=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mbh/4wyEktqVNZ7JEY+sl40lS6VjnBjvnRnPaoNDFqBnU9KkniIVNaZ9FdrPPlHh5CJ++pIT/QFJRi5dnI5K9+SqajQBL7IYdZVIvLLHnOkbsWHYVuXj6/RDOcNkfralyxNgrDsKi1cMCJMopDp2aSbFYQIJXqEHWB2DlXpLXX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=ekzUClz5; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=VHMsLBRe; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="ekzUClz5";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="VHMsLBRe"
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfout.phl.internal (Postfix) with ESMTP id 5758CEC0102;
	Sat, 18 Oct 2025 11:01:53 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Sat, 18 Oct 2025 11:01:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1760799713;
	 x=1760886113; bh=i+ToOqoqKBnvwiPF7ipU2ldP/5IAZwDg1suxF5YbHSQ=; b=
	ekzUClz5YBPCdN7YhTc6N5Mng/2UzmphXUM6RAxGtnC/lQo/KrokjFEUaly/1sEz
	Ysr5hhMwMDXMXdT294w3weJ9BpT4y/yzQlqFECdrBntVSPLmJPJwaa4Q0ikKUPin
	U9jA41zD9HZ5ANbjnM7Q3zGp2AFnYdV6rTem1e2AJy9JtY+Tgfl9tigC0naDadfc
	ERuVYUK8gf9XrjmZaceS47bjABJtwHJFjzPq/VSgXLoMXM8vXy3iK2/lMyHpuC+H
	WURgXLOLH5vwbGnTPsg3sOftS8jjuwM3rIDZnEEh6OQ1y7vptjXnbCHmEc4TzpUC
	ciKxff6B+XtYXDzQzBI/0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1760799713; x=
	1760886113; bh=i+ToOqoqKBnvwiPF7ipU2ldP/5IAZwDg1suxF5YbHSQ=; b=V
	HMsLBReuzcbnva3leeCgtlG0BBI1t+Dh1mRgYdGBkVL6AteEzkzHe0joUsMknZtq
	sQE4Zb739AAH1QA2N0kfv4s/qKtLn2h4Fk6u8A6Ibtj9QVElaDdY9lo5lB1U5+iA
	WBg1Ez9E/R6fZczXADGATftsYzDu0Yl18ZkfMn8Ybd+KfeldnxUbHIfrGiOJdT74
	KdUhpVgP2bEECX8rLCI4f4Zp+i981NJni1wywaGK+H6EfYtKAhJj9zLV3EF/ZLl1
	scFctoI3mbOxS2H1mJitRfEWZECzi+9QgY2x75VJDJJvUZs/yucxIycfHj7E//Ix
	f+/ECKU2teHCzHYBBdB6A==
X-ME-Sender: <xms:4KvzaFjOZCxzWP0VwKR29_rbJPO3OlEUKRqVO_ZKayd7epNXrbAajw>
    <xme:4KvzaDchsK6XCVUCKprFHsn8-O2lelKjSiha1v9DOeKBL4YipCYvoX4gSVApbxFsV
    WqNLOHniGWgdeJ4O35cb7xZOxQ-HJ82FDJQhge0bYpjDcqD2hQ_ZIyw>
X-ME-Received: <xmr:4KvzaErcHz5X_WJUn30DjBOn_HtXcieT8PcsqKCjXbKnM487wTr8Tt7Q2uU0RJbMvLs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddufedvfeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpefgrhhitgcu
    ufgrnhguvggvnhcuoehsrghnuggvvghnsehsrghnuggvvghnrdhnvghtqeenucggtffrrg
    htthgvrhhnpeevieekueetfeeujedtheeffedvgeffiedvjeejleffhfeggeejuedtjeeu
    lefhvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hsrghnuggvvghnsehsrghnuggvvghnrdhnvghtpdhnsggprhgtphhtthhopeegpdhmohgu
    vgepshhmthhpohhuthdprhgtphhtthhopegujhifohhngheskhgvrhhnvghlrdhorhhgpd
    hrtghpthhtoheplhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehfshhtvghsthhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    ephhgthhesihhnfhhrrgguvggrugdrohhrgh
X-ME-Proxy: <xmx:4KvzaABbnttf66ha_4OUR0M0S-cUiC9qUbkEqAWpBARbN6UvHjtSMw>
    <xmx:4KvzaJalW8e2Z8-DQDjskDQeltu6HA7YEfiZLaKQB6Soj_pLdBzOdA>
    <xmx:4KvzaL7XJJYsJxmNxy7cggC29rSIUFBd36jGvsNYaeTVH53y_Nxp1Q>
    <xmx:4KvzaCa6TTTw98ztLhDFYYHjNpl_xToaa0ZGs5SKjTvzrkwU2YGdoQ>
    <xmx:4avzaPjHNR9Xkclr1cE6Pku2P3-vpwbec3JVtZnIMJltoWpf7v5yZlne>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 18 Oct 2025 11:01:52 -0400 (EDT)
Message-ID: <26eb7381-c95c-4277-ab97-4bdb32d36418@sandeen.net>
Date: Sat, 18 Oct 2025 11:01:47 -0400
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mkfs.xfs "concurrency" change concerns
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
 Christoph Hellwig <hch@infradead.org>
References: <84c8a5e5-938d-4745-996d-4237009c9cc5@sandeen.net>
 <20251010191713.GE6188@frogsfrogsfrogs>
 <f7d5eaab-c2fe-4a11-82d5-a7c5ca563e75@sandeen.net>
 <20251014023228.GU6188@frogsfrogsfrogs>
 <f41be58e-071b-4179-a0e2-7fbbef1e534e@sandeen.net>
 <20251017224652.GJ6215@frogsfrogsfrogs>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20251017224652.GJ6215@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/17/25 5:46 PM, Darrick J. Wong wrote:
> On Tue, Oct 14, 2025 at 10:36:14AM -0500, Eric Sandeen wrote:
>> On 10/13/25 9:32 PM, Darrick J. Wong wrote:
>>>> This was 6.17. The backing file get the nonrotational/concurrency treatment
>>>> but the loop device does. This probably says more about the xfsprogs test
>>>> (ddev_is_solidstate) than the kernel.
>>>>
>>>> ioctl(3, BLKROTATIONAL, 0x7ffd9d48f696) = -1 ENOTTY (Inappropriate ioctl for device)
>>>>
>>>> fails, so ddev_is_solidstate returns false. For the loop dev, BLKROTATIONAL
>>>> says rotational == 0 so we get true for solidstate.
>>>>
>>>> But TBH this might be the right answer for mkfsing a file directly, as it is
>>>> likely an image destined for another machine.
>>>>
>>>> Perhaps ddev_is_solidstate() should default to "not solidstate" for regular
>>>> files /and/ loopback devices if possible?
>>> It's *possible*, but why would mkfs ignore what the kernel tells us?
>>
>> Because for one, it's not reliable or consistent. A loop device and its backing
>> file are on the same storage, of course. We get different answers when we try to
>> query one vs the other via the ioctl, currently.
> 
> The way I see things, I've told you how to turn off the ssd
> optimizations for golden image creation.  You don't appear to like that
> solution and would prefer some sort of heuristic based on stat::st_rdev.
> I suggest you send a patch with your exact solution so that we can all
> discuss on list.

The way I see it, given the tone of the responses so far, I'll be walking
into a buzz saw regardless of how I approach it, so ... never mind.

-Eric
