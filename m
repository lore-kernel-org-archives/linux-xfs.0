Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39234 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbeLQUJM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Dec 2018 15:09:12 -0500
Date: Mon, 17 Dec 2018 12:09:06 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH v2 2/3] xfs: Fix bulkstat compat ioctls on x32
 userspace.
Message-ID: <20181217200906.GA27176@magnolia>
References: <20181215012259.28358-1-nbowler@draconx.ca>
 <20181215012259.28358-3-nbowler@draconx.ca>
 <20181217174018.GH24487@magnolia>
 <CADyTPEwwbKq2KCcRU=Rj+66JKPemq+BhNRitR-uz_gu=fXp-Ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADyTPEwwbKq2KCcRU=Rj+66JKPemq+BhNRitR-uz_gu=fXp-Ng@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nick Bowler <nbowler@draconx.ca>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>

On Mon, Dec 17, 2018 at 03:06:43PM -0500, Nick Bowler wrote:
> On 2018-12-17 Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > On Fri, Dec 14, 2018 at 08:22:58PM -0500, Nick Bowler wrote:
> [...]
> >> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> >> index 4c34efcbf7e8..1cdc75dca779 100644
> >> --- a/fs/xfs/xfs_ioctl32.c
> >> +++ b/fs/xfs/xfs_ioctl32.c
> >> @@ -241,6 +241,32 @@ xfs_compat_ioc_bulkstat(
> >>  	int			done;
> >>  	int			error;
> >>
> >> +	/*
> >> +	 * Output structure handling functions.  Depending on the command,
> >> +	 * either the xfs_bstat and xfs_inogrp structures are written out
> >> +	 * to userpace memory via bulkreq.ubuffer.  Normally the compat
> >> +	 * functions and structure size are the correct ones to use ...
> >> +	 */
> >> +	inumbers_fmt_pf inumbers_func = xfs_inumbers_fmt_compat;
> >> +	bulkstat_one_pf	bs_one_func = xfs_bulkstat_one_compat;
> >> +	size_t bs_one_size = sizeof(compat_xfs_bstat_t);
> >> +
> >> +#ifdef CONFIG_X86_X32
> >> +	if (in_x32_syscall()) {
> >> +		/*
> >> +		 * ... but on x32 the input xfs_fsop_bulkreq has pointers
> >> +		 * which must be handled in the "compat" (32-bit) way, while
> >> +		 * the xfs_bstat and xfs_inogrp structures follow native 64-
> >> +		 * bit layout convention.  So adjust accordingly, otherwise
> >> +		 * the data written out in compat layout will not match what
> >> +		 * x32 userspace expects.
> >> +		 */
> >> +		inumbers_func = xfs_inumbers_fmt;
> >> +		bs_one_func = xfs_bulkstat_one;
> >> +		bs_one_size = sizeof(xfs_bstat_t);
> >
> > struct xfs_bstat, not xfs_bstat_t, because we're gradually getting rid
> > of the structure typedefs.  If I don't hear any other objections in the
> > next day or so I'll fix this when I pull in this patch.
> 
> Makes sense.  I'll only change this on my end if I have to respin the
> series for some other reason then.  I guess the sizeof(compat_xfs_bstat_t)
> just before this should be similarly changed as well?

Yep.

--D

> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Thanks,
>   Nick
