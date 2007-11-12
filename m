Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 11 Nov 2007 20:11:29 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAC4BKv8030644
	for <xfs@oss.sgi.com>; Sun, 11 Nov 2007 20:11:23 -0800
Date: Mon, 12 Nov 2007 15:11:21 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] bulkstat fixups
Message-ID: <20071112041121.GT66820511@sgi.com>
References: <4733EEF2.9010504@sgi.com> <20071111214759.GS995458@sgi.com> <4737C11D.8030007@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4737C11D.8030007@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Nov 12, 2007 at 01:57:33PM +1100, Lachlan McIlroy wrote:
> David Chinner wrote:
> >[Lachlan, can you wrap your email text at 72 columns for ease of quoting?]
> >
> >On Fri, Nov 09, 2007 at 04:24:02PM +1100, Lachlan McIlroy wrote:
> >>Here's a collection of fixups for bulkstat for all the remaining issues.
> >>
> >>- sanity check for NULL user buffer in xfs_ioc_bulkstat[_compat]()
> >
> >OK.
> >
> >>- remove the special case for XFS_IOC_FSBULKSTAT with count == 1.  This 
> >>special
> >>  case causes bulkstat to fail because the special case uses 
> >>  xfs_bulkstat_single()
> >>  instead of xfs_bulkstat() and the two functions have different 
> >>  semantics.
> >>  xfs_bulkstat() will return the next inode after the one supplied while 
> >>  skipping
> >>  internal inodes (ie quota inodes).  xfs_bulkstate_single() will only 
> >>  lookup the
> >>  inode supplied and return an error if it is an internal inode.
> >
> >Userspace visile change. What applications do we have that rely on this
> >behaviour that will be broken by this change?
> 
> Any apps that rely on the existing behaviour are probably broken.  If an app
> wants to call xfs_bulkstat_single() it should use XFS_IOC_FSBULKSTAT_SINGLE.

Perhaps, but we can't arbitrarily decide that those apps will now break on
a new kernel with this change. At minimum we need to audit all of the code
we have that uses bulkstat for such breakage (including DMF!) before we make a
change like this.

> >>- checks against 'ubleft' (the space left in the user's buffer) should be 
> >>against
> >>  'statstruct_size' which is the supplied minimum object size.  The 
> >>  mixture of
> >>  checks against statstruct_size and 0 was one of the reasons we were 
> >>  skipping
> >>  inodes.
> >
> >Can you wrap these checks in a static inline function so that it is obvious
> >what the correct way to check is and we don't reintroduce this porblem? 
> >i.e.
> >
> >static inline int
> >xfs_bulkstat_ubuffer_large_enough(ssize_t space)
> >{
> >	return (space > sizeof(struct blah));
> >}
> >
> >That will also remove a stack variable....
> 
> That won't work - statstruct_size is passed into xfs_bulkstat() so we don't
> know what 'blah' is.  Maybe a macro would be easier.
> 
> #define XFS_BULKSTAT_UBLEFT	(ubleft >= statstruct_size)

Yeah, something like that, but I don't like macros with no parameters used
like that....

> >FWIW - missing from this set of patches - cpu_relax() in the loops. In the 
> >case
> >where no I/O is required to do the scan, we can hold the cpu for a long 
> >time
> >and that will hold off I/O completion, etc for the cpu bulkstat is running 
> >on.
> >Hence after every cluster we scan we should cpu_relax() to allow other
> >processes cpu time on that cpu.
> >
> 
> I don't get how cpu_relax() works.  I see that it is called at times with a
> spinlock held so it wont trigger a context switch.  Does it give interrupts 
> a chance to run?

Sorry, my mistake - confused cpu_relax() with cond_resched(). take the above
paragraph and s/cpu_relax/cond_resched/g

> It appears to be used where a minor delay is needed - I don't think we have 
> any
> cases in xfs_bulkstat() where we need to wait for an event that isn't I/O.

The issue is when we're hitting cached buffers and we never end up waiting
for I/O - we will then monopolise the cpu we are running on and hold off
all other processing. It's antisocial and leads to high latencies for other
code.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
