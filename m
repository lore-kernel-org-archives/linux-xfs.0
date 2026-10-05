Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885DC1A6822
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 21:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791236796; cv=none; b=fBlC2Bx2nkook0itmzKbEsH2phk+ZUD0xGI2V320Hjqwnod/iPJPWWdVrNffwJHTvFE6o9bkOMHwWRW1YxMVjnJCfDZm13ya0bSo3do+e0sW1hS2ZYYp+XIUMP4i08sN8gvOaT1C/iW6RFLK2OJy7mdQLM7YmtcW2jW0307YdCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791236796; c=relaxed/simple;
	bh=u6pI/gounnzzbFKTrNy+PP2LWeyI0PmISsbpbJd/MOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lt29G0/Lz7e1ax8dyrWvkSQlweiTtAeoyqXuPnXI5clpGOG9qZrbpxDfnpvqusBvQcJ8S6kMyqbxkCxEN1cMAGseCDOpk1hLpdDAPiHHeJWWWzd3j6fbMl9f18qEFNYXow8XSFsmkbrJiAAFlp3vKDN0qLCLm90sy9gk3Kjr7kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WEQWsS9z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WEQWsS9z"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 802D91F000FF;
	Mon,  5 Oct 2026 21:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791236793;
	bh=sIde6Sl0yoyWhIbo5vTW3TANQl4n8P2WOGxxkVnw2rY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WEQWsS9zoFUWVGuFYECLRVEEYfLcqzq4OMBHhx+0TQNSmbZAMBIm1pcq9M8xyUTRr
	 L/Qt2ReSMq6yFE3Spgbfa7Ja1YTsOXxCNxrdI1WvOhigU8rxyr41OxIY1Vmeczflqh
	 jQj1i3bSD+O3f65B1aXsJ1g42QOzONmb542wuG60scjTomAFA15gPHYJmk4zbROP/L
	 2dwFoniTSfQ3QuiHMTyJQCqfudgiuPuFt17k6bb84/ar9zaGGMb0YYLZZBC52My+Xl
	 vzVEh3KGbwwSCUMWt3RzYN3axm/+EyoNqQzEDsBSYts/7otcOuH1SaTzwi5YykUixT
	 H+MP+c8v77SRg==
Date: Mon, 5 Oct 2026 14:46:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/13] libxfs: remove the xfs_log_item_t and
 xfs_buf_log_item_t typedefs
Message-ID: <20261005214633.GM2705364@frogsfrogsfrogs>
References: <20261005125637.1340355-1-hch@lst.de>
 <20261005125637.1340355-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005125637.1340355-8-hch@lst.de>

On Mon, Oct 05, 2026 at 02:56:17PM +0200, Christoph Hellwig wrote:
> These are long gone from the kernel, so catch up.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Hooray!!!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libxfs/logitem.c         |  8 ++++----
>  libxfs/stubs/xfs_trans.h | 12 ++++++------
>  libxfs/trans.c           |  8 ++++----
>  3 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/libxfs/logitem.c b/libxfs/logitem.c
> index d09ff75e9ce2..0bb9088db351 100644
> --- a/libxfs/logitem.c
> +++ b/libxfs/logitem.c
> @@ -74,10 +74,10 @@ static const struct xfs_item_ops xfs_buf_item_ops = {
>  void
>  xfs_buf_item_init(
>  	struct xfs_buf		*bp,
> -	xfs_mount_t		*mp)
> +	struct xfs_mount	*mp)
>  {
> -	xfs_log_item_t		*lip;
> -	xfs_buf_log_item_t	*bip;
> +	struct xfs_log_item	*lip;
> +	struct xfs_buf_log_item	*bip;
>  
>  #ifdef LI_DEBUG
>  	fprintf(stderr, "buf_item_init for buffer %p\n", bp);
> @@ -121,7 +121,7 @@ xfs_buf_item_init(
>   */
>  void
>  xfs_buf_item_log(
> -	xfs_buf_log_item_t	*bip,
> +	struct xfs_buf_log_item	*bip,
>  	uint			first,
>  	uint			last)
>  {
> diff --git a/libxfs/stubs/xfs_trans.h b/libxfs/stubs/xfs_trans.h
> index fcd58930cc85..1117aad80c2f 100644
> --- a/libxfs/stubs/xfs_trans.h
> +++ b/libxfs/stubs/xfs_trans.h
> @@ -21,7 +21,7 @@ struct xfs_item_ops {
>  	int (*iop_precommit)(struct xfs_trans *tp, struct xfs_log_item *lip);
>  };
>  
> -typedef struct xfs_log_item {
> +struct xfs_log_item {
>  	struct list_head		li_trans;	/* transaction list */
>  	xfs_lsn_t			li_lsn;		/* last on-disk lsn */
>  	uint				li_type;	/* item type */
> @@ -29,12 +29,12 @@ typedef struct xfs_log_item {
>  	struct xfs_buf			*li_buf;	/* real buffer pointer */
>  	struct list_head		li_bio_list;	/* buffer item list */
>  	const struct xfs_item_ops	*li_ops;	/* function list */
> -} xfs_log_item_t;
> +};
>  
>  #define XFS_LI_DIRTY	3	/* log item dirty in transaction */
>  
>  struct xfs_inode_log_item {
> -	xfs_log_item_t		ili_item;		/* common portion */
> +	struct xfs_log_item	ili_item;		/* common portion */
>  	struct xfs_inode	*ili_inode;		/* inode pointer */
>  	unsigned short		ili_lock_flags;		/* lock flags */
>  	unsigned int		ili_dirty_flags;	/* dirty in current tx */
> @@ -43,13 +43,13 @@ struct xfs_inode_log_item {
>  	spinlock_t		ili_lock;
>  };
>  
> -typedef struct xfs_buf_log_item {
> -	xfs_log_item_t		bli_item;	/* common item structure */
> + struct xfs_buf_log_item {
> +	struct xfs_log_item	bli_item;	/* common item structure */
>  	struct xfs_buf		*bli_buf;	/* real buffer pointer */
>  	unsigned int		bli_flags;	/* misc flags */
>  	unsigned int		bli_recur;	/* recursion count */
>  	struct xfs_buf_log_format	__bli_format;	/* in-log header */
> -} xfs_buf_log_item_t;
> +};
>  
>  #define XFS_BLI_DIRTY			(1<<0)
>  #define XFS_BLI_HOLD			(1<<1)
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index 9dd2e244a812..aa303288a81c 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -941,7 +941,7 @@ free_item:
>  
>  static void
>  buf_item_done(
> -	xfs_buf_log_item_t	*bip)
> +	struct xfs_buf_log_item	*bip)
>  {
>  	struct xfs_buf		*bp;
>  	int			hold;
> @@ -972,7 +972,7 @@ trans_committed(
>  		xfs_trans_del_item(lip);
>  
>  		if (lip->li_type == XFS_LI_BUF)
> -			buf_item_done((xfs_buf_log_item_t *)lip);
> +			buf_item_done((struct xfs_buf_log_item *)lip);
>  		else if (lip->li_type == XFS_LI_INODE)
>  			inode_item_done((struct xfs_inode_log_item *)lip);
>  		else {
> @@ -985,7 +985,7 @@ trans_committed(
>  
>  static void
>  buf_item_unlock(
> -	xfs_buf_log_item_t	*bip)
> +	struct xfs_buf_log_item	*bip)
>  {
>  	struct xfs_buf		*bp = bip->bli_buf;
>  	uint			hold;
> @@ -1017,7 +1017,7 @@ xfs_trans_free_items(
>  	list_for_each_entry_safe(lip, next, &tp->t_items, li_trans) {
>  		xfs_trans_del_item(lip);
>  		if (lip->li_type == XFS_LI_BUF)
> -			buf_item_unlock((xfs_buf_log_item_t *)lip);
> +			buf_item_unlock((struct xfs_buf_log_item *)lip);
>  		else if (lip->li_type == XFS_LI_INODE)
>  			inode_item_unlock((struct xfs_inode_log_item *)lip);
>  		else {
> -- 
> 2.53.0
> 
> 
