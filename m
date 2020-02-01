Return-Path: <SRS0=nLlH=3V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D22ECC33CB7
	for <linux-xfs@archiver.kernel.org>; Sat,  1 Feb 2020 19:28:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A003920723
	for <linux-xfs@archiver.kernel.org>; Sat,  1 Feb 2020 19:28:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DHbz0vbx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgBAT2S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 1 Feb 2020 14:28:18 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46314 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbgBAT2R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Feb 2020 14:28:17 -0500
Received: by mail-ot1-f66.google.com with SMTP id g64so9844726otb.13
        for <linux-xfs@vger.kernel.org>; Sat, 01 Feb 2020 11:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cxP/mWDrHKD9UWBcOV7z7zMrCIASBgDPmpZP09ULspU=;
        b=DHbz0vbxuVJr39v4IG5GLko8yPJ2OS6cGBWBlCBw6koGzH+k7gmSCl86lfXXJXyTfS
         lGLseZubt3OGJEGo7iYD6W08gI9l+Z0T6Z8qt2Sl4a584TvXAdgew2Zny1clbqb5yqTa
         zo5P76hEP3ZOy/8YimvwqHHOOK/+kG2vflddlA4LDX2Xk+CZis5rwduV5SZe3AGIcN3F
         N1JkutQpZB5oy9/0pQcdNCdb8eg8DZDeDkDvE3MZ2bvF7MYUe2GeY5l/edaHdyr+Ie4h
         WulEeklbFMQFb86tSVVfFrIvW121MkB3D9LqmtYh62q+ZNYSKUgfvb5q/vKRjxTNuy/J
         QBzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cxP/mWDrHKD9UWBcOV7z7zMrCIASBgDPmpZP09ULspU=;
        b=QtefHSI1t8xVEeGN/eqdx2LOAGtBp3ztYKFxlh54G5/8yp7fcr5dvourK+VvJlFdFO
         9IyhU/NNfZKtPTFvVmuoxw7za6www6G3F+bV0r4CLLxT+YiS1N6iD+7+lMYwJ9Tu8mK0
         Oxc+Gz+lraeSn/Zta3rImOiq9rUNzy7od4fE8EYUnoIjeDbFv6aIb3mNQFyeh2qQugO7
         JwOxTC3M31HJJcu1HN+O7utjyMgPPomIRKQHyI/f4sh1m8SzzN9d+cHMxkGLH7fSe97X
         +zkNYSG/Yh0hQ7qu6Yb8I4wkHlf3CloOqy2QMmiSIw8A9yDgfQVsu4dPDmrqoGh8PSGD
         o+Zw==
X-Gm-Message-State: APjAAAX3nqgtuYVY53EBrCMlHJ2w6rSbMVlMaBdPlG0DUS2U3JuAqdsT
        CjMSI9U3lE3foGvkPc81RiMcM2QGir7qvV1h+C1k9w==
X-Google-Smtp-Source: APXvYqwr4ptf9tE3b6yjDXLUXSR7qGzKb90HMFk1L4yOE6UqTeeItB+3BKcSnDGEm0sa3acbKu307vS9ea6L+YdsRSA=
X-Received: by 2002:a9d:74d0:: with SMTP id a16mr1495412otl.228.1580585295885;
 Sat, 01 Feb 2020 11:28:15 -0800 (PST)
MIME-Version: 1.0
References: <bfca96db-bbd0-d958-7732-76e36c667c68@suse.cz> <202001271519.AA6ADEACF0@keescook>
 <5861936c-1fe1-4c44-d012-26efa0c8b6e7@de.ibm.com> <202001281457.FA11CC313A@keescook>
 <alpine.DEB.2.21.2001291640350.1546@www.lameter.com> <6844ea47-8e0e-4fb7-d86f-68046995a749@de.ibm.com>
 <20200129170939.GA4277@infradead.org> <771c5511-c5ab-3dd1-d938-5dbc40396daa@de.ibm.com>
 <202001300945.7D465B5F5@keescook> <CAG48ez1a4waGk9kB0WLaSbs4muSoK0AYAVk8=XYaKj4_+6e6Hg@mail.gmail.com>
 <202002010952.ACDA7A81@keescook>
In-Reply-To: <202002010952.ACDA7A81@keescook>
From:   Jann Horn <jannh@google.com>
Date:   Sat, 1 Feb 2020 20:27:49 +0100
Message-ID: <CAG48ez2ms+TDEXQdDONuQ1GG0K20E69nV1r_yjKxxYjYKv1VCg@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH 09/38] usercopy: Mark kmalloc caches as
 usercopy caches
To:     Kees Cook <keescook@chromium.org>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christopher Lameter <cl@linux.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kernel list <linux-kernel@vger.kernel.org>,
        David Windsor <dave@nullcore.net>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, linux-xfs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Laura Abbott <labbott@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Jan Kara <jack@suse.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Garrett <mjg59@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Kubecek <mkubecek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[pruned bogus addresses from recipient list]

On Sat, Feb 1, 2020 at 6:56 PM Kees Cook <keescook@chromium.org> wrote:
> On Fri, Jan 31, 2020 at 01:03:40PM +0100, Jann Horn wrote:
> > I think dma-kmalloc slabs should be handled the same way as normal
> > kmalloc slabs. When a dma-kmalloc allocation is freshly created, it is
> > just normal kernel memory - even if it might later be used for DMA -,
> > and it should be perfectly fine to copy_from_user() into such
> > allocations at that point, and to copy_to_user() out of them at the
> > end. If you look at the places where such allocations are created, you
> > can see things like kmemdup(), memcpy() and so on - all normal
> > operations that shouldn't conceptually be different from usercopy in
> > any relevant way.
>
> I can't find where the address limit for dma-kmalloc is implemented.

dma-kmalloc is a slab that uses GFP_DMA pages.

Things have changed a bit through the kernel versions, but in current
mainline, the zone limit for GFP_DMA is reported from arch code to
generic code via zone_dma_bits, from where it is used to decide which
zones should be used for allocations based on the address limit of a
given device:

kernel/dma/direct.c:
/*
 * Most architectures use ZONE_DMA for the first 16 Megabytes, but some use it
 * it for entirely different regions. In that case the arch code needs to
 * override the variable below for dma-direct to work properly.
 */
unsigned int zone_dma_bits __ro_after_init = 24;
[...]
static gfp_t __dma_direct_optimal_gfp_mask(struct device *dev, u64 dma_mask,
                u64 *phys_limit)
{
[...]
        /*
         * Optimistically try the zone that the physical address mask falls
         * into first.  If that returns memory that isn't actually addressable
         * we will fallback to the next lower zone and try again.
         *
         * Note that GFP_DMA32 and GFP_DMA are no ops without the corresponding
         * zones.
         */
        if (*phys_limit <= DMA_BIT_MASK(zone_dma_bits))
                return GFP_DMA;
        if (*phys_limit <= DMA_BIT_MASK(32))
                return GFP_DMA32;
        return 0;
}


There are only a few architectures that override the limit:

powerpc:
        /*
         * Allow 30-bit DMA for very limited Broadcom wifi chips on many
         * powerbooks.
         */
        if (IS_ENABLED(CONFIG_PPC32))
                zone_dma_bits = 30;
        else
                zone_dma_bits = 31;

s390:
        zone_dma_bits = 31;

and arm64:
#define ARM64_ZONE_DMA_BITS     30
[...]
        if (IS_ENABLED(CONFIG_ZONE_DMA)) {
                zone_dma_bits = ARM64_ZONE_DMA_BITS;
                arm64_dma_phys_limit = max_zone_phys(ARM64_ZONE_DMA_BITS);
        }


The actual categorization of page ranges into zones happens via
free_area_init_nodes() or free_area_init_node(); these are provided
with arrays of maximum physical addresses or zone sizes (depending on
which of them is called) by arch-specific code.
For arm64, the caller is zone_sizes_init(). X86 does it in zone_sizes_init().

> As to whitelisting all of dma-kmalloc -- I guess I can be talked into
> it. It still seems like the memory used for direct hardware
> communication shouldn't be exposed to userspace, but it we're dealing
> with packet data, etc, then it makes sense not to have to have bounce
> buffers, etc.

FWIW, as far as I understand, usercopy doesn't actually have any
effect on drivers that use the modern, proper APIs, since those don't
use the slab allocator at all - as I pointed out in my last mail, the
dma-kmalloc* slabs are used very rarely. (Which is good, because
putting objects from less-than-page-size slabs into iommu entries is a
terrible idea from a security and reliability perspective because it
gives the hardware access to completely unrelated memory.) Instead,
they get pages from the page allocator, and these pages may e.g. be
allocated from the DMA, DMA32 or NORMAL zones depending on the
restrictions imposed by hardware. So I think the usercopy restriction
only affects a few oddball drivers (like this s390 stuff), which is
why you're not seeing more bug reports caused by this.
