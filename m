Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E36ECCA473
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Jun 2022 13:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236938AbiFLNDa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Jun 2022 09:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbiFLNDa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Jun 2022 09:03:30 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F5B26EF;
        Sun, 12 Jun 2022 06:03:24 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id y32so5072308lfa.6;
        Sun, 12 Jun 2022 06:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YTsB0N3qWfzpCuWe8xUMKoFVyRm+YxRVrS5Z4FIpVVM=;
        b=AsSwvwNxL3KeUSJBcoZ1iIcJZEbYruf9NSXjmaXfcvuJyayYlkSFFLGoZeVq1oKbIV
         XaKFFMgzUChyJSjOYc4cV+T+Fq2TnxHZNYbunfmIKKsC0LbSyE+xfHHcQRgFcSgK11oz
         eePYpL3UNGYvOHZWbnkvec1YWEtms7M4wVIbaND/rK9DabSHc/ePrKzHf05lYkv3Kpje
         d7AARJjjV+tK+qtU28DOaQ4d0/hfJQa0G4YsZcux5eKLf1g5t08/msVAQFRppSHDGaoD
         rboxzHmavmc760MOPfbsNwK0UvEdktGWEgkSdHfJfDGJzlZY4/xb7rEreVlv2gMOokJk
         t2Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YTsB0N3qWfzpCuWe8xUMKoFVyRm+YxRVrS5Z4FIpVVM=;
        b=L01tucwBeh8Wmpre9DeatOsdYZxfwyPC6/RyRKOgwKlv4wW3sNvYC24KjZOpGgyX/f
         q/gjf+PkauI23eHMPveGFl6YMFF1AwrFhGY2TAzj+H2UOZiIsnONiYubsEq1NHna1FZ5
         g2rFPqo67xxaAMeISAQP3x7FsKiJSlEoNuiL/R1MZ7Cj5YVn09urS8zK8FxKlea0/rEJ
         3OwBX0YHR+fxOTSpt6z7KQ75yMSfh3D/sS5eqiNdCsMVQh+akOrW81Whir1kePT5IH6y
         esdr8PrOpYQXgYDGvTV3PHXpvzN2a2qyw71J4KRmzRE3dlrnjCD3zgfMKboBeiUOz10g
         px9A==
X-Gm-Message-State: AOAM532O/QwAWvPrif+nwkSxeUm32L6RC/tDPeT1titCFH7+wllg1bxU
        FD8cDG0NA5DojMkeYVnN18Z99FR9EuJnuQ==
X-Google-Smtp-Source: ABdhPJxqBZF44drPTOlVrkQ14816GxopWXiCGJdlxVakknAiNSZNINLfaOvEAx+0CqgPBpKB0XTklw==
X-Received: by 2002:a05:6512:308b:b0:479:3986:1d5c with SMTP id z11-20020a056512308b00b0047939861d5cmr21705756lfd.99.1655039002668;
        Sun, 12 Jun 2022 06:03:22 -0700 (PDT)
Received: from pc638.lan ([155.137.26.201])
        by smtp.gmail.com with ESMTPSA id a15-20020a056512200f00b0047255d210f4sm607717lfb.35.2022.06.12.06.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jun 2022 06:03:21 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Sun, 12 Jun 2022 15:03:20 +0200
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Zorro Lang <zlang@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        bugzilla-daemon@kernel.org, linux-s390@vger.kernel.org,
        linux-xfs@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Uladzislau Rezki <urezki@gmail.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [Bug 216073] New: [s390x] kernel BUG at mm/usercopy.c:101!
 usercopy: Kernel memory exposure attempt detected from vmalloc 'n  o area'
 (offset 0, size 1)!
Message-ID: <YqXkGMY9xtUvPR5D@pc638.lan>
References: <bug-216073-27@https.bugzilla.kernel.org/>
 <20220606151312.6a9d098c85ed060d36519600@linux-foundation.org>
 <Yp9pHV14OqvH0n02@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <20220608021922.n2izu7n4yoadknkx@zlang-mailbox>
 <YqD0yAELzHxdRBU6@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <20220612044230.murerhsa765akogj@zlang-mailbox>
 <YqXU+oU7wayOcmCe@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqXU+oU7wayOcmCe@casper.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Sun, Jun 12, 2022 at 12:42:30PM +0800, Zorro Lang wrote:
> > Looks likt it's not a s390x specific bug, I just hit this issue once (not 100%
> > reproducible) on aarch64 with linux v5.19.0-rc1+ [1]. So back to cc linux-mm
> > to get more review.
> > 
> > [1]
> > [  980.200947] usercopy: Kernel memory exposure attempt detected from vmalloc 'no area' (offset 0, size 1)! 
> 
>        if (is_vmalloc_addr(ptr)) {
>                struct vm_struct *area = find_vm_area(ptr);
>                if (!area) {
>                        usercopy_abort("vmalloc", "no area", to_user, 0, n);
> 
> Oh.  Looks like XFS uses vm_map_ram() and vm_map_ram() doesn't allocate
> a vm_struct.
> 
> Ulad, how does this look to you?
>
It looks like a correct way to me :) XFS uses per-cpu-vm_map_ram()-vm_unmap_ram()
API which do not allocate "vm_struct" because it is not needed.

>
> diff --git a/mm/usercopy.c b/mm/usercopy.c
> index baeacc735b83..6bc2a1407c59 100644
> --- a/mm/usercopy.c
> +++ b/mm/usercopy.c
> @@ -173,7 +173,7 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
>  	}
>  
>  	if (is_vmalloc_addr(ptr)) {
> -		struct vm_struct *area = find_vm_area(ptr);
> +		struct vmap_area *area = find_vmap_area((unsigned long)ptr);
>  		unsigned long offset;
>  
>  		if (!area) {
> @@ -181,8 +181,9 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
>  			return;
>  		}
>  
> -		offset = ptr - area->addr;
> -		if (offset + n > get_vm_area_size(area))
> +		/* XXX: We should also abort for free vmap_areas */
> +		offset = (unsigned long)ptr - area->va_start;
>
I was a bit confused about "offset" and why it is needed here. It is always zero. 
So we can get rid of it to make it less confused. From the other hand a zero offset
contributes to nothing.

>
> +		if (offset + n >= area->va_end)
>
I think it is a bit wrong. As i see it, "n" is a size and what we would like to do
here is boundary check:

<snip>
if (n > va_size(area))
    usercopy_abort("vmalloc", NULL, to_user, 0, n);
<snip>

--
Uladzislau Rezki
