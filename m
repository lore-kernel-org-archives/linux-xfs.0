Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F286F187849
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 21:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720562245; cv=none; b=bBRCUJ0DHF0rJ74aB1JIGcnNocK6CUu+yNl03VND4a7Fm8AjGm3iv5UcDa9o7wAVXzACu7NU5DXie+RWfIzoj7hNipP2QIPSLhCmhK2UshcQePufH96Yjib0jE+Fr+02sGOjLLv8vx06bWcmKiAlT2I6dJnpRj60YE37DxwB0RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720562245; c=relaxed/simple;
	bh=yQWJZEAbeCVrgqDp9yyRDqToVqzM9iNQ73w9LiMVMYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DjHuviZIwZCNS/xepSKoA+wVFL2h+P4A8mxX9Cv62cowJ5AD4K74DyL+bwuLlGY4CGT55sZa7/bTKhYwet0byqNffGQZQLDo0dkQFv2WxsMMC8pS6fF8ixzO0WnHpMiLvsMXCHkDgw+/X9z/9v5/5mAyHFLv3Y+zag4Tx6UcQV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H4ioXi3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H4ioXi3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75205C4AF0F;
	Tue,  9 Jul 2024 21:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720562243;
	bh=yQWJZEAbeCVrgqDp9yyRDqToVqzM9iNQ73w9LiMVMYY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H4ioXi3+AWB7PdMJEC5akvoxeYRUqN4e3hChf5cSsWg7f+bIz1qf72V71+Hr5xaJI
	 L6nIv3TKtxt/h/+/D5g8kQgRmGH35YZ4BgD8ppW7xzcdxuZ//KnuHX266HELMYwwut
	 Geace1XGtsEp8SkEIigSE8tDsT1kyHsPN9m3XNy82ryYiFDDMC0dRyxai1kfSbgndX
	 P0EcckLWbAT3Xz2EsAD+e88YuxICvdwzdkUjB/3GF+8E/TKeaa0/N/8JKSYOLVmXbA
	 v1M5iQM0CVEVe2OAEZnmozgXDwuaWVY97MzPmbBgVXsupTJFU+JHI9a2SUqR/LvwUw
	 eLjNNB5Qnl2iQ==
Date: Tue, 9 Jul 2024 14:57:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] spaceman/defrag: defrag segments
Message-ID: <20240709215721.GA612460@frogsfrogsfrogs>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-4-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709191028.2329-4-wen.gang.wang@oracle.com>

On Tue, Jul 09, 2024 at 12:10:22PM -0700, Wengang Wang wrote:
> For each segment, the following steps are done trying to defrag it:
> 
> 1. share the segment with a temporary file
> 2. unshare the segment in the target file. kernel simulates Cow on the whole
>    segment complete the unshare (defrag).
> 3. release blocks from the tempoary file.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  spaceman/defrag.c | 114 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 114 insertions(+)
> 
> diff --git a/spaceman/defrag.c b/spaceman/defrag.c
> index 175cf461..9f11e36b 100644
> --- a/spaceman/defrag.c
> +++ b/spaceman/defrag.c
> @@ -263,6 +263,40 @@ add_ext:
>  	return ret;
>  }
>  
> +/*
> + * check if the segment exceeds EoF.
> + * fix up the clone range and return true if EoF happens,
> + * return false otherwise.
> + */
> +static bool
> +defrag_clone_eof(struct file_clone_range *clone)
> +{
> +	off_t delta;
> +
> +	delta = clone->src_offset + clone->src_length - g_defrag_file_size;
> +	if (delta > 0) {
> +		clone->src_length = 0; // to the end
> +		return true;
> +	}
> +	return false;
> +}
> +
> +/*
> + * get the time delta since pre_time in ms.
> + * pre_time should contains values fetched by gettimeofday()
> + * cur_time is used to store current time by gettimeofday()
> + */
> +static long long
> +get_time_delta_us(struct timeval *pre_time, struct timeval *cur_time)
> +{
> +	long long us;
> +
> +	gettimeofday(cur_time, NULL);
> +	us = (cur_time->tv_sec - pre_time->tv_sec) * 1000000;
> +	us += (cur_time->tv_usec - pre_time->tv_usec);
> +	return us;
> +}
> +
>  /*
>   * defragment a file
>   * return 0 if successfully done, 1 otherwise
> @@ -273,6 +307,7 @@ defrag_xfs_defrag(char *file_path) {
>  	long	nr_seg_defrag = 0, nr_ext_defrag = 0;
>  	int	scratch_fd = -1, defrag_fd = -1;
>  	char	tmp_file_path[PATH_MAX+1];
> +	struct file_clone_range clone;
>  	char	*defrag_dir;
>  	struct fsxattr	fsx;
>  	int	ret = 0;

Now that I see this, you might want to straighten up the lines:

	struct fsxattr	fsx = { };
	long		nr_seg_defrag = 0, nr_ext_defrag = 0;

etc.  Note the "= { }" bit that means you don't have to memset them to
zero explicitly.

> @@ -296,6 +331,8 @@ defrag_xfs_defrag(char *file_path) {
>  		goto out;
>  	}
>  
> +	clone.src_fd = defrag_fd;
> +
>  	defrag_dir = dirname(file_path);
>  	snprintf(tmp_file_path, PATH_MAX, "%s/.xfsdefrag_%d", defrag_dir,
>  		getpid());
> @@ -309,7 +346,11 @@ defrag_xfs_defrag(char *file_path) {
>  	}
>  
>  	do {
> +		struct timeval t_clone, t_unshare, t_punch_hole;
>  		struct defrag_segment segment;
> +		long long seg_size, seg_off;
> +		int time_delta;
> +		bool stop;
>  
>  		ret = defrag_get_next_segment(defrag_fd, &segment);
>  		/* no more segments, we are done */
> @@ -322,6 +363,79 @@ defrag_xfs_defrag(char *file_path) {
>  			ret = 1;
>  			break;
>  		}
> +
> +		/* we are done if the segment contains only 1 extent */
> +		if (segment.ds_nr < 2)
> +			continue;
> +
> +		/* to bytes */
> +		seg_off = segment.ds_offset * 512;
> +		seg_size = segment.ds_length * 512;
> +
> +		clone.src_offset = seg_off;
> +		clone.src_length = seg_size;
> +		clone.dest_offset = seg_off;
> +
> +		/* checks for EoF and fix up clone */
> +		stop = defrag_clone_eof(&clone);
> +		gettimeofday(&t_clone, NULL);
> +		ret = ioctl(scratch_fd, FICLONERANGE, &clone);

Hm, should the top-level defrag_f function check in the
filetable[i].fsgeom structure that the fs supports reflink?

> +		if (ret != 0) {
> +			fprintf(stderr, "FICLONERANGE failed %s\n",
> +				strerror(errno));

Might be useful to include the file_path in the error message:

/opt/a: FICLONERANGE failed Software caused connection abort

(maybe also put a semicolon before the strerror message?)

> +			break;
> +		}
> +
> +		/* for time stats */
> +		time_delta = get_time_delta_us(&t_clone, &t_unshare);
> +		if (time_delta > max_clone_us)
> +			max_clone_us = time_delta;
> +
> +		/* for defrag stats */
> +		nr_ext_defrag += segment.ds_nr;
> +
> +		/*
> +		 * For the shared range to be unshared via a copy-on-write
> +		 * operation in the file to be defragged. This causes the
> +		 * file needing to be defragged to have new extents allocated
> +		 * and the data to be copied over and written out.
> +		 */
> +		ret = fallocate(defrag_fd, FALLOC_FL_UNSHARE_RANGE, seg_off,
> +				seg_size);
> +		if (ret != 0) {
> +			fprintf(stderr, "UNSHARE_RANGE failed %s\n",
> +				strerror(errno));
> +			break;
> +		}
> +
> +		/* for time stats */
> +		time_delta = get_time_delta_us(&t_unshare, &t_punch_hole);
> +		if (time_delta > max_unshare_us)
> +			max_unshare_us = time_delta;
> +
> +		/*
> +		 * Punch out the original extents we shared to the
> +		 * scratch file so they are returned to free space.
> +		 */
> +		ret = fallocate(scratch_fd,
> +			FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE, seg_off,
> +			seg_size);

Indentation here (two tabs for a continuation).  Or just ftruncate
scratch_fd to zero bytes?  I think you have to do that for the EOF stuff
to work, right?

--D

> +		if (ret != 0) {
> +			fprintf(stderr, "PUNCH_HOLE failed %s\n",
> +				strerror(errno));
> +			break;
> +		}
> +
> +		/* for defrag stats */
> +		nr_seg_defrag += 1;
> +
> +		/* for time stats */
> +		time_delta = get_time_delta_us(&t_punch_hole, &t_clone);
> +		if (time_delta > max_punch_us)
> +			max_punch_us = time_delta;
> +
> +		if (stop)
> +			break;
>  	} while (true);
>  out:
>  	if (scratch_fd != -1) {
> -- 
> 2.39.3 (Apple Git-146)
> 
> 
