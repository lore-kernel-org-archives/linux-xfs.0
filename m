Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91CA1898FB
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 22:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734041724; cv=none; b=bW8QTqUehl010VgaevUSMieDdiyEv3YpmvFW+TweC4xNeD8RvG8hb2Oq5+3tmIF2eMZCtoGKlzbjvD8uuUjV+N0W/Zwrbk0tIaq/uBlZfpzIIUSPW7iIvUP4Q8xaCy/+XZNdffmI/pwx0NRuJqWRIpsg1u5z6F/dfyjW+RI+aC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734041724; c=relaxed/simple;
	bh=Upv1c2Y3BidkRY1A52hHznjuZ/heVHfBtnvADgr+G58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FP+sdo+S4GJs00lJMmh5PQSq9EAl8DjEC6GLwMnPjzHFgZxCd9/xLBnCe0cbclFAU+kiKkdRJMMxgKHQQauDksdAu6gRrls+FzIxDj7/rtM5PY8x1k/Vh8854G/+ZdVEeTCoKbECSq54YirrOXHoPCPpJdLmQ2wOBIZu2tuSFVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NqINcDzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NqINcDzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7D2C4CECE;
	Thu, 12 Dec 2024 22:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734041724;
	bh=Upv1c2Y3BidkRY1A52hHznjuZ/heVHfBtnvADgr+G58=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NqINcDzQ3gWoIawMtoiSbAwTpPPQnvCyJNqdJcrzSZy1qMujASpT6Zf4GQaPbW1b8
	 hQ/iJEYuxc5elSCS1ozNr7N+7mDfW2klgyZB12VEFmd/Fm97+5FH6abA0cGK3lw0Gy
	 X6zTDUQYGzX/vPjM39X61WBjTl5HD4tEXafIC3zOZ1QaCE6xhXY3VcRSujBWZRfF0L
	 TJ/I5hbrHVIr4IrCSeYaBbm1tLkq63mqgPvOwNz78y5KPANQfm58lD76JDOBNrXIup
	 mn6kfw9jQz2hsnl84i7BcHKmuIZ/fBldeNuWZyoOlCzo4oiI04cBwJltRIPL2NNB5O
	 mmLhJFJdojjaw==
Date: Thu, 12 Dec 2024 14:15:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/43] xfs: don't call xfs_can_free_eofblocks from
 ->release for zoned inodes
Message-ID: <20241212221523.GF6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-22-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-22-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:46AM +0100, Christoph Hellwig wrote:
> Zoned file systems require out of place writes and thus can't support
> post-EOF speculative preallocations.  Avoid the pointless ilock critical
> section to find out that none can be freed.

I wonder if this is true of alwayscow inodes in general, not just zoned
inodes?

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Anyway that makes sense to me, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_file.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 27301229011b..827f7819df6a 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1356,15 +1356,22 @@ xfs_file_release(
>  	 * blocks.  This avoids open/read/close workloads from removing EOF
>  	 * blocks that other writers depend upon to reduce fragmentation.
>  	 *
> +	 * Inodes on the zoned RT device never have preallocations, so skip
> +	 * taking the locks below.
> +	 */
> +	if (!inode->i_nlink ||
> +	    !(file->f_mode & FMODE_WRITE) ||
> +	    (ip->i_diflags & XFS_DIFLAG_APPEND) ||
> +	    xfs_is_zoned_inode(ip))
> +		return 0;
> +
> +	/*
>  	 * If we can't get the iolock just skip truncating the blocks past EOF
>  	 * because we could deadlock with the mmap_lock otherwise. We'll get
>  	 * another chance to drop them once the last reference to the inode is
>  	 * dropped, so we'll never leak blocks permanently.
>  	 */
> -	if (inode->i_nlink &&
> -	    (file->f_mode & FMODE_WRITE) &&
> -	    !(ip->i_diflags & XFS_DIFLAG_APPEND) &&
> -	    !xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
> +	if (!xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
>  	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
>  		if (xfs_can_free_eofblocks(ip) &&
>  		    !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED))
> -- 
> 2.45.2
> 
> 
