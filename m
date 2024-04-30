Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEB4383A5
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714480785; cv=none; b=f9yszexpIVp7GhJiDTQGFb+68R2ldq0t+CFKz+xjWoB9Du2EfG2Uhlk7ZgWtGYaSX7rHenzq3SMHe+YLaciqsnwZXVLdtxY0Kuzc4aj2AClogMJSXaedGbVenJCUhFxQaPuYgbktBYZzenjZq9VLJNi070o0qNZ81a5GbqsGfik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714480785; c=relaxed/simple;
	bh=d5C1kNp1z7NxqL/wKJI/vdqABzDFLhqelCRRAccXAFI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=er5XvDd7ZAbghIydsRxUpnb3cVkRCoKBq1cRwywvaVOkPYDs7JW5hVeZUrOqj3ElwLXF4x4vhGSwzGZsre8DhDicnNKDDiq3SOCfEY2mbBxxAKnmFDxoQ/dH9dENFuAHOx/VzX5RZ606q54PUGWfU/UUSdsdbhwQNRyA8mzwSfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N0s8SQGo; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N0s8SQGo"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-4dae8b2d29bso1596829e0c.0
        for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 05:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714480782; x=1715085582; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PZRv4mKNGpnlZv+nzsq+J9a/kblTtfRZRI+IS2d96V4=;
        b=N0s8SQGoffITY1uyTYkXAZSWJIIXh5WZZ68WCYvBJ9DW/6aQPdwddX+vHF2/ja98jj
         XLtK/l1qJGV//AiF4BDjCeWzSObE2Kb22kIJkDg38XYXO49NxQ9ozKLwNgsS5GLfIJ1b
         JuEeSmO5Cko1hy40Rq1EU0rXe5BMi16Of8XnQCc0u98r+RS83PDSQ9iPTgjKp46ccGkA
         JXqZqZpqbo/IvDGhEryKOCo1j5PB7XNIp2L0aRxST0Yz5tHl32yUv6XegjKkrknH/q6g
         7uS5nNS3oZLzpKi9kVOThFFAExj1RKy1T5WjAgv4CqnaL+kg2tf0RJrOzt5h0t9pj6IU
         wLmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714480782; x=1715085582;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PZRv4mKNGpnlZv+nzsq+J9a/kblTtfRZRI+IS2d96V4=;
        b=BOmbRU7JvHDgFiEMsTbI6JnsxmngaRhgdcvtNLKOfpbe26cUP1Syv2f9C/Ax3oXoBI
         u6petpQJ2Vj+pqtnujEWZYJ00HFa3dm2l5FCiKe4VgfVYlMX1OjNYVTGfVpZ8ceNwTmw
         5+G484rkkyk/m62Cbxp+81OJcVaADUwyLCBby9Jk9rZMY3EjvR1cNxw7c7+TRMunmiRC
         FzKt/CNDZbWWYHbNgj4OKdzbhQFywVYUXlVqO2oeK1HG9s8HzZqgAUhkrFak04xJK109
         9+x5N+rSZ8+4rCxHNXMm2QcwfOQ7hAD0I5iCOyd2+5vLwEqJUXRXCzxjf5ttvFKs016q
         wxTg==
X-Forwarded-Encrypted: i=1; AJvYcCXE014nnstGKlklcnn/HvPfvyxyANvYCzC5X+dd0nDYVnYUDjbPeN4Yusm2F4Ge99R0qqzS1UNy1YTQrReEzNdMKCnZgDr3VnPH
X-Gm-Message-State: AOJu0YzZ2e39shkiIeSkoLHiS3VL+SObkgzE4hJomypzH1WiaCgy1tHh
	jKJMDvun/8Ef2Ex7B7r9UNBY6lobXnHFOCiDlTsODXVn8t1REmiZmkJqCa36sFfWeh1Qovaa+9V
	zVmeucRJ6i8jeLOjc03OGWB5/ZjBK1jzTPwUf
X-Google-Smtp-Source: AGHT+IHyjMVbPcaMiV1qHC09V0wXme2k4N77APd0OWHpJKNbqJbrVwAzQ3kXjJKvqQ3gXS0iWjPzoK/bZ94N2sqjAGQ=
X-Received: by 2002:a05:6122:311f:b0:4d4:5d86:b2d with SMTP id
 cg31-20020a056122311f00b004d45d860b2dmr13994961vkb.16.1714480782463; Tue, 30
 Apr 2024 05:39:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240430054604.4169568-1-david@fromorbit.com> <20240430054604.4169568-2-david@fromorbit.com>
In-Reply-To: <20240430054604.4169568-2-david@fromorbit.com>
From: Marco Elver <elver@google.com>
Date: Tue, 30 Apr 2024 14:39:04 +0200
Message-ID: <CANpmjNONgXYzeYXobYsT+GDkwcTCtECSpUdWE_gpeM79Cnephw@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm: lift gfp_kmemleak_mask() to gfp.h
To: Dave Chinner <david@fromorbit.com>
Cc: linux-mm@kvack.org, linux-xfs@vger.kernel.org, akpm@linux-foundation.org, 
	hch@lst.de, osalvador@suse.de, vbabka@suse.cz, andreyknvl@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 30 Apr 2024 at 07:46, Dave Chinner <david@fromorbit.com> wrote:
>
> From: Dave Chinner <dchinner@redhat.com>
>
> Any "internal" nested allocation done from within an allocation
> context needs to obey the high level allocation gfp_mask
> constraints. This is necessary for debug code like KASAN, kmemleak,
> lockdep, etc that allocate memory for saving stack traces and other
> information during memory allocation. If they don't obey things like
> __GFP_NOLOCKDEP or __GFP_NOWARN, they produce false positive failure
> detections.
>
> kmemleak gets this right by using gfp_kmemleak_mask() to pass
> through the relevant context flags to the nested allocation
> to ensure that the allocation follows the constraints of the caller
> context.
>
> KASAN recently was foudn to be missing __GFP_NOLOCKDEP due to stack
> depot allocations, and even more recently the page owner tracking
> code was also found to be missing __GFP_NOLOCKDEP support.
>
> We also don't wan't want KASAN or lockdep to drive the system into
> OOM kill territory by exhausting emergency reserves. This is
> something that kmemleak also gets right by adding (__GFP_NORETRY |
> __GFP_NOMEMALLOC | __GFP_NOWARN) to the allocation mask.
>
> Hence it is clear that we need to define a common nested allocation
> filter mask for these sorts of third party nested allocations used
> in debug code. So to start this process, lift gfp_kmemleak_mask() to
> gfp.h and rename it to gfp_nested_mask(), and convert the kmemleak
> callers to use it.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Marco Elver <elver@google.com>

Looks very reasonable, thanks.

> ---
>  include/linux/gfp.h | 25 +++++++++++++++++++++++++
>  mm/kmemleak.c       | 10 ++--------
>  2 files changed, 27 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index c775ea3c6015..a4ca004f3b8e 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -154,6 +154,31 @@ static inline int gfp_zonelist(gfp_t flags)
>         return ZONELIST_FALLBACK;
>  }
>
> +/*
> + * gfp flag masking for nested internal allocations.
> + *
> + * For code that needs to do allocations inside the public allocation API (e.g.
> + * memory allocation tracking code) the allocations need to obey the caller
> + * allocation context constrains to prevent allocation context mismatches (e.g.
> + * GFP_KERNEL allocations in GFP_NOFS contexts) from potential deadlock
> + * situations.
> + *
> + * It is also assumed that these nested allocations are for internal kernel
> + * object storage purposes only and are not going to be used for DMA, etc. Hence
> + * we strip out all the zone information and leave just the context information
> + * intact.
> + *
> + * Further, internal allocations must fail before the higher level allocation
> + * can fail, so we must make them fail faster and fail silently. We also don't
> + * want them to deplete emergency reserves.  Hence nested allocations must be
> + * prepared for these allocations to fail.
> + */
> +static inline gfp_t gfp_nested_mask(gfp_t flags)
> +{
> +       return ((flags & (GFP_KERNEL | GFP_ATOMIC | __GFP_NOLOCKDEP)) |
> +               (__GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN));
> +}
> +
>  /*
>   * We get the zone list from the current node and the gfp_mask.
>   * This zone list contains a maximum of MAX_NUMNODES*MAX_NR_ZONES zones.
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 6a540c2b27c5..b723f937e513 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -114,12 +114,6 @@
>
>  #define BYTES_PER_POINTER      sizeof(void *)
>
> -/* GFP bitmask for kmemleak internal allocations */
> -#define gfp_kmemleak_mask(gfp) (((gfp) & (GFP_KERNEL | GFP_ATOMIC | \
> -                                          __GFP_NOLOCKDEP)) | \
> -                                __GFP_NORETRY | __GFP_NOMEMALLOC | \
> -                                __GFP_NOWARN)
> -
>  /* scanning area inside a memory block */
>  struct kmemleak_scan_area {
>         struct hlist_node node;
> @@ -463,7 +457,7 @@ static struct kmemleak_object *mem_pool_alloc(gfp_t gfp)
>
>         /* try the slab allocator first */
>         if (object_cache) {
> -               object = kmem_cache_alloc(object_cache, gfp_kmemleak_mask(gfp));
> +               object = kmem_cache_alloc(object_cache, gfp_nested_mask(gfp));
>                 if (object)
>                         return object;
>         }
> @@ -947,7 +941,7 @@ static void add_scan_area(unsigned long ptr, size_t size, gfp_t gfp)
>         untagged_objp = (unsigned long)kasan_reset_tag((void *)object->pointer);
>
>         if (scan_area_cache)
> -               area = kmem_cache_alloc(scan_area_cache, gfp_kmemleak_mask(gfp));
> +               area = kmem_cache_alloc(scan_area_cache, gfp_nested_mask(gfp));
>
>         raw_spin_lock_irqsave(&object->lock, flags);
>         if (!area) {
> --
> 2.43.0
>
