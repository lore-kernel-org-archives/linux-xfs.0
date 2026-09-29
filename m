Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897142367D3;
	Tue, 29 Sep 2026 01:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790645183; cv=none; b=aFbTk/CiYRsfVuhRFjgC9OCzudQq7/7dU5IjzF1x9Z/a+SHbUu5nqGoHjgdt4Rhu4pweZKX2PxV/4clcSs7Dn5NZbI2UDS1s86S9+OriphjAwdSNkmkAqx6CE003RwMm/Cs7TOqDYyj1WEMh0xMv2pcVxYdRxCb7AQ/UtkiI0ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790645183; c=relaxed/simple;
	bh=A3lGhAnhbqfoTKLK1uBGM64TxCwtAtJa7od8D74WA9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jfMETzQfhjtUu/M+LNNlAXvTuCat3MGBqdSab4rHhdf8zK7/7yx48Ky6pA4oM+a6OC5s7+51fCf3/isiaIfz8xsHyY/+Sp9IEkktyg63K5oOtH2rtjoLL4klv0x/+4gsc/rjdskOk3h15JqvWGRWzcM6DWr4+z5rUCNeQDfFmU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eSyPgaUM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eSyPgaUM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 338F81F000FF;
	Tue, 29 Sep 2026 01:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790645182;
	bh=l3zhNd9Lsp3tNcDVwsDwm5ITcaGVWBuPymjoUuM7uLA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eSyPgaUMBaasbKNqzafa9VpIeyCyRmhFr6Ys9M9nt7urkQ06JoUqoGoukKq10A29v
	 m+Eoo2a6FiirW2FEQOMh2kfg7lKo3MyT6btH3zBShmwtqQ0LKuRDOaeaDEF/6X1Rnj
	 4ANcVLHCvXEoMfTw8vr4A26uQzymAtsLMHqXc9VghIX5yS28xu3jCoT6zQxSkNr3BS
	 I5oHg9SY1me1ngiYdRNAk/CRuWUCQ7YFucc5PGeLWai64bRd2ylLqxoklM0pl6ykSh
	 VwyBpn8poUPaWtyMuaqBaK1oi88aAK4sRi/ZyLzSsb/HuVd2wHLaEXN7esTttghaMq
	 0TxzZsiyVCG/w==
Date: Mon, 28 Sep 2026 18:26:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 19/21] xfs: report RT data checksum information via
 XFS_FSOP_GEOM
Message-ID: <20260929012621.GA2705364@frogsfrogsfrogs>
References: <20260924100032.2733101-1-hch@lst.de>
 <20260924100032.2733101-20-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100032.2733101-20-hch@lst.de>

On Thu, Sep 24, 2026 at 11:59:51AM +0200, Christoph Hellwig wrote:
> Report the RT data checksum flag and the checksum algorithm to userspace.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_fs.h | 6 +++++-
>  fs/xfs/libxfs/xfs_sb.c | 5 +++++
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 185f09f327c0..afe83ff23ef3 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -191,7 +191,10 @@ struct xfs_fsop_geom {
>  	__u32		rgcount;	/* number of realtime groups	*/
>  	__u64		rtstart;	/* start of internal rt section */
>  	__u64		rtreserved;	/* RT (zoned) reserved blocks	*/
> -	__u64		reserved[14];	/* reserved space		*/
> +	__u8		rtcsum_type;	/* RT data checksum type	*/
> +	__u8		rtcsum_blklog;	/* log2 of rtcsum bsize		*/
> +	__u8		reserved_pad[6];/* reserved space		*/
> +	__u64		reserved[13];	/* reserved space		*/
>  };
>  
>  #define XFS_FSOP_GEOM_SICK_COUNTERS	(1 << 0)  /* summary counters */
> @@ -250,6 +253,7 @@ typedef struct xfs_fsop_resblks {
>  #define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 25) /* linux parent pointers */
>  #define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 26) /* metadata directories */
>  #define XFS_FSOP_GEOM_FLAGS_ZONED	(1 << 27) /* zoned rt device */
> +#define XFS_FSOP_GEOM_FLAGS_DATA_CSUM	(1 << 28) /* data checksums */
>  
>  /*
>   * Minimum and maximum sizes need for growth checks.
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 3a470aec6c0c..506caf3e5201 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1660,6 +1660,11 @@ xfs_fs_geometry(
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
>  	if (xfs_has_zoned(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_ZONED;
> +	if (xfs_has_rtcsum(mp)) {
> +		geo->flags |= XFS_FSOP_GEOM_FLAGS_DATA_CSUM;
> +		geo->rtcsum_type = mp->m_sb.sb_rtcsum_type;
> +		geo->rtcsum_blklog = mp->m_sb.sb_rtcsum_blklog;
> +	}
>  	geo->rtsectsize = sbp->sb_blocksize;
>  	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
>  
> -- 
> 2.53.0
> 
> 
