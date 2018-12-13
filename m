Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56844 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727775AbeLMSXa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Dec 2018 13:23:30 -0500
Date: Thu, 13 Dec 2018 13:23:28 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 1/2] xfs: Fix bulkstat compat ioctls on x32 userspace.
Message-ID: <20181213182328.GC2829@bfoster>
References: <20181213013000.15716-1-nbowler@draconx.ca>
 <20181213013000.15716-2-nbowler@draconx.ca>
 <20181213124129.GB2829@bfoster>
 <CADyTPEy=vrcWKYksAyYi_-38KSxwFQ=gdxO4qRk4pvww4Dp7zQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADyTPEy=vrcWKYksAyYi_-38KSxwFQ=gdxO4qRk4pvww4Dp7zQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nick Bowler <nbowler@draconx.ca>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Thu, Dec 13, 2018 at 12:44:16PM -0500, Nick Bowler wrote:
> On 2018-12-13, Brian Foster <bfoster@redhat.com> wrote:
> > On Wed, Dec 12, 2018 at 08:29:59PM -0500, Nick Bowler wrote:
> >> The bulkstat family of ioctls are problematic on x32, because there is
> >> a mixup of native 32-bit and 64-bit conventions: the xfs_bulkstat struct
> >> contains pointers and 32-bit integers so that fits the native 32-bit
> >> layout fine.  However, one of those pointers is subsequently used to
> >> refer to one of several structs which, on x32, all follow the native
> >> 64-bit way.
> >>
> >> Fortunately the pointer chasing seems to end there, and the functions to
> >> deal with this abstract things pretty well.  We just need a little tweak
> >> to pass the right formatting function if called from x32 mode.
> >>
> > > Could you be a bit more specific on the problem? What
> > pointers/structures are problematic? What exactly is "the xfs_bulkstat
> > struct?"
> 
> A mistake.  I meant struct xfs_fsop_bulkreq; I'll fix the commit message.
> 
> The problem is:
> 
>   - xfs_fsop_bulkreq on x32 matches IA-32 layout on x32, so the
>     ioctl cmd number matches and the implementation calls
>     xfs_compat_ioc_bulkstat.
> 

I assume that this is because xfs_fsop_bulkreq includes pointers, which
is where x32 and x86_64 actually start to differ..? So in this
particular case, the two ioctl() structs actually are different between
x32 and x86_64.

>   - The 'ubuffer' pointer in that structure refers to either struct
>     xfs_bstat or struct xfs_inogrp.  On x32 both of these structures
>     match the native 64-bit layout; the compat path writes out the
>     IA-32 layout which is incorrectly formatted for x32 userspace.
> 

Ok.

> The proposed solution is:
> 
>   - Use in_x32_syscall to distinguish the IA-32 and x32 cases, the
>     functions which do this have a easy way to select which output
>     format is required, so we just need to pick the right one on x32.
> 

A little hairy, but it makes more sense now. Thanks.

> >> ---
> >>  fs/xfs/xfs_ioctl32.c | 25 +++++++++++++++++++++----
> >>  1 file changed, 21 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> >> index fba115f4103a..6a759c0ffb54 100644
> >> --- a/fs/xfs/xfs_ioctl32.c
> >> +++ b/fs/xfs/xfs_ioctl32.c
> >> @@ -241,6 +241,23 @@ xfs_compat_ioc_bulkstat(
> >>  	int			done;
> >>  	int			error;
> >>
> >> +	/*
> >> +	 * These functions and size are used later to handle individual
> >> +	 * entries; x32 is annoying and needs different functions.
> >> +	 */
> >
> > Same here, this describes the change but doesn't help me understand the
> > problem.
> 
> I'll think about a better way to write this comment.
> 

I'd suggest to use parts of what you've just described above.

Brian

> >> +	inumbers_fmt_pf inumbers_func = xfs_inumbers_fmt_compat;
> >> +	bulkstat_one_pf	bs_one_func = xfs_bulkstat_one_compat;
> >> +	size_t bs_one_size = sizeof(compat_xfs_bstat_t);
> >> +
> >> +#ifdef CONFIG_X86_X32
> >> +	if (in_x32_syscall()) {
> >> +		/* x32 matches native amd64 bstat and inogrp layout */
> >> +		inumbers_func = xfs_inumbers_fmt;
> >> +		bs_one_func = xfs_bulkstat_one;
> >> +		bs_one_size = sizeof(xfs_bstat_t);
> >> +	}
> >> +#endif
> >> +
> >
> > Would this be necessary if the higher level x32 code called into
> > xfs_ioc_bulkstat() instead of the compat variant, or is there some
> > other reason x32 wouldn't work through that path?
> 
> The xfs_compat_ioc_bulkstat function does two things: it reads in the
> xfs_fsop_bulkreq structure (matches ia-32 layout on x32), then it writes
> out the xfs_inorgp or xfs_bstat structures depending on what operation
> was requested; both of these structures match amd64 layout on x32.
> 
> So the goal of the change is to adjust the second behaviour only.
> 
> Cheers,
>   Nick
