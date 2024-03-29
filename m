Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C485E8825
	for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2024 16:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711729868; cv=none; b=O4v38M/gbRkCWw3HcsEqspeJOdUgU2RymNI8FSNXi27cRIkb1nJSIDrdAcNyDidSfX9D3UpHtrZdKwvC0PN/o22hFZXRG20YiwWcuLW4M5lIdPcBLwWoXEpyxhJYluF0LNYi4iA3r3Ya9uQZpmAXwWhAxfogiE/gzhwXRYB/RlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711729868; c=relaxed/simple;
	bh=KqVf6BCf4afyTBKUhD46TjomyvD4RK9kgAa7OWNMk3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h1O44tgiGs0f6V/6GMxHrebAZ1vH6qcix5BVuA3HdHeoTPxSpV0t7vgIg88QaUP62wR0BX92dBxWpBLihozocftaTPSyCsxXVcJAxuZl6sTW7YW624X4L2olAukB4TqoG8o10XO5qTrvWaH5z2PcQgbrbLETrmzC0t2TCMO41ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A2sbWvwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A2sbWvwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B482C433C7;
	Fri, 29 Mar 2024 16:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711729868;
	bh=KqVf6BCf4afyTBKUhD46TjomyvD4RK9kgAa7OWNMk3Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A2sbWvwtEHg5pr7JnNPcftyqR+yTLYzHnXn5WixwpJhI3vaTcSkA7zqXuDBJRQznZ
	 rkCNmRe0st1ILzeRyJv61/b/sCziQghnact32ehQwWCKY8aY+TERfRNYSXT/SB+Yft
	 cVOoR+fTCcohYadHkd73YqkgX7GO/syvLdb7WLpTpNI3Qwoy/AXIOs/HMROF97qq9l
	 vVac+aR2BrlDo+Mbe8Y5blRJhvLJoZoubaCamcxJvr/Z6jNsujrMPy5nyowQYxVSmG
	 Q2R42t5sK6ZWUXJetGgbGJdyw1X6pJ04YWCvyunb0sr1O7DTQNJwrNTiQ75k2YX9HX
	 BPgCMB3UivXMQ==
Date: Fri, 29 Mar 2024 09:31:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: rename the del variable in
 xfs_reflink_end_cow_extent
Message-ID: <20240329163108.GJ6390@frogsfrogsfrogs>
References: <20240328070256.2918605-1-hch@lst.de>
 <20240328070256.2918605-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328070256.2918605-7-hch@lst.de>

On Thu, Mar 28, 2024 at 08:02:56AM +0100, Christoph Hellwig wrote:
> del contains the new extent that we are remapping.  Give it a somewhat
> less confusing name.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_reflink.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index a7ee868d79bf02..15c723396cfdab 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -764,7 +764,7 @@ xfs_reflink_end_cow_extent(
>  	xfs_fileoff_t		end_fsb)
>  {
>  	struct xfs_iext_cursor	icur;
> -	struct xfs_bmbt_irec	got, del;
> +	struct xfs_bmbt_irec	got, new;
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp;
>  	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_COW_FORK);
> @@ -821,29 +821,29 @@ xfs_reflink_end_cow_extent(
>  	}
>  
>  	/*
> -	 * Preserve @got for the eventual CoW fork deletion; from now on @del
> +	 * Preserve @got for the eventual CoW fork deletion; from now on @new
>  	 * represents the mapping that we're actually remapping.

I'd have called it 'remap' because that's what the comment says.

--D

>  	 */
> -	del = got;
> -	xfs_trim_extent(&del, *offset_fsb, end_fsb - *offset_fsb);
> -	trace_xfs_reflink_cow_remap_from(ip, &del);
> +	new = got;
> +	xfs_trim_extent(&new, *offset_fsb, end_fsb - *offset_fsb);
> +	trace_xfs_reflink_cow_remap_from(ip, &new);
>  
>  	/* Unmap the old data. */
> -	xfs_reflink_unmap_old_data(tp, ip, del.br_startoff,
> -			del.br_startoff + del.br_blockcount);
> +	xfs_reflink_unmap_old_data(tp, ip, new.br_startoff,
> +			new.br_startoff + new.br_blockcount);
>  
>  	/* Free the CoW orphan record. */
> -	xfs_refcount_free_cow_extent(tp, del.br_startblock, del.br_blockcount);
> +	xfs_refcount_free_cow_extent(tp, new.br_startblock, new.br_blockcount);
>  
>  	/* Map the new blocks into the data fork. */
> -	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, &del);
> +	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, &new);
>  
>  	/* Charge this new data fork mapping to the on-disk quota. */
>  	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_DELBCOUNT,
> -			(long)del.br_blockcount);
> +			(long)new.br_blockcount);
>  
>  	/* Remove the mapping from the CoW fork. */
> -	xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
> +	xfs_bmap_del_extent_cow(ip, &icur, &got, &new);
>  
>  	error = xfs_trans_commit(tp);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> @@ -851,7 +851,7 @@ xfs_reflink_end_cow_extent(
>  		return error;
>  
>  	/* Update the caller about how much progress we made. */
> -	*offset_fsb = del.br_startoff + del.br_blockcount;
> +	*offset_fsb = new.br_startoff + new.br_blockcount;
>  	return 0;
>  
>  out_cancel:
> -- 
> 2.39.2
> 
> 
