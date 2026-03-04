Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C557386448
	for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2026 19:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772653770; cv=none; b=ZGK3B6QY+dMDVslogQkp2N22Sp3XAUFH9V2wUFNHRkuAEQKzHty78IQUEAtKT6l5E/4PCxBlpbyuQbHCaLjLWd+uJNCxCyLqSQGdWxkfiSgocaIDg0sqEIw5KVP+LI8MtnVG1moDvG7N4dW08l91Aid9nqGySIa34XbJkqKEdFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772653770; c=relaxed/simple;
	bh=yJmiD6UcunX4hqnuNn7+DX5e+5aErqs7yq3gnOTbWL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LGVvkv4EnK3O7Kp1nWSBxCS6AhfWQwsZxvbPojp8YKYmxrd6wgpAlX6ad9DKfSwkxuDsZfvo0EubU4lkwe0XsbqDnxYFV7nLULkk68ylNf4V4LZbv0OgTKHbLrqovsMqxwmokpiehKi9gO3OW9idQfKH/dd1l43kFeofT4ZkykE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nlV3iqE+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nlV3iqE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC04C4CEF7;
	Wed,  4 Mar 2026 19:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772653770;
	bh=yJmiD6UcunX4hqnuNn7+DX5e+5aErqs7yq3gnOTbWL8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nlV3iqE+nsVAP0ZLHBoQGCPOxLVgtO2Cgelb/kqS7GrVYHaMJ9CJNWA27iki/LvV1
	 59Kce2vs3voqnUViWNqS3Ne8qM6YMpt+1gY6l3sZtljSP5/PggN5/omF/gCCaE0Bp+
	 iJdsbS3ndJEhaAHSQYI5zOIE5q2lhkG1lIKWwhzwucc0hKvezcxH+Zvw4noWAoZdpc
	 +niCx6jieIWvSpJECTK1BrZrt4ZTaf/JkmSvEqw5ESM3J0DruLsDdR6djoOh+WeoOt
	 a//Xk8cagQA+x8ROP7y59t5/OoDbP7mY5MGcwmUVrNdieDu020qVcqMnriGjA44nwE
	 0aNXSinHlv3TQ==
Date: Wed, 4 Mar 2026 11:49:29 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>,
	Andrey Albershteyn <aalbersh@redhat.com>
Cc: hch@infradead.org, aalbersh@redhat.com, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] mkfs.xfs fix sunit size on 512e and 4kN disks.
Message-ID: <20260304194929.GY57948@frogsfrogsfrogs>
References: <20260219114405.31521-3-lukas@herbolt.com>
 <20260219114405.31521-6-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219114405.31521-6-lukas@herbolt.com>

On Thu, Feb 19, 2026 at 12:44:09PM +0100, Lukas Herbolt wrote:
> Creating of XFS on 4kN or 512e disk result in suboptimal LSU/LSUNIT.
> As of now we check if the sectorsize is bigger than XLOG_HEADER_SIZE
> and so we set lsu to blocksize. But we do not check the the size if
> lsunit can be bigger to fit the disk geometry.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  mkfs/xfs_mkfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index b34407725f76..1b6334e9adce 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3647,7 +3647,7 @@ check_lsunit:
>  	else if (cfg->lsectorsize > XLOG_HEADER_SIZE)
>  		lsu = cfg->blocksize; /* lsunit matches filesystem block size */
>  
> -	if (lsu) {
> +	if (cli->lsu) {

This patch causes ~96% failure rates on fstests on my test fleet, some
of which now have 4k LBA disks with unexciting min/opt io geometry:

# lsblk -t /dev/sda
NAME   ALIGNMENT MIN-IO  OPT-IO PHY-SEC LOG-SEC ROTA SCHED RQ-SIZE   RA WSAME
sda            0   4096 1048576    4096     512    1 bfq       256 2048    0B
# mkfs.xfs -f -N /dev/sda3
meta-data=/dev/sda3              isize=512    agcount=4, agsize=2183680 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=1   metadir=0
data     =                       bsize=4096   blocks=8734720, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=4096  sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 extents
         =                       zoned=0      start=0 reserved=0

Note that MIN-IO == PHY-SEC, so dsunit/dswidth are zero.  With this
change, we no longer set the lsunit to the fsblock size if the log
sector size is greater than 512.  Unfortunately, dsunit is also not set,
so mkfs never sets the log sunit and it remains zero.  I think
this causes problems with the log roundoff computation in the kernel:

	if (xfs_has_logv2(mp) && mp->m_sb.sb_logsunit > 1)
		log->l_iclog_roundoff = mp->m_sb.sb_logsunit;
	else
		log->l_iclog_roundoff = BBSIZE;

because now the roundoff factor is less than the log sector size.  After
a while, the filesystem cannot be mounted anymore because:

XFS (sda3): Mounting V5 Filesystem 81b8ffa8-383b-4574-a68c-9b8202707a26
XFS (sda3): Corruption warning: Metadata has LSN (4:2729) ahead of current LSN (4:2727). Please unmount and run xfs_repair (>= v4.3) to resolve.
XFS (sda3): log mount/recovery failed: error -22
XFS (sda3): log mount failed

Reverting this patch makes the problem go away, but I think you're
trying to make it so that mkfs will set lsunit = dsunit if dsunit>0 and
the caller didn't specify any -lsunit= parameter, right?

But there's something that just seems off with this whole function.  If
the user provided a -lsunit/-lsu option then we need to validate the
value and either use it if it makes sense, or complain if not.  If the
user didn't specify any option, then we should figure it out
automatically from the other data device geometry options (internal) or
the external log device probing.

But that's not what this function does.  Why would you do this:

	else if (cfg->lsectorsize > XLOG_HEADER_SIZE)
		lsu = cfg->blocksize; /* lsunit matches filesystem block size */

and then loudly validate that lsu (bytes) is congruent with the fsblock
size?  This is trivially true, but then it disables the "make lsunit use
dsunit if set" logic below:

	} else if (cfg->sb_feat.log_version == 2 &&
		   cfg->loginternal && cfg->dsunit) {
		/* lsunit and dsunit now in fs blocks */
		cfg->lsunit = cfg->dsunit;
	}

AFAICT, the "lsunit matches fs block size" logic is buggy.  This code
was added with no justification as part of a "reworking" commit
2f44b1b0e5adc4 ("mkfs: rework stripe calculations") back in 2017.  I
think the correct logic is:

	if (cli_opt_set(&lopts, L_SUNIT))
		lsunit = cli->lsunit;
	else if (cli_opt_set(&lopts, L_SU))
		lsu = getnum(cli->lsu, &lopts, L_SU);

	if (lsu) {
		/* verify if lsu is a multiple block size */
		if (lsu % cfg->blocksize != 0) {
			fprintf(stderr,
	_("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
				lsu, cfg->blocksize);
			usage();
		}
		lsunit = (int)BTOBBT(lsu);
	}
	if (BBTOB(lsunit) % cfg->blocksize != 0) {
		fprintf(stderr,
_("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
			BBTOB(lsunit), cfg->blocksize);
		usage();
	}

and then we move the "lsunit matches fs block size" logic to the
no-lsunit-option code below:

	if (lsunit) {
		/* convert from 512 byte blocks to fs blocks */
		cfg->lsunit = DTOBT(lsunit, cfg->blocklog);
	} else if (cfg->sb_feat.log_version == 2 && cfg->loginternal) {
		if (cfg->dsunit) {
			/* lsunit and dsunit now in fs blocks */
			cfg->lsunit = cfg->dsunit;
		} else if (cfg->lsectorsize > XLOG_HEADER_SIZE) {
			/* lsunit matches filesystem block size */
			cfg->lsunit = 1;
		}
	} else if (cfg->sb_feat.log_version == 2 &&
		   !cfg->loginternal) {
		/* use the external log device properties */
		cfg->lsunit = DTOBT(ft->log.sunit, cfg->blocklog);
	}

This seems to set sb_logsunit to 4096 on my test VM, to 262144 with
the scsi_debug device that you created in [1], and to 0 on the even more
boring VMs with 512 physical sectors.

--D

[1] https://lore.kernel.org/linux-xfs/20250926123829.2101207-2-lukas@herbolt.com/

>  		/* verify if lsu is a multiple block size */
>  		if (lsu % cfg->blocksize != 0) {
>  			fprintf(stderr,
> -- 
> 2.53.0
> 
> From 2771375662c9edce25d7268bc71cc6db35a0d5c7 Mon Sep 17 00:00:00 2001
> From: Lukas Herbolt <lukas@herbolt.com>
> Date: Fri, 26 Sep 2025 12:48:39 +0200
> Subject: [PATCH 1/1] mkfs.xfs fix sunit size on 512e and 4kN disks.
> 
> Creating of XFS on 4kN or 512e disk result in suboptimal LSU/LSUNIT.
> As of now we check if the sectorsize is bigger than XLOG_HEADER_SIZE
> and so we set lsu to blocksize. But we do not check the the size if
> lsunit can be bigger to fit the disk geometry.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  mkfs/xfs_mkfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index b34407725f76..1b6334e9adce 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3647,7 +3647,7 @@ check_lsunit:
>  	else if (cfg->lsectorsize > XLOG_HEADER_SIZE)
>  		lsu = cfg->blocksize; /* lsunit matches filesystem block size */
>  
> -	if (lsu) {
> +	if (cli->lsu) {
>  		/* verify if lsu is a multiple block size */
>  		if (lsu % cfg->blocksize != 0) {
>  			fprintf(stderr,
> -- 
> 2.53.0
> 
> 
