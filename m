Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A96718DB37;
	Wed, 14 May 2025 17:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747244615; cv=none; b=Wqm2NTkkVnTPu538XCnBDlPkNExftzP47zj3KQbrruKTyDwZnGLcjsA/6H30v+4EZAdJRrR+qEwNDC28drE3NPYWzAh8LicdnrKxhAcmjhVusUeZBPDY1dvkAbcW3xAESmuAVqHhAq8LBQpCs1ZZQvsPkCu+haF0b6CAjlTkl98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747244615; c=relaxed/simple;
	bh=AdAmQcxQnCFu3rV/G2z3F7z8L9E3py85R4rxUsaZqTs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UCUFI1JkcSVnobiNqj7BJ4j8bD5UKg2dzOsLgxvj1zl1n/mr7x7JGikI1h4+u3AovTn1YRjb1SvlU1WSs9m3cUXlZpvVFjBv3ViFs53lyURyZWOKhgM175KOnVJygtVa6IEJ3KF724JiBbiTUx8kTTSoSjf0PJNYLGNZGTLFQqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F0sSkeny; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F0sSkeny"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7376e311086so150884b3a.3;
        Wed, 14 May 2025 10:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747244613; x=1747849413; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fc2ve+7pto8+Oknm6tlbzqYdpwnfTnplvzDEKXv4S7E=;
        b=F0sSkenyFlDxZ5wHCjBIWnqyLKozbmXH3ojDMgwU9I4rVLPm2Sya5pSD/UnMHlfc9D
         /1ECpxCv5Hin7Gj1JDNX/36oyApwGPVZD2LleMhJeObURiY1naQev/nidjAFpEGTKG7E
         LV9NywVsXieyDvpLNopRHoTwmWuJ19SBSY2252uTumRN8Yda7dFiGyNq5N4WYr7rqo7R
         kkhELCC67sYEIHtqS7BCOp6ikTIp//lFi0SW6TyPex8dYYgu8xtbDKnwNqcjJfUvA4Rl
         ZkfjfeL7DwOPd/8rhkzYuICMrxgAIhyHm1gOdYYJtmZ2LXlJ8fPaTRCkrRIAKBg6FJVH
         K7Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747244613; x=1747849413;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fc2ve+7pto8+Oknm6tlbzqYdpwnfTnplvzDEKXv4S7E=;
        b=NiM125YSucaPIOw00gUlP/SqmI2+xTDb24eVF2mjmzZVvwMY2O23Qo/d85Cpr63W/y
         iEitMzPmqhVHwoXu/Ko7P62HzvSQrf6gaGznVUG3M5Yh4Q8Yiwjl3vs2LjI6yW7Fw2GN
         pZNr/ZZloGx0385vVFmYfW6M6oXnRFF8vDLuxGeBJlH5XOeQXCFZX1NpEm1fk+WSd+X2
         yP9NzQIVOfV0KeoVEAw2piCPjlf8c3vBuN1n3BR177QRZkq+9enMia6zprzsy442hn9O
         fkifbsUjX6P1bNs1YlwTnGebWa9OvEQK53RNlyXqkP4YB2MvxlkM1JlEvnVYF/9ZrH/F
         3xhQ==
X-Forwarded-Encrypted: i=1; AJvYcCX7E8bz+9yO78E8Gq5XlUOIYdPf1Z8s77sYueaWasO/0YkSof7oKOduDuqZdudoOBmjCZXBumaZr7U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcpcYBGQqxTEkM526QCU8YUyWqOOCmwlHGZUCFZfFho8A/ZFxz
	LQMAorjdOViv0Jp8nvCsyl+K5nbzIMqfA6XctB+s+LYET5LiDsHu
X-Gm-Gg: ASbGncvgk4o1suew6QwySaPv2szp2OGZOAOIUzbjxM2nufghKAhE9cbnfMCJdoaAiuq
	G13B7RduNWD4l7H2P8ZBseoNp/MYGKJYr040pstNVQtsrwaDvUe+sallyffWZOunTaD/NtcV9Wq
	Fs1gSOEZx8+i0STtAHyk03dr/nIOGEV9GmrN/llkOXH/ad1wKca2LgEyE0nLLWU2nGTlb/Gj9Jc
	2OGWIGzCRHmVYk97UvqB/LFeOgCZOwBI3jv/d/qK3t7K/QGmOZ88GtK9EC5ocsswr78Hrl6TK/D
	qbyU9+xFw6SGjgDoq+VWZ3cNe7K0kMKwfc0bxY7VCc5ksCnNsU/7cWRIbEkNBQ==
X-Google-Smtp-Source: AGHT+IHlzRHKH0FJwVqi8OtGHi3nTpsiwD5J67FhK1MN7DIfxaICdA5oqxb1zzd2N+oxikwldCLMDg==
X-Received: by 2002:a05:6a00:800a:b0:736:5b85:a911 with SMTP id d2e1a72fcca58-7428927c419mr7743802b3a.8.1747244613265;
        Wed, 14 May 2025 10:43:33 -0700 (PDT)
Received: from [192.168.0.120] ([49.205.34.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237a8f45csm10028016b3a.178.2025.05.14.10.43.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 May 2025 10:43:32 -0700 (PDT)
Message-ID: <fff1fd94-2c48-4ed5-9952-9a4079c02796@gmail.com>
Date: Wed, 14 May 2025 23:13:27 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/1] xfs: Fail remount with noattr2 on a v5 xfs with v4
 enabled kernel.
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
 djwong@kernel.org, zlang@kernel.org, david@fromorbit.com, hch@infradead.org
References: <cover.1747067101.git.nirjhar.roy.lists@gmail.com>
 <174724383763.752716.8413533777890731819.b4-ty@kernel.org>
Content-Language: en-US
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <174724383763.752716.8413533777890731819.b4-ty@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 5/14/25 23:00, Carlos Maiolino wrote:
> On Mon, 12 May 2025 22:00:31 +0530, Nirjhar Roy (IBM) wrote:
>> This patch fixes an issue where remount with noattr2 doesn't fail explicitly
>> on v5 xfs with CONFIG_XFS_SUPPORT_V4=y. Details are there in the commit message
>> of the patch.
>>
>> Related discussion in [1].
>>
>> [v5] --> v6
>>   - Added RB from Carlos in the commit message.
>>   - Some formatting fixes in the comments (suggested by Christoph)
>>
>> [...]
> Applied to for-next, thanks!
>
> [1/1] xfs: Fail remount with noattr2 on a v5 with v4 enabled
>        commit: 95b613339c0e5fe651a3ef7605708478bc34a5af

Thank you so much.

--NR

>
> Best regards,

-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

