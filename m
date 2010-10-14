Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9ELWJ8q075048 for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 16:32:19 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 20608191B0D4
	for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 14:33:27 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	L1Of2aJla6Yrhz0L for <xfs@oss.sgi.com>;
	Thu, 14 Oct 2010 14:33:27 -0700 (PDT)
Date: Fri, 15 Oct 2010 08:33:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: dynamic speculative EOF preallocation
Message-ID: <20101014213325.GF4681@dastard>
References: <1286187236-16682-1-git-send-email-david@fromorbit.com>
	<1286187236-16682-2-git-send-email-david@fromorbit.com>
	<1287076965.2362.520.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1287076965.2362.520.camel@doink>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 14, 2010 at 12:22:45PM -0500, Alex Elder wrote:
> On Mon, 2010-10-04 at 21:13 +1100, Dave Chinner wrote:
> > @@ -427,11 +431,25 @@ xfs_iomap_eof_want_preallocate(
> >  			if ((imap[n].br_startblock != HOLESTARTBLOCK) &&
> >  			    (imap[n].br_startblock != DELAYSTARTBLOCK))
> >  				return 0;
> > +
> >  			start_fsb += imap[n].br_blockcount;
> >  			count_fsb -= imap[n].br_blockcount;
> > +
> > +			/* count delalloc blocks beyond EOF */
> > +			if (imap[n].br_startblock == DELAYSTARTBLOCK)
> > +				found_delalloc += imap[n].br_blockcount;
> >  		}
> >  	}
> > -	*prealloc = 1;
> 
> At this point, count_fsb will be 0 (a necessary condition
> for loop termination, since count_fsb is unsigned).  Since
> found_delalloc is initially 0 (and is also unsigned), we
> can safely assume that found_delalloc >= count_fsb.  The
> only case in which found_delalloc <= count_fsb is if
> found_delalloc is also 0 (a case you cover separately,
> first, below).
> 
> Furthermore, *prealloc was assigned the value 0 at the top.
> So I think this bottom section can be simplified to:
> 	if (!found_delalloc)
> 		*prealloc = 1;

I'll have a look at this - there was some reason for the second
case, but the code has changed since I needed it and, as you
suggest, it might not be needed anymore.

> >  	error = xfs_iomap_eof_want_preallocate(mp, ip, offset, count,
> >  				ioflag, imap, XFS_WRITE_IMAPS, &prealloc);
> >  	if (error)
> > @@ -476,9 +495,25 @@ xfs_iomap_write_delay(
> >  
> >  retry:
> >  	if (prealloc) {
> > +		xfs_fileoff_t	alloc_blocks = 0;
> > +		/*
> > +		 * If we don't have a user specified preallocation size, dynamically
> > +		 * increase the preallocation size as we do more preallocation.
> > +		 * Cap the maximum size at a single extent.
> > +		 */
> > +		if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)) {
> 
> I note that this is circumventing the special code in
> xfs_set_rw_sizes() that tries to set up a different (smaller)
> size in the event the "sync" (generic) mount option was supplied
> (indicated by XFS_MOUNT_SYNC).  If that is a good thing, then I
> suggest the code in xfs_set_rw_sizes() go away.  But it would be
> good to have the case for making that change stated.

The new code based on file size is a bit different. It still
triggers off the absence of his flag, but it now uses the default
sizes as the minimum speculative allocation size.

> I guess the reason one might want the "allocsize" mount
> option now becomes the opposite of why one might have
> wanted it before.  I.e., it would be used to *reduce*
> the size of the preallocated range beyond EOF, which I
> could envision might be reasonable in some circumstances.

It now becomes the minimum preallocation size, rather than both the
minimum and the maximum....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
