Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628B22D6E4B;
	Tue, 10 Mar 2026 01:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773106155; cv=none; b=moGa/fVjSRb84CJQHmneAwmbs3NdPMpRAsJzqfwUR7bijHjfO1OE/AYF0gLMVmnuMzWskQGOmkDp/y0GbBLUOp2RwOJkzZiaJbxlo/LEGf9IpPqz0nJXeSywwEt45S8KnalkNSQRUS5D+XddN8VMLvIjCII7tuKGMprTjCh+6pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773106155; c=relaxed/simple;
	bh=psMJeJ5QeW8IxZJ0xELWgUGIx/A1kFF6591jRgDLsAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VymDkl8AN1IbrBPIhm/86aYhB3T5sC5ZmWDQmgKI//R7nXb6jfcUz1BybXuf3aGp0sWUN+ZsXBWCfmzM3zL0Pt/rMtyoIR1ion/XVxk/QYfnwP8xdYKAKM4nLVSJB5NiVZrbc5pKvuW8jo8G+9X3KFTidvyQ31lajp/4dLrrwMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J8tuMvN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J8tuMvN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0813BC4CEF7;
	Tue, 10 Mar 2026 01:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773106155;
	bh=psMJeJ5QeW8IxZJ0xELWgUGIx/A1kFF6591jRgDLsAM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J8tuMvN5dh7ZFOphg99/sztaSQz9CBx7xX8N75nGlVabNVY+vSoB1YPK2+lII0+Ar
	 IkRvCN+E59+pb7dwInJl8GZ16zgR4OpeUS5bK1J/OZfE7c3k0AZchZ50ghQWCunAOS
	 iOJyZvBYopjaa32T4Gwd8Owvb0bXRi41BcrLtl+tnuVilrI0HzM15cNWtwwDXx8UJ2
	 SKBOOVmTuhK1K0ZD+H7S8jFXhh6paWncBM3Tsr+ZhEDI75OdECJpiS6W5Z851KkSGG
	 8J/FZJrrLW0tlsHRdTN40MA7bGIqipN6EDFFUSJFJv6ga7plNVTFWrEVlVR86OjKlN
	 b0j8sDZBFhtuw==
Date: Mon, 9 Mar 2026 18:29:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 19/25] xfs: remove unwritten extents after
 preallocations in fsverity metadata
Message-ID: <20260310012914.GG1105363@frogsfrogsfrogs>
References: <20260309192355.176980-1-aalbersh@kernel.org>
 <20260309192355.176980-20-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309192355.176980-20-aalbersh@kernel.org>

On Mon, Mar 09, 2026 at 08:23:34PM +0100, Andrey Albershteyn wrote:
> XFS preallocates spaces during writes. In normal I/O this space, if
> unused, is removed by truncate. For files with fsverity, XFS does not
> use truncate as fsverity metadata is stored past EOF.
> 
> After we're done with writing fsverity metadata iterate over extents in
> that region and remove any unwritten ones. These would be preallocation
> leftovers in the merkle tree holes and past fsverity descriptor.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  fs/xfs/xfs_fsverity.c | 62 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 62 insertions(+)
> 
> diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
> index e5cd17ec15b6..f78e5f0c2fd0 100644
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
> @@ -189,6 +191,58 @@ xfs_fsverity_delete_metadata(
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
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0, &tp);
> +	if (error)
> +		return error;
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, 0);
> +
> +	while (offset_fsb < end_fsb) {
> +		nimaps = 1;
> +
> +		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
> +							  &imap, &nimaps, 0);

Indent two tabs, plz. :)

> +		if (error)
> +			goto out_cancel;
> +
> +		if (nimaps == 0)
> +			break;
> +
> +		if (imap.br_state == XFS_EXT_UNWRITTEN) {
> +			error = xfs_bunmapi(tp, ip, imap.br_startoff,
> +					    imap.br_blockcount, 0, 1, &done);
> +			if (error)
> +				goto out_cancel;
> +		}
> +
> +		offset_fsb = imap.br_startoff + imap.br_blockcount;

There's an upper limit on the number of blocks you can unmap/free in a
single transaction.  Maybe move the xfs_trans_{alloc,commit} into the
loop body?

Oh wait, you skip the written extents.  Ok, so maybe just roll it after
you've done a bunmapi.

Do you need to purge the cow fork too?

--D

> +	}
> +
> +	error = xfs_trans_commit(tp);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
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
> @@ -264,6 +318,14 @@ xfs_fsverity_end_enable(
>  	if (error)
>  		goto out;
>  
> +	/*
> +	 * Remove unwritten extents left by preallocations in the merkle tree
> +	 * holes and past descriptor
> +	 */
> +	error = xfs_fsverity_cancel_unwritten(ip, range_start, LLONG_MAX);
> +	if (error)
> +		goto out;
> +
>  	/*
>  	 * Set fsverity inode flag
>  	 */
> -- 
> 2.51.2
> 
> 
