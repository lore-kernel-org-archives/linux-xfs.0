Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351EE30566F
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2026 21:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784235672; cv=none; b=Mc+4JHWGpK9MQLztKReo332zSQ7yfgfvQiF8lHl6G2v23+Rn6yTDRSRXqk4CMvK+7CeDP4V+KPQjfJF0BJUaRETNHyi+yiwI1qgkxvuyp4b7jdLRNBf56I/0B/cSRYP8YtrVT0DSA1CnwJfTd6OpxTFmTylbfNW/DNIfEmB7k3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784235672; c=relaxed/simple;
	bh=K0FTUaIHnh0IS9KS3GLogxrNMnLdVhXBanHPy3ZXbzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VVEDqTtB3/ZLPgpKnEc660g1KU9EcA/n53zA57xwR3SYv3gUG9MzUdp91Pm+TqMcxQMPYCv1IYASjrN77zNA0Hzd5zTJ0iP+GNQOsUH08fbYrfV8Ojzr9QqH8MAjr/q0exlPQPTDZQCC/rFokzzGCi2Qqh6SVeKnh6q14UAV8gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com; spf=pass smtp.mailfrom=fastmail.com; dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b=ZThJ51CB; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=MYnU8qUM; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b="ZThJ51CB";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MYnU8qUM"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 4929B140012F;
	Thu, 16 Jul 2026 17:01:10 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 16 Jul 2026 17:01:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1784235670; x=1784322070; bh=UdtOmtaDB3
	Xe9hFWx9LymYTkArckXbVNK8LJ/huIqxY=; b=ZThJ51CBzQLPrZ6dSmsdY89z41
	WIARoYa4rr9aBn5MhB3B/gGXfRWFZeaEhC9FFQOGfy2HVuLmNfilBDI62T4dA68E
	aw1c1J7TOSVPPW2bBs0muBpWi1cBje3sx/g1aKBxLpG+wtO0tzyj/e8EGLeZfSpT
	FD23UhqMqBTz1cSSXQmqiCjq5OFLaeZ4Hp17eCVPh7V9BLL+oXaHtlySgAQRJ8yx
	i5f23MlLh1fiFlyKnwWs84mZ2hp7TOSNsiKaqmsdGdCBZLkiyZi1WphUCQ/x6kjU
	DDZuAduiaE6D5Fb23NV00BlRgc6D5Lz/6D6rKVmAv3RCKOtfJPGF9GgRA+vA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784235670; x=1784322070; bh=UdtOmtaDB3Xe9hFWx9LymYTkArckXbVNK8L
	J/huIqxY=; b=MYnU8qUMU3QiW1CzFnu1avgyKZuE27B4HDRlW4w6iQoiIKhHrJL
	GQIzbYyVauCd1nWwTvFeqMqpWM9L+xr4WvJ0cEne2+waZzP8n9+KGC3MNIUkyVhS
	gznb4VXs1YPIoE6BfC/+EYcn1u0f+XM4xPgCxDhnFnvMd9EQcBGgtreJaIwg0i/Z
	rr12Ftj/PVb73o9HT1CdtjIWmh0PMpnbZbDv4qhswZ3gRnuTPgdYkZ92BhBzSRDk
	0okkfEpNJthsX90nnNU7gAeIbtJX6ZOMZt07pDmM2awmC45OP3mpdTjf6gziu6GB
	m6nvS3DOxCHISDT5UP8ZHj+gF+3CZJlEg3Q==
X-ME-Sender: <xms:lkZZaq1xyfrpZDOxVJNuEtPaJ-fJTNStIuLfG8nEsh9pm_9pBty3tg>
    <xme:lkZZajF09m1xjhxrOIeXjZcHkiTfe_eVuY_KmGxEmy1ZpNP-CilIzGhEPDhb6WF4H
    ZHew-4H0kxrLy4a23xoSnPuXd9aoGqv85Mxoh3ankrN6PHTLjHKuQ>
X-ME-Received: <xmr:lkZZagh1yA19KoSaWrhxk_VlB6xQqZfgqhocLoT6SWEGOjCWVeDTWudJySgabwQQEcnWGzQtP7fDL97BY750hkWVhqYfXYE>
X-ME-Proxy-Cause: dmFkZTEhhYOW5L8oYGCnk/QTM5rkYyZ6y0cW+nQ77xcwcuBzUjtv5GHDhaagaBnX/KpccH
    xmmWQ8dMmWjOYfdfmZoK2Lr2GZ5OxAX2oIzWjwaskrkjeuYe5gvMAp0HITPB5JZ+HlLbRB
    MjOVXHSpffuPUzGAGo9gJQ2b3PWliBzFV/+AJ8n6uZ5hI7ukkyh2UlHlAjtdSUrRQz4P0j
    PasSe5R6+QrBVFpJ1jOWaYAdId+KVHafwx1ZvpmI1IlXAxtrQEupmzzebSGV+JKjiPVcXr
    +IN6DY5E1XM9dcy6zsphKgr5EsDrrchEdzrlSfWQV7kdwggdCtcWxnRPEn9NvZ0aHawMUd
    z9VFDMz5lvm1aqeXG1LWwdNscO62Gh0HujLwXwcLvoQr3J41cXUoxRwF4vV3f+9ZFzZ8mH
    Z5muu7UzFKovufFF5IQqe3V/Mz1+QhHT5kvHyjHGmxI93iCyJDe6DtOJ5RX+9AL3WbaO9q
    voLZ9YZk2Iwo0qLXA7VRbxMczgPoznxFhM7ogxI0zfvGUQvZMcHZck5PyIZNipdZWwQhB6
    iIqSC+7w2X4bd51oIHXm5fj4yJsa2/xonYQ+sliAWm5i/QG8HohRUUgUmr/EjsypDArkF6
    wW28/FDMtFqram/4C/O/SNfGunDJC3rjfb9tExvg0QOAParOh9Xtsjs1ZmwA
X-ME-Proxy: <xmx:lkZZam9NufJKQK-6poc2UZxYCjYaP55-i6mbC-dPOMUBIJKd5cEA_A>
    <xmx:lkZZavovkmIwS6lzMrAdMGbq40-vno-BKaCccxK9pr6bpFzFMCfwFQ>
    <xmx:lkZZat_0aPPFdogTlVKW-9ZtSCVgzyGQruBBbN0HH-lzPCVzVGX62A>
    <xmx:lkZZarVP2eo3eKQ_-2SC-z2ZaHjLHTtwVoReE1kmsUI9KCeQAk5Nww>
    <xmx:lkZZann_chUH3KDiMswuNEqmx-dXh6iRbNYt339uqHY5TS2e9D3WtTpB>
Feedback-ID: i01894241:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 16 Jul 2026 17:01:09 -0400 (EDT)
Date: Thu, 16 Jul 2026 23:01:08 +0200
From: Jan Palus <jpalus@fastmail.com>
To: Reilly Brogan <reilly@reillybrogan.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: xfsprogs: 7.1.0 Build Failure
Message-ID: <allGFtyjrlpjpTuj@pine.grzadka>
References: <CABqFQkar-sMMyZGw4KfAV51x7F65ddF7d8cszQ8iWiprvnKMFQ@mail.gmail.com>
 <alkzIx0H-cn169RI@pine.grzadka>
 <CABqFQka2DQocWjj=9d7ebT-LakGKjN5HGBH=-J3Ph3pEvcjzsA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABqFQka2DQocWjj=9d7ebT-LakGKjN5HGBH=-J3Ph3pEvcjzsA@mail.gmail.com>
User-Agent: NeoMutt/20260616

On 16.07.2026 15:30, Reilly Brogan wrote:
> > Are you 100% positive you're using slibtool? The error above looks very
> > much like coming from GNU Libtool (as well as help message...). I did
> > test slibtool and it actually works for me in similar case which could
> > lead to a conclusion about slibtool incompatibility :).
> 
> I am 100% certain we are using slibtool. On AerynOS `/usr/bin/libtool`
> is a symlink to `slibtool` and slibtool checks to see what it was
> invoked as which perhaps explains why the error message claims to be
> libtool.

Do note it's not /usr/bin/libtool that gets invoked in your output, at
least directly.
