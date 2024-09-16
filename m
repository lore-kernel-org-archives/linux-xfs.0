Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E65F15C131;
	Mon, 16 Sep 2024 17:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726506003; cv=none; b=VHERdmRMYdmStAYtZE/boXwB0thO/1vKmWOE5akA34/fRPp+/UuYDXhuWeIokKi067Gy/i5eeV9FRMIaj+RHHjOg5SpgStWcHSDU272IPXCahpH9831FdZpJxhbdO3uOzfwkz3ovWq3vEMBPj3s+/g4xIEWHYDiQBnIvzpNqB34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726506003; c=relaxed/simple;
	bh=ew8oQq/nz6HxP0olXdi/A44nsKtJE+CIblDAvkOzwTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=axmxKj+BGKjb8KupCmXg7rM+A5Vhg2BEUnyFZ7ItYvsl/yZSOKB2ibR7ExtVo7GbSihl+66GbYDB9XoWvTbQgEVdgTe8qzrJNx6Sa9PPY+yivsCpUDKCjAS9hy5c0gBjjN6wirrFZZmukB+amxO6y0z8b62kAWKnqjtOxsvS6/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zjj/mr2N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zjj/mr2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F08C4CEC4;
	Mon, 16 Sep 2024 17:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726506002;
	bh=ew8oQq/nz6HxP0olXdi/A44nsKtJE+CIblDAvkOzwTk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zjj/mr2NUg1R114wdKahthiMRrOjc85PfWMTh9KEi+bnMpeyiy58l3ua1SwH+vLSH
	 dKgzZorxGVwqmiVS72f1N0ndxQ2T6emwG+4tsgNqmHwI1jfXW/zZV/pKoFkCPu2wiu
	 mFPPdiuUD5d+zYLS3TzVnBTn6Ym58AxH56cAO5NxNmPsJrwV6eTWGe4cJoXjC5lU39
	 HOymrsplClEON4WZynNgnQAFbXaysQqWvQHtDZt7uZvLWFNsXlAXB+BjFfwhLXf9Qy
	 +HxCGi1xPJbAs3aRFMHFdXSRZZv3i0xfUy5wMSbgfREe7UH9gLdgaAzjgXVnmYGRb3
	 uc7sAnry+YCBA==
Date: Mon, 16 Sep 2024 10:00:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yan Zhen <yanzhen@vivo.com>
Cc: chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, opensource.kernel@vivo.com
Subject: Re: [PATCH v1] xfs: scrub: convert comma to semicolon
Message-ID: <20240916170001.GC182194@frogsfrogsfrogs>
References: <20240910122842.3269966-1-yanzhen@vivo.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910122842.3269966-1-yanzhen@vivo.com>

On Tue, Sep 10, 2024 at 08:28:42PM +0800, Yan Zhen wrote:
> Replace a comma between expression statements by a semicolon.
> 
> Signed-off-by: Yan Zhen <yanzhen@vivo.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/ialloc_repair.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
> index a00ec7ae1..c8d2196a0 100644
> --- a/fs/xfs/scrub/ialloc_repair.c
> +++ b/fs/xfs/scrub/ialloc_repair.c
> @@ -657,7 +657,7 @@ xrep_ibt_build_new_trees(
>  	 * Start by setting up the inobt staging cursor.
>  	 */
>  	fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.pag->pag_agno,
> -			XFS_IBT_BLOCK(sc->mp)),
> +			XFS_IBT_BLOCK(sc->mp));
>  	xrep_newbt_init_ag(&ri->new_inobt, sc, &XFS_RMAP_OINFO_INOBT, fsbno,
>  			XFS_AG_RESV_NONE);
>  	ri->new_inobt.bload.claim_block = xrep_ibt_claim_block;
> @@ -678,7 +678,7 @@ xrep_ibt_build_new_trees(
>  			resv = XFS_AG_RESV_NONE;
>  
>  		fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.pag->pag_agno,
> -				XFS_FIBT_BLOCK(sc->mp)),
> +				XFS_FIBT_BLOCK(sc->mp));
>  		xrep_newbt_init_ag(&ri->new_finobt, sc, &XFS_RMAP_OINFO_INOBT,
>  				fsbno, resv);
>  		ri->new_finobt.bload.claim_block = xrep_fibt_claim_block;
> -- 
> 2.34.1
> 
> 
