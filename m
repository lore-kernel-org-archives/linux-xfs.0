Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1268E2E2EEE
	for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 08:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761034551; cv=none; b=usQENNDsc9jRek7H5AcFJpsiO4+wtbqN/z8z9PBVWSU4QgnkyA5rmR57x5RaASUgQkjWe76oXDnxI6Uxmf6t/iVIOcdz/aQs0VgQz4eYWmZJlwBPwQ1xGRo5R3nRftrWGIjmubZf30MxYyskPJWSWJ5ayt0yzTJSGghcT916ob4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761034551; c=relaxed/simple;
	bh=zVftnVBzK8rt+bdggo8IGbxD/AJcc2cHbCdfPnYtwWM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XaQp0t90bWD8/GJe9SQu22zP49/AqSTXIu0Xspnrs89zpEInZBcTlrAk/7A5S6JCagRGfbKdgWixpPkJTatTGEpiW1kse2Fbkf6T3VXhD1GMLsKNulAbOjYn1aYXOS9stF1GisAz6fdhfsTrkU9mL5hDkNDtW65rCuegVa0dkO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WdMA9tFm; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WdMA9tFm"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-426fd62bfeaso2383695f8f.2
        for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 01:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761034546; x=1761639346; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=kHcZuzFp72N7RUBqQIuIU6WTtqLSl7qFxgRoCA9ftI4=;
        b=WdMA9tFm7VuQZIcV3jB3wZS31vjAkMWLYPFvm8ruZAE2sB0XIHJDzrHvzzuc5xiI7U
         ddo1uRSWKe9V5ENjaQE4NlMo/oSabyhGtEDGBoD52/VWkBQIVwe5oIFTPbZD/fh/dtzp
         Il8zFnpqYBCTZM2ZRyCtJpJg2Cupkj54towPZpFz5+HcVRVsWdWWkXZAhOuF/0p8zxsB
         8q8lhHhaK/NkCiyOjflAdO9T89AphH/wLVZsDudzoorTIiguJsf8XkLYZrJrsQgfj3hK
         eW52cWXWiF6ZjHKvtyWFAzzLcqRsmfeC1SQHVdW7N7Qnu+l8AwJXDriCtAii5t0Y+0cc
         anDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761034546; x=1761639346;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kHcZuzFp72N7RUBqQIuIU6WTtqLSl7qFxgRoCA9ftI4=;
        b=mXbNvQ3A4xso0Y5tI9OQ6jCXRKqJMawkDehSk5SheV54A6VRQ3+aSxtkzm0/r6PSRt
         fWUqUcKvNHdOabB13S5glwnVhtBtz2Ge5OVD1DrN1xgxyqUqD+4FIjp1UkVDCfN9q162
         S0mswJNmaYq5aJCW+TG0CxfS6hoR4i0anLrXyIDrswi5f7/XTV/Ohz1D2j3HlCFO7HMn
         iC1A1RCpJLUyNW+VylIMfdzLzZuP3hyKDSWsnSI2MlKUuCuFNADMd4QSp130pYzh+Q1q
         8QEN/c0EwjsPlecMKZTAG7lA3mG4f2qyWDW/dILuMK3JwdhJ3hSNRzaMHfrkv0Kw7ZX+
         usBg==
X-Forwarded-Encrypted: i=1; AJvYcCXUdqW+nqyCeR4PMQYsH1uTO8V9QomEhjfWT3JYMda7AACzieAvHuik6zrdfzll1lHHtiIbyTzofa0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwC/E+N5pfB9cHhjr6st3wWm5vXCNZMhkrWK/RJkW2mIyC2RB4d
	zqwhGqsQr7NFMmo2qLv5yFq3f3ViMmIxR0GDy7U0leI5+TVkCJtroagCttsE1f8gFtQ=
X-Gm-Gg: ASbGncvh2w4ywJQxFaLSYwvUJdSQdsuoh2tcLwpDnsVZT1kaJhLN3xIn4hWmFOQUqdC
	eDRFLdhGQEPEKqWF/tLwFRfxWxwBInMm5xJ8ReGteZhIu52prTDVk692nRnKVIUQwI+zYt2GI7F
	QJyz6EOy+vr6sDNcCXBH1VJiB3UyjrjbxifkIvDHoJVOqWjaq61IS9SwarT1wbjOYEmyzx1gCrZ
	wx0mSI2Z2V5fo9LxXdAaQYNqbFYn+ohGc4beXNg5ZlGT4SeOlx84Jvq7UaLFyK7fG1S97DjAP/p
	151iit0MzJHubid64EslNaib2iUgT28bAzWyprXaOOD1p8tclTgAUpgAR50UPLyh4GTvg9wtMCq
	c0tJ0Mb1M/br24ypHBQDHsxIfoRiDPxqGQm8Z4CTphYsjEzeBVFv6afXeSEYezZ69SfFe8h8MAT
	kfusueQpjFLhunV1buaEnRyuJNJ6h2NgXwZ5zFo6U=
X-Google-Smtp-Source: AGHT+IFaWIBoJi3XK2l2Na+ZDX2sj+oZzA5h4ZX6OeFEPtXSgG1fCm9Tbf7ohSg/qKEJQ1ymWULiPw==
X-Received: by 2002:a5d:5d08:0:b0:427:a34:648c with SMTP id ffacd0b85a97d-4270a34652cmr9043168f8f.58.1761034546186;
        Tue, 21 Oct 2025 01:15:46 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff4f779sm10584512b3a.32.2025.10.21.01.15.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 01:15:45 -0700 (PDT)
Message-ID: <4f4c468a-ac87-4f54-bc5a-d35058e42dd2@suse.com>
Date: Tue, 21 Oct 2025 18:45:37 +1030
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
To: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, djwong@kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-mm@kvack.org, martin.petersen@oracle.com,
 jack@suse.com
References: <aPYIS5rDfXhNNDHP@infradead.org>
 <b91eb17a-71ce-422c-99a1-c2970a015666@gmx.com>
 <aPc6uLKJkavZ_SkM@infradead.org>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <aPc6uLKJkavZ_SkM@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/10/21 18:18, Christoph Hellwig 写道:
> On Tue, Oct 21, 2025 at 01:47:03PM +1030, Qu Wenruo wrote:
>> Off-topic a little, mind to share the performance drop with PI enabled on
>> XFS?
> 
> If the bandwith of the SSDs get close or exceeds the DRAM bandwith
> buffered I/O can be 50% or less of the direct I/O performance.

In my case, the DRAM is way faster than the SSD (tens of GiB/s vs less 
than 5GiB/s).

> 
>> With this patch I'm able to enable direct IO for inodes with checksums.
>> I thought it would easily improve the performance, but the truth is, it's
>> not that different from buffered IO fall back.
> 
> That's because you still copy data.

Enabling the extra copy for direct IO only drops around 15~20% 
performance, but that's on no csum case.

So far the calculation matches your estimation, but...

> 
>> So I start wondering if it's the checksum itself causing the miserable
>> performance numbers.
> 
> Only indirectly by touching all the cachelines.  But once you copy you
> touch them again.  Especially if not done in small chunks.

As long as I enable checksum verification, even with the bouncing page 
direct IO, the result is not any better than buffered IO fallback, all 
around 10% (not by 10%, at 10%) of the direct IO speed (no matter 
bouncing or not).

Maybe I need to check if the proper hardware accelerated CRC32 is 
utilized...

Thanks,
Qu

