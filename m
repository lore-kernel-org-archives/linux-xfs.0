Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8D278F36
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 06:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736232543; cv=none; b=B0rURzdFrjX7mDEJf13vRdp2CmYRZ7EOL7rF2Ro0lsOBGESEEDLdSqyarP4Wk1zNUbq83wWLoHg0+yr56kIYVf8TAgGw+RxrdJTqHCRmGPntfssa644ZwnssvnTVzlm8U9ikwKhAMukPHywdetI9Oi5bG5SIX1+YbIYCn3qLp34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736232543; c=relaxed/simple;
	bh=xBKV0zti1CDnyN1GPbu/zYgP68vU5g8QLNGB8gEP1O4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hfh4F9JztVXoCQAne9WshADqH0N2M8Zf/6S5AnvP9SSWp9YgRPI9WRLoHALgXZ1Y1Yq94UZvlY5x0HmEovaGhDGMC2xY2gfdFHDzyFSNAjxCf6+g8c6KTHQnWMGbd6r9EH/kWP00VSQmmBQmhSibK70IY83DUEKbb2iml9n2wwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YZqneyQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YZqneyQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F730C4CED6;
	Tue,  7 Jan 2025 06:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736232543;
	bh=xBKV0zti1CDnyN1GPbu/zYgP68vU5g8QLNGB8gEP1O4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YZqneyQRKL+TQ1+3scnKRwM+1Pb7lAh1v0e+14/tW4W74i5y/k3PBPTP7Fxr8VVAJ
	 wCcPuThqwUEin9ZgAI8TfTt5rEIgmRP/14G7B/rgrhAGeNyrXYSdFYNOX2Vt1c5qse
	 z6P1lvexhlWx7pKRDKyyrCByzNbnUHIwfUoCWhL51niSObe053dBkmoYu/O9/Dk+50
	 1X6vJkfND6V1wFRtWhgxByhDZNRs64lMOH85RE5LtnE1Qs3zvFJ8+8l5U0eAkxwAoo
	 Gs/J6SBOWCd4kAEn1vwxmX9+t2c7N5FjGhC9mN3lvvphkZ5TGsJJarsOWBqN/vKKE3
	 tASZ3fkYXp2dg==
Date: Mon, 6 Jan 2025 22:49:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/15] xfs: simplify xfsaild_resubmit_item
Message-ID: <20250107064902.GD6174@frogsfrogsfrogs>
References: <20250106095613.847700-1-hch@lst.de>
 <20250106095613.847700-14-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106095613.847700-14-hch@lst.de>

On Mon, Jan 06, 2025 at 10:54:50AM +0100, Christoph Hellwig wrote:
> Since commit acc8f8628c37 ("xfs: attach dquot buffer to dquot log item
> buffer") all buf items that use bp->b_li_list are explicitly checked for
> in the branch to just clears XFS_LI_FAILED.  Remove the dead arm that
> calls xfs_clear_li_failed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense to me
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_trans_ail.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index f56d62dced97..0fcb1828e598 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -359,13 +359,8 @@ xfsaild_resubmit_item(
>  	}
>  
>  	/* protected by ail_lock */
> -	list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
> -		if (bp->b_flags & (_XBF_INODES | _XBF_DQUOTS))
> -			clear_bit(XFS_LI_FAILED, &lip->li_flags);
> -		else
> -			xfs_clear_li_failed(lip);
> -	}
> -
> +	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
> +		clear_bit(XFS_LI_FAILED, &lip->li_flags);
>  	xfs_buf_unlock(bp);
>  	return XFS_ITEM_SUCCESS;
>  }
> -- 
> 2.45.2
> 
> 
