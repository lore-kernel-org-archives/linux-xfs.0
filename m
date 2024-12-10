Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A281A704C
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 12:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733833681; cv=none; b=faKUHF0lh69ue5gQu7YnuBirvLQvOVpJrj8upTRwIU+PqHZDyeaNdMV5+RdcNZPeNhh8FabI30iJYmgqBu8b5/Zo9CiGPrbkux1g2AejPrwGIis+MJM2oNpHhk3FspeOL2U4ZdC7bix84dLQ6JZYca+5Hi4CeGJsOgIJYGv6zbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733833681; c=relaxed/simple;
	bh=P85MgTGjhikp/BBe/dAgrGd9pQpBVwfx5U7C/GYtf0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZHuwsAPe9xi6EQpbdagCwXFpZqgG7JMMygg0WWAxOEuOFnyEGgGj8QvbffWsK/IFTLjy6z6e7YSkGNNWJCbRFp7KP42jrVgSIyQb1Na2mn0Sb+b6yVt5cSj1cHcAeJIAGmO3C7miiU+1sjlS6A1sMIrq3IUBstiHHh5Yf/wI2v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VA9meHmG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VA9meHmG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733833678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pcIlZ/z8LYTZaR1VE0Qv0GsFxWRa+2SuH7DRQHzbJCk=;
	b=VA9meHmGJkBIu1nBAAkxkQDgJNXpfABkcSoyE66rTsMDT2FA8S7gzQiaXVODJAe4v04uRH
	urIVRT1ZrLx2JCaSxZNXRAeMtco76bXen8XPfsLUt15Zs8YbbO5W6dvI4uF5B2ZFjPdvky
	r1K6AkOgi8nm5BVS1s/QOogZP2++QW0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-643-3H5zw7QhMW2SZOkgAR8umw-1; Tue,
 10 Dec 2024 07:27:55 -0500
X-MC-Unique: 3H5zw7QhMW2SZOkgAR8umw-1
X-Mimecast-MFC-AGG-ID: 3H5zw7QhMW2SZOkgAR8umw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E3CD1955D5A;
	Tue, 10 Dec 2024 12:27:54 +0000 (UTC)
Received: from bfoster (unknown [10.22.90.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6BAB2195605A;
	Tue, 10 Dec 2024 12:27:53 +0000 (UTC)
Date: Tue, 10 Dec 2024 07:29:39 -0500
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/21] xfs: create incore realtime group structures
Message-ID: <Z1g0MxNmVKpFgXsU@bfoster>
References: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
 <173084396972.1871025.1072909621633581351.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173084396972.1871025.1072909621633581351.stgit@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Tue, Nov 05, 2024 at 02:24:26PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create an incore object that will contain information about a realtime
> allocation group.  This will eventually enable us to shard the realtime
> section in a similar manner to how we shard the data section, but for
> now just a single object for the entire RT subvolume is created.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/Makefile               |    1 
>  fs/xfs/libxfs/xfs_format.h    |    3 +
>  fs/xfs/libxfs/xfs_rtgroup.c   |  151 +++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_rtgroup.h   |  217 +++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_sb.c        |   13 ++
>  fs/xfs/libxfs/xfs_types.h     |    8 +-
>  fs/xfs/xfs_bmap_util.c        |    3 -
>  fs/xfs/xfs_buf_item_recover.c |   25 +++++
>  fs/xfs/xfs_fsmap.c            |    5 +
>  fs/xfs/xfs_mount.c            |   13 ++
>  fs/xfs/xfs_mount.h            |   13 ++
>  fs/xfs/xfs_rtalloc.c          |    5 +
>  fs/xfs/xfs_trace.c            |    1 
>  fs/xfs/xfs_trace.h            |    1 
>  14 files changed, 454 insertions(+), 5 deletions(-)
>  create mode 100644 fs/xfs/libxfs/xfs_rtgroup.c
>  create mode 100644 fs/xfs/libxfs/xfs_rtgroup.h
> 
> 
...
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
> new file mode 100644
> index 00000000000000..8872c27a9585fd
> --- /dev/null
> +++ b/fs/xfs/libxfs/xfs_rtgroup.h
> @@ -0,0 +1,217 @@
...
> +#ifdef CONFIG_XFS_RT
> +int xfs_rtgroup_alloc(struct xfs_mount *mp, xfs_rgnumber_t rgno,
> +		xfs_rgnumber_t rgcount, xfs_rtbxlen_t rextents);
> +void xfs_rtgroup_free(struct xfs_mount *mp, xfs_rgnumber_t rgno);
> +
> +void xfs_free_rtgroups(struct xfs_mount *mp, xfs_rgnumber_t first_rgno,
> +		xfs_rgnumber_t end_rgno);
> +int xfs_initialize_rtgroups(struct xfs_mount *mp, xfs_rgnumber_t first_rgno,
> +		xfs_rgnumber_t end_rgno, xfs_rtbxlen_t rextents);
> +
> +xfs_rtxnum_t __xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno,
> +		xfs_rgnumber_t rgcount, xfs_rtbxlen_t rextents);
> +xfs_rtxnum_t xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno);
> +
> +int xfs_update_last_rtgroup_size(struct xfs_mount *mp,
> +		xfs_rgnumber_t prev_rgcount);
> +#else
> +static inline void xfs_free_rtgroups(struct xfs_mount *mp,
> +		xfs_rgnumber_t first_rgno, xfs_rgnumber_t end_rgno)
> +{
> +}
> +
> +static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
> +		xfs_rgnumber_t first_rgno, xfs_rgnumber_t end_rgno,
> +		xfs_rtbxlen_t rextents)
> +{
> +	return 0;
> +}
> +
> +# define xfs_rtgroup_extents(mp, rgno)		(0)
> +# define xfs_update_last_rtgroup_size(mp, rgno)	(-EOPNOTSUPP)
> +#endif /* CONFIG_XFS_RT */

This patch appears to cause a regression with CONFIG_XFS_RT disabled. On
generic/034 or generic/039, I see a mount failure and hang with the
following in dmesg:

[  522.627881] XFS (dm-2): Mounting V5 Filesystem c984a654-8653-430a-9042-b59f26132eb6
[  522.676496] XFS (dm-2): Starting recovery (logdev: internal)
[  522.693551] XFS (dm-2): log mount/recovery failed: error -95
[  522.701508] XFS (dm-2): log mount failed

It seems to be related to the xfs_update_last_rtgroup_size() definition
above in that the issue goes away if I replace the error code with zero,
but I've not looked further into it than that. I'm also not clear on if
the hang behavior is related or just a separate, latent issue triggered
by the injected error.

Brian

> +
> +#endif /* __LIBXFS_RTGROUP_H */
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 4516824e3b9994..21891aa10ada02 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -696,6 +696,9 @@ __xfs_sb_from_disk(
>  		to->sb_metadirino = be64_to_cpu(from->sb_metadirino);
>  	else
>  		to->sb_metadirino = NULLFSINO;
> +
> +	to->sb_rgcount = 1;
> +	to->sb_rgextents = 0;
>  }
>  
>  void
> @@ -980,8 +983,18 @@ xfs_mount_sb_set_rextsize(
>  	struct xfs_mount	*mp,
>  	struct xfs_sb		*sbp)
>  {
> +	struct xfs_groups	*rgs = &mp->m_groups[XG_TYPE_RTG];
> +
>  	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
>  	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
> +
> +	mp->m_rgblocks = 0;
> +	mp->m_rgblklog = 0;
> +	mp->m_rgblkmask = (uint64_t)-1;
> +
> +	rgs->blocks = 0;
> +	rgs->blklog = 0;
> +	rgs->blkmask = (uint64_t)-1;
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 25053a66c225ed..bf33c2b1e43e5f 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -9,10 +9,12 @@
>  typedef uint32_t	prid_t;		/* project ID */
>  
>  typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
> +typedef uint32_t	xfs_rgblock_t;	/* blockno in realtime group */
>  typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
>  typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
>  typedef uint32_t	xfs_rtxlen_t;	/* file extent length in rtextents */
>  typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
> +typedef uint32_t	xfs_rgnumber_t;	/* realtime group number */
>  typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
>  typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
>  typedef int64_t		xfs_fsize_t;	/* bytes in a file */
> @@ -53,7 +55,9 @@ typedef void *		xfs_failaddr_t;
>  #define	NULLFILEOFF	((xfs_fileoff_t)-1)
>  
>  #define	NULLAGBLOCK	((xfs_agblock_t)-1)
> +#define NULLRGBLOCK	((xfs_rgblock_t)-1)
>  #define	NULLAGNUMBER	((xfs_agnumber_t)-1)
> +#define	NULLRGNUMBER	((xfs_rgnumber_t)-1)
>  
>  #define NULLCOMMITLSN	((xfs_lsn_t)-1)
>  
> @@ -214,11 +218,13 @@ enum xbtree_recpacking {
>  
>  enum xfs_group_type {
>  	XG_TYPE_AG,
> +	XG_TYPE_RTG,
>  	XG_TYPE_MAX,
>  } __packed;
>  
>  #define XG_TYPE_STRINGS \
> -	{ XG_TYPE_AG,	"ag" }
> +	{ XG_TYPE_AG,	"ag" }, \
> +	{ XG_TYPE_RTG,	"rtg" }
>  
>  /*
>   * Type verifier functions
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index edaf193dbd5ccc..1ac0b0facb7fd3 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -29,6 +29,7 @@
>  #include "xfs_iomap.h"
>  #include "xfs_reflink.h"
>  #include "xfs_rtbitmap.h"
> +#include "xfs_rtgroup.h"
>  
>  /* Kernel only BMAP related definitions and functions */
>  
> @@ -41,7 +42,7 @@ xfs_daddr_t
>  xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
>  {
>  	if (XFS_IS_REALTIME_INODE(ip))
> -		return XFS_FSB_TO_BB(ip->i_mount, fsb);
> +		return xfs_rtb_to_daddr(ip->i_mount, fsb);
>  	return XFS_FSB_TO_DADDR(ip->i_mount, fsb);
>  }
>  
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index c627ad3a3bbbfd..c8259ee482fd86 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -25,6 +25,7 @@
>  #include "xfs_alloc.h"
>  #include "xfs_ag.h"
>  #include "xfs_sb.h"
> +#include "xfs_rtgroup.h"
>  
>  /*
>   * This is the number of entries in the l_buf_cancel_table used during
> @@ -704,6 +705,7 @@ xlog_recover_do_primary_sb_buffer(
>  {
>  	struct xfs_dsb			*dsb = bp->b_addr;
>  	xfs_agnumber_t			orig_agcount = mp->m_sb.sb_agcount;
> +	xfs_rgnumber_t			orig_rgcount = mp->m_sb.sb_rgcount;
>  	int				error;
>  
>  	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
> @@ -722,6 +724,11 @@ xlog_recover_do_primary_sb_buffer(
>  		xfs_alert(mp, "Shrinking AG count in log recovery not supported");
>  		return -EFSCORRUPTED;
>  	}
> +	if (mp->m_sb.sb_rgcount < orig_rgcount) {
> +		xfs_warn(mp,
> + "Shrinking rtgroup count in log recovery not supported");
> +		return -EFSCORRUPTED;
> +	}
>  
>  	/*
>  	 * If the last AG was grown or shrunk, we also need to update the
> @@ -731,6 +738,17 @@ xlog_recover_do_primary_sb_buffer(
>  	if (error)
>  		return error;
>  
> +	/*
> +	 * If the last rtgroup was grown or shrunk, we also need to update the
> +	 * length in the in-core rtgroup structure and values depending on it.
> +	 * Ignore this on any filesystem with zero rtgroups.
> +	 */
> +	if (orig_rgcount > 0) {
> +		error = xfs_update_last_rtgroup_size(mp, orig_rgcount);
> +		if (error)
> +			return error;
> +	}
> +
>  	/*
>  	 * Initialize the new perags, and also update various block and inode
>  	 * allocator setting based off the number of AGs or total blocks.
> @@ -744,6 +762,13 @@ xlog_recover_do_primary_sb_buffer(
>  		return error;
>  	}
>  	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
> +
> +	error = xfs_initialize_rtgroups(mp, orig_rgcount, mp->m_sb.sb_rgcount,
> +			mp->m_sb.sb_rextents);
> +	if (error) {
> +		xfs_warn(mp, "Failed recovery rtgroup init: %d", error);
> +		return error;
> +	}
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 6cf4f00636a2d6..40beb8d75f26b1 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -25,6 +25,7 @@
>  #include "xfs_alloc_btree.h"
>  #include "xfs_rtbitmap.h"
>  #include "xfs_ag.h"
> +#include "xfs_rtgroup.h"
>  
>  /* Convert an xfs_fsmap to an fsmap. */
>  static void
> @@ -735,7 +736,7 @@ xfs_getfsmap_rtdev_rtbitmap_helper(
>  		frec.start_daddr = info->end_daddr;
>  	} else {
>  		rtbno = xfs_rtx_to_rtb(mp, rec->ar_startext);
> -		frec.start_daddr = XFS_FSB_TO_BB(mp, rtbno);
> +		frec.start_daddr = xfs_rtb_to_daddr(mp, rtbno);
>  	}
>  
>  	rtbno = xfs_rtx_to_rtb(mp, rec->ar_extcount);
> @@ -770,7 +771,7 @@ xfs_getfsmap_rtdev_rtbitmap(
>  
>  	/* Adjust the low key if we are continuing from where we left off. */
>  	if (keys[0].fmr_length > 0) {
> -		info->low_daddr = XFS_FSB_TO_BB(mp, start_rtb);
> +		info->low_daddr = xfs_rtb_to_daddr(mp, start_rtb);
>  		if (info->low_daddr >= eofs)
>  			return 0;
>  	}
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 2dd2606fc7e3e4..9464eddf9212e9 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -36,6 +36,7 @@
>  #include "xfs_ag.h"
>  #include "xfs_rtbitmap.h"
>  #include "xfs_metafile.h"
> +#include "xfs_rtgroup.h"
>  #include "scrub/stats.h"
>  
>  static DEFINE_MUTEX(xfs_uuid_table_mutex);
> @@ -834,10 +835,17 @@ xfs_mountfs(
>  		goto out_free_dir;
>  	}
>  
> +	error = xfs_initialize_rtgroups(mp, 0, sbp->sb_rgcount,
> +			mp->m_sb.sb_rextents);
> +	if (error) {
> +		xfs_warn(mp, "Failed rtgroup init: %d", error);
> +		goto out_free_perag;
> +	}
> +
>  	if (XFS_IS_CORRUPT(mp, !sbp->sb_logblocks)) {
>  		xfs_warn(mp, "no log defined");
>  		error = -EFSCORRUPTED;
> -		goto out_free_perag;
> +		goto out_free_rtgroup;
>  	}
>  
>  	error = xfs_inodegc_register_shrinker(mp);
> @@ -1072,6 +1080,8 @@ xfs_mountfs(
>  	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
>  		xfs_buftarg_drain(mp->m_logdev_targp);
>  	xfs_buftarg_drain(mp->m_ddev_targp);
> + out_free_rtgroup:
> +	xfs_free_rtgroups(mp, 0, mp->m_sb.sb_rgcount);
>   out_free_perag:
>  	xfs_free_perag_range(mp, 0, mp->m_sb.sb_agcount);
>   out_free_dir:
> @@ -1156,6 +1166,7 @@ xfs_unmountfs(
>  	xfs_errortag_clearall(mp);
>  #endif
>  	shrinker_free(mp->m_inodegc_shrinker);
> +	xfs_free_rtgroups(mp, 0, mp->m_sb.sb_rgcount);
>  	xfs_free_perag_range(mp, 0, mp->m_sb.sb_agcount);
>  	xfs_errortag_del(mp);
>  	xfs_error_sysfs_del(mp);
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 71ed04ddd737de..d491e31d33aac3 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -155,6 +155,7 @@ typedef struct xfs_mount {
>  	uint8_t			m_agno_log;	/* log #ag's */
>  	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
>  	int8_t			m_rtxblklog;	/* log2 of rextsize, if possible */
> +	int8_t			m_rgblklog;	/* log2 of rt group sz if possible */
>  	uint			m_blockmask;	/* sb_blocksize-1 */
>  	uint			m_blockwsize;	/* sb_blocksize in words */
>  	uint			m_blockwmask;	/* blockwsize-1 */
> @@ -183,12 +184,14 @@ typedef struct xfs_mount {
>  	int			m_logbsize;	/* size of each log buffer */
>  	uint			m_rsumlevels;	/* rt summary levels */
>  	xfs_filblks_t		m_rsumblocks;	/* size of rt summary, FSBs */
> +	uint32_t		m_rgblocks;	/* size of rtgroup in rtblocks */
>  	int			m_fixedfsid[2];	/* unchanged for life of FS */
>  	uint			m_qflags;	/* quota status flags */
>  	uint64_t		m_features;	/* active filesystem features */
>  	uint64_t		m_low_space[XFS_LOWSP_MAX];
>  	uint64_t		m_low_rtexts[XFS_LOWSP_MAX];
>  	uint64_t		m_rtxblkmask;	/* rt extent block mask */
> +	uint64_t		m_rgblkmask;	/* rt group block mask */
>  	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
>  	struct xfs_trans_resv	m_resv;		/* precomputed res values */
>  						/* low free space thresholds */
> @@ -391,6 +394,16 @@ __XFS_HAS_FEAT(large_extent_counts, NREXT64)
>  __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
>  __XFS_HAS_FEAT(metadir, METADIR)
>  
> +static inline bool xfs_has_rtgroups(struct xfs_mount *mp)
> +{
> +	return false;
> +}
> +
> +static inline bool xfs_has_rtsb(struct xfs_mount *mp)
> +{
> +	return false;
> +}
> +
>  /*
>   * Some features are always on for v5 file systems, allow the compiler to
>   * eliminiate dead code when building without v4 support.
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 46a920b192d191..917c1a5e8f3180 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -27,6 +27,7 @@
>  #include "xfs_health.h"
>  #include "xfs_da_format.h"
>  #include "xfs_metafile.h"
> +#include "xfs_rtgroup.h"
>  
>  /*
>   * Return whether there are any free extents in the size range given
> @@ -1136,6 +1137,7 @@ xfs_rtmount_inodes(
>  {
>  	struct xfs_trans	*tp;
>  	struct xfs_sb		*sbp = &mp->m_sb;
> +	struct xfs_rtgroup	*rtg = NULL;
>  	int			error;
>  
>  	error = xfs_trans_alloc_empty(mp, &tp);
> @@ -1166,6 +1168,9 @@ xfs_rtmount_inodes(
>  	if (error)
>  		goto out_rele_summary;
>  
> +	while ((rtg = xfs_rtgroup_next(mp, rtg)))
> +		rtg->rtg_extents = xfs_rtgroup_extents(mp, rtg_rgno(rtg));
> +
>  	error = xfs_alloc_rsum_cache(mp, sbp->sb_rbmblocks);
>  	if (error)
>  		goto out_rele_summary;
> diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
> index 1b9d75a54c5ea2..8f530e69c18ae7 100644
> --- a/fs/xfs/xfs_trace.c
> +++ b/fs/xfs/xfs_trace.c
> @@ -48,6 +48,7 @@
>  #include "xfs_refcount.h"
>  #include "xfs_metafile.h"
>  #include "xfs_metadir.h"
> +#include "xfs_rtgroup.h"
>  
>  /*
>   * We include this last to have the helpers above available for the trace
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 0f3704f3c2e4e3..f66e5b590d7597 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -219,6 +219,7 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inode_tag);
>  DEFINE_PERAG_REF_EVENT(xfs_reclaim_inodes_count);
>  
>  TRACE_DEFINE_ENUM(XG_TYPE_AG);
> +TRACE_DEFINE_ENUM(XG_TYPE_RTG);
>  
>  DECLARE_EVENT_CLASS(xfs_group_class,
>  	TP_PROTO(struct xfs_group *xg, unsigned long caller_ip),
> 
> 

