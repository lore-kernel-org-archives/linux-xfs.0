Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4DFDCCA473
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Jun 2022 19:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbiFLTH5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Jun 2022 15:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233945AbiFLTH4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Jun 2022 15:07:56 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88EA26547;
        Sun, 12 Jun 2022 12:07:54 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id y29so4144169ljd.7;
        Sun, 12 Jun 2022 12:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/lRrX5aKWLjE/LdPrNz1fAnJtllQTJwoJoNcjGrmnxk=;
        b=E02cn2lO+RPuC7XXwZFrNYb3KP5mVhxYPStSV98kHlD/R3jGkV+bTFZTmF5ZsCgfyl
         TlrD0OIJ1Af45nPpx1Lkhe98VVwUqIiXM4/9l77AjoUtwhiZY9LqNh1dcyHP0c37/YOt
         T4IzsJ+AYuMhw23vVAC8/HPpEMtslgb41vmsm8TmOJUbTlPg0MoTFPKXojAueVjNm8jb
         m/J3EyXIMaGGrbJ/rvj8z3K1SifLGU/dvUuYku6iy3iYriWve1zToNp55q/okwHQ/6/Q
         WR9pFi4ePwC7EGYe2V7JwQFPANmPgQtgP7+r1TgJvz6yauwI2xgYkMmK7/Jym0llaj7O
         9JzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/lRrX5aKWLjE/LdPrNz1fAnJtllQTJwoJoNcjGrmnxk=;
        b=Zwp7SB8RivU/Z2SeSIHfflTjqlnk+0psshtfpfqsjVNszlfzVyfNGKYKKBycz4+yGn
         jqUGNZ/vBbJIoYtoPXndIIhE4vWqrPZODAxD2mQJl4j1LscXAK3joAt5pGZ6p/WFbEwN
         ya52lGRtkS1tMVzCA2oxot+lpNXd2BWrt3vWFV0b9cSZKIFHFivaYBodeqWilr8Mee9T
         Vu0/tBxanTy72f/NX7KpPgBCm+86E9FpdiNz2Nr1eHvR7Q9kHnwDh2veLF24C7Hh5DsD
         zSqfIMT9/M6yE2G1Lujx4hZ3VK7BsGbFHxYFiXmc3uj4495QgLIIulox5GFbI7XtZAaC
         dRwg==
X-Gm-Message-State: AOAM5339pbX4TO8zgsAUrX6QTts0KhZrqjvM1Cj1RMLNaxPGgztN9QyT
        KDQ/EuQQe78JAhaZprdRFbevGdg71cIQKA==
X-Google-Smtp-Source: ABdhPJy851Li2/EGWVlluRRVu5vxEDi8U8jOZqo3ku4xXL+Y7QuRxMV0kmW5cdCL9yR8J2B5EiSdcQ==
X-Received: by 2002:a2e:7d05:0:b0:255:5dcf:f294 with SMTP id y5-20020a2e7d05000000b002555dcff294mr33620493ljc.187.1655060873150;
        Sun, 12 Jun 2022 12:07:53 -0700 (PDT)
Received: from pc638.lan ([155.137.26.201])
        by smtp.gmail.com with ESMTPSA id v22-20020a05651203b600b0047255d21171sm200596lfp.160.2022.06.12.12.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jun 2022 12:07:52 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Sun, 12 Jun 2022 21:07:50 +0200
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Uladzislau Rezki <urezki@gmail.com>, Zorro Lang <zlang@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        bugzilla-daemon@kernel.org, linux-s390@vger.kernel.org,
        linux-xfs@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Kees Cook <keescook@chromium.org>
Subject: Re: [Bug 216073] New: [s390x] kernel BUG at mm/usercopy.c:101!
 usercopy: Kernel memory exposure attempt detected from vmalloc 'n  o area'
 (offset 0, size 1)!
Message-ID: <YqY5hrW5jJPTxgZx@pc638.lan>
References: <bug-216073-27@https.bugzilla.kernel.org/>
 <20220606151312.6a9d098c85ed060d36519600@linux-foundation.org>
 <Yp9pHV14OqvH0n02@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <20220608021922.n2izu7n4yoadknkx@zlang-mailbox>
 <YqD0yAELzHxdRBU6@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <20220612044230.murerhsa765akogj@zlang-mailbox>
 <YqXU+oU7wayOcmCe@casper.infradead.org>
 <YqXkGMY9xtUvPR5D@pc638.lan>
 <YqYh0xyJvoNsSOpy@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqYh0xyJvoNsSOpy@casper.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Sun, Jun 12, 2022 at 03:03:20PM +0200, Uladzislau Rezki wrote:
> > > @@ -181,8 +181,9 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
> > >  			return;
> > >  		}
> > >  
> > > -		offset = ptr - area->addr;
> > > -		if (offset + n > get_vm_area_size(area))
> > > +		/* XXX: We should also abort for free vmap_areas */
> > > +		offset = (unsigned long)ptr - area->va_start;
> > >
> > I was a bit confused about "offset" and why it is needed here. It is always zero. 
> > So we can get rid of it to make it less confused. From the other hand a zero offset
> > contributes to nothing.
> 
> I don't think offset is necessarily zero.  'ptr' is a pointer somewhere
> in the object, not necessarily the start of the object.
> 
Right you are. Just checked the __find_vmap_area() it returns VA of the address it
belongs to. Initially i was thinking that addr have to be exactly as va->start only,
so i was wrong.

> > >
> > > +		if (offset + n >= area->va_end)
> > >
> > I think it is a bit wrong. As i see it, "n" is a size and what we would like to do
> > here is boundary check:
> > 
> > <snip>
> > if (n > va_size(area))
> >     usercopy_abort("vmalloc", NULL, to_user, 0, n);
> > <snip>
> 
> Hmm ... we should probably be more careful about wrapping.
> 
>                 if (n > area->va_end - addr)
>                         usercopy_abort("vmalloc", NULL, to_user, offset, n);
> 
> ... and that goes for the whole function actually.  I'll split that into
> a separate change.
> 
Based on that offset can be > 0, checking "offset + n" with va->va_end is OK.

<snip>
if (offset + n > area->va_end)
    usercopy_abort("vmalloc", NULL, to_user, offset, n);
<snip>

--
Uladzislau Rezki
