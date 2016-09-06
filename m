Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 340697CA7
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 18:59:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AA612AC005
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 16:59:22 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	lOZ5fvAwTezyu1Bq for <xfs@oss.sgi.com>;
	Tue, 06 Sep 2016 16:59:19 -0700 (PDT)
Date: Wed, 7 Sep 2016 09:59:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
	detected
Message-ID: <20160906235917.GO30056@dastard>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
	<1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
	<20160903003919.GI30056@dastard>
	<CA+55aFy17iuUYRSLO=e1e+W5oW8GRYy93myk816UjRgEFxQDOw@mail.gmail.com>
	<20160903014514.GB2356@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160903014514.GB2356@ZenIV.linux.org.uk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, CAI Qian <caiqian@redhat.com>, xfs@oss.sgi.com

On Sat, Sep 03, 2016 at 02:45:14AM +0100, Al Viro wrote:
> On Fri, Sep 02, 2016 at 05:57:04PM -0700, Linus Torvalds wrote:
> > On Fri, Sep 2, 2016 at 5:39 PM, Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > Fundamentally a splice infrastructure problem.
> > 
> > Yeah, I don't really like how we handle the pipe lock.
> > 
> > It *might* be possible to instead just increment the reference
> > counters as we build a kvec[] array of them, and simply do teh write
> > without holding the pipe lock at all.
> > 
> > That has other problems, ie concurrect spices from the same pipe would
> > possibly write the same data multiple times, though.
> > 
> > But yes, the fundamental problem is how splice wants to take the pipe
> > lock both early and late. Very annoying.
> 
> We could, in principle, add another flavour of iov_iter, with bvec
> array attached to it with copy_page_to_iter() sticking an extra ref to that
> page into array.  Then, under pipe lock, feed that thing to ->read_iter()
> and do an equivalent of splice_to_pipe() that would take bvec array instead
> of struct page */struct partial_page arrays.

Not sure I quite follow - where do the pages come from? Do we
allocate new pages that get put into the bvec, then run the read
which copies data from the page cache page into them, then hand
those pages in the bvec to the pipe?

ISTR this read->splice_to_pipe path was once supposed to be a
zero-copy path - doesn't this make zero-copy impossible? Or was the
zero-copy splice read path done through some other path I've
forgotten about?

> Hell, we could even have copy_to_iter() for these puppies allocate a page,
> stick it into the next bvec and copy into it.  Especially if we have those
> bvec zeroed, with copy_page_to_iter() leaving ->bvec pointing to the next
> (unused) bvec and copy_to_iter() doing that only when a page had been
> completely filled.  I.e.

This has the same "data copy in the splice read path" as the above
interface. However, I suspect that this interface could actually be
used for zero copy (by stealing pages from the page cache rather
than allocating new pages and copying), so it may be a better way to
proceed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
