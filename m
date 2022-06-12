Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E105FC43334
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Jun 2022 18:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbiFLSBZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Jun 2022 14:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233747AbiFLSAg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Jun 2022 14:00:36 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CCD237D2
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 11:00:35 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id f13so3955199vsp.1
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 11:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QEcsAXXaVRKVS5g+mazai8AK12VIklN03xS+L+Nhtx8=;
        b=PP4i51S8epeVaiFcz5OPgxIkS3qd19Nk14h3/oSNduTadgWRuqTUEPNVmfHTYFyE2M
         3p6JSnKRvhcTkWYCFVD2AV+qSny3fhaYhzWnrbODqYBoWTolQB/C14r9TKL9P4YyNHnb
         nC8/ugQArQh5SOheJDI7I42rRIhYsRfzDk04S2Ur+NTMfTtydj2tZ6ZKG4PmCIP3xdPt
         GFJIO37e/CiP8A+XzHCSi9DTetlZe7ouDGJz6PTeBMtrrKRfxM1cdeT8hK6f6dYORv9I
         +LaMV229+AMbocrtcqfAuSUFhA00JlogeQHB2W3CGhpUUEvywz36qY+GLOeTuVyTEWJl
         khpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QEcsAXXaVRKVS5g+mazai8AK12VIklN03xS+L+Nhtx8=;
        b=DCLqtFNb/o6jwcA812m1eiaaAEhN4XOVHXRyhtJX8ll7AvPdyGyVKygR2xRADZaErK
         hodW7u3STvl591qedzbCOprsxmYegiWpSdJfk91ldBuQm4pCt0HutWcaZS4nz9wyYArn
         nsr+HoARTMD0vcpUva2c7ZQ9wrBrZQ5ig4N03uQfVeG7LIvbjvcWqgwWhCDoTZ0GeTYh
         Wmxtx5U8uQrUOWQOlSJq02DXzSIkxoZZvbhfRlcoH7uzba/u/f5k6aMc+YpBD1VB5RZk
         ds/WLKHa1Q1mKLdAiMBZSb0FuadPgjkb7cYeP7Tp14WPMVKlV+Wh7PfoSODQhpAbWDWR
         13iw==
X-Gm-Message-State: AOAM532/kr01HpwlgRkOpz69vUntuv67or/dGqk9L6rRVPUaTv8aAqSJ
        BeYlSrfUETIpB9kfbbuPFGuwLILy0NYTXIaUTj2VrA==
X-Google-Smtp-Source: ABdhPJzhRA0NsYkN3KKihBGWs6FiVEoXnK8AyOCep8jLnBR9urWp92pMNL82G21RvEtLn0GH64iELoUYkorTnFHvnOE=
X-Received: by 2002:a67:f3d0:0:b0:34b:b52d:d676 with SMTP id
 j16-20020a67f3d0000000b0034bb52dd676mr15884899vsn.6.1655056834360; Sun, 12
 Jun 2022 11:00:34 -0700 (PDT)
MIME-Version: 1.0
References: <bug-216073-27@https.bugzilla.kernel.org/> <20220606151312.6a9d098c85ed060d36519600@linux-foundation.org>
 <Yp9pHV14OqvH0n02@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <20220608021922.n2izu7n4yoadknkx@zlang-mailbox> <YqD0yAELzHxdRBU6@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <20220612044230.murerhsa765akogj@zlang-mailbox> <YqXU+oU7wayOcmCe@casper.infradead.org>
 <YqXkGMY9xtUvPR5D@pc638.lan> <YqYh0xyJvoNsSOpy@casper.infradead.org>
In-Reply-To: <YqYh0xyJvoNsSOpy@casper.infradead.org>
From:   Yu Zhao <yuzhao@google.com>
Date:   Sun, 12 Jun 2022 11:59:58 -0600
Message-ID: <CAOUHufbBkcjChkMfF8exh3=6=JM09-GCU71KXhUGmz4UdOhUmg@mail.gmail.com>
Subject: Re: [Bug 216073] New: [s390x] kernel BUG at mm/usercopy.c:101!
 usercopy: Kernel memory exposure attempt detected from vmalloc 'n o area'
 (offset 0, size 1)!
To:     Matthew Wilcox <willy@infradead.org>,
        Uladzislau Rezki <urezki@gmail.com>
Cc:     Zorro Lang <zlang@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        bugzilla-daemon@kernel.org, linux-s390@vger.kernel.org,
        linux-xfs@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 12, 2022 at 11:27 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Sun, Jun 12, 2022 at 03:03:20PM +0200, Uladzislau Rezki wrote:
> > > @@ -181,8 +181,9 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
> > >                     return;
> > >             }
> > >
> > > -           offset = ptr - area->addr;
> > > -           if (offset + n > get_vm_area_size(area))
> > > +           /* XXX: We should also abort for free vmap_areas */
> > > +           offset = (unsigned long)ptr - area->va_start;
> > >
> > I was a bit confused about "offset" and why it is needed here. It is always zero.
> > So we can get rid of it to make it less confused. From the other hand a zero offset
> > contributes to nothing.
>
> I don't think offset is necessarily zero.  'ptr' is a pointer somewhere
> in the object, not necessarily the start of the object.
>
> > >
> > > +           if (offset + n >= area->va_end)
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

Please let me know if there is something we want to test -- I can
reproduce the problem reliably:

------------[ cut here ]------------
kernel BUG at mm/usercopy.c:101!
Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
CPU: 4 PID: 3259 Comm: iptables Not tainted 5.19.0-rc1-lockdep+ #1
pc : usercopy_abort+0x9c/0xa0
lr : usercopy_abort+0x9c/0xa0
sp : ffffffc010bd78d0
x29: ffffffc010bd78e0 x28: 42ffff80ac08d8ec x27: 42ffff80ac08d8ec
x26: 42ffff80ac08d8c0 x25: 000000000000000a x24: ffffffdf4c7e5120
x23: 000000000bec44c2 x22: efffffc000000000 x21: ffffffdf2896b0c0
x20: 0000000000000001 x19: 000000000000000b x18: 0000000000000000
x17: 2820636f6c6c616d x16: 0000000000000042 x15: 6574636574656420
x14: 74706d6574746120 x13: 0000000000000018 x12: 000000000000000d
x11: ff80007fffffffff x10: 0000000000000001 x9 : db174b7f89103400
x8 : db174b7f89103400 x7 : 0000000000000000 x6 : 79706f6372657375
x5 : ffffffdf4d9c617e x4 : 0000000000000000 x3 : ffffffdf4b7d017c
x2 : ffffff80eb188b18 x1 : 42ffff80ac08d8c8 x0 : 0000000000000066
Call trace:
 usercopy_abort+0x9c/0xa0
 __check_object_size+0x38c/0x400
 xt_obj_to_user+0xe4/0x200
 xt_compat_target_to_user+0xd8/0x18c
 compat_copy_entries_to_user+0x278/0x424
 do_ipt_get_ctl+0x7bc/0xb2c
 nf_getsockopt+0x7c/0xb4
 ip_getsockopt+0xee8/0xfa4
 raw_getsockopt+0xf4/0x23c
 sock_common_getsockopt+0x48/0x54
 __sys_getsockopt+0x11c/0x2f8
 __arm64_sys_getsockopt+0x60/0x70
 el0_svc_common+0xfc/0x1cc
 do_el0_svc_compat+0x38/0x5c
 el0_svc_compat+0x68/0xf4
 el0t_32_sync_handler+0xc0/0xf0
 el0t_32_sync+0x190/0x194
Code: aa0903e4 a9017bfd 910043fd 9438be18 (d4210000)
---[ end trace 0000000000000000 ]---
