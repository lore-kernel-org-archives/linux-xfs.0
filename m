Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4237E2949FF
	for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 09:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750153063; cv=none; b=N73jmfI3FkemfDjK+Bz/cm8HCwBKwOv2iNDEPOXR9TUqMDWad1jaqhlFn26qO4X9JSOtHCcAm0yIOKs2uRiV5BjPCmdBxhi8KYRWLJQEjPttfU5+s6Pw1ykfc7b/aUa4CUvO+RNi47z0nH3uRBQ0jOwZeX1Yhx8psZMQeJW31eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750153063; c=relaxed/simple;
	bh=4dKkLCw4bk4ek60+ugXGulWj9MacP7xMcntewdkIip0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mtXicV+a43N8F4PFeXm6bcUrKy1UyUTSCHakPs2+CaRRePnvKOXML9qVG4dbMqoYMSkdvjxVc1zOE1nkrn6PSaLKSboKuSkmn5e47FDWP6GkmKGJFpDEv9QrOOnTAIfGh5U0sSx0VuaO2EQY6+tIt2+JnZaf36KJajcUP+Bes4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PcsDhlyV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PcsDhlyV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750153061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2tVggpdHRMe70SNIVLjgFowvBJ62eIYbXphR2T3zCDQ=;
	b=PcsDhlyVvDorkmhP8uemET1+nb5ry+oepbX4PejvDmQD5bxIQk55Ka6kfk/Mv0rUhTDkQY
	q8FlvuPFuEg2kAGzM7CjS6GWG4fpE1KRBayUfCg5uRjpFueEJtuPkIqNVfqW8AACRSJRCY
	2ZwvWIGaoKqvcVOp7Yfl+uc7Dv0oZBY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-nU5aNF0xMg2Wz51aCiZkWw-1; Tue, 17 Jun 2025 05:37:36 -0400
X-MC-Unique: nU5aNF0xMg2Wz51aCiZkWw-1
X-Mimecast-MFC-AGG-ID: nU5aNF0xMg2Wz51aCiZkWw_1750153056
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45311704cdbso28374225e9.1
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 02:37:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750153055; x=1750757855;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2tVggpdHRMe70SNIVLjgFowvBJ62eIYbXphR2T3zCDQ=;
        b=TF7plDfcvCV5jvxKGDA39WUs8creM3AanweSI2tJ7bxS/eO1LfxuLN7X+TlTsovjgK
         Ke72BvdhJxh/AG7zk3ULlesLqNBbzEgm0LBENiiJAvJgokvOVcjQJO4y1f02w8JKNXAj
         uHVqNF1J/s7MRlzyvWUUfLwXuk/MRCHFcB6ew+5WhmvLcgYSqYYyzxGWL3l7Xg9LkmqO
         p0gBJjJrzU4inBHmjfH1cktSqnFT9vQLlyfqPCHIMg828rsWBYuPgIoIqDUruXunBQXg
         0elfBWbERBqlYOW05r7AKzxRWGt3MTZ9beu33GoD2yi6QAub0dK3nqf2rjcmB574YraY
         7nVw==
X-Forwarded-Encrypted: i=1; AJvYcCWai6OaMXaGkbb4ZoamNRMwwuTahIpWeB4UXY5bHYM2TEV3Rzy6rRu7Y6agLYsBqMhZXQxZU3SyMk8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoJb9jYcHyagCtakx9MP4mg5cmTO7k96C0F7kSITHKIuUt11bX
	LwkYQoxWv6XemaTzEUIk4PTie0X7FTeezPu1mp2+i7zaCFu0Y3+j9nWH+XiGz3SmhqwfcWXFvVA
	spdFetsvo44Yqhn4V5HT7e1JYR7ZZOhkKl8stS3ic9jk0okkWdjJ6nyz+FsTJYut5DNVgA6WL
X-Gm-Gg: ASbGnculoVGJXxdTrBUYx8nYn35TdqX4u6AixVEH4zcvAXFdRMp4bbX0LSCODoce879
	N4ciwbpVJ3P2dTSifc3/vChwBKJYzgIXQzKPXB5Hr+umwd2fsJi8TbpMsnbGcTXD7p/OqwStGU9
	B3kERw3m+L5PipizPzfS/9taOToXs1IJeYEF9FWSEiOE1eIErqr2iBvlw9EgB9XlU0WhI5p5XOm
	dPj3Oo1S3nE5d7/odZtBKn5j2V+mWxvh8DiCtiNpC1jQAt6AGTAk2jwAiDeyuvrgXHEbRfQqgJc
	2qjN5eKw8cYjujVRGgxYi4+hi42iVowGUGiDZMpVFS6y/J7MYyXLb4vSyiuo0qhsfx6RFpHiF6c
	VvdBYzRn7HlEcZvvrDb8lj0dbKrAgTfcBp3mU0ZBViYeRrhc=
X-Received: by 2002:a05:600c:3587:b0:43c:fda5:41e9 with SMTP id 5b1f17b1804b1-4533cad1aa0mr127694925e9.31.1750153055526;
        Tue, 17 Jun 2025 02:37:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE33mK7aAFnuzBQX82pmdkrCA/cX+3l1nAlm3F6BLNfxNOkhwo9+uvgQ5HQNw5b5NLLg7ZP1w==
X-Received: by 2002:a05:600c:3587:b0:43c:fda5:41e9 with SMTP id 5b1f17b1804b1-4533cad1aa0mr127694505e9.31.1750153055045;
        Tue, 17 Jun 2025 02:37:35 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f31:700:3851:c66a:b6b9:3490? (p200300d82f3107003851c66ab6b93490.dip0.t-ipconnect.de. [2003:d8:2f31:700:3851:c66a:b6b9:3490])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e224888sm172776835e9.1.2025.06.17.02.37.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 02:37:34 -0700 (PDT)
Message-ID: <338a45b0-40dd-4c11-bbe8-a047559fb77c@redhat.com>
Date: Tue, 17 Jun 2025 11:37:32 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/14] powerpc: Remove checks for devmap pages and
 PMDs/PUDs
To: Alistair Popple <apopple@nvidia.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, gerald.schaefer@linux.ibm.com,
 dan.j.williams@intel.com, jgg@ziepe.ca, willy@infradead.org,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de,
 zhang.lyra@gmail.com, debug@rivosinc.com, bjorn@kernel.org,
 balbirs@nvidia.com, lorenzo.stoakes@oracle.com,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-cxl@vger.kernel.org, dri-devel@lists.freedesktop.org, John@Groves.net,
 m.szyprowski@samsung.com, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.8d04615eb17b9e46fc0ae7402ca54b69e04b1043.1750075065.git-series.apopple@nvidia.com>
 <818b2fb2f2cf7450ecdd698f2fa019aed3be7b85.1750075065.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <818b2fb2f2cf7450ecdd698f2fa019aed3be7b85.1750075065.git-series.apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.06.25 13:58, Alistair Popple wrote:
> PFN_DEV no longer exists. This means no devmap PMDs or PUDs will be
> created, so checking for them is redundant. Instead mappings of pages that
> would have previously returned true for pXd_devmap() will return true for
> pXd_trans_huge()
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

