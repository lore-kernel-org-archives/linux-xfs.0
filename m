Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:57438 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751021AbcJCDeQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2016 23:34:16 -0400
Date: Mon, 3 Oct 2016 04:34:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [RFC] O_DIRECT vs EFAULT (was Re: [PATCH 10/12] new iov_iter
 flavour: pipe-backed)
Message-ID: <20161003033409.GT19539@ZenIV.linux.org.uk>
References: <20160917190023.GA8039@ZenIV.linux.org.uk>
 <20160923190032.GA25771@ZenIV.linux.org.uk>
 <20160923190326.GB2356@ZenIV.linux.org.uk>
 <CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
 <20160923201025.GJ2356@ZenIV.linux.org.uk>
 <CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
 <20160924040117.GP2356@ZenIV.linux.org.uk>
 <CAELBmZDpm635PcTPQfnpLGs2P4bfT6JU+DEuFu9pBut=uzOLHw@mail.gmail.com>
 <20160929225003.GQ19539@ZenIV.linux.org.uk>
 <CAJfpegs9He0bWX3VWkr2EY-7X3-pAhNAUT=mQad-zxtWkQt_SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegs9He0bWX3VWkr2EY-7X3-pAhNAUT=mQad-zxtWkQt_SQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Sep 30, 2016 at 09:30:21AM +0200, Miklos Szeredi wrote:
> On Fri, Sep 30, 2016 at 12:50 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Thu, Sep 29, 2016 at 10:53:55PM +0200, Miklos Szeredi wrote:
> >
> >> The EFAULT logic seems to be missing across the board.  And callers
> >> don't expect a zero return value.  Most will loop indefinitely.
> >
> > Nope.  copy_page_to_iter() *never* returns -EFAULT.  Including the iovec
> > one - check copy_page_to_iter_iovec().  Any caller that does not expect
> > a zero return value from that primitive is a bug, triggerable as soon as
> > you feed it an iovec with NULL ->iov_base.
> 
> Right.
> 
> I was actually looking at iov_iter_get_pages() callers...

FWIW, that's interesting - O_DIRECT readv()/writev() reacts to fault anywhere
as "nothing done, return -EFAULT now", rather than a short read/write.
Despite that some IO is actually done.  Note, BTW, that we are not even
consistent between the filesystems - local block ones do IO and give -EFAULT,
while NFS, Lustre and FUSE do short read/write, reporting -EFAULT only upon
shortening to nothing.  So does ceph, except that shortening might be for
more than one page.

Considering how weak POSIX is in that area, we are probably not violating
anything, but... it would be more convenient if we treated those as
short read/write, same way for all filesystems.

Linus, do you have any objections against such behaviour change?  AFAICS,
all it takes is this:

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 7c3ce73..3a8ebda 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -246,6 +246,8 @@ static ssize_t dio_complete(struct dio *dio, ssize_t ret, bool is_async)
 		if ((dio->op == REQ_OP_READ) &&
 		    ((offset + transferred) > dio->i_size))
 			transferred = dio->i_size - offset;
+		if (ret == -EFAULT)
+			ret = 0;
 	}
 
 	if (ret == 0)
