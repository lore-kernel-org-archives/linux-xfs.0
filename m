Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o39M2Lf5142400 for <xfs@oss.sgi.com>; Fri, 9 Apr 2010 17:02:22 -0500
Subject: Re: [PATCH] enable inode64 by default when possible
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4B7309D7.5090800@sandeen.net>
References: <4B7309D7.5090800@sandeen.net>
Date: Fri, 09 Apr 2010 17:01:39 -0500
Message-ID: <1270850499.7840.25.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, 2010-02-10 at 13:32 -0600, Eric Sandeen wrote:
> Taking another swing at this.
> 
> As XFS continues to position itself as the choice for very
> large Linux filesystems, we need to be mindful of the problems
> that the 32-bit inode restriction can cause with allocations
> and performance.
> 
> As such, this patch changes the default to inode64 whenever
> XFS_BIG_INUMS is set, which in turn depends on either
> CONFIG_LBDAF or 64-bit longs.
> 
> Going forward, we may wish to do this unconditionally for all
> filesystems by choosing CONFIG_LBDAF by default when xfs is
> chosen, but I'll leave that for later.
> 
> This patch adds a "noinode64" option for backwards compatibility.

OK, it's been about two months since Eric proposed this, and
I'm finally getting around to writing up a response.

I discussed this with a few people within SGI, and there were
two main concerns that were mentioned:
- This may be a problem for some NFS clients
- This may be a problem for some backup software
We don't believe there are any direct issues with DMF or CXFS
in making this change.

I understand that the change is only in the default behavior,
and that forcing 32-bit inodes will still be an available
option.

On NFS, there is a "fileid" automatic variable in nfs_do_filldir()
that holds the inode number, and that variable was not made to
have an explicitly 64-bit type (it had been "unsigned long")
until Linux 2.6.24.  Therefore, on 32-bit systems prior to that
release there may be problems with 64-bit inodes.

On backup software, there was at one time a restriction with
EMC Networker backup that required that only 32-bit inodes be
used in a file system in order to work correctly.  This was
reportedly a very difficult requirement to work around.  (I
made a small effort to get confirmation that this either is
still the case--or that it has since been resolved--but so
far I don't know the answer.)

There could be other issues, but the point is that there do
exist "reasonable" scenarios that still require that the
file system enforce all inode numbers fit into 32 bits.

There is no on-disk recording of whether any >32-bit
inode numbers are already allocated in a given XFS file
system (although a scan of inodes on large file systems
could determine whether any is in use).  There is also
no way for user space (or NFS for that matter) to query
whether a particular file system has inodes that require
>32 bits to represent.  So at this point it's not possible
for scenarios that have 32-bit inode number requirements
to defend themselves against a file system that doesn't
satisfy the requirement.

I am in favor of changing the default as you propose.
There's no reason we couldn't add the new "32-bit inodes"
mount option first before changing which is used by default.

I would really like to develop a way to indicate
whether a given file system uses large (>32 bit) inode
numbers, and have an implementation in place before
committing to the 64-bit default.  We could record
a ">32 bit inode present" condition on the superblock
somehow, or otherwise determine it at mount time,
for example.  Applications may find it useful to
expose this information to user space as well.

Beyond that, my only comment on your patch is that I
think I'd prefer "inode32" rather than "noinode64" as
the name of the new mount option, and choose an
appropriate mechanism for selecting which or rejecting
a mount if both are specified.

What do you think?

                                      -Alex

> (Minor update to documentation for "nobarrier" as well, which
> had not been previously documented).
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
> 
> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> index 9878f50..05b845a 100644
> --- a/Documentation/filesystems/xfs.txt
> +++ b/Documentation/filesystems/xfs.txt
> @@ -37,7 +37,10 @@ When mounting an XFS filesystem, the following options are accepted.
>  	Enables the use of block layer write barriers for writes into
>  	the journal and unwritten extent conversion.  This allows for
>  	drive level write caching to be enabled, for devices that
> -	support write barriers.
> +	support write barriers.  This is the default.
> +
> +  nobarrier
> +	Disables the use of block layer write barriers.
>  
>    dmapi
>  	Enable the DMAPI (Data Management API) event callouts.
> @@ -66,8 +69,16 @@ When mounting an XFS filesystem, the following options are accepted.
>  	Indicates that XFS is allowed to create inodes at any location
>  	in the filesystem, including those which will result in inode
>  	numbers occupying more than 32 bits of significance.  This is
> -	provided for backwards compatibility, but causes problems for
> -	backup applications that cannot handle large inode numbers.
> +	the default for 64-bit or CONFIG_LBDAF kernels as of 2.6.33.
> +
> +  noinode64
> +	Indicates that XFS must create inodes in filesystem locations
> +	which will not result in inode numbers occupying more than 32
> +	bits of significance.  This is provided for backwards compatibility,
> +	for 32-bit applications which may not use the 64-bit stat interface,
> +	such as backup applications that cannot handle large inode numbers.
> +	Note that this only affects new inode creation; existing 64-bit
> +	inode locations are unaffected.
>  
>    largeio/nolargeio
>  	If "nolargeio" is specified, the optimal I/O reported in
> diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
> index 97c0f5a..7c74965 100644
> --- a/fs/xfs/linux-2.6/xfs_super.c
> +++ b/fs/xfs/linux-2.6/xfs_super.c
> @@ -95,6 +95,7 @@ mempool_t *xfs_ioend_pool;
>  #define MNTOPT_NOBARRIER "nobarrier"	/* .. disable */
>  #define MNTOPT_OSYNCISOSYNC "osyncisosync" /* o_sync is REALLY o_sync */
>  #define MNTOPT_64BITINODE   "inode64"	/* inodes can be allocated anywhere */
> +#define MNTOPT_32BITINODE   "noinode64"	/* inodes allocated in 32-bit range */
>  #define MNTOPT_IKEEP	"ikeep"		/* do not free empty inode clusters */
>  #define MNTOPT_NOIKEEP	"noikeep"	/* free empty inode clusters */
>  #define MNTOPT_LARGEIO	   "largeio"	/* report large I/O sizes in stat() */
> @@ -196,7 +197,9 @@ xfs_parseargs(
>  	 */
>  	mp->m_flags |= XFS_MOUNT_BARRIER;
>  	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
> +#ifndef XFS_BIG_INUMS
>  	mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> +#endif
>  
>  	/*
>  	 * These can be overridden by the mount option parsing.
> @@ -317,6 +320,8 @@ xfs_parseargs(
>  				this_char);
>  			return EINVAL;
>  #endif
> +		} else if (!strcmp(this_char, MNTOPT_32BITINODE)) {
> +			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
>  		} else if (!strcmp(this_char, MNTOPT_NOUUID)) {
>  			mp->m_flags |= XFS_MOUNT_NOUUID;
>  		} else if (!strcmp(this_char, MNTOPT_BARRIER)) {
> @@ -534,6 +539,7 @@ xfs_showargs(
>  		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
>  		{ XFS_MOUNT_DMAPI,		"," MNTOPT_DMAPI },
>  		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
> +		{ XFS_MOUNT_SMALL_INUMS,	"," MNTOPT_32BITINODE },
>  		{ 0, NULL }
>  	};
>  	static struct proc_xfs_info xfs_info_unset[] = {
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
