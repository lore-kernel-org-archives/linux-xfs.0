Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E5E3090E8;
	Tue, 31 Mar 2026 23:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775000166; cv=none; b=m5/PqSWmySi4uEYfkaXDDdm/mSMyG7UjKuqTWXqS2pJpLoJWc+zoEELpNHmjZ7+5aA+Je1KluQ4uqP6o2JXmnFmSHT1L2T0h6cVWW1VpWqYNlpZ//44wWc/aW+MqiT6ZvAEswFaEuQwVrG2+3F0DVpsrUbXDBYiBKLRsIQ+Cvho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775000166; c=relaxed/simple;
	bh=4Vz30RKNLIzqXDG7pq5QA290tQq9TizJ9InK1yco/uA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lfqA0di5XYlXTQHis1Wua8jkPpD1X1p9QKXNiwKxuwqMLCarD6F3LlrHusySjMRiv9bpcRVXNSi2b4NTjmLTvk+YV/bW4BbFBQAyaxnBEFNewaO6/PCwKpYUjM7V4rr5kkvv2tlUgnbcTU4w38P6X8JedQ9e/aRyRmNUZgVb4Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O9dgTx3/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O9dgTx3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC047C19423;
	Tue, 31 Mar 2026 23:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775000166;
	bh=4Vz30RKNLIzqXDG7pq5QA290tQq9TizJ9InK1yco/uA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O9dgTx3/YTk4EZfXYiy47DlMfi1i5hE1tl6fX/zYaaznOfIgfK676dXTcAyPuKDa+
	 cuu2nZ9dDNHTrRD2w0if1Tiad7exj2CeNztLs9LhFw5ZGrleCh0zFmA9beCgiuFoDz
	 tFczHH1SRx4sGNr9Z1H+B/61Nc0cj/v5L+7tMyRxxa8sej5n4LqtcynCUxefzfBJVR
	 kdq8UycgfEvcmBHnVx33MD2S3T2AR/khpGZaoCKwvfyktsAAswMsUmw1SY6vIPkjUf
	 CfSgz2d5dln5bx/TZRKdz9Yv09OVmzhzMKUb1pxATYt3KNVQrwGhfqQBXClEVbH6Zf
	 c4Tizxc8eUISw==
Date: Tue, 31 Mar 2026 16:36:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v6 16/22] xfs: remove unwritten extents after
 preallocations in fsverity metadata
Message-ID: <20260331233605.GJ6223@frogsfrogsfrogs>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
 <20260331212827.2631020-17-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331212827.2631020-17-aalbersh@kernel.org>

On Tue, Mar 31, 2026 at 11:28:17PM +0200, Andrey Albershteyn wrote:
> XFS preallocates spaces during writes. In normal I/O this space, if
> unused, is removed by truncate. For files with fsverity XFS does not use
> truncate as fsverity metadata is stored past EOF.
> 
> After we're done with writing fsverity metadata iterate over extents in
> that region and remove any unwritten ones. These would be left overs in
> the holes in the merkle tree and past fsverity descriptor.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

/me is ok with this
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_fsverity.c | 67 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 67 insertions(+)
> 
> diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
> index 5a6a48fcf843..b193009a1bdb 100644
> --- a/fs/xfs/xfs_fsverity.c
> +++ b/fs/xfs/xfs_fsverity.c
> @@ -21,6 +21,8 @@
>  #include "xfs_iomap.h"
>  #include "xfs_error.h"
>  #include "xfs_health.h"
> +#include "xfs_bmap.h"
> +#include "xfs_bmap_util.h"
>  #include <linux/fsverity.h>
>  #include <linux/iomap.h>
>  #include <linux/pagemap.h>
> @@ -173,6 +175,63 @@ xfs_fsverity_delete_metadata(
>  	return error;
>  }
>  
> +static int
> +xfs_fsverity_cancel_unwritten(
> +	struct xfs_inode	*ip,
> +	xfs_fileoff_t		start,
> +	xfs_fileoff_t		end)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_trans	*tp;
> +	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSB(mp, start);
> +	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, end);
> +	struct xfs_bmbt_irec	imap;
> +	int			nimaps;
> +	int			error = 0;
> +	int			done;
> +
> +
> +	while (offset_fsb < end_fsb) {
> +		nimaps = 1;
> +
> +		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0,
> +				0, &tp);
> +		if (error)
> +			return error;
> +
> +		xfs_ilock(ip, XFS_ILOCK_EXCL);
> +		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
> +				&imap, &nimaps, 0);
> +		if (error)
> +			goto out_cancel;
> +
> +		if (nimaps == 0)
> +			goto out_cancel;
> +
> +		if (imap.br_state == XFS_EXT_UNWRITTEN) {
> +			xfs_trans_ijoin(tp, ip, 0);
> +
> +			error = xfs_bunmapi(tp, ip, imap.br_startoff,
> +					imap.br_blockcount, 0, 1, &done);
> +			if (error)
> +				goto out_cancel;
> +
> +			error = xfs_trans_commit(tp);
> +		} else {
> +			xfs_trans_cancel(tp);
> +		}
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +
> +		offset_fsb = imap.br_startoff + imap.br_blockcount;
> +	}
> +
> +	return error;
> +out_cancel:
> +	xfs_trans_cancel(tp);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	return error;
> +}
> +
>  
>  /*
>   * Prepare to enable fsverity by clearing old metadata.
> @@ -248,6 +307,14 @@ xfs_fsverity_end_enable(
>  	if (error)
>  		goto out;
>  
> +	/*
> +	 * Remove unwritten extents left by COW preallocations and write
> +	 * preallocation in the merkle tree holes and past descriptor
> +	 */
> +	error = xfs_fsverity_cancel_unwritten(ip, range_start, LLONG_MAX);
> +	if (error)
> +		goto out;
> +
>  	/*
>  	 * Proactively drop any delayed allocations in COW fork, the fsverity
>  	 * files are read-only
> -- 
> 2.51.2
> 
> 
