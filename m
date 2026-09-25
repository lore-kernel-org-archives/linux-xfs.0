Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E53F48097C
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 23:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790379840; cv=none; b=FHMGXn7KuPMo61T5hoVBZfaXpz1h540hiXChKElAWkihUpUNO0SbrPrgB/XaqrIWaYwWtVZeoCdetk8uJzd/Qg1JejhDYhV44LZjvOsm5d9/bnOMouge6kNaFWl4/eCsfCGEnF6NSwSNnp1dYotGmRBPwPREjRwjFcR5Yqc9qqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790379840; c=relaxed/simple;
	bh=TVMBNGMir/vMWUA+T8AP35GgUbuCaiBpKKUOKJ+n6K4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oeih3uv91Ds3FK07vuJtuI905dUFW17soYsyfkNhSeeYuH88PytPR+Zm8SJMfDfwos3oTJl7zgzUw/+wIZYAK8L2kN03p8ouWiGqB/hcB/rrG2c06e59/NlKHTC6aOvUJ98gqyWyYwxMCvBhq1frrhmteOyI4EUvjKnE2w3yYUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/cda0fE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/cda0fE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8A8111F000FF;
	Fri, 25 Sep 2026 23:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790379838;
	bh=bb4yCGjk+UA6UWwHaEke59ZmLG9kTCEo0opZxnKV+Bk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h/cda0fEKZKPDaVNq7ruG8/AXg42KM0Lx3Kcr4Vb0j8T9OQU2GvaNoWGL0Ex2fYY7
	 pNbUYFtDKmfHfOTR0Y8pf5XpfxaNNjwMWotbLTqa/3/qu0o5A9TFX7MqfRxg+f4uOz
	 mqzh9H13ABG4o/dxbbzPvUmXhvt9SQ2p8I8ktcW3oPfVGm/iNteZlCHwtm6mmR6SJC
	 MIgFI6j4lnJYNXOtVl5LuBkx2m66Lx/p/0HUbMmR2Eaw/mhfcgR0dHSc+79vmb9nxE
	 Ja8+DlJeSNrZEkXk7XNSZXO+2bMIB4JNWEpMmD+TzsigvFavRU8HzLA1FQNp4I3H8i
	 rKO7voY801u8Q==
Date: Fri, 25 Sep 2026 16:43:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/32] xfs_db: support RT data checksum
Message-ID: <20260925234358.GP2705364@frogsfrogsfrogs>
References: <20260924100512.2733748-1-hch@lst.de>
 <20260924100512.2733748-31-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100512.2733748-31-hch@lst.de>

On Thu, Sep 24, 2026 at 12:04:20PM +0200, Christoph Hellwig wrote:
> Support printing the new super block fields, and content of the per-RTG
> rtcsum files.
> 
> Note that the superblock fields are printed for all metadir file systems
> because they reuse space that previously was padding.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  db/block.c        | 10 +++++++++-
>  db/field.c        |  2 ++
>  db/field.h        |  1 +
>  db/inode.c        |  2 ++
>  db/rtgroup.c      | 42 ++++++++++++++++++++++++++++++++++++++++++
>  db/rtgroup.h      |  5 +++++
>  db/sb.c           | 10 ++++++++--
>  db/type.c         |  5 +++++
>  db/type.h         |  1 +
>  man/man8/xfs_db.8 | 13 ++++++++++++-
>  10 files changed, 87 insertions(+), 4 deletions(-)
> 
> diff --git a/db/block.c b/db/block.c
> index 2f1978c41f30..c6dd50dfa764 100644
> --- a/db/block.c
> +++ b/db/block.c
> @@ -263,7 +263,15 @@ dblock_f(
>  		dbprintf(_("no type for file data\n"));
>  		return 0;
>  	}
> -	nex = nb = type == TYP_DIR2 ? mp->m_dir_geo->fsbcount : 1;
> +
> +	if (type == TYP_DIR2)
> +		nb = mp->m_dir_geo->fsbcount;
> +	else if (type == TYP_RTCSUM)
> +		nb = XFS_B_TO_FSB(mp, 1u << mp->m_sb.sb_rtcsum_blklog);
> +	else
> +		nb = 1;
> +
> +	nex = nb;
>  	bmp = malloc(nb * sizeof(*bmp));
>  	bmap(bno, nb, XFS_DATA_FORK, &nex, bmp);
>  	if (nex == 0) {
> diff --git a/db/field.c b/db/field.c
> index 62c983fc3d49..275f175493df 100644
> --- a/db/field.c
> +++ b/db/field.c
> @@ -441,6 +441,8 @@ const ftattr_t	ftattrtab[] = {
>  	  0, NULL, NULL },
>  	{ FLDT_RGSUMMARY, "rgsummary", NULL, (char *)rgsummary_flds,
>  	  btblock_size, FTARG_SIZE, NULL, rgsummary_flds },
> +	{ FLDT_RTCSUM, "rtcsum", NULL, (char *)rtcsum_flds,
> +	  rtcsumblock_size, FTARG_SIZE, NULL, rtcsum_flds },
>  
>  	{ FLDT_ZZZ, NULL }
>  };
> diff --git a/db/field.h b/db/field.h
> index 27df5a0fcd1b..77f84d55cb62 100644
> --- a/db/field.h
> +++ b/db/field.h
> @@ -211,6 +211,7 @@ typedef enum fldt	{
>  	FLDT_RGBITMAP,
>  	FLDT_SUMINFO,
>  	FLDT_RGSUMMARY,
> +	FLDT_RTCSUM,
>  
>  	FLDT_ZZZ			/* mark last entry */
>  } fldt_t;
> diff --git a/db/inode.c b/db/inode.c
> index 46f83f18f083..a77595427c56 100644
> --- a/db/inode.c
> +++ b/db/inode.c
> @@ -727,6 +727,8 @@ inode_next_type(void)
>  				return TYP_RTRMAPBT;
>  			case XFS_METAFILE_RTREFCOUNT:
>  				return TYP_RTREFCBT;
> +			case XFS_METAFILE_RTCSUM:
> +				return TYP_RTCSUM;
>  			default:
>  				return TYP_DATA;
>  			}
> diff --git a/db/rtgroup.c b/db/rtgroup.c
> index c6b96c9dc79d..666adb2feb33 100644
> --- a/db/rtgroup.c
> +++ b/db/rtgroup.c
> @@ -16,6 +16,8 @@
>  #include "output.h"
>  #include "init.h"
>  #include "rtgroup.h"
> +#include "libfrog/crc64.h"
> +#include "xfs_rtcsumfile.h"
>  
>  #define uuid_equal(s,d)		(platform_uuid_compare((s),(d)) == 0)
>  
> @@ -152,3 +154,43 @@ const field_t	rgsummary_hfld[] = {
>  	{ "", FLDT_RGSUMMARY, OI(0), C1, 0, TYP_NONE },
>  	{ NULL }
>  };
> +
> +/*
> + * Get the size of a rtcsum block.
> + */
> +int
> +rtcsumblock_size(
> +	void	*obj,
> +	int	startoff,
> +	int	idx)
> +{
> +	return bitize(1u << mp->m_sb.sb_rtcsum_blklog);
> +}
> +
> +static int
> +rtcsum_count(
> +	void			*obj,
> +	int			startoff)
> +{
> +	return xfs_rtcsum_payload_size(mp) >> mp->m_rtcsum_shift;
> +}
> +
> +#define	OFF(f)	bitize(offsetof(struct xfs_rtbuf_blkinfo, rt_ ## f))
> +const field_t rtcsum_flds[] = {
> +	{ "magicnum", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
> +	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
> +	{ "owner", FLDT_INO, OI(OFF(owner)), C1, 0, TYP_NONE },
> +	{ "bno", FLDT_DFSBNO, OI(OFF(blkno)), C1, 0, TYP_BMAPBTD },
> +	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
> +	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
> +	/* the checksums are after the blkinfo structure */
> +	{ "csums", FLDT_SUMINFO, OI(bitize(sizeof(struct xfs_rtbuf_blkinfo))),

FLDT_SUMINFO is 4 bytes, this won't work for crc64.

You might want to add a FLDT_CRC32C and FLDT_CRC64 so that the sizes can
be correct, db can convert them from big-endian to host for display, and
the display can be '0x%x' instead of decimal.

--D

> +	  rtcsum_count, FLD_ARRAY | FLD_COUNT, TYP_DATA },
> +	{ NULL }
> +};
> +#undef OFF
> +
> +const field_t rtcsum_hfld[] = {
> +	{ "", FLDT_RTCSUM, OI(0), C1, 0, TYP_NONE },
> +	{ NULL }
> +};
> diff --git a/db/rtgroup.h b/db/rtgroup.h
> index 5b120f2c9a29..b674154fcbad 100644
> --- a/db/rtgroup.h
> +++ b/db/rtgroup.h
> @@ -15,6 +15,11 @@ extern const struct field	rgbitmap_hfld[];
>  extern const struct field	rgsummary_flds[];
>  extern const struct field	rgsummary_hfld[];
>  
> +extern const struct field	rtcsum_flds[];
> +extern const struct field	rtcsum_hfld[];
> +
> +int rtcsumblock_size(void *obj, int startoff, int idx);
> +
>  extern void	rtsb_init(void);
>  extern int	rtsb_size(void *obj, int startoff, int idx);
>  
> diff --git a/db/sb.c b/db/sb.c
> index 666207145a86..c565e6535f63 100644
> --- a/db/sb.c
> +++ b/db/sb.c
> @@ -144,8 +144,14 @@ const field_t	sb_flds[] = {
>  		FLD_COUNT, TYP_NONE },
>  	{ "pad", FLDT_UINT8X, OI(OFF(pad)), metadirfld_count,
>  		FLD_COUNT, TYP_NONE },
> -	{ "rtstart", FLDT_DRFSBNO, OI(OFF(rtstart)), zonedfld_count, FLD_COUNT, TYP_NONE },
> -	{ "rtreserved", FLDT_UINT64D, OI(OFF(rtreserved)), zonedfld_count, FLD_COUNT, TYP_NONE },
> +	{ "rtcsum_type", FLDT_UINT8D, OI(OFF(rtcsum_type)), metadirfld_count,
> +		FLD_COUNT, TYP_NONE },
> +	{ "rtcsum_blklog", FLDT_UINT8D, OI(OFF(rtcsum_blklog)), metadirfld_count,
> +		FLD_COUNT, TYP_NONE },
> +	{ "rtstart", FLDT_DRFSBNO, OI(OFF(rtstart)), zonedfld_count,
> +		FLD_COUNT, TYP_NONE },
> +	{ "rtreserved", FLDT_UINT64D, OI(OFF(rtreserved)), zonedfld_count,
> +		FLD_COUNT, TYP_NONE },
>  	{ NULL }
>  };
>  
> diff --git a/db/type.c b/db/type.c
> index 324f416a49cc..2db5b5f6a54d 100644
> --- a/db/type.c
> +++ b/db/type.c
> @@ -71,6 +71,7 @@ static const typ_t	__typtab[] = {
>  		TYP_F_NO_CRC_OFF },
>  	{ TYP_RGBITMAP, NULL },
>  	{ TYP_RGSUMMARY, NULL },
> +	{ TYP_RTCSUM, NULL },
>  	{ TYP_NONE, NULL }
>  };
>  
> @@ -125,6 +126,8 @@ static const typ_t	__typtab_crc[] = {
>  		&xfs_rtbitmap_buf_ops, XFS_RTBUF_CRC_OFF },
>  	{ TYP_RGSUMMARY, "rgsummary", handle_struct, rgsummary_hfld,
>  		&xfs_rtsummary_buf_ops, XFS_RTBUF_CRC_OFF },
> +	{ TYP_RTCSUM, "rtcsum", handle_struct, rtcsum_hfld,
> +		&xfs_rtcsum_buf_ops, XFS_RTBUF_CRC_OFF },
>  	{ TYP_NONE, NULL }
>  };
>  
> @@ -179,6 +182,8 @@ static const typ_t	__typtab_spcrc[] = {
>  		&xfs_rtbitmap_buf_ops, XFS_RTBUF_CRC_OFF },
>  	{ TYP_RGSUMMARY, "rgsummary", handle_struct, rgsummary_hfld,
>  		&xfs_rtsummary_buf_ops, XFS_RTBUF_CRC_OFF },
> +	{ TYP_RTCSUM, "rtcsum", handle_struct, rtcsum_hfld,
> +		&xfs_rtcsum_buf_ops, XFS_RTBUF_CRC_OFF },
>  	{ TYP_NONE, NULL }
>  };
>  
> diff --git a/db/type.h b/db/type.h
> index a2488a663dbd..d95c83c78d17 100644
> --- a/db/type.h
> +++ b/db/type.h
> @@ -39,6 +39,7 @@ typedef enum typnm
>  	TYP_FINOBT,
>  	TYP_RGBITMAP,
>  	TYP_RGSUMMARY,
> +	TYP_RTCSUM,
>  	TYP_NONE
>  } typnm_t;
>  
> diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> index c2d4065944be..ab89d709b89e 100644
> --- a/man/man8/xfs_db.8
> +++ b/man/man8/xfs_db.8
> @@ -1356,7 +1356,8 @@ The possible data types are:
>  .BR agf ", " agfl ", " agi ", " attr ", " bmapbta ", " bmapbtd ,
>  .BR bnobt ", " cntbt ", " data ", " dir ", " dir2 ", " dqblk ,
>  .BR inobt ", " inode ", " log ", " refcntbt ", " rmapbt ", " rtbitmap ,
> -.BR rtsummary ", " sb ", " symlink ", " rtrmapbt ", " rtrefcbt ", and " text .
> +.BR rtsummary ", " sb ", " symlink ", " rtrmapbt ", " rtrefcbt ,
> +.BR rtcsum ", and " text .
>  See the TYPES section below for more information on these data types.
>  .TP
>  .BI "timelimit [" OPTIONS ]
> @@ -2644,6 +2645,16 @@ The first dimension is the size range,
>  the second dimension is the starting bitmap block number
>  (adjacent entries are for the same size, adjacent bitmap blocks).
>  .TP
> +.B rtcsum
> +For RT data-checksum enabled file systems, there is one data checksum file
> +for each realtime group.  The data checksum file contains the standard
> +RT block self-describing metadata header, and an array of the checksums
> +for the realtime group.  The size of each entry depends on the checksum
> +used: 4 bytes for
> +.BR crc32c
> +and 8 bytes for
> +.BR crc64 .
> +.TP
>  .B sb
>  There is one sb (superblock) structure per allocation group.
>  It is the first disk block in the allocation group.
> -- 
> 2.53.0
> 
> 
