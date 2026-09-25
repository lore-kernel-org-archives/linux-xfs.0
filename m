Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA343AD50B
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 23:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790380478; cv=none; b=NKIwrLEdJnsT/3W05KbgcpwnlVIU4Tg5kTGZnBK5R7Wdlq0NYwTcRkghJiOLnSc4TbaBrc5Ig3gmKDpi/yWfYt09JY3mv8Y8Evr3y0Pgq4iTxNFBWngKLMkKUduvzvahQewRaSoUYWspUZfWsS0wrhWD9+GfLEFvlXA7FDnt+qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790380478; c=relaxed/simple;
	bh=0U3JTX82+J46WISYl61E/tJlr/onxBQGlqeo86a53kc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c0Tgg5F75sLMQh2jf0YUOT4SY39T3Xv/cEN3ScdKZ34debjsZwo9snnzxrSeky82E+EACAjkO0qxBvPSA0fN7GE8eOvO8YWVljyDn6nAR+S0l36B4N9TdRu19tMSlY0qXyRFjyCVpkNr5jdTgAiNMmoRJ4VXo1npfUWny45KtvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YfyNAEwj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YfyNAEwj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C5EA81F000FF;
	Fri, 25 Sep 2026 23:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790380476;
	bh=icaBcVZPpkKcSBojKKffNKfNbKTY8jUjtmXt0RYd8/E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YfyNAEwjLjwP5p4yiTr5t0fx1ODLsyPpz2vUnZTHWMCVvdce3G75r8PSnuDbwsWbJ
	 aOD1BmBRqJhKQXNYYuTEGezl5NijwXnF9a1ibifjm5sLRGyhEsYKrYgdBWG9vwADcK
	 8Ak46Hu4EIZsdmylvJHWbt+3khdmK5UiDl0lAaB0ZHzBt5wiE/TcdiL3t7bH0Ii+VO
	 CdYa3I2GHKieULiN7z2akNnVgF9rHvelgdG7NEt3ATf4PyMvZrqbf/p8zP2yjjhYcC
	 J2hR/Il/tkxNAjNTfb2/D0TFQsZSX/Uij46lD26ribuFiQtXVcOvguTaZGgFSIl7qN
	 6qJEKrnkX+hEA==
Date: Fri, 25 Sep 2026 16:54:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 31/32] repair: support RT data checksums
Message-ID: <20260925235435.GR2705364@frogsfrogsfrogs>
References: <20260924100512.2733748-1-hch@lst.de>
 <20260924100512.2733748-32-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100512.2733748-32-hch@lst.de>

On Thu, Sep 24, 2026 at 12:04:21PM +0200, Christoph Hellwig wrote:
> Recognize the rtcsum per-RTG metadir files, and sanity check a few
> well known attributes for them.
> 
> If a csum file is missing, or had to be nuke, regenerate it by

                             or had to be nuked,

> re-calculating the checksums.  While this does lose the protection
> of the checksums, this is probably still better than an unmountable
> file system.
> 
> Note that due to the lack of the regular buffer readahead path,
> reading the data and csum buffers for regenerating the csum file
> is fully synchronous and thus slow.  Hopefully we can come up with
> a better version for online repair and never have to use this for
> real.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  repair/Makefile |   1 +
>  repair/dinode.c |  46 ++++++++++++++
>  repair/phase6.c | 122 +++++++++++++++++++++++++++++++++++-
>  repair/rt.c     |  36 +++++++++++
>  repair/rt.h     |  10 +++
>  repair/rtcsum.c | 161 ++++++++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 375 insertions(+), 1 deletion(-)
>  create mode 100644 repair/rtcsum.c
> 
> diff --git a/repair/Makefile b/repair/Makefile
> index fb0b2f96cc91..27eb68e2b5d5 100644
> --- a/repair/Makefile
> +++ b/repair/Makefile
> @@ -73,6 +73,7 @@ CFILES = \
>  	rcbag.c \
>  	rmap.c \
>  	rt.c \
> +	rtcsum.c \
>  	rtrefcount_repair.c \
>  	rtrmap_repair.c \
>  	sb.c \
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 48939f8bd159..5c03c5f50689 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -22,6 +22,8 @@
>  #include "rmap.h"
>  #include "bmap_repair.h"
>  #include "rt.h"
> +#include "libfrog/crc64.h"
> +#include "xfs_rtcsumfile.h"
>  
>  /* inode types */
>  enum xr_ino_type {
> @@ -41,6 +43,7 @@ enum xr_ino_type {
>  	XR_INO_PQUOTA,		/* project quota inode */
>  	XR_INO_RTRMAP,		/* realtime rmap */
>  	XR_INO_RTREFC,		/* realtime refcount */
> +	XR_INO_RTCSUM,		/* realtime data checksum */
>  	XR_INO_MAX
>  };
>  
> @@ -61,6 +64,7 @@ static const char *xr_ino_type_name[] = {
>  	[XR_INO_PQUOTA]		= N_("project quota"),
>  	[XR_INO_RTRMAP]		= N_("realtime rmap"),
>  	[XR_INO_RTREFC]		= N_("realtime refcount"),
> +	[XR_INO_RTCSUM]		= N_("realtime data checksum"),
>  };
>  static_assert(ARRAY_SIZE(xr_ino_type_name) == XR_INO_MAX);
>  
> @@ -2064,6 +2068,43 @@ _("bad # of extents (%" PRIu64 ") for %s inode %" PRIu64 "\n"),
>  	return 0;
>  }
>  
> +static int
> +process_check_rtcsum_inode(
> +	struct xfs_mount	*mp,
> +	struct xfs_dinode	*dinoc,
> +	xfs_ino_t		lino,
> +	enum xr_ino_type	*type,
> +	int			*dirty)
> +{
> +	xfs_fsize_t		size = be64_to_cpu(dinoc->di_size);
> +	xfs_fsize_t		expected_size;
> +	int			error;
> +
> +	error = process_check_rt_inode(mp, dinoc, lino, type, dirty,
> +				XR_INO_RTCSUM, _("realtime data checksums"));
> +	if (error)
> +		return error;
> +
> +	/* rtcsum inodes must be contiguous */
> +	if (xfs_dfork_data_extents(dinoc) != 1) {
> +		do_warn(
> +_("non-contiguous rtcsum inode %" PRIu64 "\n"), lino);
> +		return 1;
> +	}
> +
> +	expected_size = (xfs_off_t)mp->m_sb.sb_rgextents << mp->m_rtcsum_shift;
> +	expected_size = (expected_size + xfs_rtcsum_payload_size(mp) - 1) /
> +		xfs_rtcsum_payload_size(mp) * mp->m_rtcsum_bsize;

round_up()?

> +	if (size != expected_size) {
> +		do_warn(
> +_("unexpected rtcsum file size (%" PRId64 ") for ino %" PRIu64 "\n"),
> +			size, lino);
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * If inode is a superblock inode, does type check to make sure is it valid.
>   * Returns 0 if it's valid, non-zero if it needs to be cleared.
> @@ -2130,6 +2171,8 @@ process_check_metadata_inodes(
>  	if (is_rtrefcount_inode(lino))
>  		return process_check_rt_inode(mp, dinoc, lino, type, dirty,
>  				XR_INO_RTREFC, _("realtime refcount btree"));
> +	if (is_rtcsum_inode(lino))
> +		return process_check_rtcsum_inode(mp, dinoc, lino, type, dirty);
>  	return 0;
>  }
>  
> @@ -2977,6 +3020,7 @@ process_dinode_metafile(
>  	case XR_INO_UQUOTA:
>  	case XR_INO_GQUOTA:
>  	case XR_INO_PQUOTA:
> +	case XR_INO_RTCSUM:
>  		/*
>  		 * Quota checking and repair doesn't happen until phase7, so
>  		 * preserve quota inodes and their contents for later.
> @@ -3555,6 +3599,8 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
>  			type = XR_INO_RTRMAP;
>  		else if (is_rtrefcount_inode(lino))
>  			type = XR_INO_RTREFC;
> +		else if (is_rtcsum_inode(lino))
> +			type = XR_INO_RTCSUM;
>  		else
>  			type = XR_INO_DATA;
>  		break;
> diff --git a/repair/phase6.c b/repair/phase6.c
> index f3951a3d0709..c7bc1cabd0d3 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -6,7 +6,6 @@
>  
>  #include "libxfs.h"
>  #include "threads.h"
> -#include "threads.h"
>  #include "prefetch.h"
>  #include "avl.h"
>  #include "globals.h"
> @@ -23,6 +22,8 @@
>  #include "repair/quotacheck.h"
>  #include "repair/slab.h"
>  #include "repair/rmap.h"
> +#include "libfrog/crc64.h"
> +#include "xfs_rtcsumfile.h"
>  
>  static xfs_ino_t		orphanage_ino;
>  
> @@ -703,6 +704,123 @@ ensure_rtgroup_refcountbt(
>  		populate_rtgroup_refcountbt(rtg, est_fdblocks);
>  }
>  
> +/*
> + * Link a metadata directory inode.
> + */
> +static int
> +metadir_link(
> +	struct xfs_inode		*dp,
> +	struct xfs_inode		*ip,
> +	const char			*path,
> +	enum xfs_metafile_type		type)
> +{
> +	struct xfs_metadir_update	upd = {
> +		.dp			= dp,
> +		.metafile_type		= type,
> +		.ip			= ip,
> +		.path			= path,
> +	};
> +	int				error;
> +
> +	error = xfs_metadir_start_link(&upd);
> +	if (error)
> +		return error;
> +
> +	error = xfs_metadir_link(&upd);
> +	if (error)
> +		return error;
> +
> +	xfs_trans_log_inode(upd.tp, upd.ip, XFS_ILOG_CORE);
> +	return xfs_metadir_commit(&upd);
> +}
> +
> +static void
> +ensure_rtgroup_csum(
> +	struct xfs_rtgroup	*rtg)
> +{
> +	struct xfs_mount	*mp = rtg_mount(rtg);
> +	xfs_rgnumber_t		rgno = rtg_rgno(rtg);
> +	struct xfs_inode	*dp = mp->m_rtdirip;
> +	struct xfs_inode	*ip;
> +	int			error;
> +
> +	if (no_modify) {
> +		if (rtcsum_ino_is_bad(rgno))
> +			do_warn(_("would reset RG %u csum inode\n"), rgno);;
> +		return;
> +	}
> +
> +	if (!rtcsum_ino_is_bad(rgno)) {
> +		/*
> +		 * The /realtime directory has been discarded, but we should be
> +		 * able to iget the inodes directly.
> +		 */
> +		error = -libxfs_metafile_iget(mp, rtcsum_ino(rgno),
> +				XFS_METAFILE_RTCSUM, &ip);
> +		if (error) {
> +			do_warn(
> +_("Could not open RG %u csum inode, error %d\n"), rgno, error);
> +			rtcsum_ino_mark_bad(rgno);
> +		}
> +	}
> +
> +	if (rtcsum_ino_is_bad(rgno)) {
> +		do_warn(_(
> +"resetting RG %u csum inode, regenerating data checksums\n"),

Nit: Inconsistent _( placement vs. the other errors.

> +			rgno);
> +		error = -libxfs_rtginode_create(rtg, XFS_RTGI_CSUM, false);
> +		if (error) {
> +			do_warn(
> +_("Couldn't create RG %u csum inode, error %d\n"), rgno, error);
> +			return;
> +		}
> +		ip = rtg->rtg_inodes[XFS_RTGI_CSUM];
> +		error = -xfs_rtcsum_alloc_blocks(rtg);

Does this need the usual -libxfsification macros?

> +		if (error) {
> +			do_warn(
> +_("Initialization of RG %u csum inode failed, error %d"), rgno, error);
> +			return;
> +		}
> +
> +		calculate_rtgroup_csums(rtg);
> +	} else {
> +		struct xfs_trans	*tp;
> +		const char		*name;
> +
> +		/* Erase parent pointers before we create the new link */
> +		try_erase_parent_ptrs(ip);
> +
> +		name = xfs_rtginode_path(rtg_rgno(rtg), XFS_RTGI_CSUM);
> +		error = -metadir_link(dp, ip, name, XFS_METAFILE_RTCSUM);
> +		kfree(name);
> +		if (error) {
> +			do_warn(
> +_("Couldn't link RG %u csum inode, error %d\n"), rgno, error);
> +			return;
> +		}
> +
> +		/*
> +		 * Reset the link count to 1 because  the link above bumped it.
> +		 */
> +		error = -libxfs_trans_alloc_inode(ip, &M_RES(mp)->tr_ichange,
> +				0, 0, false, &tp);
> +		if (!error) {
> +			set_nlink(VFS_I(ip), 1);
> +			libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +			error = -libxfs_trans_commit(tp);
> +		}
> +		if (error)
> +			do_error(
> +_("Couldn't reset link count on RG %i quota inode, error %d\n"),
> +				rgno, error);
> +	}
> +
> +	/* Mark the inode in use. */
> +	mark_ino_inuse(mp, I_INO(ip), S_IFREG, I_INO(dp));
> +	mark_ino_metadata(mp, I_INO(ip));
> +	libxfs_irele(ip);
> +}
> +
>  /* Initialize a root directory. */
>  static int
>  init_fs_root_dir(
> @@ -3473,6 +3591,8 @@ _("        - resetting contents of realtime bitmap and summary inodes\n"));
>  		}
>  		ensure_rtgroup_rmapbt(rtg, est_fdblocks);
>  		ensure_rtgroup_refcountbt(rtg, est_fdblocks);
> +		if (xfs_has_rtcsum(mp))
> +			ensure_rtgroup_csum(rtg);
>  	}
>  }
>  
> diff --git a/repair/rt.c b/repair/rt.c
> index b0ff775bd339..4b64a91fbe29 100644
> --- a/repair/rt.c
> +++ b/repair/rt.c
> @@ -26,6 +26,8 @@ struct rtg_computed {
>  };
>  struct rtg_computed *rt_computed;
>  
> +static xfs_ino_t *rtcsum_inos;
> +
>  static inline void
>  set_rtword(
>  	struct xfs_mount	*mp,
> @@ -410,6 +412,27 @@ fill_rtsummary(
>  _("couldn't re-initialize realtime summary inode, error %d\n"), error);
>  }
>  
> +bool
> +rtcsum_ino_is_bad(
> +	xfs_rgnumber_t		rgno)
> +{
> +	return rtcsum_inos[rgno] == NULLFSINO;
> +}
> +
> +void
> +rtcsum_ino_mark_bad(
> +	xfs_rgnumber_t		rgno)
> +{
> +	rtcsum_inos[rgno] = NULLFSINO;
> +}
> +
> +xfs_ino_t
> +rtcsum_ino(
> +	xfs_rgnumber_t		rgno)
> +{
> +	return rtcsum_inos[rgno];
> +}
> +
>  bool
>  is_rtgroup_inode(
>  	xfs_ino_t		ino,
> @@ -471,6 +494,13 @@ mark_rtginode(
>  			goto out_corrupt;
>  	}
>  
> +	/*
> +	 * Record the inode numbers of the data checksum inodes, as we don't
> +	 * just blow those away like other per-RTG metadata.
> +	 */
> +	if (type == XFS_RTGI_CSUM)
> +		rtcsum_inos[rtg_rgno(rtg)] = I_INO(ip);
> +
>  	/*
>  	 * Phase 3 will clear the ondisk inodes of all rt metadata files, but
>  	 * it doesn't reset any blocks.  Keep the incore inodes loaded so that
> @@ -494,6 +524,12 @@ discover_rtgroup_inodes(
>  	int			error, err2;
>  	int			i;
>  
> +	rtcsum_inos = calloc(mp->m_sb.sb_rgcount, sizeof(xfs_ino_t));
> +	if (!rtcsum_inos)
> +		do_error(_("could not allocate csum ino array\n"));
> +	for (i = 0; i < mp->m_sb.sb_rgcount; i++)
> +		rtcsum_inos[i] = NULLFSINO;
> +
>  	tp = libxfs_trans_alloc_empty(mp);
>  	if (xfs_has_rtgroups(mp) && mp->m_sb.sb_rgcount > 0) {
>  		error = -libxfs_rtginode_load_parent(tp);
> diff --git a/repair/rt.h b/repair/rt.h
> index e4f3d5d9af31..9400b230de59 100644
> --- a/repair/rt.h
> +++ b/repair/rt.h
> @@ -13,6 +13,10 @@ void check_rtsummary(struct xfs_mount *mp);
>  void fill_rtbitmap(struct xfs_rtgroup *rtg);
>  void fill_rtsummary(struct xfs_rtgroup *rtg);
>  
> +bool rtcsum_ino_is_bad(xfs_rgnumber_t rgno);
> +void rtcsum_ino_mark_bad(xfs_rgnumber_t rgno);
> +xfs_ino_t rtcsum_ino(xfs_rgnumber_t rgno);
> +
>  void discover_rtgroup_inodes(struct xfs_mount *mp);
>  void unload_rtgroup_inodes(struct xfs_mount *mp);
>  
> @@ -37,6 +41,10 @@ static inline bool is_rtrefcount_inode(xfs_ino_t ino)
>  {
>  	return is_rtgroup_inode(ino, XFS_RTGI_REFCOUNT);
>  }
> +static inline bool is_rtcsum_inode(xfs_ino_t ino)
> +{
> +	return is_rtgroup_inode(ino, XFS_RTGI_CSUM);
> +}
>  
>  void mark_rtgroup_inodes_bad(struct xfs_mount *mp, enum xfs_rtg_inodes type);
>  bool rtgroup_inodes_were_bad(enum xfs_rtg_inodes type);
> @@ -44,4 +52,6 @@ bool rtgroup_inodes_were_bad(enum xfs_rtg_inodes type);
>  void check_rtsb(struct xfs_mount *mp);
>  void rewrite_rtsb(struct xfs_mount *mp);
>  
> +void calculate_rtgroup_csums(struct xfs_rtgroup *rtg);
> +
>  #endif /* _XFS_REPAIR_RT_H_ */
> diff --git a/repair/rtcsum.c b/repair/rtcsum.c
> new file mode 100644
> index 000000000000..c4d629c18e8d
> --- /dev/null
> +++ b/repair/rtcsum.c
> @@ -0,0 +1,161 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2026 Christoph Hellwig.
> + *
> + * Rebuild data checksums when the csum metafile was lost.  This doens't perform
> + * great and is inteded as a last resort.

"This doesn't perform great and is intended as..."

> + */
> +#include "libxfs.h"
> +#include "globals.h"
> +#include "protos.h"
> +#include "rt.h"
> +#include "err_protos.h"
> +#include "libfrog/crc64.h"
> +#include "xfs_platform.h"
> +#include "xfs_rtcsumfile.h"
> +
> +/* default to 1MiB data reads to make the performance only somewhat horrible. */
> +#define DATA_BLOCKS_PER_BUF	256
> +
> +static int
> +read_data(
> +	struct xfs_buftarg	*btp,
> +	xfs_daddr_t		blkno,
> +	unsigned int		nblks,
> +	void			*buf)
> +{
> +	int			fd = btp->bt_bdev_fd;
> +	off_t			pos = LIBXFS_BBTOOFF64(blkno);
> +	size_t			len = BBTOB(nblks);
> +	ssize_t			ret;
> +
> +	ret = pread(fd, buf, len, pos);
> +	if (ret < 0) {
> +		ret = errno;
> +
> +		fprintf(stderr, _("%s: read failed: %s\n"),
> +			progname, strerror(ret));
> +		return -ret;
> +	}
> +	if (ret != len) {
> +		fprintf(stderr, _("%s: error - read only %zd of %zd bytes\n"),
> +			progname, ret, len);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +calculate_buf_csums(
> +	struct xfs_rtgroup	*rtg,
> +	void			*data_buf,
> +	xfs_rgblock_t		rgbno,
> +	unsigned int		*nr)
> +{
> +	struct xfs_mount	*mp = rtg_mount(rtg);
> +	unsigned int		boff = xfs_rgb_to_rtcsumoff(mp, rgbno);
> +	struct xfs_trans_res	tres = M_RES(mp)->tr_csum;
> +	xfs_daddr_t		csum_daddr;
> +	void			*csum_buf;
> +	struct xfs_buf		*csum_bp;
> +	struct xfs_trans	*tp;
> +	int			error;
> +	unsigned int		i = 0;
> +
> +	*nr = min(*nr, xfs_rtcsum_len_to_extlen(mp, mp->m_rtcsum_bsize - boff));
> +
> +	error = xfs_rtcsum_bmap(rtg, rgbno, &csum_daddr);
> +	if (error) {
> +		do_error(
> +_("Cannot bmap new csum file for RG %u, error %d\n"),
> +			rtg_rgno(rtg), error);
> +		return error;
> +	}
> +
> +	tres.tr_logres = xfs_calc_csum_reservation(mp,
> +				xfs_extlen_to_rtcsum_len(mp, *nr));
> +	ASSERT(tres.tr_logres <= M_RES(mp)->tr_csum.tr_logres);
> +
> +	error = libxfs_trans_alloc(mp, &tres, 0, 0, 0, &tp);
> +	if (error) {
> +		do_error(
> +_("Transaction allocation for csum repair failed: %d\n"),
> +			error);
> +		return error;
> +	}
> +
> +	error = libxfs_buf_read(mp->m_ddev_targp, csum_daddr,
> +			BTOBB(mp->m_rtcsum_bsize), 0, &csum_bp,
> +			&xfs_rtcsum_buf_ops);
> +	if (error) {
> +		do_error(
> +_("Cannot get buffer for new csum file for RG %u, error %d\n"),
> +			rtg_rgno(rtg), error);
> +		return error;
> +	}
> +
> +	libxfs_trans_bjoin(tp, csum_bp);
> +	xfs_trans_buf_set_type(tp, csum_bp, XFS_BLFT_RTCSUM_BUF);
> +
> +	csum_buf = csum_bp->b_addr + boff;
> +	for (i = 0; i < *nr; i++) {
> +		union xfs_csum		csum;
> +
> +		xfs_csum_seed(mp, &csum);
> +		xfs_csum_gen(mp, data_buf + XFS_FSB_TO_B(mp, i),
> +				 mp->m_sb.sb_blocksize, &csum);
> +		if (i == 0)
> +			printf("calculated checksum 0x%x\n", csum.crc32c);

Debug code?

> +		xfs_csum_finalize(mp, csum_buf, &csum);
> +		csum_buf += (1u << mp->m_rtcsum_shift);
> +	}
> +
> +	libxfs_trans_log_buf(tp, csum_bp, boff,
> +			boff + xfs_extlen_to_rtcsum_len(mp, *nr) - 1);
> +	return -libxfs_trans_commit(tp);
> +}
> +
> +void
> +calculate_rtgroup_csums(
> +	struct xfs_rtgroup	*rtg)
> +{
> +	struct xfs_mount	*mp = rtg_mount(rtg);
> +	xfs_rgblock_t		rgbno;
> +	int			error;
> +	void			*data_buf;
> +
> +	error = posix_memalign(&data_buf, sysconf(_SC_PAGESIZE),
> +			XFS_FSB_TO_B(mp, DATA_BLOCKS_PER_BUF));
> +	if (error) {
> +		do_warn(
> +_("Failed to allocate memory for csum rebuild\n"));
> +		return;
> +	}
> +	for (rgbno = 0; rgbno < rtg_blocks(rtg); rgbno += DATA_BLOCKS_PER_BUF) {
> +		unsigned int		nr_blocks, done = 0;
> +
> +		nr_blocks = min(DATA_BLOCKS_PER_BUF, rtg_blocks(rtg) - rgbno);
> +		error = read_data(mp->m_rtdev_targp,
> +				xfs_gbno_to_daddr(rtg_group(rtg), rgbno),
> +				XFS_FSB_TO_BB(mp, nr_blocks),
> +				data_buf);
> +		if (error) {
> +			do_warn(
> +_("Reading data at RG %u/%u failed, error %d"),
> +				rtg_rgno(rtg), rgbno, error);
> +			continue;

Er... so a read failure means we just leave broken checksums?

--D

> +		}
> +
> +		do {
> +			unsigned int n = nr_blocks - done;
> +
> +			calculate_buf_csums(rtg,
> +					data_buf + XFS_FSB_TO_B(mp, done),
> +					rgbno + done, &n);
> +			done += n;
> +		} while (done < nr_blocks);
> +	}
> +
> +	kfree(data_buf);
> +}
> -- 
> 2.53.0
> 
> 
