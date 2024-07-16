Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098C64690
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jul 2024 00:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721088494; cv=none; b=OhRBDN/V2hRnH4kzUwbgUn8iFtCDcsd+S5lwDhlB5klxPcJPTX5VxI+jLImDraMT8bkScUfn330t8S0CIGF9sWH1hNxo4Sc/mKyHy3RBLmnnn5BothFsEna3ekR5DHBz1M9MUGGvE32vBdxbdyhmSMhPZ6OtJFh08kt7ImCr40Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721088494; c=relaxed/simple;
	bh=/5EOXr9MatFNQs1sGskFb8V1o6Hcz2x6PCKLf+GZ+zQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iLHzbHgRGQMf35qDpYp8hHS2MK2bEvrk5x6SeKNfcF5BOrnmC20OVUH69clbHJ71hSDsV/Gpch6eLGzd3XBGWz5kNqJUJOqd7dtYPYf2alXa9KqTuSGB9p8YyoS8jXblbSc0AKJ98szACoQSshvTrosNuU/mcHqQfJVDjIBSlPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=pDUFdxg0; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="pDUFdxg0"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1fb0d88fd25so34093125ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jul 2024 17:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1721088492; x=1721693292; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R9JAcxr2dkaT/NJgutgS2C4x7tN9ewo6bjSPUwCHrn8=;
        b=pDUFdxg0s6f6ueICELRM9U4ySGcT8NGLwvdzfSmUNnOROgV4mZfAKVBBE5o8RduCR5
         mWJSYKZjBcyfj1sKhGlCVxauFDMl7r+JbdOKsLx7geLK3XFoGaUFQGTXCRVOCFMM9zOQ
         Qfsft1G4qnGsndEDNkQ4Y3AjVDsDmrLRZIz3PfQ6V2+lFV6tNv1tyEHoi+cGW99tRiXC
         IOP659sIOQ3hVbK2FOKn/MiGjGVodE4a8HuHykYpEbYpc57eF11rLcU0MnDRBtLrxaVc
         kMOEZ/lukIkC62qL/ELmRW9cSGenyXYHXaYxkmyxbso0xrt/7+tld7ZVTXCH0uxHr7wj
         hXBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721088492; x=1721693292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R9JAcxr2dkaT/NJgutgS2C4x7tN9ewo6bjSPUwCHrn8=;
        b=UUme/Q7PmL603kEDhD2hs3v7J9id/Vdi5zJ8ZYvJdl1ccuK8XsO5gz5YGoL04Py1Tb
         r33u5lYBAS2lABTx+m3rdkBqTTjwh9kecbjtF0gPYB4uqi4Di/4mv0hwpKOT2isGb5xF
         w8x5Cjx7jJZ9gmOEYt3yBMBH8vjzC+n6UyXCCjQd+g8ScAxoiP/Um3giIfbIvfWOBTbb
         bpJyC3Pu/JzQLiH2aPJF0TBJvekYrtkNqC1/Ft4hzkJfbktKFpuURYee2zbe0F18HlAb
         HX7JcmEP4TFfp0w4wX9eEPv+XAHkNvKH12gv+aOJKHaxzJlRlE9lFPPTw9AhG7uw1LFf
         oa2A==
X-Gm-Message-State: AOJu0Ywe6YMABjPlt+kbpjkIhomt3sVMbicKvB6W3afPuS5o+Jm9qOeb
	CenBwEIWqLwOJs48bj/wZCoHR2OS4IyaPl6ZiXWC4+Q2jwrCKzmiTfLy85TbEglyI4bMojAsW1b
	M
X-Google-Smtp-Source: AGHT+IGZkT6SUY3VklOnTc7CSrGG+uTAXvPESHYfyuo0pNmH68hpx4Oxj+exotyDndT/yjMfpv1kgA==
X-Received: by 2002:a17:902:8c8e:b0:1fa:2b11:657d with SMTP id d9443c01a7336-1fc3e677edamr2804335ad.10.1721088492195;
        Mon, 15 Jul 2024 17:08:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fc0bc2b822sm46405865ad.160.2024.07.15.17.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 17:08:11 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sTVjl-00HHnp-1J;
	Tue, 16 Jul 2024 10:08:09 +1000
Date: Tue, 16 Jul 2024 10:08:09 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] spaceman/defrag: defrag segments
Message-ID: <ZpW56ccnA26iYI1U@dread.disaster.area>
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
> @@ -296,6 +331,8 @@ defrag_xfs_defrag(char *file_path) {
>  		goto out;
>  	}
>  
> +	clone.src_fd = defrag_fd;
> +
>  	defrag_dir = dirname(file_path);

Just a note: can you please call this the "source fd", not the
"defrag_fd"? defrag_fd could mean either the source or the
temporary scratch file we use as the defrag destination.

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

Ugh. Do this in the mapping code that gets the extent info. Have it
return bytes. Or just use FIEMAP because it uses byte ranges to
begin with.

> +
> +		clone.src_offset = seg_off;
> +		clone.src_length = seg_size;
> +		clone.dest_offset = seg_off;
> +
> +		/* checks for EoF and fix up clone */
> +		stop = defrag_clone_eof(&clone);

Ok, so we copy the segment map into clone args, and ...

> +		gettimeofday(&t_clone, NULL);
> +		ret = ioctl(scratch_fd, FICLONERANGE, &clone);
> +		if (ret != 0) {
> +			fprintf(stderr, "FICLONERANGE failed %s\n",
> +				strerror(errno));
> +			break;
> +		}

clone the source to the scratch file. This blocks writes to the
source file while it is in progress, but allows reads to pass
through the source file as data is not changing.


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

And now we unshare the source file. This blocks all IO to the source
file.

Ok, so this is the fundamental problem this whole "segmented
defrag" is trying to work around: FALLOC_FL_UNSHARE_RANGE blocks
all read and write IO whilst it is in progress.

We had this same problem with FICLONERANGE taking snapshots of VM
files - we changed the locking to take shared IO locks to allow
reads to run while the clone was in progress. Because the Oracle Vm
infrastructure uses a sidecar to redirect writes while a snapshot
(clone) was in progress, no VM IO got blocked while the clone was in
progress and so the applications inside the VM never even noticed a
clone was taking place.

Why isn't the same infrastructure being used here?

FALLOC_FL_UNSHARE_RANGE is not changing data, nor is it freeing any
data blocks. Yes, we are re-writing the data somewhere else, but
in that case the original data is still intact in it's original
location on disk and not being freed.

Hence if a read races with UNSHARE, it will hit a referenced extent
containing the correct data regardless of whether it is in the old
or new file. Hence we can likely use shared IO locking for UNSHARE,
just like we do for FICLONERANGE.

At this point, if the Oracle VM infrastructure uses the sidecar
write channel whilst the defrag is in progress, this whole algorithm
simply becomes "for regions with extents smaller than X, clone and
unshare the region".

The whole need for "idle time" goes away. The need for segment size
control largely goes away. The need to tune the defrag algorithm to
avoid IO latency and/or throughput issues goes away.

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
> +		if (ret != 0) {
> +			fprintf(stderr, "PUNCH_HOLE failed %s\n",
> +				strerror(errno));
> +			break;
> +		}

This is unnecessary if there is lots of free space. You can leave
this to the very end of defrag so that the source file defrag
operation isn't slowed down by cleaning up all the fragmented
extents....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
