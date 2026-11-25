Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.157
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795642982;
	b=cehkS8mRO7mddAecXOdYQiRQ/9ozOgTn/PWbA8OQfAF1MEATej7aqVHtj2QLhhMtwQF2
	 70tNnYZK+gZAXL+LWcE0nMOU2WCXrbolm2KGuhg3zpvf/CyCpRdR4cNqLSIWnWzdZEwjX
	 ybgy3L2Hz5j++3tmtvzHktoco+XtOcORW/vrqTQBO/sMhg1BhvtijofQbekZokJyWxFUt
	 WLYEuzzMN3/AD3m5ysGqeF5/bm2yTbKufAQdOHGDtEEwzUg1cbHTgU/bFKFuFcIq9QYx7
	 tCjHaVP8cYPgo/+zjwg1MsEmJPWaQe2Y+oNBaJy21LGzy5SCrBWOwX1jiz3AQUVbDJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795642982;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=xBRG3bBvCN1AV2HG0Gn5yfhC8jwmZ18NCo/e7QqFk70=;
	b=u110AgPbIY47lqsV1BFzm0RxrhG+RgdouQU5g/bnz139vtuZFCtA80Wzcsnd1rRVgNBn
	 xSbtxpVcVMTiJRK0SJRPxmz0WcWZK6CmRYuJnK4NtOa7eR/Hj+v3x6z4zgoxyeSgxwJd0
	 PpUoLeeP9gARQc/uC2VzMGdREHy2uU4yN+4mXK0nJIeVv5ItQZSWP2CwP4agXjRdz/pXn
	 PgRt3KygF4OzcZibslUG/T+J6NOscm7j2oiITC6+q3nEs5lAQutpUnqdO1BmHlbZ/7btJ
	 COKhMFjTlA/3D8PieGm0Nh8qv6VrrGHq2mWTTk2ITmpxDsCprWROSVVp5es2b/8066Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=sandeen.net;
	spf=pass smtp.mailfrom=sandeen.net;
	dkim=pass header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm3 header.b=enBlAruI;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=U8z4y1QF;
	arc=none smtp.remote-ip=103.168.172.157
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4C6606A321
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 21:43:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B4C6606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm3 header.b=enBlAruI;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=U8z4y1QF
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id A7329140032B
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 16:43:00 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 25 Nov 2026 16:43:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1795642980;
	 x=1795729380; bh=xBRG3bBvCN1AV2HG0Gn5yfhC8jwmZ18NCo/e7QqFk70=; b=
	enBlAruIiVxRJHskFspwdOgc9waSxdsxlIzKFDCPbyjhOz/Vw4ysZvYrwoXuZba1
	OFu1fjpgyEQsmgOjtNPrGAM4ViMT7UMMQ9t1H6i9zsQAQ1w5hUkHEFAuXDagNnsC
	NliJCkeb/mHq7/rBBlfawbjqQjPqJRVvbkcMaeSKGBzZ1w/vOiM2AS7A5u3KtlrS
	CGPvZ2y35XNjY95h4aMGxBsNkULBUC02RKRvCYfPkYEkTSVrDEjCKHe3T6iSxHyf
	4XBredSiwl/uz5Ze6UM2LEFyHJmIQ40eVJeSHqZ4p2xqxknfOez+8RTOXLuKXUCu
	oEJtuF9Cj50Zu14THfU2FA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795642980; x=
	1795729380; bh=xBRG3bBvCN1AV2HG0Gn5yfhC8jwmZ18NCo/e7QqFk70=; b=U
	8z4y1QF3cymoLUkEsgQz/d+EaiAS6ifaW07m3k6TDE1oNV7pvqqzsK+5aHHFfHuz
	4FaMXMjm93HI753LtxDHev8Gqq5abItEcF/pPAvjnzeAS8P/MhGgLltAPTADepoJ
	X7Gsre6D/KU6HLfl0eAOpzt8OGfNuPimKPqvpeC9sNpDSPSDmZoWUH723lPrBcMi
	gA+IvzJKiPg3fuqyOxMprR8zsctOmgRnRyzouVBjzDWGNhXkgC5leCgltg1ml4WA
	05ZCPl5HO8HSgaaqS1U3MnppJ7zYmmoy0WUayk4pa1aUTgSD2Q9v0dXsscLtxlpy
	U9liJSnpk2dzWsFBqz20A==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=sandeen.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795642980; d=sandeen.net;
	mf=PHNhbmRlZW5Ac2FuZGVlbi5uZXQ+;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm3:rsa-sha256:MBVt0eD9yXyFAcsCRPwoSaLUFR1n+vgX/EIiN52g5Yl0qsD
	D83ENxvrU9jN8bdm97xpr4M/Q2pm4GtLRC8AfWwSRyEJozHEYb0AEdPAsVv9pQB2
	eG8XdhBoqWb7M7T7y9Fcx0PPYZKOzKeVQj587lCk/2kBGwqXKwE9dLfnzPXlzlJZ
	WxC+G2Am//lZJzpH2gqDy5co2/SGROejhxpofg7sxFxKVBjoXoiZfoBXdlf83MtP
	vWyIFAle/+HGeWHbFBipflz8Hv2s7d2G50CizfMOT9p8fxZxJGAmUDOi5QpYLNvf
	s4XNOGVwL3i+ck2EfLD770i6DxImLzmaoWXYz1Q==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:ijOAq2XEthMI4DYOKIJYwYkdZ8XvNPjcBzfDNTTWNGA=:UnLj9JSoOXufQgS1hq0EJJkXiowOGjV9jCE51JgipZw=;
X-ME-Sender: <xms:ZFYHa9Gl2y6KcUHVT2hVYxA6dm2FGJHiD73q_YO1UhddAIbWmxe6Lg>
    <xme:ZFYHa5NGWICpjQMH9OjnxIO-RD2OeBJt3JuFokTUpbgO3ijiDXCtXztBGEJxZnO4t
    NFtrhP24_ilG19Y5O4MLchl70_WUTkeCd5Ow6uz_1PNUS4IycThTfFoLw>
X-ME-Received: <xmr:ZFYHa3exlCF4t3zbJ_SglBh_j4yTj_EYRDA1SV40mCDNuXm9tqcgQt3aGAu8UtPYgVXpMtZnxkxgsm_yKGgxc4OM5b9joA>
X-ME-Proxy-Cause: dmFkZTGw+NEeMkxsA/vJpYEFRr/wBkOIRBde+ZjF7OwvZpxWWv6gbAEhQ40E8ZzlvGW9Rn
    uBXSgjVkoRR4njPGw7kGuaDP5qZLPgcpWQDDAMEzVbLx3JTpzabKFAGtAq02pnDtaOhdjC
    y2PuRX1BOEvbyyP23ZDx6+xypoM5ZWzmHUmTXuLO63/VIgdAPaCt1Auwhxwkm2N55wRl09
    b+zMIzPlupGz93ahw5NvOPkvziTT2oypL5nKcQ1i4Wn/tXIGZJJzkvNkJyKHEqQTLOyY6l
    Tt7VXUi7HdbQY44Utb+JT4HIkoFvAAY6AnFSFGYX9tcchTIcWbZa2UTCfjYhLVkccbexGq
    YgZLAQhviyffJXeBRXXw6edEK+Zi2bes4DQAuEwbpketIhzxY2oCQFl/2v/c0jh/Ep1nKk
    vqCGOSSO2jCIVanG68zXsIPmf+4sAuRI+9fNW9JKGK7ZeBW7axumWIelfl/KyrzNqjWHAe
    SlSFM6QVRuYShr125NPyh4t2EXA+ddc83avsCmIQwf3iWlSZXQQsGoo7C6A0YrW/Kn8y4G
    kj52CGSNt0AmwBDgWJyQ5KNmebVEEKGyKDJC0AXujskFUFT6/MHULvtL/rbq1EfodTc9HD
    U0QiIooAOrWJhTaxMvv870odb+hoiPvOMBBMNpRKlhmKsTj8ocumLsIEDzCA
X-ME-Proxy: <xmx:ZFYHa-ujFTUiUeNt_bMvzvmCrmd1HV2Gx-aZtvaymQWh72TjV6bSaw>
    <xmx:ZFYHawmqNSc3woKgUJLLeiwP_cBsxTjXyY88QAtvZoqgR-xADfU5Nw>
    <xmx:ZFYHa4zV5XqSP0ZxKZ1z3Oy_GHoiJdHzdjj0aJnW-YckHgj7IpJR8g>
    <xmx:ZFYHa6P8AG0Fcza0-wcqo3Gn7VFncOXaWb8EPMQLUxbo-1bCbwxsrA>
    <xmx:ZFYHa9rXzo4rQ5eYH0KnY-Z86c5xvBcl2gbkQAWKZsL-byi1Kv642-oA>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Nov 2026 16:42:59 -0500 (EST)
Message-ID: <ad3315e9-398b-4e9f-b5b4-269ad1f1de60@sandeen.net>
Date: Wed, 25 Nov 2026 15:42:59 -0600
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
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>
References: <3783cf39b873890896eb889c8c09edb455559fce.1795626969.git.alx@kernel.org>
 <34b824e8-21fc-4271-bd60-29cc8b06a292@sandeen.net> <awckBo8FkdsGtb1t@devuan>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <awckBo8FkdsGtb1t@devuan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/25/26 12:10 PM, Alejandro Colomar wrote:
> Hi Eric,
> 
>> Date: 2026-11-25 11:43:00-0600
>> From: Eric Sandeen <sandeen@sandeen.net>
>>
>> On 11/25/26 11:16 AM, Alejandro Colomar wrote:
>>> We want to pass the character array, not a pointer to it.
>>>
>>> This seems an obvious typo, introduced in a48373e7d35a (2026-01-20;
>>> "xfs: start creating infrastructure for health monitoring").
>>
>>
>> So,
>>
>> Fixes: a48373e7d35a ("xfs: start creating infrastructure for health monitoring")
>> Cc: stable@vger.kernel.org
> 
> It's unnecessary, because the binary will have the same exact value
> passed.  It's only a type-system issue, which affects diagnostics etc.,
> but doesn't create an actual bug.
> 
> I would add the 'Fixes' tag, but without stable@, since it doesn't need
> to be backported.  I didn't include the 'Fixes' tag because some
> maintainers don't want to see them if there's no bug in the binary.
> 
> Let me know your preference.

yeah, fair enough. cem mentioned this too. Sorry for the noise :)

-Eric

> 
> Cheers,
> Alex
> 
>>
>>> Cc: Darrick J. Wong <djwong@kernel.org>
>>> Cc: Christoph Hellwig <hch@lst.de>
>>> Signed-off-by: Alejandro Colomar <alx@kernel.org>
>>> ---
>>>  fs/xfs/xfs_healthmon.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
>>> index 2bdd747f1ead..56d19ffb02b3 100644
>>> --- a/fs/xfs/xfs_healthmon.c
>>> +++ b/fs/xfs/xfs_healthmon.c
>>> @@ -1061,7 +1061,7 @@ xfs_healthmon_validate(
>>>  		return false;
>>>  	if (hmo->format != XFS_HEALTH_MONITOR_FMT_V0)
>>>  		return false;
>>> -	if (memchr_inv(&hmo->pad, 0, sizeof(hmo->pad)))
>>> +	if (memchr_inv(hmo->pad, 0, sizeof(hmo->pad)))
>>>  		return false;
>>>  	return true;
>>>  }
>>
> 

