Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFCC204F80
	for <linux-xfs@vger.kernel.org>; Tue, 18 Mar 2025 12:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742299314; cv=none; b=OcKZQO4v951hea5T91t74NvsSBQDoE3wjoJRasPUQMJr2MV+nEJ262b5Pl/LzWZDJrNbHLjo3uxRGr+IDjMgEktHC47Tb6IZ30bujI0X17ovqiVAihPHig3D0KGmw8IY/gG1lfQDlA60Aac3giuRzVAS1KxyolQt3wU6HefAlpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742299314; c=relaxed/simple;
	bh=c8NxJnNLQLHuyv5Fr1I5n2oXXRNkJmF6r3IT6EbA22I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CnoDIBm3G5yShImpV4388GxNUZN+jtdCmrFO64vSY5OA3ak94IGpLJ58Rq5t6zL2IC3R1NfpqNpv1nNkAVpJNtMjvYeGAEOnV1HNHET2xL3vwaOXbx+9bcEmQ42XZXwJ1ZTtWGOR01u5POc2ymgB8Q8AS9E0KqL5/V+HZn1lYNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n4YgrMYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n4YgrMYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F47C4CEDD;
	Tue, 18 Mar 2025 12:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742299314;
	bh=c8NxJnNLQLHuyv5Fr1I5n2oXXRNkJmF6r3IT6EbA22I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n4YgrMYEFMzuXxHvk9WwXYWlSQyFWVnsRlyOcN6tkFqtgmayghc7BAb4Hpaz0tj4y
	 jP6fD77dZVLlEN0QtuU59iNVuAzwOfcNTG4eHq5Uwbr9mv+1dr9sDi/FQDgobiyA6X
	 sKDnnUXTEyYf23P8Le2Gh8IP9YBCVF5IISVLZtulAoKGCoV/+cMumO6rZl6yMCqKTm
	 jyq3RbnFZPmfQbQeA94BMDszf59cHyPGWEwjFQZgTDy39kv3AjVfXLYA4DjFHH/FuQ
	 CUFCGkvCE9leFNh4Sn3rK5GHstq7nIwH8yhTE/6ReyBPfgg/8/ADGDLe5cp7KIbPSE
	 cSl314Nsduowg==
Date: Tue, 18 Mar 2025 13:01:49 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: don't increment m_generation for all errors in
 xfs_growfs_data
Message-ID: <ew3j7xqbm4slq3rby4l6ovkbseli6sunhh4cv4bjrvb56szjs5@5b2ow5z5ofco>
References: <20250317054512.1131950-1-hch@lst.de>
 <ayM5uVocNmuaOG2kfyxd4JeGgP1DltqtupbIQRwUzv5rlDG-Z9IOknTsk18yKR1cZzGZPInj4MGKeRRHlErKpQ==@protonmail.internalid>
 <20250317054512.1131950-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250317054512.1131950-3-hch@lst.de>

On Mon, Mar 17, 2025 at 06:44:53AM +0100, Christoph Hellwig wrote:
> xfs_growfs_data needs to increment m_generation as soon as the primary
> superblock has been updated.  As the update of the secondary superblocks
> was part of xfs_growfs_data_private that mean the incremented had to be
> done unconditionally once that was called.  Later, commit 83a7f86e39ff
> ("xfs: separate secondary sb update in growfs") split the secondary
> superblock update into a separate helper, so now the increment on error
> can be limited to failed calls to xfs_update_secondary_sbs.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_fsops.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index d7658b7dcdbd..b6f3d7abdae5 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -311,20 +311,20 @@ xfs_growfs_data(
>  	/* we can't grow the data section when an internal RT section exists */
>  	if (in->newblocks != mp->m_sb.sb_dblocks && mp->m_sb.sb_rtstart) {
>  		error = -EINVAL;
> -		goto out_error;
> +		goto out_unlock;
>  	}
> 
>  	/* update imaxpct separately to the physical grow of the filesystem */
>  	if (in->imaxpct != mp->m_sb.sb_imax_pct) {
>  		error = xfs_growfs_imaxpct(mp, in->imaxpct);
>  		if (error)
> -			goto out_error;
> +			goto out_unlock;
>  	}
> 
>  	if (in->newblocks != mp->m_sb.sb_dblocks) {
>  		error = xfs_growfs_data_private(mp, in);
>  		if (error)
> -			goto out_error;
> +			goto out_unlock;
>  	}
> 
>  	/* Post growfs calculations needed to reflect new state in operations */
> @@ -338,13 +338,12 @@ xfs_growfs_data(
>  	/* Update secondary superblocks now the physical grow has completed */
>  	error = xfs_update_secondary_sbs(mp);
> 
> -out_error:
>  	/*
> -	 * Increment the generation unconditionally, the error could be from
> -	 * updating the secondary superblocks, in which case the new size
> -	 * is live already.
> +	 * Increment the generation unconditionally, after trying to update the
> +	 * secondary superblocks, as the new size is live already at this point.
>  	 */
>  	mp->m_generation++;
> +out_unlock:
>  	mutex_unlock(&mp->m_growlock);
>  	return error;
>  }
> --
> 2.45.2
> 
> 
