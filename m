Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802D823D28C
	for <linux-xfs@vger.kernel.org>; Sat,  5 Sep 2026 01:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788570680; cv=none; b=idQh5H0pHMdE+7DDIC9KrRgNYCuVD3n4QFIry1VfYM91MEud/wDfZ5X/gtDlRs16dhwy63nC0fihbmloGJyzqcyaFkaVCZf0EJ7GoCDPcYUKF4lGVhnGnlLjUd0lUY9ZK1N3eU0U7+V190+aE3sAL+xPqEThUvxZbkgkNR9xqGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788570680; c=relaxed/simple;
	bh=wKrvo5OvNZITE6PM8vGml3BER+WCPQhhb4qLpHc4Qss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d/5f5DPr13TiswJQmj36KbV7FKmxIXXptUMfapFkoTaCsuccvBQoA4ekjPVK455EfkhdpnQHW1sKWodOfGdxZrZraW+Bl59gQSHWrpXyaYotCLTamKzM7SclYmtCipCcVZupQ1VDpghEvAztuZwXPVX2oja/5STDbKxBJXHid1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HMfoasWB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HMfoasWB"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0A7C61F00A3D;
	Sat,  5 Sep 2026 01:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788570679;
	bh=mVjDga81LDaYXcQFIVZ/xC4E4JzpkG1Wu5XYBuWGryY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HMfoasWB86vpXjdF4vEEcUhsq4tiZGeoKJi4e9ArEWCgDeHZdgCLTkCOWLBo3NY+F
	 Qh7nkcVQ/MPWmybKl0PXwHUhVldZI00Q1ZNlOD5SLJ2igBtDmdF2B7zl9+hX6kkqAK
	 4XQXbm8IkhfvqzW+SVroNfj/UUKymSO4602SgctYpmCrlV/OVpiruN6s43cKW9hDO8
	 feiIAvW1QuNJ3SE62spg8B7znA2hj1XhgsxYkDRxKhc6AVu2aX6twVX0ByDUtICthm
	 TbQntw0NInro6Qkp2HXJZt/ctr14T83VV0BsyIH0OcDo43S/1A0RWTOeF+jFUL2zrW
	 2I7x8ppt7Pepg==
Date: Fri, 4 Sep 2026 18:11:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] xfs: make xfs_iomap_write_direct() report an
 error to xfs_trans_cancel
Message-ID: <20260905011118.GG1933798@frogsfrogsfrogs>
References: <20260904113231.1408890-1-cem@kernel.org>
 <20260904113231.1408890-4-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904113231.1408890-4-cem@kernel.org>

On Fri, Sep 04, 2026 at 01:32:23PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> I've been in the situation a few times where the transaction got
> cancelled by some reason. Most of time because bmapi_write failed and I
> start a guessing game trying to understand why.
> 
> So if xfs_iomap_write_direct fails and it causes the transaction to be
> cancelled, send the error to xfs_trans_cancel so the error gets logged
> into the kernel log buffer.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> Signed-off-by: Carlos Maiolino <cem@kernel.org>

Seems reasonable to me.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_iomap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index ff05e6b1b0bb..3d1a52757697 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -344,7 +344,7 @@ xfs_iomap_write_direct(
>  	return error;
>  
>  out_trans_cancel:
> -	xfs_trans_cancel(tp);
> +	xfs_trans_cancel(tp, error);
>  	goto out_unlock;
>  }
>  
> -- 
> 2.55.0
> 
> 
