Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BACF3C4547
	for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2026 16:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786723683; cv=none; b=AgfCGWeOF7bk6q6RG3mxcwGz857kkVL7sW6yk0h08/b332nrleIs6FablSVX7LwHc5EYl1Cp2xZNo+a8HVbQ/hd4qIl5wHPxuZt2o1VTjoXYQ6030c0tWF4LbzJwIy3/Vxhkora1TbHXpWP4zLGfBjfQ8djM+2iGCg6d3SkjltE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786723683; c=relaxed/simple;
	bh=MeOVL7cpnjew3JBBrxOvr6SE8CY1/l7lJqxAPFnloU4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AiflfmG4gCLrFxjbUXt4rH57UPMwEUZGgKNeNP+kbOUM1cGsUBS9MSYNJJrT++Bt3UTMhnrw/E0+6F3ZnArIY/t+HjsGH6T8DWW2gPG1UKZX7w9bC2JDMSzGPf8nl1KUsnsxvdkIPvFcNnhx58P8inaTMbCMLP0QMaLd9bRkOGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=WWV0Ay2L; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=W6zcFx4v; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="WWV0Ay2L";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="W6zcFx4v"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 902D2140006E;
	Fri, 14 Aug 2026 12:07:46 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Fri, 14 Aug 2026 12:07:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1786723666;
	 x=1786810066; bh=VNUlU/tHnoQ5KDHu9/pwcilla1bjI0FIeW4BddgKQBc=; b=
	WWV0Ay2Lv2g6nJD1eMeeADJcg1hXu9q+Ig/bW9KSy8WvPrI9jq9gwV3uhVHEu9mE
	2g2D4GgpRqKP9bBVlc69R2siwCzKR2IbpovPwMnpQ5nO1r/oCotLS+VPvE2ODUtf
	f6PAHVC4DcqKpEdFoOtJzGg1BSBg4kCpHP2SzRl+hc3iaCgsfbmnd7Uj35w3ChUM
	oWbMbM+Dby4Kh2TwbB7zORSNhe/atnvj4F0z2uYBYeuKyeVxiZKQXrylLQIqDMx/
	uMjlwZzIgBcAMe4HUqZFk1/wJZ7fedZcxlCnFN6YYj1N9vvqa9WI4nlnhLZd4YfD
	U3F8wHVWrUtCxyqv99V+sg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1786723666; x=
	1786810066; bh=VNUlU/tHnoQ5KDHu9/pwcilla1bjI0FIeW4BddgKQBc=; b=W
	6zcFx4v8FoQxnwG+6XLw3MchzLeewgQBmm99fdPKNEj7rzYDFUupqA0zJSJnuTUP
	ipfoM+15ktKk6SGYyClb7X/E3mUXj8oK6tSJu0Ujut/3NVyu8xBB9HvyUbHIIyAC
	KhvGKndfbFkG57BFRwWsaSrVNoh6o42k0vu6NvY/pjlUCzqulAtMbz7Az/ltsBli
	urZ2HfaGh/zbtSVncBzIMM45X+44iwAmWHx5SsfBnszwvtALk8E/Ab4c1IBSdu2h
	jfiegwshFTq3tElMEJhw082FwmBlglfh31xmCgt+dfth/j3kegZrTQwy/e12kJzU
	2zCik4n/UPGI6IOktUkXQ==
X-ME-Sender: <xms:Uj1_ahuSmJO47iQSTkmN1cOlviXPbEkaMD6mGIjs33qmVG6uIxrxbQ>
    <xme:Uj1_ahc4TWnCXT_KgDLbnL2VsRM6RZtV6yh6-bkhk7AHNWa_M7uexqVBrXCnN3QGY
    yEGW2CEAKEtKyJWXSdRTtjeChgF3Bab_hqk908J0-76COD-ynB3x81R>
X-ME-Received: <xmr:Uj1_apyZY0vqZ3HaX3wmMK_WEEUmBB20x9PMY9RGomz1H_Tf_L9HUIsVcLLwqbvzh1jg0OjsBaY7FaAOUz3si2of>
X-ME-Proxy-Cause: dmFkZTGjgA0y5oBk/MpKva3iNFZXJBWtc6+Fce5oVa8b4osBsgvkoNzuWwmcenbYIZsUJN
    6MjE3HaFHLT5On+1P7Hen5P0rxkjejejrzObPDACCec4UlYvluy50NTfRyJ9C+9n+QkgvE
    ghSW0S4WLWei6nrsQKEmQj+mSpNVlcjWpLZoJcT7YXZo8rPvqNY6l1SgJOtiV3LWhzJ/ap
    KGjFNWewFzFDdsIvjQ5UtmB0yzph0+JfGpAM8U8KPSUR8yNZGXySeI+toc1to1C9+EPeD0
    5J2uYhYAKqJh2E3JmgCO8+5BGLMyp3oc8OoFJZ7Rij5Pn2vW3LZBZz0DhOH5jmfDxSaeOK
    pK2s9ijyy2mjmBTy8LGNhgaX98U4hshparW5G6LthA/hG/wwrgYJi/tkvl2MfklK/F0yg7
    Cnv4l0dr90mYmelJy6pjtTPbMLvWJlCGNTrZ4iPmjirjaaFbqirFrC7Kz0Xzf8qMmM4Yvb
    YIfTgWsZrCP5hm/qlZt7HujLrFDrqvWHBFTal4EYDLVFLLciCrjyE4jBuapXTqFmKq2lW3
    +2mYe3y317oE2ZQSscKnONgcyrE8VZE2GADaNEUbLkdHvHteSH+ZBr41LC+yCvK8Ost+kw
    edri7PL0wctKozKGoCk8vYUVXYuUyKqX9mkWoyQRGa1nZ/ytIT6fOC/O3/Uw
X-ME-Proxy: <xmx:Uj1_anGdWlLZo3yrwclw4FhVaTEy8apVikZvnLd2cm6MkmvXfUUXdQ>
    <xmx:Uj1_atzEdUmE3cKrPy5VBpPHkhqtSsKduMVJdbYC_RJN0TtiopzlnA>
    <xmx:Uj1_aovHaKeVLOMli6CAT7S494Y4VAHWlKV2JJjXkMo_qI7SMEaVmQ>
    <xmx:Uj1_aq3r8nDmK1TXGVD9QqjM6W9cCfM4XGUu91r6yBrM7cL-UM3Ztw>
    <xmx:Uj1_ahhp3wrnu4DTfOoLrYq_-5x86AG2SUaowlHXnMh_YEau39d2o-lD>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 12:07:45 -0400 (EDT)
Message-ID: <11c14c65-8609-4482-b3d1-23d4d36afd66@sandeen.net>
Date: Fri, 14 Aug 2026 11:07:45 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: xfs: properly account xfs_buf items as reclaimable
To: Dave Chinner <dgc@kernel.org>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org
References: <20260813204929.2253988-1-sandeen@redhat.com>
 <an7D_9YRVDG-0Qjq@dread>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <an7D_9YRVDG-0Qjq@dread>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/14/26 2:30 AM, Dave Chinner wrote:
> On Thu, Aug 13, 2026 at 03:40:51PM -0500, Eric Sandeen wrote:
>> It was reported that xfs_buf items are not accounted for as
>> reclaimable,
> 
> Actually, they are:
> 
>         xfs_buf_cache = kmem_cache_create("xfs_buf", sizeof(struct xfs_buf), 0,
>                                          SLAB_HWCACHE_ALIGN |
>>>>>>>                                   SLAB_RECLAIM_ACCOUNT,
>                                          NULL);
> 
> So the xfs_buf items themselves are accounted as reclaimable slab
> objects, and these are what the xfs_buf shrinker itself acts on.
> 
>> and therefore various statistics in /proc/meminfo
>> and /proc/vmstat do not reflect their reclaimable nature as
>> other slab-allocated items with shrinkers would do, which in
>> turn affects the accuracy of stats such as MemAvailable.
>>
>> 2 patches here to add accounting for xfs_bufs allocated via
>> xfs_buf_alloc_kmem() and via xfs_buf_alloc_folio().
> 
> That's accounting for the memory attached to the xfs_buf, not the
> xfs_buf itself. 

Yeah, sorry, I was sloppy/wrong in the cover letter. Tracking the
reclaimable memory attached to the xfs_buf items is the intent
here.

> We don't use the size of that memory for reclaim
> purposes, hence we haven't ever tracked it. It is, however, fed back
> into shrinker based memory reclaim via mm_account_reclaimed_pages()
> in xfs_buf_free() and hence memory reclaim correctly tracks how much
> memory was released by the xfs_buf shrinker scan, even if the user
> visible stats don't show it.

I guess that's the crux of the question: should those stats show it?

>> I was not sure how to handle xfs_buf_alloc_vmalloc but I think
>> that's a relatively rare path, and the above two will capture
>> the majority of xfs_buf allocations.
> 
> I think both folio and vmalloc should be accounted in the same
> manner - as a number of pages based on the size of the buffer (i.e.
> same as mm_account_reclaimed_pages() does already). It doesn't
> matter if it is vmalloc or a high order folio, the amount of memory
> is the same.  If it gets accounted to the node of the first folio,
> then it will at least always be consistently accounted, if not
> always 100% accurate for the vmalloc case.

OK fair.

>> I've cc:d linux-mm just because i think this is the first
>> user of NR_KERNEL_MISC_RECLAIMABLE in the tree?
> 
> These are fs buffers - shouldn't they be accounted as something that
> reports as "cached" or "buffers" in /proc/meminfo? I mean, if you're
> going to do this to make meminfo/vmstat report the memory usage,
> shouldn't we make the effort to classify the memory usage correctly
> for the user?

I'm not sure. NR_KERNEL_MISC_RECLAIMABLE says it's for
"reclaimable non-slab kernel pages" and that seemed appropriate for
this case; they really aren't the same as page cache?

The commit (b29940c1abd7) that created NR_KERNEL_MISC_RECLAIMABLE
renamed it from NR_INDIRECTLY_RECLAIMABLE_BYTES, and said it was
"still useful for accounting direct page allocations (i.e. not slab)
with a shrinker" so it seemed appropriate but clearly I'm a bit out
of my depth here.

Thanks,
-Eric

> Cheers,
> 
> Dave.
> 

