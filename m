Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D84DDB8
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724374153; cv=none; b=YlmbLzpjiUXgpRr3xlYbhNb9z+rZmLfz/encycUWMyzkgiG6FD64KFZ7kawEh34Lw0Nxc34d0ab2ACDdr0NhKd9bHAdG58mfv/qcqbR4W2FCv6hKd5sA49x/Rg0lyGmblEjc5eMXTCfbc2fSnfEXm3z4/2NkpAv/QsLt16GjeVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724374153; c=relaxed/simple;
	bh=RFSKZfQLrytQdpuSgR9zKax5SqplbWVMVdnIJcTHg/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jfMGixzUS73c2XVTnoZEPOiu0i6UaZ/atdIDWoJ4iEHNds4l6c97SmcFhtsPPco5D7r1ExS5LQJBHEBmIXCEAsBzflkMC5crrRih0H7TykiUlc7VqLEjc8SNx0KQajmBtD63ezjswooIP3KcS422j2G671moEtN5CEoET3yGAPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=njw+oL0m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="njw+oL0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A2DC32782;
	Fri, 23 Aug 2024 00:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724374153;
	bh=RFSKZfQLrytQdpuSgR9zKax5SqplbWVMVdnIJcTHg/M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=njw+oL0mrNXrHF1ZyK0agIxBIWL18k1jGzf8FM7p3CJ6EnwR1hSWN0laz+YHeYquh
	 IaOXO8d9/+aBlSyMtEgIy/C4cIrc3JkJWHkNVgGGsX8czd34Cgb9/4Q7gO9FPdxhTM
	 1Zk5W2/Q4lko9lvX1Uw5L0BYMxbAKCbyicb8xatL7wixZHkhxPMkhRojN7O+UYHHIl
	 9GsAP8zuMBLQsOmpix6h8wPtzNOpD2XCxWU1FUPXZHAYds5viImecn2iJw8mECjLs9
	 4h7V97JlRBPxuFDr1EKLCk/MsRjAST0o27yVyCT2yVVGEkUV5UH5muyHEx2/k71DTc
	 KxELMfQfEJi+Q==
Date: Thu, 22 Aug 2024 17:49:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: liuhuan01@kylinos.cn
Cc: linux-xfs@vger.kernel.org, cmaiolino@redhat.com
Subject: Re: [PATCH] xfs_db: make sure agblocks is valid to prevent corruption
Message-ID: <20240823004912.GU6082@frogsfrogsfrogs>
References: <20240821104412.8539-1-liuhuan01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821104412.8539-1-liuhuan01@kylinos.cn>

On Wed, Aug 21, 2024 at 06:44:12PM +0800, liuhuan01@kylinos.cn wrote:
> From: liuh <liuhuan01@kylinos.cn>
> 
> Recently, I was testing xfstests. When I run xfs/350 case, it always generate coredump during the process.
> 	xfs_db -c "sb 0" -c "p agblocks" /dev/loop1
> 
> System will generate signal SIGFPE corrupt the process. And the stack as follow:
> corrupt at: (*bpp)->b_pag = xfs_perag_get(btp->bt_mount, xfs_daddr_to_agno(btp->bt_mount, blkno)); in function libxfs_getbuf_flags
> 	#0  libxfs_getbuf_flags
> 	#1  libxfs_getbuf_flags
> 	#2  libxfs_buf_read_map
> 	#3  libxfs_buf_read
> 	#4  libxfs_mount
> 	#5  init
> 	#6  main
> 
> The coredump was caused by the corrupt superblock metadata: (mp)->m_sb.sb_agblocks, it was 0.
> In this case, user cannot run in expert mode also.
> 
> Never check (mp)->m_sb.sb_agblocks before use it cause this issue.
> Make sure (mp)->m_sb.sb_agblocks > 0 before libxfs_mount to prevent corruption and leave a message.
> 
> Signed-off-by: liuh <liuhuan01@kylinos.cn>
> ---
>  db/init.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/db/init.c b/db/init.c
> index cea25ae5..2d3295ba 100644
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

What if we set sb_agblocks to 1 and let the debugger continue?

--D

> +	}
> +
>  	agcount = sbp->sb_agcount;
>  	mp = libxfs_mount(&xmount, sbp, &x, LIBXFS_MOUNT_DEBUGGER);
>  	if (!mp) {
> -- 
> 2.43.0
> 
