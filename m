Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D483793CE
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 13:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782135303; cv=none; b=OOwUgAU1TSt5H+ouhe96LkwBVxra++Fn469jogWTgPOiXV+GOe4CLClhRvsxC4ttLWOfH9y9N4RpmssifkZ/rxrJA6blQPsSIq/fgD7WgnnQn9cGUOV5bTMBX8DBd3Xs8+DBk4S/o6sh2zJteZ5V0qgKfVMvnye1im0f/qzogNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782135303; c=relaxed/simple;
	bh=HZuJAW2lpNwPcrWzGOwUGsfgdRl+ne/sxjc9u/+Pkbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lIfRBFiNFyprlKCtK8yF65oc/LrZieVhRp2vWGTiBAh0MB998WAZ4/KHE+fq+t+zTHo7onWLQTlSBM1zY1DFSM6O0AG/xWxgV9EM932RwO1GcRrDP/niqh8NOYp2CE4lPgQKLNRekoJaX7Ygio6QpH6jWR9l6sOEcSdBZve4d1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PjY7iXDM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PjY7iXDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6801F000E9;
	Mon, 22 Jun 2026 13:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782135302;
	bh=tFBjVZL+InvawuV12+7OpMJUKIUjl+7CbEQHD540Gxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PjY7iXDM1+rYcN5dL/2yimkcdnAHDO/nrVowo/mfZJrhZlR+78wHkbik1N/JfP9mr
	 6CBO7QcVKNu8jP6KPY5BNpNa4edNPCyXmI8byuNmkuXKowWAup8cfI7Zs1K7SPbRyt
	 HxohoEJDWBwhyf/6zsDuNad9cYD5NJgpXo4/SAYjSe2q8yVKdvbBQ+MCiF+8zmBTHD
	 GjdHIxTxA3miLqKKetJDzCSwtPksTFAxmS6++v/tbf1z1iQSIRJtomhYxSRQTalzA4
	 +KWVvQvqosr4brbnHEyMcPazz4wzNWXOSmVRzkXFF0KvrZKHSq+dbr2YGIHsxggm/p
	 +ZVW2ebi9iXWw==
Date: Mon, 22 Jun 2026 15:34:56 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: fix handling of synchronous errors in
 xfs_buf_submit
Message-ID: <ajk2TZSv4ivAkM0Q@nidhogg.toxiclabs.cc>
References: <20260622073035.1370904-1-hch@lst.de>
 <20260622073035.1370904-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622073035.1370904-6-hch@lst.de>

On Mon, Jun 22, 2026 at 09:30:04AM +0200, Christoph Hellwig wrote:
> Synchronous readers and writers already run __xfs_buf_ioend from
> xfs_buf_iowait after being woken through bp->b_iowait, so we
> should not call it here, which can lead to double completions.

Makes sense

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> 
> Fixes: 4b90de5bc0f5 ("xfs: reduce context switches for synchronous buffered I/O")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 651add22deea..ffaab0feb230 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1403,12 +1403,12 @@ xfs_buf_submit(
>  	bp->b_flags &= ~XBF_DONE;
>  	xfs_buf_stale(bp);
>  end_io:
> -	if (!__xfs_buf_ioend(bp))
> -		return;
> -	if (bp->b_flags & XBF_ASYNC)
> -		xfs_buf_relse(bp);
> -	else
> +	if (bp->b_flags & XBF_ASYNC) {
> +		if (__xfs_buf_ioend(bp))
> +			xfs_buf_relse(bp);
> +	} else {
>  		complete(&bp->b_iowait);
> +	}
>  }
>  
>  /*
> -- 
> 2.53.0
> 
> 
