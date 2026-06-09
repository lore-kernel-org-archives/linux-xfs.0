Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E221340A46
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2026 14:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781014636; cv=none; b=uda984oMs/lgqEcHGr8JW4cLBeubaPaV3I+EjeWNiLRpulqB6vwR90V3uJylepgcuFw5MzpVB8awHDpXCpc6p3kcxJckDOHPAJiv2+cMn/OmKXll08iFOPAm5g2uXx5vTuqLrgDpzRlA8BU+w0qZJ/0mQKqV/lRZwbYWWn1WS/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781014636; c=relaxed/simple;
	bh=ZID58UrOdfkQpBuY50WoJMIxB4nQF6sPi3VOYqSSWwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MEZXGP4GUZGDI70KJQZYHPnkXwHxNHyyhrhagVHELT/K20jLRTHxI8v+q/l9VmTTNfKR1hhPV8gzSjwpfrnf768+1oj/oWYECjTdY8AaXUJL1tX+u3vp4Wir5NwQrrmekL7s7vP83mdPOXv4XYQRUftiAmEqoeRN3FaMBPcX+ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PywtD85l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PywtD85l"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2EDC61F00893;
	Tue,  9 Jun 2026 14:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781014635;
	bh=pA2z3iz/F1Fiv4vvU/Y5nknZlNjQZspzgMyyU1g0SdI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PywtD85lNv+PA038Tc9wc1+xtbhAGAazAQUTH35gRY2ma3ZvkSkyGmff+lO+PADpG
	 30TtrSMpfqDH6YWtA+LNb02RZzJFnp+AMRBK8kS1mzExeX9r1payLXsD1e4RTcTKop
	 xvDOjq43VwkGUgGjW8qR4I0wkM3xFs9mEp7nEYXqzQtdCyyNfSO9HeBfKoAurUiNpM
	 yZ/sDtTAaPYFzHyQPScz5U4wXD4oYMzJb8RluB4zGrCFfk/k6/Qsub9gn4b99aoovS
	 DXzDWTFCyNJYm5PoKX1TMvPOYBuu1SYG63yfpX/8xT6wjzTJhM9GhWBxFzdTspQHV4
	 nvOxQwUYvo1MA==
Date: Tue, 9 Jun 2026 07:17:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: initialize iomap->flags earlier in xfs_bmbt_to_iomap
Message-ID: <20260609141714.GR6095@frogsfrogsfrogs>
References: <20260609075350.1698528-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609075350.1698528-1-hch@lst.de>

On Tue, Jun 09, 2026 at 09:53:44AM +0200, Christoph Hellwig wrote:
> Otherwise we lose the IOMAP_IOEND_BOUNDARY assingment for writes to the
> first block in a realtime group, and could cause incorrect merges for
> such writes.
> 
> Fixes: b91afef72471 ("xfs: don't merge ioends across RTGs")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense to me;

Cc: <stable@vger.kernel.org> # v6.13
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_iomap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index f20a02f49ed9..1403d568a442 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -113,6 +113,7 @@ xfs_bmbt_to_iomap(
>  		return xfs_alert_fsblock_zero(ip, imap);
>  	}
>  
> +	iomap->flags = iomap_flags;
>  	if (imap->br_startblock == HOLESTARTBLOCK) {
>  		iomap->addr = IOMAP_NULL_ADDR;
>  		iomap->type = IOMAP_HOLE;
> @@ -143,7 +144,6 @@ xfs_bmbt_to_iomap(
>  	}
>  	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
>  	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
> -	iomap->flags = iomap_flags;
>  	if (mapping_flags & IOMAP_DAX) {
>  		iomap->dax_dev = target->bt_daxdev;
>  	} else {
> -- 
> 2.53.0
> 
