Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:35134 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753752AbcLRWK4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2016 17:10:56 -0500
MIME-Version: 1.0
In-Reply-To: <20161218203003.GZ1555@ZenIV.linux.org.uk>
References: <20160917190023.GA8039@ZenIV.linux.org.uk> <20160923190032.GA25771@ZenIV.linux.org.uk>
 <20160923190326.GB2356@ZenIV.linux.org.uk> <CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
 <20160923201025.GJ2356@ZenIV.linux.org.uk> <CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
 <20160924035951.GN2356@ZenIV.linux.org.uk> <87shpmxrey.fsf@linux-m68k.org>
 <CA+55aFyJGz6njFjKe8O0+XRJhCrPHA_wnEuLbGSGypJ0G2-vpQ@mail.gmail.com>
 <20161218201207.GY1555@ZenIV.linux.org.uk> <20161218203003.GZ1555@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 18 Dec 2016 14:10:54 -0800
Message-ID: <CA+55aFzPE6FbwX2NuiMkz9G+FzAoiNeb8jOSWwSoX3O7+KuH4Q@mail.gmail.com>
Subject: Re: [PATCH 04/12] splice: lift pipe_lock out of splice_to_pipe()
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Schwab <schwab@linux-m68k.org>, Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Sun, Dec 18, 2016 at 12:30 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> OK, I see what's going on - it's wait_for_space() lifted past the checks
> for lack of readers.  The fix, AFAICS, is simply

Ugh. Does it have to be duplicated?

How about just making the wait_for_space() loop be a for-loop, and writing it as

   for (;;) {
        if (unlikely(!pipe->readers)) {
                send_sig(SIGPIPE, current, 0);
                return -EPIPE;
        }
        if (pipe->nrbufs == pipe->buffers)
                return 0;
        if (flags & SPLICE_F_NONBLOCK)
                return -EAGAIN;
        if (signal_pending(current))
                return -ERESTARTSYS;
        pipe->waiting_writers++;
        pipe_wait(pipe);
        pipe->waiting_writers--;
   }

and just having it once?

Regardless - Andreas, can you verify that that fixes your issues? I'm
assuming you had some real load that made you notice this, not just he
dummy example..

            Linus
