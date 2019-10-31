Return-Path: <SRS0=K+Ru=YY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34AD3CA9ECB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Oct 2019 15:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF0E72086D
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Oct 2019 15:36:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zadara-com.20150623.gappssmtp.com header.i=@zadara-com.20150623.gappssmtp.com header.b="Kl+WNO9+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfJaPgv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Oct 2019 11:36:51 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:44013 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727579AbfJaPgv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Oct 2019 11:36:51 -0400
Received: by mail-il1-f194.google.com with SMTP id j2so3640267ilc.10
        for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2019 08:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eybFv9TksRaRuykiLtKaiiRJ9IgYN2m38aExykQQoY0=;
        b=Kl+WNO9+ThQxJA8BW1Nn3kwb4eAmfnh02fYb0ZdyN23qGBFYkTelqS5OcThpOKg4Ch
         jMSCg8wE4ymWIRtcsu8p+QYMwZSgFPBTHORygZoeFiCI9qWG0eWr9Vz8Steu1UJOyYV7
         wbjiJU78szh7/rXCWKZrZbLcsU0ch9/4Q2Ubhi3i4Ovnpl1fMFONK73USTF+lcl8bdcu
         KewKCsL3WFwiHB7EcugLVXkDx3HpZRXI84hH0CxX4R6qB+6wJhxb4bw7eocYjcqBdUIv
         XwBP13LGbFQZ+AfSXBBDGdVdhhfVJdmvCLaOd7WmG/XXrUG6KPXfL+B8MBqmRYAcKGQR
         8Qiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eybFv9TksRaRuykiLtKaiiRJ9IgYN2m38aExykQQoY0=;
        b=MEly8p2tRo5jnwwMrtnJDCHQzhVnDmO8wuUkmAF6ITYke0kzKJdBxdxRnGbXKWkyYG
         Dz3LFDnSPVNZHsVvv5eprsE3To+rY2l0fOB0/e6GeBbXs+j8f0hSeRqOZ7ru7seGMHSC
         eeXf5WJZmfYV9dZ7E2x8IjGXqUTHD5Wl3uEFbTdIasdg+OPUZ0mcJXAy5C/ozYy/oVDV
         p/4d+SOkHGkdQX6JFbYwTEOUVRsvdq4ZwBUZc0bUzfyI1NbhRBfA+5ZwhX+IB4y4Plv4
         mMuty3iyrzf9UNBcILj+v0tmVEZJ5xwg07LjI1IFgv2bBWenYmXf2fr+vG8Li5EeEPJG
         4fgQ==
X-Gm-Message-State: APjAAAWeEG81URwaDrujcZrWJfrLHbqqHBi790QdgDUGguSVe9evSX1u
        KPDq7RH1Ah+KRKv70W+J94ncZYC5Z9AmrqZcCtPV4g==
X-Google-Smtp-Source: APXvYqw535MJgfohP9garydRsUUYHTz87tRwIHI9FnR2JJTIJyjRiKXTd+KPqMPYJ8YhozY6UAk5/kj0WSv2mSCU2SU=
X-Received: by 2002:a92:889c:: with SMTP id m28mr6737542ilh.157.1572536209703;
 Thu, 31 Oct 2019 08:36:49 -0700 (PDT)
MIME-Version: 1.0
References: <CC133B1B9D9B46AFAB2D35A366BF7DC4@alyakaslap> <20191021124714.GA26105@bfoster>
 <CAOcd+r1cwsoGD5=VtJjRwmh5Sp9MVmSv9xRq8S9STs=cUyMH+Q@mail.gmail.com> <20191022110600.GA50656@bfoster>
In-Reply-To: <20191022110600.GA50656@bfoster>
From:   Alex Lyakas <alex@zadara.com>
Date:   Thu, 31 Oct 2019 17:36:37 +0200
Message-ID: <CAOcd+r3N9qywHLnodcFNDcHeQ67HxGNPw53oL3XR8p++UapRRQ@mail.gmail.com>
Subject: Re: xfs_buftarg_isolate(): "Correctly invert xfs_buftarg LRU
 isolation logic"
To:     Brian Foster <bfoster@redhat.com>
Cc:     vbendel@redhat.com, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Brian,

On Tue, Oct 22, 2019 at 2:06 PM Brian Foster <bfoster@redhat.com> wrote:
>
> On Tue, Oct 22, 2019 at 09:49:56AM +0300, Alex Lyakas wrote:
> > Hi Brian,
> >
> > Thank you for your response.
> >
> > On Mon, Oct 21, 2019 at 3:47 PM Brian Foster <bfoster@redhat.com> wrote:
> > >
> > > On Sun, Oct 20, 2019 at 05:54:03PM +0300, Alex Lyakas wrote:
> > > > Hello Vratislav, Brian,
> > > >
> > > > This is with regards to commit "xfs: Correctly invert xfs_buftarg LRU
> > > > isolation logic" [1].
> > > >
> > > > I am hitting this issue in kernel 4.14. However, after some debugging, I do
> > > > not fully agree with the commit message, describing the effect of this
> > > > defect.
> > > >
> > > > In case b_lru_ref > 1, then indeed this xfs_buf will be taken off the LRU
> > > > list, and immediately added back to it, with b_lru_ref being lesser by 1
> > > > now.
> > > >
> > > > In case b_lru_ref==1, then this xfs_buf will be similarly isolated (due to a
> > > > bug), and xfs_buf_rele() will be called on it. But now its b_lru_ref==0. In
> > > > this case, xfs_buf_rele() will free the buffer, rather than re-adding it
> > > > back to the LRU. This is a problem, because we intended for this buffer to
> > > > have another trip on the LRU. Only when b_lru_ref==0 upon entry to
> > > > xfs_buftarg_isolate(), we want to free the buffer. So we are freeing the
> > > > buffer one trip too early in this case.
> > > >
> > > > In case b_lru_ref==0 (somehow), then due to a bug, this xfs_buf will not be
> > > > removed off the LRU. It will remain sitting in the LRU with b_lru_ref==0. On
> > > > next shrinker call, this xfs_buff will also remain on the LRU, due to the
> > > > same bug. So this xfs_buf will be freed only on unmount or if
> > > > xfs_buf_stale() is called on it.
> > > >
> > > > Do you agree with the above?
> > > >
> > >
> > > I'm not really sure how you're inferring what cases free the buffer vs.
> > > what don't based on ->b_lru_ref. A buffer is freed when its reference
> > > count (->b_hold) drops to zero unless ->b_lru_ref is non-zero, at which
> > > point the buffer goes on the LRU and the LRU itself takes a ->b_hold
> > > reference to keep the buffer from being freed. This reference is not
> > > associated with how many cycles through the LRU a buffer is allowed
> > > before it is dropped from the LRU, which is what ->b_lru_ref tracks.
> > >
> > > Since the LRU holds a (single) reference to the buffer just like any
> > > other user of the buffer, it doesn't make any direct decision on when to
> > > free a buffer or not. In other words, the bug fixed by this patch is
> > > related to when we decide to drop the buffer from the LRU based on the
> > > LRU ref count. If the LRU ->b_hold reference happens to be the last on
> > > the buffer when it is dropped from the LRU, then the buffer is freed.
> >
> > I apologize for the confusion. By "freed" I really meant "taken off
> > the LRU". I am aware of the fact that b_hold is controlling whether
> > the buffer will be freed or not.
> >
>
> Ok.
>
> > What I meant is that the commit description does not address the issue
> > accurately. From the description one can understand that the only
> > problem is the additional trip through the LRU.
> > But in fact, due to this issue, buffers will spend one cycle less in
> > the LRU than intended. If we initialize b_lru_ref to X, we intend the
> > buffer to survive X shrinker calls, and on the X+1'th call to be taken
> > off the LRU (and maybe freed). But with this issue, the buffer will be
> > taken off the LRU and immediately re-added back. But this will happen
> > X-1 times, because on the X'th time the b_lru_ref will be 0, and the
> > buffer will not be readded to the LRU. So the buffer will survive X-1
> > shrinker calls and not X as intended.
> >
>
> That sounds like a reasonable description of behavior to me. Personally,
> I also think the commit log description is fine because I read it
> generically as just pointing out the logic is backwards. Your
> description above is more detailed and probably more technically
> accurate, but I'm not sure if/why it matters at this point for anything
> beyond just attempting to understand a historical bug (for stable
> backport purposes?).
Mostly I wanted to confirm my understanding. I have sent the stable
patch with this fix.

Thanks,
Alex.



>
> Brian
>
> > Furthermore, if somehow we end up with the buffer sitting on the LRU
> > and having b_lru_ref==0, this buffer will never be taken off the LRU,
> > due to the bug. I am not sure this can happen, because by default
> > b_lru_ref is set to 1.
> >
> >
> > >
> > > > If so, I think this fix should be backported to stable kernels.
> > > >
> > >
> > > Seems reasonable to me. Feel free to post a patch. :)
> > Will do.
> >
> > Thanks,
> > Alex.
> >
> >
> > >
> > > Brian
> > >
> > > > Thanks,
> > > > Alex.
> > > >
> > > > [1]
> > > > commit 19957a181608d25c8f4136652d0ea00b3738972d
> > > > Author: Vratislav Bendel <vbendel@redhat.com>
> > > > Date:   Tue Mar 6 17:07:44 2018 -0800
> > > >
> > > >    xfs: Correctly invert xfs_buftarg LRU isolation logic
> > > >
> > > >    Due to an inverted logic mistake in xfs_buftarg_isolate()
> > > >    the xfs_buffers with zero b_lru_ref will take another trip
> > > >    around LRU, while isolating buffers with non-zero b_lru_ref.
> > > >
> > > >    Additionally those isolated buffers end up right back on the LRU
> > > >    once they are released, because b_lru_ref remains elevated.
> > > >
> > > >    Fix that circuitous route by leaving them on the LRU
> > > >    as originally intended.
> > > >
> > > >    Signed-off-by: Vratislav Bendel <vbendel@redhat.com>
> > > >    Reviewed-by: Brian Foster <bfoster@redhat.com>
> > > >    Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > >    Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > >    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > >
> > >
>
