Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4348D1FA4
	for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2024 01:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719277851; cv=none; b=TwsaBJ0yFZVFv/7fbdVSDNNlz5OW0Q2ycc+URqy6+HHhSEXAs5hfxfLZ6fURPzbQxJmYv86lAKe+pyofjxwrMMV5DYn3IOs0UOHl/dMlduDYgdxhpfIiZ0FKZJg6IBeXJpyeUia1iVxPnwIcuzgU0+mNqslGdMgau3aSUIVo9bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719277851; c=relaxed/simple;
	bh=/fYbx5c87Kw+R0HL5HIFgxuTB0c3Hz6eMNBQFrAcOZo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I7sz0aJG88FZv/5OkW845iEwhpLWoUzjElCJq/jtNu5FjRJdXOa6hk9dWA4twRsG3aOH50RBlFbXX2pn46qd2lGUE/ruOmBeUqo46C297iy5ifJtTS5Ov+IFv1iGf3x2RP8m4R4LRR/Xad8e0lZFZ4nxUZr7SgoHLSYyebPP1cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jj2JFXDF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jj2JFXDF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719277848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1y+mfhT1zOllffounRCp6OrS2eaKNKCgyHOP8s75z3E=;
	b=Jj2JFXDFWiyLuhlWF6oGYyvAGX6I9Mg+UDwlAT6h7APnKp6xDwo3k7VxdHgNiFZgNFNSIz
	zp8Kb4NjKcf/lbfKs94FeebV/qqrgsru3Zqcda3TwUmZYFUiiZ3DlMvRPTV6vjuzpUgqli
	xX3aFpWoZrNIqacET6sxA43atj28Xqo=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-nFUX6eDgOAmGl98-o--jhw-1; Mon, 24 Jun 2024 21:10:46 -0400
X-MC-Unique: nFUX6eDgOAmGl98-o--jhw-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-2598e0fbeecso7891727fac.1
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 18:10:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719277846; x=1719882646;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1y+mfhT1zOllffounRCp6OrS2eaKNKCgyHOP8s75z3E=;
        b=lTVJwSE8kaANgQarxTnGrFLEjF5D9JB2tJwZ75LbHQmKh4DtFiL/DR8hVuxr/Z/0sf
         qRjQKnp2MQrZYHGoAi/HTl3D4VE/Y08DQaoPwcSl7bFa7y/tbX+E9xXFENSJCanD6imO
         +rv/m+rSmy08xsYAlAAnzQEuxDPuuduNmzGkPP1uc5g2sNRSvkc8sVJcsAy+mligTcFC
         V5215agua5qSRR9UGOpqUtEsDvE9hSShYPA551wuWQo7sFz3QqedqCBoSWr5hWe58GpV
         Ldl5Pk3BZPESeauCdmIOy7N9bWZEyMJ4sH2G7WdGDNk8BKbTFGLNFXsClHxFY4c22wIz
         n6tQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRN5Crg1l5hOIF2OIioJxf1Yt6bhZ9twqgjGI7j+BJZM8NovNC0S4P+Izl62T1mezrwFJe/yGAZSvqN8EwyU/N3JU9SLIVUR3V
X-Gm-Message-State: AOJu0Ywcsk2Bo5K81VKBqIl8MInE4CIcOUkZtiSdGrnisPe6WuTGg/Uv
	1ysL3guygocoV1iGKcB/TyP3LjdwSo3zv9SEf+sCy531RiXoE6RqI7u8o6jYLfaS69pesXrOxFU
	DqB8j1Ke5tZNCS1BmYkotK9766s4dwvRWyRZMNwXUjd49f8nea//J98a7qg==
X-Received: by 2002:a05:6870:b622:b0:251:46d:d32a with SMTP id 586e51a60fabf-25d016733b1mr6417129fac.8.1719277845824;
        Mon, 24 Jun 2024 18:10:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHqiYmCXDL4VUWqb2tZ/iirellmnhtOelPOH+85HtiykbTPosUsDRSmNX8v5SNiPPCse1NLFA==
X-Received: by 2002:a05:6870:b622:b0:251:46d:d32a with SMTP id 586e51a60fabf-25d016733b1mr6417122fac.8.1719277845504;
        Mon, 24 Jun 2024 18:10:45 -0700 (PDT)
Received: from [192.168.68.50] ([43.252.112.224])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-716b479281esm6141262a12.38.2024.06.24.18.10.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jun 2024 18:10:44 -0700 (PDT)
Message-ID: <f73a27ca-91d4-4b1c-a2e3-ef07e56bccf3@redhat.com>
Date: Tue, 25 Jun 2024 11:10:38 +1000
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Endless calls to xas_split_alloc() due to corrupted xarray entry
To: David Hildenbrand <david@redhat.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>, Zhenyu Zhang <zhenyzha@redhat.com>,
 Linux XFS <linux-xfs@vger.kernel.org>,
 Linux Filesystems Development <linux-fsdevel@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Shaoqin Huang <shahuang@redhat.com>, Chandan Babu R
 <chandan.babu@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <CAJFLiB+J4mKGDOppp=1moMe2aNqeJhM9F2cD4KPTXoM6nzb5RA@mail.gmail.com>
 <ZRFbIJH47RkQuDid@debian.me> <ZRci1L6qneuZA4mo@casper.infradead.org>
 <91bceeda-7964-2509-a1f1-4a2be49ebc60@redhat.com>
 <6d3687fd-e11b-4d78-9944-536bb1d731de@redhat.com>
 <ZnLrq4vJnfSNZ0wg@casper.infradead.org>
 <CAHk-=who82OKiXyTiCG3rUaiicO_OB9prVvZQBzg6GDGhdp+Ew@mail.gmail.com>
 <75c1936b-bb08-423d-9a17-0da133cbee01@redhat.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <75c1936b-bb08-423d-9a17-0da133cbee01@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/20/24 5:58 AM, David Hildenbrand wrote:
> On 19.06.24 17:48, Linus Torvalds wrote:
>> On Wed, 19 Jun 2024 at 07:31, Matthew Wilcox <willy@infradead.org> wrote:
>>>
>>> Actually, it's 11.  We can't split an order-12 folio because we'd have
>>> to allocate two levels of radix tree, and I decided that was too much
>>> work.  Also, I didn't know that ARM used order-13 PMD size at the time.
>>>
>>> I think this is the best fix (modulo s/12/11/).
>>
>> Can we use some more descriptive thing than the magic constant 11 that
>> is clearly very subtle.
>>
>> Is it "XA_CHUNK_SHIFT * 2 - 1"
> 
> That's my best guess as well :)
> 
>>
>> IOW, something like
>>
>>     #define MAX_XAS_ORDER (XA_CHUNK_SHIFT * 2 - 1)
>>     #define MAX_PAGECACHE_ORDER min(HPAGE_PMD_ORDER,12)
>>
>> except for the non-TRANSPARENT_HUGEPAGE case where it currently does
>>
>>    #define MAX_PAGECACHE_ORDER    8
>>
>> and I assume that "8" is just "random round value, smaller than 11"?
> 
> Yes, that matches my understanding.
> 
> Maybe to be safe for !THP as well, something ike:
> 
> +++ b/include/linux/pagemap.h
> @@ -354,11 +354,18 @@ static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
>    * a good order (that's 1MB if you're using 4kB pages)
>    */
>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -#define MAX_PAGECACHE_ORDER    HPAGE_PMD_ORDER
> +#define WANTED_MAX_PAGECACHE_ORDER    HPAGE_PMD_ORDER
>   #else
> -#define MAX_PAGECACHE_ORDER    8
> +#define WANTED_MAX_PAGECACHE_ORDER    8
>   #endif
> 
> +/*
> + * xas_split_alloc() does not support arbitrary orders yet. This implies no
> + * 512MB THP on arm64 with 64k.
> + */
> +#define MAX_XAS_ORDER        (XA_CHUNK_SHIFT * 2 - 1)
> +#define MAX_PAGECACHE_ORDER    min(MAX_XAS_ORDER, WANTED_MAX_PAGECACHE_ORDER)
> +
>   /**
>    * mapping_set_large_folios() - Indicate the file supports large folios.
>    * @mapping: The file.

Thanks David. I'm checking if shmem needs the similar limitation and test patches.
I will post them for review once they're ready.

Thanks,
Gavin

