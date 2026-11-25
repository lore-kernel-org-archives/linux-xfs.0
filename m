Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.146
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620071;
	b=JsFLGTganWG4gBks8R6P0nT/qdVt8atOrtXQ3meXNuo83PYi9iwRdVhAgx6WOSSreNqr
	 mxhb8vBXM7pvDNtWrjarLath9N/zrWCpQt4UY5xKOq9b2RQnLz6VG5y4QetzZBw0MYcvk
	 8+JW2NC5sRBDJr5eInrRePMAezVD1mahKh6UXUFYo6enmzp2L0UVrk+S4Bzrec5duLYsH
	 LwwG8kT02PW4l78kZe+hv2s1FASMacTzyNTG3d6ZU84644ZqRHFxv2o0hfcYyGhf5njSD
	 FVc+5+k5ZxCl1Xs/EsVSl5Ci//ZuXIEppXkPuxYMG9/AMy+6mqkSxkC2c2kEmWUom6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620071;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=saRZGQGhfWHGmKWWrLKO3bt7L/wFPUBWelVeyYSFUSQ=;
	b=LSdPIfNIY8Hd4XZ9vZrKBHBLGJ27uQIiah7URtMN/bVCarhlSNrInTcRytH6pDNplpFk
	 nbS9xxUPUwUFUr6UTykhzBHfE3deRrpBVZ53NCK7BeVDbrz2O3e3fcCtg2Zn9oEiI68Gt
	 Ga8tU9mQXIc0AbklAfoktdWTbruKmmttGpSPCyePqBqTRB1SK+nTvYpJSDWubMcS+a1JA
	 9FC7R9cw1ZBry+TjJgZdTb7A150NibJ2jaqCPATktlojwR03Xjs3gshqmUvwCFb7RF7ez
	 sP9aX2hSwUxaUcU66HG9PcUv6re3IeeyUK0TmhcmNVFl2QqxZiSz5zXMmDBLZgDK1cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=sandeen.net;
	spf=pass smtp.mailfrom=sandeen.net;
	dkim=pass header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm3 header.b=d1wIRIVD;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=UOCjdAFs;
	arc=none smtp.remote-ip=103.168.172.146
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BBC606A31E
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 15:21:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83BBC606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm3 header.b=d1wIRIVD;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=UOCjdAFs
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id B9265EC0190
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 10:21:09 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 25 Nov 2026 10:21:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1795620069;
	 x=1795706469; bh=saRZGQGhfWHGmKWWrLKO3bt7L/wFPUBWelVeyYSFUSQ=; b=
	d1wIRIVDZX0+csf/7zNKUJ79FiB/kOl4YSey89uPAJ45ywmugyatnX+G8WVwwCef
	ITPlABRsdMshtyDzw1MdoS0hWAomKctjzyW6IRVQzImjJAIQ2rA7tysD8mW3wprG
	hn/ZVgYnpt6efe17AWMkhNBY11qhQMQCeEIYEYIdWNRNkIAijNmZvFlhBXp9N2+J
	dmasSFZ/mXpnYM3ddGFrxVHERpTaFTL6HASIQ3nmxbDoG5PKYIppBQEXCxeQbK0V
	EQvKKlgAcp/3/ZrIAQEhFApigC/L94iOVCBumjVZ6vMto+vIZdkpsl9Mw/Nos8rc
	tjotSs94Znwxhfj4f5ezRw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1795620069; x=1795706469; bh=s
	aRZGQGhfWHGmKWWrLKO3bt7L/wFPUBWelVeyYSFUSQ=; b=UOCjdAFsktsPDky69
	mPkJqwULOcBKsSeIJF6ARVGpoCWXCIHCTHhz9u0qtfnyH/CcIFCmWVeY/qnTxUke
	AB83vG4Jo4PfLodNophtxOraJ4YNvcrfsvQP5lwQ+7aTG/jg2qqWI4vWp+ON8KgF
	sPWKJFUJx8aAYUJyQIl4aX5CSjmbXZYKm6JTexZRVxf5ImIX32ZecHgurD3T/iGh
	Sz/Iqmkl1sVuie4whgfWu48crpfy4tAv3ik4ZhyHmd3eWbCt+DZbYuqF18t+J2lX
	PG8Mc2o8rXlu2A0nyAYzvI2YH83vEeqdxjqbp0ljPsQ7TqkUd66iuocHHGiHDgEx
	Islmw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=sandeen.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795620069; d=sandeen.net;
	mf=PHNhbmRlZW5Ac2FuZGVlbi5uZXQ+;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm3:rsa-sha256:NZtoApGjU2AbYdxpJ1y9kgvhwieR4E+bchEQmdiNMlvT4Fg
	KJnaWcIe0+cr5+kvaQ+6XGrK4GKBZBL9ciPQSciAGyMj6pu2laIrXWWh9M0asj2G
	W8izm8AHaQ+UOnwLlelGuI8fNcYTro0lkIUDG4qzA2ve/OFInhCRLSqLK4UwmUvr
	7J0CEvrY9+iNlQKV78ox15Lo58iYIXXl9ZL96HnqH3B1maRQwCGhJnmHMUAnqNbl
	J3Y/KyOkpW5k/ybwiwgqRmU2bftILYt2EBDRAluwXLCcLLWsD9AsDhEuWIo0PQH0
	L+I01FRrSJS9R7MwqZYDvUwobNn6NQlaNwFTKeA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=content-language,content-transfer-encoding,content-type,date,
	feedback-id,from,in-reply-to,message-id,mime-version,references,
	subject,to,user-agent;
Message-Instance: m=1; h=sha256:T1cOvf/dj1c+KBlA+6Z4gEGWW1btivCjWyixhoWeT3I=:D0kUNpvIUAtt6NzUY91uqy9dfvzv7M2DuQrjg26dP+c=;
X-ME-Sender: <xms:5fwGazBIu6JFhbQH9-bf1QOtDQWXnICPRmeUndgG2HJC4Ub2xMuH-A>
    <xme:5fwGawfxeF9cAbYTKGdGaeKIhbb3Q2MR9bssZ6y8azH5SceNX_JfFHQhFlXucjXMb
    Ic_R38thkU0-xwrDOuzL98nKc-8B-4w4v2COTylUQ1T_1iqELtnROM>
X-ME-Received: <xmr:5fwGa0NVoQ9vMaNx9JdIi8QkGZwUff3rkWzRxI1g5UFkp8YfT8Z5e8u0wAj5HAUCEop1BUfOLxuEoXJfaKbU7GJpcVkzDg>
X-ME-Proxy-Cause: dmFkZTFZ2O8nU911/4QXBP3akVMyFnEUEzQpbwjEIPspsdYmhtUeARZ5iVqw1XNVJUbhOu
    qEWNdCQP+bC8VWFUtGvlUmcVzL4AVGchWvvlG2iq8T40Wl19XtBSjjTLG+22Dy80k+bptf
    oYNQcig05REQGoCznWcLDb/Vchrj0GLZNtELxsA9H4hL84d/adEtFH8CwjW0fuSiVPqsA9
    oQvZhCqFV20oujgPS2BYoZurx8+NP4JDz5m5BmtgmkWx9low6RtIsy0F0cJ0Hal0fcjW6O
    57dgg8liVY5E53qVUWl32aacDYuUrWzOmyB8/iPLclFaYSykvNheJro63F8fHO3hwonCgv
    jSkvUqplpbm4dF7l9jUicIYYcp9x5Kl1wUzNKaEkAuDwsCLXLLyiPLaeRtpCNBCOgJ/4ih
    EcOKGa+iwYLzvvdYzJLfQo1XL8yCU4BqVA0/tH+io/GzMf8PS2VStuUyJzKpgpFvOPst7O
    EgZ4+t6l5G5mcN3GT+7QU1HlttDGFpJXDqcWfqx7kw04QRwHQNERw/wUFPsAoihML+pLai
    s2+Bj5d+D09nSkijPaz1UFkE5cv3DZYxgpdG3UW1KIBhoEyuPXclaoz1ZJctzUM8n7XQJu
    ZFDCkqmynTULWf4PSlSKuQJvUkw71+4htqBEBC3+u7QsoyxH65y38qlkLE+w
X-ME-Proxy: <xmx:5fwGa64AhbYZQBC-sutj7zZChW5lEBJseqkJjaeDuf9cOuy4rrB13A>
    <xmx:5fwGa4KTylrWCoGR_FHt5D_y6GpQJGEsKb5lipWat_F3yg3iFnLQrw>
    <xmx:5fwGa0eHSiI0tPGTz-1Z2fAg4eRM2l_RwTFyLwmljPdYgKdCjLpFyQ>
    <xmx:5fwGa7dsuOXHQTgXrFQs66QH0BfTVtxC87PjZGI4SvTAE32RSR70Yw>
    <xmx:5fwGa6DXklIundhmHf2KDdFMhURY2XZ7IUfTjnLGqPxKmlxA2jHE_ZNw>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 10:21:09 -0500 (EST)
Message-ID: <1bd0e8e7-68da-4927-9c0a-c73a51a5acf0@sandeen.net>
Date: Wed, 25 Nov 2026 09:21:08 -0600
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
Subject: Re: [PATCH] xfs: pass proper leaf argument from
 xfs_rtrefcountbt_broot_realloc()
To: linux-xfs@vger.kernel.org
References: <20261124213906.2130272-1-sandeen@redhat.com>
 <awaCUBjzpjuvUQgN@infradead.org>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <awaCUBjzpjuvUQgN@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/25/26 12:38 AM, Christoph Hellwig wrote:
> On Tue, Nov 24, 2026 at 03:39:06PM -0600, Eric Sandeen wrote:
>> xfs_rtrefcountbt_maxrecs() takes a third boolean "leaf" argument, but
>> the caller in xfs_rtrefcountbt_broot_realloc() passes level directly,
>> rather than "level == 0" as is done correctly in
>> xfs_rtrefcountbt_get_minrecs and xfs_rtrefcountbt_get_maxrecs.
> 
> So we basically get the wrong maxrecs here.  I assume you found this
> by code inspection and not by testing?
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Yes. (with the help of an LLM doing other review)

There are actually other cases where we got a factor of two wrong in this
code when it was copied in, and some of it affects disk format. I need
to grok that a bit better and can send a patch, but the patch will probably
just be "document it in a comment" because trying to change the disk
format now is probably not worth it.

(tl;dr, the problem splits root nodes too soon due to the error, IIRC.)

-Eric
