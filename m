Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEFA18562D
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 21:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561823; cv=none; b=IKF1lvBn4S5WVw6TjN2X0JizB2zdh1d1cCAVEWrH/+nf58zUlc4AtZmmKuP1FRdElxWedhQdeBUzu84++oQmU85u08EbkdVEkISEyUr1kVXWjJEBomIf4HWeSvBm2fXsI7APwo6himgHothj6uObKM4DPCjOPdl0eFYROrcIH3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561823; c=relaxed/simple;
	bh=fo7YLv+blm2HrQc5uhJSSReCx/NkxcwaP79TfadgjwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RLNsWeJSDkWkkFSsA6W7NKSRXzkdnStLnvsOjufjTvOcfyaGk84TpsesdSeBffueWJJB/BL+hsEhzVlNBDJqpuA2bcNIOWSho41LFNVYI2hJ/YAZdbo6J1GrMqntivHl/CvyM+uOTIxjATiaF763xdnLIAejUwmtyQhNrXlx+aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=If7NBT+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="If7NBT+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69A1C3277B;
	Tue,  9 Jul 2024 21:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720561822;
	bh=fo7YLv+blm2HrQc5uhJSSReCx/NkxcwaP79TfadgjwA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=If7NBT+kGxj9P0LmziSMU9KUOmIhsjUZPFkKs0IFwpwdTAeUWBv27rcy+BowIeEV2
	 BtLyz1MVoAfBsGgKXc+tRXwC0VtbkAaDJ+tY1gA26O09M4xiitVoXs+ucrpppCClS4
	 nvJdnHzNiIoD0NLSDXVLm40faIV7XFnTn5HoVQ9NClzC2/k4sjTS0CfX8rOyAtoesN
	 ezCVgL8pHUor+Uq6Yifpk95EkhEYHqIP0Wjjkn/vr7eg0uEHHAghFj33Rc3f6+er9C
	 xy0bhn9rVJgGSqAuzaLn14yRVZHpgjLOhaVek5AnHQmfDIKduUvBqYha1g7Xnyo381
	 viEkFwzro2K6Q==
Date: Tue, 9 Jul 2024 14:50:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] spaceman/defrag: pick up segments from target fileOM
Message-ID: <20240709215022.GZ612460@frogsfrogsfrogs>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-3-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709191028.2329-3-wen.gang.wang@oracle.com>

On Tue, Jul 09, 2024 at 12:10:21PM -0700, Wengang Wang wrote:
> segments are the smallest unit to defragment.
> 
> A segment
> 1. Can't exceed size limit

What size limit?  Do you mean a segment can't extend beyond EOF?  Or did
you actually mean RLIMIT_FSIZE?

> 2. contains some extents
> 3. the contained extents can't be "unwritten"
> 4. the contained extents must be contigous in file blocks

As in the segment cannot contain sparse holes?

I think what I"m reading here is that a segment cannot extend beyond EOF
and must be completely filled with written extent mappings?

Is there an upper limit on the number of mappings per segment?

> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  spaceman/defrag.c | 204 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 204 insertions(+)
> 
> diff --git a/spaceman/defrag.c b/spaceman/defrag.c
> index c9732984..175cf461 100644
> --- a/spaceman/defrag.c
> +++ b/spaceman/defrag.c
> @@ -14,6 +14,32 @@
>  #include "space.h"
>  #include "input.h"
>  
> +#define MAPSIZE 512
> +/* used to fetch bmap */
> +struct getbmapx	g_mapx[MAPSIZE];

Each of these global arrays increases the bss segment size, which
increases the overall footprint of xfs_spaceman, even when it's not
being used to defragment files.

Could you switch this data to be dynamically allocated at the start of
defrag_f and freed at the end?

> +/* current offset of the file in units of 512 bytes, used to fetch bmap */
> +static long long 	g_offset = 0;

Unnecessary space after the 'long long'.

> +/* index to indentify next extent, used to get next extent */
> +static int		g_ext_next_idx = -1;
> +
> +/*
> + * segment, the smallest unit to defrag
> + * it includes some contiguous extents.
> + * no holes included,
> + * no unwritten extents included
> + * the size is limited by g_segment_size_lmt
> + */
> +struct defrag_segment {
> +	/* segment offset in units of 512 bytes */
> +	long long	ds_offset;
> +	/* length of segment in units of 512 bytes */
> +	long long	ds_length;
> +	/* number of extents in this segment */
> +	int		ds_nr;
> +	/* flag indicating if segment contains shared blocks */
> +	bool		ds_shared;

Maybe g_mapx belongs in here?  Wait, does a bunch of contiguous written
bmapx records comprise a segment, or is a segment created from (possibly
a subection of) a particular written bmapx record?

> +};
> +
>  /* defrag segment size limit in units of 512 bytes */
>  #define MIN_SEGMENT_SIZE_LIMIT 8192 /* 4MiB */
>  #define DEFAULT_SEGMENT_SIZE_LIMIT 32768 /* 16MiB */
> @@ -78,6 +104,165 @@ defrag_check_file(char *path)
>  	return true;
>  }
>  
> +/*
> + * get next extent in the file.
> + * Note: next call will get the same extent unless move_next_extent() is called.
> + * returns:
> + * -1:	error happened.
> + * 0:	extent returned
> + * 1:	no more extent left
> + */
> +static int
> +defrag_get_next_extent(int fd, struct getbmapx *map_out)
> +{
> +	int err = 0, i;
> +
> +	/* when no extents are cached in g_mapx, fetch from kernel */
> +	if (g_ext_next_idx == -1) {
> +		g_mapx[0].bmv_offset = g_offset;
> +		g_mapx[0].bmv_length = -1LL;
> +		g_mapx[0].bmv_count = MAPSIZE;
> +		g_mapx[0].bmv_iflags = BMV_IF_NO_HOLES | BMV_IF_PREALLOC;
> +		err = ioctl(fd, XFS_IOC_GETBMAPX, g_mapx);
> +		if (err == -1) {
> +			perror("XFS_IOC_GETBMAPX failed");
> +			goto out;
> +		}
> +		/* for stats */
> +		g_ext_stats.nr_ext_total += g_mapx[0].bmv_entries;
> +
> +		/* no more extents */
> +		if (g_mapx[0].bmv_entries == 0) {
> +			err = 1;
> +			goto out;
> +		}
> +
> +		/* for stats */
> +		for (i = 1; i <= g_mapx[0].bmv_entries; i++) {
> +			if (g_mapx[i].bmv_oflags & BMV_OF_PREALLOC)
> +				g_ext_stats.nr_ext_unwritten++;
> +			if (g_mapx[i].bmv_oflags & BMV_OF_SHARED)
> +				g_ext_stats.nr_ext_shared++;
> +		}
> +
> +		g_ext_next_idx = 1;
> +		g_offset = g_mapx[g_mapx[0].bmv_entries].bmv_offset +
> +				g_mapx[g_mapx[0].bmv_entries].bmv_length;
> +	}

Huh.  AFAICT, g_ext_next_idx/g_mapx effectively act as a cursor over the
mappings for this file segment.  In that case, shouldn't
defrag_move_next_extent (which actually advances the cursor) be in
charge of grabbing bmapx records from the kernel, and
defrag_get_next_extent be the trivial helper to pass mappings to the
consumer of the bmapx objects (aka defrag_get_next_segment)?

> +
> +	map_out->bmv_offset = g_mapx[g_ext_next_idx].bmv_offset;
> +	map_out->bmv_length = g_mapx[g_ext_next_idx].bmv_length;
> +	map_out->bmv_oflags = g_mapx[g_ext_next_idx].bmv_oflags;
> +out:
> +	return err;
> +}
> +
> +/*
> + * move to next extent
> + */
> +static void
> +defrag_move_next_extent()
> +{
> +	if (g_ext_next_idx == g_mapx[0].bmv_entries)
> +		g_ext_next_idx = -1;
> +	else
> +		g_ext_next_idx += 1;
> +}
> +
> +/*
> + * check if the given extent is a defrag target.
> + * no need to check for holes as we are using BMV_IF_NO_HOLES
> + */
> +static bool
> +defrag_is_target(struct getbmapx *mapx)
> +{
> +	/* unwritten */
> +	if (mapx->bmv_oflags & BMV_OF_PREALLOC)
> +		return false;
> +	return mapx->bmv_length < g_segment_size_lmt;
> +}
> +
> +static bool
> +defrag_is_extent_shared(struct getbmapx *mapx)
> +{
> +	return !!(mapx->bmv_oflags & BMV_OF_SHARED);
> +}
> +
> +/*
> + * get next segment to defragment.
> + * returns:
> + * -1	error happened.
> + * 0	segment returned.
> + * 1	no more segments to return
> + */
> +static int
> +defrag_get_next_segment(int fd, struct defrag_segment *out)
> +{
> +	struct getbmapx mapx;
> +	int	ret;
> +
> +	out->ds_offset = 0;
> +	out->ds_length = 0;
> +	out->ds_nr = 0;
> +	out->ds_shared = false;
> +
> +	do {
> +		ret = defrag_get_next_extent(fd, &mapx);
> +		if (ret != 0) {
> +			/*
> +			 * no more extetns, return current segment if its not
> +			 * empty
> +			*/
> +			if (ret == 1 && out->ds_nr > 0)
> +				ret = 0;
> +			/* otherwise, error heppened, stop */
> +			break;
> +		}
> +
> +		/*
> +		 * If the extent is not a defrag target, skip it.
> +		 * go to next extent if the segment is empty;
> +		 * otherwise return the segment.
> +		 */
> +		if (!defrag_is_target(&mapx)) {
> +			defrag_move_next_extent();
> +			if (out->ds_nr == 0)
> +				continue;
> +			else
> +				break;
> +		}
> +
> +		/* check for segment size limitation */
> +		if (out->ds_length + mapx.bmv_length > g_segment_size_lmt)
> +			break;
> +
> +		/* the segment is empty now, add this extent to it for sure */
> +		if (out->ds_nr == 0) {
> +			out->ds_offset = mapx.bmv_offset;
> +			goto add_ext;
> +		}
> +
> +		/*
> +		 * the segment is not empty, check for hole since the last exent
> +		 * if a hole exist before this extent, this extent can't be
> +		 * added to the segment. return the segment
> +		 */
> +		if (out->ds_offset + out->ds_length != mapx.bmv_offset)
> +			break;
> +
> +add_ext:
> +		if (defrag_is_extent_shared(&mapx))
> +			out->ds_shared = true;
> +
> +		out->ds_length += mapx.bmv_length;
> +		out->ds_nr += 1;

OH, ok.  So we walk the mappings for a file.  If we can identify a run
of contiguous written mappings, we define a segment to be the file range
described by that run, up to whatever the maximum is (~4-16M).  Each of
these segments is defragmented (somehow).  Is that correct?

> +		defrag_move_next_extent();
> +
> +	} while (true);
> +
> +	return ret;
> +}
> +
>  /*
>   * defragment a file
>   * return 0 if successfully done, 1 otherwise
> @@ -92,6 +277,9 @@ defrag_xfs_defrag(char *file_path) {
>  	struct fsxattr	fsx;
>  	int	ret = 0;
>  
> +	g_offset = 0;
> +	g_ext_next_idx = -1;
> +
>  	fsx.fsx_nextents = 0;
>  	memset(&g_ext_stats, 0, sizeof(g_ext_stats));
>  
> @@ -119,6 +307,22 @@ defrag_xfs_defrag(char *file_path) {
>  		ret = 1;
>  		goto out;
>  	}
> +
> +	do {
> +		struct defrag_segment segment;
> +
> +		ret = defrag_get_next_segment(defrag_fd, &segment);
> +		/* no more segments, we are done */
> +		if (ret == 1) {
> +			ret = 0;
> +			break;
> +		}

If you reverse the polarity of the 0/1 return values (aka return 1 if
there is a segment and 0 if there is none) then you can shorten this
loop to:

	struct defrag_segment	segment;
	int			ret;

	while ((ret = defrag_get_next_segment(...)) == 1) {
		/* process segment */
	}

	return ret;

--D

> +		/* error happened when reading bmap, stop here */
> +		if (ret == -1) {
> +			ret = 1;
> +			break;
> +		}
> +	} while (true);
>  out:
>  	if (scratch_fd != -1) {
>  		close(scratch_fd);
> -- 
> 2.39.3 (Apple Git-146)
> 
> 
