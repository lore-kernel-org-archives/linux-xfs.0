Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C3F36B90C
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 20:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789073498; cv=none; b=Ln7JWDRrQ41igyigy6I7wiSd9XicKqr5DrLFyzh//vJYFakoJVeh3KOYcQTs/6v8Sin9h0o8uM6fecxSBnQOGRicTXUQr8825GI1maf/9qw9+M4YcvTecjHHKJw9MYZnmWz2bjohV/A/agc5Ckjxwph6xrF207ikq0Wbh6pqXOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789073498; c=relaxed/simple;
	bh=lQ1tC8QyyXsDWotGX0Dze7Qq9KJn6duOUqMRQ51l/t0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=jS5GUbqJOy2eBze332GslHDEAjaB4kVijE1KyshYXpJGB8QkldxRgGCzVyMrubQhqi55TtiFG4skc5Qq2A9KiK7B/yRR151n809mILI3gAGcxGSXeAAC+DMA8ydQSWBqvkso6iyiH+BN5YxAf6wJ+9jScuRA1wBr4VGmTkjZclo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=qyAe0Gp+; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="qyAe0Gp+"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-4c14d66d922so153193b6e.0
        for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 13:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1789073494; x=1789678294; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GXMKHM4ByjQtPNS9X+R9gCOHk8uolkvlV5huzt/Ejg0=;
        b=qyAe0Gp+5MJD41P0biXsS+Tm0HKWVFusfBdr9lw1bFjum0QXINGToLWe3CtCYKJLzP
         mBCuIRz/76OmagJleXEv3Bv34AwPLVWb8g2XWC8qslvJ3tiUei3HkNC/2ZLl4qBipMdH
         qSjuY5eFLiqF1axrzdsuju/LUT05moIPnXAayc4h0Y+oGbqayjp10hSlr/iRIwyLWAWN
         Nl9nxWeW8LX7syvxrhW0/jOCeRrnsZA/x4bTf/mR8NJlgFsTKlF+5vKeEdBt1o46RLZI
         jk0llL/4HRqbWf0SK1oeMwc5YFrwyRUFB07A8lRQDQvmvP4V5CpDHShEiq0t27SDF4em
         MWQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789073494; x=1789678294;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GXMKHM4ByjQtPNS9X+R9gCOHk8uolkvlV5huzt/Ejg0=;
        b=N8W1JjRoAkkPhCMHwdTpiY7NPPXMGFPo4IOpTjXV3p5EDyyXNuksobJIekDqnAi0q0
         nJTdcDl8BQvaSFMRLeNIIHIsr0Z6P1dlsTLSPtJS/Wg7IEy8f3zKi1DMdJ42pR7JZNNw
         Kh/CvNGlhBSDRsRW6Sqw00MzHq7bDIqKZopGUu9DUJJpSFC6KA+Y7hLSfbdVK3ajFB1r
         C/1+WZi/xFbiIQlBJyd1ik33rcECDV+lN0J8a/fIfywjDI25VOH/sNuNsW0Emz0VqcFy
         MvW2eakdW197++clMns9JCSQuu6kvSz9/idAp3yh/V+D6dz38EnI6dTFDav01VaCNHI6
         y0Sw==
X-Forwarded-Encrypted: i=1; AKwUvByS9CHBVdkpplaYUdbV2SFVq2aKWrxPdLFzzcgfBDyLWmVS2WcwYEPzeXYWY2IzSXpNJTOc/rry8UA=@vger.kernel.org
X-Gm-Message-State: AFuF++kl7VPx7/tyYZET5rro6qj5azm9VdMJq7tZ/ypCkRBeN6DXXDDk
	LLHB5s9I95/nVHUS9FxZdRvq6/swe0eXTLVhnpaDU/WHrDyqpBjUWm0MZ4wtAFYMZSo=
X-Gm-Gg: AYBFou1GtKqCBpvTMGQIgn6bGv66m/dLNFhzBD9eR51ZheFz06qqK9EXwMvxG3q0adJ
	+QY6+OX5u9n9WO56MQToFLq6jT/uLjwjgS9AqJGA8ZWAaFie5n0Ii9aWmh9EsESeXFQ1JHzRrs+
	zAGp2afa5CaXB3qRSc9wpMagjXskUb6OKZrbzzMtLBG6R2CehmOCJQelpfRqwQaSWQz4y0SUqQX
	HZChOhSbp7zf56oXQJmm4IFNfroSnpo4H101BVYSmheCed5FSj6C7D2Ak/QyRfmJxVEimNhE3Bk
	ptHLIhORMAa1j1vNVg3s06L3JAGk6Z6abrmcMM7nr+EojFdaXsaLHW2C1XOVFV/Ey+PMaDTDPLm
	AF6zVp98yxDxhGHIUSp8ZS6iqks/PCfDPN+VpEmra31v45oQRVpFBUiB68SoAYI6rS+eCzJjsN0
	ND1n/Z03ul7Po4zfrHDM7ZKuISOYxQeAqgsRusnA5GoMcIvYYB5LLFhVhadKMnwFiTJA7ImwOGx
	AVP++K2MESKRYogOs27/TGHZmC46xQVXxo5kkBnp2rrhDcF5bFTfhhb
X-Received: by 2002:a05:6808:1a09:b0:4b9:a88b:8895 with SMTP id 5614622812f47-4c31cf44127mr554822b6e.43.1789073494540;
        Thu, 10 Sep 2026 13:51:34 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4c330daa69asm282875b6e.5.2026.09.10.13.51.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2026 13:51:33 -0700 (PDT)
Message-ID: <cff350b3-836f-4953-97f3-d664164746b4@kernel.dk>
Date: Thu, 10 Sep 2026 14:51:33 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: lazy bounce buffering for checksummed reads v3
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>, Anuj Gupta <anuj20.g@samsung.com>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260909060924.1102037-1-hch@lst.de>
 <fe537c5f-114d-4d9a-817d-93f359e12924@kernel.dk>
Content-Language: en-US
In-Reply-To: <fe537c5f-114d-4d9a-817d-93f359e12924@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/10/26 2:50 PM, Jens Axboe wrote:
> On 9/9/26 12:08 AM, Christoph Hellwig wrote:
>> NOTE/QUESTION TO SUBSYSTEM MAINTAINERS: The patches in this series are
>> split over 3 subsystems, and I'd love to hear from the maintainers
>> about their preferences for merging this.
> 
> It's a little hard to split as you have eg block patches both at the
> start and beginning... In the spirit of getting this some runtime, I'm
> going to queue it up in a separate branch,
> for-7.4/lazy-bounce-buffering for now.

On 2nd thought since this already relies on stuff in the XFS tree
apparently, you can just add my

Reviewed-by: Jens Axboe <axboe@kernel.dk>

to the block patches. Would probably make everybody's life easier.

-- 
Jens Axboe

