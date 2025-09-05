Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D24D24E01D
	for <linux-xfs@vger.kernel.org>; Fri,  5 Sep 2025 08:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757061404; cv=none; b=uJEYCrPQom8UdIcHe/i3PRlZS+GmrAt3PXZU5YyexIjoaOCacsCGW/IjF5UAXcfG/5LOx82mojVdE7mV2fNMoJsSBZBb0xifH9AXX19cc1XFm48cNK/Rp+qUo3aesu2tYSFikyG9HP8NFhaKEo9I/trSLhHJ2TaYFsc0BehKXmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757061404; c=relaxed/simple;
	bh=4EhWIXJlkq/CJ36xlM5ahEh58gQsHTxYD0AfJZErzbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D/0+35OjEknqKxUQT/dooUSqcp3BfURJJQRq7nQexMugjop7H5eI0HfqvpVRUpBqGe85eRGkMfwDYb7RtgdK4iqcSbKedMr0zZ1cSuZ5QI+L7ipOmYd01HSz2tNfvCiS8LnPJi8PhgR/C6IQpEa0TuFMlhAm3dUnmm+BthGQddY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uMZxuK/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uMZxuK/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56605C4CEF1;
	Fri,  5 Sep 2025 08:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757061404;
	bh=4EhWIXJlkq/CJ36xlM5ahEh58gQsHTxYD0AfJZErzbc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uMZxuK/eZMYx9w2Q7Segned6Zo5sEG/qqcfe1A04zDO1QeaNAE47wyNLLKXRyqRqj
	 4rtBHDTGCWhLWUg/goBTUFhQh0Ct5x2u8TY0QmszQF6Nk/0ukc/0wki4UFrF6bJJpd
	 naI9886Uey7a5sAdCP5e36FhILaHe76hwOWQr9BF+dvLVm9QTx5HYOtn9nQRDh32MR
	 Iq5gaNJ8PgQvyrtKBC40pNIbkkGn0ojlQD8zgqlLLWUoeo4e0qif2J//yzcNAoLf+u
	 BH1KokgViUH/hvr3wreHeD3PFM42b902dEmvi4VNhQdJi8SU1T6jjPsUCAGm6a9+4q
	 qfXPq/XEIHwFg==
Date: Fri, 5 Sep 2025 10:36:40 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: remove deprecated sysctl knobs
Message-ID: <3t2dnifjyxmmq5turqqgwelh7l2ikpz2itfvcgxtm4flrzis36@drdsqkctggup>
References: <175691147603.1206750.9285060179974032092.stgit@frogsfrogsfrogs>
 <JnVlibx9VgaNAso8wg-V6huscmTEBLxW0nw5RcoyBn4jXczAjQM559IFyxnrvabZXc8advmwTR-Msy859VVVdw==@protonmail.internalid>
 <175691147690.1206750.4999987781735722407.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175691147690.1206750.4999987781735722407.stgit@frogsfrogsfrogs>

On Wed, Sep 03, 2025 at 08:00:24AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> These sysctl knobs were scheduled for removal in September 2025.  That
> time has come, so remove them.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/xfs_linux.h                |    2 --
>  fs/xfs/xfs_sysctl.h               |    3 ---
>  Documentation/admin-guide/xfs.rst |   26 ++++----------------------
>  fs/xfs/libxfs/xfs_inode_util.c    |   11 -----------
>  fs/xfs/xfs_globals.c              |    2 --
>  fs/xfs/xfs_iops.c                 |   12 +++++-------
>  fs/xfs/xfs_sysctl.c               |   29 +----------------------------
>  7 files changed, 10 insertions(+), 75 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index 9a2221b4aa21ed..4dd747bdbccab2 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -89,8 +89,6 @@ typedef __u32			xfs_nlink_t;
>  #undef XFS_NATIVE_HOST
>  #endif
> 
> -#define irix_sgid_inherit	xfs_params.sgid_inherit.val
> -#define irix_symlink_mode	xfs_params.symlink_mode.val

R.I.P Irix....

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


>  #define xfs_panic_mask		xfs_params.panic_mask.val
>  #define xfs_error_level		xfs_params.error_level.val
>  #define xfs_syncd_centisecs	xfs_params.syncd_timer.val
> diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
> index 51646f066c4f7d..ed9d896079c1a8 100644
> --- a/fs/xfs/xfs_sysctl.h
> +++ b/fs/xfs/xfs_sysctl.h
> @@ -19,9 +19,6 @@ typedef struct xfs_sysctl_val {
>  } xfs_sysctl_val_t;
> 
>  typedef struct xfs_param {
> -	xfs_sysctl_val_t sgid_inherit;	/* Inherit S_ISGID if process' GID is
> -					 * not a member of parent dir GID. */
> -	xfs_sysctl_val_t symlink_mode;	/* Link creat mode affected by umask */
>  	xfs_sysctl_val_t panic_mask;	/* bitmask to cause panic on errors. */
>  	xfs_sysctl_val_t error_level;	/* Degree of reporting for problems  */
>  	xfs_sysctl_val_t syncd_timer;	/* Interval between xfssyncd wakeups */
> diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> index 7ad746a3e66c25..d6f531f2c0e694 100644
> --- a/Documentation/admin-guide/xfs.rst
> +++ b/Documentation/admin-guide/xfs.rst
> @@ -289,9 +289,6 @@ The following sysctls are available for the XFS filesystem:
>  	removes unused preallocation from clean inodes and releases
>  	the unused space back to the free pool.
> 
> -  fs.xfs.speculative_cow_prealloc_lifetime
> -	This is an alias for speculative_prealloc_lifetime.
> -
>    fs.xfs.error_level		(Min: 0  Default: 3  Max: 11)
>  	A volume knob for error reporting when internal errors occur.
>  	This will generate detailed messages & backtraces for filesystem
> @@ -318,17 +315,6 @@ The following sysctls are available for the XFS filesystem:
> 
>  	This option is intended for debugging only.
> 
> -  fs.xfs.irix_symlink_mode	(Min: 0  Default: 0  Max: 1)
> -	Controls whether symlinks are created with mode 0777 (default)
> -	or whether their mode is affected by the umask (irix mode).
> -
> -  fs.xfs.irix_sgid_inherit	(Min: 0  Default: 0  Max: 1)
> -	Controls files created in SGID directories.
> -	If the group ID of the new file does not match the effective group
> -	ID or one of the supplementary group IDs of the parent dir, the
> -	ISGID bit is cleared if the irix_sgid_inherit compatibility sysctl
> -	is set.
> -
>    fs.xfs.inherit_sync		(Min: 0  Default: 1  Max: 1)
>  	Setting this to "1" will cause the "sync" flag set
>  	by the **xfs_io(8)** chattr command on a directory to be
> @@ -364,14 +350,7 @@ The following sysctls are available for the XFS filesystem:
>  Deprecated Sysctls
>  ==================
> 
> -===========================================     ================
> -  Name                                          Removal Schedule
> -===========================================     ================
> -fs.xfs.irix_sgid_inherit                        September 2025
> -fs.xfs.irix_symlink_mode                        September 2025
> -fs.xfs.speculative_cow_prealloc_lifetime        September 2025
> -===========================================     ================
> -
> +None currently.
> 
>  Removed Sysctls
>  ===============
> @@ -381,6 +360,9 @@ Removed Sysctls
>  =============================	=======
>    fs.xfs.xfsbufd_centisec	v4.0
>    fs.xfs.age_buffer_centisecs	v4.0
> +  fs.xfs.irix_symlink_mode      v6.18
> +  fs.xfs.irix_sgid_inherit      v6.18
> +  fs.xfs.speculative_cow_prealloc_lifetime      v6.18
>  =============================	=======
> 
>  Error handling
> diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
> index 48fe49a5f050f3..309ce6dd555383 100644
> --- a/fs/xfs/libxfs/xfs_inode_util.c
> +++ b/fs/xfs/libxfs/xfs_inode_util.c
> @@ -299,17 +299,6 @@ xfs_inode_init(
>  		} else {
>  			inode_init_owner(args->idmap, inode, dir, args->mode);
>  		}
> -
> -		/*
> -		 * If the group ID of the new file does not match the effective
> -		 * group ID or one of the supplementary group IDs, the S_ISGID
> -		 * bit is cleared (and only if the irix_sgid_inherit
> -		 * compatibility variable is set).
> -		 */
> -		if (irix_sgid_inherit && (inode->i_mode & S_ISGID) &&
> -		    !vfsgid_in_group_p(i_gid_into_vfsgid(args->idmap, inode)))
> -			inode->i_mode &= ~S_ISGID;
> -
>  		ip->i_projid = xfs_get_initial_prid(pip);
>  	}
> 
> diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
> index f6f628c01febaf..566fd663c95bba 100644
> --- a/fs/xfs/xfs_globals.c
> +++ b/fs/xfs/xfs_globals.c
> @@ -14,8 +14,6 @@
>   */
>  xfs_param_t xfs_params = {
>  			  /*	MIN		DFLT		MAX	*/
> -	.sgid_inherit	= {	0,		0,		1	},
> -	.symlink_mode	= {	0,		0,		1	},
>  	.panic_mask	= {	0,		0,		XFS_PTAG_MASK},
>  	.error_level	= {	0,		3,		11	},
>  	.syncd_timer	= {	1*100,		30*100,		7200*100},
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 603effabe1ee12..afd041e28bb26a 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -431,14 +431,12 @@ xfs_vn_symlink(
>  	struct dentry		*dentry,
>  	const char		*symname)
>  {
> -	struct inode	*inode;
> -	struct xfs_inode *cip = NULL;
> -	struct xfs_name	name;
> -	int		error;
> -	umode_t		mode;
> +	struct inode		*inode;
> +	struct xfs_inode	*cip = NULL;
> +	struct xfs_name		name;
> +	int			error;
> +	umode_t			mode = S_IFLNK | S_IRWXUGO;
> 
> -	mode = S_IFLNK |
> -		(irix_symlink_mode ? 0777 & ~current_umask() : S_IRWXUGO);
>  	error = xfs_dentry_mode_to_name(&name, dentry, mode);
>  	if (unlikely(error))
>  		goto out;
> diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
> index 751dc74a30671a..9918f14b4874fd 100644
> --- a/fs/xfs/xfs_sysctl.c
> +++ b/fs/xfs/xfs_sysctl.c
> @@ -50,7 +50,7 @@ xfs_panic_mask_proc_handler(
>  }
>  #endif /* CONFIG_PROC_FS */
> 
> -STATIC int
> +static inline int
>  xfs_deprecated_dointvec_minmax(
>  	const struct ctl_table	*ctl,
>  	int			write,
> @@ -67,24 +67,6 @@ xfs_deprecated_dointvec_minmax(
>  }
> 
>  static const struct ctl_table xfs_table[] = {
> -	{
> -		.procname	= "irix_sgid_inherit",
> -		.data		= &xfs_params.sgid_inherit.val,
> -		.maxlen		= sizeof(int),
> -		.mode		= 0644,
> -		.proc_handler	= xfs_deprecated_dointvec_minmax,
> -		.extra1		= &xfs_params.sgid_inherit.min,
> -		.extra2		= &xfs_params.sgid_inherit.max
> -	},
> -	{
> -		.procname	= "irix_symlink_mode",
> -		.data		= &xfs_params.symlink_mode.val,
> -		.maxlen		= sizeof(int),
> -		.mode		= 0644,
> -		.proc_handler	= xfs_deprecated_dointvec_minmax,
> -		.extra1		= &xfs_params.symlink_mode.min,
> -		.extra2		= &xfs_params.symlink_mode.max
> -	},
>  	{
>  		.procname	= "panic_mask",
>  		.data		= &xfs_params.panic_mask.val,
> @@ -185,15 +167,6 @@ static const struct ctl_table xfs_table[] = {
>  		.extra1		= &xfs_params.blockgc_timer.min,
>  		.extra2		= &xfs_params.blockgc_timer.max,
>  	},
> -	{
> -		.procname	= "speculative_cow_prealloc_lifetime",
> -		.data		= &xfs_params.blockgc_timer.val,
> -		.maxlen		= sizeof(int),
> -		.mode		= 0644,
> -		.proc_handler	= xfs_deprecated_dointvec_minmax,
> -		.extra1		= &xfs_params.blockgc_timer.min,
> -		.extra2		= &xfs_params.blockgc_timer.max,
> -	},
>  	/* please keep this the last entry */
>  #ifdef CONFIG_PROC_FS
>  	{
> 
> 
