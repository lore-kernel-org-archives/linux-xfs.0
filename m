Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F204343D63
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 22:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772751415; cv=none; b=TaMShba+hwn1Lfec88PHUhq8wss4KAh/dfa/IY3FOhssWXhL9OpYtJ1G6YkWS1dNL+NPb/3BNNkeQQ1vRcYPffrRVORQH8rqbbaXYWclcm3zjLVN/gw/Du+cFtrzIiReC0pjVY1I/hKXY7d/M8qUoM8Gt+G5qFLSjnvXwGRUbEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772751415; c=relaxed/simple;
	bh=vgng9IACBs6iWr4EaW8O6H7BvRrEpoH6Ul92dwBqzUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eKjaKZX0624RCbVn/oOzuvDj6LNn0M/2vYbMoxriCZ6UAR2M9+YOqdMCUmV9nlZMCyfiz9N6yc/o7wvqsDAQ3u/tZ22aNGXRCYONZVc8gztYVjXeqM4vefNpqGqJWE/tfGy2nLyr8OhAkQiRBXU7J/i5cHdjjGFUUP8EscQRjNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b0xqZGVn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b0xqZGVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFA4C116C6;
	Thu,  5 Mar 2026 22:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772751415;
	bh=vgng9IACBs6iWr4EaW8O6H7BvRrEpoH6Ul92dwBqzUE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b0xqZGVnhI+DVvQESBE/DZPOQu8NvmRbqY7wM0OApNEVmIxXKaN/QIoWutO66Og0q
	 m8kC2VfYk5ocjeu+TXMQyDWqFyRO3cC9uPIOvvz5tUKrpa9Y1uZ0ZEobTFS3BHDIfw
	 JkindwRdph4kgG83qltnSCUQS/y28zo+80OnsM1iaLnZ2pjQlcnbU4gNYpni12bgB/
	 TtE3Nv0gdGZxzfoCdmgHeERUYwWaIcfKTv2bZEm6bDDI9R2cPwQfGw6HVLUyeqfpos
	 mWO9a1ZAXgPIjbIoB1/9Z9BlxrW3UMjYK8jdrTk+mWhiGCUQsOxwj0i6u44cwzBfyh
	 HZsJBU44PYHAw==
Date: Thu, 5 Mar 2026 14:56:54 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] mkfs: fix log sunit automatic configuration
Message-ID: <20260305225654.GK57948@frogsfrogsfrogs>
References: <177268456992.1999857.6319345892309281117.stgit@frogsfrogsfrogs>
 <177268457083.1999857.7479249726865742847.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177268457083.1999857.7479249726865742847.stgit@frogsfrogsfrogs>

On Wed, Mar 04, 2026 at 08:24:55PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This patch fixes ~96% failure rates on fstests on my test fleet, some
> of which now have 4k LBA disks with unexciting min/opt io geometry:
> 
> # lsblk -t /dev/sda
> NAME   ALIGNMENT MIN-IO  OPT-IO PHY-SEC LOG-SEC ROTA SCHED RQ-SIZE   RA WSAME
> sda            0   4096 1048576    4096     512    1 bfq       256 2048    0B
> # mkfs.xfs -f -N /dev/sda3
> meta-data=/dev/sda3              isize=512    agcount=4, agsize=2183680 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
>          =                       exchange=1   metadir=0
> data     =                       bsize=4096   blocks=8734720, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
> log      =internal log           bsize=4096   blocks=16384, version=2
>          =                       sectsz=4096  sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
>          =                       rgcount=0    rgsize=0 extents
>          =                       zoned=0      start=0 reserved=0
> 
> Note that MIN-IO == PHY-SEC, so dsunit/dswidth are zero.  With this
> change, we no longer set the lsunit to the fsblock size if the log
> sector size is greater than 512.  Unfortunately, dsunit is also not set,
> so mkfs never sets the log sunit and it remains zero.  I think
> this causes problems with the log roundoff computation in the kernel:
> 
> 	if (xfs_has_logv2(mp) && mp->m_sb.sb_logsunit > 1)
> 		log->l_iclog_roundoff = mp->m_sb.sb_logsunit;
> 	else
> 		log->l_iclog_roundoff = BBSIZE;
> 
> because now the roundoff factor is less than the log sector size.  After
> a while, the filesystem cannot be mounted anymore because:
> 
> XFS (sda3): Mounting V5 Filesystem 81b8ffa8-383b-4574-a68c-9b8202707a26
> XFS (sda3): Corruption warning: Metadata has LSN (4:2729) ahead of current LSN (4:2727). Please unmount and run xfs_repair (>= v4.3) to resolve.
> XFS (sda3): log mount/recovery failed: error -22
> XFS (sda3): log mount failed
> 
> Reverting this patch makes the problem go away, but I think you're
> trying to make it so that mkfs will set lsunit = dsunit if dsunit>0 and
> the caller didn't specify any -lsunit= parameter, right?
> 
> But there's something that just seems off with this whole function.  If
> the user provided a -lsunit/-lsu option then we need to validate the
> value and either use it if it makes sense, or complain if not.  If the
> user didn't specify any option, then we should figure it out
> automatically from the other data device geometry options (internal) or
> the external log device probing.
> 
> But that's not what this function does.  Why would you do this:
> 
> 	else if (cfg->lsectorsize > XLOG_HEADER_SIZE)
> 		lsu = cfg->blocksize; /* lsunit matches filesystem block size */
> 
> and then loudly validate that lsu (bytes) is congruent with the fsblock
> size?  This is trivially true, but then it disables the "make lsunit use
> dsunit if set" logic below:
> 
> 	} else if (cfg->sb_feat.log_version == 2 &&
> 		   cfg->loginternal && cfg->dsunit) {
> 		/* lsunit and dsunit now in fs blocks */
> 		cfg->lsunit = cfg->dsunit;
> 	}
> 
> AFAICT, the "lsunit matches fs block size" logic is buggy.  This code
> was added with no justification as part of a "reworking" commit
> 2f44b1b0e5adc4 ("mkfs: rework stripe calculations") back in 2017.  I
> think the correct logic is to move the "lsunit matches fs block size"
> logic to the no-lsunit-option code after the validation code.
> 
> This seems to set sb_logsunit to 4096 on my test VM, to 0 on the even
> more boring VMs with 512 physical sectors, and to 262144 with the
> scsi_debug device that Lukas Herbolt created with:
> 
> # modprobe scsi_debug inq_vendor=XFS_TEST physblk_exp=3 sector_size=512 \
> opt_xferlen_exp=9 opt_blks=512 dev_size_mb=100 virtual_gb=1000
> 
> Cc: <linux-xfs@vger.kernel.org> # v4.15.0
> Fixes: 2f44b1b0e5adc4 ("mkfs: rework stripe calculations")
> Fixes: ca1eb448e116da ("mkfs.xfs fix sunit size on 512e and 4kN disks.")
> Link: https://lore.kernel.org/linux-xfs/20250926123829.2101207-2-lukas@herbolt.com/
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  mkfs/xfs_mkfs.c |   16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index ece20905b28313..a45859dd633e98 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3624,10 +3624,8 @@ _("%s: Stripe unit(%d) or stripe width(%d) is not a multiple of the block size(%
>  		lsunit = cli->lsunit;
>  	else if (cli_opt_set(&lopts, L_SU))
>  		lsu = getnum(cli->lsu, &lopts, L_SU);
> -	else if (cfg->lsectorsize > XLOG_HEADER_SIZE)
> -		lsu = cfg->blocksize; /* lsunit matches filesystem block size */
>  
> -	if (cli->lsu) {
> +	if (lsu) {
>  		/* verify if lsu is a multiple block size */
>  		if (lsu % cfg->blocksize != 0) {
>  			fprintf(stderr,
> @@ -3651,10 +3649,14 @@ _("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
>  	if (lsunit) {
>  		/* convert from 512 byte blocks to fs blocks */
>  		cfg->lsunit = DTOBT(lsunit, cfg->blocklog);
> -	} else if (cfg->sb_feat.log_version == 2 &&
> -		   cfg->loginternal && cfg->dsunit) {
> -		/* lsunit and dsunit now in fs blocks */
> -		cfg->lsunit = cfg->dsunit;
> +	} else if (cfg->sb_feat.log_version == 2 && cfg->loginternal) {
> +		if (cfg->dsunit) {
> +			/* lsunit and dsunit now in fs blocks */
> +			cfg->lsunit = cfg->dsunit;
> +		} else if (cfg->lsectorsize > XLOG_HEADER_SIZE) {
> +			/* lsunit matches filesystem block size */
> +			cfg->lsunit = 1;
> +		}
>  	} else if (cfg->sb_feat.log_version == 2 &&
>  		   !cfg->loginternal) {
>  		/* use the external log device properties */

There's a bug in this patch; the lsectorsize > XLOG_HEADER_SIZE also
needs to be copied downwards to the external log configuration part.

--D
