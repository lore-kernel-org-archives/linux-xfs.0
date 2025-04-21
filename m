Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BC01EF0AA
	for <linux-xfs@vger.kernel.org>; Mon, 21 Apr 2025 20:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745268826; cv=none; b=PgmrRJ5hewKK7gJHZtX/J70FInq0N1KoIEboSOcKieunfkYAf0kEKOtAeUKw6B5qkresGb/AuY1Lflp0jMfsNc9xCPvcdFnrpkfLj11YLJ2WYLBeLJxzVkBKwyV3qSJiEY/dBI2WJ2fbt5IjgEpWnt6G9QRuyH5B6fvrTpSjDG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745268826; c=relaxed/simple;
	bh=uLBwTqXQoexLBnNCz3Cg0anWoUKCBqdw1G0JK1RAZvc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YDvxobehIQaCfkjJwJoL0+C6b4QlMz+pqRpbRBYQjpp0PZslYVCxWEALl1+ZpCJwhqtBaa04TjhaL//oHBNMPgwRypLkvgSD1rBoXo2B7N1Z5K8tHmoGzWt0q2mzA1yNwGAFMLL6Hmau90kYZkPEok/krYll0TT6uulf+PZDtzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gb1Xxx4D; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gb1Xxx4D"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3d46ef71b6cso38263145ab.3
        for <linux-xfs@vger.kernel.org>; Mon, 21 Apr 2025 13:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745268824; x=1745873624; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XGyMbdplm0VqgEXwZTM797av09Qdwt4xl1Ent3Qyi/Y=;
        b=gb1Xxx4D8q8NyHuFASShNuNqJCqeKAmrIB7Bvq6UzIwLzy/XDeJNgAPmybc4v7gkgH
         MpfTDiLRmHGH+ij9xc5znd4UNCihciQXk3qRcZXeMv3PhHWpFGMtsM3YlvUdRAZfAh1C
         VqSPN6s2ymV5jX/fRd31vv4MzIaSu8S+jHsYpw50QqdNGO7ygfBuqTikdzjXIBisjtKo
         5nVm5rElL5pFGdbfbKc6N1t6If155AUlHhhM3KzDuGvuFMkgOhV26P5xg7Rs6K10yZhS
         vublx3V7Vm0Yg3qXA3+pUaTKW2y9JBiniBmSKKLfqoRuIlHHpuD/Ysc98PZg79kQcEMA
         5uPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745268824; x=1745873624;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XGyMbdplm0VqgEXwZTM797av09Qdwt4xl1Ent3Qyi/Y=;
        b=JqToFFyqbJsQVX/P9lIj/x/MXAYqInOmAx2gUUhjio3jFr4skhJTABlLa8GIQiIzOB
         OEby8FuYRmV5+Hq7iqA0M/vBC0T443G6MT81ghlNbpEvhz/xXSlOfVa7yVGL6JKaJnAl
         wBHVUmixp/n6p8kRAbpYZRPZDe2jrcAo2u3SRvYwDc6s6m5hL6tjkznESVxHsXAKIJJC
         O73tCeJZyNY9jUGG5K34c/c3ei7r4QEp0h3whmAR6xz/wss4moOHgOjuGHhq1Jp7IYiM
         yfieoDQ+UhNQ4TdVXfJUMiMC4txIZTngutfXU4c5cqLyuIJjXQwcwX7r+rYfW48VT9pz
         vo9A==
X-Forwarded-Encrypted: i=1; AJvYcCU1GoiuPURu+FsUOvXQjp0rwkvvInPdWM71H5wbN28vC1OvSfE6gR+AfUu8AVZm1EVgo34EKItfTCE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyO83JUQpXlV+C978ISB1pTrvqxliB7phKcexKreHbc4ouxP2us
	LGoLPJauFT712LuBEKhSml0mp0urwxOduzNezyGfp5yXGN+LpB6tEyvMCMQNUTI=
X-Gm-Gg: ASbGncuzeLXXTtxAswxaA+K71vCFy7T5GH3v193gQ+1qdzpieFDol367w6OYLLw1CYd
	GTGYRauK3O/uRxo6rKfKYgiRnDsmdZbo2Qn1lgQlAdxJbbeSlVBMn8C5Y7Tpp/cHjU+hVh5w4iq
	eH08xYJAX+UBoCgkGXxe7HjuWladS+XHD4fVmyDJ+PubB4o1s+yfP3qc7GPkKyWw0R50Lk8uxtt
	/XXOYhn0kmjC1aVJoaZrxuSDKxGbOK0Wg8n+5+f8q96mPlQSWmaIdQPfPAdvRaR+G0EjixVLG9I
	2rdkH21SXZtY/pVWRR3sf8j8k2hlZ5gjM2oyL3KK33/yrI0=
X-Google-Smtp-Source: AGHT+IHvDgGfgDUOOapB200WZpV48HaZ8dVbhYH++As1bmXpZNufg6G1tVLq51Z1vXwqN7Cc8UQGrQ==
X-Received: by 2002:a05:6e02:3002:b0:3d8:20a3:5603 with SMTP id e9e14a558f8ab-3d88eda87bfmr139248725ab.2.1745268823944;
        Mon, 21 Apr 2025 13:53:43 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d821d1d700sm19572275ab.12.2025.04.21.13.53.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Apr 2025 13:53:43 -0700 (PDT)
Message-ID: <c6bcce15-647c-4de8-aa01-6cd3ec5bf904@kernel.dk>
Date: Mon, 21 Apr 2025 14:53:42 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET V2] block/xfs: bdev page cache bug fixes for 6.15
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, shinichiro.kawasaki@wdc.com,
 linux-mm@kvack.org, mcgrof@kernel.org, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org, willy@infradead.org, hch@infradead.org,
 linux-block@vger.kernel.org
References: <174525589013.2138337.16473045486118778580.stgit@frogsfrogsfrogs>
 <8cb99c46-d362-4158-aa1e-882f7e0c304a@kernel.dk>
 <98e7e90e-0ebe-4cbc-96f3-ce7f536d8884@kernel.dk>
 <20250421205116.GF25700@frogsfrogsfrogs>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250421205116.GF25700@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/21/25 2:51 PM, Darrick J. Wong wrote:
> On Mon, Apr 21, 2025 at 02:26:54PM -0600, Jens Axboe wrote:
>> On 4/21/25 2:24 PM, Jens Axboe wrote:
>>> On 4/21/25 11:18 AM, Darrick J. Wong wrote:
>>>> Hi all,
>>>>
>>>> Here are a handful of bugfixes for 6.15.  The first patch fixes a race
>>>> between set_blocksize and block device pagecache manipulation; the rest
>>>> removes XFS' usage of set_blocksize since it's unnecessary.
>>>>
>>>> If you're going to start using this code, I strongly recommend pulling
>>>> from my git trees, which are linked below.
>>>>
>>>> With a bit of luck, this should all go splendidly.
>>>> Comments and questions are, as always, welcome.
>>>
>>> block changes look good to me - I'll tentatively queue those up.
>>
>> Hmm looks like it's built on top of other changes in your branch,
>> doesn't apply cleanly.
> 
> Yeah, I'm still waiting for hch (or anyone) to RVB patches 2 and 3.

Maybe I wasn't 100% clear, but what I mean is that patches 1 and 2 don't
apply to the upstream kernel, as they are sitting on top of other
patches that block block/bdev.c in your tree. So even if acked, they
can't go in as-is. Well they can, I'd just have to hand apply them.
Which isn't the end of the world, but the dependency wasn't clear (to
me, at least) in the sent out patches.

-- 
Jens Axboe
