Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D3B3C0B
	for <linux-xfs@vger.kernel.org>; Thu, 28 Dec 2023 06:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K15N3yrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C681C433C7;
	Thu, 28 Dec 2023 06:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703744831;
	bh=ueR3//W3sXnG3xqynaz4KJNic51fCw3E6vUwtMKlHTQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K15N3yrGuyNmGLCSrqtSQ+7qA8qhbpLxH6tQTYTk8BmZCkCaWPnc3P5F6UnjpbIjx
	 EjGwwZgcwfTVVNrQFmkrbW9WK3wwktZBD/wEprw7UylwgsAxjxqCMZCKwgaok7x92R
	 Y8Y/2dOr0WrCm6AUzlzpWn3XYaw92FVqpVXxH0xbUi50ITQKXr2yzP4/DLPUDjVDfh
	 Cl9WaO/MsSgEhOn6bH8Hg42nb2eDBH5Bhay4NMI4J9yEnXN+2v6wLTMWs3JZjTfpau
	 qfDfI5utlSVX9yH/F62w+4URrjBQiZgd3SqyZgH0JIbqRME8vYZ79bOinW6t63AQ4i
	 PxJ/muI2Hncng==
Date: Wed, 27 Dec 2023 22:27:10 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandan.babu@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: use the op name in
 trace_xlog_intent_recovery_failed
Message-ID: <20231228062710.GS361584@frogsfrogsfrogs>
References: <20231228061830.337279-1-hch@lst.de>
 <20231228061830.337279-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231228061830.337279-2-hch@lst.de>

On Thu, Dec 28, 2023 at 06:18:30AM +0000, Christoph Hellwig wrote:
> Instead of tracing the address of the recovery handler, use the name
> in the defer op, similar to other defer ops related tracepoints.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yay fewer pointer shenanigans,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_defer.c |  3 +--
>  fs/xfs/xfs_trace.h        | 14 ++++++++------
>  2 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 785c92d2acaa73..e99d7890e614e1 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -920,8 +920,7 @@ xfs_defer_finish_recovery(
>  
>  	error = ops->recover_work(dfp, capture_list);
>  	if (error)
> -		trace_xlog_intent_recovery_failed(mp, error,
> -				ops->recover_work);
> +		trace_xlog_intent_recovery_failed(mp, ops, error);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 0efcdb79d10e51..a986c52ff466bc 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -145,21 +145,23 @@ DEFINE_ATTR_LIST_EVENT(xfs_attr_leaf_list);
>  DEFINE_ATTR_LIST_EVENT(xfs_attr_node_list);
>  
>  TRACE_EVENT(xlog_intent_recovery_failed,
> -	TP_PROTO(struct xfs_mount *mp, int error, void *function),
> -	TP_ARGS(mp, error, function),
> +	TP_PROTO(struct xfs_mount *mp, const struct xfs_defer_op_type *ops,
> +		 int error),
> +	TP_ARGS(mp, ops, error),
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
> +		__string(name, ops->name)
>  		__field(int, error)
> -		__field(void *, function)
>  	),
>  	TP_fast_assign(
>  		__entry->dev = mp->m_super->s_dev;
> +		__assign_str(name, ops->name);
>  		__entry->error = error;
> -		__entry->function = function;
>  	),
> -	TP_printk("dev %d:%d error %d function %pS",
> +	TP_printk("dev %d:%d optype %s error %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> -		  __entry->error, __entry->function)
> +		  __get_str(name),
> +		  __entry->error)
>  );
>  
>  DECLARE_EVENT_CLASS(xfs_perag_class,
> -- 
> 2.39.2
> 
> 
