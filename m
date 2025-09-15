Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE89280325
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 19:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757963476; cv=none; b=ok7PmPYdA99MoMnz4BXoiiBQHY3WjqXaJA2ffuBOvbtj3Qk9p5iK3XsnKrNsIfoqF1mW26KtpKqLffWIvjv+gN+0/QmywwERacmRLBFD6R2ooh3FM/jbxrzFggnd9VDBOv35/6SsoMYjtWA/oMftId7+gBrWxiLHjXGNYdn9xtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757963476; c=relaxed/simple;
	bh=MxSoAJFCtZ3eNvS+6E+y1SsHJYELc/B15Qzg5C1yKQY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bb6Hj2CQ99XohJd9009oRsjNnQS3ngCSHgN4rlb+TSSPqwZn2TzJR7SpCH5QME49yk31CXcc77Hxmpm1jULVvCBEZwp/3VmIxsUa6jOWI2kiup4OUilG7VCo8oqB/aRpExqYSv5+ZJY566kdhz9uX43I3CSjgWL/MP7Xkokkk/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QDkTQeW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QDkTQeW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53EDEC4CEFB;
	Mon, 15 Sep 2025 19:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757963476;
	bh=MxSoAJFCtZ3eNvS+6E+y1SsHJYELc/B15Qzg5C1yKQY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QDkTQeW64A+TVnWFmTCC552/BZ8JspgDboyaLSvhCQjEPPKKTolRIiTwikKB2whNx
	 d1IitfvAXkelNsJ7fmiG5xBaN3iqbtWWTDvRcFT5n/ifp5Y84ljm5rIx0YVitqBf2C
	 a4eMdtmxmmJa4kolx5cCEui6y/MJQrMzfOhelg0zUNTBFFUzJ+9MsT9tEFiaF8nwAY
	 i1BM+gLALtdpyJVY9li4g/LTpFM4nl5L2HYimwpqsDugmEPP2ZMh1H6QlvfloM42c3
	 No+NV3mYeh/G9GzmPyAZH1YHAMcVgmxFdmnSrejpZHYFN/bOd60auG6K6V3KVCVBSN
	 v3BYG8BoSK0IQ==
Date: Mon, 15 Sep 2025 12:11:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_io: use the XFS_ERRTAG macro to generate
 injection targets
Message-ID: <20250915191115.GZ8096@frogsfrogsfrogs>
References: <20250915133336.161352-1-hch@lst.de>
 <20250915133336.161352-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915133336.161352-3-hch@lst.de>

On Mon, Sep 15, 2025 at 06:33:17AM -0700, Christoph Hellwig wrote:
> Use the new magic macro table provided by libxfs to autogenerate
> the list of valid error injection targets.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

With this applied we no longer have to manually update inject.c every
time we do a libxfs port too, right?

If yes, then
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  io/inject.c | 108 +++++++++++++++++-----------------------------------
>  1 file changed, 35 insertions(+), 73 deletions(-)
> 
> diff --git a/io/inject.c b/io/inject.c
> index 7b9a76406cc5..99186c081230 100644
> --- a/io/inject.c
> +++ b/io/inject.c
> @@ -12,89 +12,49 @@
>  
>  static cmdinfo_t inject_cmd;
>  
> +#define ARRAY_SIZE(x)		(sizeof(x) / sizeof((x)[0]))
> +#define __stringify_1(x...)	#x
> +#define __stringify(x...)	__stringify_1(x)
> +
> +#define XFS_ERRTAG(_tag, _name, _default) \
> +        [XFS_ERRTAG_##_tag]	=  __stringify(_name),
> +#include "xfs_errortag.h"
> +static const char *tag_names[] = { XFS_ERRTAGS };
> +#undef XFS_ERRTAG
> +
> +/* Search for a name */
>  static int
> -error_tag(char *name)
> +error_tag(
> +	char		*name)
>  {
> -	static struct {
> -		int	tag;
> -		char	*name;
> -	} *e, eflags[] = {
> -		{ XFS_ERRTAG_NOERROR,			"noerror" },
> -		{ XFS_ERRTAG_IFLUSH_1,			"iflush1" },
> -		{ XFS_ERRTAG_IFLUSH_2,			"iflush2" },
> -		{ XFS_ERRTAG_IFLUSH_3,			"iflush3" },
> -		{ XFS_ERRTAG_IFLUSH_4,			"iflush4" },
> -		{ XFS_ERRTAG_IFLUSH_5,			"iflush5" },
> -		{ XFS_ERRTAG_IFLUSH_6,			"iflush6" },
> -		{ XFS_ERRTAG_DA_READ_BUF,		"dareadbuf" },
> -		{ XFS_ERRTAG_BTREE_CHECK_LBLOCK,	"btree_chk_lblk" },
> -		{ XFS_ERRTAG_BTREE_CHECK_SBLOCK,	"btree_chk_sblk" },
> -		{ XFS_ERRTAG_ALLOC_READ_AGF,		"readagf" },
> -		{ XFS_ERRTAG_IALLOC_READ_AGI,		"readagi" },
> -		{ XFS_ERRTAG_ITOBP_INOTOBP,		"itobp" },
> -		{ XFS_ERRTAG_IUNLINK,			"iunlink" },
> -		{ XFS_ERRTAG_IUNLINK_REMOVE,		"iunlinkrm" },
> -		{ XFS_ERRTAG_DIR_INO_VALIDATE,		"dirinovalid" },
> -		{ XFS_ERRTAG_BULKSTAT_READ_CHUNK,	"bulkstat" },
> -		{ XFS_ERRTAG_IODONE_IOERR,		"logiodone" },
> -		{ XFS_ERRTAG_STRATREAD_IOERR,		"stratread" },
> -		{ XFS_ERRTAG_STRATCMPL_IOERR,		"stratcmpl" },
> -		{ XFS_ERRTAG_DIOWRITE_IOERR,		"diowrite" },
> -		{ XFS_ERRTAG_BMAPIFORMAT,		"bmapifmt" },
> -		{ XFS_ERRTAG_FREE_EXTENT,		"free_extent" },
> -		{ XFS_ERRTAG_RMAP_FINISH_ONE,		"rmap_finish_one" },
> -		{ XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE,	"refcount_continue_update" },
> -		{ XFS_ERRTAG_REFCOUNT_FINISH_ONE,	"refcount_finish_one" },
> -		{ XFS_ERRTAG_BMAP_FINISH_ONE,		"bmap_finish_one" },
> -		{ XFS_ERRTAG_AG_RESV_CRITICAL,		"ag_resv_critical" },
> -		{ XFS_ERRTAG_DROP_WRITES,		"drop_writes" },
> -		{ XFS_ERRTAG_LOG_BAD_CRC,		"log_bad_crc" },
> -		{ XFS_ERRTAG_LOG_ITEM_PIN,		"log_item_pin" },
> -		{ XFS_ERRTAG_BUF_LRU_REF,		"buf_lru_ref" },
> -		{ XFS_ERRTAG_FORCE_SCRUB_REPAIR,	"force_repair" },
> -		{ XFS_ERRTAG_FORCE_SUMMARY_RECALC,	"bad_summary" },
> -		{ XFS_ERRTAG_IUNLINK_FALLBACK,		"iunlink_fallback" },
> -		{ XFS_ERRTAG_BUF_IOERROR,		"buf_ioerror" },
> -		{ XFS_ERRTAG_REDUCE_MAX_IEXTENTS,	"reduce_max_iextents" },
> -		{ XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT,	"bmap_alloc_minlen_extent" },
> -		{ XFS_ERRTAG_AG_RESV_FAIL,		"ag_resv_fail" },
> -		{ XFS_ERRTAG_LARP,			"larp" },
> -		{ XFS_ERRTAG_DA_LEAF_SPLIT,		"da_leaf_split" },
> -		{ XFS_ERRTAG_ATTR_LEAF_TO_NODE,		"attr_leaf_to_node" },
> -		{ XFS_ERRTAG_WB_DELAY_MS,		"wb_delay_ms" },
> -		{ XFS_ERRTAG_WRITE_DELAY_MS,		"write_delay_ms" },
> -		{ XFS_ERRTAG_EXCHMAPS_FINISH_ONE,	"exchmaps_finish_one" },
> -		{ XFS_ERRTAG_METAFILE_RESV_CRITICAL,	"metafile_resv_crit" },
> -		{ XFS_ERRTAG_MAX,			NULL }
> -	};
> -	int	count;
> +	unsigned int	i;
>  
> -	/*
> -	 * If this fails make sure every tag is defined in the array above,
> -	 * see xfs_errortag_attrs in kernelspace.
> -	 */
> -	BUILD_BUG_ON(sizeof(eflags) != (XFS_ERRTAG_MAX + 1) * sizeof(*e));
> +	for (i = 0; i < ARRAY_SIZE(tag_names); i++)
> +		if (tag_names[i] && strcmp(name, tag_names[i]) == 0)
> +			return i;
> +	return -1;
> +}
>  
> -	/* Search for a name */
> -	if (name) {
> -		for (e = eflags; e->name; e++)
> -			if (strcmp(name, e->name) == 0)
> -				return e->tag;
> -		return -1;
> -	}
> +/* Dump all the names */
> +static void
> +list_tags(void)
> +{
> +	unsigned int	count = 0, i;
>  
> -	/* Dump all the names */
>  	fputs("tags: [ ", stdout);
> -	for (count = 0, e = eflags; e->name; e++, count++) {
> -		if (count) {
> +	for (i = 0; i < ARRAY_SIZE(tag_names); i++) {
> +		if (count > 0) {
>  			fputs(", ", stdout);
>  			if (!(count % 5))
>  				fputs("\n\t", stdout);
>  		}
> -		fputs(e->name, stdout);
> +		if (tag_names[i]) {
> +			fputs(tag_names[i], stdout);
> +			count++;
> +		}
> +
>  	}
>  	fputs(" ]\n", stdout);
> -	return 0;
>  }
>  
>  static void
> @@ -121,8 +81,10 @@ inject_f(
>  	xfs_error_injection_t	error;
>  	int			command = XFS_IOC_ERROR_INJECTION;
>  
> -	if (argc == 1)
> -		return error_tag(NULL);
> +	if (argc == 1) {
> +		list_tags();
> +		return 0;
> +	}
>  
>  	while (--argc > 0) {
>  		error.fd = file->fd;
> -- 
> 2.47.2
> 
> 
