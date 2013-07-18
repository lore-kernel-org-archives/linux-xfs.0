Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E1D187F3F
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 16:16:36 -0500 (CDT)
Date: Thu, 18 Jul 2013 16:16:32 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: splice vs execve lockdep trace.
Message-ID: <20130718211632.GD3572@sgi.com>
References: <CA+55aFzTBUKStdZu1GhKoiYc2knybhiaUFr2By98QYew_STE=A@mail.gmail.com>
	<20130716204335.GH11674@dastard>
	<CA+55aFwHMQd-VDeTDh-gm3jyj+5+FSoAHOeU47mwU-mKtEj9RQ@mail.gmail.com>
	<20130717040616.GI11674@dastard>
	<CA+55aFz5xw9Qi9Q6mwoCSud5eQh5u-QZ-xrY+TqgZPoKOgn6ew@mail.gmail.com>
	<20130717055103.GK11674@dastard>
	<CA+55aFxdqzMY5VJoYaLmL=+=f2s1cbHHV-TjC3=taXpF-xov1w@mail.gmail.com>
	<20130717234049.GC3572@sgi.com>
	<CA+55aFy-8QH4bTW7hU=381tuEWgHC=PUM6WP3qn-ooge=7M0QQ@mail.gmail.com>
	<20130718034203.GO11674@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130718034203.GO11674@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>, xfs@oss.sgi.com, Linus Torvalds <torvalds@linux-foundation.org>

Dave,

On Thu, Jul 18, 2013 at 01:42:03PM +1000, Dave Chinner wrote:
> On Wed, Jul 17, 2013 at 05:17:36PM -0700, Linus Torvalds wrote:
> > On Wed, Jul 17, 2013 at 4:40 PM, Ben Myers <bpm@sgi.com> wrote:
> > >>
> > >> We're still talking at cross purposes then.
> > >>
> > >> How the hell do you handle mmap() and page faulting?
> > >
> > > __xfs_get_blocks serializes access to the block map with the i_lock on the
> > > xfs_inode.  This appears to be racy with respect to hole punching.
> > 
> > Would it be possible to just make __xfs_get_blocks get the i_iolock
> > (non-exclusively)?
> 
> No. __xfs_get_blocks() operates on metadata (e.g. extent lists), and
> as such is protected by the i_ilock (note: not the i_iolock).  i.e.
> XFS has a multi-level locking strategy:
> 
> 	i_iolock is provided for *data IO serialisation*,
> 	i_ilock is for *inode metadata serialisation*.

I think if __xfs_get_blocks has some way of knowing it is the mmap/page fault
path, taking the iolock shared in addition to the ilock (in just that case)
would prevent the mmap from being able to read stale data from disk.  You would
see either the data before the punch or you would see the hole.  

Actually... I think that is wrong:  You'd have to take the iolock across the
read itself (not just the access to the block map) for it to have the desired
effect:

1608 int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
...
1704 page_not_uptodate:
1705         /*
1706          * Umm, take care of errors if the page isn't up-to-date.
1707          * Try to re-read it _once_. We do this synchronously,
1708          * because there really aren't any performance issues here
1709          * and we need to check for errors.
1710          */
1711         ClearPageError(page);
1712         error = mapping->a_ops->readpage(file, page);
1713         if (!error) {
1714                 wait_on_page_locked(page);
1715                 if (!PageUptodate(page))
1716                         error = -EIO;
1717         }
1718         page_cache_release(page);

Wouldn't you have to hold the iolock until after wait_on_page_locked returns?

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
