Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35448 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751219AbcIJCGb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Sep 2016 22:06:31 -0400
Received: by mail-oi0-f67.google.com with SMTP id 2so12867293oif.2
        for <linux-xfs@vger.kernel.org>; Fri, 09 Sep 2016 19:06:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160909221945.GQ2356@ZenIV.linux.org.uk>
References: <1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
 <20160908175632.GH2356@ZenIV.linux.org.uk> <CA+55aFzg+Q0DzFNBR9TeL13_yfrfFwHu9OrZe--Zpje0EeN4Cw@mail.gmail.com>
 <20160908213835.GY30056@dastard> <20160908235521.GL2356@ZenIV.linux.org.uk>
 <20160909015324.GD30056@dastard> <CA+55aFzohsUXj_3BeFNr2t50Wm=G+7toRDEz=Tk7VJqP3n1hXQ@mail.gmail.com>
 <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <20160909023452.GO2356@ZenIV.linux.org.uk> <CA+55aFwHQMjO4-vtfB9-ytc=o+DRo-HXVGckvXLboUxgpwb7_g@mail.gmail.com>
 <20160909221945.GQ2356@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 9 Sep 2016 19:06:29 -0700
Message-ID: <CA+55aFzTOOB6oEVaaGD0N7Uznk-W9+ULPwzsxS_L_oZqGVSeLA@mail.gmail.com>
Subject: Re: xfs_file_splice_read: possible circular locking dependency detected
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Sep 9, 2016 at 3:19 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Cooking it...  The thing I really hate about the use of pipe_buffer is that
> we want to keep the "use on-stack array for default pipe size" trick, and
> pipe_buffer is fatter than I'd like.  Instead of pointer + two numbers +
> something to indicate whether it's picked from page cache or something we'd
> allocated we get get pointer + int + int + pointer + int + long, which turns
> into 5 words on 64bit.  With 16-element array of those on stack frame, it's
> not nice - more than half kilobyte of stack space with ->read_iter() yet to
> be called...  bvec would be better (60% savings boils down to 384 bytes
> shaved off that thing), but we'd need to play games with encoding the "is
> it page cache or not" bit somewhere in it.

No, please don't play games like that.

I think you'd be better off with just a really small on-stack case
(like maybe 2-3 entries), and just allocate anything bigger
dynamically. Or you could even see how bad it is if you just
force-limit it to max 4 entries or something like that and just do
partial writes.

>From when I looked at things (admittedly a *long* time ago), the
buffer sizes for things like read/write system calls were *very*
skewed.

There's a lot of small stuff, then there is the stuff that actually
honors st.st_blksize (normally one page), and then there is the big
buffers stuff.

And the thing is, the big buffers are almost never worth it. It's
often better to have a tight loop over smaller data than bouncing lots
of data into buffers and then out of buffers.

So I suspect all the "let's do many pages in one go" stuff is actually
not worth it. Especially since the pipes will basically force a wait
event when the pipe buffers fill up anyway.

So feel free to try maxing out using only a small handful of
pipe_buffer entries. Returning partial IO from splice() is fine.

                   Linus
