Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 21:10:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8U4AUgS002662
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 21:10:30 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B14A496414
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 21:12:06 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id SUiGGQqBsdpjx0Ex for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 21:12:06 -0700 (PDT)
Date: Tue, 30 Sep 2008 14:11:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Increase the default size of the reserved blocks pool
Message-ID: <20080930041149.GA23915@disturbed>
References: <48E097B5.3010906@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E097B5.3010906@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Sep 29, 2008 at 06:54:13PM +1000, Lachlan McIlroy wrote:
> The current default size of the reserved blocks pool is easy to deplete
> with certain workloads, in particular workloads that do lots of concurrent
> delayed allocation extent conversions.  If enough transactions are running
> in parallel and the entire pool is consumed then subsequent calls to
> xfs_trans_reserve() will fail with ENOSPC.  Also add a rate limited
> warning so we know if this starts happening again.
>
> --- a/fs/xfs/xfs_mount.c	2008-09-29 18:30:26.000000000 +1000
> +++ b/fs/xfs/xfs_mount.c	2008-09-29 18:27:37.000000000 +1000
> @@ -1194,7 +1194,7 @@ xfs_mountfs(
> 	 */
> 	resblks = mp->m_sb.sb_dblocks;
> 	do_div(resblks, 20);
> -	resblks = min_t(__uint64_t, resblks, 1024);
> +	resblks = min_t(__uint64_t, resblks, 16384);

I'm still not convinced such a large increase is needed for average
case. This means that at a filesystem size of 5GB we are reserving
256MB (5%) for a corner case workload that is unlikely to be run on a
5GB filesystem. That is a substantial reduction in space for such
a filesystem, and quite possibly will drive systems into immediate
ENOSPC at mount. At that point stuff is going to fail badly during
boot.

Indeed - this will ENOSPC the root drive on my laptop the moment I
apply it (6GB root, 200MB free) and reboot, as well as my main
server (4GB root - 150MB free, 2GB /var - 100MB free, etc).
On that basis alone, I'd suggest this is a bad change to make to the
default value of the reserved block pool.

> 	error = xfs_reserve_blocks(mp, &resblks, NULL);
> 	if (error)
> 		cmn_err(CE_WARN, "XFS: Unable to allocate reserve blocks. "
> @@ -1483,6 +1483,7 @@ xfs_mod_incore_sb_unlocked(
> 	int		scounter;	/* short counter for 32 bit fields */
> 	long long	lcounter;	/* long counter for 64 bit fields */
> 	long long	res_used, rem;
> +	static int	depleted = 0;
>
> 	/*
> 	 * With the in-core superblock spin lock held, switch
> @@ -1535,6 +1536,9 @@ xfs_mod_incore_sb_unlocked(
> 				if (rsvd) {
> 					lcounter = (long long)mp->m_resblks_avail + delta;
> 					if (lcounter < 0) {
> +						if ((depleted % 100) == 0)
> +							printk(KERN_DEBUG "XFS reserved blocks pool depleted.\n");
> +						depleted++;
> 						return XFS_ERROR(ENOSPC);
> 					}

This should use the generic printk ratelimiter, and the error message
should use xfs_fs_cmn_err() to indicate what filesystem the error
is occuring on. ie.:

	if (printk_ratelimit())
		xfs_fs_cmn_err(CE_WARN, mp,
				"ENOSPC: reserved block pool empty");

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
