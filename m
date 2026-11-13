Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.143
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794612873;
	b=mui6KsihFHe1YrIio8mVEgTg89YkWE2C24g8aDaUAryxJ+KUnegEWgVrA7hTT4AaSSOn
	 ChetVWuLe+6kEbfhrCm8iSt7W6Fx3iwU/9OFpzHrFcOq/PSKRgygUT8Ke/EJ4oEmGEMn7
	 9kZVxj6pADnQu0PIBfYcCZzpVro9w3NA/CM5cX9WVCNXvnIfe8MMnzctov2+R/hBfmOzl
	 RNX4gfMiVMbHVEuN4SLpAV7P6G1n9UMpFSnJgQG2VN2dpZasSP60vPOfX7IFLi4HIKNEw
	 VDJNKkssaVGQGmGjgnPItHLRiwKHURJRnQzAFg5r9No5KxYdfvKsQ96NtT/Y6rXbFAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794612873;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 References:Content-Language:Cc:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Oyo9zSeCz0Myv6TYufW01VNQ8oOw04Y12Sfo2pHArLY=;
	b=y2dpKzwj9PKy7vhGu+OQifDJMEWFqiSdtGlY3P8dwaYpnofv6DZcChBAWWF0l1OL9s6l
	 1ACpwPItwAjJeIa6C8ofa4K0CslDUKo+HaWX4vDrjlUBmZ7kx1Ijh5gA655aV83FOx9lp
	 WENXlzNP3tdk6vgscHXrYQIXyysy3PuH15yQLmBox8ndeRW0J8YpvKHb4kNoqBto2v+e/
	 FL4rq1DYaVsOO/XvRQCzJzShjO9mKPYOJnr8V8+0LZu/7zANsFS/3LACP10bnax+LwKQH
	 VIbAuJjiIB6osV5xsLyfFQvmqnfejkQUA0aZLNZHDYC3Suix/nALodC0mhrtjkeGNVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=sandeen.net;
	spf=pass smtp.mailfrom=sandeen.net;
	dkim=pass header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm3 header.b=c3+QhFii;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=UeXbK9LD;
	arc=none smtp.remote-ip=103.168.172.143
Received: from flow-a8-smtp.messagingengine.com (flow-a8-smtp.messagingengine.com [103.168.172.143])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B31E606A337
	for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2026 23:34:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B31E606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm3 header.b=c3+QhFii;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=UeXbK9LD
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailflow.phl.internal (Postfix) with ESMTP id 472601381930
	for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2026 18:34:32 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Fri, 13 Nov 2026 18:34:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1794612872;
	 x=1794620072; bh=Oyo9zSeCz0Myv6TYufW01VNQ8oOw04Y12Sfo2pHArLY=; b=
	c3+QhFiiD2du/i7Adsd+1rxWRrXxCi+0UL4uOjUmcz0GmxGKdeYSCaO5QI0JBr+5
	3n3HbtsF4zdBtwva611EofPD1VGNDX1xL1QLgDBbI9udw05tDFyopzxR3MMTqsA+
	S7f+2rK/5fS1ihqpERbWlkLj91+846830MtUa+XNNRkjFCMVWRGOYSXg+zVEHckK
	dXl6JSObhJbB/VHfFDZwCUNoFeiNWyMh0vKC6PDNHp8TBN9uz61ghOAnSKH0fIGy
	gwwhI7x53Dd/IrlxYojcQvGPcowxfE86EgSLD/XrM+9kYdCNtJ429CGvEb280Ori
	qs9E8UkOtA9hviSXRDSlBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794612872; x=
	1794620072; bh=Oyo9zSeCz0Myv6TYufW01VNQ8oOw04Y12Sfo2pHArLY=; b=U
	eXbK9LDlwwUGJKXUMR3NwCjzkRHOeuk92N6pzZmjuMZe5d9iK7Hw806j7ASqihFg
	1G8i4gWYHLAntnnLkNTdmeBc5f2mX3XdT4BYVOXa9GYu5jcRzhCzr5HFYbBtzMJN
	Eh1WUzqDjz04FV+pu81sLi+fNvtDPkVWg/fd/v9FBdM40MDz9pL8uJjLxHe7uelu
	3qvQAuuu0UtELNwijTdY3yIEgXJ9VKmhaZJK7FC3qP43AF3ES2oHp3EPkhMA/UbR
	ATCznoULNpRFfacq9L6PeEnwS3AX2DEtkDWrboRNAP3aINvb9cnvGsIF1XNBeqvy
	HX7Z/bmfZ96n648DPDmcA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=sandeen.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794612872; d=sandeen.net;
	mf=PHNhbmRlZW5Ac2FuZGVlbi5uZXQ+;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm3:rsa-sha256:l5svp3Q9usohVonpIhgV9AYKAnjcgAESaC72PacUKNtsNes
	fyq4LxNNSrmwPGBvCctLRB4DtENikD51+42Puh35UZqQSUqPP9kub25Qgux9D3eX
	+3cheq/aWt1n6205gPyv2aRLsI6IIKNzI9Waxz+mOQszKNZhUODlVtV6t/batDSa
	MkxNM8eJIA1MJqG9i/S6yGtIAejO5udIHYWjWFoQbWuYU8jh7/sfD/Z8pIT6nNeG
	NLXWglq4g5NOnkRYwHkYeH27jWPLPLI5YFhvVtRiZoMxVltGkQp0uMAweINmcUIA
	gkRw5CKz21ty0GaihPua1HqQcGXjbwcNVYw8P/g==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:OphFE05ZLwyFknARXcy1QMF1ZZ8O9yFpQQu2UMupfKQ=:FVYzbl8027YsGxZHlVMUPdw8AvYGZb6r6kRakL4Ksh8=;
X-ME-Sender: <xms:h573ajWv66KdHNavudGcFOTTLJUxcA9y2y8l4hb-wXHdsFSmdoLKDQ>
    <xme:h573apiAecA7JkHrpSz7TCJXsZKXas8E5VPDW0hIz5zq-RZM39iIE_Tt_I9AEDVlM
    -VPfyVj0xaMKR9RinMyyzQECAKreQGwSGxJ6w67VUJPlwzVgv96uOo>
X-ME-Received: <xmr:h573am_OKmOIX61LL9ccTur3iC-MTHyVxqtK8rfqXe8KislcsA3l3nrkeanIHmQ_g_AjzoecND6AQnsr6rQ3-A>
X-ME-Proxy-Cause: dmFkZTFooXMj1Sm8N/o5ldSqFRpcJhNSKWZD+Ctfg3Q5FJGE+wD7KHZV6H7PZ77IM9yp4n
    Jf3BHYEmTjk+l9XSX9RI2gIBg9AF6UDJeYecnNVNitWZ8y2kOwSIMCy0ekB1R9LjADAIVY
    SsgF82WyXCS44jIibTS1Y2COwmjLZebS3kF8bukHxoHj6whda8CK6TXn4eulRjNCi63Uez
    K6e+h+RG0fgprkIPtzFvfsbv3i4MkrGNcC5dcCNgD9tSh4uYiOjluzjgiYW6BC3DRHolSO
    CXXB2w3LrGN720XHc7/SZG1MZbZ9fdAPXu0hVESK8y+ZHxqi/84r9y5ZcAu6l/awxUbPgq
    ZK4j94gezMFRGAVIdHIN5VtuqFJSJqiSpYwz9vHZB+O640b43e76jadSItXR+Td1K30vzL
    4driKrqEtifm3HAnlEWHtv0ohQL6nk74Yi8libAt0u/WcqMzdaQDBUOZs1abjwCPeA6NUD
    /Jc1Z8XivTlca8ix4fnbiSYn4pCx3HquvrgxWRscs/07vfEeMeDVUMWo/U+ZhZbtH1HEnA
    +5FEcxfFsYJUUFbML1YmsJvD2K93UVNtWkXAnzhUe5fSztapucNNsYoMJkUVKIgSvQNYlF
    cNV5BgRKllfc5qMS/zQtNLsIgnTPSg/gWOD5Z761P3Tf96XRNyP/cdV6R4eQ
X-ME-Proxy: <xmx:h573arCKndxkf80lTymPbJCmP420WbLw9mel1kJWcgqblDxU5L2jNA>
    <xmx:h573arLfgs-vgmV8RSnBQYaSeDkLAjss8uZm2Hjwmb9zrMy03Rcmjg>
    <xmx:h573amkinTUgV6E1OX9FLRR_avJGx4PH_LQoxSTwnz72qYi7sgxGUQ>
    <xmx:h573ahEFHPzK1SHqnUDvraoBaoCu7YIiTgfDXeAkhdDKj476bSPVEQ>
    <xmx:iJ73al7ow8K6_lOPw8XjDciWOj0MpshYNp3kj3Fa9_EjXgJS4SFHtkj7>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Nov 2026 18:34:30 -0500 (EST)
Message-ID: <488fe62a-05ba-415f-babc-8b9a7190c228@sandeen.net>
Date: Fri, 13 Nov 2026 17:34:30 -0600
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
Subject: Re: xfs: data races on xfs_params and xfs_globals tunables
To: linux-xfs@vger.kernel.org
References: <4c7f9772.192e1.1a17d5c2ed5.Coremail.xuhx@hust.edu.cn>
 <2026102727-data-sequel-ce41@gregkh>
 <5495c57c.263aa.1a1d4f38fde.Coremail.xuhx@hust.edu.cn>
Content-Language: en-US
Cc: xuhx@hust.edu.cn
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <5495c57c.263aa.1a1d4f38fde.Coremail.xuhx@hust.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/13/26 6:48 AM, 徐晗翔 wrote:
> The global XFS tunables in xfs_params and xfs_globals are written through
> sysctl/sysfs handlers and read on normal filesystem paths with no common
> lock and without a consistent READ_ONCE()/WRITE_ONCE() protocol.  For the
> most concrete case, _xfs_alert_tag() reads xfs_panic_mask twice:
> 
>     if (xfs_panic_mask && (xfs_panic_mask & panic_tag)) {
>             xfs_alert(mp, "Transforming an alert into a BUG.");
>             do_panic = 1;
>     }
> 
> A concurrent write to /proc/sys/fs/xfs/panic_mask can change the value
> between the two loads, so the first test can see a non-zero mask and the
> second a zero (or a different) mask.  The result is either a missed
> panic or a panic the administrator had just disabled.  The same pattern
> exists for xfs_error_level and for the timer/rotorstep/inherit knobs; the
> DEBUG-only xfs_globals sysfs attributes have the same plain-read/plain-
> write pairing.  This is a policy/diagnostic data race, not memory
> corruption, and I am reporting it separately from the stats_clear UAF.

Thanks. While I think this is correct, it's likely extremely difficult to
hit - I think we'd need to be setting and reading and panicing all in
the same moment, for this to matter. And even then, there's no very bad
outcome.

So it's maybe worth fixing, but I don't think this is a serious real-world
flaw. Feel free to correct me if I'm missing something.

(I'll look at the others too, I think it's probably the same situation,
technically racy but probably not an issue in practice.)

The stats handler UAF problem looks definitely worth fixing though, I'll
look into sending a patch on that for sure.

Thanks!

-Eric


