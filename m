Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:32807 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752848AbcIQUPb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Sep 2016 16:15:31 -0400
Received: by mail-oi0-f65.google.com with SMTP id w11so9373140oia.0
        for <linux-xfs@vger.kernel.org>; Sat, 17 Sep 2016 13:15:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160917190023.GA8039@ZenIV.linux.org.uk>
References: <CA+55aFzohsUXj_3BeFNr2t50Wm=G+7toRDEz=Tk7VJqP3n1hXQ@mail.gmail.com>
 <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <20160909023452.GO2356@ZenIV.linux.org.uk> <CA+55aFwHQMjO4-vtfB9-ytc=o+DRo-HXVGckvXLboUxgpwb7_g@mail.gmail.com>
 <20160909221945.GQ2356@ZenIV.linux.org.uk> <CA+55aFzTOOB6oEVaaGD0N7Uznk-W9+ULPwzsxS_L_oZqGVSeLA@mail.gmail.com>
 <20160914031648.GB2356@ZenIV.linux.org.uk> <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
 <20160914042559.GC2356@ZenIV.linux.org.uk> <20160917082007.GA6489@ZenIV.linux.org.uk>
 <20160917190023.GA8039@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 17 Sep 2016 13:15:29 -0700
Message-ID: <CA+55aFyxqeA3fqyM6gihCB0N42Lw0rgBhUYSnqU8AGVV51DTsw@mail.gmail.com>
Subject: Re: xfs_file_splice_read: possible circular locking dependency detected
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>

On Sat, Sep 17, 2016 at 12:00 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> [ edited out steps 1-6]

So that all sounds very much like a big improvement. Not that I think
removing splice_pipe_desc is such a big deal per se, but on the whole
the less the actual low-level iterator does, and the more we do at a
higher level, the happier I am. The fact that you say you can remove
it does make it sound like you got rid of the right amount of
complexity, though. The reason that whole thing exists is exactly
because otherwise the splice callbacks would look too damn hair for
words.

If we get rid of all the SPLICE_F_NONBLOCK, sighandling, pipe_wait()
and fasync crap at the low level, I'll already be much happier. I hate
how complex that code is, and how the filesystems call into it as a
helper etc. Doing just the iterator in the deep corners of splice
sounds like absolutely the right thing to do.

So reading your outline I say "wonderful".

Of course, maybe I'll change my mind when I actually see your patches ;^p

             Linus
