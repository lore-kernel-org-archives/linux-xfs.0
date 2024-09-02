Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80D61A3A93
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725303394; cv=none; b=ljPQ/6AUzWYfyg4rBTHk+mTAkSEsKAhViXx5XF7dH7eLaAwj5D3+sdZYXjo/trCrB2toXoeJ+GAphpzqSdcn+mXsSVMBl2rbIwqt6vJRBBwIdJ6q9CG6n/liwx0kQvAsG1sTSIVR5GJOXWwB3W+EJ0XJNYQ77KwyMD395m0wNYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725303394; c=relaxed/simple;
	bh=iUcs+xPallOPpfj4NWMd7dvIqH5aBXEgKV0j4sRXhKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jjKoNw7zb00IbbGDo5+lR8YYK1peRU9uZqLO29u52WKpKUt2dN0NMldlKM6aYXZE1Iikmg6uFcETAUO4+RhZNjdcPDxkh5lpVvuOjWrZwKPcPCMzzY254GIjF0mukABqw+VgFXfCx1oUHxAHpW85UY7pVxd8tJi1R3UK1gcXt9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c/7I3XCu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c/7I3XCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6E2C4CEC2;
	Mon,  2 Sep 2024 18:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725303394;
	bh=iUcs+xPallOPpfj4NWMd7dvIqH5aBXEgKV0j4sRXhKA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c/7I3XCullBE2dAzrUdCbOH4f1JzV24Ftnen/woVc1UxJwIV6y7nuIzKDIfSDk1s5
	 xNtvXoe3LtIqPockzL6W2kcU6v89cJAryZeTx1880T9f27+isauy+RY21UjaWZN55D
	 ufgwlzRz4OE4VlXWxDDVfFxzYyvCyzhM28FrlLgoh9XuHcoIGWzx/L+hHyQ02GYwtg
	 QArpjzmL8B9hl2YUh2AQHmaeSqR/zC+yNSdmBVqdR5NmAwRt7VwoYvDFUgn1wn6JEO
	 J838p9EebKwMfOGlFXVkJGMmZmVb7LLEyJcRe0RJSS5QkGb3E9Dp2s3THIiYXE6tSl
	 xiL2Az3QJlBiQ==
Date: Mon, 2 Sep 2024 11:56:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: liuhuan01@kylinos.cn
Cc: david@fromorbit.com, cmaiolino@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs_db: make sure agblocks is valid to prevent
 corruption
Message-ID: <20240902185633.GZ6224@frogsfrogsfrogs>
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

Why not call the full verifier on the buffer read?

> +	if (error) {
> +		fprintf(stderr, "xfs_get_agblock from agf-0 error %d\n", error);
> +		return agblocks;
> +	}
> +
> +	if (xfs_has_crc(mp) && !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF)) {
> +		fprintf(stderr, "xfs_get_agblock from agf-0 badcrc\n");
> +		return agblocks;
> +	}

Then you don't have to do this ^^^ stuff.

--D

> +	agf = bp->b_addr;
> +	agblocks = be32_to_cpu(agf->agf_length);
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
> +		XFS_FSB_TO_B(mp, agblocks) <= XFS_MAX_AG_BYTES)
> +		return agblocks;
> +
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
> +	else
> +		agblocks = agsize;
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
> +	}
> +
>  	agcount = sbp->sb_agcount;
>  	mp = libxfs_mount(&xmount, sbp, &x, LIBXFS_MOUNT_DEBUGGER);
>  	if (!mp) {
> -- 
> 2.43.0
> 
> 
