Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5503D1B86DD
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 20:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720558282; cv=none; b=FXb1A+cvZfx1zlMHQgr5EDjS4nH9ykKhRV2ToDzH4ghkRZnPwMtL3xRK0vbtOIqIh8RoJMs4HOgum2iDQ/bpSgpL26z3WkuHyLqvlrg/NUMPAVpKjr42S4juIMqgLAgAM8wePDcgyGSHocHEyGWzMt2ZX9dgQf9uSo0JXZ5oR8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720558282; c=relaxed/simple;
	bh=yIR7RcUyE5kmnxE22lm4QrDMm1vG/gqPJGkG0cVhQSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bZnG8t4yitK+expjEBtqa8CeyakYDwRpFrbBna5VxIsFex8sgEuS1w9bIjou2r4rRZOkpSHPq8C6nioYuz/HBPid9kuunQAqjyADu6+JIoi/6acXE7yW5XLSvDzVMxlAePx13f0KTFTnJ2ZqTAnyd8rKYJW2dmKBZW4siQwsD8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WZrPnaRQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WZrPnaRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF59C3277B;
	Tue,  9 Jul 2024 20:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720558282;
	bh=yIR7RcUyE5kmnxE22lm4QrDMm1vG/gqPJGkG0cVhQSQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WZrPnaRQJ6ezwEj3uDpUXL47SaE2mJlP/WmOyNjg2aeH5juh80HN+eLHgVFu94T17
	 od0s/aKFQyghtuXYGNMkdjda27l/oZk+T8BH+7WZo6X+nSbxOGhk0G6U2KVtxeG0fl
	 Ja4ocksnfJEb8E72MdqcA/yCNMn9zbn4njm0feWvLmxRR+EH4EXhxVWHprDUsUMF5L
	 klFnHjm6aoZ9VHFc7W3OUK3gmOZn4KIb9e6c2A3juaERQ3i1Sf1NdHL+Bdn+Z2QC7B
	 qyv4reDjfVABQ16JGjLyV3Kb3YVdDWYRJCQ/DnC7aBc3JMGFHZYdFitQ8+i7qCUg1K
	 Mz1BW5uRgIjcQ==
Date: Tue, 9 Jul 2024 13:51:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] spaceman/defrag: workaround kernel
 xfs_reflink_try_clear_inode_flag()
Message-ID: <20240709205121.GV612460@frogsfrogsfrogs>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-7-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709191028.2329-7-wen.gang.wang@oracle.com>

On Tue, Jul 09, 2024 at 12:10:25PM -0700, Wengang Wang wrote:
> xfs_reflink_try_clear_inode_flag() takes very long in case file has huge number
> of extents and none of the extents are shared.
> 
> workaround:
> share the first real extent so that xfs_reflink_try_clear_inode_flag() returns
> quickly to save cpu times and speed up defrag significantly.

I wonder if a better solution would be to change xfs_reflink_unshare
only to try to clear the reflink iflag if offset/len cover the entire
file?  It's a pity we can't set time budgets on fallocate requests.

--D

> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  spaceman/defrag.c | 174 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 172 insertions(+), 2 deletions(-)
> 
> diff --git a/spaceman/defrag.c b/spaceman/defrag.c
> index f8e6713c..b5c5b187 100644
> --- a/spaceman/defrag.c
> +++ b/spaceman/defrag.c
> @@ -327,6 +327,155 @@ defrag_fs_limit_hit(int fd)
>  	return statfs_s.f_bsize * statfs_s.f_bavail < g_limit_free_bytes;
>  }
>  
> +static bool g_enable_first_ext_share = true;
> +
> +static int
> +defrag_get_first_real_ext(int fd, struct getbmapx *mapx)
> +{
> +	int			err;
> +
> +	while (1) {
> +		err = defrag_get_next_extent(fd, mapx);
> +		if (err)
> +			break;
> +
> +		defrag_move_next_extent();
> +		if (!(mapx->bmv_oflags & BMV_OF_PREALLOC))
> +			break;
> +	}
> +	return err;
> +}
> +
> +static __u64 g_share_offset = -1ULL;
> +static __u64 g_share_len = 0ULL;
> +#define SHARE_MAX_SIZE 32768  /* 32KiB */
> +
> +/* share the first real extent with scrach */
> +static void
> +defrag_share_first_extent(int defrag_fd, int scratch_fd)
> +{
> +#define OFFSET_1PB 0x4000000000000LL
> +	struct file_clone_range clone;
> +	struct getbmapx mapx;
> +	int	err;
> +
> +	if (g_enable_first_ext_share == false)
> +		return;
> +
> +	err = defrag_get_first_real_ext(defrag_fd, &mapx);
> +	if (err)
> +		return;
> +
> +	clone.src_fd = defrag_fd;
> +	clone.src_offset = mapx.bmv_offset * 512;
> +	clone.src_length = mapx.bmv_length * 512;
> +	/* shares at most SHARE_MAX_SIZE length */
> +	if (clone.src_length > SHARE_MAX_SIZE)
> +		clone.src_length = SHARE_MAX_SIZE;
> +	clone.dest_offset = OFFSET_1PB + clone.src_offset;
> +	/* if the first is extent is reaching the EoF, no need to share */
> +	if (clone.src_offset + clone.src_length >= g_defrag_file_size)
> +		return;
> +	err = ioctl(scratch_fd, FICLONERANGE, &clone);
> +	if (err != 0) {
> +		fprintf(stderr, "cloning first extent failed: %s\n",
> +			strerror(errno));
> +		return;
> +	}
> +
> +	/* safe the offset and length for re-share */
> +	g_share_offset = clone.src_offset;
> +	g_share_len = clone.src_length;
> +}
> +
> +/* re-share the blocks we shared previous if then are no longer shared */
> +static void
> +defrag_reshare_blocks_in_front(int defrag_fd, int scratch_fd)
> +{
> +#define NR_GET_EXT 9
> +	struct getbmapx mapx[NR_GET_EXT];
> +	struct file_clone_range clone;
> +	__u64	new_share_len;
> +	int	idx, err;
> +
> +	if (g_enable_first_ext_share == false)
> +		return;
> +
> +	if (g_share_len == 0ULL)
> +		return;
> +
> +	/*
> +	 * check if previous shareing still exist
> +	 * we are done if (partially) so.
> +	 */
> +	mapx[0].bmv_offset = g_share_offset;
> +	mapx[0].bmv_length = g_share_len;
> +	mapx[0].bmv_count = NR_GET_EXT;
> +	mapx[0].bmv_iflags = BMV_IF_NO_HOLES | BMV_IF_PREALLOC;
> +	err = ioctl(defrag_fd, XFS_IOC_GETBMAPX, mapx);
> +	if (err) {
> +		fprintf(stderr, "XFS_IOC_GETBMAPX failed %s\n",
> +			strerror(errno));
> +		/* won't try share again */
> +		g_share_len = 0ULL;
> +		return;
> +	}
> +
> +	if (mapx[0].bmv_entries == 0) {
> +		/* shared blocks all became hole, won't try share again */
> +		g_share_len = 0ULL;
> +		return;
> +	}
> +
> +	if (g_share_offset != 512 * mapx[1].bmv_offset) {
> +		/* first shared block became hole, won't try share again */
> +		g_share_len = 0ULL;
> +		return;
> +	}
> +
> +	/* we check up to only the first NR_GET_EXT - 1 extents */
> +	for (idx = 1; idx <= mapx[0].bmv_entries; idx++) {
> +		if (mapx[idx].bmv_oflags & BMV_OF_SHARED) {
> +			/* some blocks still shared, done */
> +			return;
> +		}
> +	}
> +
> +	/*
> +	 * The previously shared blocks are no longer shared, re-share.
> +	 * deallocate the blocks in scrath file first
> +	 */
> +	err = fallocate(scratch_fd,
> +		FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE,
> +		OFFSET_1PB + g_share_offset, g_share_len);
> +	if (err != 0) {
> +		fprintf(stderr, "punch hole failed %s\n",
> +			strerror(errno));
> +		g_share_len = 0;
> +		return;
> +	}
> +
> +	new_share_len = 512 * mapx[1].bmv_length;
> +	if (new_share_len > SHARE_MAX_SIZE)
> +		new_share_len = SHARE_MAX_SIZE;
> +
> +	clone.src_fd = defrag_fd;
> +	/* keep starting offset unchanged */
> +	clone.src_offset = g_share_offset;
> +	clone.src_length = new_share_len;
> +	clone.dest_offset = OFFSET_1PB + clone.src_offset;
> +
> +	err = ioctl(scratch_fd, FICLONERANGE, &clone);
> +	if (err) {
> +		fprintf(stderr, "FICLONERANGE failed %s\n",
> +			strerror(errno));
> +		g_share_len = 0;
> +		return;
> +	}
> +
> +	g_share_len = new_share_len;
> + }
> +
>  /*
>   * defragment a file
>   * return 0 if successfully done, 1 otherwise
> @@ -377,6 +526,12 @@ defrag_xfs_defrag(char *file_path) {
>  
>  	signal(SIGINT, defrag_sigint_handler);
>  
> +	/*
> +	 * share the first extent to work around kernel consuming time
> +	 * in xfs_reflink_try_clear_inode_flag()
> +	 */
> +	defrag_share_first_extent(defrag_fd, scratch_fd);
> +
>  	do {
>  		struct timeval t_clone, t_unshare, t_punch_hole;
>  		struct defrag_segment segment;
> @@ -454,6 +609,15 @@ defrag_xfs_defrag(char *file_path) {
>  		if (time_delta > max_unshare_us)
>  			max_unshare_us = time_delta;
>  
> +		/*
> +		 * if unshare used more than 1 second, time is very possibly
> +		 * used in checking if the file is sharing extents now.
> +		 * to avoid that happen again we re-share the blocks in front
> +		 * to workaround that.
> +		 */
> +		if (time_delta > 1000000)
> +			defrag_reshare_blocks_in_front(defrag_fd, scratch_fd);
> +
>  		/*
>  		 * Punch out the original extents we shared to the
>  		 * scratch file so they are returned to free space.
> @@ -514,6 +678,8 @@ static void defrag_help(void)
>  " -f free_space      -- specify shrethod of the XFS free space in MiB, when\n"
>  "                       XFS free space is lower than that, shared segments \n"
>  "                       are excluded from defragmentation, 1024 by default\n"
> +" -n                 -- disable the \"share first extent\" featue, it's\n"
> +"                       enabled by default to speed up\n"
>  	));
>  }
>  
> @@ -525,7 +691,7 @@ defrag_f(int argc, char **argv)
>  	int	i;
>  	int	c;
>  
> -	while ((c = getopt(argc, argv, "s:f:")) != EOF) {
> +	while ((c = getopt(argc, argv, "s:f:n")) != EOF) {
>  		switch(c) {
>  		case 's':
>  			g_segment_size_lmt = atoi(optarg) * 1024 * 1024 / 512;
> @@ -539,6 +705,10 @@ defrag_f(int argc, char **argv)
>  			g_limit_free_bytes = atol(optarg) * 1024 * 1024;
>  			break;
>  
> +		case 'n':
> +			g_enable_first_ext_share = false;
> +			break;
> +
>  		default:
>  			command_usage(&defrag_cmd);
>  			return 1;
> @@ -556,7 +726,7 @@ void defrag_init(void)
>  	defrag_cmd.cfunc	= defrag_f;
>  	defrag_cmd.argmin	= 0;
>  	defrag_cmd.argmax	= 4;
> -	defrag_cmd.args		= "[-s segment_size] [-f free_space]";
> +	defrag_cmd.args		= "[-s segment_size] [-f free_space] [-n]";
>  	defrag_cmd.flags	= CMD_FLAG_ONESHOT;
>  	defrag_cmd.oneline	= _("Defragment XFS files");
>  	defrag_cmd.help		= defrag_help;
> -- 
> 2.39.3 (Apple Git-146)
> 
> 
