Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 07:12:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l54EBxWt010770
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 07:12:01 -0700
Date: Tue, 5 Jun 2007 00:11:54 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: Be smarter about handling ENOSPC during writeback
Message-ID: <20070604141154.GK86004887@sgi.com>
References: <20070604045219.GG86004887@sgi.com> <E4C7CA19461547A0919B23A2@timothy-shimmins-power-mac-g5.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E4C7CA19461547A0919B23A2@timothy-shimmins-power-mac-g5.local>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Jun 04, 2007 at 07:41:19PM +1000, Timothy Shimmin wrote:
> Hi Dave,
> 
> As an aside,
> I don't understand the following bit of code in xfs_reserve_blocks():
>        /*
>         * If our previous reservation was larger than the current value,
>         * then move any unused blocks back to the free pool.
>         */
>        fdblks_delta = 0;
>        if (mp->m_resblks > request) {
>                lcounter = mp->m_resblks_avail - request;
>                if (lcounter  > 0) {            /* release unused blocks */
>                        fdblks_delta = lcounter;
>                        mp->m_resblks_avail -= lcounter;
>                }
	>>>>	 mp->m_resblks = request;

> 
> I can't see why it is not calculating a delta for:
>  delta = m_resblks - request

Because mp->m_resblks_avail is the amount of reservation space
we have *unallocated*. i.e. 0 <= mp->m_resblks_avail <= mp->m_resblks

IOWs, when we have used some blocks and then change mp->m_resblks, the
amount we can can return is limited by the the available blocks,
not the total reservation.

> and using that to update the m_resblks_avail and fdblks_delta;
> like we do in the case below where the request is the larger one.
> Instead it is affectively doing:
> m_resblks_avail = m_resblks_avail - m_resblks_avail + request
>                = request

Surprising, but correct. When we reduce mp->m_resblks,
mp->m_resblks_avail must be <= mp->m_resblks. IOWs we reduce the
available blocks to that of the limit, so any allocated reserved
blocks will now immediately be considered as unreserved and when
they are freed the space will be immediately returned to the normal
pool.

Example: resblks = 1000, avail = 750. Set new resblks = 500.
avail must be reduced to 500 and 250 must be freed.

	fdblks_delta = 0
	if (1000 > 500) {
		lcounter = 750 - 500 = 250
		if (250 > 0) {
			fdblks_delta = 250
			resblks_avail = 500
		}
		m_resblks = 500;
	} else {
.....
	}
.....
	if (fdblks_delta) {
.....
		error = xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS, fdblks_delta, 0);
.....

That "frees" 250 blocks. This is correct behaviour.

> It looks wrong to me.
> What am I missing?
> And why doesn't sb_fdblocks need to be updated in this case.

Because if we update mp->m_sb.sb_fdblocks, the value minus the reservation
gets written to disk, and that means it is incorrect (xfs-check
would fail) as the reservation is purely an in-memory construct...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
