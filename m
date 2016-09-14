Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:42762 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750728AbcINE0G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Sep 2016 00:26:06 -0400
Date: Wed, 14 Sep 2016 05:26:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
 detected
Message-ID: <20160914042559.GC2356@ZenIV.linux.org.uk>
References: <20160908235521.GL2356@ZenIV.linux.org.uk>
 <20160909015324.GD30056@dastard>
 <CA+55aFzohsUXj_3BeFNr2t50Wm=G+7toRDEz=Tk7VJqP3n1hXQ@mail.gmail.com>
 <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <20160909023452.GO2356@ZenIV.linux.org.uk>
 <CA+55aFwHQMjO4-vtfB9-ytc=o+DRo-HXVGckvXLboUxgpwb7_g@mail.gmail.com>
 <20160909221945.GQ2356@ZenIV.linux.org.uk>
 <CA+55aFzTOOB6oEVaaGD0N7Uznk-W9+ULPwzsxS_L_oZqGVSeLA@mail.gmail.com>
 <20160914031648.GB2356@ZenIV.linux.org.uk>
 <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>

On Tue, Sep 13, 2016 at 08:49:58PM -0700, Linus Torvalds wrote:
 
> I'd also like to simplify the splice code if at all possible.

Then pipe_buffer it is; it will take a bit of surgery, but I'd expect
the end result to be much simpler.  OK, so splice_pipe_desc switches
from the pages/partial_pages/ops/spd_release to pipe_bufs, and I'm
actually tempted to replace nr_pages with "the rest of ->pipe_bufs[] has
NULL ->page".  Then it becomes simply
struct splice_pipe_desc {
	struct pipe_buffer *bufs;
	int nbufs;
	unsigned flags;
}, perhaps with struct pipe_buffer _bufs[INLINE_SPLICE_BUFS]; in the end.
struct partial_page simply dies...

Next question: what to do with sanitizing flags in splice(2)/vmsplice(2)/tee(2)?
Right now we accept anything, and quietly ignore everything outside of lower
4 bits.  Should we start masking everything else out and/or warning about
anything unexpected?

	What I definitely want for splice_to_pipe() is an additional flag for
"fail unless there's enough space to copy everything".  Having fuse open-code
splice_to_pipe() with all its guts is just plain wrong.  I'm not saying that
it should be possible to set in splice(2) arguments; it's obviously an ABI
breakage, since currently we ignore all unknown bits.  The question is whether
we mask the unknown bits quietly; doing that with yelling might allow to
make them eventually available.
