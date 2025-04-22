Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A88728136B;
	Tue, 22 Apr 2025 13:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745330182; cv=none; b=seBsvxQsji+29LANehbU6R2zJB4gf0Iqmek+anM4+K6PhZWepNFNt1qZgdaQsLzn3pFjiTaZGp7RFKQ6UQPbNUtDC5P/angV/+LkXxcQWZfAihX+lu42NVEnqTtPbMaB52WqW5igb50PrjqPsHSb1FJbRGTdqScrryAR9x4GkPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745330182; c=relaxed/simple;
	bh=8SEW95m+vZxiG981zwzLbOenIT1ihvqC1+XXm9Cjwy4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uGXKsPZBpeTFoe0Erd1txJ+g2UyhXlU/ipO3GJ3VTjfcZPLvSurucSELCOZM6hlaP7ChmHyI7e/1z6yXrYVuovisz5KMrvYO681vEHOKnM3kxGJSmZr+TuOaBl7OA7lplYzrTci54GJZ+OnsN60QaX4Ke0gm5QPhAd6idwgtDf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g4bCbWXB; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g4bCbWXB"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-736dd9c4b40so5417362b3a.0;
        Tue, 22 Apr 2025 06:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745330180; x=1745934980; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=7KaKEEvu0UJyVW+Z2ph1QObcx2UHRtosoFsRJXZoV64=;
        b=g4bCbWXBREtrl3kn5A/2+1hZ7KsBXOgnULG5ZqdCo/9gxqtZWh8Ead7TetzHiozc9W
         M31k1FUHkfNptzfuRVmlTmcMvq3pSLjrLoUOo0XfX2S2UG2CAv9vjcZxGRHLn/w1DNpI
         9O5NPCDTwsbODwFwGdrnkM7s2hinBgFTrG4zYrpKE2FaEiDY87hrQ0kZUVTrdMSuNf2u
         v3vlBSWaRDrVBtkRL2salM+ckQBq4ouUTZqCSeXBjoi7LgIoxhDrhcQw9hR9YFHubgrn
         I2lhQ6fCnRjk+zPXJ8FReNJqKzdsns7NwD8AdwFq40pqbQZcbjoZqeXa6uaYVIN5irJ1
         PwZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745330180; x=1745934980;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7KaKEEvu0UJyVW+Z2ph1QObcx2UHRtosoFsRJXZoV64=;
        b=Bmz4abIJ6vmPUFptdjX4tYt4Gc+Q/k/aDcRXIoB9rdrgc8xF3lhgY+u5bHEb6MI5FW
         byW3YFjqKixkqfXEC6BJ/2EH2LA1Bjxkmksq6UOZJsXRoX8P8khUkKG3HcdY4j/sfUjI
         g29tNIMBaBEd8Vb1JHQqN7XT79CXHJC19sC1KrhiKzjmFVwamzlWa0bCnDHBQMjGElKg
         dAw91IcDwSEu57I6HvsdYFMbMU/Lc5B12KH2n9i0zDVDR3F3/ibzw783K3haX8Wb2Sn3
         +doRGuwQ7N9w9Azi3swTYC3z9fLnzy4gqNakN/2BoPoxOjj7ip6qUfJBS7156mZW2r9z
         Aq+g==
X-Forwarded-Encrypted: i=1; AJvYcCVI3cgFcG4efMc+rvutlZyY8TjfdN19OWDNOyUPfUngDvrM7/D9eNXq0lrZxfW6BFRUkDHUhCqzzEfi@vger.kernel.org, AJvYcCWZqwVNrSHgwsT/ue2IXCxTenXMGcikbIBO8TOxQoNiJNH1OI/FkU83YyDSA19az8NhTHw9axDZl1lqdJY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8cxIpyjWOS1PM0tzp7gPxJjfwKgiSxTzOUmId1g4mQQZy312C
	6cXUcjZizneHUrIn9tQjNLhRf5+s8KIvYncC1OgmjihwnVQyuJoo
X-Gm-Gg: ASbGnctrycn3f40sf1E1LRyAt79inhnW4ZK6k/Zd3H42yeXfT6vHgNSea82hLGsjOLv
	NUXCO37eYgKEwTJQAV50J99+0G7Kz9cTJnerWJ6v/JkK2zFIC7pZYM3DJkMd/91MtC9FF6MIbTG
	BXBzB+vEfvhKU5/JbY9kN9r6LbhwW5BTHf++kA7imljWgSQajLW0UwNPg7KfS1AaOvPxdmGA30b
	EBkibacFBzRe5GE+40xx0NPaMNIhuyrj8UqHmYJGU+U9hyvxz4gIalit57tW0aTZMwyZeTO+7/g
	xIaPDv5iLY0EWr715OQfKrNTVng+OVoZiqS6xrkX5w5X6taSW9OKJfmCbR/vH0u8gO/ssgYnU3X
	BfbQXrUy6wYSrKw==
X-Google-Smtp-Source: AGHT+IGc5WnybySe4c344IiNQHqU74ZHT8nMbhNCRflaKFjYTzoM71nNXEx81AqRoVn08p7q/qXtTQ==
X-Received: by 2002:a05:6a00:4b03:b0:725:4a1b:38ec with SMTP id d2e1a72fcca58-73dbe4e6458mr24353404b3a.3.1745330180144;
        Tue, 22 Apr 2025 06:56:20 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73dbfaaf900sm8536318b3a.154.2025.04.22.06.56.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 06:56:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <fb2ddf20-d978-4aab-bbb4-0a3e86fb28df@roeck-us.net>
Date: Tue, 22 Apr 2025 06:56:18 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] XFS: fix zoned gc threshold math for 32-bit arches
To: cem@kernel.org, linux-xfs@vger.kernel.org
Cc: hch@lst.de, Hans.Holmberg@wdc.com, linux-kernel@vger.kernel.org,
 oe-kbuild-all@lists.linux.dev
References: <20250422125501.1016384-1-cem@kernel.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20250422125501.1016384-1-cem@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/22/25 05:54, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> xfs_zoned_need_gc makes use of mult_frac() to calculate the threshold
> for triggering the zoned garbage collector, but, turns out mult_frac()
> doesn't properly work with 64-bit data types and this caused build
> failures on some 32-bit architectures.
> 
> Fix this by essentially open coding mult_frac() in a 64-bit friendly
> way.
> 
> Notice we don't need to bother with counters underflow here because
> xfs_estimate_freecounter() will always return a positive value, as it
> leverages percpu_counter_read_positive to read such counters.
> 
> Fixes: 845abeb1f06a ("xfs: add tunable threshold parameter for triggering zone GC")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202504181233.F7D9Atra-lkp@intel.com/
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Succesfully built openrisc:allmodconfig and parisc:allmodconfig with gcc 13.3.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter

