Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DACD186D
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 01:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BeW8yUdN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDA8C433C8;
	Tue, 28 Nov 2023 01:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701136692;
	bh=ed8Ry2OSdR74Y0d+H+DfJuES+wT77i8gyQ9HPeXHQus=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BeW8yUdNzmoUdXyTNUb9e6Jhy8OMGfh6VGsebU745pXZ2yXzHjeA6q7v1Am5nDFQS
	 GT9q/Nk6qnPTWaRsmZPhTOt7ckXc+7SsGyaem2kVgN3lwH6tvmyoSRhJOFtvsfcGNb
	 EcRyEyYgaNctIOvdt9oh0x5qLPsenw8UfltSGTskIqW7bVdu0MazgShzz33lvcmt/T
	 AK8zD/NKAYV7kLuT/eiy8CkV++feJRl8BgSqUbIXMkHca8fR+ooBCFwXJy4TbRzQ+6
	 p9MhAhSuc14u0rjZeI4liqiasovJa1H+o0UU1WUBTmgFwelAqSKO7lRCIGaqL765Eq
	 Y9VaMdIJvpUbg==
Date: Mon, 27 Nov 2023 17:58:12 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: clean up the XFS_IOC_FSCOUNTS handler
Message-ID: <20231128015812.GR2766956@frogsfrogsfrogs>
References: <20231126130124.1251467-1-hch@lst.de>
 <20231126130124.1251467-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231126130124.1251467-3-hch@lst.de>

On Sun, Nov 26, 2023 at 02:01:22PM +0100, Christoph Hellwig wrote:
> Split XFS_IOC_FSCOUNTS out of the main xfs_file_ioctl function, and
> merge the xfs_fs_counts helper into the ioctl handler.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_fsops.c | 16 ----------------
>  fs/xfs/xfs_fsops.h |  1 -
>  fs/xfs/xfs_ioctl.c | 29 ++++++++++++++++++++---------
>  3 files changed, 20 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 7cb75cb6b8e9b4..01681783e2c31a 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -343,22 +343,6 @@ xfs_growfs_log(
>  	return error;
>  }
>  
> -/*
> - * exported through ioctl XFS_IOC_FSCOUNTS
> - */
> -
> -void
> -xfs_fs_counts(
> -	xfs_mount_t		*mp,
> -	xfs_fsop_counts_t	*cnt)
> -{
> -	cnt->allocino = percpu_counter_read_positive(&mp->m_icount);
> -	cnt->freeino = percpu_counter_read_positive(&mp->m_ifree);
> -	cnt->freedata = percpu_counter_read_positive(&mp->m_fdblocks) -
> -						xfs_fdblocks_unavailable(mp);
> -	cnt->freertx = percpu_counter_read_positive(&mp->m_frextents);
> -}
> -
>  /*
>   * exported through ioctl XFS_IOC_SET_RESBLKS & XFS_IOC_GET_RESBLKS
>   *
> diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
> index 2cffe51a31e8b2..45f0cb6e805938 100644
> --- a/fs/xfs/xfs_fsops.h
> +++ b/fs/xfs/xfs_fsops.h
> @@ -8,7 +8,6 @@
>  
>  extern int xfs_growfs_data(struct xfs_mount *mp, struct xfs_growfs_data *in);
>  extern int xfs_growfs_log(struct xfs_mount *mp, struct xfs_growfs_log *in);
> -extern void xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
>  extern int xfs_reserve_blocks(xfs_mount_t *mp, uint64_t *inval,
>  				xfs_fsop_resblks_t *outval);
>  extern int xfs_fs_goingdown(xfs_mount_t *mp, uint32_t inflags);
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 8faaf2ef67a7b8..c8e78c8101c65c 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1902,6 +1902,24 @@ xfs_ioctl_getset_resblocks(
>  	return 0;
>  }
>  
> +static int
> +xfs_ioctl_fs_counts(
> +	struct xfs_mount	*mp,
> +	struct xfs_fsop_counts	*uarg)
> +{
> +	struct xfs_fsop_counts	out = {
> +		.allocino = percpu_counter_read_positive(&mp->m_icount),
> +		.freeino = percpu_counter_read_positive(&mp->m_ifree),
> +		.freedata = percpu_counter_read_positive(&mp->m_fdblocks) -
> +				xfs_fdblocks_unavailable(mp),
> +		.freertx = percpu_counter_read_positive(&mp->m_frextents),
> +	};

	struct xfs_fsop_counts	out = {
		.allocino = percpu_counter_read_positive(&mp->m_icount),
		.freeino  = percpu_counter_read_positive(&mp->m_ifree),
		.freedata = percpu_counter_read_positive(&mp->m_fdblocks) -
						xfs_fdblocks_unavailable(mp),
		.freertx  = percpu_counter_read_positive(&mp->m_frextents),
	};

Nit: Would you mind lining up the columns?

Otherwise looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> +
> +	if (copy_to_user(uarg, &out, sizeof(out)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
>  /*
>   * These long-unused ioctls were removed from the official ioctl API in 5.17,
>   * but retain these definitions so that we can log warnings about them.
> @@ -2038,15 +2056,8 @@ xfs_file_ioctl(
>  		return error;
>  	}
>  
> -	case XFS_IOC_FSCOUNTS: {
> -		xfs_fsop_counts_t out;
> -
> -		xfs_fs_counts(mp, &out);
> -
> -		if (copy_to_user(arg, &out, sizeof(out)))
> -			return -EFAULT;
> -		return 0;
> -	}
> +	case XFS_IOC_FSCOUNTS:
> +		return xfs_ioctl_fs_counts(mp, arg);
>  
>  	case XFS_IOC_SET_RESBLKS:
>  	case XFS_IOC_GET_RESBLKS:
> -- 
> 2.39.2
> 
> 
