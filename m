Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD123F9E0
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 03:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712116137; cv=none; b=CEUf1knat9zNnTfUvAt8Dm3euvmXWr/slmjGHFKi7z2B9tUTLy9dacNrTHvBxkEEQ55w4We8qAve45C6MZtZNX79AuxivLw5pEYlfddTmKN6W3qmgBVRNSspilX7S5d133Ty1Fletwb2KSpu6kcsCzNMg80GIB/bLOK8SH3c/pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712116137; c=relaxed/simple;
	bh=MZ7motSjNR6nlRh690DLhPjRLRjTjHiKCh8BKXGf83g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mJGb7zLf0Trgn/cPlOsuqFIc1785PUTZoX8xDqeA8R/1eXrjEi3gCRpKnjVU5KNrzNzhIo2egY97ktiUVTZSfs/VuBt5kRL0L37ilhFTcgcJv4fjih5HLE4B6Qmr7OcPCpZRHpNREmDmgl/OiMpXuXAAK4B6fcPcuLcJ40DlThw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mwvOXUSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mwvOXUSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CBDC433C7;
	Wed,  3 Apr 2024 03:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712116136;
	bh=MZ7motSjNR6nlRh690DLhPjRLRjTjHiKCh8BKXGf83g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mwvOXUSbzKCWHlZhLfqNtu5DyljfbEQaOurqnwi1eVF52s+/qNt0y7gomNmSmAd07
	 BVrgnDr9k0YNL0IW31alVhjldOg4MzvErcIGmPEfm9GRj6xB8OKX9Qiy8t/0eW4v8x
	 bRLKArP6rQOFExBB8HBlf6XsjqRgOwZlIu2y45AEzDGs1ysylGGC22VPBxDY7oQBYk
	 v/4KrYxgU2B8+oqFzmIuhHwtdanJo5O5lEHtDj8J9aOEzClApEDwJ4Q5jkCyZt/6/T
	 ry+VusInFloKsevyPKzJU954W0rrn0VCpfcPLSQLjyAttSouAvUDGct8mq56iZW2nu
	 noMDd/bACV4dw==
Date: Tue, 2 Apr 2024 20:48:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH 3/4] xfs: handle allocation failure in
 xfs_dquot_disk_alloc()
Message-ID: <20240403034856.GK6390@frogsfrogsfrogs>
References: <20240402221127.1200501-1-david@fromorbit.com>
 <20240402221127.1200501-4-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402221127.1200501-4-david@fromorbit.com>

On Wed, Apr 03, 2024 at 08:38:18AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If free space accounting is screwed up, then dquot allocation may go
> ahead when there is no space available. xfs_dquot_disk_alloc() does
> not handle allocation failure - it expects that it will not get
> called when there isn't space available to allocate dquots.
> 
> Because fuzzers have been screwing up the free space accounting, we
> are seeing failures in dquot allocation, and they aren't being
> caught on produciton kernels. Debug kernels will assert fail in this
> case, so turn that assert fail into more robust error handling to
> avoid these issues in future.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Sounds fine to me!  It'll be interesting to see what happens the next
time one of my VMs trips this.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_dquot.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index c98cb468c357..a2652e3d5164 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -356,6 +356,23 @@ xfs_dquot_disk_alloc(
>  	if (error)
>  		goto err_cancel;
>  
> +	if (nmaps == 0) {
> +		/*
> +		 * Unexpected ENOSPC - the transaction reservation should have
> +		 * guaranteed that this allocation will succeed. We don't know
> +		 * why this happened, so just back out gracefully.
> +		 *
> +		 * We commit the transaction instead of cancelling it as it may
> +		 * be dirty due to extent count upgrade. This avoids a potential
> +		 * filesystem shutdown when this happens. We ignore any error
> +		 * from the transaction commit - we always return -ENOSPC to the
> +		 * caller here so we really don't care if the commit fails for
> +		 * some unknown reason...
> +		 */
> +		xfs_trans_commit(tp);
> +		return -ENOSPC;
> +	}
> +
>  	ASSERT(map.br_blockcount == XFS_DQUOT_CLUSTER_SIZE_FSB);
>  	ASSERT(nmaps == 1);
>  	ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
> -- 
> 2.43.0
> 
> 
