Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A135235
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 04:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712117069; cv=none; b=ilvYtc3hSFiGDyQYmmFYqLxG3lj1yau+wKNX30ojaLKGAFgPERYdYpPLwhUzzBRyxAP5y+nCYfEVgnWzYyr3QVO3ouHGHVorBdeBIrflozFt0CRklLbEJ53jISAyzm9qKdZSDrBCH1hbYw+EBXVq8qv6R1VJcMxK+UPk6Jlfut4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712117069; c=relaxed/simple;
	bh=Cn/MdfuisCtf5kSYESNUJNiIgo8+upo2DhttIWGAuHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vxdv8Y8/11ceHOEYPfV6pqYVNDE7UL6h3VGfJ71PohnNef8oh74KIlcVvgNq3h1c46ZwLx2Y0+Q7wxyXjJGV0FHFvs66bQwY0i4ad08dbfkAfuM2fWS79J2dTwWDPmanBG1qlfeJA9SLKeGX4u94L8YxfPNPw+Z4+DkbT24a7oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MSiGyWRz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MSiGyWRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F3DC433F1;
	Wed,  3 Apr 2024 04:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712117069;
	bh=Cn/MdfuisCtf5kSYESNUJNiIgo8+upo2DhttIWGAuHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MSiGyWRzWyDWRvGLUAahLnYpyDISD9QxfMRKA9qTsrsnlwiWvKD8B3wWqs3lEBLYr
	 iwsUOsYLfLF+XZGAM2qLr6Q9rHM/Bsz1btGpQs7FtgRwZr4SKJ3GiS0BzDlnhXVfTx
	 msSIg7V5etCq7c3ISLJg69hWCf7Sw6mExXUuSN4d0BaA+vc0SpKMpmgR7oiSNpTwmy
	 /FbeDv/axZ7kcnqlFAskPf4s9QoYNqP609pd7eekgs7+zBK+YKEz/zw6W/q5nmyrnQ
	 d0NbLfW3Xleoa22VLPkOXmZJ8EtH1UbQzY7chjD7dEN5cSKoMc+4ebe5ATCGawZzxA
	 mG4quln1cQejQ==
Date: Tue, 2 Apr 2024 21:04:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: fix sparse warning in xfs_extent_busy_clear
Message-ID: <20240403040428.GP6390@frogsfrogsfrogs>
References: <20240402213541.1199959-1-david@fromorbit.com>
 <20240402213541.1199959-3-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402213541.1199959-3-david@fromorbit.com>

On Wed, Apr 03, 2024 at 08:28:29AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Sparse reports:
> 
> fs/xfs/xfs_extent_busy.c:588:17: warning: context imbalance in 'xfs_extent_busy_clear' - unexpected unlock
> 
> But there is no locking bug here. Sparse simply doesn't understand
> the logic and locking in the busy extent processing loop.
> xfs_extent_busy_put_pag() has an annotation to suppresses an
> unexpected unlock warning, but that isn't sufficient.
> 
> If we move the pag existence check into xfs_extent_busy_put_pag() and
> annotate that with a __release() so that this function always
> appears to release the pag->pagb_lock, sparse now thinks the loop
> locking is balanced (one unlock, one lock per loop) but still throws
> an unexpected unlock warning after loop cleanup.
> 
> i.e. it does not understand that we enter the loop without any locks
> held and exit it with the last lock still held. Whilst the locking
> within the loop is inow balanced, we need to add an __acquire() to
> xfs_extent_busy_clear() to set the initial lock context needed to
> avoid false warnings.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_extent_busy.c | 27 +++++++++++++++++++++++----
>  1 file changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 56cfa1498571..686b67372030 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -534,12 +534,24 @@ xfs_extent_busy_clear_one(
>  	kfree(busyp);
>  }
>  
> +/*
> + * Sparse has real trouble with the structure of xfs_extent_busy_clear() and it
> + * is impossible to annotate it correctly if we leave the 'if (pag)' conditional
> + * in xfs_extent_busy_clear(). Hence we always "release" the lock in
> + * xfs_extent_busy_put_pag() so sparse only ever sees one possible path to
> + * drop the lock.
> + */
>  static void
>  xfs_extent_busy_put_pag(
>  	struct xfs_perag	*pag,
>  	bool			wakeup)
>  		__releases(pag->pagb_lock)
>  {
> +	if (!pag) {
> +		__release(pag->pagb_lock);
> +		return;
> +	}

Passing in a null pointer so we can fake out a compliance tool with a
nonsense annotation really feels like the height of software bureaucracy
compliance culture now...

I don't want to RVB this but I'm so tired of fighting pointless battles
with people over their clearly inadequate tooling, so GIGO:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +
>  	if (wakeup) {
>  		pag->pagb_gen++;
>  		wake_up_all(&pag->pagb_wait);
> @@ -565,10 +577,18 @@ xfs_extent_busy_clear(
>  	xfs_agnumber_t		agno = NULLAGNUMBER;
>  	bool			wakeup = false;
>  
> +	/*
> +	 * Sparse thinks the locking in the loop below is balanced (one unlock,
> +	 * one lock per loop iteration) and doesn't understand that we enter
> +	 * with no lock held and exit with a lock held. Hence we need to
> +	 * "acquire" the lock to create the correct initial condition for the
> +	 * cleanup after loop termination to avoid an unexpected unlock warning.
> +	 */
> +	__acquire(pag->pagb_lock);
> +
>  	list_for_each_entry_safe(busyp, n, list, list) {
>  		if (busyp->agno != agno) {
> -			if (pag)
> -				xfs_extent_busy_put_pag(pag, wakeup);
> +			xfs_extent_busy_put_pag(pag, wakeup);
>  			agno = busyp->agno;
>  			pag = xfs_perag_get(mp, agno);
>  			spin_lock(&pag->pagb_lock);
> @@ -584,8 +604,7 @@ xfs_extent_busy_clear(
>  		}
>  	}
>  
> -	if (pag)
> -		xfs_extent_busy_put_pag(pag, wakeup);
> +	xfs_extent_busy_put_pag(pag, wakeup);
>  }
>  
>  /*
> -- 
> 2.43.0
> 
> 
