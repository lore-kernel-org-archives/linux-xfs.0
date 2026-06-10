Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC663655D5;
	Wed, 10 Jun 2026 05:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781068366; cv=none; b=HRWa6JPmTBVZ2bOfEuaxsqIG4v0mvk3sLTsNstd+Sa0OaPIRoRI6wqork26t72KUhYASW3g1gemq4kPQRfPxaEIJTtdyYqdzU80gpAirmw+P/BFVB7Yhfpoiv0t1lFLg/T1fb+0dGJDO26LRU2rbg07JEwqiIq8ddwewIVGua+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781068366; c=relaxed/simple;
	bh=9deeTKqEK9tdY67dUFu1hzxQZLWT5qO78Hr/sO2Bv4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E5afYMjzOfqos5prHckyn+KhR4KCzpW1a1METRKCbz1GC/mGyeZRp6KpivMk8EmFkCPlpPHaMfxouWv1vw5Z35Kgxr2nQUI90ZT425Tto7mTN/DMfjklZMKGLNKCQwstiRbo5J0WgKHh1awnlaFIYZJotIfJGI5wfq9+GiDJcSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Crhd4uam; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Crhd4uam"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D87AA1F00893;
	Wed, 10 Jun 2026 05:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781068364;
	bh=wthpo5jxGmLosKXdG2K1WL/x1t1DqeEbvSzsayuuYZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Crhd4uamRkIE8/3VysyF9fGWCWkXOIQXtyQZhbt6n2KGPNXnyMXCB5VjKXV0irdaZ
	 aYGVGhvSq0lu7+tS1YeNgQCLxM07N/06KVBsbMYSBcdlhVh/QoBVyFHbBxA5OCSha0
	 4bus2Lk62S5fumx+AMKIZpVmtULeYVvxaKldy9Oj9AgLuOCDFiS3a2bYTJDDg8BsyR
	 /7E7sIEX5dlCKAts9LNhxjKD1cHB66RO+WewSOu/COOV7ogpQd04aAleRoSheN7Pwo
	 KQMKIGYJkWuvSHNnOSvu2qczHmbHfi08JjoyPD09Sxdom+p2GFVLBUlwavkKZo0Mpq
	 KL2/TotQC67cw==
Date: Tue, 9 Jun 2026 22:12:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yingjie Gao <gaoyingjie@uniontech.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] xfs: clean up attr intent recovery error paths
Message-ID: <20260610051244.GG6078@frogsfrogsfrogs>
References: <20260609111619.1866748-1-gaoyingjie@uniontech.com>
 <20260610022028.79846-1-gaoyingjie@uniontech.com>
 <20260610022028.79846-3-gaoyingjie@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610022028.79846-3-gaoyingjie@uniontech.com>

On Wed, Jun 10, 2026 at 10:20:28AM +0800, Yingjie Gao wrote:
> xfs_attr_recover_work() still uses a backward goto from out_cancel to
> out_unlock.

What's so bad about backwards gotos?

--D

> Restructure the cleanup labels into the same linear fallthrough style
> used by the neighboring bmap and exchmaps recovery helpers.  Initialize
> the local error variable to zero as those helpers do as well, which
> makes the shared return path easier to follow.
> 
> No functional change intended.
> 
> Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
> ---
>  fs/xfs/xfs_attr_item.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 841838bc1d0f..f8aa9dd80bb9 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -739,7 +739,7 @@ xfs_attr_recover_work(
>  	struct xfs_trans_res		resv;
>  	struct xfs_attri_log_format	*attrp;
>  	struct xfs_attri_log_nameval	*nv = attrip->attri_nameval;
> -	int				error;
> +	int				error = 0;
>  	unsigned int			total = 0;
>  
>  	/*
> @@ -789,14 +789,20 @@ xfs_attr_recover_work(
>  		goto out_cancel;
>  
>  	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
> +	if (error)
> +		goto out_unlock;
> +
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	xfs_irele(ip);
> +	return 0;
> +
> +out_cancel:
> +	xfs_trans_cancel(tp);
>  out_unlock:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  out_rele:
>  	xfs_irele(ip);
>  	return error;
> -out_cancel:
> -	xfs_trans_cancel(tp);
> -	goto out_unlock;
>  }
>  
>  /* Re-log an intent item to push the log tail forward. */
> -- 
> 2.20.1
> 
> 
