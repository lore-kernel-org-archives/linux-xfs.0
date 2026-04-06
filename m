Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903082DF6F4
	for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2026 15:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775489847; cv=none; b=RopqXxVxTRCrEacL48tm8PGMRjYWf8iy69h1ZTZhNrhIAVJvEMJXnB+3F+K32fsZb0nqweVb7CG+KtwCaTtzkFWzN/4a4MXjtp6pfFrJaB+0jJmGMRiLSvBI8ftn63OVlpBZqxnlFMkHSOewzCc7OeNzez88TOeI2QjToinM7Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775489847; c=relaxed/simple;
	bh=8mQqy67dtG0rvVo+IO2PumoJOhCwl2B3pRygw0Ndmfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J+VcBhOXGclA8n+SB4GpwWvrCCMmEx0i34No4Pj9/6lAXMuvbTev+ITaO/mn1a0VBUQM96u7gGBcwKoam0Zx+GpI6CMVYy2ke0ihc23sSExhIu2KJ83sQi1rigWOURBD1Kvrv2bGnRVnAViJZaXMnGqcm/wkmXvzp8t1Eu93gb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y8/NRD9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y8/NRD9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1673AC4CEF7;
	Mon,  6 Apr 2026 15:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775489847;
	bh=8mQqy67dtG0rvVo+IO2PumoJOhCwl2B3pRygw0Ndmfw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y8/NRD9DGk1d+ExOiYw4m4V0RwXfnBTtX0GgLZpO/ZdIC5GsolG/6PVpgQX39AsGs
	 NIyKX/V67crnDfsX6D8p7KsIDMM02wBn9IVIWnDWhi4xktWnLt5cfT6nqLimJE1bAw
	 v2V5OPToNbdXnT0sZ2zze8iNC0tFOCcx1mmiHl9vYq4qAK15CF2g2NKuRosmXkOvei
	 FDmWeXpKKaxxKovg2KgBXplwobcdUJuvEzPx7LthCAVSyHvExF8eD98RLQS5DhACI/
	 6cmybUczkDPKq5KgNzZWqDzhzqr3vzuqWkRvfEloLOwqDirzRSdJiykbqhzw2UOuLn
	 3LAoOYeGFjPxA==
Date: Mon, 6 Apr 2026 08:37:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/2] mkfs: unify validation behavior for data, log and rt
 dev
Message-ID: <20260406153726.GD1048989@frogsfrogsfrogs>
References: <20260404163640.1013997-1-zlang@kernel.org>
 <20260404163640.1013997-3-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260404163640.1013997-3-zlang@kernel.org>

On Sun, Apr 05, 2026 at 12:36:40AM +0800, Zorro Lang wrote:
> The current validation logic in validate_datadev, validate_logdev,
> and validate_rtdev is inconsistent and confusing when checking device
> sizes, particularly when handling file images.
> 
> This patch unifies the validation flow by categorizing devices into
> two distinct cases: "regular file" and "block device". Validation is
> now performed separately for each case across all three subvolumes to
> ensure consistent behavior.
> 
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
> 
> Hi,
> 
> validate_datadev, validate_logdev and validate_rtdev, these three functions
> handle xi->*.size, cfg->*blocks, and cli->*size inconsistently while also
> juggling xi->*.isfile status. Three functions ideally have similar validation
> patterns, but instead of following a template, each function has its own
> custom implementation, which invites bugs, maintenance overhead and inconsistent
> behavior, especially for file images.
> 
> For example, mkfs.xfs works on an empty data file with -d size=xxx:
> 
> # mkfs.xfs -f -d name=/home/emptyfile,size=300m
> meta-data=/home/emptyfile        isize=512    agcount=4, agsize=19200 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
>          =                       exchange=1   metadir=0
> data     =                       bsize=4096   blocks=76800, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
> log      =internal log           bsize=4096   blocks=16384, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
>          =                       rgcount=0    rgsize=0 extents
>          =                       zoned=0      start=0 reserved=0
> 
> But for log or rt, we got below weird errors:
> 
> # mkfs.xfs -f -l logdev=/home/emptyfile,size=128m /dev/pmem1
> size 128m specified for log subvolume is too large, maximum is 0 blocks
> ...
> # mkfs.xfs -f -r rtdev=/home/emptyfile,size=128m /dev/pmem1
> Invalid zero length rt subvolume found
> ...
> 
> One said the "size=128m" is too large, maximum is 0 (??? due to the file
> size is 0). The other one ignored the "size=128m", just complained the empty
> file.
> 
> Thanks,
> Zorro
> 
> 
>  mkfs/xfs_mkfs.c | 115 ++++++++++++++++++++++++++++++------------------
>  1 file changed, 72 insertions(+), 43 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 9a93330f..5a2274ed 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3839,34 +3839,37 @@ validate_datadev(
>  {
>  	struct libxfs_init	*xi = cli->xi;
>  
> -	if (!xi->data.size) {
> +	if (!xi->data.isfile) {
>  		/*
>  		 * if the device is a file, we can't validate the size here.
>  		 * Instead, the file will be truncated to the correct length
>  		 * later on. if it's not a file, we've got a dud device.
>  		 */
> -		if (!xi->data.isfile) {
> +		if (!xi->data.size) {
>  			fprintf(stderr, _("can't get size of data subvolume\n"));
>  			usage();
> -		} else {
> -			if (!cli->dsize) {
> +		}
> +		if (cfg->dblocks) {
> +			/* check the size fits into the underlying device */
> +			if (cfg->dblocks > DTOBT(xi->data.size, cfg->blocklog)) {
>  				fprintf(stderr,
> -_("Warning: Empty file needs a data subvolume size by -d size=<value> option\n"));
> +_("size %s specified for data subvolume is too large, maximum is %lld blocks\n"),
> +				        cli->dsize,
> +				        (long long)DTOBT(xi->data.size, cfg->blocklog));
>  				usage();
>  			}
> +		} else {
> +			/* no user size, so use the full block device */
> +			cfg->dblocks = DTOBT(xi->data.size, cfg->blocklog);
>  		}
> -	} else if (cfg->dblocks) {
> -		/* check the size fits into the underlying device */
> -		if (cfg->dblocks > DTOBT(xi->data.size, cfg->blocklog)) {
> +	} else {
> +		if (!cfg->dblocks && !xi->data.size) {
>  			fprintf(stderr,
> -_("size %s specified for data subvolume is too large, maximum is %lld blocks\n"),
> -				cli->dsize,
> -				(long long)DTOBT(xi->data.size, cfg->blocklog));
> +_("Warning: Empty data file needs a data subvolume size by -d size=<value> option\n"));
>  			usage();
> +		} else if (xi->data.size && !cfg->dblocks) {
> +			cfg->dblocks = DTOBT(xi->data.size, cfg->blocklog);
>  		}
> -	} else {
> -		/* no user size, so use the full block device */
> -		cfg->dblocks = DTOBT(xi->data.size, cfg->blocklog);

I think this rearrangement preserves all the datadev validation checks,
then makes the log/rt validation code look almost the same, except for
which variables are accessed.  That change looks ok to me, but it's
disappointing that there isn't a third patch that actually refactors all
three into a single function, seeing as the commit message talks about
unifying the implementations.

--D

>  	}
>  
>  	if (cfg->dblocks < XFS_MIN_DATA_BLOCKS(cfg)) {
> @@ -3925,19 +3928,31 @@ _("log size %lld too large for internal log\n"),
>  		usage();
>  	}
>  
> -	if (!cfg->logblocks) {
> -		if (xi->log.size == 0) {
> +	if (!xi->log.isfile) {
> +		if (!xi->log.size) {
> +			fprintf(stderr, _("can't get size of log subvolume\n"));
> +			usage();
> +		} else if (cfg->logblocks) {
> +			/* check the size fits into the underlying device */
> +			if (cfg->logblocks > DTOBT(xi->log.size, cfg->blocklog)) {
> +				fprintf(stderr,
> +_("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
> +				        cli->logsize,
> +				        (long long)DTOBT(xi->log.size, cfg->blocklog));
> +				usage();
> +			}
> +		} else {
> +			/* no user size, so use the full block device */
> +			cfg->logblocks = DTOBT(xi->log.size, cfg->blocklog);
> +		}
> +	} else {
> +		if (!cfg->logblocks && !xi->log.size) {
>  			fprintf(stderr,
> -_("unable to get size of the log subvolume.\n"));
> +_("Warning: Empty log file needs a log subvolume size by -l size=<value> option\n"));
>  			usage();
> +		} else if (xi->log.size && !cfg->logblocks) {
> +			cfg->logblocks = DTOBT(xi->log.size, cfg->blocklog);
>  		}
> -		cfg->logblocks = DTOBT(xi->log.size, cfg->blocklog);
> -	} else if (cfg->logblocks > DTOBT(xi->log.size, cfg->blocklog)) {
> -		fprintf(stderr,
> -_("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
> -			cli->logsize,
> -			(long long)DTOBT(xi->log.size, cfg->blocklog));
> -		usage();
>  	}
>  
>  	if (xi->log.bsize > cfg->lsectorsize) {
> @@ -3968,31 +3983,45 @@ _("size specified for non-existent rt subvolume\n"));
>  		cfg->rtbmblocks = 0;
>  		return;
>  	}
> -	if (!xi->rt.size) {
> -		fprintf(stderr, _("Invalid zero length rt subvolume found\n"));
> -		usage();
> -	}
>  
> -	if (cli->rtsize) {
> -		if (cfg->rtblocks > DTOBT(xi->rt.size, cfg->blocklog)) {
> -			fprintf(stderr,
> +	if (!xi->rt.isfile) {
> +		if (!xi->rt.size) {
> +			fprintf(stderr, _("can't get size of realtime subvolume\n"));
> +			usage();
> +		}
> +		if (cfg->rtblocks) {
> +			/* check the size fits into the underlying device */
> +			if (cfg->rtblocks > DTOBT(xi->rt.size, cfg->blocklog)) {
> +				fprintf(stderr,
>  _("size %s specified for rt subvolume is too large, maximum is %lld blocks\n"),
> -				cli->rtsize,
> -				(long long)DTOBT(xi->rt.size, cfg->blocklog));
> +				        cli->rtsize,
> +				        (long long)DTOBT(xi->rt.size, cfg->blocklog));
> +				usage();
> +			}
> +		} else {
> +			/* no user size, so use the full block device */
> +			if (zt->rt.nr_zones) {
> +				cfg->rtblocks = DTOBT(zt->rt.nr_zones * zt->rt.zone_capacity,
> +				                      cfg->blocklog);
> +			} else {
> +				cfg->rtblocks = DTOBT(xi->rt.size, cfg->blocklog);
> +			}
> +		}
> +	} else {
> +		if (!cfg->rtblocks && !xi->rt.size) {
> +			fprintf(stderr,
> +_("Warning: Empty rt file needs a rt subvolume size by -r size=<value> option\n"));
>  			usage();
> +		} else if (xi->rt.size && !cfg->rtblocks) {
> +			cfg->rtblocks = DTOBT(xi->rt.size, cfg->blocklog);
>  		}
> -		if (xi->rt.bsize > cfg->sectorsize) {
> -			fprintf(stderr, _(
> +	}
> +
> +	if (xi->rt.bsize > cfg->sectorsize) {
> +		fprintf(stderr, _(
>  "Warning: the realtime subvolume sector size %u is less than the sector size\n\
>  reported by the device (%u).\n"),
> -				cfg->sectorsize, xi->rt.bsize);
> -		}
> -	} else if (zt->rt.nr_zones) {
> -		cfg->rtblocks = DTOBT(zt->rt.nr_zones * zt->rt.zone_capacity,
> -				      cfg->blocklog);
> -	} else {
> -		/* grab volume size */
> -		cfg->rtblocks = DTOBT(xi->rt.size, cfg->blocklog);
> +		        cfg->sectorsize, xi->rt.bsize);
>  	}
>  
>  	cfg->rtextents = cfg->rtblocks / cfg->rtextblocks;
> -- 
> 2.52.0
> 
> 
