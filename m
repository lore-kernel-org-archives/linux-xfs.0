Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51603173D
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 18:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UKUaqZ1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA6BC433CC;
	Wed, 13 Dec 2023 18:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702491529;
	bh=JMzBbQ4D0FkGh1dhuaj4R0RJ+E9NwAF/FrT0a+bVe/4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UKUaqZ1gIga99dQw1INNz6CkJ9vAQ8xm8/QD//jJplXV1VIB9dRHzBhA+rfjZ+Bm3
	 /HP4O3qO+38nNvqmaUbK1K3VcJaJh121Y0+q+9W/qJoFMFnJoAq2gtQq70BY32AFcr
	 IjsE6toMnBECizIP0V9IfgzVL7wMMSbwQMVKw6vlS8slXCn2NVcaZl2f7LvnZxtvo4
	 Xq6vo7cE1+Ffa0ermPoWV5A3AXLb95rrpCzv5CoDKHQKzkZsHRV0mxnKpiUWT76Krl
	 AncGBCuffp1X2HkyB3HE/fJ+/zHnOtqzxJT94dPv6pyZdqr3vOXug2UTgQAEXgF6Zo
	 eTcwJKm0l+d8w==
Date: Wed, 13 Dec 2023 10:18:49 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org, yi.zhang@huawei.com,
	houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v3 1/2] xfs: add lock protection when remove perag from
 radix tree
Message-ID: <20231213181849.GI361584@frogsfrogsfrogs>
References: <20231213031013.390145-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231213031013.390145-1-leo.lilong@huawei.com>

On Wed, Dec 13, 2023 at 11:10:12AM +0800, Long Li wrote:
> Take mp->m_perag_lock for deletions from the perag radix tree in
> xfs_initialize_perag to prevent racing with tagging operations.
> Lookups are fine - they are RCU protected so already deal with the
> tree changing shape underneath the lookup - but tagging operations
> require the tree to be stable while the tags are propagated back up
> to the root.
> 
> Right now there's nothing stopping radix tree tagging from operating
> while a growfs operation is progress and adding/removing new entries
> into the radix tree.
> 
> Hence we can have traversals that require a stable tree occurring at
> the same time we are removing unused entries from the radix tree which
> causes the shape of the tree to change.
> 
> Likely this hasn't caused a problem in the past because we are only
> doing append addition and removal so the active AG part of the tree
> is not changing shape, but that doesn't mean it is safe. Just making
> the radix tree modifications serialise against each other is obviously
> correct.
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks correct to me, and I didn't find any other suspicious accesses of
m_perag_tree so

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ag.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index f62ff125a50a..c730976fdfc0 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -424,13 +424,17 @@ xfs_initialize_perag(
>  
>  out_remove_pag:
>  	xfs_defer_drain_free(&pag->pag_intents_drain);
> +	spin_lock(&mp->m_perag_lock);
>  	radix_tree_delete(&mp->m_perag_tree, index);
> +	spin_unlock(&mp->m_perag_lock);
>  out_free_pag:
>  	kmem_free(pag);
>  out_unwind_new_pags:
>  	/* unwind any prior newly initialized pags */
>  	for (index = first_initialised; index < agcount; index++) {
> +		spin_lock(&mp->m_perag_lock);
>  		pag = radix_tree_delete(&mp->m_perag_tree, index);
> +		spin_unlock(&mp->m_perag_lock);
>  		if (!pag)
>  			break;
>  		xfs_buf_hash_destroy(pag);
> -- 
> 2.31.1
> 
> 
