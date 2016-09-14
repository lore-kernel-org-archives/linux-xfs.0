Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36048 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752960AbcINDuA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Sep 2016 23:50:00 -0400
Received: by mail-oi0-f67.google.com with SMTP id o7so205230oif.3
        for <linux-xfs@vger.kernel.org>; Tue, 13 Sep 2016 20:49:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160914031648.GB2356@ZenIV.linux.org.uk>
References: <CA+55aFzg+Q0DzFNBR9TeL13_yfrfFwHu9OrZe--Zpje0EeN4Cw@mail.gmail.com>
 <20160908213835.GY30056@dastard> <20160908235521.GL2356@ZenIV.linux.org.uk>
 <20160909015324.GD30056@dastard> <CA+55aFzohsUXj_3BeFNr2t50Wm=G+7toRDEz=Tk7VJqP3n1hXQ@mail.gmail.com>
 <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <20160909023452.GO2356@ZenIV.linux.org.uk> <CA+55aFwHQMjO4-vtfB9-ytc=o+DRo-HXVGckvXLboUxgpwb7_g@mail.gmail.com>
 <20160909221945.GQ2356@ZenIV.linux.org.uk> <CA+55aFzTOOB6oEVaaGD0N7Uznk-W9+ULPwzsxS_L_oZqGVSeLA@mail.gmail.com>
 <20160914031648.GB2356@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 13 Sep 2016 20:49:58 -0700
Message-ID: <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
Subject: Re: xfs_file_splice_read: possible circular locking dependency detected
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>

On Tue, Sep 13, 2016 at 8:16 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
>> So feel free to try maxing out using only a small handful of
>> pipe_buffer entries. Returning partial IO from splice() is fine.
>
>         Are you sure that nobody's growing the output pipe buffer before
> doing splice() into it as a way to reduce the amount of iterations?

Do we care?

There's a lot of people who use large buffers. That doesn't
necessarily mean that it is the right thing to do. A small buffer that
we can allocate on-stack might well be better even if it causes more
iterations.

I'd also like to simplify the splice code if at all possible.
Particularly as there really aren't necessarily all that many actual
users of it. So if we can say "screw that" and just allocate a small
buffer on stack, and people end up iterating a bit more, so what? The
point of splice is to avoid the data copies and VM games, not to make
big buffers.

             Linus
