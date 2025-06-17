Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE060292B2E
	for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 09:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750151983; cv=none; b=cab8cUbtNMbQQv0mTJVRjLifutv2Jusu2IhZn6KkTNk6KOlZtgGKQ4Vyqg62lGjrBumztmbFfd6BevnvzqLK/W+OJENZJSS9diOXIk1uFenyJabcttO6rvBGplcwxMG8bwF/y97vFal0YnNlmE65faCQTHB7DX0/Gndl2Spu6Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750151983; c=relaxed/simple;
	bh=+5SWU1o8juSDYZoOuyQJC1B+OKlGQ52mSspkNeSUazk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KkiacB2S7kxS0J029OU1b1VwlmocQC2eWDYMQTsfz2jhcgyjRXyuS8l+BFy7LxV52I/JUZJbmm/8woSADTI0uBWWB1CapePPzZ+U/5wp7nzowxnFSvWsp6zOqMQe5OJezYH09zH8GjJ3WMUHaj2Rq97FCVKZmIealrqU3snj9fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hpyv6nxu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hpyv6nxu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750151979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Pl6PxwbpUS7ADU1xqvtXXrf/iKUynSR5SAu+83BnGX4=;
	b=Hpyv6nxuUkYyaiSPWyTENXhMPXmMziP5LWCNJqk+SV/gM4mOWMsHPPHyk8T1g1LZ+wvtp6
	VDeDiWzC2xAxN6S+QkgrSoYDOIFb0O5R0EhqmeWfP7XfVtCc+5cL2pcU31a/IyOlsEzGpE
	+ORyZjkGIviB99mAWsh5xEXPqt6iQKg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-6QUB-Ls5Nb228p096PoMmg-1; Tue, 17 Jun 2025 05:19:38 -0400
X-MC-Unique: 6QUB-Ls5Nb228p096PoMmg-1
X-Mimecast-MFC-AGG-ID: 6QUB-Ls5Nb228p096PoMmg_1750151977
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4f8fd1856so2649342f8f.2
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 02:19:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750151977; x=1750756777;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Pl6PxwbpUS7ADU1xqvtXXrf/iKUynSR5SAu+83BnGX4=;
        b=PB3jFnxqFkNVqf2cNlteD69MKDJUpiPv3HlvPrvY4buTYyEK6ceJvNoY26nkjiRbav
         5DUF6LYQx8B9HBWNxT/npIHG+3retPYD67Zh5LCK43uHWiKJNxDd3vHIabTUxWKvNPkt
         cKT5QzCZNmRmuNrnnoNyBjmVJFy1+ej8d3IefO31XEm1YNrM+OlTX48PKIMFGMQ44dy5
         +/uZK+50YHg3Ie+e6WoWXgta/ct5jf1NSO0KrVZvZsuppdL2AzbL1zCt/3BTQ4V9hTom
         6anc0DGwmaeFAOfmbocuchOisla75vUuZRv8U3SOJAR/siY5uzEfIYaOtJgztW/jmJQK
         2cFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSyIKQuAlA2L416HYZyhTr29kwT4ScLSMw2L8szI51tVDI0o046ext3tORBzFawiaYZ2UEtJyuR18=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbuUwlOl69YrtgBooX1vnv2Z4oM89tdXf3UDxvw3K4vBgmaIby
	sOZQmQdGDltMqYcxnhNFI1ZqOoR90Wa9SJyCQ+DrErm9SGGNs23uUNlvhjs62afqeiaRJ4dnUoa
	v/3LnJaAJ4AcomcZbcidgs5SOyB9Xfm6kO4LucbatnW1WWLhJ1xf3Sdh0N+2S6g==
X-Gm-Gg: ASbGncu7Eao7e4Aqx+bZYvOy5tY4VVE40l82I9uPk333a9WXQ7CEAiRVfvzF1dGkpm/
	4myGRb5rF3TjzFFwiRgOBnTyD1w1JXnU6Yl2LKRI2Io+AucpDaYombn7NvfoRsqqmXNZXC470O2
	Lq8TZ2ypd9RR4YyywG3hrvAD+Q7rbf9luPGW8zWWkB3+IYwJEhpi91MjKmcaLlk95B9xJhoX/GZ
	ATK/6XHXEIW1KL37OWNh/4bWFjZtzGBIQskXk3qlJWnBo7p0YUyz4AgVWYm9VXkvjeRzHDavXjv
	Zs4ZZqKHMbWOUsYTQtULJe7XzjjqTaGprARyxdKt5EMv5L8MkDgvwAL0IXD89Qxft9Z+KBkWZvy
	tXdO780yr/B0hdtZTyvVBmOS5s/tGHnu13Gm4Y8NuOjGCRjI=
X-Received: by 2002:a05:6000:4202:b0:3a4:dfaa:df8d with SMTP id ffacd0b85a97d-3a572367c45mr11265684f8f.9.1750151977228;
        Tue, 17 Jun 2025 02:19:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHt8iXJvJT0W2e4sI8GT6VcpVG8jxrePAU09oM8r6xnq4XSbjmN3FC6k4gXR+D2djVSpIQQtw==
X-Received: by 2002:a05:6000:4202:b0:3a4:dfaa:df8d with SMTP id ffacd0b85a97d-3a572367c45mr11265656f8f.9.1750151976687;
        Tue, 17 Jun 2025 02:19:36 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f31:700:3851:c66a:b6b9:3490? (p200300d82f3107003851c66ab6b93490.dip0.t-ipconnect.de. [2003:d8:2f31:700:3851:c66a:b6b9:3490])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568b08e21sm13528866f8f.52.2025.06.17.02.19.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 02:19:36 -0700 (PDT)
Message-ID: <bf855ce0-d0ba-4bd6-bfc1-8be2fdbdfe70@redhat.com>
Date: Tue, 17 Jun 2025 11:19:34 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/14] mm: Convert pXd_devmap checks to vma_is_dax
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
 <361009510f346090fad328c53ec228d99bb955ee.1750075065.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAhkBFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAl8Ox4kFCRKpKXgACgkQTd4Q
 9wD/g1oHcA//a6Tj7SBNjFNM1iNhWUo1lxAja0lpSodSnB2g4FCZ4R61SBR4l/psBL73xktp
 rDHrx4aSpwkRP6Epu6mLvhlfjmkRG4OynJ5HG1gfv7RJJfnUdUM1z5kdS8JBrOhMJS2c/gPf
 wv1TGRq2XdMPnfY2o0CxRqpcLkx4vBODvJGl2mQyJF/gPepdDfcT8/PY9BJ7FL6Hrq1gnAo4
 3Iv9qV0JiT2wmZciNyYQhmA1V6dyTRiQ4YAc31zOo2IM+xisPzeSHgw3ONY/XhYvfZ9r7W1l
 pNQdc2G+o4Di9NPFHQQhDw3YTRR1opJaTlRDzxYxzU6ZnUUBghxt9cwUWTpfCktkMZiPSDGd
 KgQBjnweV2jw9UOTxjb4LXqDjmSNkjDdQUOU69jGMUXgihvo4zhYcMX8F5gWdRtMR7DzW/YE
 BgVcyxNkMIXoY1aYj6npHYiNQesQlqjU6azjbH70/SXKM5tNRplgW8TNprMDuntdvV9wNkFs
 9TyM02V5aWxFfI42+aivc4KEw69SE9KXwC7FSf5wXzuTot97N9Phj/Z3+jx443jo2NR34XgF
 89cct7wJMjOF7bBefo0fPPZQuIma0Zym71cP61OP/i11ahNye6HGKfxGCOcs5wW9kRQEk8P9
 M/k2wt3mt/fCQnuP/mWutNPt95w9wSsUyATLmtNrwccz63XOwU0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAHCwXwEGAEIACYCGwwWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCXw7HsgUJEqkpoQAKCRBN3hD3AP+DWrrpD/4qS3dyVRxDcDHIlmguXjC1Q5tZTwNB
 boaBTPHSy/Nksu0eY7x6HfQJ3xajVH32Ms6t1trDQmPx2iP5+7iDsb7OKAb5eOS8h+BEBDeq
 3ecsQDv0fFJOA9ag5O3LLNk+3x3q7e0uo06XMaY7UHS341ozXUUI7wC7iKfoUTv03iO9El5f
 XpNMx/YrIMduZ2+nd9Di7o5+KIwlb2mAB9sTNHdMrXesX8eBL6T9b+MZJk+mZuPxKNVfEQMQ
 a5SxUEADIPQTPNvBewdeI80yeOCrN+Zzwy/Mrx9EPeu59Y5vSJOx/z6OUImD/GhX7Xvkt3kq
 Er5KTrJz3++B6SH9pum9PuoE/k+nntJkNMmQpR4MCBaV/J9gIOPGodDKnjdng+mXliF3Ptu6
 3oxc2RCyGzTlxyMwuc2U5Q7KtUNTdDe8T0uE+9b8BLMVQDDfJjqY0VVqSUwImzTDLX9S4g/8
 kC4HRcclk8hpyhY2jKGluZO0awwTIMgVEzmTyBphDg/Gx7dZU1Xf8HFuE+UZ5UDHDTnwgv7E
 th6RC9+WrhDNspZ9fJjKWRbveQgUFCpe1sa77LAw+XFrKmBHXp9ZVIe90RMe2tRL06BGiRZr
 jPrnvUsUUsjRoRNJjKKA/REq+sAnhkNPPZ/NNMjaZ5b8Tovi8C0tmxiCHaQYqj7G2rgnT0kt
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <361009510f346090fad328c53ec228d99bb955ee.1750075065.git-series.apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.06.25 13:58, Alistair Popple wrote:
> Currently dax is the only user of pmd and pud mapped ZONE_DEVICE
> pages. Therefore page walkers that want to exclude DAX pages can check
> pmd_devmap or pud_devmap. However soon dax will no longer set PFN_DEV,
> meaning dax pages are mapped as normal pages.
> 
> Ensure page walkers that currently use pXd_devmap to skip DAX pages
> continue to do so by adding explicit checks of the VMA instead.
 > > Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> 
> ---
> 
> Changes from v1:
> 
>   - Remove vma_is_dax() check from mm/userfaultfd.c as
>     validate_move_areas() will already skip DAX VMA's on account of them
>     not being anonymous.

This should be documented in the patch description above.

> ---
>   fs/userfaultfd.c | 2 +-
>   mm/hmm.c         | 2 +-
>   mm/userfaultfd.c | 6 ------
>   3 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index ef054b3..a886750 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -304,7 +304,7 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
>   		goto out;
>   
>   	ret = false;
> -	if (!pmd_present(_pmd) || pmd_devmap(_pmd))
> +	if (!pmd_present(_pmd) || vma_is_dax(vmf->vma))
>   		goto out;

VMA checks should be done before doing any page table walk.

>   
>   	if (pmd_trans_huge(_pmd)) {
> diff --git a/mm/hmm.c b/mm/hmm.c
> index feac861..5311753 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -441,7 +441,7 @@ static int hmm_vma_walk_pud(pud_t *pudp, unsigned long start, unsigned long end,
>   		return hmm_vma_walk_hole(start, end, -1, walk);
>   	}
>   
> -	if (pud_leaf(pud) && pud_devmap(pud)) {
> +	if (pud_leaf(pud) && vma_is_dax(walk->vma)) {
>   		unsigned long i, npages, pfn;
>   		unsigned int required_fault;
>   		unsigned long *hmm_pfns;

Dito.

> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 58b3ad6..8395db2 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1818,12 +1818,6 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>   
>   		ptl = pmd_trans_huge_lock(src_pmd, src_vma);
>   		if (ptl) {
> -			if (pmd_devmap(*src_pmd)) {
> -				spin_unlock(ptl);
> -				err = -ENOENT;
> -				break;
> -			}
> -
>   			/* Check if we can move the pmd without splitting it. */
>   			if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
>   			    !pmd_none(dst_pmdval)) {


-- 
Cheers,

David / dhildenb

