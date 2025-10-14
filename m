Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C04257AD3
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 21:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760478523; cv=none; b=a7ywwkpPsU+Cx3CnUjR9gkxvp93rX99rHI82AK6PLYxxHq6GaimlLDNeeftxRC8lHzBJc/7Azv2eVygSwqnjhdfJppA8eADTelBAMlsGnIxZYrLuKgWPZ3kVgDV0aB1VfiD0Q8nFoLXXjP78KfDC6Vt5/yuY+2OxceiDnWPZg8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760478523; c=relaxed/simple;
	bh=kc1wMyRkiPzHij+7d7zL4iurARjW82SUJtHc+L5f1JQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ku9oWJTVS7wC2k7oDedvLj94HfX88OESfW13O0fBWVG8DAuUxgPQGcr+job+uF/Y3F8j4P6tUJQQRxR4yx1i5jy814PVr5ZE+sgvBMQAwCcT6GELLovQX/BmyvfQPJa+jBVtiABNzE8oJOG34fnpQqoEEG0MBVXYTPUIkksfq1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AfYpRfAE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AfYpRfAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539B4C4CEE7;
	Tue, 14 Oct 2025 21:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760478523;
	bh=kc1wMyRkiPzHij+7d7zL4iurARjW82SUJtHc+L5f1JQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AfYpRfAEw+tem3BO+zvTy8XxOvZgppvsZaIskEl/siHWIapFXSOJUUPlmk1EpCm1E
	 y9QSudyOIpvHRre8SK1/zhQggZX4NNDmqtJ37CJiGiAeKdUGUOjNhUFO0Ttj24Tpgq
	 KfYMw4B1GbNIDOq1z3VWnQSvehBrqaYKbGMMlry9XGtN+j8S0vg7e1A+kwbdrjtUuZ
	 WBT1vpIATDZSSUhwOcpV1fVYG4uHu9ca04Y/qJIbeXFBJ4qUWB9RtJ7fuyLSjW2imA
	 dXpnrlk7Bjo1XAxbygK3pSQ1vYtFVagHarbCW8I7oF3oCvUrf2X31jM8nDTtdTM8d9
	 QZEsf3MwL+34g==
Date: Tue, 14 Oct 2025 14:48:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: cleanup xlog_alloc_log a bit
Message-ID: <20251014214842.GJ6188@frogsfrogsfrogs>
References: <20251013024228.4109032-1-hch@lst.de>
 <20251013024228.4109032-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024228.4109032-5-hch@lst.de>

On Mon, Oct 13, 2025 at 11:42:08AM +0900, Christoph Hellwig wrote:
> Remove the separate head variable, move the ic_datap initialization
> up a bit where the context is more obvious and remove the duplicate
> memset right after a zeroing memory allocation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This looks like a pretty easy variable removal,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index d9476124def6..3bd2f8787682 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1367,7 +1367,6 @@ xlog_alloc_log(
>  	int			num_bblks)
>  {
>  	struct xlog		*log;
> -	xlog_rec_header_t	*head;
>  	xlog_in_core_t		**iclogp;
>  	xlog_in_core_t		*iclog, *prev_iclog=NULL;
>  	int			i;
> @@ -1461,22 +1460,21 @@ xlog_alloc_log(
>  				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  		if (!iclog->ic_header)
>  			goto out_free_iclog;
> -		head = iclog->ic_header;
> -		memset(head, 0, sizeof(xlog_rec_header_t));
> -		head->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
> -		head->h_version = cpu_to_be32(
> +		iclog->ic_header->h_magicno =
> +			cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
> +		iclog->ic_header->h_version = cpu_to_be32(
>  			xfs_has_logv2(log->l_mp) ? 2 : 1);
> -		head->h_size = cpu_to_be32(log->l_iclog_size);
> -		/* new fields */
> -		head->h_fmt = cpu_to_be32(XLOG_FMT);
> -		memcpy(&head->h_fs_uuid, &mp->m_sb.sb_uuid, sizeof(uuid_t));
> +		iclog->ic_header->h_size = cpu_to_be32(log->l_iclog_size);
> +		iclog->ic_header->h_fmt = cpu_to_be32(XLOG_FMT);
> +		memcpy(&iclog->ic_header->h_fs_uuid, &mp->m_sb.sb_uuid,
> +			sizeof(iclog->ic_header->h_fs_uuid));
>  
> +		iclog->ic_datap = (void *)iclog->ic_header + log->l_iclog_hsize;
>  		iclog->ic_size = log->l_iclog_size - log->l_iclog_hsize;
>  		iclog->ic_state = XLOG_STATE_ACTIVE;
>  		iclog->ic_log = log;
>  		atomic_set(&iclog->ic_refcnt, 0);
>  		INIT_LIST_HEAD(&iclog->ic_callbacks);
> -		iclog->ic_datap = (void *)iclog->ic_header + log->l_iclog_hsize;
>  
>  		init_waitqueue_head(&iclog->ic_force_wait);
>  		init_waitqueue_head(&iclog->ic_write_wait);
> -- 
> 2.47.3
> 
> 
