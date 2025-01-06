Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D5F360;
	Mon,  6 Jan 2025 19:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736193112; cv=none; b=PmLmqBa6+OFxSx9+KG/mcITPnwxRqfUnH38bmW1bw+QyV7uCWX7noVyjaoX+Whga2GuoDSpg+Blv5qW9TW5z9xX5u4aVhUcF5jWcY1jFTmcZs/22lxkZgKHUL+lrYRmCdOgpW88iu2rORYgg4vUjiFY8s2uDZDL3I49tythoS9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736193112; c=relaxed/simple;
	bh=xN9DQ9jpv1AM9xVNQja0Eha6rNg7yiQbDsn3FehN33o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dowjJWGmDZalGzAOC/h2yMBOBHUaySV/ThLKvYTL10TjPPgH0Gw5TmOxMSk4E30UJA2XQyTegW+GqUjWoNBCir6uk3LK9o4p3oh8dCM8pmuGP4+dKaCxfmWW6rfOoPEIf/+ILe/NV6h2vQxlg3FLzBQGEgN/aVCdai1lU8LJ2Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EWXb7sV9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EWXb7sV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2832C4CED2;
	Mon,  6 Jan 2025 19:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736193111;
	bh=xN9DQ9jpv1AM9xVNQja0Eha6rNg7yiQbDsn3FehN33o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EWXb7sV9ytR6qZBAPceq6/7ohZwjb04tW/JkwOUjJhVuSkMFE5UhjgdpINhfo0KJA
	 PXdRg6k4IL4hy2/BOdKM9N5Xr2Bk9uGnhoonrxNUYbm4JoA8EW2J4Y6SVYux7Z5MVZ
	 fkXDR62r2twMCtCpvRtg+Y/mjQ0wD6dVgWOkfKd7n4T14QsbLaqJeaA78jmr+yyVtf
	 ySw3Tm39+ajsBOuz+9//wR3QeLy4pBE+MkFpLxT3LYGgPBmYCuoKMJYgNM1dvqZu03
	 S+TcvkYtCoswi3QPTO6DkOQ1rkOWzfcdq8wg+pnevB5jRtlb1iK+3CAZDk16BRb3Ob
	 HI/lbWxf6XZlQ==
Date: Mon, 6 Jan 2025 11:51:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pei Xiao <xiaopei01@kylinos.cn>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] xfs: Use refcount_t instead of atomic_t for xmi_refcount
Message-ID: <20250106195151.GJ6174@frogsfrogsfrogs>
References: <4236d961cf3dd2413cebd56619d0f5927c8e749a.1735542858.git.xiaopei01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4236d961cf3dd2413cebd56619d0f5927c8e749a.1735542858.git.xiaopei01@kylinos.cn>

On Mon, Dec 30, 2024 at 03:18:16PM +0800, Pei Xiao wrote:
> Use an API that resembles more the actual use of xmi_refcount.
> 
> Found by cocci:
>     fs/xfs/xfs_exchmaps_item.c:57:5-24: WARNING: atomic_dec_and_test
> variation before object free at line 58.
> 
> Fixes: 6c08f434bd33 ("xfs: introduce a file mapping exchange log intent item")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202412260634.uSDUNyYS-lkp@intel.com/
> Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>

What has changed since
https://lore.kernel.org/linux-xfs/1508497678-10508-1-git-send-email-elena.reshetova@intel.com/
and if something has, why wouldn't you apply atomic_t -> refcount_t for
/all/ the log intent item types?

--D

> ---
>  fs/xfs/xfs_exchmaps_item.c | 6 +++---
>  fs/xfs/xfs_exchmaps_item.h | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_exchmaps_item.c b/fs/xfs/xfs_exchmaps_item.c
> index 264a121c5e16..5975a16c54e3 100644
> --- a/fs/xfs/xfs_exchmaps_item.c
> +++ b/fs/xfs/xfs_exchmaps_item.c
> @@ -57,8 +57,8 @@ STATIC void
>  xfs_xmi_release(
>  	struct xfs_xmi_log_item	*xmi_lip)
>  {
> -	ASSERT(atomic_read(&xmi_lip->xmi_refcount) > 0);
> -	if (atomic_dec_and_test(&xmi_lip->xmi_refcount)) {
> +	ASSERT(refcount_read(&xmi_lip->xmi_refcount) > 0);
> +	if (refcount_dec_and_test(&xmi_lip->xmi_refcount)) {
>  		xfs_trans_ail_delete(&xmi_lip->xmi_item, 0);
>  		xfs_xmi_item_free(xmi_lip);
>  	}
> @@ -138,7 +138,7 @@ xfs_xmi_init(
>  
>  	xfs_log_item_init(mp, &xmi_lip->xmi_item, XFS_LI_XMI, &xfs_xmi_item_ops);
>  	xmi_lip->xmi_format.xmi_id = (uintptr_t)(void *)xmi_lip;
> -	atomic_set(&xmi_lip->xmi_refcount, 2);
> +	refcount_set(&xmi_lip->xmi_refcount, 2);
>  
>  	return xmi_lip;
>  }
> diff --git a/fs/xfs/xfs_exchmaps_item.h b/fs/xfs/xfs_exchmaps_item.h
> index efa368d25d09..b8be3bca3155 100644
> --- a/fs/xfs/xfs_exchmaps_item.h
> +++ b/fs/xfs/xfs_exchmaps_item.h
> @@ -38,7 +38,7 @@ struct kmem_cache;
>   */
>  struct xfs_xmi_log_item {
>  	struct xfs_log_item		xmi_item;
> -	atomic_t			xmi_refcount;
> +	refcount_t			xmi_refcount;
>  	struct xfs_xmi_log_format	xmi_format;
>  };
>  
> -- 
> 2.25.1
> 
> 
