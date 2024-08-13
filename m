Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633B62262B;
	Tue, 13 Aug 2024 12:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723550523; cv=none; b=JIK+hn+hNSuUCDSasOLZ1QBg7Pd1Qycn2sQiQNvnhXRnJlMObOzkzn4MaAc//pBC8BVrT7s1H/5Oo3qLAYPECfVO0LEtQs9ymmtnb930B7VUbm+tnxmiAUnqWfdsxJ0CZZm5EuRVV8eznZRBzYvl6QpN+l4os9a8TXwd5Bf9ohA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723550523; c=relaxed/simple;
	bh=WoxzxQV1ooQd4sb4UGzBvOFbkbnqQDKsPPMquAA7wMk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O6jHdAf3kaCajlOc3ZS7c8rY9M6IAn9s0C3hUpYSf+uotNoXUrUubDjrFnfROjj4/9SvUwQfTiuN+aUMUqJTMy8x5+mwHL9oJZ8Hxjvz3+2XmR/G8QZWms/OLpKChgbsX4JiZ6BQrrtAd9Zf0ygMHGmtrkLLsnFHKzv1CNZszcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gYeUvquH; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gYeUvquH"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6bd777e6623so22924236d6.3;
        Tue, 13 Aug 2024 05:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723550521; x=1724155321; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8lKe2IZzXANr7tMnM64bs7C7lJQXJvi3Yh98xyr+R3c=;
        b=gYeUvquHYNQBpUOsoOkqJcRzAtuBymqC0blwoMv3DIMbE5tUOZSCTSg9wczSFyUJ/o
         jAkySvXOHverIhdPgpChQmiUsH0mFtCguDqUdzEPQEo5WtKpaAJgujChIv+LhqvDfivT
         cOAcVKycuS/COd281hAlwsbAn+SUw9ZLlM+Eg9nvcdrCBf9m0up5gOvfymxd3wJ15iNO
         F5dOUrnmGFne18xXf8dDDbQ7WFje330INo3I6Lq08i0G6MO8k6DZhrOZxoW/MDQVsCMp
         TyhMUC8aZM+j7P0Ob20cRV5LHrJBje9fZjo+iAgLuku189xsNkA92ZMBQCanZI1uMRfr
         sk5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723550521; x=1724155321;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8lKe2IZzXANr7tMnM64bs7C7lJQXJvi3Yh98xyr+R3c=;
        b=mGiNqOtoscoW+OZT8bRJcI1YXppXCvSTOyq/SFfzYv/bCRNfP1Dv3B+aa4Pgru3kZl
         uZEakReEtlCT2aPHfRY+Z7cBoSZK9fQ2bAFtToFzOtFLbr7JFjaAcT+13XG2kfOoZN97
         u51i+5EKKRFWbV1ttrxfDe7YycRnRwIhTC/u14uGckyIgXB+MDngJuj9WZG+kW8UTdI8
         FlSe46oaTK+6INLm4X2NTHx7ACiyvFimvyWPTwta5nm95JfHBdPR+6MbzHAoJH2YnYKr
         mLhXQMLK/BxeaOatfyEUTFnwWoonVobUSAfMV15TXFWK9kGkPryA+O2sOt6HEIufXFWm
         bM5g==
X-Forwarded-Encrypted: i=1; AJvYcCUtrvHkcAY/uk0CeP3Sl27gNIpceWO/MQrNbUsB5GG/nwPGTXZEWvyYBXhvNVXIFGNKp8jqyioWvjcfXDjUoiLJ1du4ifkprouJap8J
X-Gm-Message-State: AOJu0YxOctsBiGHG0a2i+HwCeZ3R8kgh+zuveYe7enuhltEOgMcBFzvd
	PehGVhgt7IIl+NT957+KE2qPpMz/8M01Z8t3QV33nlNLEipqQMCc
X-Google-Smtp-Source: AGHT+IHHvzj09SebJbcuJ/1mNymCt6orZzcJ2wp/qIiGAqZtLn1D+Y2//gKE+pHCoWmXVK8igCX4Fw==
X-Received: by 2002:a05:6214:5507:b0:6bb:a0f6:8b32 with SMTP id 6a1803df08f44-6bf4f7de658mr32844146d6.33.1723550521072;
        Tue, 13 Aug 2024 05:02:01 -0700 (PDT)
Received: from [130.235.83.196] (nieman.control.lth.se. [130.235.83.196])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bd82e6db59sm33111936d6.143.2024.08.13.05.01.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 05:02:00 -0700 (PDT)
Message-ID: <6766edb4-2f56-4b52-9e6d-343ae00d6957@gmail.com>
Date: Tue, 13 Aug 2024 14:01:57 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: XFS mount timeout in linux-6.9.11
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Chandan Babu R <chandan.babu@oracle.com>, "Darrick J. Wong"
 <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>
References: <71864473-f0f7-41c3-95f2-c78f6edcfab9@gmail.com>
 <ZraeRdPmGXpbRM7V@dread.disaster.area>
 <252d91e2-282e-4af4-b99b-3b8147d98bc3@gmail.com>
 <ZrfzsIcTX1Qi+IUi@dread.disaster.area>
 <4697de37-a630-402f-a547-cc4b70de9dc3@gmail.com>
 <ZrlRggozUT6dJRh+@dread.disaster.area>
 <6a19bfdf-9503-4c3b-bc5b-192685ec1bdd@gmail.com>
 <ZrslIPV6/qk6cLVy@dread.disaster.area>
Content-Language: en-US
From: Anders Blomdell <anders.blomdell@gmail.com>
In-Reply-To: <ZrslIPV6/qk6cLVy@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2024-08-13 11:19, Dave Chinner wrote:
> On Mon, Aug 12, 2024 at 03:03:49PM +0200, Anders Blomdell wrote:
>> On 2024-08-12 02:04, Dave Chinner wrote:
>>>
>>> Ok, can you run the same series of commands but this time in another
>>> shell run this command and leave it running for the entire
>>> mount/unmount/mount/unmount sequence:
>>>
>>> # trace-cmd record -e xfs\* -e printk
> 
> [snip location of trace]
> 
>>> That will tell me what XFS is doing different at mount time on the
>>> different kernels.
>> Looks like a timing issue, a trylock fails and brings about a READ_AHEAD burst.
> 
> Not timing - it is definitely a bug in the commit the bisect pointed
> at.
> 
> However, it's almost impossible to actually see until someone or
> something (the trace) points it out directly.
> 
> The trace confirmed what I suspected - the READ_AHEAD stuff you see
> is an inode btree being walked. I knew that we walk the free inode
> btrees during mount unless you have a specific feature bit set, but
> I didn't think your filesystem is new enough to have that feature
> set according to the xfs_info output.
> 
> However, I couldn't work out why the free inode btrees would take
> that long to walk as the finobt generally tends towards empty on any
> filesystem that is frequently allocating inodes. The mount time on
> the old kernel indicates they are pretty much empty, because the
> mount time is under a second and it's walked all 8 finobts *twice*
> during mount.
> 
> What the trace pointed out was that the finobt walk to calculate
> AG reserve space wasn't actually walking the finobt - it was walking
> the inobt. That indexes all allocated inodes, so mount was walking
> the btrees that index the ~30 million allocated inodes in the
> filesystem. That takes a lot of IO, and that's the 450s pause
> to calculate reserves before we run log recovery, and then the
> second 450s pause occurs after log recovery because we have to
> recalculate the reserves once all the intents and unlinked inodes
> have been replayed.
> 
>  From that observation, it was just a matter of tracking down the
> code that is triggering the walk and working out why it was running
> down the wrong inobt....
> 
> In hindsight, this was a wholly avoidable bug - a single patch made
> two different API modifications that only differed by a single
> letter, and one of the 23 conversions missed a single letter. If
> that was two patches - one for the finobt conversion, the second for
> the inobt conversion, the bug would have been plainly obvious during
> review....
> 
> Anders, can you try the patch below? It should fix your issue.
Works like a charm! Thanks for the help!

I take it that this patch goes into linux-stable (and linux-next) quite soon!

/Anders
