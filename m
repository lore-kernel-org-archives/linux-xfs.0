Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795628583;
	b=qXwbmSJQnCxU530CbTqP2sRTZIncKsEUtBk6EpH/Ltsw6mh+wWfYtUcuLaCPHToNNCgC
	 PGqEF1AnrSjVdr3zOyEgXj/vjdu4d/v8E6YbiOztQl3roS0P4mwrowCkAkBStZl7lbyTY
	 2fMNIUZQrj9oliThtr475XtbA0aHqxkfWoOf+GhFVgMVjectWNYsqMbFXcnJd/nSUvPJh
	 nY9ooL3Dwx/Fz+T+TrKE+dcafTbMHtTfQO32biT8v6Qd9rkgQ/I/0unJ4wdLlGg2nyXoA
	 TRfjUOxaigvKryfP8d6ztQ7zt9MOknehYPrGWkFdML6LAOVys9v8gmupj0P0FdML0+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795628583;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=idnzLwCRQl0eYBXIDbNRu7HybsB6uaYMcsWff/KAAQ4=;
	b=BalxVcq9yudyOjD2tIMbHS3ATcxw1mDk2eA9ErnLuDWGASciHDJJwgxiyWuIFhwLQHmY
	 7QcxXsFcqnnvATNo5zsURGhgwB+07X7HZnzOnv/vcZ9eiJ8T5+r8UYLG/0THlxrerN+Yh
	 XjvFn4mFsPO89l0CVNDKYEdJfHR4JMUAxO9HPkeImU9zRAuxvyd5C+0FZNFY9WSZyGWc0
	 4h7fcidtGa5h8o2DiOQY8aBcIdhDFXed0nEHKRUxoGnUDlGf9HPcYdpXIC3eWR00NdhpA
	 schI8DApdpXPB0RFTcj65AcJ/7b+8c3GpWjJ+J9VpPR+oA0mpLOQAFK2J2aL17lY2NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=sandeen.net;
	spf=pass smtp.mailfrom=sandeen.net;
	dkim=pass header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm3 header.b=h3SKPmqm;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=gFMcWWhd;
	arc=none smtp.remote-ip=103.168.172.155
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C9F606A31E
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 17:43:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6C9F606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm3 header.b=h3SKPmqm;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=gFMcWWhd
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id CFBE91400395
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 12:43:01 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Wed, 25 Nov 2026 12:43:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1795628581;
	 x=1795714981; bh=idnzLwCRQl0eYBXIDbNRu7HybsB6uaYMcsWff/KAAQ4=; b=
	h3SKPmqmjbJTkcJhdhhBTNAbfZuPf2kpRIbC1jRzDZVrL3xuR16H/X//sa4WGxdL
	Zo+ZomZJQo5lj3JH11+RpEk6W3EpOgphdmNdZeF2lPi+0idmHwEt9t4C/AJoWi6U
	Fjr33Z6JAd/79R7LBAM+k/AYE9R/CkzfBGQ/cZkIj2y8Q2LwOa6stJ2wPk8WW9Sm
	OSeghAk3ODJt9cQfYvlSPpsg75VfxSYsTf1T/P13tTeSpKLkUSeBsurNjYxMTam0
	1WxXFfO2kvcZMHIT3Qazw0HKYQOqDg1rZUz4ubyL2hpPvmxbasTc6b/xSlb0EWP3
	T8IjbN/K2wxknq64iWDGnw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795628581; x=
	1795714981; bh=idnzLwCRQl0eYBXIDbNRu7HybsB6uaYMcsWff/KAAQ4=; b=g
	FMcWWhddKpa89l2KLIPGs5OEZ8wV29WUACjTBfokj/89vVYXzaQh7nk83N3XNY83
	RHQesjf8q3F8LSd4GBRBaRCkkR8IR7oZeeSNO46TYDIfM1ALCk4cmRWILtWH6gxc
	xDhK0BSoJKcYi/qcg56px69EZSnuui9YSU1F4a7jzbxPdrakWtoCIYyr6PIUQuDV
	gSOYPUDcGJHumBv1j+1B8Yzcieo2k40+RRSJohyVWHSWV1Wu7Kr7YtArBJUFJjiG
	Cmu6ufGF4CoOY7eLTUsIl3QY9xiaULK3KXNvhvgymi3v4xaNFG1GgwWUS4vdt2ix
	t1LIL7gqNESRAmcGBSN5w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=sandeen.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795628581; d=sandeen.net;
	mf=PHNhbmRlZW5Ac2FuZGVlbi5uZXQ+;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm3:rsa-sha256:WG+CJLbH5koDxfM4Np7eDJGFOAf3rL7QzKhURz3NDT4jAnT
	ci5JDnxkSzTB7tzlDGRH7tAn5Zs8YR1mZlMulUsoENZcizbFmiUkP8nqjhGE1orp
	d3iNTUET7sOY2pjEIqmHC9pnqNdr99pm67A7daJLN3mWtmlDc6hbVbz2uiScIexl
	dkQrqlRg6eZYf/3Z9Q96gE4n0ONupWZx0qVlUmoc5VfHcWWJVNBFNLlBvOWAj+zx
	w+h0BZ45kV5g8PXJ/VZRDZLshGXguwNwRf+LIPuQQu4hrQ6AitoGWAkqHlTPY155
	XSoQuCnTaxK6Mm1faM+AgPY8ntvog85BjAUm2Fw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:qqw5m46+GY/EVcTf58X8EhItPXHWKN+co1FP7mTNY8g=:h3JcBlI9vqGwlQIdRwvPaVG2gbuTlBcCWHsmB6yxqAY=;
X-ME-Sender: <xms:JR4Ha8gBH-Hzw2mA6bylV4Akq_uWTnzihI05wAEFi3sOF_2G-5m5CQ>
    <xme:JR4Ha75YWuWC1q_dGk-N7wDwcJv8NARQJDYB_9gsfpnW4RGsKrtGr6JxbMPPDXhGk
    -elarUNGUjYzmGdV1B4bts8IJ4Eb-R3qpbKqr05cHX0N9dsIn29gqd5>
X-ME-Received: <xmr:JR4Ha8YPbQmlRVeX63hnWAjVPbCQrHRfnIeoITVIRVGWYPfiFqoXRB7aEv8Bc5_93obfT7IFQsza0AnnqIbJvRp8uRcpLg>
X-ME-Proxy-Cause: dmFkZTEPkgPwSu5cfB5FYhIdBROtYLAlz9X6MxidtmpnI/E4f4x75wF4W2y2iKUqNl56l1
    RS/Bw0BXIsvNpjsZpO1AW89qMuIwrWDABUm9ttm6LAyQd0fFzIgjg9V54UCSXuq7KBNyPG
    vi7K2yj61lrLCdNrBPlH8FsLb1DymNAX0YHYY6G/sQywqzmjkyfOG0dj9eRvyUM6PoL5VG
    807eALQlPh5uvaAu6+Qt5s3kpLESM9T3CTHXjC/IWh7I17JrCiM71Bd5xx59yzB6dPLi98
    mER8vi/WAC5OvHcoppWEWG9HWat5ggaglSRLwtzvKp+f5l8Hn4uzdmreGAey4XCZxrq0i/
    lxZkU6FUKNeBnUyEUZKn8yMcEtmzpyE81mJ4Pkjepnllr5HZXOuUqJlBhM1Dgf5MhjuG7i
    R3X4N7v0RfMMTbhtUVxLBgBO/ovBHXbGHyd593fq7FnKMNzjGyWZNfBnikIhAo7OLCJAuO
    hfy+1guCxMcoY0YRs5KUPkBSA8+2SANdsStWqhE588ieR29j00xlNc1hRj5lAWJiyRilFX
    nrr3xNd5VLo2MZ0on4JxDCOeMReQnL8lQUNq456CxVAx8CpoYAkYr0eZPdUbZFFK83FL4C
    NI0gG64BKn51EIrTJ8FJTZ5Gx0HJyl2cg7UtuKaLpEa1FZcp0u4PDblA1ceQ
X-ME-Proxy: <xmx:JR4Ha47FxMMQzq6_6gDgz4jdWO0LTIfRfCjTbTKU2fVeJ-DqtuiXeA>
    <xmx:JR4Ha3BuQ5x3ocyknIfoKYAOcHJLcd5TBNdgayK1krxbr5_FIW9wlQ>
    <xmx:JR4Ha2f_KhFUEQXDDOYGCoAwLl3YiKLvZtYtCJnX41BTg1TgeXnZ2A>
    <xmx:JR4Ha-KQ8guTGjEeM3_qE0QPYzi66vm57P8-eZlc63b1zIuhTXv_IQ>
    <xmx:JR4Ha_WX3NVCZv9ASDXvucqzya7_THaC1qEs5SaqJqdoajS4RzhSIzWU>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Nov 2026 12:43:00 -0500 (EST)
Message-ID: <34b824e8-21fc-4271-bd60-29cc8b06a292@sandeen.net>
Date: Wed, 25 Nov 2026 11:43:00 -0600
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
Subject: Re: [PATCH] xfs: Remove incorrect use of '&'
To: Alejandro Colomar <alx@kernel.org>, linux-xfs@vger.kernel.org,
 Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>
References: <3783cf39b873890896eb889c8c09edb455559fce.1795626969.git.alx@kernel.org>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <3783cf39b873890896eb889c8c09edb455559fce.1795626969.git.alx@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/25/26 11:16 AM, Alejandro Colomar wrote:
> We want to pass the character array, not a pointer to it.
> 
> This seems an obvious typo, introduced in a48373e7d35a (2026-01-20;
> "xfs: start creating infrastructure for health monitoring").


So,

Fixes: a48373e7d35a ("xfs: start creating infrastructure for health monitoring")
Cc: stable@vger.kernel.org

> Cc: Darrick J. Wong <djwong@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Alejandro Colomar <alx@kernel.org>
> ---
>  fs/xfs/xfs_healthmon.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
> index 2bdd747f1ead..56d19ffb02b3 100644
> --- a/fs/xfs/xfs_healthmon.c
> +++ b/fs/xfs/xfs_healthmon.c
> @@ -1061,7 +1061,7 @@ xfs_healthmon_validate(
>  		return false;
>  	if (hmo->format != XFS_HEALTH_MONITOR_FMT_V0)
>  		return false;
> -	if (memchr_inv(&hmo->pad, 0, sizeof(hmo->pad)))
> +	if (memchr_inv(hmo->pad, 0, sizeof(hmo->pad)))
>  		return false;
>  	return true;
>  }

