Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D2D2ED14E
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 21:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760563233; cv=none; b=L71B0zCV/7HhrXykfPBs37NIUEUwCwTJdxQZoqc27faPgCtNwzSCu6pxscGBMF9qTkjH0MVZraNXLUickmGCw1fPCgT7ye+O7LVjJz7Rfn7OsRzjcbnoNO4zxo1rm7afNSNOB7wFfYIWQpSLrzdELM7o9woshq09JN2VAyBzFk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760563233; c=relaxed/simple;
	bh=TyzW/9ZjJGvmZ4GsBCBj9w4l4SC+rpJe9t0FBRUTtdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ajLi2eKIvgtelcjPjplUSNhVK3qy7FuNi+TaHTPcrhpKIEV9XbrX1Dl1x+wOBie8WxInY0A9lwKUVZeLOxvHHsMf7sXoaqU4MPDK0/oygMpPQA2gESOZMmOCzEPc8MIWCgjKIXdzMpta9HlIbHl85X9s21+PHUmWjW4+8YezS40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iNGr9Waz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iNGr9Waz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D389EC4CEF8;
	Wed, 15 Oct 2025 21:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760563232;
	bh=TyzW/9ZjJGvmZ4GsBCBj9w4l4SC+rpJe9t0FBRUTtdo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iNGr9WazRX1mg6PIn8/q4XXo7GGvYa89vwK7r0TOkcFBXFUy0CJ0XAokOgGfp+FUf
	 VdcMZr/KQHQQWPP1pCcacolP39cy41Xeh9i14s08XBI2rO2zSB37fIqyDIRh0vTaEC
	 jed7khCILI3eMr0kXT8tnhhVaGGgSnzquDWhG+NRoeAqYXT8B8m2z2mAKXjEnspBQY
	 f0TVB8lYnlPJHFMG/iRXer8lFO5Yyae0R29npssT/XNgcJMCzmPckz7ii5QZvO57Fd
	 3cY84Frf/L8LLiwqzMHL6JOQ7T+9LTWZ+lInqzgRUhYGloZhGCbXFUp5U8eRdgSxRq
	 jF2IlvROXkLZg==
Date: Wed, 15 Oct 2025 14:20:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/17] xfs: move q_qlock acquisition into
 xqcheck_commit_dquot
Message-ID: <20251015212032.GK2591640@frogsfrogsfrogs>
References: <20251013024851.4110053-1-hch@lst.de>
 <20251013024851.4110053-16-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024851.4110053-16-hch@lst.de>

On Mon, Oct 13, 2025 at 11:48:16AM +0900, Christoph Hellwig wrote:
> This removes a pointless roundtrip because xqcheck_commit_dquot has to
> drop the lock for allocating a transaction right now.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Ohhhh this looks so much better!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/quotacheck_repair.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/scrub/quotacheck_repair.c b/fs/xfs/scrub/quotacheck_repair.c
> index de1521739ec9..942df94e1215 100644
> --- a/fs/xfs/scrub/quotacheck_repair.c
> +++ b/fs/xfs/scrub/quotacheck_repair.c
> @@ -52,13 +52,11 @@ xqcheck_commit_dquot(
>  	bool			dirty = false;
>  	int			error = 0;
>  
> -	/* Unlock the dquot just long enough to allocate a transaction. */
> -	mutex_unlock(&dq->q_qlock);
>  	error = xchk_trans_alloc(xqc->sc, 0);
> -	mutex_lock(&dq->q_qlock);
>  	if (error)
>  		return error;
>  
> +	mutex_lock(&dq->q_qlock);
>  	xfs_trans_dqjoin(xqc->sc->tp, dq);
>  
>  	if (xchk_iscan_aborted(&xqc->iscan)) {
> @@ -150,7 +148,6 @@ xqcheck_commit_dqtype(
>  	 */
>  	xchk_dqiter_init(&cursor, sc, dqtype);
>  	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
> -		mutex_lock(&dq->q_qlock);
>  		error = xqcheck_commit_dquot(xqc, dqtype, dq);
>  		xfs_qm_dqrele(dq);
>  		if (error)
> @@ -182,7 +179,6 @@ xqcheck_commit_dqtype(
>  		if (error)
>  			return error;
>  
> -		mutex_lock(&dq->q_qlock);
>  		error = xqcheck_commit_dquot(xqc, dqtype, dq);
>  		xfs_qm_dqrele(dq);
>  		if (error)
> -- 
> 2.47.3
> 
> 
