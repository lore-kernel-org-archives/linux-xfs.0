Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEF32BF019
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 14:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768228518; cv=none; b=DKJCiW5Fhl7UCTY8FZ4HGWL0Z/2B8Jw0DPRpsunYSsqTdnMoKfGzXvTq4qUX+NnQ5pqK8o0HWJkOzlgGomnUGdGHXG32It883aXUpuvIp3IKVW0O7C8orBKFjC5eOEXGOvPGHjNFvvWyT7USaqM2QAvZczMFYZaKIj+ipV8mGso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768228518; c=relaxed/simple;
	bh=5DDWbAghc9ruhfFawpwk9bxnZT3RSnykkpqY8mLuu+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RTGx+oz2SK/ANJPF/3mzN09e0XuEKGBSh3ziq8h9MsqIzMJItIce7dTjxpzu1W2nifuwkdt3y/UG893AHrziRGySMf2BIqgotcaBMCBX5B8zElV7YuUntMvKda2KSYwBlXSPe/Il9dYPbRBLWrvxAm5mG5tzFb1Aqsax48hLouo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jr+HsKym; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jr+HsKym"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-81e8a9d521dso1412186b3a.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 06:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768228517; x=1768833317; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=luIK9vw5wWwV2cLpORAxmT/Mq8tM0pb0kSYTC/cWDb8=;
        b=jr+HsKymS4sQRogq+M1tv+MFED7e79H16kdnJSArnERCb5mgkA6W+Gk5CL4tJng8Cm
         teHcqaXW2qHRoTyifGfYj9g3EWfn5Fdur4q7qdGOEqeaRmiDY8/EQnuf7ypesMIvr+Wo
         Ex5u8MpWsgONrUl7nj3GgUX03gA8NY3v76/rgVC1WUjQaHFGtZtp6BzBJdmmgFhVeHBx
         nmjXU+INDQrjW+WG8Y0oKMC1hchZGCV338Ecuhywt87eLxEbxpFVihBibRcGQ6aoR8du
         yog62XhJupFnsGenXWcfujHmQExr9rCmCHhG8WR2qnsnriCiD/33/J8/1luMVqgjawQ4
         5BFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768228517; x=1768833317;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=luIK9vw5wWwV2cLpORAxmT/Mq8tM0pb0kSYTC/cWDb8=;
        b=dRy200dKfJBgMxz4N6xnW6Qk86JPTJvP40MKv5Wtmkt+8qMmN/4osD83B1/01ApR7J
         mZBbmM41rJ0vbUA6C7DtNEjXqFBn2NzraX/uXIOFYO6PM25gXB1GWvsNgl8pbvH5gMpq
         AKK3AL5pMixJzdbh8bxmarlbHBHFzKIByA8pilD/P+nag/9ttzVHHzEbBnzGoFzPqcuR
         9oo8fyYg1uzd/Am/7CDyM5v+Pwz+sDUm4MiKg4yUwmyQFcTltBtDLj1JPc7t58QPqdAX
         oSC4yzmj2G1b8rHdD42hj3DPVVUVg7qu65x2rX8oSHUlXYYR7/cmbQ6wkPXBHQS0l0M3
         1olQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLfWg5bL5BkwY5MujN3YC+xjBqHlQ9U8yBUCrWm2K1G8XDNDVhBDJ8Jy++osC49tHgym8UswlJkA8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIv19lYwjpoVOrDQt8eMEyC653rmRNRm3ZRWxuLg19LMmnqKpo
	IjsBTK2EqSsIX2w6dPlCIuEuMKTexuQuSiYrNHqVef/5aqOWAT1LB3LCk0e0rQ==
X-Gm-Gg: AY/fxX5MafJGD0BxxXsKMoffhjNK5Hgg5RqtPzF+odDi6900C8gfTg8h/owmkur+LFt
	oP4yvfOwpJKd69Ej0jj9QVxt3W9QlWhkecM6ppBbwL+1DP0f7et+ZxM45KVxzB6qIp7b5yCoglJ
	EQ5RKXFPY/KU7m7N/KjCBB9/7wIqSnkX0dgB0xQiFWFKL29J4e2wp/IP28UYWC/VIRmCqM8bS4e
	l26J6xGmrMheVKyH7Ays8qO045IU5afQtRhhlqIubz4R57jZOe8Xr7le4gTtpHuTneeE0ZrJaMd
	SKfblkL1IADdioUg9FJAInjD0za3zwsD+uXL8dHqXEXUJva1JYD0jfMv/s6iqEWu/z2ERsmGJ39
	ju6mtVvlbtNUZa/QXFhEKFGkUqOOeCaT51DWl+uO78oYiZc/sW/B1X2N0QvIrwo6ivZ92RABl5a
	kIV6nlj3lIYWfbN/dgmoIOMw==
X-Google-Smtp-Source: AGHT+IEmNl8HDiHuU8nhk3t2ev/xMrqoKnYdV7JYYjRogF8rOZa/K30y4pxxKeSjHgdNjsVaiq2n/Q==
X-Received: by 2002:a05:6a00:2a09:b0:81f:3957:2770 with SMTP id d2e1a72fcca58-81f39572b94mr5838069b3a.38.1768228516561;
        Mon, 12 Jan 2026 06:35:16 -0800 (PST)
Received: from [192.168.0.120] ([49.207.232.254])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81df6b3bd16sm9641626b3a.25.2026.01.12.06.35.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jan 2026 06:35:16 -0800 (PST)
Message-ID: <2f9c2c7d-a6c1-4f79-b7e5-6bc369bb585b@gmail.com>
Date: Mon, 12 Jan 2026 20:05:12 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Shrinking XFS - is that happening?
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, linux-xfs@vger.kernel.org
References: <B96A5598-3A5F-4166-8566-2792E5AADB3E@karlsbakk.net>
 <8a9071104eec47d91ab44c86465d08d76e0cf808.camel@gmail.com>
 <aJnKcktFW6jPBETP@infradead.org> <20250811152532.GH7965@frogsfrogsfrogs>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20250811152532.GH7965@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 8/11/25 20:55, Darrick J. Wong wrote:
> On Mon, Aug 11, 2025 at 03:48:18AM -0700, Christoph Hellwig wrote:
>> On Tue, Aug 05, 2025 at 10:20:15AM +0530, Nirjhar Roy (IBM) wrote:
>>> On Mon, 2025-08-04 at 17:13 +0200, Roy Sigurd Karlsbakk wrote:
>>>> Hi all!
>>>>
>>>> I beleive I heard something from someone some time back about work in progress on shrinking xfs filesystems. Is this something that's been worked with or have I been lied to or just had a nice dream?
>>>>
>>>> roy
>>> I have recently posted an RFC[1]. The work is based/inspired from an old RFC[2] by Gao and ideas
>>> given by Dave Chinner.
>> Like the previous attempts it doesn't seem to include an attempt to
>> address the elephant in the room:  moving inodes out of the to be
>> removed AGs or tail blocks of an AG.
> Anyone who wants to finish the evacuation part is welcome to pick this
> up:
> https://lore.kernel.org/linux-xfs/173568777852.2709794.6356870909327619205.stgit@frogsfrogsfrogs/

Hi Darrick,

I am working on the extending my online shrink fs work [1] to realtime 
fs shrink and as a part of that project, I am looking into the patchbomb 
above - specifically " [PATCHSET 3/5] xfsprogs: defragment free space". 
I have a high level questions before I delve deep into the patches above:

1. Can you please elaborate a bit on what do you mean by "finish the 
evacuation part"? I took a very high level look at the patch, and it 
seems it is already adding support to move data from one rtg/AG to another?

--NR

>
> --D

-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

