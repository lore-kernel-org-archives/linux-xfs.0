Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A626918C908
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 17:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724433639; cv=none; b=AlvUoiLCRL7H0irRWGcCKCk49xQ2NhRo+SMMvXF0GWgbR1Or/IFDR+xPhiJstNhty+qEzcmWaLFPsERwrDu+bz+gFsV46dWE+ytqeAaOwhVYfK5SljQ/vrZLC1ECctnm8i2dqf7F9X3FaagY+wpoJsBwOotgLmxpxTw+xAk/1G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724433639; c=relaxed/simple;
	bh=D5YmsNVdl0kn3AypqacEUtr6EqsmB3cQu+aQVSelLVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TC7Uta5krJyK6Mp04rEqBrqPXVuolyjAPaED8GipqXzj6hidC5AQ6hmqYlEXtqMIGJ3Rm9JFHc7yq8ePGUeC9BgoQD+iS24UN9aapxTmrBdqeM5kkVR7kmnZ3wksf75F0n34/n8g/i5UwvDqk31hr5y6fJMyZlAe7U/5JuDNbTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TbToqDGL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TbToqDGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D316C32786;
	Fri, 23 Aug 2024 17:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724433639;
	bh=D5YmsNVdl0kn3AypqacEUtr6EqsmB3cQu+aQVSelLVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TbToqDGLkeSsRWCnu1ZR1xbE6HQcAw9KHNpSu/mSX5RcNPZ0uqVvuXIBUEO66je++
	 H8j9sB95PiiZNcR+Iib8dh2ZvzdaXkXHZv+5/rPiDfys+6ikiuP2wJXN8grJFoXC02
	 ac/dA8J6g5LJyEpEGDlVnE4vUc1KH6s1KEzZWXV7xrm820ZwewqucNJ1kzR2Y0qQKM
	 glgK0LLlKmCuzTwtFm3bktFN4QEsCvLLmaK6dc4dGiw8w9+Tl087tehbC1FeGYpgsi
	 9hNJjlO27v8gRf6mHqPjWH4C9QbK+ZWTdFma6ckU6/Pz7sBWzsv8uFmMG5+Ulrfa5Z
	 7w2Rm3i699rtw==
Date: Fri, 23 Aug 2024 10:20:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 4/5] xfs: fix a UAF when dquot item push
Message-ID: <20240823172038.GH865349@frogsfrogsfrogs>
References: <20240823110439.1585041-1-leo.lilong@huawei.com>
 <20240823110439.1585041-5-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823110439.1585041-5-leo.lilong@huawei.com>

On Fri, Aug 23, 2024 at 07:04:38PM +0800, Long Li wrote:
> If errors are encountered while pushing a dquot log item, the dquot dirty
> flag is cleared. Without the protection of dqlock and dqflock locks, the
> dquot reclaim thread may free the dquot. Accessing the log item in xfsaild
> after this can trigger a UAF.
> 
>   CPU0                              CPU1
>   push item                         reclaim dquot
>   -----------------------           -----------------------
>   xfsaild_push_item
>     xfs_qm_dquot_logitem_push(lip)
>       xfs_dqlock_nowait(dqp)
>       xfs_dqflock_nowait(dqp)
>       spin_unlock(&lip->li_ailp->ail_lock)
>       xfs_qm_dqflush(dqp, &bp)
>                        <encountered some errors>
>         xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE)
>         dqp->q_flags &= ~XFS_DQFLAG_DIRTY
>                        <dquot is not diry>
>         xfs_trans_ail_delete(lip, 0)
>         xfs_dqfunlock(dqp)
>       spin_lock(&lip->li_ailp->ail_lock)
>       xfs_dqunlock(dqp)
>                                     xfs_qm_shrink_scan
>                                       list_lru_shrink_walk
>                                         xfs_qm_dquot_isolate
>                                           xfs_dqlock_nowait(dqp)
>                                           xfs_dqfunlock(dqp)
>                                           //dquot is clean, not flush it
>                                           xfs_dqfunlock(dqp)
>                                           dqp->q_flags |= XFS_DQFLAG_FREEING
>                                           xfs_dqunlock(dqp)
>                                           //add dquot to dispose list
>                                       //free dquot in dispose list
>                                       xfs_qm_dqfree_one(dqp)
>   trace_xfs_ail_xxx(lip)  //UAF
> 
> Fix this by returning XFS_ITEM_UNSAFE in xfs_qm_dquot_logitem_push() when
> dquot flush encounters errors (excluding EAGAIN error), ensuring xfsaild
> does not access the log item after it is pushed.
> 
> Fixes: 9e4c109ac822 ("xfs: add AIL pushing tracepoints")
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/xfs_dquot_item.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index 7d19091215b0..afc7ad91ddef 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -160,8 +160,16 @@ xfs_qm_dquot_logitem_push(
>  		if (!xfs_buf_delwri_queue(bp, buffer_list))
>  			rval = XFS_ITEM_FLUSHING;
>  		xfs_buf_relse(bp);
> -	} else if (error == -EAGAIN)
> +	} else if (error == -EAGAIN) {
>  		rval = XFS_ITEM_LOCKED;
> +	} else {
> +		/*
> +		 * The dirty flag has been cleared; the dquot may be reclaimed
> +		 * after unlock. It's unsafe to access the item after it has
> +		 * been pushed.
> +		 */
> +		rval = XFS_ITEM_UNSAFE;
> +	}
>  
>  	spin_lock(&lip->li_ailp->ail_lock);

Um, didn't we just establish that lip could have been freed?  Why is it
safe to continue accessing the AIL through the lip here?

--D

>  out_unlock:
> -- 
> 2.39.2
> 
> 
