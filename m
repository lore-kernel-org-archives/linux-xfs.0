Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03B0236FB6
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 09:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733910181; cv=none; b=Gnhxr8oSTwD66F37uHGxs4ekzuju0JbqaOQBapB/sNQUHnvBOo0HSlB7IJMCH3BXYOQ4auM8oduQMboWpBXY4xmXlCaV4EMv1XtU22hI8HYA3QN7cLNHjXZEJOjyxqq4+XwJhgru2hF1PuW/MPK7OatNZq7FGT63Xx9JG8GdcjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733910181; c=relaxed/simple;
	bh=KEH1H5677Ja4sv2pUMvOi0VNIuYC/QJP7O7SoB63LbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jF8+rp9qvK/BWFhGGUOF7BttO661CjWqiMcp7OtsV8vgZy751+RCppsJJhK+B1oSr8EzbWKAv0REAjp6GBfPmWLt2Y6BX1dKmuZ4HocZ3+G7sbXvgv23IEtJhIZ74rzhsTLosZa5buw6/Xd2cLoFmUwfd/XhKArYkCVbKr83V7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qNnMhfVL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qNnMhfVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC958C4CED2;
	Wed, 11 Dec 2024 09:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733910181;
	bh=KEH1H5677Ja4sv2pUMvOi0VNIuYC/QJP7O7SoB63LbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qNnMhfVLR6V5LqdU0Wzkyoz3+x5DzEqNa9f48/LVCfLrdUxZqoqeYykH0N17EiXLp
	 dQZo/bvcHjXT+0SnLj1UP24Uz8skaXoBGMV0lpVos7TbESVi8YRdbujrwvE5MCodB9
	 qaK2qCR07B4gk99WBgWWH3/OzgQZQQmqPhWmUmwV6LTxa+PKyoiqZE5iY1Kc5lm67y
	 NDMl6VZkGJ8ZvtTbOrVov0I2+NHki4x33btMHaNVfFybdmym5BHJmbDxJ1XGFylXxd
	 T1QipVTcwX81Dzmn9d1NM4+Y1jQ16Kvh+soK7j2m+Pq77qHr7HjKRK7tnLiBzzRXN+
	 XCtWyToryc4ww==
Date: Wed, 11 Dec 2024 10:42:56 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, 
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] xfs: fix !quota build
Message-ID: <yqgip2p2p5jrh5amvtfdetdv3x7do2ra4uknj53h2mel2423cj@lpewtpl3q2tt>
References: <20241211035433.1321051-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211035433.1321051-1-hch@lst.de>

On Wed, Dec 11, 2024 at 04:54:32AM +0100, Christoph Hellwig wrote:
> fix the !quota stub for xfs_trans_apply_dquot_deltas.
> 
> Fixes: 03d23e3ebeb7 ("xfs: don't lose solo dquot update transactions")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_quota.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index b864ed597877..d7565462af3d 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -173,7 +173,7 @@ static inline void xfs_trans_mod_dquot_byino(struct xfs_trans *tp,
>  		struct xfs_inode *ip, uint field, int64_t delta)
>  {
>  }
> -#define xfs_trans_apply_dquot_deltas(tp, a)
> +#define xfs_trans_apply_dquot_deltas(tp)
>  #define xfs_trans_unreserve_and_mod_dquots(tp, a)
>  static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp,
>  		struct xfs_inode *ip, int64_t dblocks, int64_t rblocks,

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> -- 
> 2.45.2
> 
