Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602B233E363
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 14:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771512059; cv=none; b=GOoWoaoZA4Stp8tQPirK5vUPk8zYasu0xSipwfGXBxSy6XTRy0WuO4MC30y7CJNEggEzPRZVLFneYl13XuOcz+ei9GJIarLa6hBlZSCqPcLO0+TC9IXT7QjR8gT63MJJUJLzrl8RUZZYg0+AWQRM45W7OzlwJ57czGDSGkCt8Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771512059; c=relaxed/simple;
	bh=PhoA057osy1i3S+HKrAbmX1QXkZS5ZyPJtJHB8Kf4rU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nOU33yW6pp8BdVU1S0HKmYgqG/2hOAq93DuEOUfKFVyLkOhkqjPSyeU4VcLvEE5YzKiUsmXB2wXOuHr7QOHbBJT7CV0tHgipWgvzpS4dgqPX68C4BCxYClo8w4591L/0t+CnGEPTsiyvSz3LVMMCXcEQtRhUU7AMyoJugWBTM7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iUqlOiCM; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iUqlOiCM"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a962230847so8233605ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 06:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771512058; x=1772116858; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zbIFaxq5xcyvqtoFGbdoji7321OG3eY0gh9+VmeT0ck=;
        b=iUqlOiCMA4hmpvVHgklk4iz/m3syJ5mQDPcvTF/lkhK1HxPwEorCSNVhTnLis383kj
         h3oX4EyMKtDBJwc8oKut7gG4IHjl2qWMKVGAnxT9qI/9CG9e5QT/1wasjpKlIrYDcFns
         flwycemf8sEBERDI3fheAUeUIDIfIiB7OypHCEN8P3Iv0+f3dEUv8z4o08zxXA79zxf5
         Ysa5D0ZJxBPRftEtCVyw1jkKUfhdTVtoxs5rXaIjzMUPPr+mALoMDNq9kuKeD08q8L6r
         wsqyvMmBRml/rPuhaJgVwELUQWZFXUeZyiJr0pOlBgn++pL56k6LpXyQMlQVA9Lo8TKg
         BbjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771512058; x=1772116858;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zbIFaxq5xcyvqtoFGbdoji7321OG3eY0gh9+VmeT0ck=;
        b=mDCQOcVL3CDxvVQvmQXVYKMKovYZQWdp6yG2UYGU+0Uyq3B35ORIoSy5m8gHbKspzE
         E3oP9lstRQ+aMJDV9UAFbnt59q7+0jxDGLK1kHWdNmIDaI/mQgmfRExrDlF7L6XuP31a
         SQEG7EDKAOHh6JZaLWT8ZHiwqcAJImjF3wG6ADuc4m47pB6Ae//6c4FxRGlpL+WKGjRT
         88NP3C1KGnvremuGD1IN7HwkeDaqWnDH70262MT+kQqIh5Cuyo8FlzNTMy/yBvGSSRzV
         VTKuu10V4BaRkyXg3DBMjlrvzbp38YdTf2FcSxk7ZvyFy+8SijTzKor4OnQrxHbj6ZLD
         3XEw==
X-Forwarded-Encrypted: i=1; AJvYcCV1TRpJXg3A/HuTW/6JOyKHdL7R90W1gYR5EIBxerVLRLi4jD9JtPKYnVoo4zaa+2ocny8oFFsx+H8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMrB/2fooJSLSO61Xd+721ocdQ80tVyDLQqMRnXeA7bqS3nDil
	/HnvX5phE0UVCvdjYhKThMaWcW9OD0KmyHn0aQ1G1vsspzujy7SbJoUc
X-Gm-Gg: AZuq6aKma/kW/PxLD3InLctanmkgsLUqLaHXFMzVNyo1erpB53lvlelgVMAKFhSfzwJ
	WWfRICsOJS1PGEdidoJAIvk7mZTdevFaKypAz7BZ8DdcJjxpaVLfwU+oGKS2eCGBxwKneTv5jCO
	DCmfjO3J0jTgFoCmtp541PoWunYUsif59EZoubtQhKJG5xY90cx/MOy+X8PtEBosPMmP2CntkjW
	kXx5tW3Ib9XM47JQaQuHFX0WQzfrW1j5XmeiuXrrdfkW82cxOuN4nd2o1u6+RH7Ejs5tBaEFkh4
	VMZyRPOpVt7MTCComjj6aMoS8Lvj6ImxM3xBYsvKUwLeoEe1fLZp3I4yVy30gHsg0J4UZGSC7UH
	eKegQ6HONLQrKHw894vSkJcyykaUyEGSjWjFd7G+nC6/IE27//IiRwmdLiQZoyWArAGc7aMDZJu
	4toqdHF61/kuh2ZIxPwPFCHAgwlJkpEPcTWeV1Kw==
X-Received: by 2002:a17:903:3c6f:b0:2aa:d320:e969 with SMTP id d9443c01a7336-2ad50e5a717mr48246455ad.8.1771512057695;
        Thu, 19 Feb 2026 06:40:57 -0800 (PST)
Received: from [192.168.0.120] ([49.207.232.214])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a73053dsm172985165ad.35.2026.02.19.06.40.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Feb 2026 06:40:57 -0800 (PST)
Message-ID: <dd1b584b-987c-4dce-b84c-c9fe74687e95@gmail.com>
Date: Thu, 19 Feb 2026 20:10:50 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/7] Add multi rtgroup grow and shrink tests
Content-Language: en-US
To: Carlos Maiolino <cem@kernel.org>,
 "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
Cc: djwong@kernel.org, hch@infradead.org, david@fromorbit.com,
 zlang@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
 ritesh.list@gmail.com, ojaswin@linux.ibm.com, hsiangkao@linux.alibaba.com
References: <20260219055737.769860-1-nirjhar@linux.ibm.com>
 <cover.1771425357.git.nirjhar.roy.lists@gmail.com>
 <aZcIEd9DY_bQGJ9L@nidhogg.toxiclabs.cc>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <aZcIEd9DY_bQGJ9L@nidhogg.toxiclabs.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/19/26 18:25, Carlos Maiolino wrote:
> On Thu, Feb 19, 2026 at 06:10:48AM +0000, Nirjhar Roy (IBM) wrote:
>> From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
>>
>> This series adds several tests to validate the XFS realtime fs growth and
>> shrink functionality.
>> It begins with the introduction of some preconditions and helper
>> functions, then some tests that validate realtime group growth, followed
>> by realtime group shrink/removal tests and ends with a test that
>> validates both growth and shrink functionality together.
>> Individual patches have the details.
> Please don't send new versions in reply to the old one, it just make
> hard to pull patches from the list. b4 usually doesn't handle it
> gracefully.

This entire series is new i.e, the kernel changes, fstests and the 
xfsprogs changes. Can you please explain as to what do you mean by the 
old version? Which old are version are you referring to?

--NR

>
>> Nirjhar Roy (IBM) (7):
>>    xfs: Introduce _require_realtime_xfs_{shrink,grow} pre-condition
>>    xfs: Introduce helpers to count the number of bitmap and summary
>>      inodes
>>    xfs: Add realtime group grow tests
>>    xfs: Add multi rt group grow + shutdown + recovery tests
>>    xfs: Add realtime group shrink tests
>>    xfs: Add multi rt group shrink + shutdown + recovery tests
>>    xfs: Add parallel back to back grow/shrink tests
>>
>>   common/xfs        |  65 +++++++++++++++-
>>   tests/xfs/333     |  95 +++++++++++++++++++++++
>>   tests/xfs/333.out |   5 ++
>>   tests/xfs/539     | 190 ++++++++++++++++++++++++++++++++++++++++++++++
>>   tests/xfs/539.out |  19 +++++
>>   tests/xfs/611     |  97 +++++++++++++++++++++++
>>   tests/xfs/611.out |   5 ++
>>   tests/xfs/654     |  90 ++++++++++++++++++++++
>>   tests/xfs/654.out |   5 ++
>>   tests/xfs/655     | 151 ++++++++++++++++++++++++++++++++++++
>>   tests/xfs/655.out |  13 ++++
>>   11 files changed, 734 insertions(+), 1 deletion(-)
>>   create mode 100755 tests/xfs/333
>>   create mode 100644 tests/xfs/333.out
>>   create mode 100755 tests/xfs/539
>>   create mode 100644 tests/xfs/539.out
>>   create mode 100755 tests/xfs/611
>>   create mode 100644 tests/xfs/611.out
>>   create mode 100755 tests/xfs/654
>>   create mode 100644 tests/xfs/654.out
>>   create mode 100755 tests/xfs/655
>>   create mode 100644 tests/xfs/655.out
>>
>> -- 
>> 2.34.1
>>
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

