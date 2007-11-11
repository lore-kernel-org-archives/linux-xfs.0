Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 11 Nov 2007 13:48:09 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lABLm0vj013593
	for <xfs@oss.sgi.com>; Sun, 11 Nov 2007 13:48:03 -0800
Date: Mon, 12 Nov 2007 08:48:00 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] bulkstat fixups
Message-ID: <20071111214759.GS995458@sgi.com>
References: <4733EEF2.9010504@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4733EEF2.9010504@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

[Lachlan, can you wrap your email text at 72 columns for ease of quoting?]

On Fri, Nov 09, 2007 at 04:24:02PM +1100, Lachlan McIlroy wrote:
> Here's a collection of fixups for bulkstat for all the remaining issues.
> 
> - sanity check for NULL user buffer in xfs_ioc_bulkstat[_compat]()

OK.

> - remove the special case for XFS_IOC_FSBULKSTAT with count == 1.  This 
> special
>   case causes bulkstat to fail because the special case uses 
>   xfs_bulkstat_single()
>   instead of xfs_bulkstat() and the two functions have different semantics.
>   xfs_bulkstat() will return the next inode after the one supplied while 
>   skipping
>   internal inodes (ie quota inodes).  xfs_bulkstate_single() will only 
>   lookup the
>   inode supplied and return an error if it is an internal inode.

Userspace visile change. What applications do we have that rely on this
behaviour that will be broken by this change?

> - in xfs_bulkstat(), need to initialise 'lastino' to the inode supplied so 
> in cases
>   were we return without examining any inodes the scan wont restart back at 
>   zero.

Ok.

> - sanity check for valid *ubcountp values.  Cannot sanity check for valid 
> ubuffer
>   here because some users of xfs_bulkstat() don't supply a buffer.

Ok - the cases that supply a buffer are caught by the first checks you
added, right?

> - checks against 'ubleft' (the space left in the user's buffer) should be 
> against
>   'statstruct_size' which is the supplied minimum object size.  The mixture 
>   of
>   checks against statstruct_size and 0 was one of the reasons we were 
>   skipping
>   inodes.

Can you wrap these checks in a static inline function so that it is obvious
what the correct way to check is and we don't reintroduce this porblem? i.e.

static inline int
xfs_bulkstat_ubuffer_large_enough(ssize_t space)
{
	return (space > sizeof(struct blah));
}

That will also remove a stack variable....

> - if the formatter function returns BULKSTAT_RV_NOTHING and an error and 
> the error
>   is not ENOENT or EINVAL then we need to abort the scan.  ENOENT is for 
>   inodes that
>   are no longer valid and we just skip them.  EINVAL is returned if we try 
>   to lookup
>   an internal inode so we skip them too.  For a DMF scan if the inode and 
>   DMF
>   attribute cannot fit into the space left in the user's buffer it would 
>   return
>   ERANGE.  We didn't handle this error and skipped the inode.  We would 
>   continue to
>   skip inodes until one fitted into the user's buffer or we completed the 
>   scan.

ok.

> - put back the recalculation of agino (that got removed with the last fix) 
> at the
>   end of the while loop.  This is because the code at the start of the loop 
>   expects
>   agino to be the last inode examined if it is non-zero.

ok.

> - if we found some inodes but then encountered an error, return success 
> this time
>   and the error next time.  If the formatter aborted with ENOMEM we will 
>   now return
>   this error but only if we couldn't read any inodes.  Previously if we 
>   encountered
>   ENOMEM without reading any inodes we returned a zero count and no error 
>   which
>   falsely indicated the scan was complete.

ok.

FWIW - missing from this set of patches - cpu_relax() in the loops. In the case
where no I/O is required to do the scan, we can hold the cpu for a long time
and that will hold off I/O completion, etc for the cpu bulkstat is running on.
Hence after every cluster we scan we should cpu_relax() to allow other
processes cpu time on that cpu.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
