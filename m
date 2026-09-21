Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738B92E6CB8
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 22:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790028329; cv=none; b=kMPHNxYvMVjRGQMsU5Z9AgG/xHPGs7O2JLcviooh6ftETku5Bv5RvmY679g19mrfs8KO4t/S00QG/reAUSOr6EQB8RZ7G2dIDcD/lxQ8DGRUEgCdxOeVl4aLjPG5xeuwY8VuBzad4HJxzhv5ObDix6Yop0ZOG7aX6VN3+KV2qHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790028329; c=relaxed/simple;
	bh=1JgGheblRv13iZ8hrBndzezeeBs+JLNuhhUezw2sid0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XxtoKKcBkbc0wrXXx/txCfeh2hgfulTeQvPKQVwBn5msSp5bUQMyo0em6Eqiib3WC++ZQHobSxcJkiEMFYcGScxxxa7ioT5FtmnuD7XhBa9WCvoBys4RZdSVqf7Twb6xXYkBWbuwCV5IsyYBPyaVXQ72LicHM0Y83idu6aszrco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FFndldo+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FFndldo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7501A1F000FF;
	Mon, 21 Sep 2026 22:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790028328;
	bh=6aslS+rhbbPGvoVxRSS70XNGdkB05xEH+1/k8ZUMVxQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FFndldo+tQLXFhY9g4QFp8B0i01Nl4q4qRYMdGoxTWARj/LJ/xH1f+vbfgQMICirG
	 YBmKbNiqKQj0MG3ZTAQBeoVQDrlDNsEvyT+Nw8OH+GM6o2dN6+whZAv0As6GkhnYm4
	 pTu+wnH2aCkXYANjygpjpApnBNZo34DTEXhl1acIJMI9d95Ebcrg/jsxE2RmfCADSl
	 TqHQXWhfVOoQ6LRhyP0U5T/4HBBn+c/RWxC1OK3WJd7b3NiIHa+kfRYmqrDKlld+2R
	 l4v3ANL9HGWN+7eb75GbeJ/7aobqUqL2xR3I0BIRp8lDw3r7kC/2m9q9XOod3i6RkB
	 BXOsQ9GpH5zoA==
Date: Tue, 22 Sep 2026 08:05:19 +1000
From: Dave Chinner <dgc@kernel.org>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	John Garry <john.garry@linux.dev>
Subject: Re: [bug report] fstests generic/774 hang again
Message-ID: <arGqH7adMMyhM1pi@dread>
References: <aqkP9CTUvlC2YCIb@shinmob>
 <aqsN4GOXthkF8rOI@dread>
 <aquJIL3Ztk3KBdHV@shinmob>
 <aqvER2bZyAO6H-4v@shinmob>
 <aqxag3TcgpYYVwTk@dread>
 <aq51WDjHLW3XyPR0@shinmob>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq51WDjHLW3XyPR0@shinmob>

On Sat, Sep 19, 2026 at 08:53:39PM +0900, Shin'ichiro Kawasaki wrote:
> On Sep 18, 2026 / 07:24, Dave Chinner wrote:
> > On Thu, Sep 17, 2026 at 07:45:11PM +0900, Shin'ichiro Kawasaki wrote:
> > > On Sep 17, 2026 / 15:52, Shin'ichiro Kawasaki wrote:
> > > [...]
> > > > As suggested, now I'm trying to increase the journal/log section size.
> > > > I added the mkfs options below:
> > > > 
> > > >   MKFS_OPTIONS="-l size=128m"
> > > > 
> > > > With this, I repeated the test case 30 times, and did not observe the hang.
> > > > It looks like the log section size increase avoids the hang. I will keep it on
> > > > running to see if the hang is observed after 100 times run.
> > > 
> > > The test case did not hang all through the 100 times repeated runs. Then
> > > expanding the log section from 64MiB to 128MiB avoided the hang.
> > 
> > Ok, so the fix for the moment is to make the software COW path for
> > atomic writes use IOLOCK_EXCL, rather than IOLOCK_SHARED. That will
> > result in all the IO submission blocking on the IOLOCK with no other
> > resources held rather than blocking on the ILOCK whilst holding an
> > unreleasable transaction reservation.
> 
> Thanks for the explanation and the fix suggestion. Based on the suggestion,
> I cooked a fix trial patch below [4]. I applied this patch on top of
> the xfs-linux/for-next branch kernel at the git hash 0ca15a1a115. I repeated
> the test case generic/774 100 times on the kernel, and observed no hang.
> Looks working good. I will do further testing to confirm no regression.
> Meanwhile, comments on the patch will be appreciated.
> 
> 
> [4] fix trial patch
> 
> -----------------------------------------------------------------------------
> 
> From 2d2cbd8e3424953880f6ffc8e2ed5b4f844b0822 Mon Sep 17 00:00:00 2001
> From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Date: Fri, 18 Sep 2026 00:00:00 +0900
> Subject: [PATCH] xfs: serialise software COW atomic write submission on the
>  IOLOCK
> 
> When fstests generic/774 is repeated on a 8GiB device with a 64MiB
> journal size, the test case hangs. Dozens of IO completion workers are
> blocked on the ILOCK in xfs_reflink_end_atomic_cow():
> 
>   down_write_nested+0x1c0/0x1f0
>   xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
>   xfs_dio_write_end_io+0x4b7/0x650 [xfs]
>   iomap_dio_complete+0x140/0xb20
>   iomap_dio_complete_work+0x58/0x90
>   process_one_work+0x947/0x1760
> 
> while the ILOCK holder is waiting for journal space:
> 
>   xlog_grant_head_wait+0x175/0xac0 [xfs]
>   xlog_grant_head_check+0x312/0x3f0 [xfs]
>   xfs_log_regrant+0x380/0x7d0 [xfs]
>   xfs_trans_roll+0x2d9/0x420 [xfs]
>   xfs_defer_trans_roll+0x11e/0x4b0 [xfs]
>   xfs_defer_finish_noroll+0x460/0xe70 [xfs]
>   xfs_trans_commit+0xfc/0x180 [xfs]
>   xfs_reflink_end_atomic_cow+0x3b2/0x560 [xfs]
>   xfs_dio_write_end_io+0x4b7/0x650 [xfs]
> 
> Each atomic write software COW submitter allocates around 1.6MiB of
> journal resource under ILOCK. When a few dozen of atomic writes are
> submitted, it is enough to run out of the 64MiB journal size. This
> caused the deadlock between ILOCK and the journal resource.
> 
> To avoid the deadlock, take the IOLOCK exclusively at the atomic write
> software COW submission. This serializes the submission in the IO path,
> so concurrent atomic writes block on the IOLOCK holding no other
> resources.
> 
> Fixes: 9baeac3ab1f8 ("xfs: add xfs_file_dio_write_atomic()")
> Closes: https://lore.kernel.org/linux-xfs/aqkP9CTUvlC2YCIb@shinmob/
> Suggested-by: Dave Chinner <dgc@kernel.org>
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  fs/xfs/xfs_file.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 426a67b813a..8d10ae22884 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -829,7 +829,7 @@ xfs_file_dio_write_atomic(
>  	struct kiocb		*iocb,
>  	struct iov_iter		*from)
>  {
> -	unsigned int		iolock = XFS_IOLOCK_SHARED;
> +	unsigned int		iolock;
>  	ssize_t			ret, ocount = iov_iter_count(from);
>  	unsigned int		dio_flags = 0;
>  	const struct iomap_ops	*dops;
> @@ -844,6 +844,17 @@ xfs_file_dio_write_atomic(
>  		dops = &xfs_direct_write_iomap_ops;
>  
>  retry:
> +	/*
> +	 * Concurrent atomic write COW submissions under ILOCK can run out
> +	 * journal reservation resource and can deadlock with the IO
> +	 * completions. To avoid the deadlock, serialize submissions of
> +	 * atomic write COW by taking IOLOCK exclusively.
> +	 */
> +	if (dops == &xfs_atomic_write_cow_iomap_ops)
> +		iolock = XFS_IOLOCK_EXCL;
> +	else
> +		iolock = XFS_IOLOCK_SHARED;
> +
>  	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
>  	if (ret)
>  		return ret;

Urk, that's pretty nasty.

> @@ -853,7 +864,8 @@ xfs_file_dio_write_atomic(
>  		goto out_unlock;
>  
>  	/* Demote similar to xfs_file_dio_write_aligned() */
> -	if (iolock == XFS_IOLOCK_EXCL) {
> +	if (iolock == XFS_IOLOCK_EXCL &&
> +	    dops != &xfs_atomic_write_cow_iomap_ops) {
>  		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
>  		iolock = XFS_IOLOCK_SHARED;
>  	}

And at this point, we now have several atomic write cow ops specific
operations in this function (locking, the retry loop, etc).

This feels much more like there should be a separate function for
the software cow path, and the fast path simply calls it on
ENOPROTOOPT from the dio submission. That gets rid of all the
conditionals and looping from the fast path. i.e

	if (ocount > xfs_inode_buftarg(ip)->bt_awu_maxocount)
		return xfs_file_dio_write_atomic_cow();

	/* do normal DIO write */

	if (error == -ENOPROTOOPT)
		return xfs_file_dio_write_atomic_cow();
	return error;


That essentially makes xfs_file_dio_write_atomic() and
xfs_file_dio_write_aligned() the same code, except for the above two
checks, hence they could easily be collapsed back into a common
implementation is:

	if ((iocb->ki_flags & IOCB_ATOMIC) &&
	    ocount > xfs_inode_buftarg(ip)->bt_awu_maxocount)
		return xfs_file_dio_write_atomic_cow();

	/* do normal DIO write */

	if (error == -ENOPROTOOPT)
		return xfs_file_dio_write_atomic_cow();
	return error;

That seems like a much more natural breakdown that the current
duplication of the DIO write submission code...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
