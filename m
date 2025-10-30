Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5D8330B20
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 06:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761807227; cv=none; b=eMVZ81cHgzMkRjW4iLrv27c/qmlY4Usz75O8N94Ex0Crg5xLj06jTbji09F3MXgFz+tPsgFX+TDgr9xcqNPEvCK7UihShb0LvI5jTxP2O1KHog6dCpqGVyfp9j+0K5iq4lOx7vOCHzgVLVqIOBaqbeNZdeCj7tvz1NIuN7dktuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761807227; c=relaxed/simple;
	bh=qXHx/nT/qZjdrxmThc3MLeYmmngjwAmO4ugSN42nCY0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NufucFnHvg+9Ka3/Y1pph09og8lNc8Ygy/5Cmh4Nb4Zpwsa+sZAqOA0l97HqILvtNvFmMti2UnpYbQNzB10qXitik1Q2JKl01GX0DJhQoz1zCBHAM/OqCZgiwCvSpL0eUBYQ1PEpJ4owbrjUEKhpsQ2IdY/GWYxuljTF425+MkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LKPmOFtR; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LKPmOFtR"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3ed20bdfdffso599705f8f.2
        for <linux-xfs@vger.kernel.org>; Wed, 29 Oct 2025 23:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761807222; x=1762412022; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=spaiIJRDeLO8qql3bA4ah50+w7VcfliYUjhE/5FZ+4M=;
        b=LKPmOFtRHgudKWQ8MjmGjAuDVzuvQsIyRWZaSbIFopmL20gMfZ+pW39gduNoCHl1eF
         SZiJgOX+Vr+ihFxh79BohaT82CfbH9Q/3vBgI1W7v5FtO/oqOnR6uvdHBBIpFJl2pWLK
         btRAZ0Uf1EGq7m8oN70+NNoBYO0KSPkii5tl3X/eXe01kpYt49gL3JGg0/OkU9FCEEie
         ERAHd8OHuxt/+w6B25khsnhHEXQR+tCrqM903GoRlY8A3RgK+AhOXvqMKEs6nWLIyba+
         PZxxwErEOYi3RWz7EV8k4S958V0kFTEgzsc76Ptu6hR+LhNbP/P2b9g7CsJTvVz9hACs
         PRdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761807222; x=1762412022;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=spaiIJRDeLO8qql3bA4ah50+w7VcfliYUjhE/5FZ+4M=;
        b=HJh2SHLBW4pspMoA4Iep7yRmoT9Jomc9IV7CzhYO4ZTWBH0h1Pq0yyJ0FDsRba5nJG
         OVG3DeVFQgbTZ3QLJbzgiF6yiR58A/fjzTXjsl42TQ8QnRy1sHQZEXpBE+oGRpe+HLu4
         XLm4KE+Ftv+hOdjobfjmHOV7ZkUEM8T6rS2nN0ua2SMdo+q5IAduVY/rhyVTzXRyyz0l
         kjgV6bPpLMz1L3A2TbXhQ1KOUZmPSQcWM48jFWE4DfJr9ogNCQ4GOqBe1UsKb0G8y5f2
         7ifmf7t3G/r/rCPlSEqi+mOHfk6NIR5VYRwZNCwUN3/MAuEXmKbxVpA9ikUpaPiLlqCv
         q4uw==
X-Forwarded-Encrypted: i=1; AJvYcCW1oCTqQbcq3C/04+vHQBNivC+aFWGok6K6DL4yPjBRrvhbCNqJ/kzo6GBmmy22AbxsWKZIzyDVHm4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtfSr8Klqyu1rbWkbjVNMNQtiKqcBCikGTbi7e/svYo+u25ZkZ
	DJQLHVI3xdR2gmtdF7bl2UO9Bby7u78aTyBm8q1UWE64Gpwa3yjV4hMvGuOjKqKFBJE=
X-Gm-Gg: ASbGncswiOVPdFPBLA7+xYr59l5CO89gDkmkV24+32nRbTw2eRlZK4FfW5y9lFQgasX
	K/tBjCiG9kRNCmLjdqxZ83j/trPy1JNxnKImIA4a2cV0qliG4reHDKRhOdRvrmcNyAYLlgC5rex
	wi6uxy89P+t9byWt6fCGFXuVW9dF9yCbfID8u2eKTZVJSaPKU+lVwDiz3e5pr5jeHr0GjtG+Ht5
	7tPuSo2eEyXMbOw0hIXnAVbBlLeAVd4lTBYdjLo0MWxMGkuVhi976sNSgCiwL4X37RXFRs1cFj1
	ZvOvpC/r5D1t06bBE+dfyeCdQFqSFcyagCRVq4WqaHohV5wV7tFR5yO+MjpuzD85iDU8eisl/HO
	R5I9z5cJu5zRhBhR7fJ0PgKA3De/dEIPrAkUmuIojrqnxrxQW9r1qX/uZ4MdjF/a0Y1aGfm/IFl
	k3rHBoc842bflxUXFtK0pBty0d17pQ
X-Google-Smtp-Source: AGHT+IGuyA1xrlmXYXQ1Yx0rW63y51Ujb1gDH99TS1bXYeBdhPsZDhgqJaLMAea312NaYFO3cs4sPA==
X-Received: by 2002:a05:6000:18a9:b0:3d2:9cbf:5b73 with SMTP id ffacd0b85a97d-429aef75eb2mr3899135f8f.6.1761807222300;
        Wed, 29 Oct 2025 23:53:42 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a427684bddsm14144800b3a.31.2025.10.29.23.53.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 23:53:41 -0700 (PDT)
Message-ID: <a44566d9-4fef-43cc-b53e-bd102724344a@suse.com>
Date: Thu, 30 Oct 2025 17:23:32 +1030
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] xfs: fallback to buffered I/O for direct I/O when
 stable writes are required
To: Christoph Hellwig <hch@lst.de>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20251029071537.1127397-1-hch@lst.de>
 <20251029071537.1127397-5-hch@lst.de>
 <20251029155306.GC3356773@frogsfrogsfrogs> <20251029163555.GB26985@lst.de>
 <8f384c85-e432-445e-afbf-0d9953584b05@suse.com>
 <20251030055851.GA12703@lst.de>
 <04db952d-2319-4ef9-8986-50e744b00b62@gmx.com>
 <20251030064917.GA13549@lst.de>
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
In-Reply-To: <20251030064917.GA13549@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/10/30 17:19, Christoph Hellwig 写道:
> On Thu, Oct 30, 2025 at 05:07:44PM +1030, Qu Wenruo wrote:
>> I mean some open flag like O_DIRECT_NO_FALLBACK, then we can directly
>> reutrn -ENOBLK without falling back to buffered IO (and no need to bother
>> the warning of falling back).
>>
>> This will provide the most accurate, true zero-copy for those programs that
>> really require zero-copy.
>>
>> And we won't need to bother falling back to buffered IO, it will be
>> something for the user space to bother.
> 
> So what is your application going to do if the open fails?

If it can not accept buffered fallback, error out.

If it can, do regular open without direct IO flags, and may be even open 
a bug report to the project, questioning if they really need direct IO 
in the first place.

Thanks,
Qu

> 
>>
>> Thanks,
>> Qu
> ---end quoted text---

