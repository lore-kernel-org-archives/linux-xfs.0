Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Jun 2007 16:15:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5QNEwtL001594
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 16:15:00 -0700
Date: Wed, 27 Jun 2007 09:14:31 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070626231431.GO31489@sgi.com>
References: <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625214626.GJ5181@schatzie.adilger.int>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Mon, Jun 25, 2007 at 03:46:26PM -0600, Andreas Dilger wrote:
> On Jun 25, 2007  20:33 +0530, Amit K. Arora wrote:
> > I have not implemented FA_FL_FREE_ENOSPC and FA_ZERO_SPACE flags yet, as
> > *suggested* by Andreas in http://lkml.org/lkml/2007/6/14/323  post.
> > If it is decided that these flags are also needed, I will update this
> > patch. Thanks!
> 
> Can you clarify - what is the current behaviour when ENOSPC (or some other
> error) is hit?  Does it keep the current fallocate() or does it free it?
> 
> For FA_ZERO_SPACE - I'd think this would (IMHO) be the default - we
> don't want to expose uninitialized disk blocks to userspace.  I'm not
> sure if this makes sense at all.

Someone on the XFs list had an interesting request - preallocated
swap files. You can't use unwritten extents for this because
of sys_swapon()s use of bmap() (XFS returns holes for reading
unwritten extents), so we need a method of preallocating that does
not zero or mark the extent unread. i.e. FA_MKSWAP.

I thinkthis would be:

#define FA_FL_NO_ZERO_SPACE	0x08	/* default is to zero space */

#define FA_MKSWAP 	(FA_ALLOCATE | FA_FL_NO_ZERO_SPACE)

That way we can allocate large swap files that don't need zeroing
in a single, fast operation, and hence potentially bring new
swap space online without needed very much memory at all (i.e.
should succeed in most near-OOM conditions).

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
