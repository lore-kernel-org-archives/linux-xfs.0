Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:33948 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbdIHBEp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Sep 2017 21:04:45 -0400
Date: Fri, 8 Sep 2017 02:04:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: iov_iter_pipe warning.
Message-ID: <20170908010441.GZ5426@ZenIV.linux.org.uk>
References: <20170421175430.GT29622@ZenIV.linux.org.uk>
 <20170428152955.mafs3f22srmm34aw@codemonkey.org.uk>
 <20170428164313.GK29622@ZenIV.linux.org.uk>
 <20170428165024.ofyl2atpjwohekqa@codemonkey.org.uk>
 <20170428172024.GL29622@ZenIV.linux.org.uk>
 <20170807201818.kykqzexce6ap6aik@codemonkey.org.uk>
 <20170828203130.y6dq5fqovev6wmrv@codemonkey.org.uk>
 <20170829042542.GO4757@magnolia>
 <20170906200337.b5wj3gpfebliindw@codemonkey.org.uk>
 <20170906234617.GW17782@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170906234617.GW17782@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Jones <davej@codemonkey.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org

On Thu, Sep 07, 2017 at 09:46:17AM +1000, Dave Chinner wrote:
> On Wed, Sep 06, 2017 at 04:03:37PM -0400, Dave Jones wrote:
> > On Mon, Aug 28, 2017 at 09:25:42PM -0700, Darrick J. Wong wrote:
> >  > On Mon, Aug 28, 2017 at 04:31:30PM -0400, Dave Jones wrote:
> >  > > I'm still trying to narrow down an exact reproducer, but it seems having
> >  > > trinity do a combination of sendfile & writev, with pipes and regular
> >  > > files as fd's is the best repro.
> >  > > 
> >  > > Is this a real problem, or am I chasing ghosts ?  That it doesn't happen
> >  > > on ext4 or btrfs is making me wonder...
> >  > 
> >  > <shrug> I haven't heard of any problems w/ directio xfs lately, but OTOH
> >  > I think it's the only filesystem that uses iomap_dio_rw, which would
> >  > explain why ext4/btrfs don't have this problem.
> > 
> > Another warning, from likely the same root cause.
> > 
> > WARNING: CPU: 3 PID: 572 at lib/iov_iter.c:962 iov_iter_pipe+0xe2/0xf0
> 
> 	WARN_ON(pipe->nrbufs == pipe->buffers);
> 
>  *      @nrbufs: the number of non-empty pipe buffers in this pipe
>  *      @buffers: total number of buffers (should be a power of 2)
> 
> So that's warning that the pipe buffer is already full before we
> try to read from the filesystem?
> 
> That doesn't seem like an XFS problem - it indicates the pipe we are
> filling in generic_file_splice_read() is not being emptied by
> whatever we are splicing the file data to....

Or that XFS in some conditions shoves into pipe more than it reports,
so not all of that gets emptied, filling the sucker up after sufficient
amount of iterations...

There's at least one suspicious place in iomap_dio_actor() -
                if (!(dio->flags & IOMAP_DIO_WRITE)) {
                        iov_iter_zero(length, dio->submit.iter);
                        dio->size += length;
                        return length;
                }
which assumes that iov_iter_zero() always succeeds.  That's very
much _not_ true - neither for iovec-backed, not for pipe-backed.
Orangefs read_one_page() is fine (it calls that sucker for bvec-backed
iov_iter it's just created), but iomap_dio_actor() is not.

I'm not saying that it will suffice, but we definitely need this:

diff --git a/fs/iomap.c b/fs/iomap.c
index 269b24a01f32..4a671263475f 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -843,7 +843,7 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 		/*FALLTHRU*/
 	case IOMAP_UNWRITTEN:
 		if (!(dio->flags & IOMAP_DIO_WRITE)) {
-			iov_iter_zero(length, dio->submit.iter);
+			length = iov_iter_zero(length, dio->submit.iter);
 			dio->size += length;
 			return length;
 		}
