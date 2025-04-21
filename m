Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150231DF991;
	Mon, 21 Apr 2025 13:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745242907; cv=none; b=LHgrW1hl4107wWpxPaj9F4g2vlFPPGmzSiF96sTpBLFaBoRhbnWTxJ8WWKOw5BVpTMb4CJwkgMFtFK0rdAOj57a2DX96q5x14739lZC3THlj6rqLjJrduF/uel4TfwjtOdoXQ/OgybS5A2t6ST/qs5L2qXSOGLYdnYFZ3cB1Bto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745242907; c=relaxed/simple;
	bh=3ZCFAI/4+bl+AZdTOM6dCisJV6nIVMfQ5cjhCxYa928=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kp0HQGUam0OUk3d5R/GKBdHmHiNIzJMC7ImGuFGQs7fMzgrC7qrMvG/VDeam8iB06NJXrJyf+0BtFY7uOf00pNTZh9H0C1tz1HKhgSO+X4RjMO+tUYZMvLSuFaYL1G2phFlU237H0+qhOBOWZ4JXx3QzzI2C5YF5mJ1mp2RoStU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O8BVHCfJ; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O8BVHCfJ"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-308702998fbso3590603a91.1;
        Mon, 21 Apr 2025 06:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745242905; x=1745847705; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=ECd/IrPdIV8qR2l6zKp0PLviOgJCM1imAVXIEmiix8Q=;
        b=O8BVHCfJPmiScMYBJteMFP2uNpMJApEezd0sQaTaD32XW2hyRkH2hceaDp0sYutb+M
         /XthdCtjdKG7DpIhl6hrSYegppj2o8DQOdNu02t3Wu/7/jFiAuaCmvbhvQ4IhtC2UveE
         gopMaYoiuBD+sTeBjxBVEdo8dgsXmdvYjCcW+JRRoYCerPXIgeCRfFx96EL+vF2yzEFD
         jvXzFEJ9USrTn0XgCk73tG3xr/WLPy2ZH3Ko+2Gec+Xs4Cu4N6KJQa2zMER0YjrqAokX
         YwCeEGGY+aP9KD/Pht1aMi/ZwyODfVqQMHteG9cXN66MclNYCanWhuoHMnNZsYAWbE3n
         sqRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745242905; x=1745847705;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ECd/IrPdIV8qR2l6zKp0PLviOgJCM1imAVXIEmiix8Q=;
        b=dsalt2J9RiFUV2CTmIlZjcRdGAaeBS877PVMydceA1l1R/9Q0O1WxJ9gybVZzY5FTV
         iudjhr0Ze4IUI6s/bkMjY9WmsfdmlMDgCiW3sL2HzXXoDrphIfKNXRqlEa4rYei907VD
         DeVq4xVKvOv4GXpzrVT38zzBkQtvZWPacrPr+mFDeVPtlaa6MqNWlOZEdrcMkSfVD1Na
         mtli2+/+QEvbI30ryAAqHNs+Wjd6k/4fxxdcuKaN5SscznNbD40TRNEM2fxUFqE64HEF
         qBrNXR1fn5GsnzzMfjzwoIaj0baTrIp+nIR5hO7lOPzT7acMqMATeXV5s4IZ01/17xRq
         OuRA==
X-Forwarded-Encrypted: i=1; AJvYcCU45Tsmem26asTzsCn5S2vtr/zgQaLhxOwzlQXcXgVsxxstGWiMaR3CaL4hCR43uTKzI6hn4wgrvIPB@vger.kernel.org, AJvYcCXDigs3XcB++AVgI4BGQAZD+n3M4d4ihPW7Zlw6ffDSon1J80n9PPQFDVI5RYtCXbUX1Lz4kXVUY1mvHfo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt77wB+vjqbzMhI24fYs8NOPrSZTcVpy0HEkyTLoEV7DRqZ7gK
	+spmEKc8A8dmtu5FOHI+q5HCcmMtr6cWdOgyVUXz1SyqMmU8sZmQBJkMqg==
X-Gm-Gg: ASbGnctcMEsWyhavK1u/f9BZU9gn9NaUwaYW03vwry+1ZnOri2rwKGgpPVLtXCqYudn
	/PMhS0zc9kXjpPP27qmGG17123XyPI15Mq/RNBAxhmNAh88SEzynvBCVmcc8uM9pKTZKMwfwEkR
	UU5B/oq8J3Aw80JerFRbmLR1hj5SJ40c8MXuWxb1F5Jlo41cmAj9NWhWNb+CndnexjLEAM/N0Dk
	aYf9y/ixfs7NqbbhB8PKc9HaOfN+1jK+SNT5TNn748tvHp0+nL4OELSQewLHHAJUek59KX5+fog
	zXIASRFNVkh/OrBrYZ5pAqA1XcwXIt78P05F0bbOyfZ2co5URa/mmd8ZLoRfz69hWoqATl2yfdE
	k+7MdZ9yVzXk1xA==
X-Google-Smtp-Source: AGHT+IEozYtzMzT0wyJ+5Q0iT3If8p7VxTm3YmZ8htO8Bi69Cg4WKE1MGXh9j0UVW7uT1Vm6FmyYWA==
X-Received: by 2002:a17:90b:1c0a:b0:301:98fc:9b51 with SMTP id 98e67ed59e1d1-3087bb3e858mr16085910a91.5.1745242905254;
        Mon, 21 Apr 2025 06:41:45 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73dbf8e3631sm6843441b3a.51.2025.04.21.06.41.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Apr 2025 06:41:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <c432be87-827e-4ed7-87e9-3b56d4dbcf26@roeck-us.net>
Date: Mon, 21 Apr 2025 06:41:43 -0700
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
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20250421083128.GA20490@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/21/25 01:31, hch wrote:
> On Sun, Apr 20, 2025 at 10:42:56AM -0700, Guenter Roeck wrote:
>> A possible local solution is below. Note the variable type change from s64 to u64.
> 
> I think that'll need a lower bound of 0 thrown in to be safe as these
> counters can occasionally underflow.
> 
> Otherwise this is probably the right thing to do for now until mult_frac
> gets fixed eventually.  Can you add a comment why this open codes
> mult_frac to the code and send a formal patch for it?
> 

Technically only free needs to be u64 for do_div to work. But that makes
me wonder what the function is supposed to return if free < 0.

Note that the proposed 64-bit safe version of mult_frac() also requires
the dividend to be unsigned. That is a quirk of do_div().

Thanks,
Guenter

