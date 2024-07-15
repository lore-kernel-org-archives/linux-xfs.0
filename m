Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D6B13D502
	for <linux-xfs@vger.kernel.org>; Mon, 15 Jul 2024 23:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721086857; cv=none; b=HmpXRCRoHEOl7J/BxpN543AM7rYPv2XXP+emZ6Yq929oKm6UQRz8hyGQJvSxffrrA21+acllGJd5hQqkbM0F3uTHLqGX1Eif9xxHfC6jm046ZcItz/tW1cVWftKs/WB+sJj+1sgkxgLyXC00bI1+08ZNumSwObESklbe5MeFwag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721086857; c=relaxed/simple;
	bh=3XL3Is1VILEsFVJQ9u8vhFwmWmReMeG1CX2zyH2LcQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jYK6UnA+7IzYQ9pPWKRyf9zK02PLvUX1Bl0llxEtcOKJ5Tip1P5WmQWySt9O5jRMI048ljfDYLkvq/1TeMUaX1NmVathvTUIzYo7TF3e5rfuaBooAOhfxD3OmGpt5fbw/MJnQokF1FVOQdgP9Go3fMJvtaI1Ww05STJscJwRAak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=wNQKpmKx; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="wNQKpmKx"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-704156d0e0dso2603879a34.1
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jul 2024 16:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1721086855; x=1721691655; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UgePRVRV5ECyu5VSKXfaN1qQQoXx4RnG5pUoy5l8eq4=;
        b=wNQKpmKx81sk19DvE54uS8hvMnD1Cq2aIXlUt6aANEdAaJWlcm58KOeOdtczKY5//C
         oInOfYhajBNNyyPoWXEOHDiHPlZeBn/1FHayeWURdw+GM/2SRR2h3494NyLY4hkC2ZkO
         8fnDU3Awr/mo4BgSDBkdQgOnlhAkETd5oRC0ICE2gasOE9t2yrPkhds08Eh3KXCIpbCA
         c4IxYJ3BedKwhxMp1QaQM52bZPWgkqTbhbs4CGO/jIgGgEWEOrrlSRE4Uzn5H8+lP1aG
         As8r+df/kKjn5Qd6evx+biIlIn+jKiGu4T0GG/uZ/TaZv6popFBrjeehk2ZiK4LiEuVt
         NkUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721086855; x=1721691655;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UgePRVRV5ECyu5VSKXfaN1qQQoXx4RnG5pUoy5l8eq4=;
        b=XWvxELuS3Qe/PYoAdTAirVcsi692v6ZHQ1WvR2Ti4O1f23dwe5dE1l60Wcj8QHDL2G
         CzM22x+0KBuRPfay7qAtzW74ekEQHI3M+dgVCRsKX8Ea8G0wvNhXP5hjn9SHst/kqHlg
         AE/yADCy03hNi8idpy7jr1OPE0ZDl7i3UWzccfoT/Oe0gkD5GSO5Ko0E3A32QY2eZiQF
         XwaEgfrNXsfFyE/tzWYx2arx+okWYCL1iAhphfIlU75q9+7D+MRRYNmt1DxAg94wp8oj
         761XgQ5x/zLyDyt3eILP1UDCmiBBb07f8gqfFYukpNhAnujPx00t2wLdzlMTHeo2GCAy
         8O5w==
X-Gm-Message-State: AOJu0YwojHG/RYFKpXSp93PERZEbEzakYGQOFviFrF2ZPoEOHzMROpB8
	IO05Qu3NqttDQfTfbffareFf0yrxhhQM5p/28Cu8bhllVQsohoAsL50BKYqLDUHfafy2ecdxXoL
	D
X-Google-Smtp-Source: AGHT+IGiJJGH+2F8jF4oMgEUcIdsRf2o86B90unQst73ONUwUGUxvxOIzSZXiAvNKRkUdOIjNjX/1Q==
X-Received: by 2002:a05:6830:3704:b0:702:2550:4e31 with SMTP id 46e09a7af769-708d9be783amr651733a34.29.1721086854647;
        Mon, 15 Jul 2024 16:40:54 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b7eb9c969sm4956430b3a.35.2024.07.15.16.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 16:40:53 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sTVJL-00HGOr-0h;
	Tue, 16 Jul 2024 09:40:51 +1000
Date: Tue, 16 Jul 2024 09:40:51 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] spaceman/defrag: pick up segments from target file
Message-ID: <ZpWzg9Jnko76tAx5@dread.disaster.area>
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
> 2. contains some extents
> 3. the contained extents can't be "unwritten"
> 4. the contained extents must be contigous in file blocks
> 
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
> +/* current offset of the file in units of 512 bytes, used to fetch bmap */
> +static long long 	g_offset = 0;
> +/* index to indentify next extent, used to get next extent */
> +static int		g_ext_next_idx = -1;

Please do not prefix global variables with "g_". This is not
useful, and simply makes the code hard to read.

That said, it is much better to pass these as function parameters so
they are specific to the mapping context and so are inherently
thread safe.

> +/*
> + * segment, the smallest unit to defrag
> + * it includes some contiguous extents.
> + * no holes included,
> + * no unwritten extents included
> + * the size is limited by g_segment_size_lmt
> + */

I have no idea what this comment is trying to tell me.

> +struct defrag_segment {
> +	/* segment offset in units of 512 bytes */
> +	long long	ds_offset;
> +	/* length of segment in units of 512 bytes */
> +	long long	ds_length;
> +	/* number of extents in this segment */
> +	int		ds_nr;
> +	/* flag indicating if segment contains shared blocks */
> +	bool		ds_shared;
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
> +
> +	map_out->bmv_offset = g_mapx[g_ext_next_idx].bmv_offset;
> +	map_out->bmv_length = g_mapx[g_ext_next_idx].bmv_length;
> +	map_out->bmv_oflags = g_mapx[g_ext_next_idx].bmv_oflags;
> +out:
> +	return err;
> +}

Ok, so the global variables are just a bmap cache. That's a problem,
because this cache is stale the moment XFS_IOC_GETBMAPX returns to
userspace. Iterating it to decide exactly waht to do next will
race with ongoing file modifications and so it's not going to be
accurate....

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

out->ds_nr is never set to anything but zero in this patch.

> +
> +	do {
> +		ret = defrag_get_next_extent(fd, &mapx);
> +		if (ret != 0) {
> +			/*
> +			 * no more extetns, return current segment if its not

Typos everywhere.

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

So this is essentially a filter for the getbmapx output that strips
away unwritten extents and anything outside/larger than the target
range.

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

Why do you need a goto for this logic?

		/*
		 * the segment is not empty, check for hole since the last exent
		 * if a hole exist before this extent, this extent can't be
		 * added to the segment. return the segment
		 */
		if (out->ds_nr) {
			if (out->ds_offset + out->ds_length != mapx.bmv_offset)
				break;
		} else {
			out->ds_offset = mapx.bmv_offset;
		}

> +		if (defrag_is_extent_shared(&mapx))
> +			out->ds_shared = true;
> +
> +		out->ds_length += mapx.bmv_length;
> +		out->ds_nr += 1;
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
> +		/* error happened when reading bmap, stop here */
> +		if (ret == -1) {
> +			ret = 1;
> +			break;
> +		}

ternary return values are nasty. Return a negative errno when a
an error occurs, and -ENODATA when there are no more segments.
Then you have

		if (ret < 0) {
			if (ret == -ENODATA)
				exit_value = 0;
			else
				exit_value = 1;
			break;
		}

> +	} while (true);

Not a fan of do {} while(true) loops.

WIth the above error handling changes, this becomes:

	do {
		struct defrag_segment segment;

		ret = defrag_get_next_segment(defrag_fd, &segment);
	} while (ret == 0);

	if (ret == 0 || ret == -ENODATA)
		exit_value = 0;
	else
		exit_value = 1;


Ok, so this is a linear iteration of all extents in the file that
filters extents for the specific "segment" that is going to be
processed. I still have no idea why fixed length segments are
important, but "linear extent scan for filtering" seems somewhat
expensive.

Indeed, if you used FIEMAP, you can pass a minimum
segment length to filter out all the small extents. Iterating that
extent list means all the ranges you need to defrag are in the holes
of the returned mapping information. This would be much faster
than an entire linear mapping to find all the regions with small
extents that need defrag. The second step could then be doing a
fine grained mapping of each region that we now know either contains
fragmented data or holes....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
