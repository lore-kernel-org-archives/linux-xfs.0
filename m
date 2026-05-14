Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20245330B3F
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 16:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778774720; cv=none; b=KPJT0roqgk3XKJw19BAjUtKjTHJvUcFf84UhgMBTol+b8u00VAUd8/nVXG3WvScjzXYtP5y1Gt8ApexXPbJrpBCX/yqnu+L6vYXXGN2RlXmGTL6DdmOK14XsCtJuXQuwxFyoW+Ax06wjjXLAKLZVYOfCGuhVeQSUtaHZARblAL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778774720; c=relaxed/simple;
	bh=u4TNrjVFlVwajmuoZyXRcIP4zbfdirEwylOviTV891w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G2xaHP5rCNyUUCOnB2+bEgXYY0XxtwGzL/UoYYSqONZaOMu1qya1LI7QmGjlJcUe0G/a5C074KGqqGzeZ6p69eQf0PWGTxEhAgXtDAO3LCSlJ9MWHZ6aaw22/UzJ9NgKuwWEzNSfcY2qrkVkiiXWI7+kD1H0bq+4FXYSyATxI2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=MShlTrO6; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=XkiqmtfI; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="MShlTrO6";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="XkiqmtfI"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 444B17A0109;
	Thu, 14 May 2026 12:05:18 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Thu, 14 May 2026 12:05:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1778774718;
	 x=1778861118; bh=u4TNrjVFlVwajmuoZyXRcIP4zbfdirEwylOviTV891w=; b=
	MShlTrO6hpmEtnWAGZ8Nmy1khdripDEp+fRYZedr2GLFq8iSSzhvHa78NXZQUFaF
	c/6crX6XO6B/iRNc86lR93ar487fa6Q0GJKyMYlY11qHfovwuzYuwXcxlJJl4fYD
	1BES3MA/+ZsZ8MzlAlvEscDgZI+JvPuhtAS8tJfOuMPE03kQl8Gbat29ppIduaeG
	atup5WBZJpIEK2dOdp73ASaF0IXx77fe62Fw+3v9hmoHTWmx89uOmNJB16qD3Sd2
	PRwhDFuLeMezZCeUjz+oZRA6edo7GyRJmKLdzdhOdn7Md3Ymc7jVNw/fZfKyyDzC
	cE+fm0IofAt3B7UldJHwkw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1778774718; x=
	1778861118; bh=u4TNrjVFlVwajmuoZyXRcIP4zbfdirEwylOviTV891w=; b=X
	kiqmtfIU9mUxBfxTAEoQUkuuVCrDPXCtDihdQ6+URLeCdG4pBdpjDBv9n6M2c9ME
	UqRdIOCAtZxWZCoSWZEUvbXwqqzIAbulVDSWMJbFx7CVhssL6iUrYXBG8zHB1FzK
	JvsPCNCB+BOBXfXdGSq538+LK5+Q9oX+yt9cBf2CGAEaXVNMAfNGffpAvXjL/IUg
	qoKGf2NboyEXmMygt1G+FV4p1ERL65yhRgvIusLT9yfnuXJgM87woHRF+QmUsdnw
	rLcvfzhM+PYpnmxuvx4pGb9sW2RCb/+dIgSO+lka1pzFavfEEqUDylIQ5J8bDcCh
	sgPGmO8oAQ0nfJDijjeNg==
X-ME-Sender: <xms:vfIFah0b2Gz-OMKoPzgFPsPHmn4TCY5eH2gmxbrKFPqFOyXQ3VBG4A>
    <xme:vfIFau9_SMDeEu_kmsrbAU7429nVvsCHnpn2uK5OU3NbHN4urlH4pfLHm_2t8knT6
    Rk-S3cDSZHoQ3FJSt2I23m2RckpknP2C7ZwxmcUzmpM3QxfAtNc1B-D>
X-ME-Received: <xmr:vfIFaqPFNdfDTKR09kfsDHDpOVvBf3CGtjShb-Z3FwmkWhmxEXC487LbCBRDRENMAnmMCuRPY0H_b7Wvuh8Lr6v7tAJVFd-oqHfBwBToYS4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduvdejleehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpefgrhhitgcu
    ufgrnhguvggvnhcuoehsrghnuggvvghnsehsrghnuggvvghnrdhnvghtqeenucggtffrrg
    htthgvrhhnpeevieekueetfeeujedtheeffedvgeffiedvjeejleffhfeggeejuedtjeeu
    lefhvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hsrghnuggvvghnsehsrghnuggvvghnrdhnvghtpdhnsggprhgtphhtthhopeehpdhmohgu
    vgepshhmthhpohhuthdprhgtphhtthhopegtvghmsehkvghrnhgvlhdrohhrghdprhgtph
    htthhopehluhhkrghssehhvghrsgholhhtrdgtohhmpdhrtghpthhtohepughjfihonhhg
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrrghlsggvrhhshheskhgvrhhnvghlrd
    horhhgpdhrtghpthhtoheplhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhr
    gh
X-ME-Proxy: <xmx:vfIFaqfCWgOH-bQjah0HUDiJfTjHB49J6mIF6RJjPy8um7A33l_BNQ>
    <xmx:vfIFahWokHGyQqYa9kI2vBnKziH10ZSTsNbYBj_NSTFEby699BPm1A>
    <xmx:vfIFaqjI8n5U7zPkEgRHSzQpqqg-mPv5T01ysPYvezd_9Guf_u24og>
    <xmx:vfIFao-nvy6PpbSy4cyTJDdnth9aMqQssPtuu8bsyxgqzrdkuticfA>
    <xmx:vvIFavp3n05spE82ffXRRleSMY7KHGdtJB7DGoxrYYkQllb_MPbIQhoI>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 14 May 2026 12:05:16 -0400 (EDT)
Message-ID: <fddc8573-8461-475f-9826-ee465c48c969@sandeen.net>
Date: Thu, 14 May 2026 11:05:14 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/1] xfsprogs: mkfs.xfs add default configuration
 file.
To: Carlos Maiolino <cem@kernel.org>, Lukas Herbolt <lukas@herbolt.com>
Cc: djwong@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org
References: <20260514143716.893814-2-lukas@herbolt.com>
 <20260514143716.893814-3-lukas@herbolt.com>
 <agXnLdc5kzfyOI3P@nidhogg.toxiclabs.cc>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <agXnLdc5kzfyOI3P@nidhogg.toxiclabs.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/14/26 10:21 AM, Carlos Maiolino wrote:
> On Thu, May 14, 2026 at 04:37:17PM +0200, Lukas Herbolt wrote:
>> Various users may prefer different default values. Having a default config
>> file will allow them to utilize it without the need specifying configuration
>> file on command line.
>>
> The idea seems reasonable, to have a default file to load if it's found.
> I just particularly don't like the idea of shipping/installing a 'default'
> config file.
> I think we could ship an "example" one, but leave to distributions to decide
> what to do. If they would install a default config or not. And maintain
> the default config file.
> LTS configs are easy to maintain because we know no new features will be
> ported to LTS. Providing a default config file from the mainline risks
> getting a lot of user complains if we in the future decide to change the
> 'defaults' of the default config file.

Thanks for starting this discussion Lukas.

I'm sure others will have Deeper Thoughts but I more or less agree with
Carlos here - a default config file to be loaded /if it exists/ but maybe
not existing by default - because we already have defaults hardcoded into
the binary itself - might be a more maintainable path for upstream.
Otherwise I see new tests appearing which are like "make sure the dfault
config we ship matches the defaults built into the binary itself" which
seems like unneeded complexity.

(i.e. the os-specific config files could be renamed or symlinked to
that special default config file path, for example?)

I could maybe see generating an example defaults config file which matches
the built-in defaults at build time? Not sure if that would be useful
or helpful (or complex).

Thanks,
-Eric
