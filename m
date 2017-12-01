Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18757 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751031AbdLAXCI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Dec 2017 18:02:08 -0500
Date: Fri, 1 Dec 2017 15:02:00 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/4] xfs: move all scrub input checking to
 xfs_scrub_validate
Message-ID: <20171201230200.GC21412@magnolia>
References: <2f4bb05f-fd41-7fa3-22f0-9ec9d2224a47@redhat.com>
 <b60a6557-ca8c-6118-8013-09677d529adb@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b60a6557-ca8c-6118-8013-09677d529adb@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Dec 01, 2017 at 04:15:04PM -0600, Eric Sandeen wrote:
> There were ad-hoc checks for some scrub types but not others;
> mark each scrub type with ... it's type, and use that to validate
> the allowed and/or required input fields.
> 
> Moving these checks out of xfs_scrub_setup_ag_header makes it
> a thin wrapper, so unwrap it in the process.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> enum scrub_type should probably go somewhere shared ...?
> 
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index 2a9b4f9..b599358 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -37,23 +37,6 @@
>  #include "scrub/common.h"
>  #include "scrub/trace.h"
>  
> -/*
> - * Set up scrub to check all the static metadata in each AG.
> - * This means the SB, AGF, AGI, and AGFL headers.
> - */
> -int
> -xfs_scrub_setup_ag_header(
> -	struct xfs_scrub_context	*sc,
> -	struct xfs_inode		*ip)
> -{
> -	struct xfs_mount		*mp = sc->mp;
> -
> -	if (sc->sm->sm_agno >= mp->m_sb.sb_agcount ||
> -	    sc->sm->sm_ino || sc->sm->sm_gen)
> -		return -EINVAL;
> -	return xfs_scrub_setup_fs(sc, ip);
> -}
> -
>  /* Walk all the blocks in the AGFL. */
>  int
>  xfs_scrub_walk_agfl(
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index ac95fe9..98452ad 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -472,7 +472,7 @@
>  			return error;
>  	}
>  
> -	error = xfs_scrub_setup_ag_header(sc, ip);
> +	error = xfs_scrub_setup_fs(sc, ip);
>  	if (error)
>  		return error;
>  
> @@ -507,14 +507,6 @@
>  	struct xfs_inode		*ip = NULL;
>  	int				error;
>  
> -	/*
> -	 * If userspace passed us an AG number or a generation number
> -	 * without an inode number, they haven't got a clue so bail out
> -	 * immediately.
> -	 */
> -	if (sc->sm->sm_agno || (sc->sm->sm_gen && !sc->sm->sm_ino))
> -		return -EINVAL;
> -
>  	/* We want to scan the inode we already had opened. */
>  	if (sc->sm->sm_ino == 0 || sc->sm->sm_ino == ip_in->i_ino) {
>  		sc->ip = ip_in;
> diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
> index 5c04385..fe12053 100644
> --- a/fs/xfs/scrub/common.h
> +++ b/fs/xfs/scrub/common.h
> @@ -78,8 +78,6 @@ void xfs_scrub_fblock_set_warning(struct xfs_scrub_context *sc, int whichfork,
>  
>  /* Setup functions */
>  int xfs_scrub_setup_fs(struct xfs_scrub_context *sc, struct xfs_inode *ip);
> -int xfs_scrub_setup_ag_header(struct xfs_scrub_context *sc,
> -			      struct xfs_inode *ip);
>  int xfs_scrub_setup_ag_allocbt(struct xfs_scrub_context *sc,
>  			       struct xfs_inode *ip);
>  int xfs_scrub_setup_ag_iallocbt(struct xfs_scrub_context *sc,
> diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> index 2eac160..4587853 100644
> --- a/fs/xfs/scrub/quota.c
> +++ b/fs/xfs/scrub/quota.c
> @@ -67,13 +67,6 @@
>  {
>  	uint				dqtype;
>  
> -	/*
> -	 * If userspace gave us an AG number or inode data, they don't
> -	 * know what they're doing.  Get out.
> -	 */
> -	if (sc->sm->sm_agno || sc->sm->sm_ino || sc->sm->sm_gen)
> -		return -EINVAL;
> -
>  	dqtype = xfs_scrub_quota_to_dqtype(sc);
>  	if (dqtype == 0)
>  		return -EINVAL;
> diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
> index c6fedb6..6860d5d 100644
> --- a/fs/xfs/scrub/rtbitmap.c
> +++ b/fs/xfs/scrub/rtbitmap.c
> @@ -43,22 +43,14 @@
>  	struct xfs_scrub_context	*sc,
>  	struct xfs_inode		*ip)
>  {
> -	struct xfs_mount		*mp = sc->mp;
> -	int				error = 0;
> -
> -	/*
> -	 * If userspace gave us an AG number or inode data, they don't
> -	 * know what they're doing.  Get out.
> -	 */
> -	if (sc->sm->sm_agno || sc->sm->sm_ino || sc->sm->sm_gen)
> -		return -EINVAL;
> +	int				error;
>  
>  	error = xfs_scrub_setup_fs(sc, ip);
>  	if (error)
>  		return error;
>  
>  	sc->ilock_flags = XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP;
> -	sc->ip = mp->m_rbmip;
> +	sc->ip = sc->mp->m_rbmip;
>  	xfs_ilock(sc->ip, sc->ilock_flags);
>  
>  	return 0;
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index 16932f9..6899126 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -129,8 +129,6 @@
>  {
>  	int				error = 0;
>  
> -	if (sc->sm->sm_ino || sc->sm->sm_agno)
> -		return -EINVAL;
>  	if (xfs_scrub_should_terminate(sc, &error))
>  		return error;
>  
> @@ -169,105 +167,129 @@
>  
>  static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
>  	[XFS_SCRUB_TYPE_PROBE] = {	/* ioctl presence test */
> +		.type	= ST_NONE,
>  		.setup	= xfs_scrub_setup_fs,
>  		.scrub	= xfs_scrub_probe,
>  	},
>  	[XFS_SCRUB_TYPE_SB] = {		/* superblock */
> -		.setup	= xfs_scrub_setup_ag_header,
> +		.type	= ST_PERAG,
> +		.setup	= xfs_scrub_setup_fs,
>  		.scrub	= xfs_scrub_superblock,
>  	},
>  	[XFS_SCRUB_TYPE_AGF] = {	/* agf */
> -		.setup	= xfs_scrub_setup_ag_header,
> +		.type	= ST_PERAG,
> +		.setup	= xfs_scrub_setup_fs,
>  		.scrub	= xfs_scrub_agf,
>  	},
>  	[XFS_SCRUB_TYPE_AGFL]= {	/* agfl */
> -		.setup	= xfs_scrub_setup_ag_header,
> +		.type	= ST_PERAG,
> +		.setup	= xfs_scrub_setup_fs,
>  		.scrub	= xfs_scrub_agfl,
>  	},
>  	[XFS_SCRUB_TYPE_AGI] = {	/* agi */
> -		.setup	= xfs_scrub_setup_ag_header,
> +		.type	= ST_PERAG,
> +		.setup	= xfs_scrub_setup_fs,
>  		.scrub	= xfs_scrub_agi,
>  	},
>  	[XFS_SCRUB_TYPE_BNOBT] = {	/* bnobt */
> +		.type	= ST_PERAG,
>  		.setup	= xfs_scrub_setup_ag_allocbt,
>  		.scrub	= xfs_scrub_bnobt,
>  	},
>  	[XFS_SCRUB_TYPE_CNTBT] = {	/* cntbt */
> +		.type	= ST_PERAG,
>  		.setup	= xfs_scrub_setup_ag_allocbt,
>  		.scrub	= xfs_scrub_cntbt,
>  	},
>  	[XFS_SCRUB_TYPE_INOBT] = {	/* inobt */
> +		.type	= ST_PERAG,
>  		.setup	= xfs_scrub_setup_ag_iallocbt,
>  		.scrub	= xfs_scrub_inobt,
>  	},
>  	[XFS_SCRUB_TYPE_FINOBT] = {	/* finobt */
> +		.type	= ST_PERAG,
>  		.setup	= xfs_scrub_setup_ag_iallocbt,
>  		.scrub	= xfs_scrub_finobt,
>  		.has	= xfs_sb_version_hasfinobt,
>  	},
>  	[XFS_SCRUB_TYPE_RMAPBT] = {	/* rmapbt */
> +		.type	= ST_PERAG,
>  		.setup	= xfs_scrub_setup_ag_rmapbt,
>  		.scrub	= xfs_scrub_rmapbt,
>  		.has	= xfs_sb_version_hasrmapbt,
>  	},
>  	[XFS_SCRUB_TYPE_REFCNTBT] = {	/* refcountbt */
> +		.type	= ST_PERAG,
>  		.setup	= xfs_scrub_setup_ag_refcountbt,
>  		.scrub	= xfs_scrub_refcountbt,
>  		.has	= xfs_sb_version_hasreflink,
>  	},
>  	[XFS_SCRUB_TYPE_INODE] = {	/* inode record */
> +		.type	= ST_INODE,
>  		.setup	= xfs_scrub_setup_inode,
>  		.scrub	= xfs_scrub_inode,
>  	},
>  	[XFS_SCRUB_TYPE_BMBTD] = {	/* inode data fork */
> +		.type	= ST_INODE,
>  		.setup	= xfs_scrub_setup_inode_bmap,
>  		.scrub	= xfs_scrub_bmap_data,
>  	},
>  	[XFS_SCRUB_TYPE_BMBTA] = {	/* inode attr fork */
> +		.type	= ST_INODE,
>  		.setup	= xfs_scrub_setup_inode_bmap,
>  		.scrub	= xfs_scrub_bmap_attr,
>  	},
>  	[XFS_SCRUB_TYPE_BMBTC] = {	/* inode CoW fork */
> +		.type	= ST_INODE,
>  		.setup	= xfs_scrub_setup_inode_bmap,
>  		.scrub	= xfs_scrub_bmap_cow,
>  	},
>  	[XFS_SCRUB_TYPE_DIR] = {	/* directory */
> +		.type	= ST_INODE,
>  		.setup	= xfs_scrub_setup_directory,
>  		.scrub	= xfs_scrub_directory,
>  	},
>  	[XFS_SCRUB_TYPE_XATTR] = {	/* extended attributes */
> +		.type	= ST_INODE,
>  		.setup	= xfs_scrub_setup_xattr,
>  		.scrub	= xfs_scrub_xattr,
>  	},
>  	[XFS_SCRUB_TYPE_SYMLINK] = {	/* symbolic link */
> +		.type	= ST_INODE,
>  		.setup	= xfs_scrub_setup_symlink,
>  		.scrub	= xfs_scrub_symlink,
>  	},
>  	[XFS_SCRUB_TYPE_PARENT] = {	/* parent pointers */
> +		.type	= ST_INODE,
>  		.setup	= xfs_scrub_setup_parent,
>  		.scrub	= xfs_scrub_parent,
>  	},
>  	[XFS_SCRUB_TYPE_RTBITMAP] = {	/* realtime bitmap */
> +		.type	= ST_FS,
>  		.setup	= xfs_scrub_setup_rt,
>  		.scrub	= xfs_scrub_rtbitmap,
>  		.has	= xfs_sb_version_hasrealtime,
>  	},
>  	[XFS_SCRUB_TYPE_RTSUM] = {	/* realtime summary */
> +		.type	= ST_FS,
>  		.setup	= xfs_scrub_setup_rt,
>  		.scrub	= xfs_scrub_rtsummary,
>  		.has	= xfs_sb_version_hasrealtime,
>  	},
>  	[XFS_SCRUB_TYPE_UQUOTA] = {	/* user quota */
> -		.setup = xfs_scrub_setup_quota,
> -		.scrub = xfs_scrub_quota,
> +		.type	= ST_FS,
> +		.setup	= xfs_scrub_setup_quota,
> +		.scrub	= xfs_scrub_quota,
>  	},
>  	[XFS_SCRUB_TYPE_GQUOTA] = {	/* group quota */
> -		.setup = xfs_scrub_setup_quota,
> -		.scrub = xfs_scrub_quota,
> +		.type	= ST_FS,
> +		.setup	= xfs_scrub_setup_quota,
> +		.scrub	= xfs_scrub_quota,
>  	},
>  	[XFS_SCRUB_TYPE_PQUOTA] = {	/* project quota */
> -		.setup = xfs_scrub_setup_quota,
> -		.scrub = xfs_scrub_quota,
> +		.type	= ST_FS,
> +		.setup	= xfs_scrub_setup_quota,
> +		.scrub	= xfs_scrub_quota,
>  	},
>  };
>  
> @@ -298,14 +320,35 @@
>  	sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
>  	if (sm->sm_flags & ~XFS_SCRUB_FLAGS_IN)
>  		goto out;
> +	/* sm_reserved[] must be zero */
>  	if (memchr_inv(sm->sm_reserved, 0, sizeof(sm->sm_reserved)))
>  		goto out;
>  
> +	ops = &meta_scrub_ops[sm->sm_type];

This has to come after we range-check sm_type.

--D

> +	/* restricting fields must be appropriate for type */
> +	switch (ops->type) {
> +	case ST_NONE:
> +	case ST_FS:
> +		if (sm->sm_ino || sm->sm_gen || sm->sm_agno)
> +			goto out;
> +		break;
> +	case ST_PERAG:
> +		if (sm->sm_ino || sm->sm_gen ||
> +		    sm->sm_agno >= mp->m_sb.sb_agcount)
> +			goto out;
> +		break;
> +	case ST_INODE:
> +		if (sm->sm_agno || (sm->sm_gen && !sm->sm_ino))
> +			goto out;
> +		break;
> +	default:
> +		goto out;
> +	}
> +
>  	error = -ENOENT;
>  	/* Do we know about this type of metadata? */
>  	if (sm->sm_type >= XFS_SCRUB_TYPE_NR)
>  		goto out;
> -	ops = &meta_scrub_ops[sm->sm_type];
>  	if (ops->setup == NULL || ops->scrub == NULL)
>  		goto out;
>  	/* Does this fs even support this type of metadata? */
> diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
> index e9ec041..47f098c 100644
> --- a/fs/xfs/scrub/scrub.h
> +++ b/fs/xfs/scrub/scrub.h
> @@ -22,7 +22,17 @@
>  
>  struct xfs_scrub_context;
>  
> +/* Type info and names for the scrub types. */
> +enum scrub_type {
> +	ST_NONE = 1,	/* disabled */
> +	ST_PERAG,	/* per-AG metadata */
> +	ST_FS,		/* per-FS metadata */
> +	ST_INODE,	/* per-inode metadata */
> +};
> +
>  struct xfs_scrub_meta_ops {
> +	/* type describing required/allowed inputs */
> +	int		type;
>  	/* Acquire whatever resources are needed for the operation. */
>  	int		(*setup)(struct xfs_scrub_context *,
>  				 struct xfs_inode *);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
