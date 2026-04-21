Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92EE126C03
	for <linux-xfs@vger.kernel.org>; Tue, 21 Apr 2026 23:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776815225; cv=none; b=Y0vBl96XVIiFVKgKkUsMZMzRuyEbwO8faUmWeI+p/bVUHKrahBTYjCncj1V8859mF2heJKYKmeKCJj5DlDeborvfPeEOeBMMJK9NlcKX8zkdeISYrnlA6b0xtA2l1DGYiVMbogS1e0FgAE7tIGvKoNmfDGH829o+ZrL9pMz7jXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776815225; c=relaxed/simple;
	bh=ivl1wSI3ZRdR+s4+hiVXM4w8093rghaEoKr0Mz91Ew0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=WfuH8ExSDoQ4HHQcz0wm2ewWO8aRswjMg5ldwnZ5RT/YNhzsMrMNcqAyEHgMrjgvotHGpdK17Fkbm3hfbJlHPbLLz/7RTDsyTel2OjGSvk43hXm7rkLmaL9a1kVRtbLSG+FyOlAeKw/FCf3Iooit1N1CLp43tuT/L9IkeED7mS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=FxMI/9vv; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=L0mnfAp0; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="FxMI/9vv";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="L0mnfAp0"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id C144C1D000F9
	for <linux-xfs@vger.kernel.org>; Tue, 21 Apr 2026 19:47:02 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Tue, 21 Apr 2026 19:47:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1776815222;
	 x=1776901622; bh=SodajmZA5gU/qPwmcWWqBDccPPaA/oDY6cxdsa3IVmE=; b=
	FxMI/9vv8gS9DsKfdkFKsxsgbIM/1VUFDgtVg/4ztmMWwGAbNWQRynJSamsXfMkX
	NdqX5DNaPcqrAP3IRVpgnMjbTv3aMTMXRFkqAs3DU2cv9bxJpXXPFw+ZweKz7f1J
	GdB/jraPEmZlbW/kQZjFRzszC5ebYbAsAwboUwdO4fZhnKJH2ZShXCBURvyDWCc3
	57pUvTv0vhd4yM94aQNYvck2I7LxZ9wul9uQUyButP0NXGaLpOfcplMdXwYqajZ1
	aU3HpC6WUvHOVqly37E+gfHeCvlJpY8oX+AMBbL4fGYOsuG7h4U9QX+nqnc8I+tY
	T0mQDyGwu1NThrd4SJe72A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1776815222; x=1776901622; bh=S
	odajmZA5gU/qPwmcWWqBDccPPaA/oDY6cxdsa3IVmE=; b=L0mnfAp0+kiyGefhz
	UWHKBON8IlMaS20Hhj4vXnuKx/ke7+vHmTsQwousG6Is/5Kay0Fodr+o1aMXFLUy
	XpqoP96dryHj2d6HYD9Doog67XlJFe+lxFsegjHlsJXjbrqrVfFL6Ph5+mkbtJh5
	iHyQPd6W8WFeHIi+/tSFS3LL+JDTEVubrBnNss0KhQ5YZVp/5dWcqVM0Mny0Y8Oc
	xIMJAHcAdcKJjjHBSXDBJv3BMf93bEjdOloxinPC3xVVm2qc6qUIMCWSDc3sLn98
	x4U6/xV7QY6laGOKM2LAzxlK9Iv9F4+d7ZwStzUXEnH6TUEPg+x/dxePCQHAXkPx
	YCdEA==
X-ME-Sender: <xms:dgzoaX1NDYcNUqbiPVuQM7ZrRTbsYkcxXpoWzprbmm3syvvYjM3XUA>
    <xme:dgzoadBgJPClzj5FbW68KuW4WYSIHMgBrLS_Gv2zx65MRYw4skV3hkl598Gt_pFly
    l05vpk5Orm_z-DzT_gZZXuymop7yMPNVYUvyKsO4oZvgyBijss>
X-ME-Received: <xmr:dgzoadiDWgpboJjIq_OjHkUwHyqf6GxSFcxanWWB-zOYyH3X_9nMFQdv8EiWhOhGz6umZZTuF3P03Z4sD-y4LM4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeivdejhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepkfffgggfuffhvfhfjggtgfesthejredttd
    dvjeenucfhrhhomhepgfhrihgtucfurghnuggvvghnuceoshgrnhguvggvnhesshgrnhgu
    vggvnhdrnhgvtheqnecuggftrfgrthhtvghrnhepheefueetgfduteevgfegheelgeeihf
    dvtedvuedtgeekgeejtdegffeukedvkeevnecuffhomhgrihhnpehsrghshhhikhhordgu
    vghvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsh
    grnhguvggvnhesshgrnhguvggvnhdrnhgvthdpnhgspghrtghpthhtohepuddpmhhouggv
    pehsmhhtphhouhhtpdhrtghpthhtoheplhhinhhugidqgihfshesvhhgvghrrdhkvghrnh
    gvlhdrohhrgh
X-ME-Proxy: <xmx:dgzoaR-0k_6x0sWy4Jde88UGz9iqGKzyuPPzsgSPHifb6UmAqA7bHA>
    <xmx:dgzoaZ-AcKh0NbTc9raTdDwkqv8rdCzTRlV8RFJ0j3HFs1I0ZGqeAQ>
    <xmx:dgzoaaCKtAFj-SX6M1NCuXLjeSlFPa-x_3mV6UaCZQ_QZ1Odld_Cag>
    <xmx:dgzoaZzP6YgIoX4zfFAmDLusNCmCGqTrrGYd9C8QjhfmYmRe19oL-w>
    <xmx:dgzoaVFJ6WpmfoUZS4WFHHiSj0AbNbHO5ZIH9wNNBK8j4lsVyut78WAo>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-xfs@vger.kernel.org>; Tue, 21 Apr 2026 19:47:02 -0400 (EDT)
Message-ID: <83e6b930-2705-4719-80cc-71987092f1b7@sandeen.net>
Date: Tue, 21 Apr 2026 18:47:01 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Should we hook up sashiko.dev?
From: Eric Sandeen <sandeen@sandeen.net>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <87c6dc3d-ed23-4ae9-8309-0782ffd9b191@sandeen.net>
Content-Language: en-US
In-Reply-To: <87c6dc3d-ed23-4ae9-8309-0782ffd9b191@sandeen.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/15/26 11:49 AM, Eric Sandeen wrote:
> Hi all - 
> 
> "Sashiko is an agentic Linux kernel code review system. It monitors public mailing lists to thoroughly evaluate proposed Linux kernel changes. The system acts like a team of specialized reviewers covering domains from high-level architecture verification and security audits to low-level resource management and concurrency analysis."
> 
> This is something built by Chris Mason and others, with Google providing the LLM and tokens.
> 
> The website sashiko.dev shows these review results for mailing lists it is subscribed to, so you can browse around and see how it works. I've heard reasonably positive feedback from some who've used it already.
> 
> We could send a PR to request adding linux-xfs, and I think we should try it.

Ok, we're connected: https://sashiko.dev/#/?list=org.kernel.vger.linux-xfs

for now it is not sending any emails; it's web-only. Depending on the
usefulness and accuracy of the reviews, we could consider more than web-only.

I'd like to set up some xfs-specific review prompts, but apparently we need
to be somewhat sparse on that due to token usage for a large set of prompts.

LMK what you think of the review quality!

-Eric
