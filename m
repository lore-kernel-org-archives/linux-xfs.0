Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748BA483BCD
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 23:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790377411; cv=none; b=cWlhD7iNhTL5i3OnO0fM49/lF2kJW1CPOIWBdIWkHSAWUVODETw0CNW1ZPyPmSz5KN2DQcqgLJFq+3HSLhO0viSvjOjyI/HyFhZYi7pPi2ql+VSCSYwN9BWLAyENlTya/Y2Aavb1PHxTl0xsZOdobjfVw3Vb3InRzkSaJNIHoh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790377411; c=relaxed/simple;
	bh=/LrxfYGOOM1R7niSmpWnHxay2+DPlxssp6qhEPtACiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gtyFBkf6yDyns37QHf68wpepWjAAPC8iPJw27VLNBxpWdXbFT3wcxYYzOqbtzhWANRjHHiZEyCAhNWUgNbrRqpHfJBYFvnFe2Uu7J6sklyHYBTJ2Q0huCd739dK2OF0GRq6gh5ImpUJyiTCXFYKLj9HWDJrxbqA5Evg+eKY/Ius=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ORnz8ARZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ORnz8ARZ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EA8AC1F000FF;
	Fri, 25 Sep 2026 23:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790377410;
	bh=Jp2uQYNlwrWnfZrIygDLHcKJjvf/tey/591PMS5ewTo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ORnz8ARZTPjRLzhnpjK5jCBicaTlTZwmjmqbevyUPm4zL2PJ3QMcuS8y+7ZJSO7Op
	 h4+Gb5EYOJWfz9NRkSaj9GUHfMPIDol+HeGoaviwgdrbCuq6zom7Qav1kjBbN0YgEI
	 LGQxXjhQf+dM4eWPG9lBq/rGD7SqPrwBGAOUgndx1haTrPaT6sSX/hwBJDQveOb4Wu
	 s0FB2WHClqm+CHxqj7rWYC82ZJ7CLG9EiEFYxpT7F5389gVAxu752LbfDNnQHoyM/5
	 wgl0GxC1gGoguFwzpRKuHaLH7Aq630ukxbt4+WyQ+AtNRXNEQ0+UFEC0ohTf5s/2gz
	 xbaBBrbon0+dw==
Date: Fri, 25 Sep 2026 16:03:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Dave Chinner <dgc@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	John Garry <john.garry@linux.dev>
Subject: Re: [bug report] fstests generic/774 hang again
Message-ID: <20260925230329.GE2705364@frogsfrogsfrogs>
References: <aqkP9CTUvlC2YCIb@shinmob>
 <aqsN4GOXthkF8rOI@dread>
 <20260922002814.GK2705364@frogsfrogsfrogs>
 <arXPSS6ikVMDaI7w@shinmob>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arXPSS6ikVMDaI7w@shinmob>

On Fri, Sep 25, 2026 at 10:38:07AM +0900, Shin'ichiro Kawasaki wrote:
> On Sep 21, 2026 / 17:28, Darrick J. Wong wrote:
> > On Thu, Sep 17, 2026 at 07:45:04AM +1000, Dave Chinner wrote:
> [...]
> > > A bunch of threads waiting on the ILOCK here:
> > > 
> > >  down_write_nested+0x1c0/0x1f0
> > >  xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> > >  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
> > >  iomap_dio_complete+0x140/0xb20
> > >  iomap_dio_complete_work+0x58/0x90
> > >  process_one_work+0x947/0x1760
> > > 
> > > And the holder:
> > > 
> > >  schedule+0xe5/0x2e0
> > >  xlog_grant_head_wait+0x175/0xac0 [xfs]
> > >  xlog_grant_head_check+0x312/0x3f0 [xfs]
> > >  xfs_log_regrant+0x380/0x7d0 [xfs]
> > >  xfs_trans_roll+0x2d9/0x420 [xfs]
> > >  xfs_defer_trans_roll+0x11e/0x4b0 [xfs]
> > >  xfs_defer_finish_noroll+0x460/0xe70 [xfs]
> > >  xfs_trans_commit+0xfc/0x180 [xfs]
> > >  xfs_reflink_end_atomic_cow+0x3b2/0x560 [xfs]
> > >  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
> > >  iomap_dio_complete+0x140/0xb20
> > >  iomap_dio_complete_work+0x58/0x90
> > >  process_one_work+0x947/0x1760
> > > 
> > > is waiting on log space whilst holding the ILOCK.
> > > 
> > > This looks to me like the test runs out of log space because of all
> > > the IO completions holding transaction reservations waiting on the
> > > ILOCK, whilst the ILOCK holder can't get enough log space to regrant
> > > on transaction roll to continue the transaction.
> > 
> > Agreed.
> > 
> > Why are we calling xlog_grant_head_check from within
> > xfs_reflink_end_atomic_cow?  I think the reason for doing that is
> > because we've exhausted t_cnt in the ticket (i.e. we've already rolled
> > more than tr_logcount times).
> > 
> > Oh.  tr_atomic_ioend.tr_logcount is 5 on a rmap+reflink filesystem,
> > which it inherits from tr_itruncate.  However, tr_itruncate is only
> > intended to remove two extents from a file, so it only needs 5 rolls.
> > Coincidentally we calculate 5 rolls for each atomic extent remapping
> > operation.
> > 
> > For atomic write ioends, what if we increased tr_logcount to 5x the
> > number of remappings that would have to occur to finish the write?
> > That would preallocate all the permanent reservation we'd need before we
> > take the ILOCK, which avoids the situation of needing to obtain more log
> > space while holding ILOCK.
> > 
> > The downside is that you'd have to limit the software awu_max even
> > further, perhaps to 40% of the log size divided by
> > (tr_logres*tr_logcount).  However, we'd still be able to handle
> > concurrent atomic writes to different parts of the file, at least until
> > fragmentation got bad.
> 
> Darrick, thanks for the idea. I wanted to try out the idea, so I cooled
> the experimental patch below. Is this what you meant? It is a very rough
> patch, and does not reflect the "limit the software awu_max even further"
> part, it is just for experiment.
> 
> Anyway, I applied this patch on top of the kernel xfs/for-next branch git
> hash 0ca15a1a1151, and repeated the test case g774. It did not hang after
> 100 times repeat, so it looks working.
> 
> 
> From c90ec246b0b9e14097b0ad1d1ef5661261dd61db Mon Sep 17 00:00:00 2001
> From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Date: Thu, 24 Sep 2026 19:08:32 +0900
> Subject: [PATCH] xfs: try out Darrick's idea for g774 hang
> 
> [experimental patch]
> 
> Darrick's idea from
> https://lore.kernel.org/linux-xfs/20260922002814.GK2705364@frogsfrogsfrogs/
> 
> The deadlock of g774 caused by grant space while holding ILOCK. To avoid the
> deadlock, allocate enough space before taking the ILOCK by increasing
> tr_logcount. 5 rolls are required for each extent, then multiply tr_logcount
> by 5.
> ---
>  fs/xfs/xfs_reflink.c | 33 ++++++++++++++++++++++++++++++++-
>  1 file changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 48013613663..9d3da713a01 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1020,6 +1020,28 @@ xfs_reflink_end_cow(
>  	return error;
>  }
>  
> +/*
> + * Number of transaction rolls needed to remap a single extent during an atomic
> + * write ioend.
> + */
> +#define XFS_ATOMIC_IOEND_ROLLS	5
> +
> +/*
> + * Compute the number of log operations to reserve for an atomic write ioend
> + * that remaps @blockcount blocks with a @logres byte reservation.
> + */
> +STATIC int
> +xfs_calc_atomic_write_ioend_logcount(
> +	struct xfs_mount	*mp,
> +	xfs_extlen_t		blockcount,
> +	unsigned int		logres)
> +{
> +	if (blockcount == 0 || logres == 0)
> +		return M_RES(mp)->tr_atomic_ioend.tr_logcount;
> +
> +	return blockcount * XFS_ATOMIC_IOEND_ROLLS;
> +}
> +
>  /*
>   * Fully remap all of the file's data fork at once, which is the critical part
>   * in achieving atomic behaviour.
> @@ -1036,6 +1058,7 @@ xfs_reflink_end_atomic_cow(
>  	xfs_fileoff_t			end_fsb;
>  	int				error = 0;
>  	struct xfs_mount		*mp = ip->i_mount;
> +	struct xfs_trans_res		resv = M_RES(mp)->tr_atomic_ioend;
>  	struct xfs_trans		*tp;
>  	unsigned int			resblks;
>  
> @@ -1051,7 +1074,15 @@ xfs_reflink_end_atomic_cow(
>  	resblks = (end_fsb - offset_fsb) *
>  			XFS_NEXTENTADD_SPACE_RES(mp, 1, XFS_DATA_FORK);
>  
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_atomic_ioend, resblks, 0,
> +	/*
> +	 * Reserve enough log operations to remap every block of this write
> +	 * before we take ILOCK, so that no roll below has to wait for grant
> +	 * space while holding ILOCK.
> +	 */
> +	resv.tr_logcount = xfs_calc_atomic_write_ioend_logcount(mp,
> +			end_fsb - offset_fsb, resv.tr_logres);
> +
> +	error = xfs_trans_alloc(mp, &resv, resblks, 0,
>  			XFS_TRANS_RESERVE, &tp);
>  	if (error)
>  		return error;

Yeah, I think you're on the right track with the dynamic tr_logcount
changes but I wonder if you want to constrain the max software atomic
write size so that we don't end up with gigantic chains that consume
significant portions of the log for a single write?

Admittedly I see the multi-megabyte atomic write limits and marvel at
how far we've drifted from the original requirements.

--D

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 1c20a7c27aa1bf..2e84544cd22a0a 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -1473,6 +1473,10 @@ xfs_calc_max_atomic_write_fsblocks(
        struct xfs_mount                *mp)
 {
        const struct xfs_trans_res      *resv = &M_RES(mp)->tr_atomic_ioend;
+       const unsigned int              max_log_bytes =
+               XFS_FSB_TO_B(mp, mp->m_sb.sb_logblocks * 10 / 4);
+       const unsigned int              log_bytes_per_aw_block =
+               (resv->tr_logres * resv->tr_logcount * 5) / 4;
        unsigned int                    per_intent = 0;
        unsigned int                    step_size = 0;
        unsigned int                    ret = 0;
@@ -1483,6 +1487,9 @@ xfs_calc_max_atomic_write_fsblocks(
 
                if (resv->tr_logres >= step_size)
                        ret = (resv->tr_logres - step_size) / per_intent;
+
+               if (ret > 0 && log_bytes_per_aw_block > max_log_bytes / ret)
+                       ret = max_log_bytes / log_bytes_per_aw_block;
        }
 
        trace_xfs_calc_max_atomic_write_fsblocks(mp, per_intent, step_size,

