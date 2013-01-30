Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 48A657F4E
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 19:04:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 833D0AC001
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 17:04:39 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	RDwZXrIEGvPQkd5F for <xfs@oss.sgi.com>;
	Tue, 29 Jan 2013 17:04:37 -0800 (PST)
Date: Wed, 30 Jan 2013 12:04:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: add agskip=value mount option
Message-ID: <20130130010430.GE7255@disturbed.disaster>
References: <20130129153914.801475275@sgi.com>
	<20130129153914.976867239@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130129153914.976867239@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: rjohnston@sgi.com
Cc: xfs@oss.sgi.com

On Tue, Jan 29, 2013 at 09:39:15AM -0600, rjohnston@sgi.com wrote:
> The agskip mount option specifies  the allocation group, (AG) for a new
> file, relative to the start of the last created file. agskip has the
> opposite effect of the rotorstep  system tunable  parameter.   Each
> new  file  to  be placed in the location lastAG + agskipValue,
> where lastAG is the allocation group of the last created file.
> 
> For example, agskip=3 means each new file will be  allocated  three  AGs  away
> from the starting AG of the most recently created file.

What problem is this intended to solve? What are the limits to useful
values of the mount option for solving that problem?

> The agskip mount option disables the rotorstep system tunable parameter.

I think that's wrong. The both can co-exist, and I can see use cases
where you'd actually want both to be active on inode32 systems.
Specifying the size of the skip between each "rotorstep" should not
disable the number of files in each rotorstep....

> Signed-off-by: Rich Johnston <rjohnston@sgi.com> 
> ---
>  fs/xfs/xfs_alloc.c      |   35 ++++++++++++++++++++++++++++-------
>  fs/xfs/xfs_filestream.c |    8 +++++++-
>  fs/xfs/xfs_mount.c      |    1 +
>  fs/xfs/xfs_mount.h      |    4 +++-
>  fs/xfs/xfs_super.c      |   13 ++++++++++++-
>  5 files changed, 51 insertions(+), 10 deletions(-)
> 
> Index: b/fs/xfs/xfs_alloc.c
> ===================================================================
> --- a/fs/xfs/xfs_alloc.c
> +++ b/fs/xfs/xfs_alloc.c
> @@ -2365,12 +2365,20 @@ xfs_alloc_vextent(
>  		 * Try near allocation first, then anywhere-in-ag after
>  		 * the first a.g. fails.
>  		 */
> -		if ((args->userdata  == XFS_ALLOC_INITIAL_USER_DATA) &&
> -		    (mp->m_flags & XFS_MOUNT_32BITINODES)) {
> -			args->fsbno = XFS_AGB_TO_FSB(mp,
> -					((mp->m_agfrotor / rotorstep) %
> -					mp->m_sb.sb_agcount), 0);
> -			bump_rotor = 1;
> +		if (args->userdata == XFS_ALLOC_INITIAL_USER_DATA) {
> +			if (mp->m_flags & XFS_MOUNT_AGSKIP) {
> +				spin_lock(&mp->m_agfrotor_lock);
> +				args->fsbno = XFS_AGB_TO_FSB(mp,
> +					mp->m_agfrotor, 0);
> +				mp->m_agfrotor = (mp->m_agfrotor + mp->m_agskip)
> +					% mp->m_sb.sb_agcount;
> +				spin_unlock(&mp->m_agfrotor_lock);

Why are you changing the inode64 allocator behaviour like this? The
whole point of inode64 is that it allocates data close to the owner
inode and this breaks that association. Perhaps this modification to
the initial data allocation should still only be applied to the
inode32 allocator.

Indeed, if we want the inode64 allocator to have this behaviour,
then we should be applying the agskip parameter to the inode
allocator, not the data extent allocator. i.e to the agirotor in
xfs_ialloc_next_ag(). This will retain the data/metadata locality
properties of the inode64 allocator, yet still give the benefits of
an agskip allocation parameter to move the locality of entire
directories.

....

> @@ -2385,8 +2393,21 @@ xfs_alloc_vextent(
>  			/*
>  			 * Start with the last place we left off.
>  			 */
> -			args->agno = sagno = (mp->m_agfrotor / rotorstep) %
> +                        if (mp->m_flags & XFS_MOUNT_AGSKIP) {
> +				/*
> +				 * The spinlock makes the combined assignment
> +				 * of args->fsbno and mp->m_agfrotor atomic.
> +				 * mp->m_agfrotor can not be advanced until
> +				 * args->fsbno is assigned.
> +				*/
> +                                spin_lock(&mp->m_agfrotor_lock);
> +                                sagno = mp->m_agfrotor;
> +                                spin_unlock(&mp->m_agfrotor_lock);

There's whitespace damage there, and the comment doesn't make any
sense. Reading mp->m_agfrotor will always be an atomic access.

Also, there's nothing to stop you getting the "wrong" rotor value
here. i.e.

	thread 1	thread 2
	lock
	calc agfrotor
	unlock
			lock
			calc agfrotor
			unlock
	lock
	sagno = agfrotor
	unlock
			lock
			sagno = agfrotor
			unlock

And hence both allocations end up with the same start AG at twice
the distance of the skip value. I doubt this is what you intend.

....

> @@ -622,7 +622,13 @@ xfs_filestream_associate(
>  	 * Set the starting AG using the rotor for inode32, otherwise
>  	 * use the directory inode's AG.
>  	 */
> -	if (mp->m_flags & XFS_MOUNT_32BITINODES) {
> +	if (mp->m_flags & XFS_MOUNT_AGSKIP) {
> +		spin_lock(&mp->m_agfrotor_lock);
> +		startag = mp->m_agfrotor;
> +		mp->m_agfrotor = (mp->m_agfrotor + mp->m_agskip)
> +			% mp->m_sb.sb_agcount;
> +		spin_unlock(&mp->m_agfrotor_lock);
> +	} else if (mp->m_flags & XFS_MOUNT_32BITINODES) {
>  		rotorstep = xfs_rotorstep;
>  		startag = (mp->m_agfrotor / rotorstep) % mp->m_sb.sb_agcount;
>  		mp->m_agfrotor = (mp->m_agfrotor + 1) %

Please encapsulate all this agf rotor stuff in helper functions so
we don't duplicate logic all over the place...

....
> +		} else if (!strcmp(this_char, MNTOPT_AGSKIP)) {
> +			if (!value || !*value) {
> +				xfs_warn(mp,
> +					"%s option requires an argument",
> +					this_char);
> +				return EINVAL;
> +			}
> +			mp->m_flags |= XFS_MOUNT_AGSKIP;
> +			mp->m_agskip = simple_strtoul(value, &eov, 10);
>  		} else {

Hmmm. You don't validate whether the agskip option is valid for the
current filesystem configuration. What is a valid value for an
arbitrary configuration, and how can the filesystem validate it is
sensible?

>  			xfs_warn(mp, "unknown mount option [%s].", this_char);
>  			return EINVAL;
> @@ -567,6 +576,8 @@ xfs_showargs(
>  
>  	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
>  		seq_puts(m, "," MNTOPT_NOQUOTA);
> +	if (mp->m_flags & XFS_MOUNT_AGSKIP)
> +		seq_printf(m, "," MNTOPT_AGSKIP "=%d", mp->m_agskip);
>  
>  	return 0;
>  }

Overall, I'm wondering if this is the right way to approach this
problem. It only really works correctly (in terms of distribution of
files/metadata) for fixed volume sizes (i.e. homogenous layouts) -
the common case where a skip is useful is after growing a filesystem
onto a new volume. It's rare that the new volume is the same as the
existing volumes, so it's hard to set a skip value that reliably
alternates between old and new volumes.

We talked about this allocation distribution problem last march when
we met at LSF, and I thought we agreed that pushing
agskip/agrotorstep mount options upstream was not the way we were
going to solve this problem after I outlined how I planned to solve
this problem. Indeed, I already have prototype patches for the AG control ioctls
that allow the xfs_spaceman program that associate an AG with an
"allocation zone" (an "AZ") and partially written kernel
patches that implement AZs, per-AZ agi/agf rotors and higher level AZ
iteration in the allocator.

(It also allows specification of per-AZ stripe unit/stripe width and
other allocation control parameters but those details are little
outside the scope of this particular discussion.)

IOWs, I'm close to having a significantly more capable and flexible
solution to this problem that doesn't require new mount options to
be added or on-disk format changes to be made. As such, I'm not sure
that we want to introduce a mount option that is only a partial
solution to the problem. We basically can't remove mount options
once they have been added, so introducing a new mount option just to
mark it deprecated in 6 months time seems like a bad idea....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
