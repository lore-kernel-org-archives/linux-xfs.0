Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C95D29E0ED
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 23:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760483788; cv=none; b=qAs+RqpoJiOPCBOTkI3JyJcLJA5bLeAwFUEmeCtdwRpkkawAjcdMIxenufN7d6oe/MVeEKmwewQXtsgukv43qbD8YSVStJqTobAFMci0eCPJ16xkeznL0xNbD8WyJxYOgi/n1U7hB30eUZDKiblovdoDqcpTS7eC3WhTMvujyCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760483788; c=relaxed/simple;
	bh=RYdS8w2ZuxAcw0n99benen53vNn9TJbUTXswoCVdnjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ktp7eqeJXqGScAbomwdHNj9SOycngO66GCwKXSUYA2O1UaUvI3lxHIebpGhJ8s1/SagVf1mdI9AWMTEMwktFPgon05v2RJ1jlaKNd2SeUJMRHKhcDbe0TG6W9Aami/QNQD/Y02hMOAZTOKxCUGsk/rLi071n9epI1MPytl4NXeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wflq9BhQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wflq9BhQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7EBC4CEE7;
	Tue, 14 Oct 2025 23:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760483787;
	bh=RYdS8w2ZuxAcw0n99benen53vNn9TJbUTXswoCVdnjI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wflq9BhQs6Y9tA2aJD1kd2gmRDlk4SZ6N39BYQ4k+xcfpELjeNuerPvbbhT/0WLkC
	 Dx6FEXlHh3YSkPn47O2Q++xhmbZIabo/J9XHLDVUVlbJ+35d0hibqT60gT+s1uuTrM
	 7yN8LLh5D9+/+vy1zupgLEqsg5qDCdvhDmFFpQa3uCK3or99Wasps5YCAEas3Pj+2k
	 LK3iiuyVfSqoteX0Q762vJAY6hvySOwLUCu8YYIdrye3keS0ztoKXiYwsfWK9LdNL8
	 CLhB1BcGlyHvf96axyRlM5u9cNdgoIVzZWNH0faadOtPZDGBFVW1A6bL++Ot88jhpr
	 eTV4ecQs52pIg==
Date: Tue, 14 Oct 2025 16:16:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/17] xfs: make qi_dquots a 64-bit value
Message-ID: <20251014231627.GQ6188@frogsfrogsfrogs>
References: <20251013024851.4110053-1-hch@lst.de>
 <20251013024851.4110053-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024851.4110053-2-hch@lst.de>

On Mon, Oct 13, 2025 at 11:48:02AM +0900, Christoph Hellwig wrote:
> qi_dquots counts all quotas in the file system, which can be up to
> 3 * UINT_MAX and overflow a 32-bit counter, but can't be negative.
> Make qi_dquots a uint64_t, and saturate the value to UINT_MAX for
> userspace reporting.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_qm.h       | 2 +-
>  fs/xfs/xfs_quotaops.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 35b64bc3a7a8..e88ed6ad0e65 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -57,7 +57,7 @@ struct xfs_quotainfo {
>  	struct xfs_inode	*qi_pquotaip;	/* project quota inode */
>  	struct xfs_inode	*qi_dirip;	/* quota metadir */
>  	struct list_lru		qi_lru;
> -	int			qi_dquots;
> +	uint64_t		qi_dquots;
>  	struct mutex		qi_quotaofflock;/* to serialize quotaoff */
>  	xfs_filblks_t		qi_dqchunklen;	/* # BBs in a chunk of dqs */
>  	uint			qi_dqperchunk;	/* # ondisk dq in above chunk */
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index 4c7f7ce4fd2f..1045c4c262ad 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -65,7 +65,7 @@ xfs_fs_get_quota_state(
>  	memset(state, 0, sizeof(*state));
>  	if (!XFS_IS_QUOTA_ON(mp))
>  		return 0;
> -	state->s_incoredqs = q->qi_dquots;
> +	state->s_incoredqs = max_t(uint64_t, q->qi_dquots, UINT_MAX);

Isn't this min_t?  Surely we don't want to return 0xFFFFFFFF when
there's only 3 dquots loaded in the system?

--D

>  	if (XFS_IS_UQUOTA_ON(mp))
>  		state->s_state[USRQUOTA].flags |= QCI_ACCT_ENABLED;
>  	if (XFS_IS_UQUOTA_ENFORCED(mp))
> -- 
> 2.47.3
> 
> 
