Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B714C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 22:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350503AbiDKWWu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 18:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350438AbiDKWWh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 18:22:37 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17E8DF47
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 15:20:22 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id h23-20020a17090a051700b001c9c1dd3acbso739958pjh.3
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 15:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ilC4hsjkYuKv6ebyejb/hqupiLMdVX0htffDOmrd7F4=;
        b=FxqMOl+LQRjm4xHV3WMTnaWUoHHNIwNG2iGvDbblMfZ8JddwTKg3ZpTCrlFkBB6rBu
         rSWbPPe9GjWLrChgxM3IBRCmVz5THofbIx0GGXctZmol6NievamWm9zkyAkJ24Cm0K9A
         DCtKBvlvzxZRb7YquzNbT2PdlI832d7CHnSCwf1bN5nHFuq8QnFM4JqEliGFJoIQQMbh
         jlPIO+ne9Hb8R7Ba1ZEnAjMWmLA+Qo6v4RY8WcEEkyOVuQrUjq+FZs7b6JFMuvp4LYVK
         7gQv7b3itG0nRglCi6Aiz7vPQL4cblVgmQ9M0dGACks264GbH5DuU0YIA9ydPmcdahOM
         Hryw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ilC4hsjkYuKv6ebyejb/hqupiLMdVX0htffDOmrd7F4=;
        b=4urbiAuwZ2+rMZ63+5COmsIC0PBS/uQaOle6k+MT9XVm/Psc3oYDiMIn+AVKfUgwoK
         nk3BkilJWof0QpYCSZraX1wSyJW8dxyG/gjbYQ4bLkdMtXY/Uf6c3XzogX3E4oHKaFd1
         4iS0CQso1B31hi/mRP68g+38ztTeTCHxatvVWQN/XtTpVfDBPX9WrFUUKOQH0CKkfebp
         XfzgfroOjnW0lAWVXQEbt6L8ZZ5GlSS39xP/nfGyHUuoVSld3BZAmF6o38DPV291IH6L
         YmqGkATVRv4h0IQdvfHeixqXiAFdKlgss0X8V+6+eLQZhFCW5g8bumryxt6KpBCRpoVT
         F1SA==
X-Gm-Message-State: AOAM533TMs93kW2LXJkvI0pE4bVEDbk2trxuNKnTO0ELo6G5XXk2dHZ2
        vt6ylYB2UlB6S2MUGG/SIc9Qcq1dXm8rso2TyUX/5Q==
X-Google-Smtp-Source: ABdhPJwobl8Twz9/+FJGw8iwZ7aqkX15fxktugOjY8lPoNQzuoJOzcOfQ2MMC/mpkqomhSOO2S1HZ/lhTWtwo8KT1ZQ=
X-Received: by 2002:a17:90a:ca:b0:1ca:5253:b625 with SMTP id
 v10-20020a17090a00ca00b001ca5253b625mr1484772pjd.220.1649715621869; Mon, 11
 Apr 2022 15:20:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220405194747.2386619-1-jane.chu@oracle.com> <20220405194747.2386619-3-jane.chu@oracle.com>
In-Reply-To: <20220405194747.2386619-3-jane.chu@oracle.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 11 Apr 2022 15:20:10 -0700
Message-ID: <CAPcyv4iUWLsZRV4StCzHuVUhEsOB5WURD2r_w3L+LEjoQEheog@mail.gmail.com>
Subject: Re: [PATCH v7 2/6] x86/mce: relocate set{clear}_mce_nospec() functions
To:     Jane Chu <jane.chu@oracle.com>
Cc:     david <david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Vishal L Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "Weiny, Ira" <ira.weiny@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I notice that none of the folks from "X86 MM" are on the cc, added.

On Tue, Apr 5, 2022 at 12:49 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> Relocate the twin mce functions to arch/x86/mm/pat/set_memory.c
> file where they belong.
>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  arch/x86/include/asm/set_memory.h | 52 -------------------------------
>  arch/x86/mm/pat/set_memory.c      | 47 ++++++++++++++++++++++++++++
>  include/linux/set_memory.h        |  9 +++---
>  3 files changed, 52 insertions(+), 56 deletions(-)
>
> diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
> index 78ca53512486..b45c4d27fd46 100644
> --- a/arch/x86/include/asm/set_memory.h
> +++ b/arch/x86/include/asm/set_memory.h
> @@ -86,56 +86,4 @@ bool kernel_page_present(struct page *page);
>
>  extern int kernel_set_to_readonly;
>
> -#ifdef CONFIG_X86_64
> -/*
> - * Prevent speculative access to the page by either unmapping
> - * it (if we do not require access to any part of the page) or
> - * marking it uncacheable (if we want to try to retrieve data
> - * from non-poisoned lines in the page).
> - */
> -static inline int set_mce_nospec(unsigned long pfn, bool unmap)
> -{
> -       unsigned long decoy_addr;
> -       int rc;
> -
> -       /* SGX pages are not in the 1:1 map */
> -       if (arch_is_platform_page(pfn << PAGE_SHIFT))
> -               return 0;
> -       /*
> -        * We would like to just call:
> -        *      set_memory_XX((unsigned long)pfn_to_kaddr(pfn), 1);
> -        * but doing that would radically increase the odds of a
> -        * speculative access to the poison page because we'd have
> -        * the virtual address of the kernel 1:1 mapping sitting
> -        * around in registers.
> -        * Instead we get tricky.  We create a non-canonical address
> -        * that looks just like the one we want, but has bit 63 flipped.
> -        * This relies on set_memory_XX() properly sanitizing any __pa()
> -        * results with __PHYSICAL_MASK or PTE_PFN_MASK.
> -        */
> -       decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
> -
> -       if (unmap)
> -               rc = set_memory_np(decoy_addr, 1);
> -       else
> -               rc = set_memory_uc(decoy_addr, 1);
> -       if (rc)
> -               pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
> -       return rc;
> -}
> -#define set_mce_nospec set_mce_nospec
> -
> -/* Restore full speculative operation to the pfn. */
> -static inline int clear_mce_nospec(unsigned long pfn)
> -{
> -       return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
> -}
> -#define clear_mce_nospec clear_mce_nospec
> -#else
> -/*
> - * Few people would run a 32-bit kernel on a machine that supports
> - * recoverable errors because they have too much memory to boot 32-bit.
> - */
> -#endif
> -
>  #endif /* _ASM_X86_SET_MEMORY_H */
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 38af155aaba9..93dde949f224 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -1925,6 +1925,53 @@ int set_memory_wb(unsigned long addr, int numpages)
>  }
>  EXPORT_SYMBOL(set_memory_wb);
>
> +#ifdef CONFIG_X86_64

It seems like the only X86_64 dependency in this routine is the
address bit 63 usage, so how about:

if (!IS_ENABLED(CONFIG_64BIT))
    return 0;

...and drop the ifdef?

Other than that you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
