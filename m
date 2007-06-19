Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Jun 2007 21:33:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5J4Xedo024641
	for <xfs@oss.sgi.com>; Mon, 18 Jun 2007 21:33:43 -0700
Date: Tue, 19 Jun 2007 14:33:33 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS_IOC_RESVSP64 for swap files
Message-ID: <20070619043333.GJ86004887@sgi.com>
References: <20070617100822.GA4586@cordes.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070617100822.GA4586@cordes.ca>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Cordes <peter@cordes.ca>
Cc: xfs@oss.sgi.com

On Sun, Jun 17, 2007 at 07:08:23AM -0300, Peter Cordes wrote:
>  Hi XFS list.  I'm not subscribed, please CC me.
> 
>  Programs such as swapspace and swapd create new swap files when vmem runs
> low.  They would benefit hugely from being able to create a swapfile without
> any significant disk I/O.  (If a process grabs a lot of memory quickly, the
> system will be swapping hard while swapspace(8) is writing a swapfile.)
> 
> unfortunately,
>  touch foo
>  xfs_io -c 'truncate 1000000000' -c "resvsp 0 1000000000" foo
>  mkswap foo
>  sudo swapon foo
> doesn't work.  The kernel complains:
>  swapon: swapfile has holes
> 
>  foo is a ~1GB file with disk space allocated for it, though.  But reading
> it doesn't create any disk I/O and reads all zero, so it's treated like a
> sparse file.  Is this because my filesystem flags unwritten extents?

Yes.

> And if
> my FS was created with that option off, would RESVSP make the file contain
> the previous contents of that disk space?

Yes.

> That would be an obvious security hole,

Yes. That's why unwritten extents were introduced 10 or so years ago.

> but it would still be useful for making swap files even if only root
> could do it.

Still a potential security hole.

>  So, any ideas on how to make swap files without writing the whole file?

You can't. You need to use allocsp to allocate zero'd space. i.e.

# xfs_io -f -c 'allocsp 1000000000 0' foo

>  Could swapon(2) in the kernel be made to work on XFS files with reserved
> space?

Basically, the swapon syscall calls bmap() for the block mapping of the
file and XFS returns "holes" for unwritten extents because this is the
interface needed for reads to zero fill the pages. Something would need
to be changed in XFS to make it return anything different, and that would
break other things. So I doubt anything will change here.

> i.e. call something that would give XFS a chance to mark all the
> extents as written, even though they're not.

You mean like XFS_IOC_EXPOSE_MY_STALE_DATA_TO_EVERYONE? ;)

That's not going to happen.

In fact, I plan to make unwritten extents non-optional soon (i.e. I've already
got preliminary patches to do this) so that filesystems that have it turned
off will get them turned on automatically.

The reasons?

	a) there is no good reason for unwritten=0 from a performance
	   perspective
	b) there is good reason for unwritten=1 from a security perspective
	c) we need to use unwritten extents in place of written extents
	   during delayed allocation to prevent stale data exposure on
	   crash and when using extent size hints.

So soon unwritten=0 is likely to go the way of the dodo.....

>  BTW, I think xfs_allocsp has its args reversed, or something.
> touch bar
> xfs_io -c "allocsp 0 1000000" bar; ll -h
> -rw-rw-r-- 1 peter peter    0 2007-06-17 06:45 bar
> xfs_io -c "allocsp 1000000 0" bar; ll -h
> -rw-rw-r-- 1 peter peter 977K 2007-06-17 06:45 bar

Nope, acting as [badly] documented. in the xfsctl man page:

	"If the section specified is beyond the current end of file,  the
	file  is  grown  and  filled  with zeroes. The l_len field is
	currently ignored, and should be set to zero."

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
