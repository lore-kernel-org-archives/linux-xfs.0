Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92FE54FB4
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 22:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SNpqld0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C75C433C7;
	Mon, 11 Dec 2023 22:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702332186;
	bh=qYVbyEcmkEhfoQpdvgWbX10UO05Vcj37YFAkoXkoJsQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SNpqld0u5nlvWCgI999XwhtTJOc0vUNJ01wjf8+pCwZTa5jH9iZ135pjgjbwTAII+
	 Cgte9e5uW+9y+kWR731zV+H28pB00RVobBDS4WFeOOQJF+dUKd+BS5qC4bIKehN+qA
	 FWstfbXOIQ69i45OgHO5ZWoXyWdF5XXfSycrngKa3OCVMRjrOrpS8eRP89naa+yvIL
	 F3vn6Z0Ty+6b6CZkJaPp+u9+eSutJBOBl17u3koEtFOREmnNFQHX3V++Om0HG6Wy9N
	 Rx6X5YktBwHti5JvNjMTsXoUZmMZkeN3jrcanhM72IF5KJnnt++iYOoNQiAHCIWJZz
	 DWtPk6J5UTiRg==
Date: Mon, 11 Dec 2023 14:03:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org, yi.zhang@huawei.com,
	houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v2 3/3] xfs: fix perag leak when growfs fails
Message-ID: <20231211220305.GW361584@frogsfrogsfrogs>
References: <20231209122107.2422441-1-leo.lilong@huawei.com>
 <20231209122107.2422441-3-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231209122107.2422441-3-leo.lilong@huawei.com>

On Sat, Dec 09, 2023 at 08:21:07PM +0800, Long Li wrote:
> During growfs, if new ag in memory has been initialized, however
> sb_agcount has not been updated, if an error occurs at this time it
> will cause perag leaks as follows, these new AGs will not been freed
> during umount , because of these new AGs are not visible(that is
> included in mp->m_sb.sb_agcount).
> 
> unreferenced object 0xffff88810be40200 (size 512):
>   comm "xfs_growfs", pid 857, jiffies 4294909093
>   hex dump (first 32 bytes):
>     00 c0 c1 05 81 88 ff ff 04 00 00 00 00 00 00 00  ................
>     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace (crc 381741e2):
>     [<ffffffff8191aef6>] __kmalloc+0x386/0x4f0
>     [<ffffffff82553e65>] kmem_alloc+0xb5/0x2f0
>     [<ffffffff8238dac5>] xfs_initialize_perag+0xc5/0x810
>     [<ffffffff824f679c>] xfs_growfs_data+0x9bc/0xbc0
>     [<ffffffff8250b90e>] xfs_file_ioctl+0x5fe/0x14d0
>     [<ffffffff81aa5194>] __x64_sys_ioctl+0x144/0x1c0
>     [<ffffffff83c3d81f>] do_syscall_64+0x3f/0xe0
>     [<ffffffff83e00087>] entry_SYSCALL_64_after_hwframe+0x62/0x6a
> unreferenced object 0xffff88810be40800 (size 512):
>   comm "xfs_growfs", pid 857, jiffies 4294909093
>   hex dump (first 32 bytes):
>     20 00 00 00 00 00 00 00 57 ef be dc 00 00 00 00   .......W.......
>     10 08 e4 0b 81 88 ff ff 10 08 e4 0b 81 88 ff ff  ................
>   backtrace (crc bde50e2d):
>     [<ffffffff8191b43a>] __kmalloc_node+0x3da/0x540
>     [<ffffffff81814489>] kvmalloc_node+0x99/0x160
>     [<ffffffff8286acff>] bucket_table_alloc.isra.0+0x5f/0x400
>     [<ffffffff8286bdc5>] rhashtable_init+0x405/0x760
>     [<ffffffff8238dda3>] xfs_initialize_perag+0x3a3/0x810
>     [<ffffffff824f679c>] xfs_growfs_data+0x9bc/0xbc0
>     [<ffffffff8250b90e>] xfs_file_ioctl+0x5fe/0x14d0
>     [<ffffffff81aa5194>] __x64_sys_ioctl+0x144/0x1c0
>     [<ffffffff83c3d81f>] do_syscall_64+0x3f/0xe0
>     [<ffffffff83e00087>] entry_SYSCALL_64_after_hwframe+0x62/0x6a
> 
> Now, the logic for freeing perag in xfs_free_perag() and
> xfs_initialize_perag() error handling is essentially the same. Factor
> out xfs_free_perag_range() from xfs_free_perag(), used for freeing
> unused perag within a specified range, inclued when growfs fails.
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_ag.c | 35 ++++++++++++++++++++---------------
>  fs/xfs/libxfs/xfs_ag.h |  2 ++
>  fs/xfs/xfs_fsops.c     |  5 ++++-
>  3 files changed, 26 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 11ed048c350c..edec03ab09aa 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -245,16 +245,20 @@ __xfs_free_perag(
>  }
>  
>  /*
> - * Free up the per-ag resources associated with the mount structure.
> + * Free per-ag within the specified range, if agno is not found in the
> + * radix tree, then it means that agno and subsequent AGs have not been
> + * initialized.
>   */
>  void
> -xfs_free_perag(
> -	struct xfs_mount	*mp)
> +xfs_free_perag_range(
> +		xfs_mount_t		*mp,

Please stop reverting the codebase's use of typedefs for struct
pointers.

> +		xfs_agnumber_t		agstart,
> +		xfs_agnumber_t		agend)

This is also ^^ unnecessary indentation.

>  {
> -	struct xfs_perag	*pag;
>  	xfs_agnumber_t		agno;
> +	struct xfs_perag	*pag;

...and unnecessary rearranging of variables...

>  
> -	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> +	for (agno = agstart; agno < agend; agno++) {
>  		spin_lock(&mp->m_perag_lock);
>  		pag = radix_tree_delete(&mp->m_perag_tree, agno);
>  		spin_unlock(&mp->m_perag_lock);
> @@ -274,6 +278,16 @@ xfs_free_perag(
>  	}
>  }
>  
> +/*
> + * Free up the per-ag resources associated with the mount structure.
> + */
> +void
> +xfs_free_perag(
> +	struct xfs_mount	*mp)
> +{
> +	xfs_free_perag_range(mp, 0,  mp->m_sb.sb_agcount);
> +}
> +
>  /* Find the size of the AG, in blocks. */
>  static xfs_agblock_t
>  __xfs_ag_block_count(
> @@ -432,16 +446,7 @@ xfs_initialize_perag(
>  	kmem_free(pag);
>  out_unwind_new_pags:
>  	/* unwind any prior newly initialized pags */
> -	for (index = first_initialised; index < agcount; index++) {
> -		spin_lock(&mp->m_perag_lock);
> -		pag = radix_tree_delete(&mp->m_perag_tree, index);
> -		spin_unlock(&mp->m_perag_lock);
> -		if (!pag)
> -			break;
> -		xfs_buf_hash_destroy(pag);
> -		xfs_defer_drain_free(&pag->pag_intents_drain);
> -		kmem_free(pag);
> -	}
> +	xfs_free_perag_range(mp, first_initialised, agcount);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 2e0aef87d633..927f737f84ec 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -136,6 +136,8 @@ __XFS_AG_OPSTATE(agfl_needs_reset, AGFL_NEEDS_RESET)
>  int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
>  			xfs_rfsblock_t dcount, xfs_agnumber_t *maxagi);
>  int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
> +void xfs_free_perag_range(xfs_mount_t *mp, xfs_agnumber_t agstart,
> +			xfs_agnumber_t agend);
>  void xfs_free_perag(struct xfs_mount *mp);
>  
>  /* Passive AG references */
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 57076a25f17d..144fea4374af 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -153,7 +153,7 @@ xfs_growfs_data_private(
>  		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata, -delta, 0,
>  				0, &tp);
>  	if (error)
> -		return error;
> +		goto out_free_unused_perag;
>  
>  	last_pag = xfs_perag_get(mp, oagcount - 1);
>  	if (delta > 0) {
> @@ -227,6 +227,9 @@ xfs_growfs_data_private(
>  
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
> +out_free_unused_perag:
> +	if (nagcount > oagcount)
> +		xfs_free_perag_range(mp, oagcount, nagcount);

Complaints aside, this addition looks correct.

--D

>  	return error;
>  }
>  
> -- 
> 2.31.1
> 
> 
