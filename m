Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1CE14F13A
	for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2024 16:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724257271; cv=none; b=P18m26lS6u2jCRotzt2WjEygbIlqgJVeT+WNWiDCCl2dJwrYGrNB8+b0x7lZf3cc1iEdhzxv73sQDr7Z8nfo7WQpSjO9+OuXw5Uur9a/m9Z+TmLL9PKgmjwdJgI3jyoC4illi9xs49Kh0IkcbemeQrDrZiuGVtAB3P6DIH9M/Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724257271; c=relaxed/simple;
	bh=E1LqhyaI5OVrB0BQo+soThpgluOiPqpLqblkoYR9owE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aE6gTLjZRcPNam0skgiHO+H+a+f1W0qo3qgfZ4X0BqBqlBWnfBGMk74D0zy/NyTjH5Xo2TNZGSCy57PnvpWvVcP86/rFSK+wINwcE+qi4Lp9uRiUMw3PAFnK2Y6872YGQ38Y3c5HN+FWADm9YAnmczeRlD469QwURsrYrK/rvvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aByUsN3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aByUsN3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73961C32781;
	Wed, 21 Aug 2024 16:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724257270;
	bh=E1LqhyaI5OVrB0BQo+soThpgluOiPqpLqblkoYR9owE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aByUsN3NdCEvXJRgNzRW5gzobwNvzebMLNid+MvVEBoywVHTZk24icTfdcKj+Geaf
	 7v9trBTDXFjS2lHmX35XEfvHqKcdlj6sxDbA6NpB1Iajrb+VsUXfVKkt5FgfiAuBTk
	 icN5veMJQtCXK/iKrd9w1Dktiuzd3p+D5YC23CFrSoLdbwsol2Blt7XNJkiYEYPdR4
	 5O6Ml9hW33o56iJ+fkTsVIdpHDIxf6oyGzhdqtoGIFD7NI1+HvEacoFJ9HAKcIhNXo
	 3mYFWOse3sU1OZo8HuajdFLqoJU72PkGvMgJWK7vni3HCRgSuEEyKWj/JymEsnQZkP
	 N0u/rDsfgbKZg==
Date: Wed, 21 Aug 2024 09:21:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: chandan.babu@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH -next] xfs: use LIST_HEAD() to simplify code
Message-ID: <20240821162110.GD865349@frogsfrogsfrogs>
References: <20240821064355.2293091-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821064355.2293091-1-lihongbo22@huawei.com>

On Wed, Aug 21, 2024 at 02:43:55PM +0800, Hongbo Li wrote:
> list_head can be initialized automatically with LIST_HEAD()
> instead of calling INIT_LIST_HEAD().
> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_mru_cache.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
> index 7443debaffd6..d0f5b403bdbe 100644
> --- a/fs/xfs/xfs_mru_cache.c
> +++ b/fs/xfs/xfs_mru_cache.c
> @@ -230,9 +230,8 @@ _xfs_mru_cache_clear_reap_list(
>  		__releases(mru->lock) __acquires(mru->lock)
>  {
>  	struct xfs_mru_cache_elem *elem, *next;
> -	struct list_head	tmp;
> +	LIST_HEAD(tmp);
>  
> -	INIT_LIST_HEAD(&tmp);
>  	list_for_each_entry_safe(elem, next, &mru->reap_list, list_node) {
>  
>  		/* Remove the element from the data store. */
> -- 
> 2.34.1
> 
> 
