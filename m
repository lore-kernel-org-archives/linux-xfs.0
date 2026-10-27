Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.146
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793118372;
	b=St6gX/vyoFTOqRmFYqxHxK9WGd0RO+uu+X8stvCpx+F4AEM2/MMX25xdj36/w6m5pRGn
	 zJPmAM3oaW4IRphbzfNE5BtmXoAeE8JVA3LJAYwBCd8jcipP92sPZup6Do+tJzuJP5k0y
	 j3CUuLfeclzYBg+Tlt7gUW92/cCo3Q+Ny40Vv+qEBi4GS60wlr36QsjH/AE53G5jsAxs0
	 +yvHZH8MsP/Wya7mj13PppjmDoL+Obmsyw6zvelHhULBgcstWxbllhSPnB0pkk0ls3RWC
	 dHv3xZdOmsR1jfgE3r/AqltrSzztTiXPOMfEAQ1a5pIAyyp+rB+knwGT6QzAqleqMvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793118372;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=WDPyzKJKR88Di93LKZ44Gqpz4oCHlPvrgKpjWyPFcYI=;
	b=VHy00lcRR5U19BZ+iTzTGct7TdcyqJY5HVbE/zd6P2Nwbw5pZrniD4WTdVar4nbYKTob
	 NWos7qyOfiZI1baGFI0F4WjHLBjr0yYQGGkiEKVQurESXEODGdCMG+c+ACn9zS9SgdKuo
	 rOeBDarCdFEHij5DEhlfRBdoYx3AZMmZKLLNegpKBhHraqB3hO2yq9vsvb/9JNNVV680C
	 qDuG5edV8w2wT8N5HBu9K2NOW4CFDlgmtUvruQu1pkuSWM+lgfqU0xLtHwrx+gE2FvthK
	 ybrhwum3GzHo6hUm7EOPIiLicJ/eNEB1ImaYGu5mX+sILGznPufgX6kpP1J+rpiGT/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=sandeen.net;
	spf=pass smtp.mailfrom=sandeen.net;
	dkim=pass header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm2 header.b=Q2YOedsb;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=WY5T3AGx;
	arc=none smtp.remote-ip=103.168.172.146
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6BC606A31E
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 16:26:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E6BC606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm2 header.b=Q2YOedsb;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=WY5T3AGx
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id 70F22EC003D
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 12:26:10 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Tue, 27 Oct 2026 12:26:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1793118370;
	 x=1793204770; bh=WDPyzKJKR88Di93LKZ44Gqpz4oCHlPvrgKpjWyPFcYI=; b=
	Q2YOedsbOPxIol0lI8hPtjGkEEEc5rQeekPpiNyx6G9cm8z1WShqBmkaBjXPwqeF
	ChoNk0r1afpGlhpUeaFlT59JcUIcJJSLVdf+kKli23O1ZQRvZpJJWdV8J0wP1T4x
	G3u591L+4C6hVFUx1ItGB8GSrDvQC9jrvAntjv0LurpjAGT9Dv1Mm/Vu9MXvFEQ9
	dbhG8x8WjR2RM85ZXOFNXiDunAyFm7LAGCyymlK8tQBpDYnKN5z2CWc+givcPXDt
	j/yG2Dh8D2duvKBsTJ/cPyoQxvDVrpHRn/GynwmKancIzkcShsM3LIpUWddJRuUX
	LPu02a3mlQoK9QuKlSB0Nw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1793118370; x=1793204770; bh=W
	DPyzKJKR88Di93LKZ44Gqpz4oCHlPvrgKpjWyPFcYI=; b=WY5T3AGxhejqTFFeV
	Q2GGJKf3A691ZS2oRL1EmC4xCo015VWt5fxFV+z570VeMxE5O5eVvvv5PhZ0R2w8
	yLw6vjVZ83iXcuckWL17lWSP5Z3ivTJBfzCQQN4YyU0ou04U7VdZLYdGwAGBiS3V
	dwzitWtWybZDJwgQov8DEpC2rE6Ta0gkyAQ9/KnU1jKhVB4eX+ysK9221ZhIvuYz
	7j+7GNkVXXQkvZWbpcJ9WNRWTfX+NnJt+G/K83jOFxkXJXsoVwUnBkGywGnuehmu
	QG0y4YbByOw+hzscZGd6L1BRP9ZCp6iFBoARK+6lYmNERAERUA4kKDOdwkQgrO6Z
	1WWnA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=sandeen.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793118370; d=sandeen.net;
	mf=PHNhbmRlZW5Ac2FuZGVlbi5uZXQ+;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm2:rsa-sha256:EAEt7bQX4DuOCfvPBX3kW5+ZAyKgbpYuuCCfdF8a5x7YdbK
	QKV5wIkoROINI0EWRaJJjTpe76ghRf/zJySBX2ZZhJUhs6b1uxUNspGg/e2Py4Hk
	619vJ/ocxyfN4TWDxUPfsRMTlwg/R1hiDuqJ064+QNXIEOlkKGaBcdyTaoQFSVrt
	X0IxwCuO3TCMJ1yew/DOW3nZ7i3ETbKvwanJetavRLVUmNRjxJBTf4bOPt8ZoUmp
	zUOA7bVPDJbJ3eaJxW5cryY7FIbjsXOQaedotOOkcuOSLRjS2l0vUqXT+zzNkSYF
	YahLD+kWyc+m6PoOabumGVCNEwstRLEQwVQNtAQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=content-language,content-transfer-encoding,content-type,date,
	feedback-id,from,in-reply-to,message-id,mime-version,references,
	subject,to,user-agent;
Message-Instance: m=1; h=sha256:zBIX2I7hxYD9Sscj6roXLGGN4uKm7INzh9fUeQaKUlk=:LnBnL5m4/neJim9zgPl2agP6ZfJj559mxmEU1UFlbo0=;
X-ME-Sender: <xms:otDgarfMWtZZWIWOw4GfjGiHBRgxiYM4_ARaPrL2pK5eD0cGW2gVhQ>
    <xme:otDgaoKo6enHbuZHS3s-lOT8sr_uvlLhNCWcXbRD2f-1vFuhjPtSsueWKejVZKlG8
    PL7pUbq9IS7EO4YtJzQgRePEX1UnsMXvAseoNfELSVLAME1QGz-5UY_>
X-ME-Received: <xmr:otDgaqL22xWKRnQREFAvIWm5iflkVUFs1XftNqtAd1FCNBfwzy0D0dv_vLjswmpX6TKn_p9zY6o4pKu5IlL6arbpU5CCDw>
X-ME-Proxy-Cause: dmFkZTERweESpPOIH20Fk0/R2faURZP2mJzlnYVQKzXci+pBySQDUCRkfFtUaHtR6NGL0N
    T96UxVtlpFaVd9RmYK6hEbMLcQ48HeInB0lWflv4H9ABbS586O0Pl3IMu8HO6roOCMeGpB
    qdtNxribrddnwOmxLVuIrvwi7FNDJ4X3CGbbdI/2RVPu48G7poB5fodw+fkm9vJfW43sdQ
    dg+80G6UuCX2mv4UPeDhtLJb5/P6O0n1YD5luVz4If93CwotdVFmyBoM1MBi6tAFkhIrjK
    S0Ha3xpG6TueWsZS2CcXSMGPUVkFXLjV8YlYfKCj2jsDHe3PaBlQBYcpXRnroWWGxeHsot
    6HDBTK60n4xaIbW7lHQ3QIJiC3t7dzV5G/u3ZX1kMF7KcXbMUX/0dkVmsp4zdhScJKKSPb
    0budC9GSIC2KuaFIkiwGsm0wwNaMX/SnzGFJnNhiv4gOq9fNZ2V+FT1NhJFEf4bxmdaH+w
    AVPiTUa/FFG7f8tFDGiriqxiKdqiooFKLcP8RDLXqwaedXCRyhNxusETUcwNwntmgf79kJ
    mZfOPrRYvVG9OfMpfrs9tPvjTfmYoHDyWm3cNfB8v8KOpNMKbUJQ8t/cjMXUz4h2nPtZZy
    ytqyU2+5qI9ZdYKCI6qIyoHKMRIDQpDmHK7xJ7CaPUjRhSt0bUmfnxZDvXPA
X-ME-Proxy: <xmx:otDgaiEQCzDxlBuaeqwM-dPgXcK_tZCxwhpc7ksYuSPJMqukdk2HrA>
    <xmx:otDganl5xIK4Hd_SXCES89j2qyHROXzH7xcFJKluEDDmgd7zJpyiBw>
    <xmx:otDganJbAd6Qelw6JxWAmySM86QsbMqtoIDFCkMzl5IS7pbS4_oe8A>
    <xmx:otDgagZl0_YB6j0JjGjR2isKjd1akaEq4sE47qIwm4D_e8E58aU97w>
    <xmx:otDgatOp11l5KWBZH3mpH1Xtgec8hpmejbM5DqbtZm-ODjSHDj8ZQaT2>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 12:26:10 -0400 (EDT)
Message-ID: <56cba09a-305b-43a7-b0d9-d39820e8cefa@sandeen.net>
Date: Tue, 27 Oct 2026 11:26:09 -0500
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
To: linux-xfs@vger.kernel.org
References: <CAGNJ+_2p_qyY2xx0b7wgHg+PJWLSQzYmfRqk3UCpue2f6GchVQ@mail.gmail.com>
 <20261016050847.GT2705364@frogsfrogsfrogs>
 <a785481f-74a4-468a-b164-0b7a55c04246@redhat.com>
 <auDAzCf_MBLTmkBI@infradead.org>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <auDAzCf_MBLTmkBI@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/27/26 10:18 AM, Christoph Hellwig wrote:
> I wonder if we should have a way to test these compat abis in
> xfstests.  Have test programs (or xfs_io?) compiled with -m32
> and compare to native?
What about 2 things:

A refactor (to eliminate the need to type out matching structure names twice)
and a kunit test?

Something like:

#define BSTAT_GET(f)            (bstat->f = bstat32->f)

xfs_bstat_from_compat(
        struct xfs_bstat                *bstat,
        const struct compat_xfs_bstat   *bstat32)
{
	BSTAT_GET(bs_ino);
	BSTAT_GET(bs_mode);
	BSTAT_GET(bs_nlink);
	...
}

...

xfs_ioctl32_bstat_copyin(
        struct xfs_bstat                *bstat,
        struct compat_xfs_bstat __user  *bstat32)
{
        struct compat_xfs_bstat         c;

        if (copy_from_user(&c, bstat32, sizeof(c)))
                return -EFAULT;
        xfs_bstat_from_compat(bstat, &c);
        return 0;
}

and then a kunit test that populates 32-bit and native structures with
unique values, runs the conversion both ways, and tests that those unique /
sentinel values match?

Not sure how we feel about kunit tests in general, and it could get to be quite
a lot of code to validate all the 32-bit compat conversions.

-Eric
