Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB85316F917
	for <linux-xfs@vger.kernel.org>; Fri,  5 Apr 2024 15:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712331919; cv=none; b=t99d6jn2WVkp1+SyJSQ+J3EAGnGRrnqGXmosOtoVffxM+XgUHLSWZ13ENSe17l5MF4ZoRHVXksXSCFjACwQzDT2FxMCS7gHNMbelQD7CxCAtJfTDzUMFQpio8UWB/XDnpTTAyxFd9zLYNwbrWFwyLy/P1XPM3eAEPDjGvwSHa00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712331919; c=relaxed/simple;
	bh=L8VmGwN9qPLYak2Y+KCHl9XQ7E+gLZSkOTmLxGssLAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cZb7PmlF07SRL1wVrmFTNdhE1MXFHib95e9mOLYSshgWcd5psYP96h+JLd7hb5g3iwjciRJFMyueediWRD0edk7mvsNJTORxeLw0WHPppejhrr7jdq8mQHlWKtO/By/0f2HR453Jt9JotAGfD7a4BaV2Isrt4zwr9KoXbShSNVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ir+ykwLn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ir+ykwLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4795FC433F1;
	Fri,  5 Apr 2024 15:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712331919;
	bh=L8VmGwN9qPLYak2Y+KCHl9XQ7E+gLZSkOTmLxGssLAA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ir+ykwLnfwRmZ2O8LtZYQZ8iX4WaBN2EB8R5tLTqZyVeq6vWumoPoSyG5jEpbi0Ff
	 ngBdu3gQJvmRLsHNk0KuV9FRtedly44kAjm6X6QvUd+IrHbDa2ZpQFgviWQ0r/FZEi
	 j9Xc2v5WAYLGXbC4PwHTNj5i0z8V3Ehla+Pq6qiXcjcN2jQ6DCxGaEYApEm0/4yH96
	 HeVFiBb4YgjHeM0gngIlF5dQTQ4GeA7vuX64Dnt0YqPI99ioEY9CrMPk2nA2TPID9N
	 +XIOYPDQuyxeA1l/2se4DR5oT8oInsrJK6FcdYIpNIozuhWNjo77+cCtKa7sW4cJlt
	 aH+3k2crxjt3A==
Date: Fri, 5 Apr 2024 08:45:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: unwind xfs_extent_busy_clear
Message-ID: <20240405154518.GA6390@frogsfrogsfrogs>
References: <20240405060710.227096-1-hch@lst.de>
 <20240405060710.227096-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405060710.227096-3-hch@lst.de>

On Fri, Apr 05, 2024 at 08:07:09AM +0200, Christoph Hellwig wrote:
> The current structure of xfs_extent_busy_clear that locks the first busy
> extent in each AG and unlocks when switching to a new AG makes sparse
> unhappy as the lock critical section tracking can't cope with taking the
> lock conditionally and inside a loop.
> 
> Rewrite xfs_extent_busy_clear so that it has an outer loop only advancing
> when moving to a new AG, and an inner loop that consumes busy extents for
> the given AG to make life easier for sparse and to also make this logic
> more obvious to humans.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

That is a lot easier to understand!  Thank you for the cleanup.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_extent_busy.c | 59 +++++++++++++++++-----------------------
>  1 file changed, 25 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 6fbffa46e5e94b..a73e7c73b664c6 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -540,21 +540,6 @@ xfs_extent_busy_clear_one(
>  	return true;
>  }
>  
> -static void
> -xfs_extent_busy_put_pag(
> -	struct xfs_perag	*pag,
> -	bool			wakeup)
> -		__releases(pag->pagb_lock)
> -{
> -	if (wakeup) {
> -		pag->pagb_gen++;
> -		wake_up_all(&pag->pagb_wait);
> -	}
> -
> -	spin_unlock(&pag->pagb_lock);
> -	xfs_perag_put(pag);
> -}
> -
>  /*
>   * Remove all extents on the passed in list from the busy extents tree.
>   * If do_discard is set skip extents that need to be discarded, and mark
> @@ -566,27 +551,33 @@ xfs_extent_busy_clear(
>  	struct list_head	*list,
>  	bool			do_discard)
>  {
> -	struct xfs_extent_busy	*busyp, *n;
> -	struct xfs_perag	*pag = NULL;
> -	xfs_agnumber_t		agno = NULLAGNUMBER;
> -	bool			wakeup = false;
> -
> -	list_for_each_entry_safe(busyp, n, list, list) {
> -		if (busyp->agno != agno) {
> -			if (pag)
> -				xfs_extent_busy_put_pag(pag, wakeup);
> -			agno = busyp->agno;
> -			pag = xfs_perag_get(mp, agno);
> -			spin_lock(&pag->pagb_lock);
> -			wakeup = false;
> -		}
> +	struct xfs_extent_busy	*busyp, *next;
>  
> -		if (xfs_extent_busy_clear_one(pag, busyp, do_discard))
> -			wakeup = true;
> -	}
> +	busyp = list_first_entry_or_null(list, typeof(*busyp), list);
> +	if (!busyp)
> +		return;
> +
> +	do {
> +		bool			wakeup = false;
> +		struct xfs_perag	*pag;
>  
> -	if (pag)
> -		xfs_extent_busy_put_pag(pag, wakeup);
> +		pag = xfs_perag_get(mp, busyp->agno);
> +		spin_lock(&pag->pagb_lock);
> +		do {
> +			next = list_next_entry(busyp, list);
> +			if (xfs_extent_busy_clear_one(pag, busyp, do_discard))
> +				wakeup = true;
> +			busyp = next;
> +		} while (!list_entry_is_head(busyp, list, list) &&
> +			 busyp->agno == pag->pag_agno);
> +
> +		if (wakeup) {
> +			pag->pagb_gen++;
> +			wake_up_all(&pag->pagb_wait);
> +		}
> +		spin_unlock(&pag->pagb_lock);
> +		xfs_perag_put(pag);
> +	} while (!list_entry_is_head(busyp, list, list));
>  }
>  
>  /*
> -- 
> 2.39.2
> 
> 
