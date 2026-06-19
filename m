Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0B336073E;
	Fri, 19 Jun 2026 22:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781908054; cv=none; b=mnrhyA8+7Y4SRzQqNw8ghQVx0muj7GxeFEHXTJeufKcmxgeDjOaMK7lskG8vLLFagFsNx7sk6z8Z405WgiTZfjjO+wZV5ws4NLl3g6YwwNbhi3a3sN+X29CFxvr0X9UMUsD6CBwhN9hrOvuRwAw33PqvhNj3lL1ICKGrsTic+js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781908054; c=relaxed/simple;
	bh=pZCAAhNlFXNX5Qzb0xYhDxFdYkSrdSpk5pHAPyRlVWQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DCK14fVYj+rnW0T4KiNUqENS7/fYWMAHjtiaYC2NgzOSUpei3SLDOtx1b4wft02KVE1l0W/+Al2h8LrTikx+kSMR/iCpai0fMQ24L6ZtTuDEWYxr4RuIkH1dbShafad5++subyIpj1umtK4UlSz4vtgQ5Gwt0PseQZ+r9984mFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=lDFnhUnd; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=fB5/LaVI; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="lDFnhUnd";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="fB5/LaVI"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfout.phl.internal (Postfix) with ESMTP id 9ED2AEC02AE;
	Fri, 19 Jun 2026 18:27:32 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Fri, 19 Jun 2026 18:27:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1781908052;
	 x=1781994452; bh=X0YaVyc5F3jEpAKuI6UkaL4Lq0al2hNvjmcAbXsczJs=; b=
	lDFnhUndKb9kMUnULGM9V7QVNiPJeZMdPPEUAj3uBZpdPNkSjAhSTfmmsdYegVwD
	pGIm2WsloAZ+6nV3tBO+10cpBRFSRgKYVjclc6yggHlR8RiFJi5yG0ZuckFedSHs
	55NWgqwamVTtbDZuDH4Pxushw3QXAc2biRhKnxjqq4sTM1ems9cWkaMyhzo1QBaJ
	uHBOtHI2E7Lqe8eg7qT8bUd5WniEcJ0kwvjKiCajljOvYlgPtJSR/KoeWma+FF7M
	pnKT9tnjZdBP3xjI2kcjMkxhXhO9ho2nM644940w4d8KvWGb1qjpBIwTs3SmWA06
	KT6iIIeOHLuBO+m+ZvHi7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1781908052; x=
	1781994452; bh=X0YaVyc5F3jEpAKuI6UkaL4Lq0al2hNvjmcAbXsczJs=; b=f
	B5/LaVIufXAE/U4EfhVli0UHH7c0vp0tU3meqjtzTtcSuXNCOUQOevyURNeDi6K+
	B7/ftJzDJwlVlSperfF2gH/XDI166b0Vmr+s0cCl5aaPGjSK4PdOsLt4BvUgqLHZ
	S+fgKRyJlbKifukeMPtfZnMqjY0+qZ/e827mmMc3zkd8WZOeKaeOzsVK773M1VK7
	CYg+nujNC6PQvyExz1qtheh1VUSdZ5j8DQgbub9Umg3ZNJw07giKOSyB5C+Q3bzD
	vWVrc6DfuWzMac3Vg8jb+KqXVnwG6QWrhvw3yTjj01ellEa8ehuUPtmvDCEADoyT
	ELaw6+HtTBe3zwlEfJexg==
X-ME-Sender: <xms:VMI1aheP_lUvAwDQe06VJSwhGrdXHo8hK6maleCmRVDesGNpctSoOg>
    <xme:VMI1av4E1bvA2Ml3I4DqRgVlU8si0A59aVTUj8rsJdvyL2rn2AVnypHPZeKqVOR5m
    shP8PxuNgnXois7sZrFZKqCeGmpDaCTAvRcWnRwxQKAwjVQi1uYa6NZ>
X-ME-Received: <xmr:VMI1aosoDIIEiGLPtY803TsHWFEIKtHYYFq3yd1SuJ_QM0MbcU9k-EwBtOPczGLBd_yqKIq5kAac5UfiD9J90gBWJUl_gA>
X-ME-Proxy-Cause: dmFkZTFoTImpe5sOLGod5PwABj872JLtWJj/U0Fz05OT/z1aKo9Gmpt7T51mtmnNpeQCIv
    ULvL8R6DqNe2rrlMd+ChoRYJJRe+cdoR7o5C+q2QQ/3BOe5KcdkjEyYxcwQmh4LilFSd6Y
    EOO2gOd+QqP/0458zcH73aSGNuMTHpgV88WgOat/oXWJXeJIwhDLg+qJg3Z8ry5n4oHN1J
    WsAvr8X/jfCTDSo1uERyxvjU9F05Pu4FON8CZ/ERb9H0/mgcVa2mr7PKocN3q5YxKntJJj
    vU7pxk2kWPRqq+3d51gMFhoCJSYe9F47x42F88t6U093EChXiflgVkALz+WtEgMZ+FSboH
    2YqFXrybtEMFMXTsrtWIt4x0XvYNUUD3B7ri3+f+An7qlSwvgxARaljvi+jyCFSFdHsPc8
    0/3anN49JvgKu4gwyw6Um7hy/OC08q6UqtfouueYBwr84fhxG7pnzZOZ+TyhxS2UNtLY78
    NaXVePzSAj9RBmGbdAcvSap64ZtIL7LRsU3nePb5zz6Z8pP3pzUHdKUcFT1J/jIaRcvw2C
    Kon5SlXTJfe2OMvU2SOkxYdz3xLDjHU/1z2bzdK6enjDq2dZO599a56IY1QsPqFqOZ3vwm
    I5am51QZt4M2MIRAc6b4n/r8Y7GWhKmrbM4J05qETBdAcIrgpu8AL7U6U+sA
X-ME-Proxy: <xmx:VMI1aviEC4gnPXJcsJC3rlYauQmHK9KteMBp8T9HrJ3GGWUz-RjpkA>
    <xmx:VMI1ajrJ2F7Gq6KFqq2CqkdekI3-fnQn8MgwTLpUrglpbYQdhFV-tA>
    <xmx:VMI1asvE-IJPh6gLuHZTU3C1ptp_NHeF-HAlPr5I4JdzWXDoat7aiQ>
    <xmx:VMI1ambqak1lfeSindiEkJnGyW8OY7Ie3p_e3CRyr1GYWzx18m-n3A>
    <xmx:VMI1aurqznC4Whz_yfAEVSuzPhRW4PyaR-Jvm2Y85CKAzCYz4ZpYKLwq>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Jun 2026 18:27:31 -0400 (EDT)
Message-ID: <1172af00-32d4-454a-9d92-a1b804b6775b@sandeen.net>
Date: Fri, 19 Jun 2026 17:27:31 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] xfs/216: disable all concurrency scaling
To: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Lukas Herbolt <lukas@herbolt.com>,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <20260619050937.444488-1-hch@lst.de>
 <20260619050937.444488-3-hch@lst.de>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20260619050937.444488-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/19/26 12:09 AM, Christoph Hellwig wrote:
> This test currently disables log concurrency scaling, but even the
> data device concurrency scaling can create mismatching output on
> systems with a large CPU count.
> 
> Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  tests/xfs/216 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/216 b/tests/xfs/216
> index 1749647c11f7..ce8bb528410b 100755
> --- a/tests/xfs/216
> +++ b/tests/xfs/216
> @@ -23,7 +23,7 @@ _cleanup()
>  _require_scratch
>  _scratch_mkfs_xfs >/dev/null 2>&1
>  if _scratch_mkfs_xfs_supports_concurrency -l >> $seqres.full 2>&1; then
> -	loop_mkfs_opts="-l concurrency=0"
> +	loop_mkfs_opts="-d concurrency=0 -l concurrency=0 -r concurrency=0"
>  else
>  	loop_mkfs_opts=""
>  fi

