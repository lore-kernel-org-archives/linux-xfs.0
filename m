Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78AC2E8B6C
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806799; cv=none; b=YFor6kqKxAZDGTP534K/ZzYk7gJd3YTk4ZbNphy0prDqpWOywck4JcO/nml2UHJcWelUZwPcbql5qK1n1F3+3diRjIT0qO5U4/jhStbMly0mS85Kz9Bg45e1VWgBxR6iz9Nugr4uuvGVu2AhjHkBbOBhsURYiDNTmWZV079ibXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806799; c=relaxed/simple;
	bh=8K+U4S2Rbr0jrtv6zU8LEeUDXArDH9aLx84rV4Zmw6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jMqqGWT5KOvS0SiVDJHZbxLkyxgzI98pXcnO4xMuq3FwtxZTU4IbwpHGZc9RquqtsGeCe0ho52VLe2Zf8YHQAp748SLBjMcd/00FvFsnl9pRGVan6QHqXaTx9Qh27+YsFK5dcXz6Xvx8KYrpxcHhRXzddKVD9yPGIH2dSDWo7K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=Ro0L7aU9; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=CLYjFUgE; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="Ro0L7aU9";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="CLYjFUgE"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id CC31D7A0133;
	Thu, 21 Aug 2025 16:06:35 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 21 Aug 2025 16:06:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1755806795;
	 x=1755893195; bh=ul/RVBCCJxocbjuD4rj2z7TbOVguqtR/MwxbjIkJn18=; b=
	Ro0L7aU9Fo0UGmZeiFFDQT/GvzQKYhJKjz57DUvTC/odO5S4D9yNxrBN8lkhhExH
	2Bgdf9UK5qN+Qv0bUuXvPDc2J3sgZ1ajmAmQWBpgQk5mdnSWBRXXVWf6tfgGcxWH
	MZR96MwCdyBiN5sfUGTB5A594kyuJCGhD4msm3yN0gsz2Q28a30Vln7Iz6dYB0u4
	GjGuHASNwXCcMOgtcXWjYd/xfF1/2n7jbRP269y8M94Z5k15mws/fylK9XiWYSmO
	l8QLUoeqGutXxpEhgCrz9iMwZ2DCG8xKKejs5KRFGf6FY2AVNrfsMB704MCsxgWp
	lV6Ce/wRYAN6DuCtttAg9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1755806795; x=
	1755893195; bh=ul/RVBCCJxocbjuD4rj2z7TbOVguqtR/MwxbjIkJn18=; b=C
	LYjFUgEsB4i/wH0fsqa9ij/4CWdRGyp7ZxBGg0hG8KGnEyRDdjVzFHbGBImXLRGV
	8Up7ZnvPvltt77hLDsWNk7BJORaPkX6dTrNL+ZbT3CLAEZYvJtmg938CnH3jXDG0
	Oz0dFtZt0JJUl3nMGbZB+ERiveWuRXRBu9snMEKqNpGPa7DmNlHsI/fyiqNdl5C7
	bcYjrQfovxh02UwzcvHdtaWCUe3GlXGJ2MAEaUvrO23ULRnF3YeCaVAi4rsIynDX
	tcG1GZzpEUmMWoGB2yi5slMvkOQTNkiDmosXWRhN2OtcYYSRCr2S48hd6hgnuafP
	pWlWHmABhTNXGDDu0uKNQ==
X-ME-Sender: <xms:S3ynaIcQVs9YFLqQlsY5B_fZhnUBTYxgWpu0OnOSa_05qGdKZx-WiQ>
    <xme:S3ynaFvmBIy5AzLgmsqqaB-4HN1HxeIBorA_AbM2pxWwVu9EvstO0KV5-dbsYEXMg
    qR2M5wyXB3FL99Q9cc>
X-ME-Received: <xmr:S3ynaP8AkdD6W0P9rwP__npqw8g68ZZj2U-GN0ZUiHBcav8v_2Oum9npI7D4_NN_9B7Ncn-3KB8pPUPyIkhxf5FlkQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduiedvudehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpefgrhhitgcu
    ufgrnhguvggvnhcuoehsrghnuggvvghnsehsrghnuggvvghnrdhnvghtqeenucggtffrrg
    htthgvrhhnpeevieekueetfeeujedtheeffedvgeffiedvjeejleffhfeggeejuedtjeeu
    lefhvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hsrghnuggvvghnsehsrghnuggvvghnrdhnvghtpdhnsggprhgtphhtthhopeehpdhmohgu
    vgepshhmthhpohhuthdprhgtphhtthhopegtvghmsehkvghrnhgvlhdrohhrghdprhgtph
    htthhopeguughouhifshhmrgesrhgvughhrghtrdgtohhmpdhrtghpthhtohepughjfiho
    nhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsrghnuggvvghnsehrvgguhhgrth
    drtghomhdprhgtphhtthhopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdho
    rhhg
X-ME-Proxy: <xmx:S3ynaI1DzFaVqFJeSzAoec4iuCtvPhc01Ht05HmXFvYv-KgyGCmbeQ>
    <xmx:S3ynaMDKoQky1nuHXK-iuPcrzUm8Wq4fi2Z6fnQ9nVapnelViTUN0g>
    <xmx:S3ynaMcbRTW29UkdUbNWbhvTrKpB1njo8QCT4hPHPrE7cnM8RtFzUg>
    <xmx:S3ynaB7fRupyNCRBnoqsIvq86lkyKvpni3RZk9qRy7loMjXhoIwsmQ>
    <xmx:S3ynaPa47hZ9zvRUaBQoADfWuzkE6zgvuqQY5hiMr1q2LIKRJFX_GQ8S>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 21 Aug 2025 16:06:35 -0400 (EDT)
Message-ID: <e719e02a-508b-4417-8819-c27b8ea5c60b@sandeen.net>
Date: Thu, 21 Aug 2025 15:06:34 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] xfs: remap block layer ENODATA read errors to EIO
To: Carlos Maiolino <cem@kernel.org>, Donald Douwsma <ddouwsma@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Eric Sandeen <sandeen@redhat.com>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <1bd13475-3154-4ab4-8930-2c8cdc295829@redhat.com>
 <20250818204533.GV7965@frogsfrogsfrogs>
 <zyfEYJMTkKD5zOCGC1U7KIpJyi-frJE_rYWyR5xVhz1u_VwOJDZm00KBbDZs-fKPTDD-Q7BOfuJrybFyo31WbQ==@protonmail.internalid>
 <85ac8fbf-2d12-4b2e-9bfa-010867a91ecd@redhat.com>
 <22vxocakop5le2flnejcrkuftszwdweqzco4qdf3fbvxsf2a5e@j3ffahfdd2zh>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <22vxocakop5le2flnejcrkuftszwdweqzco4qdf3fbvxsf2a5e@j3ffahfdd2zh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/21/25 7:52 AM, Carlos Maiolino wrote:
> On Thu, Aug 21, 2025 at 07:16:49PM +1000, Donald Douwsma wrote:
>>
>>
>> On 19/8/25 06:45, Darrick J. Wong wrote:
>>> On Mon, Aug 18, 2025 at 03:22:02PM -0500, Eric Sandeen wrote:
>>>> We had a report that a failing scsi disk was oopsing XFS when an xattr
>>>> read encountered a media error. This is because the media error returned
>>>> -ENODATA, which we map in xattr code to -ENOATTR and treat specially.
> 
> scsi_debug can be configured to return a MEDIUM error which if I follow
> the discussion properly, would result in the block layer converting it
> to ENODATA.

Yep that does work though very old scsi_debug modules can't control
which sector returns ENODATA. But for semi-modern scsi_debug it should
work quite well.

-Eric

