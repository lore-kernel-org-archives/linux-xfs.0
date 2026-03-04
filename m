Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2B4320CAC
	for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2026 02:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772592170; cv=none; b=EVJ2Dnpwx9K28d5juoEyPW3Wkvm9khMLJrkEpATogFmtynPRamCHYpKauqB/o/cK6xjsVkomF+rL6GhzfqwNuh3EkhqJnc/lMN6toYF/951iqlG8h7K2mi7raRUlqGnpKq8lS3QUOjMHd+nYPVJCSrbLdPrIWGlKm4othlh2BO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772592170; c=relaxed/simple;
	bh=/XWSBClgiVO9Y8DcC9EFb3ReAwqS4B91iVSCE58gCGI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E54tNdVudDfCGz/g0FvXb9oUbOVm+ZWPx2O/stR5Bh5ESogW2KRJFFSXaUlf/aq6QLSnTVnELABGE51Rtc7j5qsJVl91iTgzqQoWNHpCf3CFpX0trQR95TRW98LGg/9k23B6OoskQqj0FXR94XsrrSWYIbWVcr1H2N8CGnYlXf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IPhOHuwC; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IPhOHuwC"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7d596a5be31so5399304a34.3
        for <linux-xfs@vger.kernel.org>; Tue, 03 Mar 2026 18:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772592167; x=1773196967; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W7dycZCW1i0wVXbu5i6p68JSQ3h2ubeTDMrk86ISU5M=;
        b=IPhOHuwCkLxyO4EpVYKpsls/Zk3bTYDr5gDNc4xJLUJDrnHiuJvGo0QgTRDd2+azUI
         pBX7Ba63Ei2YcOW2FGUGqlAj8LqqRwSa//bkEQLtCRavpeOADrrPKjCBZNutxytn4MZ5
         OZEpxGLp1B6KtkZNUZgXw8tl5CEfC5T8MQ7w+9SpgfhFxpzLj3eoi8hJc1EkkoeFRy0L
         2ezE9sDKG9Hh/wv3ayonBYBOaDXBydfLvmECeCULO8nl3pjIka6h2HJdWvpcyBtlmr4X
         mtMWK8GukJd0X04q7jCU4Zap+hsdXVcvrtEXCg3weUaV9cy6+EK1O5kAbAwQ5Nk2xVkc
         c6RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772592167; x=1773196967;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W7dycZCW1i0wVXbu5i6p68JSQ3h2ubeTDMrk86ISU5M=;
        b=amjnkPmX6Ptpsyhn55DsVuzyhHRg+ROuyjc1uctzoMVEzceajZB6A2rYnEMXIgPUfm
         MnD3eju4OWRK0iCeAWFkbnSfLrCyCYFDYzx0gsMVPZ+hlOLI/grfc8ypT2GZkqcmBK/T
         lMvc8nVP6pkqauRQxWyCbXsqTZJymfysAMKWr48WG+gkwq81wDTiDC6QkcoUz0PrkHRT
         Ld8ewXQMUAyKrYd02aTRrL/UYU6ddFOlsHeP0M9PMzP8ubPmhgPrfQTtkPA0WLkkp27y
         4Dnk8iRX3M/6ZggRdKxZHjWPto4qT72t5ni5qG4/17aNTkNK8sb0IOB3jDgHO7xJDeBA
         /gWw==
X-Forwarded-Encrypted: i=1; AJvYcCVl83h4QKNnyerIzM97PZ24sTBF0fSrnylmNmx6jXZWSXP8QfQ8gB06BdTzm6fMcOWHxk2U72VIOnE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTU4OCVU2GvDrSbIIv/4PBiDsfqeX9Mqd6fOitJcKUFuu+LCLA
	CYijZev44JRudwfh43yMPKMFLV1szFH2XjIZas5uewSwky5Hi61c2MopduBNhqwYUVI=
X-Gm-Gg: ATEYQzyo+InUrSKjymIM5fZUA/wkGNTYlGRUSF7Rct6T8BvQ4PmqrJb3GerWiKdvTFm
	KHZWXcaC0gp9antsVUlo83Jgs5nAu9OPw5uNNCrdWjWokphJYNvn7hDi8CrqAf4VHTW4yVOpH88
	FQzaCZtVFUL+S8biaZFqo4b+NMzGJIPQOW6IeL8T2ZjdAuzuX/HN0Urfc4QWWDXfkMHuYGw9Ju/
	6AMcbdUCjFwu8bHdr21rPP3Ni5i9zhGir2YusIL+M16KsbXJcZXxOaeoNZgF6bQbzTkU7NLOI+F
	CpRH0snm23ts+uhLVtFxx3Z7dGberhgL4WDCXVkP4mIGBz0pU0UXgux18TtTUBqQcGe3fq3x1ML
	98BfuVflIeE7Mmr0lFlFkcuKtW7apcCkitSakAfhF5vO7gP947JADecqgONH+fcP7N+WNSJFFZG
	s6yqeRnH8Gr2ULfF6VJzL0A7PphFKtNSzKMZa4PZi1XlyIC5GGBfFi6Mzz9wKCKAhLlMWvW2Zvn
	u8QAambsg==
X-Received: by 2002:a05:6820:4a8e:b0:66a:1886:e4bf with SMTP id 006d021491bc7-67b17703546mr346906eaf.22.1772592166871;
        Tue, 03 Mar 2026 18:42:46 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-679f2bfee3csm12574800eaf.7.2026.03.03.18.42.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2026 18:42:45 -0800 (PST)
Message-ID: <f8d86743-6231-414d-a5e8-65e867123fea@kernel.dk>
Date: Tue, 3 Mar 2026 19:42:40 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] mm: globalize rest_of_page() macro
To: Jakub Kicinski <kuba@kernel.org>, Yury Norov <ynorov@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>, "Michael S. Tsirkin"
 <mst@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexander Duyck <alexanderduyck@fb.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Alexandra Winter <wintera@linux.ibm.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Anna Schumaker <anna@kernel.org>,
 Anton Yakovlev <anton.yakovlev@opensynergy.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Aswin Karuvally <aswin@linux.ibm.com>, Borislav Petkov <bp@alien8.de>,
 Carlos Maiolino <cem@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Yu <chao@kernel.org>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Christian Brauner <brauner@kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, David Airlie <airlied@gmail.com>,
 Dominique Martinet <asmadeus@codewreck.org>,
 Dongsheng Yang <dongsheng.yang@linux.dev>, Eric Dumazet
 <edumazet@google.com>, Eric Van Hensbergen <ericvh@kernel.org>,
 Heiko Carstens <hca@linux.ibm.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@redhat.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Jani Nikula <jani.nikula@linux.intel.com>,
 Janosch Frank <frankja@linux.ibm.com>, Jaroslav Kysela <perex@perex.cz>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Latchesar Ionkov <lucho@ionkov.net>, Linus Walleij <linusw@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Mark Brown <broonie@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, Miklos Szeredi <miklos@szeredi.hu>,
 Namhyung Kim <namhyung@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paolo Abeni <pabeni@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Sean Christopherson <seanjc@google.com>, Simona Vetter <simona@ffwll.ch>,
 Takashi Iwai <tiwai@suse.com>, Thomas Gleixner <tglx@kernel.org>,
 Trond Myklebust <trondmy@kernel.org>, Tvrtko Ursulin <tursulin@ursulin.net>,
 Vasily Gorbik <gor@linux.ibm.com>, Will Deacon <will@kernel.org>,
 Yury Norov <yury.norov@gmail.com>, Zheng Gu <cengku@gmail.com>,
 linux-kernel@vger.kernel.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-block@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 dm-devel@lists.linux.dev, netdev@vger.kernel.org, linux-spi@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-crypto@vger.kernel.org, linux-mm@kvack.org,
 linux-perf-users@vger.kernel.org, v9fs@lists.linux.dev,
 virtualization@lists.linux.dev, linux-sound@vger.kernel.org
References: <20260304012717.201797-1-ynorov@nvidia.com>
 <20260303182845.250bb2de@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260303182845.250bb2de@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/3/26 7:28 PM, Jakub Kicinski wrote:
> On Tue,  3 Mar 2026 20:27:08 -0500 Yury Norov wrote:
>> The net/9p networking driver has a handy macro to calculate the
>> amount of bytes from a given pointer to the end of page. Move it
>> to core/mm, and apply tree-wide. No functional changes intended.
>>
>> This series was originally introduced as a single patch #07/12 in:
>>
>> https://lore.kernel.org/all/20260219181407.290201-1-ynorov@nvidia.com/
>>
>> Split it for better granularity and submit separately.
> 
> I don't get what the motivation is here. Another helper developers
> and readers of the code will need to know about just to replace 
> obvious and easy to comprehend math.

I fully agree, I had the same thought reading this.

-- 
Jens Axboe
