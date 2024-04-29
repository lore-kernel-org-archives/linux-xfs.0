Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD3482C6B
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 15:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714406029; cv=none; b=p3ZOhddY6KrOIm92kTrNV8UlUnHiXx/AV/9FEDICfSF1BAGyjbGaq/j3yV7wSnpj9QQNS5V0rhOHlew+7pJ2+ueyX7Y/NtDXb33vUq0CvNcWBNq2y+13M19N7swAeioQwBHBO1IQueSJxGezVJaTlXsOfMSSdhjrCF5/de8EXDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714406029; c=relaxed/simple;
	bh=bNAitwID/5AyO0CSuVP8+i673JQRyF8LeOBVjM42JX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CsY4biiryeQsgtRSk5aj3zR+wiKCUckfMOsIr+WP7s6bepuOszzzE9q6esGlsppOCyT+E/hWMlsTQMONp2R9XUGIDkDpCzd9wbfiVsYJoZYk74OzP4AiEfK2iqlvDV9l9xw2eWN01MUQ5To6kfdFn3fSce13oLH2J/ObaVMFdzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QfWr2Nvy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QfWr2Nvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A47C4AF1D;
	Mon, 29 Apr 2024 15:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714406028;
	bh=bNAitwID/5AyO0CSuVP8+i673JQRyF8LeOBVjM42JX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QfWr2NvySyXfmmUclxmB7msj+353iQ+kufLdsa28tB//i1o7Gp01RPzhTMcS7Pthw
	 k0x6aQeUJ//Qxzf7ZMnVexE4YnxZFX7gTADFFj6DAXYOaek8KLs7F7fGiTaH7KzxDO
	 Q1imuK8HDKJ4wyEZ1fNXk/jzLP9LFWvSZ11kcvvX2H8+WaC72cP9zxipTg2Yzy8Crk
	 pN17PF1S6rwo+KFYlV8Jwhgms48ZzIID2FcziUaxGBcepWKvZbBFloT9W9uow61Zcq
	 USfSojGYLcMk8bD7MQG1g/nQzhsqcNidMUUs7B0ug0eqYpv/QD64fyIKOaBynGVMII
	 f6yNub12OYylQ==
Date: Mon, 29 Apr 2024 08:53:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Brian Foster <bfoster@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Sam Sun <samsun1006219@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: fix log recovery buffer allocation for the
 legacy h_size fixup
Message-ID: <20240429155348.GD360919@frogsfrogsfrogs>
References: <20240429070200.1586537-1-hch@lst.de>
 <20240429070200.1586537-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429070200.1586537-2-hch@lst.de>

On Mon, Apr 29, 2024 at 09:01:58AM +0200, Christoph Hellwig wrote:
> Commit a70f9fe52daa ("xfs: detect and handle invalid iclog size set by
> mkfs") added a fixup for incorrect h_size values used for the initial
> umount record in old xfsprogs versions.  But it is not using this fixed
> up value to size the log recovery buffer, which can lead to an out of
> bounds access when the incorrect h_size does not come from the old mkfs
> tool, but a fuzzer.
> 
> Fix this by open coding xlog_logrec_hblks and taking the fixed h_size
> into account for this calculation.
> 
> Fixes: a70f9fe52daa ("xfs: detect and handle invalid iclog size set by mkfs")

Modulo what bfoster said about the tagging,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> Reported-by: Sam Sun <samsun1006219@gmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log_recover.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index b445e8ce4a7d21..bb8957927c3c2e 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2999,7 +2999,7 @@ xlog_do_recovery_pass(
>  	int			error = 0, h_size, h_len;
>  	int			error2 = 0;
>  	int			bblks, split_bblks;
> -	int			hblks, split_hblks, wrapped_hblks;
> +	int			hblks = 1, split_hblks, wrapped_hblks;
>  	int			i;
>  	struct hlist_head	rhash[XLOG_RHASH_SIZE];
>  	LIST_HEAD		(buffer_list);
> @@ -3055,14 +3055,22 @@ xlog_do_recovery_pass(
>  		if (error)
>  			goto bread_err1;
>  
> -		hblks = xlog_logrec_hblks(log, rhead);
> -		if (hblks != 1) {
> -			kvfree(hbp);
> -			hbp = xlog_alloc_buffer(log, hblks);
> +		/*
> +		 * This open codes xlog_logrec_hblks so that we can reuse the
> +		 * fixed up h_size value calculated above.  Without that we'd
> +		 * still allocate the buffer based on the incorrect on-disk
> +		 * size.
> +		 */
> +		if (h_size > XLOG_HEADER_CYCLE_SIZE &&
> +		    (rhead->h_version & cpu_to_be32(XLOG_VERSION_2))) {
> +			hblks = DIV_ROUND_UP(h_size, XLOG_HEADER_CYCLE_SIZE);
> +			if (hblks > 1) {
> +				kvfree(hbp);
> +				hbp = xlog_alloc_buffer(log, hblks);
> +			}
>  		}
>  	} else {
>  		ASSERT(log->l_sectBBsize == 1);
> -		hblks = 1;
>  		hbp = xlog_alloc_buffer(log, 1);
>  		h_size = XLOG_BIG_RECORD_BSIZE;
>  	}
> -- 
> 2.39.2
> 
> 
