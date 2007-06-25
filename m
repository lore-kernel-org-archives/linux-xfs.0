Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Jun 2007 23:02:49 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5P62ido026053
	for <xfs@oss.sgi.com>; Sun, 24 Jun 2007 23:02:45 -0700
Subject: Re: XFS_IOC_RESVSP64 for swap files
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20070621061449.GB11200@cordes.ca>
References: <20070617100822.GA4586@cordes.ca>
	 <20070619043333.GJ86004887@sgi.com>  <20070621061449.GB11200@cordes.ca>
Content-Type: text/plain
Date: Mon, 25 Jun 2007 10:07:51 +1000
Message-Id: <1182730071.15488.36.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Cordes <peter@cordes.ca>
Cc: xfs@oss.sgi.com

On Thu, 2007-06-21 at 03:14 -0300, Peter Cordes wrote:
> 
> > >  Could swapon(2) in the kernel be made to work on XFS files with
> reserved
> > > space?
> > 
> > Basically, the swapon syscall calls bmap() for the block mapping of
> the
> > file and XFS returns "holes" [...]
> 
>  Yeah, bad idea to put special case stuff in the kernel.
> 
> > > i.e. call something that would give XFS a chance to mark all the
> > > extents as written, even though they're not.
> > 
> > You mean like XFS_IOC_EXPOSE_MY_STALE_DATA_TO_EVERYONE? ;)
> > 
> > That's not going to happen.

I wouldn't dismiss it out of hand.

Maybe if it was approached as follows:
- forget about "preallocation", as that's clouding the discussion
  with talk of unwritten extents, etc.  This is a real allocation,
  and filesize would need to reflect that (its XFS_IOC_ALLOCSP, just
  without the zeroing).
- instead, if you added a flag to the shiny new fallocate syscall,
  F_MKSWAP or some such, and then implemented it as an allocate
  with no zeroing.
- change mkswap to be able to optionally use this, and those dynamic
  methods for adding swap that you mentioned.
- produce objective data demonstrating the improvements this makes,
  as this will be needed when arguing the case for the flag in the
  kernel (the fallocate flag, I mean).

I can't see any reason this shouldn't be acceptable - there really
is no security issue here, provided the F_MKSWAP syscall has tight
restrictions (the arbitrary contents of memory that will get swapped
have potentially more sensitive info, like decrypted passwords, than
would usually be stored in a filesystem).  And there is very little
added complexity/code introduced, almost everything is already in
place, so if its demonstrably useful... *shrug*.

> > In fact, I plan to make unwritten extents non-optional soon (i.e.
> I've already

Unwritten extents aren't really relevent here - you would definately
not want to have these extents marked unwritten, as that would cause
additional transactions, memory allocations, writes, etc during swap.

>  Ok.  I didn't really want to recreate my /var/tmp filesystem with
> unwritten=0, but I really wish I had
> XFS_IOC_EXPOSE_MY_STALE_DATA_TO_EVERYONE on my desktop machine.  I
> think
> dynamic swap file creation is a cool idea, and that ioctl would make
> it work
> perfectly.

I think if the data was compelling enough, there's no obvious reason
this couldn't be merged, IMO (you may want to make an XFS ioctl also,
just to test it - use xfs_io on the frontend & write some xfstests -
and you'll need to tweak the call down into xfs_alloc_file_space - the
4th "alloc_type" argument will need to become a flags parameter instead
of effectively the boolean it is now, and theres a few code changes to
be done related to that).

cheers.

--
Nathan
