Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3227B219E5F
	for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 23:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731453341; cv=none; b=K7LYJ8FdICKrG5+6ozWjCnK5Fp2NBmpc3F/2oRG8fec+8pmYtqNd62ZCeBNz5voDy7kVY0FXkc6mQmaOoLhMKwoDU5z5GYhJSB2LD08qxLW40wWmFudFsAaQm83f69dCwzYYwPvsbV4srlX2SGyRJLLDRwL2FZILM93crVJRv0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731453341; c=relaxed/simple;
	bh=b93U+WU1dZglHZzoeUd8f9/nLm7jbGUrRx/P7XzS7ds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ed6YhfJHC83PjV3tScUkOsZE2D52qb4HqgBhwHQSQT2QRDqr0YOrv6/n+grU3fmMoxNwc9WIoZ031PIW56/4qYO08I0P4YIE0xXfdnTr+PUMpuUOrq03W/NO2KOKEQ2fy60cD0tcL16HPsAJTY0rXLhYgEb3SolB37aGU6Ld5+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pHmgKwQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pHmgKwQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F58C4CED6;
	Tue, 12 Nov 2024 23:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731453340;
	bh=b93U+WU1dZglHZzoeUd8f9/nLm7jbGUrRx/P7XzS7ds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pHmgKwQcpNL93JIh2PATyJNjbirFC9ULA9c9+J8PZReOyn3YwnV1XQlKqlUJj7EDb
	 S8wx9PEN7McAqq42LZOblWs0R4tmA7fXjEEJUHDFYs8JlDDXOu4ULFsesAUWrrTT1h
	 9ewncwMqhDKYoZvn9UI2EKgLXWhrTuwo4F38RjJLVa46s1PkGO+DdBXyc1FmO8VaSS
	 Bx6Tr6zO/oSUacf4ZxRJ83LZzR8odhwXBfVjYYJy5x3vY05vzyKj+N24Yk6xuzmtQH
	 og2kvmohH9wf3iYfGx7qtvFi6f0UaMHhgusYD9uyIYuHRoR+JevDZeUTJJtTnnW1Pg
	 3kJEyPIUPRQlw==
Date: Tue, 12 Nov 2024 15:15:39 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 1/3] xfs: fix sparse inode limits on runt AG
Message-ID: <20241112231539.GG9438@frogsfrogsfrogs>
References: <20241112221920.1105007-1-david@fromorbit.com>
 <20241112221920.1105007-2-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241112221920.1105007-2-david@fromorbit.com>

On Wed, Nov 13, 2024 at 09:05:14AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The runt AG at the end of a filesystem is almost always smaller than
> the mp->m_sb.sb_agblocks. Unfortunately, when setting the max_agbno
> limit for the inode chunk allocation, we do not take this into
> account. This means we can allocate a sparse inode chunk that
> overlaps beyond the end of an AG. When we go to allocate an inode
> from that sparse chunk, the irec fails validation because the
> agbno of the start of the irec is beyond valid limits for the runt
> AG.
> 
> Prevent this from happening by taking into account the size of the
> runt AG when allocating inode chunks. Also convert the various
> checks for valid inode chunk agbnos to use xfs_ag_block_count()
> so that they will also catch such issues in the future.
> 
> Fixes: 56d1115c9bc7 ("xfs: allocate sparse inode chunks on full chunk allocation failure")

Cc: <stable@vger.kernel.org> # v4.2

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 271855227514..6258527315f2 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -855,7 +855,8 @@ xfs_ialloc_ag_alloc(
>  		 * the end of the AG.
>  		 */
>  		args.min_agbno = args.mp->m_sb.sb_inoalignmt;
> -		args.max_agbno = round_down(args.mp->m_sb.sb_agblocks,
> +		args.max_agbno = round_down(xfs_ag_block_count(args.mp,
> +							pag->pag_agno),

So if I'm reading this right, the inode cluster allocation checks now
enforce that we cannot search for free space beyond the actual end of
the AG, rounded down per inode alignment rules?

In that case, can this use the cached ag block count:

		args.max_agbno = round_down(
					pag_group(pag)->xg_block_count,
					args.mp->m_sb.sb_inoalignmt);

rather than recomputing the block count every time?

>  					    args.mp->m_sb.sb_inoalignmt) -
>  				 igeo->ialloc_blks;
>  
> @@ -2332,9 +2333,9 @@ xfs_difree(
>  		return -EINVAL;
>  	}
>  	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
> -	if (agbno >= mp->m_sb.sb_agblocks)  {
> -		xfs_warn(mp, "%s: agbno >= mp->m_sb.sb_agblocks (%d >= %d).",
> -			__func__, agbno, mp->m_sb.sb_agblocks);
> +	if (agbno >= xfs_ag_block_count(mp, pag->pag_agno)) {
> +		xfs_warn(mp, "%s: agbno >= xfs_ag_block_count (%d >= %d).",
> +			__func__, agbno, xfs_ag_block_count(mp, pag->pag_agno));

and everywhere else too?

(The logic itself looks ok)

--D

>  		ASSERT(0);
>  		return -EINVAL;
>  	}
> @@ -2457,7 +2458,7 @@ xfs_imap(
>  	 */
>  	agino = XFS_INO_TO_AGINO(mp, ino);
>  	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
> -	if (agbno >= mp->m_sb.sb_agblocks ||
> +	if (agbno >= xfs_ag_block_count(mp, pag->pag_agno) ||
>  	    ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino)) {
>  		error = -EINVAL;
>  #ifdef DEBUG
> @@ -2467,11 +2468,12 @@ xfs_imap(
>  		 */
>  		if (flags & XFS_IGET_UNTRUSTED)
>  			return error;
> -		if (agbno >= mp->m_sb.sb_agblocks) {
> +		if (agbno >= xfs_ag_block_count(mp, pag->pag_agno)) {
>  			xfs_alert(mp,
>  		"%s: agbno (0x%llx) >= mp->m_sb.sb_agblocks (0x%lx)",
>  				__func__, (unsigned long long)agbno,
> -				(unsigned long)mp->m_sb.sb_agblocks);
> +				(unsigned long)xfs_ag_block_count(mp,
> +							pag->pag_agno));
>  		}
>  		if (ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino)) {
>  			xfs_alert(mp,
> -- 
> 2.45.2
> 
> 
