Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4E71C683
	for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2024 00:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724200309; cv=none; b=K05y01fArdYiOfD7xg2tUdVGzN91lO5W7DaxxGr4EBWZt2b9JmSxDI3ionaKBKymyTGIVm6271PyFzwVpI27iEZHhlkjqNHyRNxUnWYxrSBWYle/NM2N+xLlutmWtx6EvaSaFvuWGwCAkyIFdPU9GDkYUcyU82O4kW/OcjavVlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724200309; c=relaxed/simple;
	bh=58pHqsVHnh2ci7MntRVeyLPYBsELqPu4MDWIXOr+bHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Koc8f+hhtXJhANC2CIwKrm6Mtzr6ZgbJqexDdwIMoL5XKdECbHDp/BrTcPGziV32bXpZU3DQ3Ru1aHJvQvS5mFZOhedf92VDSAxUT/WgMqPXqToDXvHAwCupfSRpki3RfGFdzh9eXi63eyaGLOqNI2o1rMCHyaeyOktSpySYMSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QiIBsnNN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QiIBsnNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65947C4AF0F;
	Wed, 21 Aug 2024 00:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724200308;
	bh=58pHqsVHnh2ci7MntRVeyLPYBsELqPu4MDWIXOr+bHU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QiIBsnNN4PgEuSrHEvA7zQgpryGn3MfxH3cwZF0snGfE0oSfTilyGxK1WCY14jy3q
	 Ts7pA/xQkullcsyZYKw6D+aU2a0tOVmJ2U5KQppduuwSA7sBkeCIa7G3/ruRPEwok3
	 Fw5Z9ZTpOpANrWp1FMbXQ/jxbsFPjb7TmSpr5XTGg89/MkXQBImTKwlJUASH2U88ss
	 t9VDKg1LWG2vRlyikmtCjlxQA4Cgybg1tlM0kZpMUjOUyAQDqckbhT0AHtTATxGlXz
	 spTQH2/sm9ibd0q/LxRe1uTlJ+RaV6IKKTzJOQYida9tJBu8pPKp2HwfRi97iSL/TT
	 8RW3FzbG2Z8bA==
Date: Tue, 20 Aug 2024 17:31:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: liuhuan01@kylinos.cn
Cc: linux-xfs@vger.kernel.org, cmaiolino@redhat.com
Subject: Re: [PATCH] xfs_db: do some checks in init to prevent corruption
Message-ID: <20240821003147.GT865349@frogsfrogsfrogs>
References: <20240820015654.17418-1-liuhuan01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820015654.17418-1-liuhuan01@kylinos.cn>

On Tue, Aug 20, 2024 at 09:56:54AM +0800, liuhuan01@kylinos.cn wrote:
> From: liuh <liuhuan01@kylinos.cn>
> 
> Recently, I was testing xfstests. When I run xfs/350 case, it always generate coredumps during the process.
> Total two types of coredump:
> 	(a) xfs_db -c "sb 0" -c "print sectlog" /dev/loop1
> 	(b) xfs_db -c "sb 0" -c "print agblock" /dev/loop1
> 
> For coredump (a) system will generate signal SIGSEGV corrupt the process. And the stack as follow:
> corrupt at: q = *++b; in function crc32_body
> 	#0  crc32_body
> 	#1  crc32_le_generic
> 	#2  crc32c_le
> 	#3  xfs_start_cksum_safe
> 	#4  libxfs_verify_cksum
> 	#5  xfs_buf_verify_cksum
> 	#6  xfs_agf_read_verify
> 	#7  libxfs_readbuf_verify
> 	#8  libxfs_buf_read_map
> 	#9  libxfs_trans_read_buf_map
> 	#10 libxfs_trans_read_buf
> 	#11 libxfs_read_agf
> 	#12 libxfs_alloc_read_agf
> 	#13 libxfs_initialize_perag_data
> 	#14 init
> 	#15 main
> 
> For coredump (b) system will generate signal SIGFPE corrupt the process. And the stack as follow:
> corrupt at: (*bpp)->b_pag = xfs_perag_get(btp->bt_mount, xfs_daddr_to_agno(btp->bt_mount, blkno)); in function libxfs_getbuf_flags
> 	#0  libxfs_getbuf_flags
> 	#1  libxfs_getbuf_flags
> 	#2  libxfs_buf_read_map
> 	#3  libxfs_buf_read
> 	#4  libxfs_mount
> 	#5  init
> 	#6  main
> 
> Analyze the above two issues separately:
> 	coredump (a) was caused by the corrupt superblock metadata: (mp)->m_sb.sb_sectlog, it was 128;
> 	coredump (b) was caused by the corrupt superblock metadata: (mp)->m_sb.sb_agblocks, it was 0;

One patch per bugfix, please.

> Current, xfs_db doesn't validate the superblock, it goes to corruption if superblock is damaged, theoretically.

libxfs does, but xfs_db doesn't quite use the verifiers, being a
debugger and all.

> So do some check in xfs_db init function to prevent corruption and leave some hints.
> 
> Signed-off-by: liuh <liuhuan01@kylinos.cn>
> ---
>  db/init.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/db/init.c b/db/init.c
> index cea25ae5..4402f85f 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -129,6 +129,13 @@ init(
>  		}
>  	}
>  
> +	if (unlikely(sbp->sb_agblocks == 0)) {
> +		fprintf(stderr,
> +			_("%s: device %s agblocks unexpected\n"),
> +			progname, x.data.name);
> +		exit(1);
> +	}
> +
>  	agcount = sbp->sb_agcount;
>  	mp = libxfs_mount(&xmount, sbp, &x, LIBXFS_MOUNT_DEBUGGER);
>  	if (!mp) {
> @@ -140,6 +147,13 @@ init(
>  	mp->m_log = &xlog;
>  	blkbb = 1 << mp->m_blkbb_log;
>  
> +	if (unlikely(sbp->sb_sectlog < XFS_MIN_SECTORSIZE_LOG || sbp->sb_sectlog > XFS_MAX_SECTORSIZE_LOG)) {

Please fix the long lines.

> +		fprintf(stderr,
> +			_("%s: device %s sectlog(%u) unexpected\n"),
> +			progname, x.data.name, sbp->sb_sectlog);
> +		exit(1);

If xfs_db is being run in expert mode, could we try to install
reasonable values here?  Such as the mkfs defaults?  Or let the user
specify an override via extended cli option?

--D

> +	}
> +
>  	/* Did we limit a broken agcount in libxfs_mount? */
>  	if (sbp->sb_agcount != agcount)
>  		exitcode = 1;
> -- 
> 2.43.0
> 
> 
