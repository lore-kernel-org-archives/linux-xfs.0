Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8CACCA473
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Jun 2022 20:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiFLUxw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Jun 2022 16:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235747AbiFLUxv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Jun 2022 16:53:51 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C183C42A3B
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 13:53:50 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id j39so4176506vsv.11
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 13:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OJfotZiRzuoS+7CnA5NemSTVt7fepw5ufihdBDzzgQQ=;
        b=KXAKuvYoZX6voVfebZciqsFuaOT1xlylP/bXjRsOd3khGsexHMExqDJTGaXDWkxC/U
         WlW9rLB4Cr8X2AUypnU3qY/y2zOoEz16xqXUOu5B6oONQeMTaS0YctoXDzusseC91Jt3
         vVo0FCJdanTfiSAqu9vlWRrSwP8vwe3u+1Oyw9sPI5znsSlnmfaPPOkja8qDqE/t88ab
         lp8Azxs0YfoAzd3PW853IDmhZzK+gOdz55CuV2HJfv49q8OS0+fpFcSHJQSBkigHnSlY
         +hw/tW99NN1hNhtjRA8eosw2rzmBWa+OJutfNW0W0K/BWfEOslmyoX71i+wHeiVO9YIh
         dAfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OJfotZiRzuoS+7CnA5NemSTVt7fepw5ufihdBDzzgQQ=;
        b=4U42Gg64T89bf39NYYqUJ6n9smK54/luxGnytNy3WAj7PfyajblSeRg3pJdw1wp2Yn
         +HziJP0gbC9oSB+OrDvbA4LmlvgBr7L712l/ZTtUcAVC/1KKc1Lmp40aBflp0R8NX19I
         vFJwkKj7KgG4OLusbbPZGMjFCbv7o1ykXbczs+4rWxeHIdyXRT2M9NZoYlsCxGunkB8s
         Jck6EZPTASuQt58bpX9K7EU1agz5w2gQe3OkWHNPWhkJ8kULWUWT7UthYuVN6kI91q0t
         FTp5L6f1vSKjKk4Txfswua0SxNNDjNSX2UTkkk+Dv0RrIniCNn9/gnrmyARVphADB9mB
         GztA==
X-Gm-Message-State: AOAM531HwIeojO54tx7DpGb1jM5JBNj6k28FWlC9wOXJ0MOeo6PwzSni
        K3SEtpUO/n21cjKIlsC0oW2jF2LEpZoxP4DR5015EQ==
X-Google-Smtp-Source: ABdhPJwBVf+WBAiEXjrt+ydVOHqQ5Be67mgqqSivacZ32Q88vfjoi97jW7UtQXBof9HP9JSki187Blq+rKsVWaKI6/o=
X-Received: by 2002:a67:f3d0:0:b0:34b:b52d:d676 with SMTP id
 j16-20020a67f3d0000000b0034bb52dd676mr16027842vsn.6.1655067229790; Sun, 12
 Jun 2022 13:53:49 -0700 (PDT)
MIME-Version: 1.0
References: <Yp9pHV14OqvH0n02@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <20220608021922.n2izu7n4yoadknkx@zlang-mailbox> <YqD0yAELzHxdRBU6@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <20220612044230.murerhsa765akogj@zlang-mailbox> <YqXU+oU7wayOcmCe@casper.infradead.org>
 <YqXkGMY9xtUvPR5D@pc638.lan> <YqYh0xyJvoNsSOpy@casper.infradead.org>
 <CAOUHufbBkcjChkMfF8exh3=6=JM09-GCU71KXhUGmz4UdOhUmg@mail.gmail.com>
 <YqYq846zFUInllTw@casper.infradead.org> <CAOUHufan8+uombVMSSrKra-8Cu5pSJj80LVa6QrGbFzBmUQHxg@mail.gmail.com>
 <YqZD/5sUmeJJMonT@casper.infradead.org>
In-Reply-To: <YqZD/5sUmeJJMonT@casper.infradead.org>
From:   Yu Zhao <yuzhao@google.com>
Date:   Sun, 12 Jun 2022 14:53:13 -0600
Message-ID: <CAOUHufZujyohTuqeMqk+yzba17wHSmT2NxbwO_98ApO+LgJ0XA@mail.gmail.com>
Subject: Re: [Bug 216073] New: [s390x] kernel BUG at mm/usercopy.c:101!
 usercopy: Kernel memory exposure attempt detected from vmalloc 'n o area'
 (offset 0, size 1)!
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Uladzislau Rezki <urezki@gmail.com>, Zorro Lang <zlang@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        bugzilla-daemon@kernel.org, linux-s390@vger.kernel.org,
        linux-xfs@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 12, 2022 at 1:52 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Sun, Jun 12, 2022 at 12:43:45PM -0600, Yu Zhao wrote:
> > On Sun, Jun 12, 2022 at 12:05 PM Matthew Wilcox <willy@infradead.org> wrote:
> > >
> > > On Sun, Jun 12, 2022 at 11:59:58AM -0600, Yu Zhao wrote:
> > > > Please let me know if there is something we want to test -- I can
> > > > reproduce the problem reliably:
> > > >
> > > > ------------[ cut here ]------------
> > > > kernel BUG at mm/usercopy.c:101!
> > >
> > > The line right before cut here would have been nice ;-)
> >
> > Right.
> >
> > $ grep usercopy:
> > usercopy: Kernel memory exposure attempt detected from vmalloc (offset
> > 2882303761517129920, size 11)!
> > usercopy: Kernel memory exposure attempt detected from vmalloc (offset
> > 8574853690513436864, size 11)!
> > usercopy: Kernel memory exposure attempt detected from vmalloc (offset
> > 7998392938210013376, size 11)!
>
> That's a different problem.  And, er, what?  How on earth do we have
> an offset that big?!
>
>                 struct vm_struct *area = find_vm_area(ptr);
>                 offset = ptr - area->addr;
>                 if (offset + n > get_vm_area_size(area))
>                         usercopy_abort("vmalloc", NULL, to_user, offset, n);
>
> That first offset is 0x2800'0000'0000'30C0
>
> You said it was easy to replicate; can you add:
>
>                         printk("addr:%px ptr:%px\n", area->addr, ptr);
>
> so that we can start to understand how we end up with such a bogus
> offset?

Here you go:

addr:96ffffdfebcd4000 ptr:ffffffdfebcd70c0
usercopy: Kernel memory exposure attempt detected from vmalloc (offset
7566047373982445760, size 11)!

And, not sure if it'd be helpful, with the vmap:

va_start:ffffffd83db0d000 va_end:ffffffd83db13000
addr:44ffffd83db0d000 ptr:ffffffd83db100c0
usercopy: Kernel memory exposure attempt detected from vmalloc (offset
13474770085092536512, size 11)!

which seems to explain why the fix worked.

+               if (offset + n > get_vm_area_size(area)) {
+                       struct vmap_area *vmap =
find_vmap_area((unsigned long)ptr);
+
+                       if (vmap)
+                               printk("va_start:%px va_end:%px\n",
vmap->va_start, vmap->va_end);
+                       printk("addr:%px ptr:%px\n", area->addr, ptr);
                        usercopy_abort("vmalloc", NULL, to_user, offset, n);
+               }
