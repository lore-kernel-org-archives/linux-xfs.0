Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E981191
	for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2024 17:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723484536; cv=none; b=a1Pa4h+frR/0W3dPaLSwjHfT1PKTaxlbiC2pWVdBburbuk4+dQDy9ilY0ze7ducWUiOJkTjdS/ZxxRN5P0+88b3iHiVLz+Ry2Ey6yrlwvnkgjsVk37rJU/S7B1HuoucEM+SMWbRAahVMcvzABdIbZlUYG3TdyMFLM7qhUKgVRa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723484536; c=relaxed/simple;
	bh=g2gC+HoyPK6Kr8loo5TtdceWLK7OMYi2uwZga4QIQTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RssQlk7d98QYiFEXqyuOTZlD0D9zbSQmI3f79G1S4nghbFnGLehR9HUg9B+Z1C8w8AjXySdhQNj9rc4YIktx5oLq4VOs5mYY8DiLUbLwr458ZmhDE5DDBBaabMGuokPHF/g9vuoNLMpjhbsxkzKrgYxrJM7ZBISSWZMP/AZpexE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eW/v9PiN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eW/v9PiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F346C32782;
	Mon, 12 Aug 2024 17:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723484535;
	bh=g2gC+HoyPK6Kr8loo5TtdceWLK7OMYi2uwZga4QIQTY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eW/v9PiNx+A3oHBDaS9xiw6+gAnB3nevmUucubb2TR7TRXxBgZxzo1rQoTa58ZWaE
	 CbpIXy++QnE4nh3qE0PnKvrT/zhsFBoQsEHhIvEr2U+ws9hgCa2jGSKwEtLgz8MSEb
	 rG0nouiXpKr/Kp36YupzMiwt8ztaW6DZZEfjgm+HksmlyfzU/g4AuXHS1gy6OGPZpw
	 GkBGG3bLsxRg/c9f6YTXWzNO+cNp8QLR44d0E6D7SZLWQoe7Cir6Z1OXvweplUouUm
	 thCB76byqokz58xxdT4RhsGbDLc7bMHkbIbXN1N87ApHOtqQ2Ib1pkydDTW/DVDY5B
	 Z32DL9hzE/sRQ==
Date: Mon, 12 Aug 2024 10:42:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix handling of RCU freed inodes from other AGs
 in xrep_iunlink_mark_incore
Message-ID: <20240812174215.GA6051@frogsfrogsfrogs>
References: <20240812052352.3786445-1-hch@lst.de>
 <20240812052352.3786445-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812052352.3786445-3-hch@lst.de>

On Mon, Aug 12, 2024 at 07:23:01AM +0200, Christoph Hellwig wrote:
> When xrep_iunlink_mark_incore skips an inode because it was RCU freed
> from another AG, the slot for the inode in the batch array needs to be
> zeroed.  Also un-duplicate the check and remove the need for the
> xrep_iunlink_igrab helper.
> 
> Fixes: ab97f4b1c030 ("xfs: repair AGI unlinked inode bucket lists")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/agheader_repair.c | 28 +++++++---------------------
>  1 file changed, 7 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 2f98d90d7fd66d..558bc86b1b83c3 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -1108,23 +1108,6 @@ xrep_iunlink_walk_ondisk_bucket(
>  	return 0;
>  }
>  
> -/* Decide if this is an unlinked inode in this AG. */
> -STATIC bool
> -xrep_iunlink_igrab(
> -	struct xfs_perag	*pag,
> -	struct xfs_inode	*ip)
> -{
> -	struct xfs_mount	*mp = pag->pag_mount;
> -
> -	if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno)
> -		return false;
> -
> -	if (!xfs_inode_on_unlinked_list(ip))
> -		return false;
> -
> -	return true;
> -}
> -
>  /*
>   * Mark the given inode in the lookup batch in our unlinked inode bitmap, and
>   * remember if this inode is the start of the unlinked chain.
> @@ -1196,9 +1179,6 @@ xrep_iunlink_mark_incore(
>  		for (i = 0; i < nr_found; i++) {
>  			struct xfs_inode *ip = ragi->lookup_batch[i];
>  
> -			if (done || !xrep_iunlink_igrab(pag, ip))
> -				ragi->lookup_batch[i] = NULL;
> -
>  			/*
>  			 * Update the index for the next lookup. Catch
>  			 * overflows into the next AG range which can occur if
> @@ -1211,8 +1191,14 @@ xrep_iunlink_mark_incore(
>  			 * us to see this inode, so another lookup from the
>  			 * same index will not find it again.
>  			 */
> -			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno)
> +			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno) {
> +				ragi->lookup_batch[i] = NULL;
>  				continue;
> +			}
> +
> +			if (done || !xfs_inode_on_unlinked_list(ip))
> +				ragi->lookup_batch[i] = NULL;
> +
>  			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
>  			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
>  				done = true;
> -- 
> 2.43.0
> 
> 
