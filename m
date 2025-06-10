Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741C322DF9F
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 07:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749542169; cv=none; b=GZmADkpAbZcHJKkpP/K5+A4wC8usYv6IbIYdKtTFih8oC+otsGqn0yZqYxz7MsAHjjXFxIpOzyCM549nEb6Tb+A8EbLAB6tCHuNRoCt0yYVsrwrrCX0KkJscEB5CmIAhgOF2dG/oBg2MDy+nU/pq0ZDm/wRKXX9eU7L3xb7y26k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749542169; c=relaxed/simple;
	bh=7JRL9rWIhpuHP9fzy1RamrtXqCKC/5DgZ4HTvqg18pw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p3VBKtwoiS1PvWQDy18DIDzhGXTt3bLjg2vaTAwnsRl1hPW+atsvZcu2XVATQ2qVW853UkeHE811inWMmmhCMLQInJgZYjD12b5twMABRIoubVtybvDu3dDoGYgUEICXnq0z11XhlsOTnidPSeWBTd/sH7yXDkhq8TTbbFPlvj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iKgB9iAw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iKgB9iAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD82C4CEEF;
	Tue, 10 Jun 2025 07:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749542169;
	bh=7JRL9rWIhpuHP9fzy1RamrtXqCKC/5DgZ4HTvqg18pw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iKgB9iAwWvwYyMADsZz89gfn3AH32eozfsj8hB8n+YBqCxJYCUvJ+4kn+HisHj1FV
	 61XiuzqRhwGz0nBR9ETixIgwLyxnHuF2ttNfE+wmYI3tOqQjZunw3FS3ZIjFPn8yny
	 9JreKOElu/Na3y01yepRnk3yOHkkzWsNvftDW0ZApY6WBs2MA0xjkiMusH0QBYgTUu
	 QdpX1JmAh096qeimZpTtwDuGe4hbyhSitm1Owxll2Lv8v4N6NJLiIcGma/fjjHmwpT
	 SsJ+mOG9iRH+do6HdLQ6jreaymxOhi+SWS7t/KGMAHU2grvJ6mq1DBtexKtwxmWFdq
	 GRM2XciGBsNWA==
Date: Tue, 10 Jun 2025 09:56:04 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/17] xfs: cleanup the ordered item logic in
 xlog_cil_insert_format_items
Message-ID: <txjhmsaiqnyjl46nhz75ukobgnmxwy6ka3wlsb6xvdz5v6bj3t@hpkwwjwk5f5k>
References: <20250610051644.2052814-1-hch@lst.de>
 <cqWn7I8cwwfGuWnf1e0-3it6wZgwjbXDsuuqz5qtz1MSy4hWQDWfQNT8SefFV7CfDrh1OSxj8qotWfFp9SYFtQ==@protonmail.internalid>
 <20250610051644.2052814-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250610051644.2052814-3-hch@lst.de>

On Tue, Jun 10, 2025 at 07:14:59AM +0200, Christoph Hellwig wrote:
> Split out handling of ordered items into a single branch in
> xlog_cil_insert_format_items so that the rest of the code becomes more
> clear.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log_cil.c | 31 +++++++++++++------------------
>  1 file changed, 13 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index c3db01b2ea47..81b6780e0afc 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -452,9 +452,8 @@ xlog_cil_insert_format_items(
>  	}
> 
>  	list_for_each_entry(lip, &tp->t_items, li_trans) {
> -		struct xfs_log_vec *lv;
> -		struct xfs_log_vec *shadow;
> -		bool	ordered = false;
> +		struct xfs_log_vec *lv = lip->li_lv;
> +		struct xfs_log_vec *shadow = lip->li_lv_shadow;
> 
>  		/* Skip items which aren't dirty in this transaction. */
>  		if (!test_bit(XFS_LI_DIRTY, &lip->li_flags))
> @@ -464,21 +463,23 @@ xlog_cil_insert_format_items(
>  		 * The formatting size information is already attached to
>  		 * the shadow lv on the log item.
>  		 */
> -		shadow = lip->li_lv_shadow;
> -		if (shadow->lv_buf_len == XFS_LOG_VEC_ORDERED)
> -			ordered = true;
> +		if (shadow->lv_buf_len == XFS_LOG_VEC_ORDERED) {
> +			if (!lv) {
> +				lv = shadow;
> +				lv->lv_item = lip;
> +			}
> +			ASSERT(shadow->lv_size == lv->lv_size);

			This assert is kind of confusing me. if we have an
			ORDERED vector here, couldn't we still have a shadow
			size smaller than the current vector?

> +			xfs_cil_prepare_item(log, lip, lv, diff_len);
> +			continue;
> +		}
> 
>  		/* Skip items that do not have any vectors for writing */
> -		if (!shadow->lv_niovecs && !ordered)
> +		if (!shadow->lv_niovecs)
>  			continue;
> 
>  		/* compare to existing item size */
> -		if (lip->li_lv && shadow->lv_size <= lip->li_lv->lv_size) {
> +		if (lv && shadow->lv_size <= lv->lv_size) {
>  			/* same or smaller, optimise common overwrite case */
> -			lv = lip->li_lv;
> -
> -			if (ordered)
> -				goto insert;
> 
>  			/*
>  			 * set the item up as though it is a new insertion so
> @@ -498,16 +499,10 @@ xlog_cil_insert_format_items(
>  			/* switch to shadow buffer! */
>  			lv = shadow;
>  			lv->lv_item = lip;
> -			if (ordered) {
> -				/* track as an ordered logvec */
> -				ASSERT(lip->li_lv == NULL);
> -				goto insert;
> -			}
>  		}
> 
>  		ASSERT(IS_ALIGNED((unsigned long)lv->lv_buf, sizeof(uint64_t)));
>  		lip->li_ops->iop_format(lip, lv);
> -insert:
>  		xfs_cil_prepare_item(log, lip, lv, diff_len);
>  	}
>  }
> --
> 2.47.2
> 
> 
