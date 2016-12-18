Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:52650 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753569AbcLRWS5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2016 17:18:57 -0500
Date: Sun, 18 Dec 2016 22:18:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 04/12] splice: lift pipe_lock out of splice_to_pipe()
Message-ID: <20161218221853.GA1555@ZenIV.linux.org.uk>
References: <20160923190326.GB2356@ZenIV.linux.org.uk>
 <CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
 <20160923201025.GJ2356@ZenIV.linux.org.uk>
 <CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
 <20160924035951.GN2356@ZenIV.linux.org.uk>
 <87shpmxrey.fsf@linux-m68k.org>
 <CA+55aFyJGz6njFjKe8O0+XRJhCrPHA_wnEuLbGSGypJ0G2-vpQ@mail.gmail.com>
 <20161218201207.GY1555@ZenIV.linux.org.uk>
 <20161218203003.GZ1555@ZenIV.linux.org.uk>
 <CA+55aFzPE6FbwX2NuiMkz9G+FzAoiNeb8jOSWwSoX3O7+KuH4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzPE6FbwX2NuiMkz9G+FzAoiNeb8jOSWwSoX3O7+KuH4Q@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>, Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Sun, Dec 18, 2016 at 02:10:54PM -0800, Linus Torvalds wrote:
> On Sun, Dec 18, 2016 at 12:30 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > OK, I see what's going on - it's wait_for_space() lifted past the checks
> > for lack of readers.  The fix, AFAICS, is simply
> 
> Ugh. Does it have to be duplicated?
> 
> How about just making the wait_for_space() loop be a for-loop, and writing it as
> 
>    for (;;) {
>         if (unlikely(!pipe->readers)) {
>                 send_sig(SIGPIPE, current, 0);
>                 return -EPIPE;
>         }
>         if (pipe->nrbufs == pipe->buffers)

ITYM "!="...
