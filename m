Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:35210 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750942AbcINEBJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Sep 2016 00:01:09 -0400
Received: by mail-oi0-f41.google.com with SMTP id w11so3263551oia.2
        for <linux-xfs@vger.kernel.org>; Tue, 13 Sep 2016 21:01:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160914133925.2fba4629@roar.ozlabs.ibm.com>
References: <CA+55aFzg+Q0DzFNBR9TeL13_yfrfFwHu9OrZe--Zpje0EeN4Cw@mail.gmail.com>
 <20160908213835.GY30056@dastard> <20160908235521.GL2356@ZenIV.linux.org.uk>
 <20160909015324.GD30056@dastard> <CA+55aFzohsUXj_3BeFNr2t50Wm=G+7toRDEz=Tk7VJqP3n1hXQ@mail.gmail.com>
 <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <20160909023452.GO2356@ZenIV.linux.org.uk> <CA+55aFwHQMjO4-vtfB9-ytc=o+DRo-HXVGckvXLboUxgpwb7_g@mail.gmail.com>
 <20160909221945.GQ2356@ZenIV.linux.org.uk> <CA+55aFzTOOB6oEVaaGD0N7Uznk-W9+ULPwzsxS_L_oZqGVSeLA@mail.gmail.com>
 <20160914031648.GB2356@ZenIV.linux.org.uk> <20160914133925.2fba4629@roar.ozlabs.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 13 Sep 2016 21:01:07 -0700
Message-ID: <CA+55aFyB6zORxo-VYBP=0geXT0D_5nGzTJTJQXbVZ2=wcYVYEA@mail.gmail.com>
Subject: Re: xfs_file_splice_read: possible circular locking dependency detected
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>

On Tue, Sep 13, 2016 at 8:39 PM, Nicholas Piggin <npiggin@gmail.com> wrote:
>
> But even for those, at 16 entries, the bulk of the cost *should* be hitting
> struct page cachelines and refcounting. The rest should mostly stay in cache.

Yes. And those costs will be exactly the same whether we do 16 entries
at a time or 4 loops of 4 entries.

There's something to be said for small temp buffers. They often have
better cache behavior thanks to re-use than having larger arrays.

But I still think that the biggest win could be from just trying to
cut down on code, if we can just say "we'll limit splice to N entries"
(where "N" is small enough that we really can do everything in a
simple stack allocation - I suspect 16 is already too big, and we
really should look at 4 or 8).

And if we actually get a report of a performance regression, we'd at
least hear who actually *uses* splice and notices.

I'm (sadly) still not at all convinced that "splice()" was ever a good
idea. I think it was a clever idea, and it is definitely much more
powerful conceptually than sendfile(), but I also suspect that it's
simply not used enough to be really worth the pain.

You can get great benchmark numbers with it. But whether it actually
matters in real life? I really don't know. But if we screw it up, and
make the buffers too small, and people actually complain and tell us
about what they are doing, that in itself would be a good datapoint.

So I wouldn't be too worried about just trying things out. We
certainly don't want to *break* anything, but at the same time I
really don't think we should be too nervous about it either.

Which is why I'd be more than happy to say "Just try limiting things
to a pretty small buffer and see if anybody even notices!"

                   Linus
