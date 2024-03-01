Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3785BE6C
	for <linux-xfs@vger.kernel.org>; Fri,  1 Mar 2024 17:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709315358; cv=none; b=rUreBQOePoGRkdJSuM3AWXqTD6nP2fk3AekCUkOYNbWeUiQ320g1vg4K03SYZCY61DiHyrdgO4/cs6FkFH9SZlWQci5nIR1hYwgOXc59HqmGHRZoRs9qWZ2kYVEMJKED8QmyWb7FisPM+5SLzpjYJRN4U73pX2NdeXoO64xwagM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709315358; c=relaxed/simple;
	bh=g3zDkyf652KQzCF96eDftz+CdQ9GPQQ0NdXjYjH3B2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fVgw1XapvorsCJ8aQC8dTH9KZ2HpCK9G1Ra2h7iU2yTkT80FHY5AML2LYKSmZ2KYPCWeNasy0lmGE56vgzjrlhftBzo57sr3AT8Z0LV5Xe+kTpCUxJvpMDfqKaEkSSiBoCAV7SA+wVGw1xqVQz4bXNUfg0Mj7Q1ryJBdFCdNrv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f9xArVmM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f9xArVmM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32663C433C7;
	Fri,  1 Mar 2024 17:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709315358;
	bh=g3zDkyf652KQzCF96eDftz+CdQ9GPQQ0NdXjYjH3B2s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f9xArVmMr/GPr7Syzc39m8+jEc3vzX02j2CvCPsOSwanJg077Enw8SNUkSaoJfO3q
	 jRIkRHL6hNZCT+ymI2ZDInrcUhoBZpKjUwMUMVzQO3k/pLmddYXxloTA9om/OyqCPb
	 PcLCkaDp1mFVIJuqC4jjwvXM1a/mnulYBQ/gj7NinZ3osLQTsZ21SiaRqiceTU2l/Q
	 xK2rG1EsxSWRZo14yma1+2Ci3NRk9hWx1IsAoP++zKImPwKGvNuHaNoXgRdvnreH6K
	 9HjLYei4RLWYzgwr6StbZwypCxqkONgNNfXXrsEsd32w/mJCi1CYx2pKHg9eCFhMZo
	 lw79S/7Msk92A==
Date: Fri, 1 Mar 2024 09:49:17 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsdump/xfsrestore: don't use O_DIRECT on the RT device
Message-ID: <20240301174917.GH1927156@frogsfrogsfrogs>
References: <20240301144846.1147100-1-hch@lst.de>
 <20240301144846.1147100-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240301144846.1147100-2-hch@lst.de>

On Fri, Mar 01, 2024 at 07:48:46AM -0700, Christoph Hellwig wrote:
> For undocumented reasons xfsdump and xfsrestore use O_DIRECT for RT
> files  On a rt device with 4k sector size this runs into alignment
> issues, e.g. xfs/060 fails with this message:
> 
> xfsrestore: attempt to write 237568 bytes to dumpdir/large000 at offset 54947844 failed: Invalid argument
> 
> Switch to using buffered I/O to match the main device and remove all
> the code to align to the minimum direct I/O size and make these
> alignment issues go away.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  doc/xfsdump.html  |  1 -
>  dump/content.c    | 46 +++++++++-------------------------------------
>  restore/content.c | 41 +----------------------------------------
>  3 files changed, 10 insertions(+), 78 deletions(-)
> 
> diff --git a/doc/xfsdump.html b/doc/xfsdump.html
> index efd3890..eec7dac 100644
> --- a/doc/xfsdump.html
> +++ b/doc/xfsdump.html
> @@ -884,7 +884,6 @@ Initialize the mmap files of:
>                     <ul>
>                     <li> S_IFREG -> <b>restore_reg</b> - restore regular file
>                        <ul>
> -                      <li>if realtime set O_DIRECT
>                        <li>truncate file to bs_size
>                        <li>set the bs_xflags for extended attributes
>                        <li>set DMAPI fields if necessary
> diff --git a/dump/content.c b/dump/content.c
> index 9117d39..6462267 100644
> --- a/dump/content.c
> +++ b/dump/content.c
> @@ -4319,15 +4319,8 @@ init_extent_group_context(jdm_fshandle_t *fshandlep,
>  			   struct xfs_bstat *statp,
>  			   extent_group_context_t *gcp)
>  {
> -	bool_t isrealtime;
> -	int oflags;
>  	struct flock fl;
>  
> -	isrealtime = (bool_t)(statp->bs_xflags & XFS_XFLAG_REALTIME);
> -	oflags = O_RDONLY;
> -	if (isrealtime) {
> -		oflags |= O_DIRECT;
> -	}
>  	(void)memset((void *)gcp, 0, sizeof(*gcp));
>  	gcp->eg_bmap[0].bmv_offset = 0;
>  	gcp->eg_bmap[0].bmv_length = -1;
> @@ -4336,7 +4329,7 @@ init_extent_group_context(jdm_fshandle_t *fshandlep,
>  	gcp->eg_endbmapp = &gcp->eg_bmap[1];
>  	gcp->eg_bmapix = 0;
>  	gcp->eg_gbmcnt = 0;
> -	gcp->eg_fd = jdm_open(fshandlep, statp, oflags);
> +	gcp->eg_fd = jdm_open(fshandlep, statp, O_RDONLY);
>  	if (gcp->eg_fd < 0) {
>  		return RV_ERROR;
>  	}
> @@ -4387,7 +4380,6 @@ dump_extent_group(drive_t *drivep,
>  		   off64_t *bytecntp,
>  		   bool_t *cmpltflgp)
>  {
> -	struct dioattr da;
>  	drive_ops_t *dop = drivep->d_opsp;
>  	bool_t isrealtime = (bool_t)(statp->bs_xflags
>  					&
> @@ -4397,18 +4389,6 @@ dump_extent_group(drive_t *drivep,
>  	int rval;
>  	rv_t rv;
>  
> -	/*
> -	 * Setup realtime I/O size.
> -	 */
> -	if (isrealtime) {
> -		if ((ioctl(gcp->eg_fd, XFS_IOC_DIOINFO, &da) < 0)) {
> -			mlog(MLOG_NORMAL | MLOG_WARNING, _(
> -			      "dioinfo failed ino %llu\n"),
> -			      statp->bs_ino);
> -			da.d_miniosz = PGSZ;
> -		}
> -	}
> -
>  	/* dump extents until the recommended extent length is achieved
>  	 */
>  	nextoffset = *nextoffsetp;
> @@ -4677,17 +4657,13 @@ dump_extent_group(drive_t *drivep,
>  		}
>  		assert(extsz > 0);
>  
> -		/* if the resultant extent would put us over maxcnt,
> -		 * shorten it, and round up to the next BBSIZE (round
> -		 * upto d_miniosz for realtime).
> +		/*
> +		 * If the resultant extent would put us over maxcnt,
> +		 * shorten it, and round up to the next BBSIZE.
>  		 */
>  		if (extsz > maxcnt - (bytecnt + sizeof(extenthdr_t))) {
> -			int iosz;
> +			int iosz = BBSIZE;
>  
> -			if (isrealtime)
> -				iosz = da.d_miniosz;
> -			else
> -				iosz = BBSIZE;
>  			extsz = maxcnt - (bytecnt + sizeof(extenthdr_t));
>  			extsz = (extsz + (off64_t)(iosz - 1))
>  				&
> @@ -4723,18 +4699,14 @@ dump_extent_group(drive_t *drivep,
>  			return RV_OK;
>  		}
>  
> -		/* if the resultant extent extends beyond the end of the
> +		/*
> +		 * If the resultant extent extends beyond the end of the
>  		 * file, shorten the extent to the nearest BBSIZE alignment
> -		 * at or beyond EOF.  (Shorten to d_miniosz for realtime
> -		 * files).
> +		 * at or beyond EOF.
>  		 */
>  		if (extsz > statp->bs_size - offset) {
> -			int iosz;
> +			int iosz = BBSIZE;
>  
> -			if (isrealtime)
> -				iosz = da.d_miniosz;
> -			else
> -				iosz = BBSIZE;
>  			extsz = statp->bs_size - offset;
>  			extsz = (extsz + (off64_t)(iosz - 1))
>  				&
> diff --git a/restore/content.c b/restore/content.c
> index 488ae20..7ec3a4d 100644
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -7435,7 +7435,6 @@ restore_reg(drive_t *drivep,
>  	int rval;
>  	struct fsxattr fsxattr;
>  	struct stat64 stat;
> -	int oflags;
>  
>  	if (!path)
>  		return BOOL_TRUE;
> @@ -7470,11 +7469,7 @@ restore_reg(drive_t *drivep,
>  	if (tranp->t_toconlypr)
>  		return BOOL_TRUE;
>  
> -	oflags = O_CREAT | O_RDWR;
> -	if (persp->a.dstdirisxfspr && bstatp->bs_xflags & XFS_XFLAG_REALTIME)
> -		oflags |= O_DIRECT;
> -
> -	*fdp = open(path, oflags, S_IRUSR | S_IWUSR);
> +	*fdp = open(path, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);
>  	if (*fdp < 0) {
>  		mlog(MLOG_NORMAL | MLOG_WARNING,
>  		      _("open of %s failed: %s: discarding ino %llu\n"),
> @@ -8392,8 +8387,6 @@ restore_extent(filehdr_t *fhdrp,
>  	off64_t off = ehdrp->eh_offset;
>  	off64_t sz = ehdrp->eh_sz;
>  	off64_t new_off;
> -	struct dioattr da;
> -	bool_t isrealtime = BOOL_FALSE;
>  
>  	*bytesreadp = 0;
>  
> @@ -8418,18 +8411,6 @@ restore_extent(filehdr_t *fhdrp,
>  		}
>  		assert(new_off == off);
>  	}
> -	if ((fd != -1) && (bstatp->bs_xflags & XFS_XFLAG_REALTIME)) {
> -		if ((ioctl(fd, XFS_IOC_DIOINFO, &da) < 0)) {
> -			mlog(MLOG_NORMAL | MLOG_WARNING, _(
> -			      "dioinfo %s failed: "
> -			      "%s: discarding ino %llu\n"),
> -			      path,
> -			      strerror(errno),
> -			      fhdrp->fh_stat.bs_ino);
> -			fd = -1;
> -		} else
> -			isrealtime = BOOL_TRUE;
> -	}
>  
>  	/* move from media to fs.
>  	 */
> @@ -8519,26 +8500,6 @@ restore_extent(filehdr_t *fhdrp,
>  					assert(remaining
>  						<=
>  						(size_t)INTGENMAX);
> -					/*
> -					 * Realtime files must be written
> -					 * to the end of the block even if
> -					 * it has been truncated back.
> -					 */
> -					if (isrealtime &&
> -					    (remaining % da.d_miniosz != 0 ||
> -					     remaining < da.d_miniosz)) {
> -						/*
> -						 * Since the ring and static
> -						 * buffers from the different
> -						 * drives are always large, we
> -						 * just need to write to the
> -						 * end of the next block
> -						 * boundry and truncate.
> -						 */
> -						rttrunc = remaining;
> -						remaining += da.d_miniosz -
> -						   (remaining % da.d_miniosz);
> -					}
>  					/*
>  					 * Do the write. Due to delayed allocation
>  					 * it's possible to receive false ENOSPC
> -- 
> 2.39.2
> 
> 
