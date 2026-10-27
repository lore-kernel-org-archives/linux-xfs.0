Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.158
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793115113;
	b=bChl5NFvB4rYDlmbbAv0Z5cz6/fKUKlATSqe+7isuE0Km4bWrK806T6YLF4HZKQ4zd/I
	 oSIEJE90yU7Xf6QVdLjdaMKH51SS71LL/pXSyN+ErrIw4o5jfQ78uAdaWHtRoKwDYjRVP
	 osp+0Sn9NTzfwJTHMEJucJ/mfJdYX75y9KRBautskmJRlhSjPz9ShYMvpo9Qpm+eAiL1C
	 UbxJjqmnp+BE0edw0Klh+W1XYawadCtAX7iRnWLc6EBDKfT63uzSM55AbmsD+VYu6sTeu
	 i0eTiH2ZZTl2X+xTon1SC+EQIbb/OSZ1zDA+qotfIrGt4Ld/5x2NyL4rzM31ZacZleA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793115113;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=445HZ65Cmo6dnaIDiH6ALuEdRGcSUunp8CKbG8INBYI=;
	b=vh000H63THV6cR4UYNvP7DqmIhqUSioGRFiJDKgDjf8kvtpow5qIW7TenhqFw8a8zC7F
	 2YXww1lOtaM/OBWhEdi+hg9l1SyQraIMHLRDwwsIO+HGqJdo+dka41QgTXqQpRbj8Uyd6
	 8PWLuUxFVZ2XbVjHeuvMjdd/riHystbtVUn5RNZ1ml3365vQSWJZT272n5IKMdl7dSz9R
	 ijmrkjPgCY7nqCgGdUY3rl3xtCddAK5DQs5+jG/y/matZ8QY80qHpPSlhYVcuqs1XrHj2
	 LeNCfE1cNZro78uHl5OMSGSNNUkhE/lCothORUVFiMSA9P2aD2KCaZUhm0JEneMiDKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=sandeen.net;
	spf=pass smtp.mailfrom=sandeen.net;
	dkim=pass header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm2 header.b="xo/iKtww";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=PPsml3RN;
	arc=none smtp.remote-ip=103.168.172.158
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD453606A31A
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 15:31:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD453606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm2 header.b=xo/iKtww;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=PPsml3RN
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 23D4C14000B0
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 11:31:52 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Tue, 27 Oct 2026 11:31:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1793115112;
	 x=1793201512; bh=445HZ65Cmo6dnaIDiH6ALuEdRGcSUunp8CKbG8INBYI=; b=
	xo/iKtwwlb4A0d35B9c/FK/71pK7OCy+xoGwfq8e3kKuYCqbuVpAZbaoOFc+gtzP
	dSiywiZ/hrEu+ESwwi3APq220/0pFXUFUqZrUaBnto12q0ns9CYmoNkSHB7XG9jO
	hlXRmuG+ue5ZjP4cUMyLFS8glu3XJ1VDche5xDWwkPpTKWaPGKKTkjkbPjTiRpGF
	/uVC531/ETAaLxOXCmxvHerRvo9vD2/LRWc8pHTThJwkU1pD0sDNiAihLEKNhZCv
	3jBdH7A2TTy3PhErkuX6x1zpTVA9ObAJAIGnaF2Mz9qur8VkWLAwQSnkowstRb8A
	bFq6WwNxbWhmWTpC4Uzu1A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1793115112; x=1793201512; bh=4
	45HZ65Cmo6dnaIDiH6ALuEdRGcSUunp8CKbG8INBYI=; b=PPsml3RNR7CmqvmYQ
	EVw2WioIbTTIV7Ql6b3o8JJuEpcVIlKbaXBuZ136TWbs2TmhYTE3hV3ji/qTzAh1
	Akny3aXZyyWOrxC/+jyT4hG0SUxjR2QW/A5fo4UY0a6MAB9y/3G9X5rLtabc7vus
	ISHpwm3F6PLq9jQCO5UjIosvrpnhUTTIYNZBNetJHMz6PFiOYytnmjqxh8fGi3YD
	6UPH5yJVeybcq2FDMRjgY1KeUDE9EZKTuUS7d77Khd+cXcnelK95VADaGsw4PsC4
	jjo8+YheRAZiETRXesMYXTSeraF1ogiyvTuEj0wjsW/Q/wFKOR9rkvEANdfZSKqg
	e+RVQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=sandeen.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793115112; d=sandeen.net;
	mf=PHNhbmRlZW5Ac2FuZGVlbi5uZXQ+;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm2:rsa-sha256:QfN0QIpjnhWuZD5W4U48Bnej+TRJQi1uuJMQ8Ldovf0pvuG
	HLnLGgnyXAdI4yQ0mKm58Shp2RRRfGAPjBDvz19Dr5JuUEmcHWYsObCW+dk9/LTU
	Inj95RNkub3NvnePbxx4TndOsykrGuVBPOs5TvKzzLBTh5trRSv4ruYFG5q5iJHv
	n6QOUBTRM4i9lr0FqNVOkdYS7C18+1ng4oX9sEgv7ar7RcEbogsLLi0rlRC9IEWL
	w134OREjZMfpwjxzHwE7PboOAQPFRAz1mY+Al9l1Ecp0U+S5Pj31SN4gQ6Korktr
	d/0u4ciTqf3DTdUrgsXdia+sL701oUmCo3NePjw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=content-language,content-transfer-encoding,content-type,date,
	feedback-id,from,in-reply-to,message-id,mime-version,references,
	subject,to,user-agent;
Message-Instance: m=1; h=sha256:rQ0xL1Du4A4fvT/EHo4rUmRqAF2STEU0OHgxt8ups2E=:av79xjZAHVY152oMrfcAfXprlVJpGlDIML4x84UuuKo=;
X-ME-Sender: <xms:58PgavbJQ1zVe87Y2PIBniKo1O3t2DG5tIt30T5QRQpZhpw3cQOCUg>
    <xme:58PgalToRM5KXzn0nxqWe0cr1EI5NdYdia8LDFcqe8JVGEIxu3LW5Np6shh3Oa1os
    ZWvLRwQ1z1GVoceKqnbMpak6VA27tgTMwnHs-e9TSHVmaC89tV_ezba>
X-ME-Received: <xmr:58PgaqT2lGSkq10DjTgCnh-fxwsVbmzGkUS54td3rIAX9g53e9yj6U3OJhKSZJW-QU4hyj5EU6zOSXuQduBPHM9qo7_r6A>
X-ME-Proxy-Cause: dmFkZTFZWiZJ2VY4CXjmjg8ExQ7sht3gOse05ljBVtRhoTSjOrL+uA8sL6vuWx2jseK+jh
    4i1Iix8y8rt3z5xfMjlUbh7rOdgDxIrd8r7exCkIYT6c4oUPQY4tQMTgsu0bFocOrBm9+9
    +10Kqi6N93UOp6bJdM7H4Gr0FkYlubkdj9D3mfHhmF5iJSeTon7rFpvx/HnZOIjdcQP32R
    jkXr7OhLkN/gqX+M0qagA6j7qiASZ0G6g3uOPmBqaDkcsVxxs+mylONPVV7d23qwteBxcq
    yxxpIs7dF4p42nYmVLtDsdsfn9BexNBFVMh/98DaXqMcxR6JReJlTOxHzl4F4cQ3DJNkKR
    L2o48CooDeGnlEY+bEuGvU0Pm2JD4QgIYKTUxj6GtJ5RTFajC/WP7SJ4QiPqsg5P3dWfsf
    gsFB7U83x7Xrxt8BTvuigDrHMvD/H6XWtZSAV56eofP3ZyZrpan8d3QV9ApM1mAGLqHEfV
    vNvnqSfzk1CyXGlfZHXLjGbJHeYSWTNNAnP1UWV5VB1CVmL3UY++MSZpEbuTl1k3+hdmDN
    m7y+0O3y5R6+ev9OS3twupUwlRYeR5r8e6WAWdK2rICUu0L2KS/68fK2lEjis25Xcx1f9g
    wGyneX0ZaxulmTWi/isMpbmvgkZPk+sVIsoqs8siun3PM+wCo9S/ls4pJrpQ
X-ME-Proxy: <xmx:58PgahSG1cXKObpAsGt357zO-Ou_EoRd8hPg0AQgfbWxVTL-aBFdTQ>
    <xmx:58Pgan7L5Tkkxs7MRYqH9Wf8pzMNBoXCxsppXD_Wh7L85U1J5feGqQ>
    <xmx:58Pgal0yz_uADidoPt3ZeF3xyqyNfQ710EdcfAMbAy-H2E6BV8FItA>
    <xmx:58PgaqBHbcj00bgBeS58mezpNLq1BQ_zsGdBYOl8irg9xs5U8BvyoQ>
    <xmx:6MPgakufGDKTC6T4tpUZBVy9Dbw2zgr0u3wB42VODyR5FgeydxT__laF>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 27 Oct 2026 11:31:51 -0400 (EDT)
Message-ID: <daa9cc7e-51c6-4b6f-8933-e4b8f16c5520@sandeen.net>
Date: Tue, 27 Oct 2026 10:31:50 -0500
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
Subject: Re: [PATCH] xfs: fix bs_xflags copied from wrong compat field
To: Reid D <skibletz@gmail.com>, Carlos Maiolino <cem@kernel.org>,
 linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 "Darrick J. Wong" <djwong@kernel.org>
References: <CAGNJ+_2p_qyY2xx0b7wgHg+PJWLSQzYmfRqk3UCpue2f6GchVQ@mail.gmail.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <CAGNJ+_2p_qyY2xx0b7wgHg+PJWLSQzYmfRqk3UCpue2f6GchVQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/15/26 9:11 PM, Reid D wrote:
> From: Reid Downing (b1nv0id) <skibletz@gmail.com>
> Subject: [PATCH] xfs: fix bs_xflags copied from wrong compat field
> 
> Read bs_xflags from the correct compat field in
> xfs_ioctl32_bstat_copyin().
> 
> Signed-off-by: Reid Downing (b1nv0id) <skibletz@gmail.com>
> ---
>  fs/xfs/xfs_ioctl32.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -124,7 +124,7 @@
>             xfs_ioctl32_bstime_copyin(&bstat->bs_mtime, &bstat32->bs_mtime) ||
>             xfs_ioctl32_bstime_copyin(&bstat->bs_ctime, &bstat32->bs_ctime) ||
>             get_user(bstat->bs_blocks,  &bstat32->bs_size)      ||

Ummm we /all/ missed that the line just above is wrong, too. :(

Carlos, looks like this isn't in for-next yet so maybe we can fix it
properly before merge.

-Eric

> -           get_user(bstat->bs_xflags,  &bstat32->bs_size)      ||
> +           get_user(bstat->bs_xflags,  &bstat32->bs_xflags)    ||
>             get_user(bstat->bs_extsize, &bstat32->bs_extsize)   ||
>             get_user(bstat->bs_extents, &bstat32->bs_extents)   ||
>             get_user(bstat->bs_gen,     &bstat32->bs_gen)       ||
> 

