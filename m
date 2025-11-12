Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD59D28642A
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 07:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762931652; cv=none; b=R0mnnQe+adwipZowLfy11ghQBykjZ2LdCH6TrpED0lyFE9O/QqXz1Ey90jtCqy9aeMfdWSHRqJCJyF+vf5yk0QgtemXCiLFxuR0HftZweVw1VTRJnumkjttMU9D6bHqaO78JLAjePVdqQhIc3DbOqi16oxBatUF0m0PSTppMb5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762931652; c=relaxed/simple;
	bh=cUgCmt7/S4H78nSegwnrwPgzDrfISuJQ8hnVSCrlVDQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C0PajoTe2n7/+0Rv87IVq1sYUeG/SFKkc9MnGiSrv6NqWOl1Mu/ojlM5B0S2bgHCNgxaard+In+BcCnTBDa2w2yzYAzt7WA9uqeUHTMUe9EKiqChWH88YyDG4p07+kaLSXfop9KHTwTyAt+Bq8vtNHYNS2K3Fcj3MMId1uds1gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XgH8q1jr; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XgH8q1jr"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-29555b384acso5271535ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 11 Nov 2025 23:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762931650; x=1763536450; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X8sb02e1W+AKeJ6wR0eYaD2KkfiM6HqalBahoIkkYHA=;
        b=XgH8q1jr2+XQgLkfDKCa/eUWE1ZvSrkjRxtr5lBbLGxRYdtzxNaRzJKM50Ux2SEHOn
         0BlAjFIYdWeA6qeOVyyZmDrK6k4OKLxGTQYKjGI7qHlLKCwbVIW0OFzrgEv4v5ewBziv
         lv4ohKUGv7dG6To2zsCiMcMO+Ruuo3xwZdTgTqKyLYSvet1wbq7QLkzDOvfx78zFlOw+
         MR3w5gfbC9TLFm1qlc0UjFCOBC78Zar1o6Tx335kme/yEGz0nsP3JeYSRpYmnGxuxOuv
         z5Wpi3dE0zdK4SoBYUa7rWSOkPUcOAf6XQY3Au3eII4YW4J+vud6XV4zDnR1hSYZ39Yj
         SQ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762931650; x=1763536450;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X8sb02e1W+AKeJ6wR0eYaD2KkfiM6HqalBahoIkkYHA=;
        b=T6rkRC+onjAjAv6GsmGX66BlZ8K0Iu0UNNjNxt59BDqdJy3K4NBw4kyt87gUfagVgN
         sNVssdHA9KPRv/92nMw4jjrn4/KBS4oVMhSys6vjcFY9NTd8wcc18PdOTu6vT5UZQY6H
         hZJtmITLv8afU0D+a99O223rQk/bC+nBMRfM917MDvj3zZKvnTgA0AP2CSI+LZdgIUT/
         Y7alItjibs7Jz9EmDq7mLwbEWbjFXBvnnqR4OgVg0v6p1O57kanNFttgzP6wqAPPtxcV
         CC+n6/K3gUW98MVWmr5hmi7Rs6bY86enc6M6HCXNMi0gUsdI5hwfFEoQTkql5r4LtQCF
         kWRw==
X-Forwarded-Encrypted: i=1; AJvYcCVnZyuRkWNyRTd9lFH2VtTqeQarMaWP3gbv4euo3NEr0uY/Yg8Mr+lxmaMsLEbI7SKPG+uvmGh9wJA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcVKSNPckpDZQEnsKy1FQPSdBhT/L/HTyB40R1ZQZ9BAlniGth
	ukeWqo59rLmcwcwiFW//2qaY6CZygaznsDulJ5HX2b7P6N10myG1pSuw
X-Gm-Gg: ASbGncs0LnZB+svA8d4soIgAbquIh+9TTKyM3mHKUKK/7Oz+7D7SQD9E9Krq5mn63WQ
	OOoM+GuYrERVAgZdbEbZ2TXP70djRncZ7i1/yoVCQgjo6VGTS74DJPy7rGd29xHKrfpCXjqmyvQ
	G2YLo3m9USwPo8cp993pZSNjoOSVD0maHygGTj7+ki8H6tOFjPU0MfOIr0GOUk1Ao/n78K6FMMv
	oyFuhBstyD/h76C+2WYOYABUvEEXwd54+53cVvC/2onsoXuWnnRiN/ia3dvuxdoHmx/Ae/hY6uC
	DSefqvk8W+t+GVLX6eX1eXZuGNFoyVeZcYz6hchvPEeXmtBGDyPDAGabbVsXcFexXTt+CGXbSLP
	4//BLQBky7UOyvOonjZtR2yflokfrSOpWcXb0m0/vpEwigFU1IcH26SjMypCJzRPBl9/PhjM4Js
	if31zqcHr7Zjdb+JPS
X-Google-Smtp-Source: AGHT+IFxIDHbMDQtJnDd1j29er8I9W16ktyYHaqy/e9kdgu1LMq6asMSVrMWec36NOc6lpyOhk0v6w==
X-Received: by 2002:a17:903:3d0b:b0:295:9e4e:4090 with SMTP id d9443c01a7336-2984edde5demr21733055ad.52.1762931650013;
        Tue, 11 Nov 2025 23:14:10 -0800 (PST)
Received: from [9.109.246.38] ([129.41.58.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2984dca027esm19947645ad.70.2025.11.11.23.14.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 23:14:09 -0800 (PST)
Message-ID: <c91c87ab-dd85-4c42-9af4-a25ea2540de3@gmail.com>
Date: Wed, 12 Nov 2025 12:43:05 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] xfs: fallback to buffered I/O for direct I/O when
 stable writes are required
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-block@vger.kernel.org
References: <20251029071537.1127397-1-hch@lst.de>
 <20251029071537.1127397-5-hch@lst.de>
 <7f7163d79dc89ae8c8d1157ce969b369acbcfb5d.camel@gmail.com>
 <20251110135932.GA11277@lst.de>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20251110135932.GA11277@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/10/25 19:29, Christoph Hellwig wrote:
> On Mon, Nov 10, 2025 at 07:08:05PM +0530, Nirjhar Roy (IBM) wrote:
>> Minor: Let us say that an user opens a file in O_DIRECT in an atomic
>> write enabled device(requiring stable writes), we get this warning
>> once. Now the same/different user/application opens another file
>> with O_DIRECT in the same atomic write enabled device and expects
>> atomic write to be enabled - but it will not be enabled (since the
>> kernel has falled back to the uncached buffered write path)
>> without any warning message. Won't that be a bit confusing for the
>> user (of course unless the user is totally aware of the kernel's exact
>> behavior)?
> The kernel with this patch should reject IOCB_ATOMIC writes because
> the FMODE_CAN_ATOMIC_WRITE is not set when we need to fallback.
Okay, makes sense.
>
> But anyway, based on the feedback in this thread I plan to revisit the
> approach so that the I/O issuer can declare I/O stable (initially just
> for buffered I/O, but things like nvmet and nfsd might be able to
> guarantee that for direct I/O as well), and then bounce buffer in lower
> layers.  This should then also support parallel writes, async I/O and
> atomic writes.

Okay.

--NR

>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

