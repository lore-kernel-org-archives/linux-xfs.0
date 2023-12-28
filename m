Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BEE256C
	for <linux-xfs@vger.kernel.org>; Thu, 28 Dec 2023 06:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qknYgL4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B5CC433C7;
	Thu, 28 Dec 2023 06:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703744794;
	bh=OHYG/6Ecy4+Azsr4VYAK4yA4swxLtAvHnMWJC4ZldRw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qknYgL4YVE2ZEnmV10SzbQiCclWaRtJAxTVjJNKrEikx+vEoy3Ue7n20WgClaiFAg
	 mvNguLPGq8pX35ATE5ZrdIV2kbhA7VUjJJfayxSZufuSbc4tzHyBb6ZhZ5Mrtxk8CX
	 urlaDJcKFaXWQ9ORs97S0WtbEYS12HVJI5ExaLtH9daUJZ6fbf6+Mc4Pq5gEMCS5sc
	 Rv3FdqVwHDaW/iY31F9OVcNJSB588kl/JR/cE8wmvBo6ICLv6CZxMgsOTj6UgSJqTT
	 /knKpirMc2kwkmc2143Xk0uWPyE+RsmliBICsVnnAS3MC7bKB0F59ELlAcuyG45b7w
	 WVcox5Cuft24w==
Date: Wed, 27 Dec 2023 22:26:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH 1/2] xfs: fix a use after free in
 xfs_defer_finish_recovery
Message-ID: <20231228062633.GR361584@frogsfrogsfrogs>
References: <20231228061830.337279-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231228061830.337279-1-hch@lst.de>

On Thu, Dec 28, 2023 at 06:18:29AM +0000, Christoph Hellwig wrote:
> dfp will be freed by ->recover_work and thus the tracepoint in case
> of an error can lead to a use after free.
> 
> Store the defer ops in a local variable to avoid that.
> 
> Fixes: 7f2f7531e0d4 ("xfs: store an ops pointer in struct xfs_defer_pending")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_defer.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index ca7f0ac0489604..785c92d2acaa73 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -915,12 +915,13 @@ xfs_defer_finish_recovery(
>  	struct xfs_defer_pending	*dfp,
>  	struct list_head		*capture_list)
>  {
> +	const struct xfs_defer_op_type	*ops = dfp->dfp_ops;
>  	int				error;
>  
> -	error = dfp->dfp_ops->recover_work(dfp, capture_list);
> +	error = ops->recover_work(dfp, capture_list);

Since I suck at remembering that dfp can be freed by recovery work, can
you add a comment to that effect? e.g.

	/* dfp is freed by recover_work and must not be accessed further */
	error = ops->recover_work(dfp, capture_list);

With that added,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


>  	if (error)
>  		trace_xlog_intent_recovery_failed(mp, error,
> -				dfp->dfp_ops->recover_work);
> +				ops->recover_work);
>  	return error;
>  }
>  
> -- 
> 2.39.2
> 
> 
