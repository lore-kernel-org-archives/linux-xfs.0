Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE8C3264ED;
	Wed,  4 Mar 2026 16:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772642692; cv=none; b=jHTpNvoS9Yg1CVZFT2p7vAidcIBo9/xpCQoyPYl6yPIE8Cnu13QFizuClUuk2MBnSkdUawGTGb/T+fSxK2S2u/acKPXPJOqMio7x+i8WyhvUKB1g12ABJQEw1VJFtOswHoEkEygwqwskyc9HPmnbtC5fg/H/hfblue+qKdU9KW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772642692; c=relaxed/simple;
	bh=Vf8+GXwy4WDgkqG5c/4wsXk5bvhJqcLmTc9tkPR43ic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ANx6dEGnBQUPdqOoPimxeY+nEeRRmu2WVydxRomG1Qbs2CWPzPT3hlJ6V1XR6gUxBm0UaqAU5eky3BtwWWFdsPDAfKadWrx0rWAcNpSqEthuFv3miLF5xbbhT1dGElbav8PwiiPoZltEiSd6smoS5sQFL6KA6+zaGIZPT9WZ13E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T1EEbYId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T1EEbYId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593F5C2BC87;
	Wed,  4 Mar 2026 16:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772642692;
	bh=Vf8+GXwy4WDgkqG5c/4wsXk5bvhJqcLmTc9tkPR43ic=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T1EEbYId27V8IOw8W/10cmXHOkcaUvZ74/qkO32Gc9KHAbb3T3WJgu0bvilBQcblg
	 zCTsH2Yhqyx7yZW/7pz1cbS7p2nnJJw+STm78jwnadZ1Ebrw4zoCcEdX71Msdadj7r
	 J9Oh3D+rcEGc5h0FUR5IVvQ4PVkfEefPhehPUGduGz2CsmydNp7OvDDRxROLGtTZqD
	 pbxSsQD9SmMi45NU0CzULQA7EsGmgdI2uiYiKrMGfDOqmyGtMZHhQDtTWmD9iA/Nj1
	 gi9ZkE/MKg+wz7eGUyOh1ro96cVdWGCCFTBKEN+KRuK4XlMuOHcy3EKkN0/ec+TnXd
	 ANh099+GzqrlA==
Date: Wed, 4 Mar 2026 08:44:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <darrick.wong@oracle.com>,
	Dave Chinner <dchinner@redhat.com>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: fix use-after-free in xfs_inode_item_push()
Message-ID: <20260304164451.GW57948@frogsfrogsfrogs>
References: <20260304162405.58017-2-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304162405.58017-2-ytohnuki@amazon.com>

On Wed, Mar 04, 2026 at 04:24:06PM +0000, Yuto Ohnuki wrote:
> Since commit 90c60e164012 ("xfs: xfs_iflush() is no longer necessary"),
> xfs_inode_item_push() no longer holds the inode locked (ILOCK_SHARED)
> while flushing, so the inode and its log item can be freed via
> RCU callback (xfs_inode_free_callback) while the AIL lock is
> temporarily dropped.
> 
> This results in a use-after-free when the function reacquires the AIL
> lock by dereferencing the freed log item's li_ailp pointer at offset 48.
> 
> Fix this by saving the ailp pointer in a local variable while the AIL
> lock is held and the log item is guaranteed to be valid.
> 
> Also move trace_xfs_ail_push() before xfsaild_push_item() because the
> log item may be freed during the push.
> 
> Reported-by: syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=652af2b3c5569c4ab63c
> Fixes: 90c60e164012 ("xfs: xfs_iflush() is no longer necessary")
> Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>

Cc: <stable@vger.kernel.org> # v5.9

> ---
>  fs/xfs/xfs_inode_item.c | 5 +++--
>  fs/xfs/xfs_trans_ail.c  | 8 +++++++-
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 8913036b8024..0a8957f9c72f 100644
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
> @@ -795,7 +796,7 @@ xfs_inode_item_push(
>  		rval = XFS_ITEM_LOCKED;
>  	}
>  
> -	spin_lock(&lip->li_ailp->ail_lock);
> +	spin_lock(&ailp->ail_lock);

Hmm, so the @lip UAF is here, where we try to re-acquire the AIL lock?

>  	return rval;
>  }
>  
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 923729af4206..e34d8a7e341d 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -510,6 +510,13 @@ xfsaild_push(
>  		if (test_bit(XFS_LI_FLUSHING, &lip->li_flags))
>  			goto next_item;
>  
> +		/*
> +		 * The log item may be freed after the push if the AIL lock is
> +		 * temporarily dropped and the RCU grace period expires,
> +		 * so trace it before pushing.
> +		 */
> +		trace_xfs_ail_push(lip);
> +
>  		/*
>  		 * Note that iop_push may unlock and reacquire the AIL lock.  We
>  		 * rely on the AIL cursor implementation to be able to deal with
> @@ -519,7 +526,6 @@ xfsaild_push(
>  		switch (lock_result) {
>  		case XFS_ITEM_SUCCESS:
>  			XFS_STATS_INC(mp, xs_push_ail_success);
> -			trace_xfs_ail_push(lip);

Do the tracepoints in the other legs of the switch statement have a
similar UAF problem because they dereference @lip?

--D

>  
>  			ailp->ail_last_pushed_lsn = lsn;
>  			break;
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
