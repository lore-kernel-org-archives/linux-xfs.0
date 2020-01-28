Return-Path: <SRS0=UJS8=3R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BDF2C33CB3
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 23:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70F872087F
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 23:02:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="SLEtsTXM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgA1XB4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jan 2020 18:01:56 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45724 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbgA1XB4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jan 2020 18:01:56 -0500
Received: by mail-pg1-f194.google.com with SMTP id b9so7786977pgk.12
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2020 15:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+dg91h5BizLIOhJtrfPoQX1PBXFzRkzG/EccKIP5g+k=;
        b=SLEtsTXM5HHL6KRx3hcUWmwHu6WOPgN0CNP8fHNTI+FAT+8rXdOFNHQ4Yag2eY0oom
         MxIjkObrnioymch5q5MyrzGbWNjwhgMUswCx/M+MVBVQAe23jccXfrAxinTI930p2387
         D9bys2Kwzdd099/FcXPhmwL9QuGCzxCyDD8ZA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+dg91h5BizLIOhJtrfPoQX1PBXFzRkzG/EccKIP5g+k=;
        b=l8pWGjg2cR1UDxfMUQiuRRgk6QRV6A1iTTSekStG5QmvFm5zaorGFyk+aYWYhZjRIK
         SZgthqaJBunkBpq0JE2WRBYxZ5VhqPcg5j8csqPTLcEkk+0K4I7HVmXsrQeaJ0fjX8aq
         8ii/de/IUObPB2aznSt0z4ErY6uzfHl8tt3y5XrOhQUM403+trhfSl5SXE3FUJBHIiW7
         toFsTvYugJhvH5JHP2ujiSCqYJGS7frkL5VOHbknkfVi8zLAfFBhMpb4YnELqiygLMHq
         JeBvG9RM4Au4HNUnxO39o7kvscX+kPLrIS686hNka7xHjU9NzK2UkMLZ8m0rteNWsBT1
         C+dw==
X-Gm-Message-State: APjAAAWyJNoGJnasIJzuxLAXOX9NyGbBRU6wotU69xl8kz2KXbN5Bdi9
        Tdmpp+/n9k1/rK2dmtl4qja4ag==
X-Google-Smtp-Source: APXvYqxW3ZrU4wM0/mAVtxUyqtcw5VzYRKNT21IpKIlpAgs8GJ04bta0GGU8Rs7byefZaonYLylsnQ==
X-Received: by 2002:aa7:82d5:: with SMTP id f21mr6360681pfn.245.1580252515843;
        Tue, 28 Jan 2020 15:01:55 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k21sm136324pgt.22.2020.01.28.15.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2020 15:01:54 -0800 (PST)
Date:   Tue, 28 Jan 2020 15:01:53 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Jiri Slaby <jslaby@suse.cz>, Julian Wiedmann <jwi@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, David Windsor <dave@nullcore.net>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Christoph Lameter <cl@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Laura Abbott <labbott@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Jan Kara <jack@suse.cz>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Rik van Riel <riel@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
        netdev@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [kernel-hardening] [PATCH 09/38] usercopy: Mark kmalloc caches
 as usercopy caches
Message-ID: <202001281457.FA11CC313A@keescook>
References: <1515636190-24061-1-git-send-email-keescook@chromium.org>
 <1515636190-24061-10-git-send-email-keescook@chromium.org>
 <9519edb7-456a-a2fa-659e-3e5a1ff89466@suse.cz>
 <201911121313.1097D6EE@keescook>
 <201911141327.4DE6510@keescook>
 <bfca96db-bbd0-d958-7732-76e36c667c68@suse.cz>
 <202001271519.AA6ADEACF0@keescook>
 <5861936c-1fe1-4c44-d012-26efa0c8b6e7@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5861936c-1fe1-4c44-d012-26efa0c8b6e7@de.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 28, 2020 at 08:58:31AM +0100, Christian Borntraeger wrote:
> 
> 
> On 28.01.20 00:19, Kees Cook wrote:
> > On Thu, Jan 23, 2020 at 09:14:20AM +0100, Jiri Slaby wrote:
> >> On 14. 11. 19, 22:27, Kees Cook wrote:
> >>> On Tue, Nov 12, 2019 at 01:21:54PM -0800, Kees Cook wrote:
> >>>> How is iucv the only network protocol that has run into this? Do others
> >>>> use a bounce buffer?
> >>>
> >>> Another solution would be to use a dedicated kmem cache (instead of the
> >>> shared kmalloc dma one)?
> >>
> >> Has there been any conclusion to this thread yet? For the time being, we
> >> disabled HARDENED_USERCOPY on s390...
> >>
> >> https://lore.kernel.org/kernel-hardening/9519edb7-456a-a2fa-659e-3e5a1ff89466@suse.cz/
> > 
> > I haven't heard anything new. What did people think of a separate kmem
> > cache?
> > 
> 
> Adding Julian and Ursula. A separate kmem cache for iucv might be indeed
> a solution for the user hardening issue.

It should be very clean -- any existing kmallocs already have to be
"special" in the sense that they're marked with the DMA flag. So
converting these to a separate cache should be mostly mechanical.

> On the other hand not marking the DMA caches still seems questionable.

My understanding is that exposing DMA memory to userspace copies can
lead to unexpected results, especially for misbehaving hardware, so I'm
not convinced this is a generically bad hardening choice.

-Kees

> 
> For reference
> https://bugzilla.suse.com/show_bug.cgi?id=1156053
> the kernel hardening now triggers a warning.
> 

-- 
Kees Cook
