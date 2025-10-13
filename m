Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C515274B27
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 14:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366532; cv=none; b=PvnW+K90HWLu7vGaW1ozslalNNNqMGX8so4eB4qhDecLiZ4FJNVVvinBnJQMaa3WLnnd9FOi6HSTODlcOebKBo8tq3DlFfj05Y6qqcdSdVuO0slEXYLNoMzTTIYnrvz3K0EoUVdZ7e3bqOL3ps/nqYeYXEWuaQxkAYFBW8a3v1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366532; c=relaxed/simple;
	bh=lb/ofP/CUeQfaZ9tnn400g47ImV+B1Q7hSrOKnvUzIM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R9H53ZM/BLdIjN17idpS6s3VHiEXQvPkN0Y2DPsCmuqGZEX5ybprSYqZGoUPm+/2uJOGTBX/O1wtYeLv7ZD/4eZHG3TToWwPB6WiQWio2Vo78B3ulG3Axt2nXLBUAItSBRdtLD52zWzimY17g+xx9H+qOG8yFtiINyeErvt1ZW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fyh14f7L; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fyh14f7L"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b5a631b9c82so2611407a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 07:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760366530; x=1760971330; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S1YfzWsEkP6Jpfl+QShdw4FnAJRrSitMw7SxdtKASYU=;
        b=Fyh14f7LUvEORGNZZRG/xmO3lQApkM1tZBK1esA8T4BlIcJEd6fzFLPmvgrpwuZaVu
         xxsJBYLL13Ae0gF3wTQQezpJEyc5bDKKEyXuYdECQ7qZG4YRF0tDOh/2lBJzBq61A9qZ
         Wh8O16L94cF53qLqnwSwzGBVMWsaJJmIwL0VGqTKYqTzhkf3fJiMagDVUcP9fAmrDi9Q
         SYIGG+6WceTtq55KB68wsqCuxbrBwg+lv8aqS+vzFqrJN8EiuaT6bRypad/+aUXFlYdi
         G1/21Kr1R3oQGe6NlHNiktlHtwf2iHknKsMY/ctLc104kv7ExwF3dLoxIBwqY2X/+PVn
         3KpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760366530; x=1760971330;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S1YfzWsEkP6Jpfl+QShdw4FnAJRrSitMw7SxdtKASYU=;
        b=KMod2gItxcaRY8roGeipMdGxpfqO7mkz9LRitotsIqgBbtqhCtW/c4O+dMfl0F1CRd
         z7udIywOCUYmbipDwL4C2V06nUDZ8QzN3JYtPnaBsAqAUW7iwXYuQPyCQMwg9rWwl/qo
         mrkXlNlOvZmTrk/4uCOqtZf5DeH4ksRmNg7CgzI8wftj+/du/8EWxnaRS+0vVgkSK5Wh
         iscDgqcWvZV/1AwYmTOeG7jlwzPehykIDokRG+H1ZnpK9GhJslPXjZbP+2TjlG01QGWV
         Dncr/Q8OhKpREo2n68EHqDdze0piQpDpIwzDg2ZD5R+5sQFWjXEIgYsC/f9ZcFz1Qvzw
         1j5g==
X-Forwarded-Encrypted: i=1; AJvYcCVrK0dGdxnOsdx/kXIZK6OomUjGlA7SRAZcek4psOmL2L3cCindgmPwnbouqo5uK5Xhkadu9jeTTjk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTJCR1L4jscNIL5h0FQHo96B4cr+WTgSG8fhgGaruROlvqNeh3
	rHK3EZ0K9tdrnkfFXtPe5avyDGvT66r1+PlhpJRlkdlXljcPz2vEZRhuodlecsUitaKjIg==
X-Gm-Gg: ASbGnctBISrhauhM3PCsmIKqFziz+SLph34aq6xx5wj5rHOvImK9gTetnIRu0NwkjEL
	TEEqMce1bkuSkj+mtXI28TFF9VyJ9vsHaxHi4ZGXu13UWid/x1KYfdwnSsbSgXtZNxUA8OzkIuv
	G+Wh+KFWa+HsuFP7iUI/I9ohc5RKWmFWxnf8SCFDIlEdE9QMcUiPpy6siMGL1X0IF5T3VOpS1Ii
	u3ZvQMUC95UHsasAR6JA7KbLeKUfkHxfZlNYh4p1C9hM+5tyhxvYODWxaiH6MUnlFnVdrjkUPW5
	wOq46zOnqo6NO7I8ZZFGiVq2yP16z7cYeS1kXuIxWW9wDxuvRdxtq8BbIgdhIq25jTVEtNkYxNW
	fzFHJJ2Iqh8FQrz8aqelIS/Pxx1muNRdkKBi7oufQRIMv/JLrFwS1pHsMvg6TN1r4kOxIcP9eLj
	FHyYCsuhaMlrGs6Q==
X-Google-Smtp-Source: AGHT+IG+K1vywETLzSrivhI3s/QeWt+yhGZXCHW6mRT36HHpdfHPqdLr355p9ZJAsXJ/F59gampgMg==
X-Received: by 2002:a17:903:2409:b0:290:52aa:7291 with SMTP id d9443c01a7336-29052aa8299mr113498825ad.53.1760366529612;
        Mon, 13 Oct 2025 07:42:09 -0700 (PDT)
Received: from [192.168.50.102] ([49.245.38.171])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034e1ccc4sm135799655ad.42.2025.10.13.07.42.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 07:42:09 -0700 (PDT)
Message-ID: <97aece25-d146-4447-9756-f537acadace1@gmail.com>
Date: Mon, 13 Oct 2025 22:42:03 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] generic: basic smoke for filesystems on zoned
 block devices
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
 Zorro Lang <zlang@redhat.com>
Cc: hch <hch@lst.de>, Naohiro Aota <Naohiro.Aota@wdc.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 Hans Holmberg <Hans.Holmberg@wdc.com>,
 "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 Carlos Maiolino <cem@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>,
 Carlos Maiolino <cmaiolino@redhat.com>
References: <20251013080759.295348-1-johannes.thumshirn@wdc.com>
 <20251013080759.295348-4-johannes.thumshirn@wdc.com>
 <006ae40b-b2e6-441a-b2d3-296d1e166787@gmail.com>
 <4eeb481f-b94d-4c2f-909e-7c29ac2440b2@wdc.com>
Content-Language: en-GB
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <4eeb481f-b94d-4c2f-909e-7c29ac2440b2@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 13-Oct-25 10:06 PM, Johannes Thumshirn wrote:
> On 10/13/25 3:55 PM, Anand Jain wrote:
>> Johannes,
>>
>> The test case is failing with XFS. For some reason, the mkfs error
>> wasn't captured in the output, so I had to modify the test slightly.
>> Errors and the diff is below.
>>
>> Thanks, Anand
>>
>> -------
>> SECTION       -- generic-config
>> RECREATING    -- xfs on /dev/sde
>> FSTYP         -- xfs (non-debug)
>> PLATFORM      -- Linux/x86_64 feddev 6.16.10-100.fc41.x86_64 #1 SMP
>> PREEMPT_DYNAMIC Thu Oct  2 18:19:14 UTC 2025
>> MKFS_OPTIONS  -- -f /dev/sda
>> MOUNT_OPTIONS -- /dev/sda /mnt/scratch
>>
>> generic/772       [not run] cannot mkfs zoned filesystem
>> Ran: generic/772
>> Not run: generic/772
>> Passed all 1 tests
> 
> Hi Anand,
> 
> Looking at the output it isn't failing but skipped on your XFS config.
> 
> 
> This is expected if XFS isn't build with support for the zoned realtime
> device. I've been discussing this with Christoph, because for XFS there
> is no feature flag in sysfs we can check if the kernel can actually
> support a zoned RT device (unlike f2fs or btrfs which do have this in
> sysfs).
> 
> Christoph's idea was to do exactly this, if no zoned RT support is
> compiled in the kernel. Hence the _try_mkfs_dev instead of a plain
> _mkfs_dev call.
> 
> So I /think/ you just validated that the skip if !CONFIG_BLK_DEV_ZONED
> && !CONFIG_XFS_RT check works.
> 

Ah, thanks for clarifying. Any idea if the redirect to seqres.full can 
be fixed? It was missing the mkfs errors.

Best, Anand


> Thanks,
> 
> Johannes
> 

