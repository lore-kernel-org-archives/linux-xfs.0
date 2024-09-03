Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD751CDA10
	for <linux-xfs@vger.kernel.org>; Tue,  3 Sep 2024 02:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725330543; cv=none; b=Tiw/0KNQCGgX1roLVHKHL6RbclrmnOevVKz+HxFm7yy+D5zGxtFyxm3SsQ7Jrxzj2nCoTx3H/IGkid/XrhFpDGrm6WMu5MrIyqu8RiaV1KdEGlaLN5UrOwnt+aqEUA6Mvs2lF6/5fwQnOjOCv7EmlgzCt3mf+/It2OnyvHcLeAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725330543; c=relaxed/simple;
	bh=NDNR9RDJZ957813fqIb+Q20L1GC8ct5BOHqCfMXqeok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JS1TZ+aV2lTXLSQF2hLuEUZjgVYTKRUsQz2JQd2LzbTzscMK+pDKPtMv/Z08EbLzd50HxaVDRV1NgtPIICuxZhq0Fg8HBEhpZhsKH4P+Uw24dTpgVz6NuQ/Ap3q8Ly72yr36vCDw2GMfQ0RrVMsTrZRauo7RBLzsvJgezLad+SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=QnPMGbql; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="QnPMGbql"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2059112f0a7so9678185ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 02 Sep 2024 19:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1725330540; x=1725935340; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CKrEJi4jL+zUhgcEJL++mUQZQLtU3J+jR4nvH0bIG+k=;
        b=QnPMGbqlb3hedQNYRLWUyAm0r9+DFiV9n1OzgPjkpF8YyMZiB/Dpb5CycxRfsfr4zs
         o9m/kgNMKSGlEJKdI7SVS0hp1FCVFmFMPVSvCBGqgKpdp/CrrYTQGx2/Cl9OHVb93JK5
         dF3whP5j1o3LEYBJmLOeVpkeYqDpccz586YucIOlS3bJ7GPZ6GFbmV3lXQ2Oav48eqcm
         LkmzumqFNnAB8QxxsNgB+kr1mwpay5bNlDbUpz7QTF9dsZnyXwW1b/n0d18zhfwHPrht
         0hSaxCH73LNe0kBxJKwFJNKrfkNVTg9Kd3RCNtmSJNRMzaSAl3Em0y/Xplp4VgqCdiC1
         WAQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725330540; x=1725935340;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CKrEJi4jL+zUhgcEJL++mUQZQLtU3J+jR4nvH0bIG+k=;
        b=pAgsjl+sTLQAX3mnkhI3RgB+sh2WG+dRrTvpQqdJ+FT50YjFTUsCF4iSCfQwJxC/jb
         rE0KobiNy39lyEN4pCoD1eWDmh4g3gFYM5cjqAXdZucV2f64UvLvsVTXbJXr/tMwq10p
         P2ZFL+cEAaznSUPMPNpZUC4aJrz0KLQPJFUF3cNA83DzNAbsDO+G0/M86tqZNuvMjnLS
         D8vWm6CRLTXqOvIfKT5COK3U75jcFSR7qZdxnya/OPSeXpYqWMtPADe/5ztBbcKW7nm4
         xtDiv5ALGiUZU5uc3CkcvCQxb9YaHXnr70zo40UJFCD04ag0TfpYmaTcwm5wDDcCLrAx
         zDNg==
X-Forwarded-Encrypted: i=1; AJvYcCUyQvhsPTeLBrsQ+Aw43iAPsDbiOFNevcVKu9PLjaapEsT2BkS7B6rRk46hkYVjdYNqLx/tfx7MEhQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YztCzgKliA8Y4SGzTPZJR9sSAnRy1DE+7j8OPLy/2hrQIaSMj1T
	LSpdzZmLPS9GPsqxwj8tppNg4iknmGEA9cZbdT7uTRwe+FWFUB/k0oLydLeIR4U=
X-Google-Smtp-Source: AGHT+IGLSQDp/ZmPCmxswKrdbKzEjGgHFxnRsDtz2DXG6Q6SbpFAoH4s666PvVgxMXvod6MlUEzgJQ==
X-Received: by 2002:a17:902:c40e:b0:202:4640:cc68 with SMTP id d9443c01a7336-2050c48fb65mr141175725ad.59.1725330539715;
        Mon, 02 Sep 2024 19:28:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-205152b11dbsm71681635ad.50.2024.09.02.19.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 19:28:59 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1slJHr-0005hW-2i;
	Tue, 03 Sep 2024 12:28:55 +1000
Date: Tue, 3 Sep 2024 12:28:55 +1000
From: Dave Chinner <david@fromorbit.com>
To: liuhuan01@kylinos.cn
Cc: cmaiolino@redhat.com, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs_db: make sure agblocks is valid to prevent
 corruption
Message-ID: <ZtZ0Z58+XHoFt84Q@dread.disaster.area>
References: <Zs5jMo1Vzg9gxA/J@dread.disaster.area>
 <20240902101238.12895-1-liuhuan01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240902101238.12895-1-liuhuan01@kylinos.cn>

On Mon, Sep 02, 2024 at 06:12:39PM +0800, liuhuan01@kylinos.cn wrote:
> From: liuh <liuhuan01@kylinos.cn>
> 
> Recently, I was testing xfstests. When I run xfs/350 case, it always generate coredump during the process.
> 	xfs_db -c "sb 0" -c "p agblocks" /dev/loop1
> 
> System will generate signal SIGFPE corrupt the process. And the stack as follow:
> corrupt at: (*bpp)->b_pag = xfs_perag_get(btp->bt_mount, xfs_daddr_to_agno(btp->bt_mount, blkno)); in function libxfs_getbuf_flags
> 	#0  libxfs_getbuf_flags
> 	#1  libxfs_getbuf_flags
> 	#2  libxfs_buf_read_map
> 	#3  libxfs_buf_read
> 	#4  libxfs_mount
> 	#5  init
> 	#6  main
> 
> The coredump was caused by the corrupt superblock metadata: (mp)->m_sb.sb_agblocks, it was 0.
> In this case, user cannot run in expert mode also.
> 
> So, try to get agblocks from agf/agi 0, if failed use the default geometry to calc agblocks.
> The worst thing is cannot get agblocks accroding above method, then set it to 1.
> 
> Signed-off-by: liuh <liuhuan01@kylinos.cn>
> ---
>  db/Makefile |   2 +-
>  db/init.c   | 128 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 129 insertions(+), 1 deletion(-)
> 
> diff --git a/db/Makefile b/db/Makefile
> index 83389376..322d5617 100644
> --- a/db/Makefile
> +++ b/db/Makefile
> @@ -68,7 +68,7 @@ CFILES = $(HFILES:.h=.c) \
>  LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
>  
>  LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBURCU) \
> -	  $(LIBPTHREAD)
> +	  $(LIBPTHREAD) $(LIBBLKID)
>  LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBFROG)
>  LLDFLAGS += -static-libtool-libs
>  
> diff --git a/db/init.c b/db/init.c
> index cea25ae5..15124ee2 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -38,6 +38,121 @@ usage(void)
>  	exit(1);
>  }
>  
> +static void
> +xfs_guess_default_ag_geometry(uint64_t *agsize, uint64_t *agcount, struct libxfs_init *x)
> +{
> +	struct fs_topology	ft;
> +	int			blocklog;
> +	uint64_t		dblocks;
> +	int			multidisk;
> +
> +	memset(&ft, 0, sizeof(ft));
> +	get_topology(x, &ft, 1);
> +
> +	/*
> +	 * get geometry from get_topology result.
> +	 * Use default block size (2^12)
> +	 */
> +	blocklog = 12;
> +	multidisk = ft.data.swidth | ft.data.sunit;
> +	dblocks = x->data.size >> (blocklog - BBSHIFT);
> +	calc_default_ag_geometry(blocklog, dblocks, multidisk,
> +				 agsize, agcount);
> +}
> +
> +static xfs_agblock_t
> +xfs_get_agblock_from_agf(struct xfs_mount *mp)
> +{
> +	xfs_agblock_t agblocks = 0;
> +	int error;
> +	struct xfs_buf *bp;
> +	struct xfs_agf *agf;
> +
> +	error = -libxfs_buf_read_uncached(mp->m_ddev_targp,
> +			XFS_AG_DADDR(mp, 0, XFS_AGF_DADDR(mp)),
> +			XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);

You're not checking what the code you wrote actually does.

#define XFS_AGB_TO_DADDR(mp,agno,agbno) \
        ((xfs_daddr_t)XFS_FSB_TO_BB(mp, \
                (xfs_fsblock_t)(agno) * (mp)->m_sb.sb_agblocks + (agbno)))
#define XFS_AG_DADDR(mp,agno,d)         (XFS_AGB_TO_DADDR(mp, agno, 0) + (d))

Yup, XFS_AG_DADDR() uses the very field we've already decided is
invalid....

In these cases where we specifically want to read from the AG 0
headers and we can't trust anything in the superblock, we need to
open code the daddrs we need to read from.

In this case the daddr of AGF 0 is simply XFS_AGF_DADDR(mp). And we
don't need XFS_FSS_TO_BB(), either - we can simply read a single
sector at that location as the AGF and AGI headers always fit in a
single sector.

Hence this should be:

	error = -libxfs_buf_read_uncached(mp->m_ddev_targp, XFS_AGF_DADDR(mp),
			1, 0, &bp, NULL);

> +	if (error) {
> +		fprintf(stderr, "xfs_get_agblock from agf-0 error %d\n", error);
> +		return agblocks;

Return NULLAGBLOCK on failure.

> +	}
> +
> +	if (xfs_has_crc(mp) && !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF)) {
> +		fprintf(stderr, "xfs_get_agblock from agf-0 badcrc\n");
> +		return agblocks;
> +	}

We can't trust the CRC to discover corruption here - syzbot corrupts
structures and then recalculates the CRC. Hence a good CRC is not an
indication of a valid, uncorrupted structure. And ignoring the CRC
allows a single sector read....

> +	agf = bp->b_addr;
> +	agblocks = be32_to_cpu(agf->agf_length);

This is missing magic number checks to determine if the metadata
returned is actually an AGF block.


> +
> +	libxfs_buf_relse(bp);
> +
> +	return agblocks;
> +}
> +
> +static xfs_agblock_t
> +xfs_get_agblock_from_agi(struct xfs_mount *mp)
> +{
> +	xfs_agblock_t agblocks = 0;
> +	int error;
> +	struct xfs_buf *bp;
> +	struct xfs_agi *agi;
> +
> +	error = -libxfs_buf_read_uncached(mp->m_ddev_targp,
> +			XFS_AG_DADDR(mp, 0, XFS_AGI_DADDR(mp)),
> +			XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
> +	if (error) {
> +		fprintf(stderr, "xfs_get_agblock from agi-0 error %d\n", error);
> +		return agblocks;
> +	}
> +
> +	if (xfs_has_crc(mp) && !xfs_buf_verify_cksum(bp, XFS_AGI_CRC_OFF)) {
> +		fprintf(stderr, "xfs_get_agblock from agi-0 badcrc\n");
> +		return agblocks;
> +	}
> +
> +	agi = bp->b_addr;
> +	agblocks = be32_to_cpu(agi->agi_length);
> +
> +	libxfs_buf_relse(bp);
> +
> +	return agblocks;
> +}
> +
> +/*
> + * If sb_agblocks was damaged, try to read it from agf/agi 0.
> + * With read agf/agi fails use default geometry to calc agblocks/agcount.
> + * The worst thing is cannot get agblocks according above method, then set to 1.
> + */
> +static xfs_agblock_t
> +xfs_try_get_agblocks(struct xfs_mount *mp, struct libxfs_init *x)
> +{
> +	xfs_agblock_t agblocks;
> +	uint64_t agsize, agcount;
> +
> +	/* firset try to get agblocks from agf-0 */
> +	agblocks = xfs_get_agblock_from_agf(mp);
> +	if (XFS_FSB_TO_B(mp, agblocks) >= XFS_MIN_AG_BYTES &&

Ah, did you look at what XFS_FSB_TO_B() requires to be set?

#define XFS_FSB_TO_B(mp,fsbno)  ((xfs_fsize_t)(fsbno) << (mp)->m_sb.sb_blocklog)

Essentially, detected that the superblock is damaged by using an
adjacent field in the superblock (which also may be damaged) to do
the validity check isn't reliable here.

We have XFS_MIN_AG_BLOCKS and XFS_MAX_AG_BLOCKS constants defined,
so that is what the validity checks here should use...

> +		XFS_FSB_TO_B(mp, agblocks) <= XFS_MAX_AG_BYTES)
> +		return agblocks;

We shouldn't return agblocks here - we need to validate that it is
the same as the AGI length because we can't trust a single value to
be correct if we have corruption in the headers.

i.e. if both AGI and AGF magic numbers are valid, and the lengths
match, it's a pretty good indication that this is the actual length
of the AG. It just doesn't matter if the AGF/AGI are
otherwise damaged and fail CRCs or pass the CRCs because of
malicious corruption, but if they match we can probably trust it to
be correct for the purposes of diagnosis.

> +	/* second try to get agblocks from agi-0 */
> +	agblocks = xfs_get_agblock_from_agi(mp);
> +	if (XFS_FSB_TO_B(mp, agblocks) >= XFS_MIN_AG_BYTES &&
> +		XFS_FSB_TO_B(mp, agblocks) <= XFS_MAX_AG_BYTES)
> +		return agblocks;
> +
> +	/* third use default geometry to calc agblocks/agcount */
> +	xfs_guess_default_ag_geometry(&agsize, &agcount, x);
> +
> +	if (XFS_FSB_TO_B(mp, agsize) < XFS_MIN_AG_BYTES ||
> +		XFS_FSB_TO_B(mp, agsize) > XFS_MAX_AG_BYTES)
> +		agblocks = 1; /* the worst is set to 1 */

*no*.

agblocks = 1 is *not a valid size* - why set an out-of-bounds value
for something we are already know is out-of-bounds?

Further, xfs_guess_default_ag_geometry() should never return an
invalid AG size unless the block device is under the minimum size
of an XFS filesystem. In which case, there's really nothing we can
do and should actually abort this saying "device too small to hold a
valid XFS filesystem".

> +	else
> +		agblocks = agsize;

The resultant should be probably be compared against the lengths
found from the AGI/AGF checks. If it matches one of them, we have
more confidence that this is the correct length.

> +
> +	return agblocks;
> +}
> +
>  static void
>  init(
>  	int		argc,
> @@ -129,6 +244,19 @@ init(
>  		}
>  	}
>  
> +	/* If sb_agblocks was damaged, try to get agblocks */
> +	if (XFS_FSB_TO_B(&xmount, sbp->sb_agblocks) < XFS_MIN_AG_BYTES ||
> +		XFS_FSB_TO_B(&xmount, sbp->sb_agblocks) > XFS_MAX_AG_BYTES) {
> +		xfs_agblock_t agblocks;
> +		xfs_agblock_t bad_agblocks = sbp->sb_agblocks;
> +
> +		agblocks = xfs_try_get_agblocks(&xmount, &x);
> +		sbp->sb_agblocks = agblocks;
> +
> +		fprintf(stderr, "wrong agblocks, try to get from agblocks %u -> %u\n",
> +			bad_agblocks, sbp->sb_agblocks);

What does this error message mean? If I saw that, I wouldn't have a
clue what it means.

I'd expect output something like this on a AGf/AGI recovery:

Out of bounds superblock agblocks (%u) found.
Attempting recovery from AGF/AGI 0 metadata....
AGF length %u blocks found.
AGI length %u blocks found.
AGF/AGI length matches.
Using %u blocks for superblock agblocks.

Or if AGF or AGI recovery fails:

Out of bounds superblock agblocks (%u) found.
Attempting recovery from AGF/AGI 0 metadata....
AGF length recovery failed.
AGI length %u blocks found.
Attempting to guess AG length from device geometry. This may not work.
Guessed AG length is %u blocks.
Guessed length matches AGI length.
Using %u blocks for superblock agblocks.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
