Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C3C1DDD1
	for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 20:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753820793; cv=none; b=flwzxijZg4+MqYe2wZArbnmHaulPrvLj7IfTYDyD928vJ43hr7X4hBd2L8UhQHAeUZMD9olWAN/mMgeoGb8EC1OxiBjUM70la4Xy+dlyWgS9I37seSZ3q1NJ9Ofh1fN0ybSQA+8WC0TdQJW7Xix6UoeYeXgh6Sq3gZ8xYWbKJGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753820793; c=relaxed/simple;
	bh=0mQPRIRAuQngb9MRakwm9gkl3ABAEVYdgTbiWXvF6q8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fD+Hddw2FOygXdJ12sMPGeAb+GvVkTagn35WhWCRUzpCzukCU1EBdc9mr5/J2ilNitT1IBYJgMwX+Ft7KYclUyadorRhm16GlSWHeKM5oqY6d5qvN9f/L9ljMvU4kdbbj8cfqAOEPcjYHv/MEVmGVpSC2tuIQx4kjF3pG7yacyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CVFRDPLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CVFRDPLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6D2C4CEEF;
	Tue, 29 Jul 2025 20:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753820792;
	bh=0mQPRIRAuQngb9MRakwm9gkl3ABAEVYdgTbiWXvF6q8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CVFRDPLTnb/NrvkecrGJu2LiCoGBWKHkSr/BZ85odRSP+oCswtdQ3D0UnslJRJoAZ
	 L/tXmpTekw6Sl0yTNPCyU2EpS8D7M+8hZ9TQyDRsu9P9HjY9WcV0JPyrPIxXfiG5kT
	 k/Js+kB1TGQTjGPgmlXCBFSMsTeEGP8q5JwKHyB+zR874+lxGH6H6+cYQdgdtNBCIb
	 v3/6RoEYFizcWR8MqNsjtWc58zGN5jqglt5l1tyx5oFV30N97cVKarwzIhrd5zoezP
	 40U4LTd2vsfejEkwvNAHYrqUEsZ67yRMQ0YX12NsIdOH4owFrNvi6B3jcHNx93IOvZ
	 tLApNUj54d+hg==
Date: Tue, 29 Jul 2025 13:26:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
	bfoster@redhat.com, david@fromorbit.com,
	hsiangkao@linux.alibaba.com
Subject: Re: [RFC 1/3] xfs: Re-introduce xg_active_wq field in struct
 xfs_group
Message-ID: <20250729202632.GF2672049@frogsfrogsfrogs>
References: <cover.1752746805.git.nirjhar.roy.lists@gmail.com>
 <70c065f02299e09b1569c3bc45ff493c9ac55fda.1752746805.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70c065f02299e09b1569c3bc45ff493c9ac55fda.1752746805.git.nirjhar.roy.lists@gmail.com>

On Thu, Jul 17, 2025 at 04:00:43PM +0530, Nirjhar Roy (IBM) wrote:
> pag_active_wq was removed in
> commit 9943b4573290
> 	("xfs: remove the unused pag_active_wq field in struct xfs_perag")
> because it was not waited upon. Re-introducing this in struct xfs_group.
> This patch also replaces atomic_dec() in xfs_group_rele() with
> 
> if (atomic_dec_and_test(&xg->xg_active_ref))
> 	wake_up(&xg->xg_active_wq);
> 
> The reason for this change is that the online shrink code will wait
> for all the active references to come down to zero before actually
> starting the shrink process (only if the number of blocks that
> we are trying to remove is worth 1 or more AGs).

...and I guess this is the start of being able to remove live rtgroups
too?

> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_group.c | 4 +++-
>  fs/xfs/libxfs/xfs_group.h | 1 +
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
> index e9d76bcdc820..1fe5319de338 100644
> --- a/fs/xfs/libxfs/xfs_group.c
> +++ b/fs/xfs/libxfs/xfs_group.c
> @@ -147,7 +147,8 @@ xfs_group_rele(
>  	struct xfs_group	*xg)
>  {
>  	trace_xfs_group_rele(xg, _RET_IP_);
> -	atomic_dec(&xg->xg_active_ref);
> +	if (atomic_dec_and_test(&xg->xg_active_ref))
> +		wake_up(&xg->xg_active_wq);
>  }
>  
>  void
> @@ -198,6 +199,7 @@ xfs_group_insert(
>  	xfs_defer_drain_init(&xg->xg_intents_drain);
>  
>  	/* Active ref owned by mount indicates group is online. */
> +	init_waitqueue_head(&xg->xg_active_wq);
>  	atomic_set(&xg->xg_active_ref, 1);
>  
>  	error = xa_insert(&mp->m_groups[type].xa, index, xg, GFP_KERNEL);
> diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
> index 4423932a2313..dbef389ef838 100644
> --- a/fs/xfs/libxfs/xfs_group.h
> +++ b/fs/xfs/libxfs/xfs_group.h
> @@ -11,6 +11,7 @@ struct xfs_group {
>  	enum xfs_group_type	xg_type;
>  	atomic_t		xg_ref;		/* passive reference count */
>  	atomic_t		xg_active_ref;	/* active reference count */
> +	wait_queue_head_t xg_active_wq; /* woken active_ref falls to zero */

Nit: tab between the     ^ variable and its type.

With that fixed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  
>  	/* Precalculated geometry info */
>  	uint32_t		xg_block_count;	/* max usable gbno */
> -- 
> 2.43.5
> 
> 
