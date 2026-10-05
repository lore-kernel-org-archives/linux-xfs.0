Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50517418340
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 21:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791236770; cv=none; b=TjIk5MRFIo36agIMPh+FS+JjhgAZcmKkShdWomq22vC+ztvKKR6ecrU2rUVdj6uDx/YRrS8OcURJYacE9QyshR7BEp+/1P6A6ko+NedYiUf8m69Sgzo/H1xJku/34UTKY6+eu4+ZbftzeTDAwqmgrIRIAi2O9t3nEuqcYy1v5xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791236770; c=relaxed/simple;
	bh=WalcQ0UCCOkvAzKF/aUp27vl5s0lEJl5Jtgu4sfkd7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KgBmvchVv5nF8+EYOAePgKhFZbQBFAljwwMdcZqR1CT45xy12m2TH9qWuqT9fRM4Pb6nXZ9YupCkDuj6q67FhL20mHzS8yD3URByMKQ9oClEC1VjWEAzy/fi4vl3ZRkoK/G5mw7j2FQjYO3bI7UeupFmmwixc6G6Bx7HB4tgfxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HfrIjUhi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HfrIjUhi"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C34001F000FF;
	Mon,  5 Oct 2026 21:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791236763;
	bh=xg03A5vO0X7n25L+5UA/6YCefEXjs1h9wbW9K4266U4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HfrIjUhir6XkzbbM6lHH9Rxmsv+Gh9vtc9gd0BQp0jaLB5/fWz1c7spV6PWkBPn28
	 YAuMP8EG4+ONGJaiePR//Qu2lHx/zgZLfuBQZ37VcmPqB7h9ff1c+Qc0EYbN0FPKuj
	 fHbtDkbFYj32HJ3SlPBbp4a3USpY6maRBgDTPF1FLsK6rWgmaoox3mtvplB26QCIUb
	 wov30KCcPGroTEOp2lDiWQLByfbiGRZhntNQ4L6MZzYL6Cw4bws/2bGiDmKESQCwQp
	 wFm4VZ7yw7jGA95QgFScCQdHguW3KFKr3okoc7XKwU24jr/en3csGCdk7go4mVoTbe
	 5lztKpfXUjAuw==
Date: Mon, 5 Oct 2026 14:46:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/13] libxfs: remove the unused xfs_log_item.li_mountp
 field
Message-ID: <20261005214603.GK2705364@frogsfrogsfrogs>
References: <20261005125637.1340355-1-hch@lst.de>
 <20261005125637.1340355-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005125637.1340355-6-hch@lst.de>

On Mon, Oct 05, 2026 at 02:56:15PM +0200, Christoph Hellwig wrote:
> To prepare for reusing the kernel version of the struct.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libxfs/stubs/xfs_trans.h | 1 -
>  libxfs/trans.c           | 1 -
>  libxfs/util.c            | 1 -
>  3 files changed, 3 deletions(-)
> 
> diff --git a/libxfs/stubs/xfs_trans.h b/libxfs/stubs/xfs_trans.h
> index 9102bc6f5b27..9b6a47988147 100644
> --- a/libxfs/stubs/xfs_trans.h
> +++ b/libxfs/stubs/xfs_trans.h
> @@ -24,7 +24,6 @@ struct xfs_item_ops {
>  typedef struct xfs_log_item {
>  	struct list_head		li_trans;	/* transaction list */
>  	xfs_lsn_t			li_lsn;		/* last on-disk lsn */
> -	struct xfs_mount		*li_mountp;	/* ptr to fs mount */
>  	uint				li_type;	/* item type */
>  	unsigned long			li_flags;	/* misc flags */
>  	struct xfs_buf			*li_buf;	/* real buffer pointer */
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index c89b035ffeaf..9dd2e244a812 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -52,7 +52,6 @@ libxfs_trans_add_item(
>  	struct xfs_trans	*tp,
>  	struct xfs_log_item	*lip)
>  {
> -	ASSERT(lip->li_mountp == tp->t_mountp);
>  	ASSERT(lip->li_ailp == tp->t_mountp->m_ail);
>  	ASSERT(list_empty(&lip->li_trans));
>  	ASSERT(!test_bit(XFS_LI_DIRTY, &lip->li_flags));
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 6cbbe9056eba..2d8f57abd585 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -408,7 +408,6 @@ xfs_log_item_init(
>  	int			type,
>  	const struct xfs_item_ops *ops)
>  {
> -	item->li_mountp = mp; 
>  	item->li_type = type;
>  	item->li_ops = ops;
>  
> -- 
> 2.53.0
> 
> 
