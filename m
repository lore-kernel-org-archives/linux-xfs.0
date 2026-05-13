Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3140125B08B
	for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 17:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778692514; cv=none; b=NDkg/aV5WBD7ebDs/rG0JjUKOwCI42DuLxwjl14XWgzMNKt/IJX2rg76Yv10U6Ad3bkmSkEUUwnj2bA80lojKbmMmu4i+doCoFVXVIKI5GFn8wBfN/2Il9c/FDCIRbz+uqeOkCR7F0ftXcMwlSZr4blkFLWVQnKjcJ5ishe+mYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778692514; c=relaxed/simple;
	bh=Iaz4Ta7/aArc8u5jlDHa5DhHsZ4NcZfOvMTNbV7KGSM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YEaxyUUGWQYg2FBcZdCZbL3PUUdtUhrcQFunMDFLpvqkvLcH2pzhIaJHJcWUmMvzv+ZA5F3etyicxOdd22jIarQ+UBTXP3L6HB/OBJQ7vgfVTJOx8BgBfhjCI2COCV2umwuyGiC1cRx29FCx+uRGwrMmakh3X/+f9y9yGP7dEQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=EdLZOvWG; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="EdLZOvWG"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-479d85152c9so2915449b6e.2
        for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 10:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778692509; x=1779297309; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FzcET/6EBA26O2gB5meYX8WxvSiEZYzWqssd3s1sb8s=;
        b=EdLZOvWGT9Gnb7r2EIssEUFb9Ljn0BYDLGWy9ymz9FZ/DZtvVdF4eMU9RevEFGtC6+
         FnuUbwavKhWjOqLsCPGzAbjIN3EnJ1m9J93YrxB43NTFqVnKOUrg7vqeGG1TcBKuND4h
         l8HzsyFnYfosMcHpn/kA7XvcbGtkibEW6JVCBR1Lyw6QBVLcKpKyFHqhCe9UXvUCgOa3
         W9eSHmyjDwVEufcWBfCOi/oBpX5LJg74IkGaWHG8OdNcDjmEASRLv4YqnCDFize26s25
         YdCpETz1XXOKMvG3wGIBAKaesTi9NMrfV+fNjbEcXbS+5IEZ1+PBFWKdmYo0+Thz4fU0
         gA5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778692509; x=1779297309;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FzcET/6EBA26O2gB5meYX8WxvSiEZYzWqssd3s1sb8s=;
        b=LsWj1DolpqboiLl5PiK8yGgwec+J6HLsKbEVHHcxbBAfuDbGtJdCRXfvrYRFvxl4D+
         E8s7dNKz1/DpC7+8bA6lBO223jZJQ95dZoEuifmz3O9bDN6UU+g4vDHsBvEjJqteREEw
         XrnjjhcM4QENmRgZXjsJyYQQG1qhc7TVqykN8HMiKHA4KNxzK5k6tMazNWxBLv+VxDPT
         EFpu9Cyy+KWUVYvalBlE+YYpGgVq8K3WIsHkfSiAx8/tafzzSN2qky7fgI+IAvEUhbjT
         tMzgKzuzLIJnQOQlMTy6cu3OZaSzqvxPWuwVa/dups5nQZL1c9yjowRE76o/aGj//rnr
         CYMg==
X-Forwarded-Encrypted: i=1; AFNElJ9kH/Y22z69Rfb/hPLWH0AW+rH0bNe66r/bC98b4Vdd3qIIhs3L83vPyd/EpasTTTjPO/qG3tgQ7IY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzVU//rW5c0CHbop0KStE7Wori23Ox5M5e4bc314OQCT5mgjA8
	Ilxq9zZAWzA8ovdsS6fLqYWg12EqUa2hwscNIuDtM4alfmp5vyW112zLKpf54Anl+rU=
X-Gm-Gg: Acq92OH/0ARH1hIqeOE1YMryvSgYIbXOO1B4po/YHd6+/o1nBoJ54fdF6BFuAc+8d1I
	GLUPV4Xyv3Hi3rp93Jy/lwzAnkg0KEn/+cQIcQgVHunnJR0StAWGB3bNW0mavHxRlJeDw/yb0BW
	H023UvTU5RXHc9MQAGrAMKxUbCtfwEyM2b9h4iR+nyGGvSRAAC7XpripEQDwRBzLK5JBKDhUDub
	j9owae6qhpzfKfVRaIokcj9K2ZMWrPV/Gx8oaXfi0SyKxj+3MpkjC+2tSITxYEuJisLief6RQ3+
	BbX7qEi45q9odRyYOJeVKRObAQpoX11RdbFaUTdHuqFKEaEq2LB4uEUbGGcDRR3pZkTe3aEbc0R
	D7PjoPExJqbtiQh3vwswmhLnnIKKHC8QCjlxs/bW9qkAaUGR95ZARv5Ph7I9EZi673nqzTTinns
	7kSpuMpa+XuRHGFrPSDXOaFv9CtHjj9sjJniZgG+r6U6uF/V18QHRi2NPL4IlCIMZeLlRHZKG35
	RRw/clW
X-Received: by 2002:a05:6820:4b0b:b0:696:1fae:fb83 with SMTP id 006d021491bc7-69b78dd8381mr2499356eaf.34.1778692509425;
        Wed, 13 May 2026 10:15:09 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69b25e0dbb5sm9611857eaf.13.2026.05.13.10.15.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 10:15:08 -0700 (PDT)
Message-ID: <683792db-32fc-4765-9ba6-3712af01676c@kernel.dk>
Date: Wed, 13 May 2026 11:15:07 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: fix block layer bounce buffering for block size > PAGE_SIZE v2
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>,
 Pankaj Raghav <pankaj.raghav@linux.dev>, linux-block@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20260507050153.1298375-1-hch@lst.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260507050153.1298375-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/6/26 11:01 PM, Christoph Hellwig wrote:
> Hi all,
> 
> this series has two fixes that make the new block layer bounce
> buffering code work for the block size > PAGE_SIZE case.
> 
> Changes since v1:
>  - update a commit log to better describe the applicability

Can we get some Fixes tags on these, please?

-- 
Jens Axboe

