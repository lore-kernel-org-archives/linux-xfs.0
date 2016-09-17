Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:43062 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754105AbcIQTA1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Sep 2016 15:00:27 -0400
Date: Sat, 17 Sep 2016 20:00:23 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
 detected
Message-ID: <20160917190023.GA8039@ZenIV.linux.org.uk>
References: <CA+55aFzohsUXj_3BeFNr2t50Wm=G+7toRDEz=Tk7VJqP3n1hXQ@mail.gmail.com>
 <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <20160909023452.GO2356@ZenIV.linux.org.uk>
 <CA+55aFwHQMjO4-vtfB9-ytc=o+DRo-HXVGckvXLboUxgpwb7_g@mail.gmail.com>
 <20160909221945.GQ2356@ZenIV.linux.org.uk>
 <CA+55aFzTOOB6oEVaaGD0N7Uznk-W9+ULPwzsxS_L_oZqGVSeLA@mail.gmail.com>
 <20160914031648.GB2356@ZenIV.linux.org.uk>
 <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
 <20160914042559.GC2356@ZenIV.linux.org.uk>
 <20160917082007.GA6489@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160917082007.GA6489@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>

On Sat, Sep 17, 2016 at 09:20:07AM +0100, Al Viro wrote:

> 5) that iov_iter flavour is backed by pipe.  {__,}generic_file_splice_read()
> is gone - we simply set an iov_iter over our locked pipe and pass it to
> ->read_iter().  That serves as ->splice_read() where generic_file_splice_read()
> used to be used, as well as nfs/ocfs2/gfs2/shmem instances.

6) The same happens to coda and lustre instances, taking a bunch of crud out
in case of lustre (IO_SPLICE handling parallel to IO_NORMAL and
->vui_io_subtype in general).  Moreover, skb_splice_bits() becomes very
similar to skb_copy_datagram_iter(), possibly allowing to replace at least
AF_UNIX ->splice_read() with the same generic ->read_iter()-based one - or
doing the same to _all_ socket ones.  Even more interesting is that
fuse_dev_splice_read() just might become replacable with that, at the price
of some massage (and simplifications) of fuse_copy_page().  If _that_ works
out, we are in a situation where that thing is universal for everything
that has ->read_iter() in the first place.  Most of the stuff that has
only ->read() uses default_file_splice_read(); the only irregular instances
left are kernel/relay.c and kernel/trace/trace.c ones.  Incidentally, these
irregulars are precisely the ones that make use of buf->private.
