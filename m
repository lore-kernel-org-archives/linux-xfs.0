Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834DB3ED5CA;
	Mon,  9 Mar 2026 16:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773073734; cv=none; b=WiXJTwemdpbIRTDfKMaL8sADWihw0qsK8RKV9oFmFZ1/dSb47PjrUt5owIfUqxQzZ1EXSa7upFItq7dXI8PM7jO5qUBSoHL/FV68iCcSx+1wB6ZdFV+u1wTTR3+e4Wwf5GeRbqm4SiK/m0QXocO1463ffx4BwINrb31dp8rH+w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773073734; c=relaxed/simple;
	bh=m9XIqz8vt2UZWr/s5rpEvKJu90xWKh2fGhh3m+fUaQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aYEWUJKicVbUN7ML0AkAt3MHU7ItK6B5Egvx6l+9tFC5CrIV/2pV4G0h5LhZ2+Fly3lkkwA6XQX8R7bq88bqxFqOk17UrOCyIlNLDtA8xBik7XvRXgpARg3ufmxoo30ES/vGM6PZy/84DI/d5Lu49xOXF09G/6zewQUcJiAzvl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rcs247rZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rcs247rZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BFE1C4CEF7;
	Mon,  9 Mar 2026 16:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773073734;
	bh=m9XIqz8vt2UZWr/s5rpEvKJu90xWKh2fGhh3m+fUaQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rcs247rZ00S2EGHK6ODiBxMPJ9J4glUz1aF+AKXtnUH3RGrCXVrMbiU7kr9ZEIIl7
	 85JwTCo+mq6t8IoFahVXjWS1wo5HtdCKu5oobdREXgIu8ZstUyEVpRdfQr6R7BN8di
	 DGia8mQ30OSuoKGcic//mrQCcjQ6a4YFOhtzhLd9T4Gdgfg0ou27cGgNf9C1i/2OkB
	 OckVKxDN6SZQB8d5/VsvRU8w/hp0f9K+MefLgD5FEJUekDCeAMrM6zUbnjU8VcaUdb
	 /xGEMoBfOpq2WsFbSyJFi887Cfihz5xIcFZXoPU/0buKevEUjEeXnyMIMtqMvI4c5C
	 xSx1oTCEg9KLg==
Date: Mon, 9 Mar 2026 09:28:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <darrick.wong@oracle.com>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 4/4] xfs: save ailp before dropping the AIL lock in
 push callbacks
Message-ID: <20260309162853.GD6033@frogsfrogsfrogs>
References: <20260308182804.33127-6-ytohnuki@amazon.com>
 <20260308182804.33127-10-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260308182804.33127-10-ytohnuki@amazon.com>

On Sun, Mar 08, 2026 at 06:28:09PM +0000, Yuto Ohnuki wrote:
> In xfs_inode_item_push() and xfs_qm_dquot_logitem_push(), the AIL lock
> is dropped to perform buffer IO. Once the cluster buffer no longer
> protects the log item from reclaim, the log item may be freed by
> background reclaim or the dquot shrinker. The subsequent spin_lock()
> call dereferences lip->li_ailp, which is a use-after-free.
> 
> Fix this by saving the ailp pointer in a local variable while the AIL
> lock is held and the log item is guaranteed to be valid.
> 
> Reported-by: syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=652af2b3c5569c4ab63c
> Fixes: 90c60e164012 ("xfs: xfs_iflush() is no longer necessary")
> Cc: <stable@vger.kernel.org> # v5.9
> Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>

Looks fine to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_dquot_item.c | 9 +++++++--
>  fs/xfs/xfs_inode_item.c | 9 +++++++--
>  2 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index 491e2a7053a3..65a0e69c3d08 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -125,6 +125,7 @@ xfs_qm_dquot_logitem_push(
>  	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
>  	struct xfs_dquot	*dqp = qlip->qli_dquot;
>  	struct xfs_buf		*bp;
> +	struct xfs_ail		*ailp = lip->li_ailp;
>  	uint			rval = XFS_ITEM_SUCCESS;
>  	int			error;
>  
> @@ -153,7 +154,7 @@ xfs_qm_dquot_logitem_push(
>  		goto out_unlock;
>  	}
>  
> -	spin_unlock(&lip->li_ailp->ail_lock);
> +	spin_unlock(&ailp->ail_lock);
>  
>  	error = xfs_dquot_use_attached_buf(dqp, &bp);
>  	if (error == -EAGAIN) {
> @@ -172,9 +173,13 @@ xfs_qm_dquot_logitem_push(
>  			rval = XFS_ITEM_FLUSHING;
>  	}
>  	xfs_buf_relse(bp);
> +	/*
> +	 * The buffer no longer protects the log item from reclaim, so
> +	 * do not reference lip after this point.
> +	 */
>  
>  out_relock_ail:
> -	spin_lock(&lip->li_ailp->ail_lock);
> +	spin_lock(&ailp->ail_lock);
>  out_unlock:
>  	mutex_unlock(&dqp->q_qlock);
>  	return rval;
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 8913036b8024..4ae81eed0442 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -746,6 +746,7 @@ xfs_inode_item_push(
>  	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
>  	struct xfs_inode	*ip = iip->ili_inode;
>  	struct xfs_buf		*bp = lip->li_buf;
> +	struct xfs_ail		*ailp = lip->li_ailp;
>  	uint			rval = XFS_ITEM_SUCCESS;
>  	int			error;
>  
> @@ -771,7 +772,7 @@ xfs_inode_item_push(
>  	if (!xfs_buf_trylock(bp))
>  		return XFS_ITEM_LOCKED;
>  
> -	spin_unlock(&lip->li_ailp->ail_lock);
> +	spin_unlock(&ailp->ail_lock);
>  
>  	/*
>  	 * We need to hold a reference for flushing the cluster buffer as it may
> @@ -795,7 +796,11 @@ xfs_inode_item_push(
>  		rval = XFS_ITEM_LOCKED;
>  	}
>  
> -	spin_lock(&lip->li_ailp->ail_lock);
> +	/*
> +	 * The buffer no longer protects the log item from reclaim, so
> +	 * do not reference lip after this point.
> +	 */
> +	spin_lock(&ailp->ail_lock);
>  	return rval;
>  }
>  
> -- 
> 2.50.1
> 
> 
> 
> 
> Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284
> 
> Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705
> 
> 
> 
> 
