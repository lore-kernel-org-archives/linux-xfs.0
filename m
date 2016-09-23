Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36556 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034236AbcIWTpz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2016 15:45:55 -0400
MIME-Version: 1.0
In-Reply-To: <20160923190326.GB2356@ZenIV.linux.org.uk>
References: <20160909023452.GO2356@ZenIV.linux.org.uk> <CA+55aFwHQMjO4-vtfB9-ytc=o+DRo-HXVGckvXLboUxgpwb7_g@mail.gmail.com>
 <20160909221945.GQ2356@ZenIV.linux.org.uk> <CA+55aFzTOOB6oEVaaGD0N7Uznk-W9+ULPwzsxS_L_oZqGVSeLA@mail.gmail.com>
 <20160914031648.GB2356@ZenIV.linux.org.uk> <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
 <20160914042559.GC2356@ZenIV.linux.org.uk> <20160917082007.GA6489@ZenIV.linux.org.uk>
 <20160917190023.GA8039@ZenIV.linux.org.uk> <20160923190032.GA25771@ZenIV.linux.org.uk>
 <20160923190326.GB2356@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 23 Sep 2016 12:45:53 -0700
Message-ID: <CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
Subject: Re: [PATCH 04/11] splice: lift pipe_lock out of splice_to_pipe()
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Sep 23, 2016 at 12:03 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> @@ -1421,8 +1406,25 @@ static long do_splice(struct file *in, loff_t __user *off_in,
> +               ret = 0;
> +               pipe_lock(opipe);
> +               bogus_count = opipe->buffers;
> +               do {
> +                       bogus_count += opipe->nrbufs;
> +                       ret = do_splice_to(in, &offset, opipe, len, flags);
> +                       if (ret > 0) {
> +                               total += ret;
> +                               len -= ret;
> +                       }
> +                       bogus_count -= opipe->nrbufs;
> +                       if (bogus_count <= 0)
> +                               break;

I was like "oh, I'm sure this is some temporary hack, it will be gone
by the end of the series".

It wasn't gone by the end.

There's two copies of that pattern, and at the very least it needs a
big comment about what this pattern does and why.

But other than that reaction, I didn't get any hives from this. I
didn't *test* it, only looking at patches, but no red flags I could
notice.

               Linus
