Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:36928 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755046AbcIQIUM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Sep 2016 04:20:12 -0400
Date: Sat, 17 Sep 2016 09:20:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
 detected
Message-ID: <20160917082007.GA6489@ZenIV.linux.org.uk>
References: <20160909015324.GD30056@dastard>
 <CA+55aFzohsUXj_3BeFNr2t50Wm=G+7toRDEz=Tk7VJqP3n1hXQ@mail.gmail.com>
 <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <20160909023452.GO2356@ZenIV.linux.org.uk>
 <CA+55aFwHQMjO4-vtfB9-ytc=o+DRo-HXVGckvXLboUxgpwb7_g@mail.gmail.com>
 <20160909221945.GQ2356@ZenIV.linux.org.uk>
 <CA+55aFzTOOB6oEVaaGD0N7Uznk-W9+ULPwzsxS_L_oZqGVSeLA@mail.gmail.com>
 <20160914031648.GB2356@ZenIV.linux.org.uk>
 <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
 <20160914042559.GC2356@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160914042559.GC2356@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>

On Wed, Sep 14, 2016 at 05:25:59AM +0100, Al Viro wrote:
> On Tue, Sep 13, 2016 at 08:49:58PM -0700, Linus Torvalds wrote:
>  
> > I'd also like to simplify the splice code if at all possible.
> 
> Then pipe_buffer it is; it will take a bit of surgery, but I'd expect
> the end result to be much simpler.  OK, so splice_pipe_desc switches
> from the pages/partial_pages/ops/spd_release to pipe_bufs, and I'm
> actually tempted to replace nr_pages with "the rest of ->pipe_bufs[] has
> NULL ->page".  Then it becomes simply
> struct splice_pipe_desc {
> 	struct pipe_buffer *bufs;
> 	int nbufs;
> 	unsigned flags;
> }, perhaps with struct pipe_buffer _bufs[INLINE_SPLICE_BUFS]; in the end.
> struct partial_page simply dies...

Actually, we can do even better, and kill the sodding splice_pipe_desc
entirely, along with skb_splice_bits() callback.

1) make splice_to_pipe() return on pipe overflow, flags be damned.  And
lift pipe_lock()/looping/waking the readers up into callers.  Basically,
what you've suggested earlier in the thread.  There are 2 kinds of callers -
vmsplice_to_pipe() and assorted ->splice_read(), called from do_splice_to().
pipe_lock and loop is lifted into vmsplice_to_pipe() and into do_splice();
another caller of do_splice_to() already has a loop *and* couldn't wait
on the pipe anyway - it uses an internal one.

2) fuse_dev_splice_read() checks the amount of space in the pipe and
either buggers off or calls splice_to_pipe().

3) since the pipe is locked, skb_splice_bits() callbacks don't need to
unlock/relock any socket locks.  All those callbacks are simply
splice_to_pipe() and can be replaced with direct call of that sucker.

4) since the pipe is locked, there's no point feeding the bits in one go;
we can as well send them one by one.  That kills splice_to_pipe(),
splice_pipe_desc and these on-stack arrays, along with the questions about
their size.

5) that iov_iter flavour is backed by pipe.  {__,}generic_file_splice_read()
is gone - we simply set an iov_iter over our locked pipe and pass it to
->read_iter().  That serves as ->splice_read() where generic_file_splice_read()
used to be used, as well as nfs/ocfs2/gfs2/shmem instances.
