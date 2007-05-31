Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 May 2007 06:04:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4VD3tWt017134
	for <xfs@oss.sgi.com>; Thu, 31 May 2007 06:03:57 -0700
Date: Thu, 31 May 2007 23:03:37 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch 3/3] Fix XFS_IOC_FSBULKSTAT{,_SINGLE} and XFS_IOC_FSINUMBERS in compat mode
Message-ID: <20070531130337.GM85884050@sgi.com>
References: <20070530125954.706423971@suse.cz> <20070530143044.060544510@suse.cz> <20070531063734.GJ85884050@sgi.com> <465E8CBE.8020709@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465E8CBE.8020709@suse.cz>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michal Marek <mmarek@suse.cz>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 10:52:14AM +0200, Michal Marek wrote:
> David Chinner wrote:
> > On Wed, May 30, 2007 at 02:59:57PM +0200, Michal Marek wrote:
> >> +typedef struct xfs_bstat32 {
.......
> >> +}
> >> +#ifdef BROKEN_X86_ALIGNMENT
> >> +	__attribute__((packed))
> >> +#endif
> >> +	xfs_bstat32_t;
> > 
> > #ifdef BROKEN_X86_ALIGNMENT
> > #define _PACKED	__attribute__((packed))
> > #else
> > #define _PACKED
> > #endif
> > 
> > typedef struct xfs_bstat_32 {
> > 	......
> > } _PACKED xfs_bstat32_t
> 
> Yes, that would look cleaner. Perhaps something like PACKED_IF_NEEDED so
> that it's clear that it's not allways defined to __attribute__((packed))?

<shrug>

Not really that fussed ;)

> >> +
> >> +	if (cmd == XFS_IOC_FSBULKSTAT || cmd == XFS_IOC_FSBULKSTAT_SINGLE) {
> > 
> > Oh, now it gets messy :(
> 
> True :-/
> 
> 
> > So, we do a whole lot of repacking of the bulkstat structures
> > once we've got the data out of the bulkstat call.
> > 
> > I think this is really the wrong way of doing this - the bulkstat
> > functions themselves take a "formatter" argument that is used to pack
> > the buffer in a given format. I think that we need to be supplying
> > the bulkstat code with different formatters in this case, not
> > repacking the buffer into a different format at a later time.
> > 
> > The formatter used by default is xfs_bulkstat_one() which 
> > falls down to xfs_bulkstat_one_dinode() or xfs_bulkstat_one_iget()
> > depending on whether we are doing icache coherent or blockdev
> > cache coherent lookups. It is these functions that need to be
> > told what format they are packing, I think, and xfs_bulkstat_single()
> > needs to be taught about them....
> 
> Well, I didn't want to touch other files but xfs_ioctl32.c so that the
> patch has a higher chance of being accepted ;-) But of course if you
> think that patching the implementation to be aware of the compat ioctls
> is acceptable, then I can do it.

I think that given we already have multiple bulkstat formatters to
support different buffer formats, we'd be silly not to use that
interface directly for the new buffer formats needed.

You can probably dup the code from xfs_ioctl.c to issue the bulkstat
calls and then modify both to take specified formatters. You could even
define the compat formatter(s) in xfs_ioctl32.c so the compat code
doesn't need to be put elsewhere....

> >> +	if (cmd == XFS_IOC_FSINUMBERS) {
> > 
> > And I'm wondering if we should be doing the same thing here
> > (i.e. customer formatters), because this is equally ugly...
> 
> I'll try to clean up the XFS_IOC_FSBULKSTAT part first...

Yup, fair enough.

Thanks!

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
