Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E864A0F13;
	Fri, 11 Sep 2026 17:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789148571; cv=none; b=fUSSMI9wBcSj+qLWEFsLMWUMiLf2Khw8M4VhAuCQYG5jyaE1a8s0Lbf6DqG0miyXxOyaf0E1Wf4e/L136kqNUEuljl0SAPh+zThQ1TuIrT9AfCluG4Del+m4p0jZHzADmCJ6OqfyF9J7sVlH3wJYynFtqtC+CD/uXEGmmf3pRaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789148571; c=relaxed/simple;
	bh=+j6N2ru0WJf8d04Uzu76W9zwWyzxh+qgzW54PAWNOLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cC24FLJmiVBpjzcHAOFWjuu9PevfRPa6CDwRt5yNNeOmIRf2gEAtLNxHvbIIH7336P1Z7gtY+S9VIwf5adZJ7j1F2DPVQNT2S83QAifOsm3JDhImGXSMzUyWwAMVCBUJwn13viX1sBrD4b5isI3TCcMVfVUMhH5fV0SLQ+4h6fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bjoaFtOe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bjoaFtOe"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 79A631F00893;
	Fri, 11 Sep 2026 17:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789148568;
	bh=bTgLdHEJd4F/ATN9FDiyzCsrpd5bhCioRy3qnyPw6+Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bjoaFtOeh0Alkrj1/viQqa/yDUG/V9N77rEyDKcLbqbSBxA459UtYVZRyWr0ukWyb
	 WWHUWuPk1R4gB/5XDjDEbiXo8Z3RNRz6sk4BCXDpNQk50unB+H3ZsBq6l29cEtCx1S
	 JgcR/81M1qp4hxSEXASdHRRxHUuAVu0mff/wRowVHtSDCZVFWekFuHsQ4k8L6n3TXm
	 nq59mPsUXqQf4/uP3GQCfsSUb9AzuTzBZpqmAgBpw2F/WSzns3uSj/vymYOund4HH2
	 vJ059E/8eAAVuprzkR/nB12IEMLFgBSSmS6FrJh2m6fiGzNn7ei9jt6WGyE85mbfa3
	 L3yHkmTMcyyfQ==
Date: Fri, 11 Sep 2026 10:42:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] xfs: don't hold buffer locks across sync transaction
 commit in xfs_sync_sb_buf
Message-ID: <20260911174247.GK6265@frogsfrogsfrogs>
References: <20260731031010.2627884-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731031010.2627884-1-yun.zhou@windriver.com>

On Fri, Jul 31, 2026 at 11:10:10AM +0800, Yun Zhou wrote:
> xfs_sync_sb_buf() holds sb/rtsb buffer locks across a synchronous
> xfs_trans_commit(), which flushes the CIL push workqueue internally.
> If shutdown occurs during the CIL push, xfs_buf_item_unpin() needs to
> lock these buffers to fail them, causing a deadlock:
> 
>   setlabel:          holds buf lock -> flush_workqueue(xfs-cil)
>   CIL push worker:   xfs_buf_item_unpin -> xfs_buf_lock(same buf)
> 
> Remove the xfs_trans_bhold() calls so that commit releases the buffer
> locks normally.  After the sync commit, re-acquire the buffers via
> mp->m_sb_bp / mp->m_rtsb_bp for the on-disk writeback.
> 
> Fixes: f7664b31975b ("xfs: implement online get/set fs label")
> Reported-by: syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
> Cc: stable@vger.kernel.org
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
> v3:
>  - Drop xfs_buf_hold/xfs_buf_relse, use lock/unlock directly (Christoph).
> 
> v2:
>  - Remove the bp variable and pass xfs_trans_getsb(tp) directly to
>    xfs_log_rtsb() to fix compilation warnings when CONFIG_XFS_RT=n.
>  - Convert xfs_log_rtsb() stub from macro to inline function to avoid
>    the need for (void) casting (Christoph).
> ---
>  fs/xfs/libxfs/xfs_rtgroup.h |  6 +++++-
>  fs/xfs/libxfs/xfs_sb.c      | 37 +++++++++++++++++--------------------
>  2 files changed, 22 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
> index c0b9f9f2c413..fca2eb74908c 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.h
> +++ b/fs/xfs/libxfs/xfs_rtgroup.h
> @@ -359,7 +359,11 @@ static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
>  # define xfs_rtgroup_unlock(rtg, gf)		((void)0)
>  # define xfs_rtgroup_trans_join(tp, rtg, gf)	((void)0)
>  # define xfs_update_rtsb(bp, sb_bp)	((void)0)
> -# define xfs_log_rtsb(tp, sb_bp)	(NULL)
> +static inline struct xfs_buf *xfs_log_rtsb(struct xfs_trans *tp,
> +		const struct xfs_buf *sb_bp)
> +{
> +	return NULL;
> +}
>  # define xfs_rtgroup_get_geometry(rtg, rgeo)	(-EOPNOTSUPP)
>  #endif /* CONFIG_XFS_RT */
>  
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 47322adb7690..2664728f2d8f 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1470,36 +1470,33 @@ xfs_sync_sb_buf(
>  	bool			update_rtsb)
>  {
>  	struct xfs_trans	*tp;
> -	struct xfs_buf		*bp;
> -	struct xfs_buf		*rtsb_bp = NULL;
>  	int			error;
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
>  	if (error)
>  		return error;
>  
> -	bp = xfs_trans_getsb(tp);
>  	xfs_log_sb(tp);
> -	xfs_trans_bhold(tp, bp);
> -	if (update_rtsb) {
> -		rtsb_bp = xfs_log_rtsb(tp, bp);
> -		if (rtsb_bp)
> -			xfs_trans_bhold(tp, rtsb_bp);
> -	}
> +	if (update_rtsb)
> +		xfs_log_rtsb(tp, xfs_trans_getsb(tp));
>  	xfs_trans_set_sync(tp);
>  	error = xfs_trans_commit(tp);
>  	if (error)
> -		goto out;
> -	/*
> -	 * write out the sb buffer to get the changes to disk
> -	 */
> -	error = xfs_bwrite(bp);
> -	if (!error && rtsb_bp)
> -		error = xfs_bwrite(rtsb_bp);
> -out:
> -	if (rtsb_bp)
> -		xfs_buf_relse(rtsb_bp);
> -	xfs_buf_relse(bp);
> +		return error;
> +
> +	/* Re-acquire and write the sb and rtsb to disk. */
> +	xfs_buf_lock(mp->m_sb_bp);

FYI, this causes porting problems to xfsprogs' libxfs because userspace
doesn't have m_sb_bp or m_rtsb_bp pointers in struct xfs_mount.  It's
not a big deal to add them, but if anyone ever wants to call
xfs_sync_sb_buf then we're going to have to figure out when to populate
those pointers.

--D

> +	error = xfs_bwrite(mp->m_sb_bp);
> +	xfs_buf_unlock(mp->m_sb_bp);
> +	if (error)
> +		return error;
> +
> +	if (update_rtsb && mp->m_rtsb_bp) {
> +		xfs_buf_lock(mp->m_rtsb_bp);
> +		error = xfs_bwrite(mp->m_rtsb_bp);
> +		xfs_buf_unlock(mp->m_rtsb_bp);
> +	}
> +
>  	return error;
>  }
>  
> -- 
> 2.43.0
> 
> 
