Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BA1408612
	for <linux-xfs@vger.kernel.org>; Tue, 25 Aug 2026 15:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672353; cv=none; b=XdqAqExlne9acwIcwZma1lUivOYEXyfNor2aB3WuPbUDaEcqWI5p78ogFSWCiKiEf8Bg9tMH3g7tecy9cVi6RPfs3CZBQxH61NJSb80mNPkCF8lE4wRW3ZcyGwCtcmK7IavGSdO4//PIJMetARyI2MTUTDJ7MTPlI+KkVDMxpsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672353; c=relaxed/simple;
	bh=y735Rc8GxADutZa1YCNIkrgjn/aY11G8Q5xquOSCh1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zl5Vn/1SN4ZAkejmpBCYFSvMIeJySJ//o2wgNO8xTzUUo2kA6RblD5f1/RGYVS6+0aAx/UqLwYvaFqKt8RYyPPYEd2jkaYLXoo8SROS8t+Qu3YicQG2PFGzdF6lsD7hY7wBIt8GpVYoMJNibYOPoTgvesia3IghX400gKpqPXd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=LJ3Dhihs; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=OfDf0Ips; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="LJ3Dhihs";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="OfDf0Ips"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id A41E61400093;
	Tue, 25 Aug 2026 11:39:09 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 25 Aug 2026 11:39:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1787672349;
	 x=1787758749; bh=FPo7PzMa18ZYeY9oqD9coL2eovKl1ToPSX41l037zxw=; b=
	LJ3Dhihsl5khA+rNQwIwP6ty76EmCKm4HRnHot9dykzPQRCGcp5IHldrg2NEddEz
	3Qj9kbj6Q+JPnomadpxC+PhmBr/egNKRZTScy32aY6XGDSM2ouejIsnyRBhihDp6
	Zxb1j76mDGAQyEoKpCu3ZwzI3FwQHQ2VCS7DE5Fgz9V16nO9JMLNkwu/YABA7FQ8
	CEG+qRsEeriVo15IYL1VMuKOtRlnHZc26iV9eLHhQ5mzKLBofHJ1yfZs0FNB9Mwc
	ERinkm1y29uOAcNK9bfK3FMLmxsCXx3tgdb+W3+KE4hzSeZYAgbnKLIUfOhPYc4l
	yQ+X8sWye+SUTmgYQXdplg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787672349; x=
	1787758749; bh=FPo7PzMa18ZYeY9oqD9coL2eovKl1ToPSX41l037zxw=; b=O
	fDf0IpshHmT3kRI0rIgHYg7xdCoQuSrsBlY5irrMkd2UiNkdquppN1M7wC12m/RO
	oqv6osFjq/Jrjv2CScVjxHxRHjPwNyUs55N26pPvFDZIb0cO++tYaMltMs8U9gsX
	04wbXMhXfZZkU6xPMNQzu1N1Xj5mSblbvFKKcISGlU/LguiUhop1K+RFM/2LmGqu
	ZlEtxEXN3Yom9aDAy8Aim+qgpgPw0usZ/36xpNDp4dN3Z3nStxy2kR6IKhFIVSNZ
	v8vC5PCvfMkiY0yXHmqX2Kul1VyoADSoSmmU8V0Mx3XohIYDgyF+M5fIRkCX3Yl6
	M+vzTqEUQ8istzmHdJyRg==
X-ME-Sender: <xms:HbeNauOCNavKQ9CZhbiT06FDDmR59lgyRMnc07bOYKSebErpf1b9Pg>
    <xme:HbeNakakdi53DEPQFmTe8qAAh7NRdw2KU00Ge12-NY2nhghjsk1xkNWk2KoBIXPfK
    xbCE7_Di4SMLOtCYx4wu4wJP9xP8vq9FWF55JaNrkyHtZT0UL9Ug_aI>
X-ME-Received: <xmr:HbeNaireILl5FMNEk5VTkRqTT_RpmTT9fMO_oWrgoD3WsT1WgqgCD-j40HYNxp9ZRGxZZ82GSC1CCeEy57lV4_fU>
X-ME-Proxy-Cause: dmFkZTFGVAaVE4X/PekZW0/1I4bDKkUEKl8bEd55/OKH9SgLgEgZ7ygK9Pa0DISVxVtufF
    f0rNbrf6gdTSSgG2XiqAbqwNuyjmvdnXrKGpIfROgVP5QXl+dgRq7xPj34gELdSqPQ32gJ
    QbXateZ+zv2mlcRnfQaSmmu9+2O5xQ6vOnzddQ1OdVyayt3xe8CoSUbgCYgmnaJw9d2Uee
    HuGnH06G1DEjEKzqmstGB9t/F3KmGOQWp6Ini+heV1wcHREaO2g7LbyoOJYWHgWLWQ/TaF
    tul53teK96S6UpW9PyhhoNSof4pfnfxqt6YCAQCbOPj81BJnMzqG4XqMSIaxVX6kE6TwiJ
    Aj3MGT+mQexO1bg2BbfQf3yH1lfE1/EwIwkr30/lxDkNMaHCeJAqdjsTwrpMFXrH4Cbmfi
    pum9fpwMEAFI0NIWBShKAVqBzsDSWKg0zgYOAEG0QsBOVaAIWtT2PyU0ZW0aWuPMNe/s2k
    J9Op05MQ0fILzOzgyrH/885XmMe/8xcxm5sjjDpAeMNsAXRb2PJrRrl5ln2niJXeE0AyVx
    yu6ZHDcnDYr6I7vgtK+vIClFi8uk7B5m2Ue5k9JrLe91A7bLTw+2cOWg53Az87lcpEs+Qy
    wx8nv6fF2UTN6/OLWlNcsah6FX50AxoKn720ixPkq4rdgTGtcsNtAcTUPRPg
X-ME-Proxy: <xmx:HbeNaobXGn4fOjwnUjmgr4ihuRZLD8RPekCwR-9ROJ17hv71cGFdJQ>
    <xmx:HbeNaqSj-Rz2Be85Mp3MIUa4YJyu-2xJyyhFmDCiqrDgZIf7ToksWA>
    <xmx:HbeNav6FEb2uwK1Z7Ljpkpb-D7txDBxuDuF8VcgRJVeI154GAbUOPQ>
    <xmx:HbeNavxK03aFr83pt9OD9X4yuAEw_kvPpE28ZdYViBl5tTIxMJx0kQ>
    <xmx:HbeNanqIqN-2LBPlFnGmSDh0iKBKIqR1FeViCgQWZgQHgeXGbGbxQMgu>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 25 Aug 2026 11:39:09 -0400 (EDT)
Message-ID: <ec9e4908-32f9-4d54-aa1e-93dfc8a5b95c@sandeen.net>
Date: Tue, 25 Aug 2026 10:39:08 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] xfs_repair: distinguish true ENOMEM from "not found"
 in cache_node_get
To: "Darrick J. Wong" <djwong@kernel.org>, "user.mail" <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org
References: <20260824214056.400740-1-sandeen@redhat.com>
 <20260824214056.400740-3-sandeen@redhat.com>
 <20260825031810.GQ6072@frogsfrogsfrogs>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20260825031810.GQ6072@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/24/26 10:18 PM, Darrick J. Wong wrote:
> On Mon, Aug 24, 2026 at 02:59:00PM -0500, user.mail wrote:
>> In the cache_node_get() callchain, we may fail in cache_node_allocate
>> for two distinct reasons:
>>  - The cache may be at its current size limit, and must be expanded
>>  - An underlying allocation may have actually failed with ENOMEM
>>
>> Today, we do not distinguish these 2 failure modes and will try to
>> expand the cache size even in the face of an ENOMEM, which won't help.
>> We can distinguish these two failures, because:
>>
>> If cache_node_allocate fails because all slots are full, c_count is
>> untouched, and it is >= c_maxcount (all slots full.)
>>
>> If cache_node_allocate fails due to an underlying ENOMEM, c_count is
>> decremented before return and c_count will remain < c_maxcount.
>>
>> So, if the cache has been fully shaken, cache_node_allocate stil
>> fails, and c_count < c_maxcount, this is a true ENOMEM situation, and
>> we should give up and tell the caller.
>>
>> This adds yet another return value to cache_node_get (-1) for ENOMEM
>> failures, and corrects the comment about the existing 0-vs-1 returns
>> - though nobody looks at that return value today.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> Signed-off-by: user.mail <sandeen@redhat.com>
> 
> Dunno who "user.mail" is but I feel like I know them from somewhere ;)

I'll check my git config in that tree, oops :( Been a minute since I
sent an xfsprogs patch I guess!

>> ---
>>  libxfs/cache.c | 16 ++++++++++++++--
>>  1 file changed, 14 insertions(+), 2 deletions(-)
>>
>> diff --git a/libxfs/cache.c b/libxfs/cache.c
>> index f8be9b89..63224e58 100644
>> --- a/libxfs/cache.c
>> +++ b/libxfs/cache.c
>> @@ -373,8 +373,8 @@ __cache_node_purge(
>>   * hit, in which case this will all be over quickly and painlessly.
>>   * Otherwise, we allocate a new node, taking care not to expand the
>>   * cache beyond the requested maximum size (shrink it if it would).
>> - * Returns one if hit in cache, otherwise zero.  A node is _always_
>> - * returned, however.
>> + * Returns zero if hit in cache, otherwise return 1 for new node;
>> + * allocation failures return -1 and a null nodep.
>>   */
>>  int
>>  cache_node_get(
>> @@ -474,6 +474,18 @@ next_object:
>>  		 * If we exceed CACHE_MAX_PRIORITY all slots are full; grow it.
>>  		 */
>>  		if (priority > CACHE_MAX_PRIORITY) {
>> +			/*
>> +			 * Shaking failed to make room. If the cache is not
>> +			 * full, expanding the limit won't help - this is a
>> +			 * genuine ENOMEM. Tell the caller.
>> +			 */
>> +			pthread_mutex_lock(&cache->c_mutex);
>> +			if (cache->c_count < cache->c_maxcount) {
>> +				pthread_mutex_unlock(&cache->c_mutex);
>> +				*nodep = NULL;
>> +				return -1;
>> +			}
>> +			pthread_mutex_unlock(&cache->c_mutex);
> 
> Also seems fine to me, but nobody checks for these -1 returns.

Yeah, lazily mentioned in the commit log.

>  Also,
> maybe we should be "return -ENOMEM" here or something?

Then have callers check, etc. Do you want me to rework things to rationalize
the return values (and caller checks?)

-Eric

> --D
> 
>>  			priority = 0;
>>  			if (!cache_expand(cache))
>>  				goto fail;
>> -- 
>> 2.55.0
>>
>>
> 

