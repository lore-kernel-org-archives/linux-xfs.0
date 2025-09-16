Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB4431E893
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 16:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758040712; cv=none; b=ulrcoHHroELfqhhHCOTh0K+mQ5xALj613anZWWsQmaPkHHiraQathLjPpbeRkTSaaCdhgndx+UfkfW/i83rrzRgnSOoK15jv8VrMsXXfRO4SEtLbzD3LIFuq8EqI7S9OQ6tymo8c2ZZlcEp48q/iVSqNHz8QW/mtzSyWRIxhfcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758040712; c=relaxed/simple;
	bh=Fq0sUj81pLGeUex69ezldepPTzdb3TPHWpOl/mmPLKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TMW6qC9+WbY1cAFGgu+jbl0BvhaOkkDzq1LeJsmZgayJFAamCjCWgB3kYctojpcmq10eeJ1Umn2ovqeHADhxZmmy9GrLk0SrrYTpbmAZMZRo7C7rKL2ip8+TuWf0R4yysRWf6I7ytoeRP84QySuIg2xa8Gjfe8UY77vBVfwFySI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vEn7QAcI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vEn7QAcI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A60C4CEEB;
	Tue, 16 Sep 2025 16:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758040712;
	bh=Fq0sUj81pLGeUex69ezldepPTzdb3TPHWpOl/mmPLKU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vEn7QAcIyR+xpMc66Yyv3/JH8Ks9BisMxtVUJgr9GZ/+oAHJqmU6bTkCDg+0CCdh0
	 9tu7S1KxjoTJSMtORpc/0vVXqBlGZaD64yDXymPf1QFtWeKbKS0WWUaFiL1nepzesw
	 GcwlchVZAThz2eAKD5AJeclO9WAL7yMzjIQHIoBiPqlDiJ75DKSRLueTSqdk1y++UT
	 SGzgR637ujz0OaUGZVve8U6daATNA4vCEPTN5JrEQThTLnWFbsDT4H7c03wqh9lndB
	 HuOjgQ8HJ7whwFjB34F09zQ3ONK/f7m4RL5yrJgQuOpKuLvzDeBI3gI4G8V1eqY7jw
	 ea275MJGjtfWg==
Date: Tue, 16 Sep 2025 09:38:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: centralize error tag definitions
Message-ID: <20250916163831.GG8096@frogsfrogsfrogs>
References: <20250916162843.258959-1-hch@lst.de>
 <20250916162843.258959-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916162843.258959-6-hch@lst.de>

On Tue, Sep 16, 2025 at 09:28:18AM -0700, Christoph Hellwig wrote:
> Right now 5 places in the kernel and one in xfsprogs need to be updated
> for each new error tag.  Add a bit of macro magic so that only the
> error tag definition and a single table, which reside next to each
> other, need to be updated.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_errortag.h | 106 ++++++++++++----------
>  fs/xfs/xfs_error.c           | 166 +++++------------------------------
>  2 files changed, 81 insertions(+), 191 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index a53c5d40e084..e45ac1314078 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -4,9 +4,19 @@
>   * Copyright (C) 2017 Oracle.
>   * All Rights Reserved.
>   */
> -#ifndef __XFS_ERRORTAG_H_
> +#if !defined(__XFS_ERRORTAG_H_) || defined(XFS_ERRTAG)
>  #define __XFS_ERRORTAG_H_
>  
> +/*
> + * There are two ways to use this header file.  The first way is to #include it
> + * bare, which will define all the XFS_ERRTAG_* error injection knobs for use
> + * with the XFS_TEST_ERROR macro.  The second way is to enclose the #include
> + * with a #define for an XFS_ERRTAG macro, in which case the header will define
> + * an XFS_ERRTAGS macro that expands to the XFS_ERRTAG macro supplied by the
> + * source files that includes this header use for each defined error
> + * injection knob.

Hmm, that last sentence could be more concise, and describe what is
passed to the XFS_ERRTAG macro:

"...will define an XFS_ERRTAGS macro that expands to invoke that
XFS_ERRTAG macro for each defined error injection knob.  The parameters
to the XFS_ERRTAG macro are:

1. The XFS_ERRTAG_ flag but without the prefix;
2. The name of the sysfs knob; and
3. The default value for the knob."

I wonder if XFS_ERRTAG() should be supplied with the full XFS_ERRTAG_FOO
name, not just FOO?

Otherwise this looks good now.

--D

> + */
> +
>  /*
>   * error injection tags - the labels can be anything you want
>   * but each tag should have its own unique number
> @@ -71,49 +81,55 @@
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
>   */
>  #define XFS_RANDOM_DEFAULT				100
> -#define XFS_RANDOM_IFLUSH_1				XFS_RANDOM_DEFAULT
> -#define XFS_RANDOM_IFLUSH_2				XFS_RANDOM_DEFAULT
> -#define XFS_RANDOM_IFLUSH_3				XFS_RANDOM_DEFAULT
> -#define XFS_RANDOM_IFLUSH_4				XFS_RANDOM_DEFAULT
> -#define XFS_RANDOM_IFLUSH_5				XFS_RANDOM_DEFAULT
> -#define XFS_RANDOM_IFLUSH_6				XFS_RANDOM_DEFAULT
> -#define XFS_RANDOM_DA_READ_BUF				XFS_RANDOM_DEFAULT
> -#define XFS_RANDOM_BTREE_CHECK_LBLOCK			(XFS_RANDOM_DEFAULT/4)
> -#define XFS_RANDOM_BTREE_CHECK_SBLOCK			XFS_RANDOM_DEFAULT
> -#define XFS_RANDOM_ALLOC_READ_AGF			XFS_RANDOM_DEFAULT
> -#define XFS_RANDOM_IALLOC_READ_AGI			XFS_RANDOM_DEFAULT
> -#define XFS_RANDOM_ITOBP_INOTOBP			XFS_RANDOM_DEFAULT
> -#define XFS_RANDOM_IUNLINK				XFS_RANDOM_DEFAULT
> -#define XFS_RANDOM_IUNLINK_REMOVE			XFS_RANDOM_DEFAULT
> -#define XFS_RANDOM_DIR_INO_VALIDATE			XFS_RANDOM_DEFAULT
> -#define XFS_RANDOM_BULKSTAT_READ_CHUNK			XFS_RANDOM_DEFAULT
> -#define XFS_RANDOM_IODONE_IOERR				(XFS_RANDOM_DEFAULT/10)
> -#define XFS_RANDOM_STRATREAD_IOERR			(XFS_RANDOM_DEFAULT/10)
> -#define XFS_RANDOM_STRATCMPL_IOERR			(XFS_RANDOM_DEFAULT/10)
> -#define XFS_RANDOM_DIOWRITE_IOERR			(XFS_RANDOM_DEFAULT/10)
> -#define XFS_RANDOM_BMAPIFORMAT				XFS_RANDOM_DEFAULT
> -#define XFS_RANDOM_FREE_EXTENT				1
> -#define XFS_RANDOM_RMAP_FINISH_ONE			1
> -#define XFS_RANDOM_REFCOUNT_CONTINUE_UPDATE		1
> -#define XFS_RANDOM_REFCOUNT_FINISH_ONE			1
> -#define XFS_RANDOM_BMAP_FINISH_ONE			1
> -#define XFS_RANDOM_AG_RESV_CRITICAL			4
> -#define XFS_RANDOM_LOG_BAD_CRC				1
> -#define XFS_RANDOM_LOG_ITEM_PIN				1
> -#define XFS_RANDOM_BUF_LRU_REF				2
> -#define XFS_RANDOM_FORCE_SCRUB_REPAIR			1
> -#define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
> -#define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
> -#define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
> -#define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
> -#define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
> -#define XFS_RANDOM_AG_RESV_FAIL				1
> -#define XFS_RANDOM_LARP					1
> -#define XFS_RANDOM_DA_LEAF_SPLIT			1
> -#define XFS_RANDOM_ATTR_LEAF_TO_NODE			1
> -#define XFS_RANDOM_WB_DELAY_MS				3000
> -#define XFS_RANDOM_WRITE_DELAY_MS			3000
> -#define XFS_RANDOM_EXCHMAPS_FINISH_ONE			1
> -#define XFS_RANDOM_METAFILE_RESV_CRITICAL		4
> +
> +#ifdef XFS_ERRTAG
> +# undef XFS_ERRTAGS
> +# define XFS_ERRTAGS \
> +XFS_ERRTAG(NOERROR,		noerror,		XFS_RANDOM_DEFAULT) \
> +XFS_ERRTAG(IFLUSH_1,		iflush1,		XFS_RANDOM_DEFAULT) \
> +XFS_ERRTAG(IFLUSH_2,		iflush2,		XFS_RANDOM_DEFAULT) \
> +XFS_ERRTAG(IFLUSH_3,		iflush3,		XFS_RANDOM_DEFAULT) \
> +XFS_ERRTAG(IFLUSH_4,		iflush4,		XFS_RANDOM_DEFAULT) \
> +XFS_ERRTAG(IFLUSH_5,		iflush5,		XFS_RANDOM_DEFAULT) \
> +XFS_ERRTAG(IFLUSH_6,		iflush6,		XFS_RANDOM_DEFAULT) \
> +XFS_ERRTAG(DA_READ_BUF,		dareadbuf,		XFS_RANDOM_DEFAULT) \
> +XFS_ERRTAG(BTREE_CHECK_LBLOCK,	btree_chk_lblk,		XFS_RANDOM_DEFAULT/4) \
> +XFS_ERRTAG(BTREE_CHECK_SBLOCK,	btree_chk_sblk,		XFS_RANDOM_DEFAULT) \
> +XFS_ERRTAG(ALLOC_READ_AGF,	readagf,		XFS_RANDOM_DEFAULT) \
> +XFS_ERRTAG(IALLOC_READ_AGI,	readagi,		XFS_RANDOM_DEFAULT) \
> +XFS_ERRTAG(ITOBP_INOTOBP,	itobp,			XFS_RANDOM_DEFAULT) \
> +XFS_ERRTAG(IUNLINK,		iunlink,		XFS_RANDOM_DEFAULT) \
> +XFS_ERRTAG(IUNLINK_REMOVE,	iunlinkrm,		XFS_RANDOM_DEFAULT) \
> +XFS_ERRTAG(DIR_INO_VALIDATE,	dirinovalid,		XFS_RANDOM_DEFAULT) \
> +XFS_ERRTAG(BULKSTAT_READ_CHUNK,	bulkstat,		XFS_RANDOM_DEFAULT) \
> +XFS_ERRTAG(IODONE_IOERR,	logiodone,		XFS_RANDOM_DEFAULT/10) \
> +XFS_ERRTAG(STRATREAD_IOERR,	stratread,		XFS_RANDOM_DEFAULT/10) \
> +XFS_ERRTAG(STRATCMPL_IOERR,	stratcmpl,		XFS_RANDOM_DEFAULT/10) \
> +XFS_ERRTAG(DIOWRITE_IOERR,	diowrite,		XFS_RANDOM_DEFAULT/10) \
> +XFS_ERRTAG(BMAPIFORMAT,		bmapifmt,		XFS_RANDOM_DEFAULT) \
> +XFS_ERRTAG(FREE_EXTENT,		free_extent,		1) \
> +XFS_ERRTAG(RMAP_FINISH_ONE,	rmap_finish_one,	1) \
> +XFS_ERRTAG(REFCOUNT_CONTINUE_UPDATE, refcount_continue_update, 1) \
> +XFS_ERRTAG(REFCOUNT_FINISH_ONE,	refcount_finish_one,	1) \
> +XFS_ERRTAG(BMAP_FINISH_ONE,	bmap_finish_one,	1) \
> +XFS_ERRTAG(AG_RESV_CRITICAL,	ag_resv_critical,	4) \
> +XFS_ERRTAG(LOG_BAD_CRC,		log_bad_crc,		1) \
> +XFS_ERRTAG(LOG_ITEM_PIN,	log_item_pin,		1) \
> +XFS_ERRTAG(BUF_LRU_REF,		buf_lru_ref,		2) \
> +XFS_ERRTAG(FORCE_SCRUB_REPAIR,	force_repair,		1) \
> +XFS_ERRTAG(FORCE_SUMMARY_RECALC, bad_summary,		1) \
> +XFS_ERRTAG(IUNLINK_FALLBACK,	iunlink_fallback,	XFS_RANDOM_DEFAULT/10) \
> +XFS_ERRTAG(BUF_IOERROR,		buf_ioerror,		XFS_RANDOM_DEFAULT) \
> +XFS_ERRTAG(REDUCE_MAX_IEXTENTS,	reduce_max_iextents,	1) \
> +XFS_ERRTAG(BMAP_ALLOC_MINLEN_EXTENT, bmap_alloc_minlen_extent, 1) \
> +XFS_ERRTAG(AG_RESV_FAIL,	ag_resv_fail,		1) \
> +XFS_ERRTAG(LARP,		larp,			1) \
> +XFS_ERRTAG(DA_LEAF_SPLIT,	da_leaf_split,		1) \
> +XFS_ERRTAG(ATTR_LEAF_TO_NODE,	attr_leaf_to_node,	1) \
> +XFS_ERRTAG(WB_DELAY_MS,		wb_delay_ms,		3000) \
> +XFS_ERRTAG(WRITE_DELAY_MS,	write_delay_ms,		3000) \
> +XFS_ERRTAG(EXCHMAPS_FINISH_ONE,	exchmaps_finish_one,	1) \
> +XFS_ERRTAG(METAFILE_RESV_CRITICAL, metafile_resv_crit,	4)
> +#endif /* XFS_ERRTAG */
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 44dd8aba0097..ac895cd2bc0a 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -10,61 +10,17 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_errortag.h"
>  #include "xfs_error.h"
>  #include "xfs_sysfs.h"
>  #include "xfs_inode.h"
>  
>  #ifdef DEBUG
>  
> -static unsigned int xfs_errortag_random_default[] = {
> -	XFS_RANDOM_DEFAULT,
> -	XFS_RANDOM_IFLUSH_1,
> -	XFS_RANDOM_IFLUSH_2,
> -	XFS_RANDOM_IFLUSH_3,
> -	XFS_RANDOM_IFLUSH_4,
> -	XFS_RANDOM_IFLUSH_5,
> -	XFS_RANDOM_IFLUSH_6,
> -	XFS_RANDOM_DA_READ_BUF,
> -	XFS_RANDOM_BTREE_CHECK_LBLOCK,
> -	XFS_RANDOM_BTREE_CHECK_SBLOCK,
> -	XFS_RANDOM_ALLOC_READ_AGF,
> -	XFS_RANDOM_IALLOC_READ_AGI,
> -	XFS_RANDOM_ITOBP_INOTOBP,
> -	XFS_RANDOM_IUNLINK,
> -	XFS_RANDOM_IUNLINK_REMOVE,
> -	XFS_RANDOM_DIR_INO_VALIDATE,
> -	XFS_RANDOM_BULKSTAT_READ_CHUNK,
> -	XFS_RANDOM_IODONE_IOERR,
> -	XFS_RANDOM_STRATREAD_IOERR,
> -	XFS_RANDOM_STRATCMPL_IOERR,
> -	XFS_RANDOM_DIOWRITE_IOERR,
> -	XFS_RANDOM_BMAPIFORMAT,
> -	XFS_RANDOM_FREE_EXTENT,
> -	XFS_RANDOM_RMAP_FINISH_ONE,
> -	XFS_RANDOM_REFCOUNT_CONTINUE_UPDATE,
> -	XFS_RANDOM_REFCOUNT_FINISH_ONE,
> -	XFS_RANDOM_BMAP_FINISH_ONE,
> -	XFS_RANDOM_AG_RESV_CRITICAL,
> -	0, /* XFS_RANDOM_DROP_WRITES has been removed */
> -	XFS_RANDOM_LOG_BAD_CRC,
> -	XFS_RANDOM_LOG_ITEM_PIN,
> -	XFS_RANDOM_BUF_LRU_REF,
> -	XFS_RANDOM_FORCE_SCRUB_REPAIR,
> -	XFS_RANDOM_FORCE_SUMMARY_RECALC,
> -	XFS_RANDOM_IUNLINK_FALLBACK,
> -	XFS_RANDOM_BUF_IOERROR,
> -	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
> -	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
> -	XFS_RANDOM_AG_RESV_FAIL,
> -	XFS_RANDOM_LARP,
> -	XFS_RANDOM_DA_LEAF_SPLIT,
> -	XFS_RANDOM_ATTR_LEAF_TO_NODE,
> -	XFS_RANDOM_WB_DELAY_MS,
> -	XFS_RANDOM_WRITE_DELAY_MS,
> -	XFS_RANDOM_EXCHMAPS_FINISH_ONE,
> -	XFS_RANDOM_METAFILE_RESV_CRITICAL,
> -};
> +#define XFS_ERRTAG(_tag, _name, _default) \
> +	[XFS_ERRTAG_##_tag]	= (_default),
> +#include "xfs_errortag.h"
> +static unsigned int xfs_errortag_random_default[] = { XFS_ERRTAGS };
> +#undef XFS_ERRTAG
>  
>  struct xfs_errortag_attr {
>  	struct attribute	attr;
> @@ -125,110 +81,28 @@ static const struct sysfs_ops xfs_errortag_sysfs_ops = {
>  	.store = xfs_errortag_attr_store,
>  };
>  
> -#define XFS_ERRORTAG_ATTR_RW(_name, _tag) \
> +#define XFS_ERRTAG(_tag, _name, _default)				\
>  static struct xfs_errortag_attr xfs_errortag_attr_##_name = {		\
>  	.attr = {.name = __stringify(_name),				\
>  		 .mode = VERIFY_OCTAL_PERMISSIONS(S_IWUSR | S_IRUGO) },	\
> -	.tag	= (_tag),						\
> -}
> -
> -#define XFS_ERRORTAG_ATTR_LIST(_name) &xfs_errortag_attr_##_name.attr
> -
> -XFS_ERRORTAG_ATTR_RW(noerror,		XFS_ERRTAG_NOERROR);
> -XFS_ERRORTAG_ATTR_RW(iflush1,		XFS_ERRTAG_IFLUSH_1);
> -XFS_ERRORTAG_ATTR_RW(iflush2,		XFS_ERRTAG_IFLUSH_2);
> -XFS_ERRORTAG_ATTR_RW(iflush3,		XFS_ERRTAG_IFLUSH_3);
> -XFS_ERRORTAG_ATTR_RW(iflush4,		XFS_ERRTAG_IFLUSH_4);
> -XFS_ERRORTAG_ATTR_RW(iflush5,		XFS_ERRTAG_IFLUSH_5);
> -XFS_ERRORTAG_ATTR_RW(iflush6,		XFS_ERRTAG_IFLUSH_6);
> -XFS_ERRORTAG_ATTR_RW(dareadbuf,		XFS_ERRTAG_DA_READ_BUF);
> -XFS_ERRORTAG_ATTR_RW(btree_chk_lblk,	XFS_ERRTAG_BTREE_CHECK_LBLOCK);
> -XFS_ERRORTAG_ATTR_RW(btree_chk_sblk,	XFS_ERRTAG_BTREE_CHECK_SBLOCK);
> -XFS_ERRORTAG_ATTR_RW(readagf,		XFS_ERRTAG_ALLOC_READ_AGF);
> -XFS_ERRORTAG_ATTR_RW(readagi,		XFS_ERRTAG_IALLOC_READ_AGI);
> -XFS_ERRORTAG_ATTR_RW(itobp,		XFS_ERRTAG_ITOBP_INOTOBP);
> -XFS_ERRORTAG_ATTR_RW(iunlink,		XFS_ERRTAG_IUNLINK);
> -XFS_ERRORTAG_ATTR_RW(iunlinkrm,		XFS_ERRTAG_IUNLINK_REMOVE);
> -XFS_ERRORTAG_ATTR_RW(dirinovalid,	XFS_ERRTAG_DIR_INO_VALIDATE);
> -XFS_ERRORTAG_ATTR_RW(bulkstat,		XFS_ERRTAG_BULKSTAT_READ_CHUNK);
> -XFS_ERRORTAG_ATTR_RW(logiodone,		XFS_ERRTAG_IODONE_IOERR);
> -XFS_ERRORTAG_ATTR_RW(stratread,		XFS_ERRTAG_STRATREAD_IOERR);
> -XFS_ERRORTAG_ATTR_RW(stratcmpl,		XFS_ERRTAG_STRATCMPL_IOERR);
> -XFS_ERRORTAG_ATTR_RW(diowrite,		XFS_ERRTAG_DIOWRITE_IOERR);
> -XFS_ERRORTAG_ATTR_RW(bmapifmt,		XFS_ERRTAG_BMAPIFORMAT);
> -XFS_ERRORTAG_ATTR_RW(free_extent,	XFS_ERRTAG_FREE_EXTENT);
> -XFS_ERRORTAG_ATTR_RW(rmap_finish_one,	XFS_ERRTAG_RMAP_FINISH_ONE);
> -XFS_ERRORTAG_ATTR_RW(refcount_continue_update,	XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE);
> -XFS_ERRORTAG_ATTR_RW(refcount_finish_one,	XFS_ERRTAG_REFCOUNT_FINISH_ONE);
> -XFS_ERRORTAG_ATTR_RW(bmap_finish_one,	XFS_ERRTAG_BMAP_FINISH_ONE);
> -XFS_ERRORTAG_ATTR_RW(ag_resv_critical,	XFS_ERRTAG_AG_RESV_CRITICAL);
> -XFS_ERRORTAG_ATTR_RW(log_bad_crc,	XFS_ERRTAG_LOG_BAD_CRC);
> -XFS_ERRORTAG_ATTR_RW(log_item_pin,	XFS_ERRTAG_LOG_ITEM_PIN);
> -XFS_ERRORTAG_ATTR_RW(buf_lru_ref,	XFS_ERRTAG_BUF_LRU_REF);
> -XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
> -XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
> -XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
> -XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
> -XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
> -XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
> -XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
> -XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
> -XFS_ERRORTAG_ATTR_RW(da_leaf_split,	XFS_ERRTAG_DA_LEAF_SPLIT);
> -XFS_ERRORTAG_ATTR_RW(attr_leaf_to_node,	XFS_ERRTAG_ATTR_LEAF_TO_NODE);
> -XFS_ERRORTAG_ATTR_RW(wb_delay_ms,	XFS_ERRTAG_WB_DELAY_MS);
> -XFS_ERRORTAG_ATTR_RW(write_delay_ms,	XFS_ERRTAG_WRITE_DELAY_MS);
> -XFS_ERRORTAG_ATTR_RW(exchmaps_finish_one, XFS_ERRTAG_EXCHMAPS_FINISH_ONE);
> -XFS_ERRORTAG_ATTR_RW(metafile_resv_crit, XFS_ERRTAG_METAFILE_RESV_CRITICAL);
> +	.tag	= XFS_ERRTAG_##_tag,					\
> +};
> +#include "xfs_errortag.h"
> +XFS_ERRTAGS
> +#undef XFS_ERRTAG
>  
> +#define XFS_ERRTAG(_tag, _name, _default) \
> +	&xfs_errortag_attr_##_name.attr,
> +#include "xfs_errortag.h"
>  static struct attribute *xfs_errortag_attrs[] = {
> -	XFS_ERRORTAG_ATTR_LIST(noerror),
> -	XFS_ERRORTAG_ATTR_LIST(iflush1),
> -	XFS_ERRORTAG_ATTR_LIST(iflush2),
> -	XFS_ERRORTAG_ATTR_LIST(iflush3),
> -	XFS_ERRORTAG_ATTR_LIST(iflush4),
> -	XFS_ERRORTAG_ATTR_LIST(iflush5),
> -	XFS_ERRORTAG_ATTR_LIST(iflush6),
> -	XFS_ERRORTAG_ATTR_LIST(dareadbuf),
> -	XFS_ERRORTAG_ATTR_LIST(btree_chk_lblk),
> -	XFS_ERRORTAG_ATTR_LIST(btree_chk_sblk),
> -	XFS_ERRORTAG_ATTR_LIST(readagf),
> -	XFS_ERRORTAG_ATTR_LIST(readagi),
> -	XFS_ERRORTAG_ATTR_LIST(itobp),
> -	XFS_ERRORTAG_ATTR_LIST(iunlink),
> -	XFS_ERRORTAG_ATTR_LIST(iunlinkrm),
> -	XFS_ERRORTAG_ATTR_LIST(dirinovalid),
> -	XFS_ERRORTAG_ATTR_LIST(bulkstat),
> -	XFS_ERRORTAG_ATTR_LIST(logiodone),
> -	XFS_ERRORTAG_ATTR_LIST(stratread),
> -	XFS_ERRORTAG_ATTR_LIST(stratcmpl),
> -	XFS_ERRORTAG_ATTR_LIST(diowrite),
> -	XFS_ERRORTAG_ATTR_LIST(bmapifmt),
> -	XFS_ERRORTAG_ATTR_LIST(free_extent),
> -	XFS_ERRORTAG_ATTR_LIST(rmap_finish_one),
> -	XFS_ERRORTAG_ATTR_LIST(refcount_continue_update),
> -	XFS_ERRORTAG_ATTR_LIST(refcount_finish_one),
> -	XFS_ERRORTAG_ATTR_LIST(bmap_finish_one),
> -	XFS_ERRORTAG_ATTR_LIST(ag_resv_critical),
> -	XFS_ERRORTAG_ATTR_LIST(log_bad_crc),
> -	XFS_ERRORTAG_ATTR_LIST(log_item_pin),
> -	XFS_ERRORTAG_ATTR_LIST(buf_lru_ref),
> -	XFS_ERRORTAG_ATTR_LIST(force_repair),
> -	XFS_ERRORTAG_ATTR_LIST(bad_summary),
> -	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
> -	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
> -	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
> -	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
> -	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
> -	XFS_ERRORTAG_ATTR_LIST(larp),
> -	XFS_ERRORTAG_ATTR_LIST(da_leaf_split),
> -	XFS_ERRORTAG_ATTR_LIST(attr_leaf_to_node),
> -	XFS_ERRORTAG_ATTR_LIST(wb_delay_ms),
> -	XFS_ERRORTAG_ATTR_LIST(write_delay_ms),
> -	XFS_ERRORTAG_ATTR_LIST(exchmaps_finish_one),
> -	XFS_ERRORTAG_ATTR_LIST(metafile_resv_crit),
> -	NULL,
> +	XFS_ERRTAGS
> +	NULL
>  };
>  ATTRIBUTE_GROUPS(xfs_errortag);
> +#undef XFS_ERRTAG
> +
> +/* -1 because XFS_ERRTAG_DROP_WRITES got removed, + 1 for NULL termination */
> +static_assert(ARRAY_SIZE(xfs_errortag_attrs) == XFS_ERRTAG_MAX);
>  
>  static const struct kobj_type xfs_errortag_ktype = {
>  	.release = xfs_sysfs_release,
> -- 
> 2.47.2
> 
> 
