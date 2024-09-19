Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6891CD16
	for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2024 04:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721173; cv=none; b=V3+f36TNP5RASXZ4Rqk5cR0m9pBRTr3kEDeGgmUkbP1KsNuO0gWUOh+O9ETahBGVfU8GI72pgdpHc9qGbqOZxWBVpNWE6MTEU+x1syL2kjhWdbsiGjhrNc5cThC0WXmKbADDGcXE85cRNJfayz0bYV1UGCDHHTY+lOSXuseWfIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721173; c=relaxed/simple;
	bh=WMbmOVlDj4J4YNccxGu39IJJ/C4FQWTMH+hmZ5SW1LU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CJ2sFx6JHk89xiCImXQhDu4Ex7WjUetMVGQk8jrRZdLgUekn4IitMTeyF2SiY9V77xRxIfqsaPfbggHKNKYpDRhKzYTPtRIiIbjJzuPikjojiuuB/uYpq5AjzXLmvD0AVQC3ePN7luCxN1F6pUkBDCP+Uw46ogWp8aVW6pVn/ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LvpaB65g; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LvpaB65g"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-42ca6ba750eso2420635e9.0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 21:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726721169; x=1727325969; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VKK0K7oF92qoXvqUn1Ads4k++5P61ZhpT/0tIxiVX/Q=;
        b=LvpaB65gHFePTq1PweMA2DNsx28qPCWPeWrO01NuCLoaZvTMsRgbW4rHeDG10pryzV
         emv24S4SdK1e+D1fOgLQsNR5aa+tbteKhyWNIdbu7tmnhUVSfjmxPfoAHNc3FYfaEXlI
         3by77OS3Ne84Rk6q+HPcvU2HmuKED4x6CnvGKFnJLqOQibU+YUA8KV77vZ+OJKa5/N4N
         VkJhkqGjxKk3XeSAxIflbRc/FeetSBCSkjWfxDXrKvIYmYoLI1I0KhrEYtW6W4v6kn5d
         Aaz7tpEEDKq8XpDqs+ugnO2qNaFbeqII18Vw8PgERvZy0NKSfrAvjuGesvXpwcuz6LmP
         ciOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721169; x=1727325969;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VKK0K7oF92qoXvqUn1Ads4k++5P61ZhpT/0tIxiVX/Q=;
        b=EbgQ6fDx2UOT05h00AzloqEYyjVZ89dE7wXr9xp7AVDeioWlIWYUYsNcVEP29vHMB3
         ByVY5ZmaqysG+O0RkG7d31BhoAQn1RXzj9iNYw1ERD2Q9zo3EhVboH7Kk/FyQHfyqlRp
         0LFJOULuNISpngas19Cs46Gl+AUEZQOuiUIm0l+srD+Q2eJTOaTqwZ2vqJcUxptg9V6A
         DYKm5E6uYnag915SACGm1dlPg1Rl5LfzRLvczS+vhD2jwc+R/ZQAEasGZYHcjYRuS/ii
         TO8e+Is6Bi/gX9YeUQiILZi7mbQJM/LDGlNCSk411QIsmc5I6f4E7gs7v+TL4oL13adA
         06lA==
X-Forwarded-Encrypted: i=1; AJvYcCVqGA/hufDNLYN+urYsQc5aeRfl476gJk8kV5a+doUB5N48KVBzH5W2StTsmCRGMxt8/p1k8XUec3o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHdrgKB6IHmUx0/CowNuKmgJSB6ilFXZDbqGVmM2Ff2r30UsId
	5DWMlbMD+vo+hHT65cFRCwObmJegwurZOlHmRixGboOFf5Kv+Kjwzl4Ca6Drk84=
X-Google-Smtp-Source: AGHT+IGHHVaBDfu7IHVrU1p7r2GdHKFQUmAh5YFVoOfSzfC5RVAziHBMEMJBUvybKuiAcnw/DiY4EA==
X-Received: by 2002:a05:600c:1d02:b0:42c:b68f:38fb with SMTP id 5b1f17b1804b1-42e74417444mr9041015e9.7.1726721169038;
        Wed, 18 Sep 2024 21:46:09 -0700 (PDT)
Received: from [192.168.0.216] ([185.44.53.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e75445a98sm10823905e9.28.2024.09.18.21.46.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2024 21:46:07 -0700 (PDT)
Message-ID: <9e62898f-907e-439f-96f3-de2e29f57e37@kernel.dk>
Date: Wed, 18 Sep 2024 22:46:06 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Known and unfixed active data loss bug in MM + XFS with large
 folios since Dec 2021 (any kernel from 6.1 upwards)
To: Matthew Wilcox <willy@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>, Chris Mason <clm@meta.com>,
 Christian Theune <ct@flyingcircus.io>, linux-mm@kvack.org,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Daniel Dao <dqminh@cloudflare.com>, regressions@lists.linux.dev,
 regressions@leemhuis.info
References: <ZulMlPFKiiRe3iFd@casper.infradead.org>
 <52d45d22-e108-400e-a63f-f50ef1a0ae1a@meta.com>
 <ZumDPU7RDg5wV0Re@casper.infradead.org>
 <5bee194c-9cd3-47e7-919b-9f352441f855@kernel.dk>
 <459beb1c-defd-4836-952c-589203b7005c@meta.com>
 <ZurXAco1BKqf8I2E@casper.infradead.org>
 <ZuuBs762OrOk58zQ@dread.disaster.area>
 <CAHk-=wjsrwuU9uALfif4WhSg=kpwXqP2h1ZB+zmH_ORDsrLCnQ@mail.gmail.com>
 <CAHk-=wgQ_OeAaNMA7A=icuf66r7Atz1-NNs9Qk8O=2gEjd=qTw@mail.gmail.com>
 <8697e349-d22f-43a0-8469-beb857eb44a1@kernel.dk>
 <ZuuqPEtIliUJejvw@casper.infradead.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZuuqPEtIliUJejvw@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/18/24 10:36 PM, Matthew Wilcox wrote:
> On Wed, Sep 18, 2024 at 09:38:41PM -0600, Jens Axboe wrote:
>> On 9/18/24 9:12 PM, Linus Torvalds wrote:
>>> On Thu, 19 Sept 2024 at 05:03, Linus Torvalds
>>> <torvalds@linux-foundation.org> wrote:
>>>>
>>>> I think we should just do the simple one-liner of adding a
>>>> "xas_reset()" to after doing xas_split_alloc() (or do it inside the
>>>> xas_split_alloc()).
>>>
>>> .. and obviously that should be actually *verified* to fix the issue
>>> not just with the test-case that Chris and Jens have been using, but
>>> on Christian's real PostgreSQL load.
>>>
>>> Christian?
>>>
>>> Note that the xas_reset() needs to be done after the check for errors
>>> - or like Willy suggested, xas_split_alloc() needs to be re-organized.
>>>
>>> So the simplest fix is probably to just add a
>>>
>>>                         if (xas_error(&xas))
>>>                                 goto error;
>>>                 }
>>> +               xas_reset(&xas);
>>>                 xas_lock_irq(&xas);
>>>                 xas_for_each_conflict(&xas, entry) {
>>>                         old = entry;
>>>
>>> in __filemap_add_folio() in mm/filemap.c
>>>
>>> (The above is obviously a whitespace-damaged pseudo-patch for the
>>> pre-6758c1128ceb state. I don't actually carry a stable tree around on
>>> my laptop, but I hope it's clear enough what I'm rambling about)
>>
>> I kicked off a quick run with this on 6.9 with my debug patch as well,
>> and it still fails for me... I'll double check everything is sane. For
>> reference, below is the 6.9 filemap patch.
>>
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index 30de18c4fd28..88093e2b7256 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -883,6 +883,7 @@ noinline int __filemap_add_folio(struct address_space *mapping,
>>  		if (order > folio_order(folio))
>>  			xas_split_alloc(&xas, xa_load(xas.xa, xas.xa_index),
>>  					order, gfp);
>> +		xas_reset(&xas);
>>  		xas_lock_irq(&xas);
>>  		xas_for_each_conflict(&xas, entry) {
>>  			old = entry;
> 
> My brain is still mushy, but I think there is still a problem (both with
> the simple fix for 6.9 and indeed with 6.10).
> 
> For splitting a folio, we have the folio locked, so we know it's not
> going anywhere.  The tree may get rearranged around it while we don't
> have the xa_lock, but we're somewhat protected.
> 
> In this case we're splitting something that was, at one point, a shadow
> entry.  There's no struct there to lock.  So I think we can have a
> situation where we replicate 'old' (in 6.10) or xa_load() (in 6.9)
> into the nodes we allocate in xas_split_alloc().  In 6.10, that's at
> least guaranteed to be a shadow entry, but in 6.9, it might already be a
> folio by this point because we've raced with something else also doing a
> split.
> 
> Probably xas_split_alloc() needs to just do the alloc, like the name
> says, and drop the 'entry' argument.  ICBW, but I think it explains
> what you're seeing?  Maybe it doesn't?

Since I can hit it pretty reliably and quickly, I'm happy to test
whatever you want on top of 6.9. From the other email, I backported:

a4864671ca0b ("lib/xarray: introduce a new helper xas_get_order")
6758c1128ceb ("mm/filemap: optimize filemap folio adding")

to 6.9 and kicked off a test with that 5 min ago, and it's still going.
I'd say with 90% confidence that it should've hit already, but let's
leave it churning for an hour and see what pops out the other end.

-- 
Jens Axboe
