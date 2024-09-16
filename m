Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D03D2233B
	for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2024 06:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726469752; cv=none; b=Aw7jtK3gGQ5GrgFHKEXHBb+Tk22CyJlqUK6c0Br9uacnlJkuGDl6egoIOHYC+fZzYVdJhUTSkXjXKz+MxTU0W6DimMVpHvujfj/gv8LRGLrusEzx89RqQArhEEFnyEGwI0/L1RWJ3qDMpIlmMsaNmxy8w6ZCgPzlxECAyCofZsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726469752; c=relaxed/simple;
	bh=BsgYoGTsDqbCL4aepved9xj9PWFHkuc+Rox9umyIzEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lnDXDjO2axsfdxRObmxwJT61nExp9xKUGmxU1J0Z7dWg6eUK2HpCnezY+6CYdhjRRgog5A+mro/K1d/M5Goz57tPxabXx9kR1/9xl87Ca25z/DWhW+olQLpnbYeGdKBCmrnkuZAyLx3weY1jaVBQxQF8fbYTaTG1YUIXf1ARzEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aJRergHh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aJRergHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417F9C4CEC4;
	Mon, 16 Sep 2024 06:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726469751;
	bh=BsgYoGTsDqbCL4aepved9xj9PWFHkuc+Rox9umyIzEo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aJRergHhCZLX4JnbvO4vj/lXgE7JV+MGb6gJnst5nUwy4kL+qnS6J5FLqk6qK9f6X
	 l8bSBMZokVZxZqk7YeuV8t9ahe7CeiuVM0wRIyxhRUIn5oYWpjNGkKI/5Fo2OhUHS4
	 wet+lqTRAt7Mug1TrQ7t3RRgYFRvIaC6VQTpgqhtNrPjlIb/GIqrUMjqrORd7XHOwQ
	 g6DdRW4ulEHAllzNSLgfOKYnhl/zuesxBkQH4vFZMNpVlhPF7B3cG4Me69JdIA7ta2
	 cntwcWILLRIQcYA6CCg6xLl+GAy4bCbCJFVxkzgkBnItQJdEt55fHRuC+QvS9BtZbf
	 XW7oFv7kCZzQg==
Date: Mon, 16 Sep 2024 08:55:47 +0200
From: Carlos Maiolino <cem@kernel.org>
To: liuhuan01@kylinos.cn
Cc: david@fromorbit.com, cmaiolino@redhat.com, djwong@kernel.org, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfs_db: make sure agblocks is valid to prevent
 corruption
Message-ID: <mjsnnp3nuilpltftn4wekvnegwa4dnwu2d3n2wh7bzy3shktxf@q5mozedlxnez>
References: <ZtZ0Z58+XHoFt84Q@dread.disaster.area>
 <20240903102401.14085-1-liuhuan01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240903102401.14085-1-liuhuan01@kylinos.cn>

On Tue, Sep 03, 2024 at 06:24:02PM GMT, liuhuan01@kylinos.cn wrote:
> From: liuh <liuhuan01@kylinos.cn>
> 
> Recently, I was testing xfstests. When I run xfs/350 case, it always generate coredump during the process.
> 	xfs_db -c "sb 0" -c "p agblocks" /dev/loop1

Please, don't send new versions in reply to old versions.

Carlos

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
> So, try to get agblocks from agf/agi 0, if agf/agi 0 length match, use it as agblocks.
> If failed use the default geometry to calc agblocks.
> 
> Signed-off-by: liuh <liuhuan01@kylinos.cn>
> ---
>  db/Makefile |   2 +-
>  db/init.c   | 142 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 143 insertions(+), 1 deletion(-)
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
> index cea25ae5..167bc777 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -38,6 +38,138 @@ usage(void)
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
> +	fprintf(stderr, "Attempting to guess AG length from device geometry. This may not work.\n");
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
> +
> +	if (*agsize >= XFS_MIN_AG_BLOCKS && *agsize <= XFS_MAX_AG_BLOCKS)
> +		fprintf(stderr, "Guessed AG length is %lu blocks.\n", *agsize);
> +}
> +
> +static xfs_agblock_t
> +xfs_get_agblock_from_agf(struct xfs_mount *mp)
> +{
> +	xfs_agblock_t agblocks = NULLAGBLOCK;
> +	int error;
> +	struct xfs_buf *bp;
> +	struct xfs_agf *agf;
> +
> +	error = -libxfs_buf_read_uncached(mp->m_ddev_targp,
> +			XFS_AGF_DADDR(mp), 1, 0, &bp, NULL);
> +	if (error) {
> +		fprintf(stderr, "AGF 0 length recovery failed\n");
> +		return NULLAGBLOCK;
> +	}
> +
> +	agf = bp->b_addr;
> +	if (be32_to_cpu(agf->agf_magicnum) == XFS_AGF_MAGIC)
> +		agblocks = be32_to_cpu(agf->agf_length);
> +
> +	libxfs_buf_relse(bp);
> +
> +	if (agblocks != NULLAGBLOCK)
> +		fprintf(stderr, "AGF 0 length %u blocks found.\n", agblocks);
> +	else
> +		fprintf(stderr, "AGF 0 length recovery failed.\n");
> +
> +	return agblocks;
> +}
> +
> +static xfs_agblock_t
> +xfs_get_agblock_from_agi(struct xfs_mount *mp)
> +{
> +	xfs_agblock_t agblocks = NULLAGBLOCK;
> +	int error;
> +	struct xfs_buf *bp;
> +	struct xfs_agi *agi;
> +
> +	error = -libxfs_buf_read_uncached(mp->m_ddev_targp,
> +			XFS_AGI_DADDR(mp), 1, 0, &bp, NULL);
> +	if (error) {
> +		fprintf(stderr, "AGI 0 length recovery failed\n");
> +		return NULLAGBLOCK;
> +	}
> +
> +
> +	agi = bp->b_addr;
> +	if (be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC)
> +		agblocks = be32_to_cpu(agi->agi_length);
> +
> +	libxfs_buf_relse(bp);
> +
> +	if (agblocks != NULLAGBLOCK)
> +		fprintf(stderr, "AGI 0 length %u blocks found.\n", agblocks);
> +	else
> +		fprintf(stderr, "AGI 0 length recovery failed.\n");
> +
> +	return agblocks;
> +}
> +
> +/*
> + * Try to get it from agf/agi length when primary superblock agblocks damaged.
> + * If agf matchs agi length, use it as agblocks, otherwise use the default geometry
> + * to calc agblocks
> + */
> +static xfs_agblock_t
> +xfs_try_get_agblocks(struct xfs_mount *mp, struct libxfs_init *x)
> +{
> +	xfs_agblock_t agblocks = NULLAGBLOCK;
> +	xfs_agblock_t agblocks_agf, agblocks_agi;
> +	uint64_t agsize, agcount;
> +
> +	fprintf(stderr, "Attempting recovery from AGF/AGI 0 metadata...\n");
> +
> +	agblocks_agf = xfs_get_agblock_from_agf(mp);
> +	agblocks_agi = xfs_get_agblock_from_agi(mp);
> +
> +	if (agblocks_agf == agblocks_agi && agblocks_agf >= XFS_MIN_AG_BLOCKS && agblocks_agf <= XFS_MAX_AG_BLOCKS) {
> +		fprintf(stderr, "AGF/AGI 0 length matches.\n");
> +		fprintf(stderr, "Using %u blocks for superblock agblocks\n", agblocks_agf);
> +		return agblocks_agf;
> +	}
> +
> +	/* use default geometry to calc agblocks/agcount */
> +	xfs_guess_default_ag_geometry(&agsize, &agcount, x);
> +
> +	/* choose the agblocks among agf/agi length and agsize */
> +	if (agblocks_agf == agsize && agsize >= XFS_MIN_AG_BLOCKS && agsize <= XFS_MAX_AG_BLOCKS) {
> +		fprintf(stderr, "Guessed AG matchs AGF length\n");
> +		agblocks = agsize;
> +	} else if (agblocks_agi == agsize && agsize >= XFS_MIN_AG_BLOCKS && agsize <= XFS_MAX_AG_BLOCKS) {
> +		fprintf(stderr, "Guessed AG matchs AGI length\n");
> +		agblocks = agsize;
> +	} else if (agsize >= XFS_MIN_AG_BLOCKS && agsize <= XFS_MAX_AG_BLOCKS) {
> +		fprintf(stderr, "Guessed AG does not match AGF/AGI 0 length.\n");
> +		agblocks =  agsize;
> +	} else {
> +		fprintf(stderr, "_(%s: device too small to hold a valid XFS filesystem)", progname);
> +		exit(1);
> +	}
> +
> +	fprintf(stderr, "Using %u blocks for superblock agblocks.\n", agblocks);
> +
> +	return agblocks;
> +}
> +
>  static void
>  init(
>  	int		argc,
> @@ -129,6 +261,16 @@ init(
>  		}
>  	}
>  
> +	/* If sb_agblocks was damaged, try to get agblocks */
> +	if (sbp->sb_agblocks < XFS_MIN_AG_BLOCKS || sbp->sb_agblocks > XFS_MAX_AG_BLOCKS) {
> +		xfs_agblock_t agblocks;
> +
> +		fprintf(stderr, "Out of bounds superblock agblocks (%u) found.\n", sbp->sb_agblocks);
> +
> +		agblocks = xfs_try_get_agblocks(&xmount, &x);
> +		sbp->sb_agblocks = agblocks;
> +	}
> +
>  	agcount = sbp->sb_agcount;
>  	mp = libxfs_mount(&xmount, sbp, &x, LIBXFS_MOUNT_DEBUGGER);
>  	if (!mp) {
> -- 
> 2.43.0
> 
> 
