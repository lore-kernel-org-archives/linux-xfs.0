Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF5D272E54
	for <linux-xfs@vger.kernel.org>; Thu, 10 Jul 2025 15:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752160130; cv=none; b=JrYaScSGSF/MWsh6OmPEPsjgKj6qsMKgrQ+CUJMB4Nd1h9Y7QHHQcc7GnPHJP//TlK0/kX/vyJc5rKm3xKEnHxIAqyQxet64UgYdHR1iZkI52XKRLnCkpxooyXXMPhIrVtrpcPOig5CHFqe8yrj2PXC3bL8SzGm8g4NrfJVvzTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752160130; c=relaxed/simple;
	bh=QyVa336Ax4fYxIVQnHT2lv1xl803ARX1EKCvvArbBpo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qyWX2My1IhfFqR0mj37JJL+0mN0hLJza3lMvkxy0vyBkDOWu9I/i5ei3W9eHdAdRZiWWMj7INFkwq5F82/lJiJAMWUNFAx+tGCqDzQzIEwtdhVSzM0UzoFcn3u06EEnvk4z4xhuI/SsZ+/VQIbkc8Z/qB7vS15qLk0j8yI2by7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hygZvzP2; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hygZvzP2"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-875ce3c8e24so43320639f.1
        for <linux-xfs@vger.kernel.org>; Thu, 10 Jul 2025 08:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752160127; x=1752764927; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ge1nC4yCBIiNPQ1G0qBajhIAzAiOK+EhF/zLDgsIM/U=;
        b=hygZvzP26whIkw5yAmbYEnJbTkbkptUkFYL+QQqXQqP7RQ9Z/WHtj1KVe+IchID8uo
         z5Uz0KBbeDaPrn+1ds8EXobtSe8pmxU2q5jxYg/I8DD5PtsbsiyN4xYuJiwJnYG8k8EF
         GEu+5BVrt8igKHkHv0TSnujJhRWTmkAtYDRWyZH0Jxq9Ekbeeko3dx2FzfW8MRFG6+t3
         xChK9WauqbAgU6iQ0UTkMoHCfRqv0j9Oe3Z0Blp0y3MU/TWlOfo3sRgLRbTcPuANCdbL
         r5joFfAuF9HKTm+hmiAiY20+P+41wFkxHQvwdJP4h7vwMhCo2bfkvFHc2Ut5J1Kb6gEf
         LlvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752160127; x=1752764927;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ge1nC4yCBIiNPQ1G0qBajhIAzAiOK+EhF/zLDgsIM/U=;
        b=vBWpzBOUzayPyKGkmQzHyxbkyfnKoKJ6R4c9gSOVZNAy6T+xm4q6YYk2b2uvaghfCC
         FhwQBZ6GcER8JOspkyJ+6CnybeEUPHrksrAipJUq65RXyBgMg8i8j4TIs2XiiL4aNE+0
         zHbHFV+y+2c/h0OlH40doHNs90JmB2st8oNn5XrlYGelkQjS5CMxPFCuiRyC5epNsS2P
         nbhOtH7z2tWqyGd6ovqFld8Wx0q9b4edY/wV1k6AIBJBv509mp879JSP4xKVRPE/EPsc
         MmE9vsb1I+0BZ75gFlUNhBDY7KVJ28z4HnBS1googcfwCcOp5Z5y7apsYvJ5IXPU43nd
         NMVg==
X-Forwarded-Encrypted: i=1; AJvYcCUVGtehY+Nno6ToYn2FGFxEHSN4nMHDErQjqz+KRzqVXcRpAwv1VUIeJj1D9EAUbtoodHsbntkvo88=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5OR6KmU6CWfKAemln2U177Rdhib9uhanP2fzFdIFpgwQZu1gY
	wA2eqFViH7Pm6IlzZOgPrn8fuLwkrzbPEIvUOpdWAi3IkrFOameu8tSzEPYccZj1bTY=
X-Gm-Gg: ASbGncsSfQsYKmmxsDo1sh/0dnG2jUsRwCG+zGpU1KJZsPqztHrMGKA2m24ki5DJpRw
	OWvyemqzluAOMMr6lAxC3AOS7ywL1hl9OEdPIxFdxWwI7UFfM2Ul3zH9rN2q641futsVNuVluHP
	DC0JCjJN3/xAsuRgHNkk6PdCeh4/dQC7JBFCWtkC3ly9aoqdf0M88Tqo6bjQFd2ulHPJVeeEe6Q
	LeCR75jDX9dRdFzKgYFKwiQhNZwEM4FWYSEvojoYCOv/Fbri8NpN9kSVveIl6KGMKTxYBXHIszC
	IZUP8bcf1yul5FRDwX5yqTAoslpexLYjFYqNmIzl/PFkkUQFOCh+FjgINFzW1UZGkflgIA==
X-Google-Smtp-Source: AGHT+IGmdMCnI9PM5J20YVfQZv3O6vQotnLPNVuRWKQQFulsqOrvRtJsNYHyRleOJsO9cj/dzaQlSw==
X-Received: by 2002:a05:6602:13c2:b0:873:47fb:a455 with SMTP id ca18e2360f4ac-87966269ef0mr451794739f.2.1752160126577;
        Thu, 10 Jul 2025 08:08:46 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8796bc5bc60sm41323839f.47.2025.07.10.08.08.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jul 2025 08:08:45 -0700 (PDT)
Message-ID: <04620cc5-7c3a-4e4f-87ce-b691d9b57917@kernel.dk>
Date: Thu, 10 Jul 2025 09:08:44 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/6] block: sanitize chunk_sectors for atomic write
 limits
To: John Garry <john.g.garry@oracle.com>, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
 nilay@linux.ibm.com, cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
 ojaswin@linux.ibm.com, martin.petersen@oracle.com,
 akpm@linux-foundation.org, linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20250709100238.2295112-1-john.g.garry@oracle.com>
 <20250709100238.2295112-3-john.g.garry@oracle.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250709100238.2295112-3-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/9/25 4:02 AM, John Garry wrote:
> Currently we just ensure that a non-zero value in chunk_sectors aligns
> with any atomic write boundary, as the blk boundary functionality uses
> both these values.
> 
> However it is also improper to have atomic write unit max > chunk_sectors
> (for non-zero chunk_sectors), as this would lead to splitting of atomic
> write bios (which is disallowed).
> 
> Sanitize atomic write unit max against chunk_sectors to avoid any
> potential problems.
> 
> Fixes: d00eea91deaf3 ("block: Add extra checks in blk_validate_atomic_write_limits()")
> Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  block/blk-settings.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index a000daafbfb4..725035376f51 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -180,6 +180,7 @@ static void blk_atomic_writes_update_limits(struct queue_limits *lim)
>  
>  static void blk_validate_atomic_write_limits(struct queue_limits *lim)
>  {
> +	unsigned long long chunk_bytes;
>  	unsigned int boundary_sectors;
>  
>  	if (!(lim->features & BLK_FEAT_ATOMIC_WRITES))
> @@ -202,6 +203,13 @@ static void blk_validate_atomic_write_limits(struct queue_limits *lim)
>  			 lim->atomic_write_hw_max))
>  		goto unsupported;
>  
> +	chunk_bytes = lim->chunk_sectors << SECTOR_SHIFT;
> +	if (chunk_bytes) {
> +		if (WARN_ON_ONCE(lim->atomic_write_hw_unit_max >
> +			chunk_bytes))
> +			goto unsupported;
> +	}

Unnecessary indentation here. Why not just:

	chunk_bytes = lim->chunk_sectors << SECTOR_SHIFT;
	if (WARN_ON_ONCE(chunk_bytes &&
			 lim->atomic_write_hw_unit_max > chunk_bytes))
		goto unsupposed.

Also avoids splitting a comparison over multiple lines, which is always
annoying to read.

-- 
Jens Axboe
