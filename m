Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:52150 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965627AbcIWUK2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2016 16:10:28 -0400
Date: Fri, 23 Sep 2016 21:10:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 04/11] splice: lift pipe_lock out of splice_to_pipe()
Message-ID: <20160923201025.GJ2356@ZenIV.linux.org.uk>
References: <20160909221945.GQ2356@ZenIV.linux.org.uk>
 <CA+55aFzTOOB6oEVaaGD0N7Uznk-W9+ULPwzsxS_L_oZqGVSeLA@mail.gmail.com>
 <20160914031648.GB2356@ZenIV.linux.org.uk>
 <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
 <20160914042559.GC2356@ZenIV.linux.org.uk>
 <20160917082007.GA6489@ZenIV.linux.org.uk>
 <20160917190023.GA8039@ZenIV.linux.org.uk>
 <20160923190032.GA25771@ZenIV.linux.org.uk>
 <20160923190326.GB2356@ZenIV.linux.org.uk>
 <CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Sep 23, 2016 at 12:45:53PM -0700, Linus Torvalds wrote:

> I was like "oh, I'm sure this is some temporary hack, it will be gone
> by the end of the series".
> 
> It wasn't gone by the end.
> 
> There's two copies of that pattern, and at the very least it needs a
> big comment about what this pattern does and why.

The thing is, I'm not sure what to do with it; it was brought by the LTP
vmsplice test, which asks to feed 128Kb into a pipe.  With the caller
itself on the other end of that pipe, SPLICE_F_NONBLOCK *not* given and
the pipe capacity being 64Kb.  Unfortunately, "quietly truncate the
length down to 64Kb" does *not* suffice - the damn thing starts not at
the page boundary, so we only copy about 62Kb until hitting the pipe
overflow (the pipe is initially empty).  The reason why it doesn't go
to sleep indefinitely on the mainline kernel is that mainline collects
up to page->buffers *pages*, before feeding them into the pipe.  And these
~62Kb are just that.  Note that had there been anything already in the
pipe, the same call would've gone to sleep (and in the end transferred the
same ~62Kb worth of data).

All of that is completely undocumented in vmsplice(2) (or anywhere else that
I'd been able to find) ;-/

OTOH, considering the quality of documentation, I'm somewhat tempted to go
for "sleep only if it had been completely full when we entered; once there's
some space feed as much as fits and be done with that".  OTTH, I'm not sure
that no userland cr^Hode will manage to be hurt by that variant...
