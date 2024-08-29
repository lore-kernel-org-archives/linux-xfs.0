Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43AE4D108
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 21:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724966362; cv=none; b=ToWoelxEuewVaZTU35HkaSjYLWK7XUt8W3ClWIoUKCIwhbFFPidCXzBmZODUN5zDJ5GPxyHuiVYv+vHhLijY868jbj7+aIXFOUVol08CCDIf451VwjVPvMj/aajQ3UNJLm8WmaZuaXOiqrOiaHqkI/TLMrs1qmf3nLJhOL3gJMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724966362; c=relaxed/simple;
	bh=umMZJfmtOAhyyAGOZwwNOVYrs0Z0sbgQ58uLdugT9Ek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d1tF/g+ypwA1imHmHrvy5dwGXNg+lOpshrzW89ggMamb1MIxLAvCeSRyg1Mscld6a8O/q5Rh/4C/k4A+OyP1ucqkHKZkiXCjZxlcKeFGcwXhrREIJs2YxmclCwydXfeG326D0rzU9YYysOgN4w4Yo4CArr9qbHPl61Rxkfv0o3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qSQpkodF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qSQpkodF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6591FC4CEC1;
	Thu, 29 Aug 2024 21:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724966361;
	bh=umMZJfmtOAhyyAGOZwwNOVYrs0Z0sbgQ58uLdugT9Ek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qSQpkodF6gp3yepGb3RaExBpYXxm6H1v4tkQmLGysTHAbEsoKWOlHYeGjqlOkvPCr
	 F9hbyT4ypWzykgiRa0uSLDUYamWE00wnC14N0ZGbZrxdaZHharwDjAQ2PiE71FcbyY
	 9eMDLmZnIUOY/aCdDpmhw95v051CensgqsEwbCMk688yavND28ftL43c2W2rd/8WDL
	 TdQ3GhtteAvk0E0ptPUUqRLC80Lzevhu/LBCTFrQCjL3KA/U/9dPxqdkfM+LjnAB7a
	 icr8HWacYHoSKWvZGdRoIxO3Qh+VtvMsP5BypRFZpD/oQVKzZjiVvCbstlP45b580n
	 ldhxQpIrJ/DPg==
Date: Thu, 29 Aug 2024 14:19:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: use kfree_rcu_mightsleep to free the perag
 structures
Message-ID: <20240829211920.GK6224@frogsfrogsfrogs>
References: <20240829040848.1977061-1-hch@lst.de>
 <20240829040848.1977061-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829040848.1977061-2-hch@lst.de>

On Thu, Aug 29, 2024 at 07:08:37AM +0300, Christoph Hellwig wrote:
> Using the kfree_rcu_mightsleep is simpler and removes the need for a
> rcu_head in the perag structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ag.c | 12 +-----------
>  fs/xfs/libxfs/xfs_ag.h |  3 ---
>  2 files changed, 1 insertion(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 7e80732cb54708..4b5a39a83f7aed 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -235,16 +235,6 @@ xfs_initialize_perag_data(
>  	return error;
>  }
>  
> -STATIC void
> -__xfs_free_perag(
> -	struct rcu_head	*head)
> -{
> -	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
> -
> -	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
> -	kfree(pag);
> -}
> -
>  /*
>   * Free up the per-ag resources associated with the mount structure.
>   */
> @@ -270,7 +260,7 @@ xfs_free_perag(
>  		xfs_perag_rele(pag);
>  		XFS_IS_CORRUPT(pag->pag_mount,
>  				atomic_read(&pag->pag_active_ref) != 0);
> -		call_rcu(&pag->rcu_head, __xfs_free_perag);
> +		kfree_rcu_mightsleep(pag);
>  	}
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 35de09a2516c70..d62c266c0b44d5 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -63,9 +63,6 @@ struct xfs_perag {
>  	/* Blocks reserved for the reverse mapping btree. */
>  	struct xfs_ag_resv	pag_rmapbt_resv;
>  
> -	/* for rcu-safe freeing */
> -	struct rcu_head	rcu_head;
> -
>  	/* Precalculated geometry info */
>  	xfs_agblock_t		block_count;
>  	xfs_agblock_t		min_block;
> -- 
> 2.43.0
> 
> 
