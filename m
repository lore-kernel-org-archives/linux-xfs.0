Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458D9246BDE;
	Tue, 14 Oct 2025 15:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760456179; cv=none; b=QhE2vKxxwHYoXohIxsVfCdOkyKUBFFZn0Wnq4JzF6uA2cv2fJTkobqNCg04czJc3qV/yVJhUse6O9YQLyVZA7DF1W41T5d3uIDbvPxxCRurnQSn3AMmZghsyBk8djEMtUVwIegJ4SXc6ejDxdf6JBzGDey6J8cOgxD91Gg9Zpws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760456179; c=relaxed/simple;
	bh=1Q4B2LoqgxHjlKYvfaIrIlwosXhttBzfMwZzefNT4lQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GNSaZLthjjXUNMljWlFGCZN1/AW5sGMmwdhdw8zSCva6uaweuUvE19gvxpoY93rEIxPxRmrllhCxu3y/dHeCyLzq5JZ90DhXzL/pTMT5VhHGeHniTj28o+pq0xmx85HK354qPhDdELCR8F/8htkjKVE3EmGZYTm+abZJUo+deZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=uurpsOuU; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=OoRq+oX2; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="uurpsOuU";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="OoRq+oX2"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 4923914000F7;
	Tue, 14 Oct 2025 11:36:16 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Tue, 14 Oct 2025 11:36:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1760456176;
	 x=1760542576; bh=QVV7mPNppq7WyXnr2ey3xLD8yg4b6Mf/fYN2soYMBG0=; b=
	uurpsOuU4/elzoeAQHYIajbf5MdhSIjVZmCM8SQY/gjPxONPA+Lh4WmTzcRBKmRj
	aj8qYD/U4GrcV4xYprvgGdMKk+qy76btX1fesQEHbn+INt5xwa9rTQ8KwQf2ggQi
	hyziFDHXUoZUONXpjolISFfl1cuxHyDrn9+xBqoiPCYttzHqpYx4RCIy4b/fm9zz
	RXEjEBpqgO79ZdUovroUynDg7g5M8gGHiNPJr0ESUsvsoODqOOXYciEMKgarwPXG
	UzKBI3BlXwpDHbhdbR8xnz8EyXmJoCgN+1VZr3xj9JpwQs19BJ88qUMkG7FgBMhW
	Oy1Jtdap669ucCUnftK6Hw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1760456176; x=
	1760542576; bh=QVV7mPNppq7WyXnr2ey3xLD8yg4b6Mf/fYN2soYMBG0=; b=O
	oRq+oX2PNCMQJBeaXuIVAfELdqRq+JWoyNdA4HOYbRuw51pLdYG1n1g9Jzj7Y3is
	WoQIElTgqABRU2xuOAraYGwwxnOyeQbqtho9CXZvq+hWUruK3LkFOGB2xvC5cLy1
	5quleW7FKMvgUM6ljlGOSb2zfWMu1NXe6aNplWARWPQKnteTpBVS7QieCpmAah9I
	h7I0Eve+0S0ENKAdQ2GN3f8XHOHvQvFqXh1gzuHYNr2qPbYBAFnkruE1WUYXb64Z
	p6wen4pRXO2lNk52GSlC8lBe3dSd2ugAGmC4wuvDezl1vIzhgKVV5dt4hosqPJtm
	bZpCc+Aws5+259pKw9WyA==
X-ME-Sender: <xms:723uaEXcf_MUA3pdV6MDQ2aUSdPE8n1WNW5FQ_QCcey6WAAeb4RJ3Q>
    <xme:723uaGbVEkyQjYavpH5xNfpWQtBCTzAoGKnsks9MbGCrGUGQfmWUhiMshRuCZBReb
    O0nOB7Ilp41UQBY6PQQ0MMwqbBshpgW6Wb9juCtJ4HJlHVmuSoe-g>
X-ME-Received: <xmr:723uaC22Byv9BLqOZpPruocv_6XcBeyY4qWuT45_iU-LzkwVMEfZiDQklCY5Jdui8OaODKxOTG-aV9OtsSnoqiw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduvddtleduucetufdoteggodetrf
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
X-ME-Proxy: <xmx:723uaAhNB4ZkvXduwtrNmyw7Zwwua5nHQtVjXkQ3XlIiVA_xSqlw9w>
    <xmx:723uaOYPnBtMnYjIQ9Vk5lE381sOAIBtc8OLC_3slDGFq5ufJD_yiQ>
    <xmx:723uaIRP8C6tm-WNM0QqYCdyhLGuh4k9mzBokC6S21M3ZnfQV-05KA>
    <xmx:723uaBQGhUzeKCHUWlnihsCW6-XNYZOf0RWi-NPCpc6O-hFiofYBAw>
    <xmx:8G3uaP-X1ko-WFjG4e43ESR4irBvPY6JGdCvZRKdL2WV-U7PWtvTIjoz>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Oct 2025 11:36:15 -0400 (EDT)
Message-ID: <f41be58e-071b-4179-a0e2-7fbbef1e534e@sandeen.net>
Date: Tue, 14 Oct 2025 10:36:14 -0500
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
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20251014023228.GU6188@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/13/25 9:32 PM, Darrick J. Wong wrote:
>> This was 6.17. The backing file get the nonrotational/concurrency treatment
>> but the loop device does. This probably says more about the xfsprogs test
>> (ddev_is_solidstate) than the kernel.
>>
>> ioctl(3, BLKROTATIONAL, 0x7ffd9d48f696) = -1 ENOTTY (Inappropriate ioctl for device)
>>
>> fails, so ddev_is_solidstate returns false. For the loop dev, BLKROTATIONAL
>> says rotational == 0 so we get true for solidstate.
>>
>> But TBH this might be the right answer for mkfsing a file directly, as it is
>> likely an image destined for another machine.
>>
>> Perhaps ddev_is_solidstate() should default to "not solidstate" for regular
>> files /and/ loopback devices if possible?
> It's *possible*, but why would mkfs ignore what the kernel tells us?

Because for one, it's not reliable or consistent. A loop device and its backing
file are on the same storage, of course. We get different answers when we try to
query one vs the other via the ioctl, currently.

And for two, the actual access patterns and behavior or writing to a loopback
file aren't really the same as either flavor of block device any way, right?

> Suppose you're creating an image file on a filesystem sitting on a SSD
> with the intent of deploying the image in a mostly non-rotational
> environment.  Now those people don't get any of the SSD optimizations
> even though the creator had an SSD

Now suppose you're creating it for deployment on rotating storage, instead.

My point is if the admin is making an image file, mkfs.xfs has absolutely
no idea where that image will be deployed. The administrator might, and 
could explicitly set parameters as needed based on that knowledge.

...

>>> What I tell our internal customers is:
>>>
>>> 1. Defer formatting until deployment whenever possible so that mkfs can
>>> optimize the filesystem for the storage and machine it actually gets.
>>>
>>> 2. If you can't do that, then try to make the image creator machine
>>> match the deployment hardware as much as possible in terms of
>>> rotationality and CPU count.

>> I just don't think that's practical in real life when you're creating a
>> generic OS image for wide distribution into unknown environments.
> Uhhh well I exist in real life too.

Of course...?

I read #2 as "make sure the system you run mkfs on has the same CPU count
as any system you'll deploy that image on" and that's not possible for
a generic image destined for wide deployment into varied environments.

rotationality is pretty trivial and is almost always "not rotational" so
that's not really my major concern. My concern is how CPU count affects
geometry now, by default, once nonrotationality has been determined.

For example if there's some fleet of machines used to produce
an OS and its images, the images may vary depending on which build machine
the image build task lands on unless they all have exactly the same CPU
count. Or say you build for ppc64, aarch64, and x86_64. By default, you're
almost guaranteed to get different fs geometry for each. I just think that's
odd and unexpected. (I understand that it can be overridden but this is
nothing anyone likely expects to be necessary.)

I agree that it makes sense to optimize for nonrotationality more than we
have in the past, by default, for image files. I totally get your point about
how 4 AGs is an optimization for the old world.

So I think my rambling boils down to a few things:

1) mkfsing a file-backed image should be consistent whether you access
   it through a loop device or you open the file directly. That's not
   currently the case.

2) When you are a mkfsing a file-backed image instead of a block device,
   that's a big hint that the filesystem is destined for use on other
   machines, about which mkfs.xfs knows nothing.

3) To meet in the middle, rather than falling back to the old rotational
   behavior of 4 AGs for image files, maybe a new image-file-specific
   heuristic of "more AGs than before, but not scaled by local CPU count"
   would be reasonable. This would make image file generation yield
   consistent and repeatable geometries, by default.

-Eric
