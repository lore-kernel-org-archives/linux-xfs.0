Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348981EDA08;
	Tue, 22 Apr 2025 06:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745302971; cv=none; b=rmQQIU5QkCOE7dy7spSIjOy2F8tRFcOdmYr/aKXc6Q8FBJ+Cx5qaB9gfKKRNKkwyft/2532zblmMMcRS3yDl5f3JXw25+iSCPSnJmBzI6bNZV6elGeryb1oLEl/LGa84Lyq/S9W6s7aB/AagIAQhIateb9dANWe3ZoSjKSf+Oj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745302971; c=relaxed/simple;
	bh=8ZCoI2lqt4CjT+O1++Xd0dg+rCnn/cdYch+N7ibzs+4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YDhBWlwUTO5ictXdNI/gg6ThrUlxqY6pJlXmI/7ZU6lwSK5NB+qhNSN3awT8kGaDoAX5avvLTkcMJ1GgTotu/mVv7yTuase5Hyj12fwBgqCD+Hn0l6F1dG0UM5EgeAlCeC3gq5PubmdluvcFoefg0tcq/W/TrsvaAmOL6OLy+vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cu14uHrV; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cu14uHrV"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-736ad42dfd6so4007405b3a.3;
        Mon, 21 Apr 2025 23:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745302969; x=1745907769; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=bXUp6y/+R9kQOKY3Ed4LH6FsiF29kWz5b9SOb0K1PKs=;
        b=Cu14uHrV8c3tAN7875sStei4xBMfv6YvnaGnf7HKKIKVQyfj9i7RPwJIMrxhoIk4PS
         QAMZig49oUUaLi/UFSch2/P6vNRffBjBvd71rUndxKPF3Dkk2LryTzw5kkNaLKpPMNOa
         Z5IBuXHWBdULTYaBBdDPCs/CPCdCGs6XI9mSTxLhj+zG5ZCnxbgz/90kq2Iger1fipDr
         CQJS1T8hpNZPmu7Zz43V/IJOVDfvXjMb71sp9yENOaQ3vm/608/GUOrZuVt42jjY3DzM
         YvVFRYXNgJ6f8D5aGTA48ZJ84nrPXXnHRlgloG6F6aVg34nx13vvZRu9w46zRhu0hj9K
         zePQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745302969; x=1745907769;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bXUp6y/+R9kQOKY3Ed4LH6FsiF29kWz5b9SOb0K1PKs=;
        b=Py2CgQm/ofick3IV5gWw+xkiSrjwSwYzwtdN3jj+fLavLwTWTYG5ozT50ta3Rqh3Z0
         4KtVKdBEb3zkgfy8iz6IkxWOaH1EpMyLabsdb8R/X7GiyJIjA0Oj4YevFeakynDJ1ENk
         ghXoXviZfOP2SESEvLDX3WKWz22RHF+DXkWTsqA6oUZYg9pzXKVhnKIclqYUFBN+50H6
         ZpW+zDQs8SdFsOf+XnvrFAjgYm7sa/w7tgSf2VNVJmd5wRKNhCbTM8dk0gl7hBjhTAXH
         zeIdwYKXT6Rj3i8Y5ZksUN28I9+ijAIXhDhFFbjtYZNI4VtHPyX6tNNalM8dGRpOQ6ZU
         Gg8Q==
X-Forwarded-Encrypted: i=1; AJvYcCU2ROxagc6bOca+a4criFO9DoZzmPZByWHvc9VQNTPGOsxD6XLbI82hwR0SrMY6bqfYbzsgr5kdUVbs@vger.kernel.org, AJvYcCVp5PG7KRiH8642S0hNAetWliS0QccR18yVJ1ytSdZXYBdJq2eg1KRUjX0bMxMCEHCrgioSyOcvJ5BygCQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywo6mRQiYBegRbPF4MbOhWpaBj81WkiZ4F2IZvoVEGymdezUcmc
	82TTJZkbUT0k78vRjBLftFygwRbepDyHs9PpW1QfxcepOs0Ze4ni
X-Gm-Gg: ASbGncvtp519dCV82JzTND/HmGUbnAlo2HK032/GxIfpBUOzCiICEZZcWrlt1t8dpLZ
	51gwh6gn1IEvAzWU/8cv/aYZSC+5+7xatjsDJWNQsuBmglbSmtw/qMCVZEv0fpz04YMtzEMqXYM
	8VE2MBeH8D/ZYkEGa/kbxr4mdeYFBm0dOWHYrpi8ioSW8Fr++qPvl7JazitJROWmpgwGObaJvik
	ZBu/aGB9wLaVyN7lvK3tLaA4a0r+dj+D/1oG1W2I8TPjENSi4VSyMYaPjCtoSKZqQCULSP1cNEg
	AFGgi7ZjdE+5siuU218mzN9y1tark0yDPy8kXXdZf/goB23l0/hkQ3adQpwix/R1Nv4lMBzWnAK
	O+U5xthMyhnvw+eDWkwg7nK0i
X-Google-Smtp-Source: AGHT+IEZ9Dao93TgMe34wAWu9BRLrmTdXBU6FAiDvqVhjuAR39MHcoU8Z3hzdHgrNdPsYnhMMAkwaA==
X-Received: by 2002:aa7:9306:0:b0:736:d6da:8f9e with SMTP id d2e1a72fcca58-73dc119fb18mr20048620b3a.0.1745302969307;
        Mon, 21 Apr 2025 23:22:49 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73dbf8e3cfasm7748711b3a.40.2025.04.21.23.22.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Apr 2025 23:22:48 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <9a3cd21b-5b51-4aae-9f04-2a63f3cc68d7@roeck-us.net>
Date: Mon, 21 Apr 2025 23:22:47 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: add tunable threshold parameter for triggering zone
 GC
To: hch <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <Hans.Holmberg@wdc.com>,
 Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <djwong@kernel.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20250325091007.24070-1-hans.holmberg@wdc.com>
 <iB7R4jpT-AaCUfizQ4YDpmyoSwGWmjJCdGfIRdvTE76nG3sPcUxeHgwVOgS5vFYV0DCeR1L5EINLppSGbgC3gg==@protonmail.internalid>
 <476cf4b6-e3e6-4a64-a400-cc1f05ea44cc@roeck-us.net>
 <mt3tlttnxheypljdkyy6bpjfkb7n5pm2w35wuf7bsma3btwnua@a3zljdrqqaq7>
 <e5ccf0d5-a757-4d1b-84b9-36a5f02e117c@roeck-us.net>
 <20250421083128.GA20490@lst.de>
 <c432be87-827e-4ed7-87e9-3b56d4dbcf26@roeck-us.net>
 <20250422054851.GA29297@lst.de>
 <c575ab39-f118-4459-aaea-6d3c213819cb@roeck-us.net>
 <20250422060137.GA29668@lst.de>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20250422060137.GA29668@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/21/25 23:01, hch wrote:
> On Mon, Apr 21, 2025 at 10:57:31PM -0700, Guenter Roeck wrote:
>>> free should be floored to zero, i.e.
>>>
>>> 	free = min(0, xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS));
>>>
>>
>> Do you mean max, maybe ?
> 
> Yes, sorry.
> 
> Also if you want the work taken off your hands I can prepare a patch
> as well, I just don't want to do that without approval from the
> original author.

I didn't actually plan to write a patch myself. I thought that either
Hans or Carlos would do that. Sorry if my replies caused a misunderstanding.

Guenter

