Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAA24C79
	for <linux-xfs@vger.kernel.org>; Thu,  1 May 2025 04:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746074256; cv=none; b=Wk7jDflcH8kQsdYq0QFsM3Vd4NVKt7BKOwzMKVaE9UE98ScGtj12gsunMTKJSfvuBMAJjGdsMxjiIXUSkZ+MYmLEnY0P7xdD4fStDL0lZLRlbZWC/UxLrJyfn4KzW+CQTFnFRz9YOIjaX06pQ+1qeaCWom+ypRQNKgbKz6l+6VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746074256; c=relaxed/simple;
	bh=8+9Qe3aJMyMy0Q3Mf5LN+xjlLRjyqSUE88m1zGaUxoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sIs/XOs8Q2NXDz9RjagI86DZcHfIla75rQp9cWGvLWnqBtoM3LhHicL4KvJJygkkxe55ptUTB8LoUGaJHRhACGAo1zjfPDrDLK0K7vivJNRocKvhN/1OrUM6IEmwk2ecbwJ4+ETLUthCmWD73bc0WqbEB4lrfl4qp9R56giAehM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s3GzplBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s3GzplBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF73C4CEE3;
	Thu,  1 May 2025 04:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746074255;
	bh=8+9Qe3aJMyMy0Q3Mf5LN+xjlLRjyqSUE88m1zGaUxoU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s3GzplBkEaeYaG9v71pdVZEy1Z5B95n8mUFSelVmtEA1Iq7M5Ie1HgzZ4SIeWoycT
	 BJWafESghKQtL2boB86y2C8b765yW1fCKNXOCKzW4Fe7W0hMf8qDEjbBUVezufYXAa
	 aa/PSclh52MhIyPY4Z3NkY1lvxVspGqSAy2A/1mUzWUIbdGId6+vuqFPIBGISpfR8Q
	 7YkcNoZ/gPR+jDr0/pKvUPr3jnKjIJcp57UksNhGP1CFe9soVkIyP4X9RP3JSnt7Qx
	 gK7j+YX+7tEHF9gs8sso8aowuhvxYALaiECF+GQI9m4iOMOha/+O4h8pXepXblMyQ5
	 gDRIGYBIrhuMw==
Date: Wed, 30 Apr 2025 21:37:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't assume perags are initialised when trimming
 AGs
Message-ID: <20250501043735.GZ25675@frogsfrogsfrogs>
References: <20250430232724.475092-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430232724.475092-1-david@fromorbit.com>

On Thu, May 01, 2025 at 09:27:24AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When running fstrim immediately after mounting a V4 filesystem,
> the fstrim fails to trim all the free space in the filesystem. It
> only trims the first extent in the by-size free space tree in each
> AG and then returns. If a second fstrim is then run, it runs
> correctly and the entire free space in the filesystem is iterated
> and discarded correctly.
> 
> The problem lies in the setup of the trim cursor - it assumes that
> pag->pagf_longest is valid without either reading the AGF first or
> checking if xfs_perag_initialised_agf(pag) is true or not.
> 
> As a result, when a filesystem is mounted without reading the AGF
> (e.g. a clean mount on a v4 filesystem) and the first operation is a
> fstrim call, pag->pagf_longest is zero and so the free extent search
> starts at the wrong end of the by-size btree and exits after
> discarding the first record in the tree.
> 
> Fix this by deferring the initialisation of tcur->count to after
> we have locked the AGF and guaranteed that the perag is properly
> initialised. We trigger this on tcur->count == 0 after locking the
> AGF, as this will only occur on the first call to
> xfs_trim_gather_extents() for each AG. If we need to iterate,
> tcur->count will be set to the length of the record we need to
> restart at, so we can use this to ensure we only sample a valid
> pag->pagf_longest value for the iteration.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Makes sense to me.  Please add the following trailers on merge:

Cc: <stable@vger.kernel.org> # v6.10
Fixes: b0ffe661fab4b9 ("xfs: fix performance problems when fstrimming a subset of a fragmented AG")

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_discard.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index c1a306268ae4..94d0873bcd62 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -167,6 +167,14 @@ xfs_discard_extents(
>  	return error;
>  }
>  
> +/*
> + * Care must be taken setting up the trim cursor as the perags may not have been
> + * initialised when the cursor is initialised. e.g. a clean mount which hasn't
> + * read in AGFs and the first operation run on the mounted fs is a trim. This
> + * can result in perag fields that aren't initialised until
> + * xfs_trim_gather_extents() calls xfs_alloc_read_agf() to lock down the AG for
> + * the free space search.
> + */
>  struct xfs_trim_cur {
>  	xfs_agblock_t	start;
>  	xfs_extlen_t	count;
> @@ -204,6 +212,14 @@ xfs_trim_gather_extents(
>  	if (error)
>  		goto out_trans_cancel;
>  
> +	/*
> +	 * First time through tcur->count will not have been initialised as
> +	 * pag->pagf_longest is not guaranteed to be valid before we read
> +	 * the AGF buffer above.
> +	 */
> +	if (!tcur->count)
> +		tcur->count = pag->pagf_longest;
> +
>  	if (tcur->by_bno) {
>  		/* sub-AG discard request always starts at tcur->start */
>  		cur = xfs_bnobt_init_cursor(mp, tp, agbp, pag);
> @@ -350,7 +366,6 @@ xfs_trim_perag_extents(
>  {
>  	struct xfs_trim_cur	tcur = {
>  		.start		= start,
> -		.count		= pag->pagf_longest,
>  		.end		= end,
>  		.minlen		= minlen,
>  	};
> -- 
> 2.45.2
> 
> 
