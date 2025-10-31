Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A716833F363
	for <linux-xfs@vger.kernel.org>; Fri, 31 Oct 2025 13:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761918594; cv=none; b=HX5rumvWxzxuOoSv+NzmaSBmGTBhx5DO4JAq1gTOUxxOxdnbWIQJDbrUtHztsWJum1svD8MimCjWhQomJm/cTgAbDlVgz78P7RtuOUX3YQWGwG5nAkeAH3740enXzQrUqbNmJPDB0bfm5sMv9VbV6BtKiVuPYnWJRo5LF/qJIGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761918594; c=relaxed/simple;
	bh=nNXwwsc0TTHCsnbRc3KbHyXKKY5FCLNPnqrNbADO8j8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UEF2dL0g/WlmrZ83y73vBJMSPW0DPrMX+pmAoYlPuCimBRAAIA8P7STroU4AMZ3ibJlR21+usI8EmcNdclr2Y9VfiKOPP3pXg0VKdCl0LS1rSHhu9bLvwkunbzHkV7SI/7uItmYv1Kb1AkC8fb6t1Fwz8JOW5go9S15TyxHpQvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IqbsLVLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IqbsLVLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAE5C4CEE7;
	Fri, 31 Oct 2025 13:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761918594;
	bh=nNXwwsc0TTHCsnbRc3KbHyXKKY5FCLNPnqrNbADO8j8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IqbsLVLCpTSE8mFFZhn7yocDQJ59LQnzJ/RjuOsoCtuTt2jrqNtIw2xjmZFTGJGwq
	 w3pqXl9mQ0Q/jH9CkeoUccphvYZi208JAWNRLILVIFZnC5r4SnODnYJuKmM+Z0JnSM
	 OaCN9WzTZmkkB8DhdAXK/N0onQsuDpPv5j+1YyOc9adO8UK8v+zFynZT/iQPQhTKEp
	 gSVRlQHEoag31qLXnRQ65Mz2/IF2K0QMXhOAqYYMNoPjzZOOrD7t05qsXiRj66ts+/
	 x1BEjCfL28ohfwGw+KOfZFlCAGckYREHPXuu2U0MArW45sxqT4V8dHnXcOUMeJ9vUm
	 u2q/c65z35m1g==
Date: Fri, 31 Oct 2025 14:49:50 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 4/9] xfs: cleanup xlog_alloc_log a bit
Message-ID: <p262kms6rk5myvqpjxunjm573if4f5ormmvzc7b2eddphwplnl@glonylkwew3j>
References: <20251027070610.729960-1-hch@lst.de>
 <Qg0yYI7fKrah-ZaL2bm_Uzt83hEqjt8rNG9zcmTKJHx22fOlvissxQN-W4ewCp1e_7o_zl8q0xZJHXnokjrjpA==@protonmail.internalid>
 <20251027070610.729960-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027070610.729960-5-hch@lst.de>

On Mon, Oct 27, 2025 at 08:05:51AM +0100, Christoph Hellwig wrote:
> Remove the separate head variable, move the ic_datap initialization
> up a bit where the context is more obvious and remove the duplicate
> memset right after a zeroing memory allocation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

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
