Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237ED376469
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 21:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791236886; cv=none; b=fF/AAkBgn3lEky2oUsGt/bFRrJAiZtTm6oaS/xtgVcRcOPuP+JerwOn0R+5b42dQ/oMefVCS3CKSuLTOljO5WROkes5CVZGVFaKqqxVy01BuH9gsKICgDiyv1qE6VJziJr4QGslFVqH+ypLTSAWDdreN8zKc/Qa3VhULe/NG5qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791236886; c=relaxed/simple;
	bh=MUcjSsfU4uiHs0I42W3HmJBqrdXb9KxpgnhYOXs5XDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vxz6KcjtKaWP3KmbMc+kHsKlNR4Jxsy9QmZSnQbDj3s5WFyN+bX2h0LLU3GhJeD85zwSUr5t/uju/NuXpeEkkA0tn2Q1Q95cn0Rojcm36PRUxv8DQO6v4OnSTD9ZQW0Usx+g9EwyXjjCR42Lu8Z9+iC7Msp6AbI5gK8bZC2M6qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kZhidU7w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kZhidU7w"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C9BED1F000FF;
	Mon,  5 Oct 2026 21:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791236884;
	bh=0507e2opztN9OW3ryTYyAlANvrghWLKzXJJMTLhXLjE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kZhidU7wnuZxu5PK4QKYNMCa2BIS5C8lfXknpWSmgDmQEJ9dYnVgMRIzMB3F73ll+
	 8cbpHA8YhOhbxkwO8NJV0QdKXdmmvsNEuKLLFiuG+/WCw3TqxV3R2lULYR1xEXl61D
	 RIHHqsI9PqgGXf8zeqiy/WEfRLkZpdAZm/pClSCdyh0mu0rmXoUc6WzyDDpeEmczgg
	 3JwSkyKEea94tbp8Mb3bbQo4gyTtyQ7DyWQTIRAYv3mXF6oEbsNBRdaSLI0i2aC77z
	 ceWCncH0OR92nQxP9sSfHSna5Sfhh0UjwYQLpsJoxeywRlxy+Gi9MF7I+wxZIxkaIy
	 SpWb80UakKfBA==
Date: Mon, 5 Oct 2026 14:48:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/13] libxfs: return int from xfs_buf_item_init
Message-ID: <20261005214804.GO2705364@frogsfrogsfrogs>
References: <20261005125637.1340355-1-hch@lst.de>
 <20261005125637.1340355-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005125637.1340355-10-hch@lst.de>

On Mon, Oct 05, 2026 at 02:56:19PM +0200, Christoph Hellwig wrote:
> Match the kernel version.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libxfs/logitem.c      | 6 +++---
>  libxfs/xfs_platform.h | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/libxfs/logitem.c b/libxfs/logitem.c
> index 0bb9088db351..2e050ad92a1e 100644
> --- a/libxfs/logitem.c
> +++ b/libxfs/logitem.c
> @@ -71,7 +71,7 @@ static const struct xfs_item_ops xfs_buf_item_ops = {
>   * buffer (see xfs_buf_attach_iodone() below), then put the
>   * buf log item at the front.
>   */
> -void
> +int
>  xfs_buf_item_init(
>  	struct xfs_buf		*bp,
>  	struct xfs_mount	*mp)
> @@ -97,7 +97,7 @@ xfs_buf_item_init(
>  				"reused buf item %p for pre-logged buffer %p\n",
>  				lip, bp);
>  #endif
> -			return;
> +			return 0;
>  		}
>  	}
>  
> @@ -112,9 +112,9 @@ xfs_buf_item_init(
>  	bip->__bli_format.blf_blkno = (int64_t)xfs_buf_daddr(bp);
>  	bip->__bli_format.blf_len = (unsigned short)bp->b_length;
>  	bp->b_log_item = bip;
> +	return 0;
>  }
>  
> -
>  /*
>   * Mark bytes first through last inclusive as dirty in the buf
>   * item's bitmap.
> diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
> index 9aa898200da8..2e3d323505c5 100644
> --- a/libxfs/xfs_platform.h
> +++ b/libxfs/xfs_platform.h
> @@ -408,7 +408,7 @@ void xfs_trans_del_item(struct xfs_log_item *);
>  void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
>  
>  /* xfs_buf_item.c */
> -void xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
> +int xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
>  void xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
>  
>  /* xfs_trans_buf.c */
> -- 
> 2.53.0
> 
> 
