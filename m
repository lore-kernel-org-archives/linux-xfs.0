Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A80AACCA47F
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jun 2022 10:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbiFMKAn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jun 2022 06:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235355AbiFMKAl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jun 2022 06:00:41 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73841CFF1;
        Mon, 13 Jun 2022 03:00:39 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id y15so5643524ljc.0;
        Mon, 13 Jun 2022 03:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n3cgN2CZeUATuDX6tGeZqbEe4qx2pH+uniVRgLnOiSY=;
        b=P5QwT1m2oOSDkfS4z7jk4qILTPWqpBqCxOLSXm8VM22ATVKCcgtpjpI1CXiAfuBV1G
         AlbNG614FbjXH53G6+QPu3P5o6AtLUv2na+plKkl+tm4i8zzYeJbhfevorVTKmdcNg/S
         JJzCdOax1zNaWUAsvddV70dd5CVkC2N0y0W4wvTZ4vuKsFVRYxl5QD6ldzp+WO5TYuAZ
         d+HaUOifBkE6SweFqRVxRFIMtwInHe0Aqv78Qzr1d8BgVpbHOAZLVJmwM8P9jsOd6BI4
         9cKeJffCZUMN+kK5biVnvBlDAynClJqxMXvPfHqKFtbuJNL3mzpq+32VI8I/DH7bEWaS
         7BIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n3cgN2CZeUATuDX6tGeZqbEe4qx2pH+uniVRgLnOiSY=;
        b=FCq/wBgDcRoPPQQ+2athS6hLCWr1CcjXx9HfqKfWmjOWmyNggAnv7t7G+exS7cPmCb
         665PEBh1y/Or+l9GAv7MmC1K3rFHW4Qv9Sug2cfO2O2I0qI2PgirbF/V80W7V0M3nKlP
         BVbLWVhm2aqLaLeGYbvCG1FT/Lcg/zz/hTtjNs9xR0KYaR9JPQHYLzmBqy59+/mBwhj2
         vjKqNEspb/8Ik+D8i9w4MCt193MDu1ea6zOZYzOrWcMls+biIdz6/09TpOylBHM1QnWg
         +Tz7CSy2UDQfCOzIDtHnvOruh1g4mmRxSnMKB2j0p0pwn9ZPSe86XkK/436CboFEZALs
         g3Qg==
X-Gm-Message-State: AOAM532cPpIeSqfkD6//B/7TpDZIS5Dbv4QlG0ORJ05Xi3Xgq7v6AFMa
        YIp5x7bEYv1TtAZaNNFrBRI=
X-Google-Smtp-Source: ABdhPJwUifOWExCNu4th+FzG3q0cyioLwDRfT3eb/rRC1EWeAkgo2bbuWuoKAHBS8/KswS3KEQDRNA==
X-Received: by 2002:a2e:9283:0:b0:253:e175:dd84 with SMTP id d3-20020a2e9283000000b00253e175dd84mr61977086ljh.221.1655114438114;
        Mon, 13 Jun 2022 03:00:38 -0700 (PDT)
Received: from pc638.lan ([155.137.26.201])
        by smtp.gmail.com with ESMTPSA id o20-20020ac24e94000000b0047255d210e7sm929510lfr.22.2022.06.13.03.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 03:00:37 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Mon, 13 Jun 2022 12:00:35 +0200
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Kees Cook <keescook@chromium.org>, linux-mm@kvack.org,
        Uladzislau Rezki <urezki@gmail.com>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 1/3] usercopy: Handle vm_map_ram() areas
Message-ID: <YqcKw4AxxvEWtLmS@pc638.lan>
References: <20220612213227.3881769-1-willy@infradead.org>
 <20220612213227.3881769-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220612213227.3881769-2-willy@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> vmalloc does not allocate a vm_struct for vm_map_ram() areas.  That causes
> us to deny usercopies from those areas.  This affects XFS which uses
> vm_map_ram() for its directories.
> 
> Fix this by calling find_vmap_area() instead of find_vm_area().
> 
> Fixes: 0aef499f3172 ("mm/usercopy: Detect vmalloc overruns")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/vmalloc.h | 1 +
>  mm/usercopy.c           | 8 +++++---
>  mm/vmalloc.c            | 2 +-
>  3 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index b159c2789961..096d48aa3437 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -215,6 +215,7 @@ extern struct vm_struct *__get_vm_area_caller(unsigned long size,
>  void free_vm_area(struct vm_struct *area);
>  extern struct vm_struct *remove_vm_area(const void *addr);
>  extern struct vm_struct *find_vm_area(const void *addr);
> +struct vmap_area *find_vmap_area(unsigned long addr);
Make it "extern" since it becomes globally visible?

--
Uladzislau Rezki
