Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.141
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794541052;
	b=ua9uBNg8gdSki7BI5ZUUkH7cl7jJ7fbP4IeTP8BIxQ3KPmE7WnE8XTtSJ4XF1b7mReQI
	 4ogzL4c2RTIGVaFa2H/VGc7jTxhWCoZXWbftMGYWwUJyRiZ2O7v0isk75HLpKyS0DpTw1
	 SAquYqSvkwtqa7FC1pTCWhHkTC4R7WmFChb1DYvd87EP1AoSpMmMsh/QzNZKAN1m4Se9i
	 Km6McO/Qt1KNeRGV8MGe7yIhaD0Z94z5PyQXaG/m0GVQNlb5FesaPtJ+Y6zSicxOlxa7x
	 SoM9HFmUIGAX6AoQgPlHzb79fQkkssrra3ltIcsu/yJOV6265X7idkbAn/kq7qqQyRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794541052;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Py7d8FNg0FKldQid2kmCT1k1h0y+w6BikN4ubeqOTCc=;
	b=DGUAgcLdu88n7r1M7KMhtOKklqu3zCWhIxreBMpuNGeT7Z/Ku3pd2RiZiEvhb/48Dp65
	 2hqsDjCQWUW4o/Cy9I72VQ5/BFTA57iblRbfhNwHTysg3TPfaonKjx1p7pOpUfm1IKDsf
	 J11Qi2UkXLR4GNjHhBigCWt7yTqc5ZypJ+hvA6SLFt/cF4IlUDFqEz6ZPioK0HtNRE9Nn
	 wNuy3qRCTv69ryEvn63e3Mfh44lqjzSpP8XiwYcmIJ+4OHmEdJ6mHowjLn+IwlWehVwM7
	 Dc/Yvk51YpVDqz03g1jRuCvpAshSXQejea/E7WE3qZKvWziluYLVeoFvx79ORsfhB2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=sandeen.net;
	spf=pass smtp.mailfrom=sandeen.net;
	dkim=pass header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm3 header.b=i5pp3j8S;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=AXXtpf7G;
	arc=none smtp.remote-ip=103.168.172.141
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12960606A31C
	for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2026 03:37:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12960606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm3 header.b=i5pp3j8S;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=AXXtpf7G
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.phl.internal (Postfix) with ESMTP id 234291381A8A
	for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2026 22:37:31 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 12 Nov 2026 22:37:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1794541051;
	 x=1794548251; bh=Py7d8FNg0FKldQid2kmCT1k1h0y+w6BikN4ubeqOTCc=; b=
	i5pp3j8SCC3bek22UBuPtrwXH2cZCRcB4KeIOJju5dVwgcrwtU69SVUrvzsspSoI
	4GV+zYIBZ7ljj6PqvsDgeGLAZ2ud6uaDIYuRublt/PfjBc8b+Pqr3fTMbMR7EIln
	hSk+3bTctkWHpOBDOLuVwPHg+LyWy+DOeS7Yyu1NbzTRWJXcpjjBSEbzsH/MzucO
	SGsmVEUD+qRkZ2TDaGoXiNxM+K6xFu2sKYOY+Eb3WfkPRNQ+Vr6eGpUH8BZjznnI
	6EAKng+KjcM/WrztE6hHTiXSwBDT1Dx+5orDx7jnni9En+7sWav8YmRpHTqsXsZ5
	Ayy3jkhoHOV8DXUeaNPSiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794541051; x=1794548251; bh=P
	y7d8FNg0FKldQid2kmCT1k1h0y+w6BikN4ubeqOTCc=; b=AXXtpf7GczZR8eZxP
	/oslybdQK9KcIDjnoX8jLsSc7GSyFK8qE8yYwTeyfiE+GMQIdaa37Y32G3bvW1Fe
	SITsQH8ZzcDrWUfnUEgTS/tqptb4+hathO5ESbTAsqMzBR/5FXbcmbjBJ2s7ANv5
	bik1ItS6/06gYL0bItZGSz2TkKMZ1LoNkDKJWVPZXgoLpnWu/+3B45ZVtJgpoEcz
	r49V+mzTsH9lm5nFW1VSlNv8qWPxk8Wgeu63+8ju+YFdaim1J05S+vOTWseXonhg
	LF85TyNSsh2hU2nCi5rKNnVAHZGkRdZWaC09A0naqHCNH7S0S7OhU26zHdXKRsuo
	TxajQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=sandeen.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794541051; d=sandeen.net;
	mf=PHNhbmRlZW5Ac2FuZGVlbi5uZXQ+;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm3:rsa-sha256:KorQavqBHTtb3uxTAVGAhBFkMgY1RQcIKIi3TEaS7CWkom1
	SobPZAVChHeUV9nHOMXOG4DyQrDBIK6JNrY+fCA/GMl0bdOnEe8t/GNv+S2P3Vjd
	DcEugYnu/tKYKv6SfBkVdM1Xoxu9SE0iWGTpSpy9O1eal9SJC6TNZO4Ahq1ieo0/
	JdbrjpUsGXORErnh9vMu8GMGGpRpSiihXS5bH/1s2S8nfnpgpy9pkKy9Gt0GpSc5
	c19iACJf9LGYyK4zXIaHqbo5hbszMHH9VaONxir9MOXwWENShnbyyncRfle/Yc11
	wLEyeWs9IK0Knz8nGqFcAukFyka0krDnK+NfF7Q==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=content-language,content-transfer-encoding,content-type,date,
	feedback-id,from,in-reply-to,message-id,mime-version,references,
	subject,to,user-agent;
Message-Instance: m=1; h=sha256:52bX4tkP/dNVk/wQ6X9DGJFzJ6ulfJ5m0cpebYfW3G0=:Py7d8FNg0FKldQid2kmCT1k1h0y+w6BikN4ubeqOTCc=;
X-ME-Sender: <xms:-4X2anJ1476oFiJcrl9PtkUlTwj7xO0-WuwAYHLlxOacuGzJGa4t-Q>
    <xme:-4X2aiGCFWohBQJxA_hXljLEV2Qj-DXW2bDWdP9WFeXG679pA1I4w4nDAUF6HW1Q6
    IDw-La725uFEWfyANrVZzod3W_yPbkTYuPGD7rh69VKtwE7TJPU8g>
X-ME-Received: <xmr:-4X2alV5oI40mVQ_aAoViRgFuX2ctNIUFCEXK016CoNM0sAlGup_A-eKBiPg1aQzq4aQKEYudNRKymsuGZItWg>
X-ME-Proxy-Cause: dmFkZTGyTn3A/R9ocCHfac036dSDrjp07IchjnZd+Qc9vdvUSfWfQ9BXIPJCssCtL0SdOo
    qZQvQARQ/HUBq7RA+EMYhw1A+bZxdnJaKBhUptUgteW6dzw2zGZ0UFdqZ0ugvegNfQKuFC
    CytZIaqDsQ2/Dqp4xf8AaEGuxE45DXUbhZXfUnHAWfcEQQYuppJxuuVE1bkFo5bC6gF09w
    l9brcElLlwxv3TBeUqd8/OAd04AqH4rKUr0NBuTi2y8tknLSJs+qaBOXLke2pkSHOmJjFc
    ZUuGWeTK1VBHES4zwWntb+Y4/mYd7A6BZ5jitoLJBL/cPEcO1W45HAJeexNuNt38C1PsA4
    6eFVQ4bPv4dRivQcqMTv1kPHEJFkGvSVl2aVLtOCJCNP0pjgzu9FxvMUxSs/CBPlDMRauG
    xxk0TyXwqM1aPtffiZjSU/gYMzELspN9ZhFBcyKpWQMq+0ozG2Qf/jicn3SkAOigsEVOI/
    OlnVE0ddThzhuPzgwhh+RuSE2dajolhwwHPaDrt6Tjp+XI63xHyZ28gw0pJrmikaBfY7r1
    Zi1CfYAnXceqVlkhcnXcHGLFcg7v7GywIGjVCbaiPl6KQTYDcPXH4ScKC736Rf1VXieOdA
    wtKG7LlgSRAdlBu77fWEBNcR5Lo552CqZCX5PsppZ/B4j9e3xVcqWTl+7G6g
X-ME-Proxy: <xmx:-4X2aliIJ-DJ3aRh-OvvwfZfQW6NgSFfaQRaa-p1ENTn11zk69NZRw>
    <xmx:-4X2auQSmZe544DDDNXYzMgLWYL2pkiJR5FnDzZ0v5E5gcB0MtD8KA>
    <xmx:-4X2agHQAPdhXWfieoEnTXlKtF59bMx5yCjzMSv9Smi4EJME4m7aeQ>
    <xmx:-4X2aul_JJTdJJ7C6e_TeHT8y9gTCf9lDkMFOYFN9VQNQRatoZKl4A>
    <xmx:-4X2arIRwBB2fngDkUzyyTJYxtfTYokhKJZpYusqPv6uLlYtRmjtCbW->
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2026 22:37:30 -0500 (EST)
Message-ID: <8cadd579-1389-4571-8b99-338752cef050@sandeen.net>
Date: Thu, 12 Nov 2026 21:37:30 -0600
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer
 lock
To: linux-xfs@vger.kernel.org
References: <au3wJNbRPXQZG5Op@infradead.org>
 <20261106204026.14530-1-lauri.gates@gmail.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20261106204026.14530-1-lauri.gates@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/6/26 2:40 PM, Lauri Gates wrote:
> On reliability, my tentative answer is that the bit does not need to
> be exact for this use. A clear bit must never be wrong, and it never
> was in my tests, including a survey of my desktop's XFS root (2.0M
> files, flags read with xfs_db -r and matched by inode number). A
> stale set bit costs one FIEMAP, so I would document it as "may have
> shared extents"; since the contract is only "may", clearing it more
> eagerly later would not change the uapi.

FWIW, after:

xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN

we can also leave a gratuitous reflink flag set on a file with no
shared extents, so that's just another case where documenting as
"may have" is better than "has."

-Eric
