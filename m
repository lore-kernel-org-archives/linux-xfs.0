Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35795 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034487AbcIWUgN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2016 16:36:13 -0400
MIME-Version: 1.0
In-Reply-To: <20160923201025.GJ2356@ZenIV.linux.org.uk>
References: <20160909221945.GQ2356@ZenIV.linux.org.uk> <CA+55aFzTOOB6oEVaaGD0N7Uznk-W9+ULPwzsxS_L_oZqGVSeLA@mail.gmail.com>
 <20160914031648.GB2356@ZenIV.linux.org.uk> <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
 <20160914042559.GC2356@ZenIV.linux.org.uk> <20160917082007.GA6489@ZenIV.linux.org.uk>
 <20160917190023.GA8039@ZenIV.linux.org.uk> <20160923190032.GA25771@ZenIV.linux.org.uk>
 <20160923190326.GB2356@ZenIV.linux.org.uk> <CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
 <20160923201025.GJ2356@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 23 Sep 2016 13:36:12 -0700
Message-ID: <CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
Subject: Re: [PATCH 04/11] splice: lift pipe_lock out of splice_to_pipe()
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Sep 23, 2016 at 1:10 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> OTOH, considering the quality of documentation, I'm somewhat tempted to go
> for "sleep only if it had been completely full when we entered; once there's
> some space feed as much as fits and be done with that".  OTTH, I'm not sure
> that no userland cr^Hode will manage to be hurt by that variant...

Let's just try it.

If that then doesn't work, we can introduce your odd code (with a
*big* comment). Ok?

               Linus
