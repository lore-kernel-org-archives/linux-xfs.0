Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568E51E9B3B;
	Tue, 22 Apr 2025 05:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745301456; cv=none; b=PWYMsIqDie6/2kEg3bvpEsQt03FIZZ9WFmeoHLjYaS7FEBBr+ZERiXWo+9wOhnYJqWOM9SGe1YTIvdIiKBh41MUYgjZg1YvsLrCunZMwIgLmQFr76UzL3wbO4BJFsUjvuY3Xe1f2Pf8Jbc8yOr1JAb11NPKXmb+GT9Q4kAHpRmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745301456; c=relaxed/simple;
	bh=yiQK2jpZHVhdgL2BdAmmnEMm/SIyv+v193pyzDsP39Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CotbP9KDu4Nx6KM95Yw3+AFWc0BGYdx9m2iutKTDby2LBxncpMY1o3a6i96i/zTQxopRStdFauIidkP3Ebgz2bE3TX6Af6y3x8Wv7hrIAlyW1Y0C3EtNpDIqt3MyzbMVWXAPx2aUqVAS0s5WqFLmvSawm16yQgnjQFbnvEVEhaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dCMjrvEq; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dCMjrvEq"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b03bc416962so3355272a12.0;
        Mon, 21 Apr 2025 22:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745301453; x=1745906253; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=2CNCIPV8knfKwGmMJ5eJ1dBewkIKBweeg/BgaIHx9u0=;
        b=dCMjrvEqwN7HM7oVjbKBlTZ/od0NKXCYtegJsv8dfnrSDgROYKjRsOVWPsrGDDu2YY
         l/SBQogSE+D3Nie5FfzgF+HQK7rLdaVkCoNtx0W5yf0DR+Qj6awOiy6Q7rx3WVlEVZun
         CZZlB35M+8TeEo5w7l61CVoQlv3xJTlKmjKnJW1XehN2Ad3D/4WA1gtNp6+SP7oy0VSw
         pZWnP2CrIqZjWoNnYh0ievRvHkTuDZXYj7NvODqnXMz5jSoknQRYiFYqT8SZEdBD9q0c
         u/iJPhkkUmgMiFHWM2LCuXA70lwLAsRbCPF17yGaK4zPSFsKeNWTOrZjvLMapDy5c9n5
         l0kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745301453; x=1745906253;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2CNCIPV8knfKwGmMJ5eJ1dBewkIKBweeg/BgaIHx9u0=;
        b=vUha7qE34+TTwJ2vw8YzPnQfzkkB+ir1Gsf+fBXiu6bXs+WTe7P3aMmoUbqKqVMQ/L
         c9oi25HqucK8wS//+KA1+Y/tarL7D5iwRgt3JXNNBGsxgAV09+q26wB2BT6htJosopKB
         E4L71H9wMBBjo4zsyI3O49L2dcS99ubvuiHSf1pz/mr4Db+mmmZWWCndWW83O8Lpv67D
         9TIwtP6OyEB1IU7ARoef+k1z8VPckmN8cRxVHemTkIq0FMCWV1UtwFec+4m/aPY8hJ8v
         kp2Vf5rzkUSwa581+VRo4QlKbPwdRalTsNYcDzJx1ig/c6HyLT6eBzE3jpJFkWm4Q871
         Wr/w==
X-Forwarded-Encrypted: i=1; AJvYcCU+gO5kOgynLValARVRFWuKIVzyRGuiMNZFuHS0eqNUB43Cer3Fl438wY70K31MwLzNrQ7URD56a+Eu@vger.kernel.org, AJvYcCWFbdN4Aax8IVYW+9GMc71ybrnnW5RdASaJgvBoGiIXeADKRXBtm1tObrAV/ntEICgrer2xAwqbamvtc/I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8IUsOKo4Whtrt5evyXjJwJZr+3w232Pdd9Ir4IDGDR7EmvNcm
	ivKxZz4PHUGrhFrHh462Ws1sXDybGkO7yqfcXp5nnMxNMAcXOxyP
X-Gm-Gg: ASbGncsZA5mxpc0C+FpI/+SNJ3KUYhGMZYq4oMdDhbd0nGS1G4LD/Fe9X5HZDTWdUuq
	yZEyFikJSOQWupYCXbOxY2AB7K5NHYzLuFO/IlrCy0+DzoUbohMxKBOxERgpFDRnf5qi6Z6QI1l
	OH10zy6KGxuL39OdIEIakQkTS9JhZm8Ku0V0GAcrxUrpjMK277qmqqaRFnfwdry5RDwN1wiCRcZ
	mxqn+AGtaWrUlvzVc3ticrebQXQ2MsHShxgn1T+ZznLFXdjODbxzo9E9jVFtpRZpd/XjpPwuTHR
	oMkycc3+R4pL724gzQoI72pvFbIWHuPMxqyxtlQfXK7hhy+/c2Q9CtS1v37mGpzzWUI10CelCby
	/ibonGN3xbCTwjg==
X-Google-Smtp-Source: AGHT+IFoPeXMFGs80VqY7AC6CwJylfGm7L1UOoz5yaul7zPuTg4ggEwjD/zEjOCvaraXEjwCZLk/CQ==
X-Received: by 2002:a05:6a20:cd93:b0:1f5:7ba7:69d3 with SMTP id adf61e73a8af0-203cbc5240emr21030819637.15.1745301453473;
        Mon, 21 Apr 2025 22:57:33 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b0db157be12sm6579328a12.64.2025.04.21.22.57.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Apr 2025 22:57:32 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <c575ab39-f118-4459-aaea-6d3c213819cb@roeck-us.net>
Date: Mon, 21 Apr 2025 22:57:31 -0700
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
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20250422054851.GA29297@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/21/25 22:48, hch wrote:
> On Mon, Apr 21, 2025 at 06:41:43AM -0700, Guenter Roeck wrote:
>> On 4/21/25 01:31, hch wrote:
>>> On Sun, Apr 20, 2025 at 10:42:56AM -0700, Guenter Roeck wrote:
>>>> A possible local solution is below. Note the variable type change from s64 to u64.
>>>
>>> I think that'll need a lower bound of 0 thrown in to be safe as these
>>> counters can occasionally underflow.
>>>
>>> Otherwise this is probably the right thing to do for now until mult_frac
>>> gets fixed eventually.  Can you add a comment why this open codes
>>> mult_frac to the code and send a formal patch for it?
>>>
>>
>> Technically only free needs to be u64 for do_div to work. But that makes
>> me wonder what the function is supposed to return if free < 0.
> 
> free should be floored to zero, i.e.
> 
> 	free = min(0, xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS));
> 

Do you mean max, maybe ?

Guenter

