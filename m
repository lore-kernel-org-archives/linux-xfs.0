Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3A38C43334
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Jun 2022 17:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiFLR0z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Jun 2022 13:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiFLR0y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Jun 2022 13:26:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0F55A083;
        Sun, 12 Jun 2022 10:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zrnFIBXm601T4yQOf/WyT3Lwfcbm3/ZR9fWcKu8zKB8=; b=Cc/lSueRI3PMxodzEHYOLMnGM9
        pkQXAZnMt3uVgZfLakvT2rHimT3er0bzYwlSyl0kKn9JmNhRX6NVSR3HAimG4x5IKjFeprULEl1H2
        p5fZBmAwzWBsFtbS7dveCnRR+F7Li0bMuUuejUGK3d2bVs8genSEfACxcWmrkWl9hhg+TmjRM3MzV
        AYWHUO6oXYhK19RpPjOb/6tRvfs61qaUDkM7xrp6gMGlB035CyQtC98oZIWuZ6zYrj7uwiFXDpeRG
        Ep9fnijSlwGtqtRX0kz7UEu8K5UG8Uwm0DPNZNaQObefz3WYWpCmP8nVwfkLsDy4R5HNStj8DXmzM
        pqlko/gg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o0RMJ-00G9qW-G0; Sun, 12 Jun 2022 17:26:43 +0000
Date:   Sun, 12 Jun 2022 18:26:43 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Uladzislau Rezki <urezki@gmail.com>
Cc:     Zorro Lang <zlang@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        bugzilla-daemon@kernel.org, linux-s390@vger.kernel.org,
        linux-xfs@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Kees Cook <keescook@chromium.org>
Subject: Re: [Bug 216073] New: [s390x] kernel BUG at mm/usercopy.c:101!
 usercopy: Kernel memory exposure attempt detected from vmalloc 'n  o area'
 (offset 0, size 1)!
Message-ID: <YqYh0xyJvoNsSOpy@casper.infradead.org>
References: <bug-216073-27@https.bugzilla.kernel.org/>
 <20220606151312.6a9d098c85ed060d36519600@linux-foundation.org>
 <Yp9pHV14OqvH0n02@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <20220608021922.n2izu7n4yoadknkx@zlang-mailbox>
 <YqD0yAELzHxdRBU6@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <20220612044230.murerhsa765akogj@zlang-mailbox>
 <YqXU+oU7wayOcmCe@casper.infradead.org>
 <YqXkGMY9xtUvPR5D@pc638.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqXkGMY9xtUvPR5D@pc638.lan>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 12, 2022 at 03:03:20PM +0200, Uladzislau Rezki wrote:
> > @@ -181,8 +181,9 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
> >  			return;
> >  		}
> >  
> > -		offset = ptr - area->addr;
> > -		if (offset + n > get_vm_area_size(area))
> > +		/* XXX: We should also abort for free vmap_areas */
> > +		offset = (unsigned long)ptr - area->va_start;
> >
> I was a bit confused about "offset" and why it is needed here. It is always zero. 
> So we can get rid of it to make it less confused. From the other hand a zero offset
> contributes to nothing.

I don't think offset is necessarily zero.  'ptr' is a pointer somewhere
in the object, not necessarily the start of the object.

> >
> > +		if (offset + n >= area->va_end)
> >
> I think it is a bit wrong. As i see it, "n" is a size and what we would like to do
> here is boundary check:
> 
> <snip>
> if (n > va_size(area))
>     usercopy_abort("vmalloc", NULL, to_user, 0, n);
> <snip>

Hmm ... we should probably be more careful about wrapping.

                if (n > area->va_end - addr)
                        usercopy_abort("vmalloc", NULL, to_user, offset, n);

... and that goes for the whole function actually.  I'll split that into
a separate change.

