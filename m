Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2A733EB17;
	Thu, 24 Sep 2026 22:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790289023; cv=none; b=eTjtBtmyurOfiyXCw/eCSnYW7Kg2AYu+fAIqLlfEQIa/bKSQCHn7WHntNLwPURnPNxTmCqr3PpZlh/VeTzaQo21SeXN7IiNQn4JikkuSYuEsAhAEYg15riCjZy6vIC6pMaf0TxOVIieBWmKKqM4vwaDzzdDoyYF/MhRnBwOD9oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790289023; c=relaxed/simple;
	bh=9SAqSq1ismvIddh3p901+HHVXxgAUCEadphBZMRBA04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RcRfsI20F1fWmfqOccxdkGsIo06Mh0G2AFixAn4J6CRx+isjsaL3MPsSiTS2g7Vd6tcR+RlRUEF3oRQvFnfkhFM63WySMeumml/XP/AFa/u4VmoYl4XsuIZy9vRIkPdSnT6/nl5XAbpo4LOdRVRHIG/ZxA+svkykYuMvy2sh34A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MrIz3ouh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MrIz3ouh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 315A91F000FF;
	Thu, 24 Sep 2026 22:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790289022;
	bh=7mk56OgNjhWEcWOWac4O6UrB0YreQ7NBqdT3bJ1U/Ks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MrIz3ouh5ZylQWwpZQXDmelI7PncIbI8PxdFdAkE8vz4BuEgyPyyZs0IbCIxjpNSM
	 btBAVjH5Ujq0uKn4sxCbC/gUrOnNCrftGA2wv+Bdgo4Kn+sXmn+QL+V/gE9IQAowki
	 otk8am1WGXlslixXfqK4yUtTDEeNTE9SZupDyUYflHvMDohC+5aLfb9AWFIFPIAods
	 KeZM8PEwBiwb/Pienf1NG8NbFAVnTxSOhr+vbVe5twzrv4xmWYbDGSLR6pVFdYIf5k
	 dsg8p98eV6Ee9fJxMwjeXTSl2KEIo0vWXb1SR3rcKW3gkGJ/2JN8KYnV8kag3GO8yK
	 htV5aCgNmneYA==
Date: Thu, 24 Sep 2026 15:30:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 10/21] xfs: calculate the log reservation for logging
 data checksum buffers
Message-ID: <20260924223021.GK2705364@frogsfrogsfrogs>
References: <20260924100032.2733101-1-hch@lst.de>
 <20260924100032.2733101-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100032.2733101-11-hch@lst.de>

On Thu, Sep 24, 2026 at 11:59:42AM +0200, Christoph Hellwig wrote:
> The data checksum is logged in its own transaction, and only logs
> transactions buffers.  While the maximum size of a checksummed data write
> is the same as that of a single checksum buffer, the Zone Append based
> zoned write path can't guarantee alignment, so it might be spread over
> up to three buffers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_trans_resv.c | 21 +++++++++++++++++++++
>  fs/xfs/libxfs/xfs_trans_resv.h |  4 ++++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 5382ece51812..8854253afba0 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -11,6 +11,7 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> +#include "xfs_rtcsumfile.h"
>  #include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_inode.h"
> @@ -1233,6 +1234,22 @@ xfs_calc_qm_dqalloc_reservation_minlogsize(
>  	return xfs_calc_qm_dqalloc_reservation(mp, true);
>  }
>  
> +/*
> + * Log data checksums for a write.
> + *
> + * Must cover a checksum for each FSB of data written, and the checksums can
> + * span the FSB-sized checksum buffers at both ends.
> + */
> +unsigned int
> +xfs_calc_csum_reservation(
> +	struct xfs_mount	*mp,
> +	unsigned int		csum_len)
> +{
> +	return xfs_calc_buf_res(
> +			howmany(csum_len, xfs_rtcsum_payload_size(mp)) + 1,
> +			mp->m_rtcsum_bsize);
> +}
> +
>  /*
>   * Syncing the incore super block changes to disk.
>   *     the super block to reflect the changes: sector size
> @@ -1354,6 +1371,10 @@ xfs_trans_resv_calc(
>  
>  	xfs_calc_namespace_reservations(mp, resp);
>  
> +	resp->tr_csum.tr_logres =
> +		xfs_calc_csum_reservation(mp, XFS_RTCSUM_MAX_WRITE);
> +	resp->tr_csum.tr_logcount = XFS_DEFAULT_LOG_COUNT;

Going back to a question I had in "xfs: prepare
xfs_rtfile_initialize_blocks for larger than FSB blocks", should we be
using tr_csum for the transaction to write out new checksum file block
contents?

Patch itself looks ok though,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +
>  	/*
>  	 * The following transactions are logged in logical format with
>  	 * a default log count.
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
> index 1804e821f382..127db4da31c1 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.h
> +++ b/fs/xfs/libxfs/xfs_trans_resv.h
> @@ -49,6 +49,7 @@ struct xfs_trans_resv {
>  	struct xfs_trans_res	tr_sb;		/* modify superblock */
>  	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
>  	struct xfs_trans_res	tr_atomic_ioend; /* untorn write completion */
> +	struct xfs_trans_res	tr_csum;	/* data checksums in metafile */
>  };
>  
>  /* shorthand way of accessing reservation structure */
> @@ -122,6 +123,9 @@ unsigned int xfs_calc_itruncate_reservation_minlogsize(struct xfs_mount *mp);
>  unsigned int xfs_calc_write_reservation_minlogsize(struct xfs_mount *mp);
>  unsigned int xfs_calc_qm_dqalloc_reservation_minlogsize(struct xfs_mount *mp);
>  
> +unsigned int xfs_calc_csum_reservation(struct xfs_mount *mp,
> +		unsigned int csum_len);
> +
>  xfs_extlen_t xfs_calc_max_atomic_write_fsblocks(struct xfs_mount *mp);
>  xfs_extlen_t xfs_calc_atomic_write_log_geometry(struct xfs_mount *mp,
>  		xfs_extlen_t blockcount, unsigned int *new_logres);
> -- 
> 2.53.0
> 
> 
