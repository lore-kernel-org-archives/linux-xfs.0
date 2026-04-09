Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE099383C93
	for <linux-xfs@vger.kernel.org>; Thu,  9 Apr 2026 09:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775727930; cv=none; b=lw17IN77xuW5YhPV+2NRTobEG+3d/rfTiaqI3bcJ4rvrNnExu5hPnJhWAbGQpLm16yrOYXDL1sVBLQUHibQj8hT2GzJjYog0ZOeAB/+g2iDxC++QEfuSJZKNT0/3uS5gaB5LaewOzuBGMol+4m06ZkGBRW5qjNN3KcJ5Ki5MBDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775727930; c=relaxed/simple;
	bh=Y7HPYaMeBrC9oPCMFCEfdGDDpTsf221Nf2WBNd8YlxA=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=JkqyAKolE4OPqWjBuqTJpRe1UhpCe697zrxQLs/uIfQuKYnT6/gnx2Og86RmE9OeDhDHTdlHaVG+RBhDx6nImrb7wH5nauWLGlphSx6xRIld0V9gVs25KRlOUA2UrG5jTHhlbPIPA0xjQJzNgSebPSPfFtMrMWTsdON1Ggglm2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YN5OYwXu; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YN5OYwXu"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2b24fede2acso4028785ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 09 Apr 2026 02:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775727929; x=1776332729; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4ADfJ2NQprV2qnHtWa7RILUcbgRcQL/MN+0KGK2nuGg=;
        b=YN5OYwXuJwI4TLfqwZZb6Rj82SPFURoKz5Sjp6cKgi25SraI8oXcz0y6vzsUELYsZ2
         GDq5AaFvFodzhKO6LbNlx6D2JOT6BRFd2J7tvqolovwXSLw6CSbT2b400FVwd0k1By6D
         HYLPpUmBakQ7ROTtNK+wWXTx9xTNxckWcI5e8AxfpQCVRek695R2aDgJWcCoB8+jfS34
         TkP0t/emljanChlYPcV1oZAEiLy/fcopwE6w/NHM/kBJEM9uUs2gu7orEIA1LVLhnWPU
         oc02HNa2msG3/S4CCrF2pazXAEChdNex1KMS6LWlbomPJ5gJqEalPZX5fFXpjY7/4mi5
         gHfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775727929; x=1776332729;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4ADfJ2NQprV2qnHtWa7RILUcbgRcQL/MN+0KGK2nuGg=;
        b=R1ipvuWiPhDz7EdrwsoIBf+m3uxh7pLHBqf45x+92pGNsC7Nh4/MTlni7PWctKO5Sq
         eGNcbITaUW/UdO2EDfBVPLKLFcrnQqWr4R/FHT7EjBf49Ik/y3X7S/EsrVQOsxuT7ZnO
         2Jes5JVQ2oDysg1U/o+MBT+B2oLt1uzuWv1m9FM1Zy2nFtc9dG4VeR0KYC8iqXsgwqf5
         149qPuEunWPRXuqg29K6qqljIVJKUV7KwUvpbAQPWOBupfuM3+oFsGSN1bATM9D/+ZcY
         /ZFR8blpx7qJCY8/OFPl6TbArqoXmk659IpDMimFUDC3nnHqs1DMDNIUj4Xc3OVg5sL7
         o17A==
X-Forwarded-Encrypted: i=1; AJvYcCV8C+JsGpmLeNJ0ckM0PACzpW33ueseS8WSGb3WQP1gu/zSJpHZIN1j6bBe9Q2WjGKpU7JWwGPqy4I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwONpKGIWPVH8yUlaBphLECAvq6QKhZ6hR8tXTNEdOBe2JNk+ft
	Ip8pXGQ0yMTg7J/MhooehvLsfyhtOKw18nW7HKF6ZDQx2KMn2AxGlWcf
X-Gm-Gg: AeBDievID8vlQHjHjjCF58ylEtuydSpXS2faaG5ziHqi5QDI2y2PWkv7/KsDNx2ubbZ
	zRv6T4GJMdNpPmhznz86Ihh86Q+HYikvlF2XDrgEGbQX1VelvR99D6tpYpLlmHOeUlvoDOzrWoi
	NPQWF0105GwygEC4SfaY6S2n9j0k8X5F1hUKugBhz+gxcZV4uNBinoWKTimx6vzWFQR3EtHcRYr
	6/XLyuBzn/mqxbL8w+7pfJmKAxFh4Mra6NMRWVBvqSYVzzxj3nYsJVdCxKAkWmDkDbbN8IatPbY
	3Ush5BJE69hn5JcLMTw3x6+jOoNWimbMGV/a9b/QAgQXy7Umnq8Rvp1U/ZvTZ0eInYzz6+mfkrk
	6uB6AoH60q8+v4RwlDVDpqwfU0teUhMW7RxjwHOU9buR2JHXMW1KmWoJaE6a/iBn09xu1MTAXO2
	cxfho0pfx4Fj3agmq3fVVOnoyqhA==
X-Received: by 2002:a17:903:37c4:b0:2b0:7b57:830f with SMTP id d9443c01a7336-2b2818e4f2amr251227605ad.33.1775727928999;
        Thu, 09 Apr 2026 02:45:28 -0700 (PDT)
Received: from [192.168.50.70] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2749a2e42sm214502685ad.56.2026.04.09.02.45.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 02:45:27 -0700 (PDT)
Message-ID: <22cfbf8d-af9b-462e-b240-67a1de24764f@gmail.com>
Date: Thu, 9 Apr 2026 17:45:24 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Anand Jain <anajain.sg@gmail.com>
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
To: Theodore Tso <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong"
 <djwong@kernel.org>, linux-ext4@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
 Anand Jain <asj@kernel.org>, dsterba@suse.com
References: <cover.1774092915.git.asj@kernel.org>
 <33e8eb64c304a4d42b60f608c26497bf9a2e9e19.1774092915.git.asj@kernel.org>
 <20260323041624.GA11453@mac.lan>
 <d4a9970b-e7ed-4e74-be9d-2d08400f9d79@gmail.com>
 <5bda3d00-df35-4ea1-b313-2fef6e5c5682@gmail.com>
 <adSUiB9L0sFAd04U@infradead.org> <20260407144709.GA81690@macsyma-wired.lan>
 <3c9e478a-42ef-446f-a8cc-1b4ac970d2ef@gmail.com>
 <20260409041035.GC99725@macsyma-wired.lan>
Content-Language: en-US
In-Reply-To: <20260409041035.GC99725@macsyma-wired.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



> So if the two file systems are identical, the (f_fsid, ino) will
> uniquely determines a file.  And that's *fine* if f_fsid is the same
> for statfs(A) and statfs(B).


Got it. Do you mean that since both filesystems are identical,
statfs(A) and statfs(B) can legitimately return the same values?

And if users want them to diverge, the expectation is that they
should update the UUID (via tune2fs), after which f_fsid would
also differ. If the UUID isn't changed, then the ambiguity is
effectively a user responsibility.

I'm not entirely sure what the correct expectation for f_fsid
should be.

My initial idea was to make f_fsid behavior consistent across
major filesystems so that user space benefits from predictable
semantics.

Currently, XFS and Btrfs provide f_fsid values that are unique
per filesystem, including clones, while ext4 provides uniqueness
only if the UUID is changed by the user.

That said, it may be fine for ext4 to retain this behavior,
since statfs(2) itself has some inherent ambiguity.

If there are no further concerns, I'll update the submitted
test case generic/791 accordingly.

Thanks, Anand

