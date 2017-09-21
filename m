Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:49165 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751605AbdIUS0p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2017 14:26:45 -0400
Received: by mail-io0-f178.google.com with SMTP id 21so12898901iof.6
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 11:26:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1709211102320.14742@nuc-kabylake>
References: <1505940337-79069-1-git-send-email-keescook@chromium.org>
 <1505940337-79069-4-git-send-email-keescook@chromium.org> <alpine.DEB.2.20.1709211024120.14427@nuc-kabylake>
 <CAGXu5j+X6dWCGocG=P7pszTY-5OZ6Jmp-RsnDKox75M5rmVe4g@mail.gmail.com> <alpine.DEB.2.20.1709211102320.14742@nuc-kabylake>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 21 Sep 2017 11:26:43 -0700
Message-ID: <CAGXu5jKqWShVMqm6-moqgO7JUaJuFxw-9mMKak+WG1HgNJqc1Q@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH v3 03/31] usercopy: Mark kmalloc
 caches as usercopy caches
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christopher Lameter <cl@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Windsor <dave@nullcore.net>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, linux-xfs@vger.kernel.org, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>

On Thu, Sep 21, 2017 at 9:04 AM, Christopher Lameter <cl@linux.com> wrote:
> On Thu, 21 Sep 2017, Kees Cook wrote:
>
>> > So what is the point of this patch?
>>
>> The DMA kmalloc caches are not whitelisted:
>
> The DMA kmalloc caches are pretty obsolete and mostly there for obscure
> drivers.
>
> ??

They may be obsolete, but they're still in the kernel, and they aren't
copied to userspace, so we can mark them.

>> >>                         kmalloc_dma_caches[i] = create_kmalloc_cache(n,
>> >> -                               size, SLAB_CACHE_DMA | flags);
>> >> +                               size, SLAB_CACHE_DMA | flags, 0, 0);
>>
>> So this is creating the distinction between the kmallocs that go to
>> userspace and those that don't. The expectation is that future work
>> can start to distinguish between "for userspace" and "only kernel"
>> kmalloc allocations, as is already done here for DMA.
>
> The creation of the kmalloc caches in earlier patches already setup the
> "whitelisting". Why do it twice?

Patch 1 is to allow for things to mark their whitelists. Patch 30
disables the full whitelisting, since then we've defined them all, so
the kmalloc caches need to mark themselves as whitelisted.

Patch 1 leaves unmarked things whitelisted so we can progressively
tighten the restriction and have a bisectable series. (i.e. if there
is something wrong with one of the whitelists in the series, it will
bisect to that one, not the one that removes the global whitelist from
patch 1.)

-Kees

-- 
Kees Cook
Pixel Security
