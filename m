Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4E181745
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 15:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714406180; cv=none; b=NyabQmnX1KlaKY7lvDCNPXI366fsY/szAfdhg04GOFzBvSuHS5ic1NQ4rIAdI+bmnFfwU579BVGSkO/Rmx3NiEwuzb+0pk1Q7XzlWuafs28BLFszm+UnmBbQ7Ar9nL+eHajRjWozTWLT30DLamr/K1Me2oPfVPij3uAgE5Hdpkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714406180; c=relaxed/simple;
	bh=jEksKuMnOgRllx3V4EOZrWI79f+C37ryoG+R/Oq/q6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YzcoJzVT7JOTNUY/VbtqOk0C2esTuTt9JJhNGbWSa/kD1Z+FKIk3bpR6PA58k+D/l6KS3E6Xo3tREwRBoKnGNsT2R/A1E497L53YbvWl/eQjHgY2pjhnclPB+73j/V1oRKrg2N55YC+Ld86dYyOYLnDK0QoW2GDehM3dOADTwRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hj5lI46O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hj5lI46O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25714C113CD;
	Mon, 29 Apr 2024 15:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714406180;
	bh=jEksKuMnOgRllx3V4EOZrWI79f+C37ryoG+R/Oq/q6g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hj5lI46O5jlQuUWhsCXgVNcWh1YzSU/kXO5/gxYmPj33QDbWRRfiw81EHeWxwszAi
	 M9FO2U+8udOMaUJA47um4dxa6+Y+uKXFQQGoo0Xznd19ZOw9gMXuDFY5iinf4CPR9F
	 cqxqsWacbMBZvMFq4HG39m+I/gRqaUd3iZmsycXfV2Gr/Zn7I1ZufjyGmUPPHHOjYK
	 Dd4Z10SkqQfomJlepemSsVnT66TqjTAU3IQxLkm3H9HTqUnhw6JUoqy5YSy0XJcZES
	 cTZI2fikqsTgWNYJXJeTYqbUPv5of1fHq9msjxbkXLF3SBNRFJ9suz/Wdl1jCswy84
	 dZhuiQ4aCuLzg==
Date: Mon, 29 Apr 2024 08:56:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Brian Foster <bfoster@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Sam Sun <samsun1006219@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: clean up buffer allocation in
 xlog_do_recovery_pass
Message-ID: <20240429155619.GF360919@frogsfrogsfrogs>
References: <20240429070200.1586537-1-hch@lst.de>
 <20240429070200.1586537-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429070200.1586537-4-hch@lst.de>

On Mon, Apr 29, 2024 at 09:02:00AM +0200, Christoph Hellwig wrote:
> Merge the initial xlog_alloc_buffer calls, and pass the variable
> designating the length that is initialized to 1 above instead of passing
> the open coded 1 directly.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice cleanup,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log_recover.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index d73bec65f93b46..d2e8b903945741 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3010,6 +3010,10 @@ xlog_do_recovery_pass(
>  	for (i = 0; i < XLOG_RHASH_SIZE; i++)
>  		INIT_HLIST_HEAD(&rhash[i]);
>  
> +	hbp = xlog_alloc_buffer(log, hblks);
> +	if (!hbp)
> +		return -ENOMEM;
> +
>  	/*
>  	 * Read the header of the tail block and get the iclog buffer size from
>  	 * h_size.  Use this to tell how many sectors make up the log header.
> @@ -3020,10 +3024,6 @@ xlog_do_recovery_pass(
>  		 * iclog header and extract the header size from it.  Get a
>  		 * new hbp that is the correct size.
>  		 */
> -		hbp = xlog_alloc_buffer(log, 1);
> -		if (!hbp)
> -			return -ENOMEM;
> -
>  		error = xlog_bread(log, tail_blk, 1, hbp, &offset);
>  		if (error)
>  			goto bread_err1;
> @@ -3071,16 +3071,15 @@ xlog_do_recovery_pass(
>  			if (hblks > 1) {
>  				kvfree(hbp);
>  				hbp = xlog_alloc_buffer(log, hblks);
> +				if (!hbp)
> +					return -ENOMEM;
>  			}
>  		}
>  	} else {
>  		ASSERT(log->l_sectBBsize == 1);
> -		hbp = xlog_alloc_buffer(log, 1);
>  		h_size = XLOG_BIG_RECORD_BSIZE;
>  	}
>  
> -	if (!hbp)
> -		return -ENOMEM;
>  	dbp = xlog_alloc_buffer(log, BTOBB(h_size));
>  	if (!dbp) {
>  		kvfree(hbp);
> -- 
> 2.39.2
> 
> 
