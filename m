Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C7A1E3DED
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 21:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760478747; cv=none; b=gEkdKkAl/dt+IZ2fuKp1mmHo45LHibRXUCe0Jxz8662Q74xYsp4sgTwiWblzkrtZhu7B7o+z4QACEzxKF7YwdosUwhR/wW19P3x5MgMdZj93uO75+PrLylLrICEZLaiEmxuBSZ1lBssfPGrvdC1tuTbR6ihmJ8XGuzANP4diuv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760478747; c=relaxed/simple;
	bh=DgukJ8YCp9NpkZ5b/xWoex+acfR334p3y5xeJgh5fUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vFyUBY3SkdLfLLVrq84VN7yR+fO+uu46o1vAgwm7RgmG1og6+yQ/sY59YqOTpgpqwnsZmuUq3fY8irVJvDDB2XzsaoluPuWYINblmQRNuS/fACLSOPEFK32oLIRIaJ9HO1Rj2A9aiXCDfWPd31udLs0liFL+tri5RN1iC3y+q7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rDuARn8S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rDuARn8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF650C4CEE7;
	Tue, 14 Oct 2025 21:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760478746;
	bh=DgukJ8YCp9NpkZ5b/xWoex+acfR334p3y5xeJgh5fUA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rDuARn8SoC5X9rT437XlhpGVellNyGco4ECs5RrIXR6mCojLIYkUftx2dVuT2hvhC
	 XPO1SXoIZWOgWupSD5LADYOlVHbXj7BIcyeUhgt+V1fnFIVTfKGyWXHiLyN+J39mzh
	 aSn5NPe9yi3HR+h5uytbt4eUDmZkbAzqXqnlqZ9PBq55g/PE8FlTIv5pKB1omfLHW3
	 uOItncXm3U66XT4LXaTGh5s73HKJwfzKuLI8kt7HBmhNrlGKj5eoY+YDZkmLYJ1Ox+
	 ckvwdtqL9D0hr08JZsfd1MoLbcyp/wY6krNTEv2rRZMk+v36hgwWI7WG5uhDMjKGax
	 MqZkTEa1K3TpA==
Date: Tue, 14 Oct 2025 14:52:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: remove a very outdated comment from
 xlog_alloc_log
Message-ID: <20251014215226.GK6188@frogsfrogsfrogs>
References: <20251013024228.4109032-1-hch@lst.de>
 <20251013024228.4109032-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024228.4109032-6-hch@lst.de>

On Mon, Oct 13, 2025 at 11:42:09AM +0900, Christoph Hellwig wrote:
> The xlog_iclog definition has been pretty standard for a while, so drop
> this now rather misleading comment.

The iclog structure's size scales proportionately to the log buffer
size, right?  AFAICT it's the iclog header itself plus enough bio_vecs
to map every page of the log buffer.  So there's really nothing weird
about that, right?

If 'yes' to both questions, then
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 3bd2f8787682..acddab467b77 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1435,13 +1435,6 @@ xlog_alloc_log(
>  	init_waitqueue_head(&log->l_flush_wait);
>  
>  	iclogp = &log->l_iclog;
> -	/*
> -	 * The amount of memory to allocate for the iclog structure is
> -	 * rather funky due to the way the structure is defined.  It is
> -	 * done this way so that we can use different sizes for machines
> -	 * with different amounts of memory.  See the definition of
> -	 * xlog_in_core_t in xfs_log_priv.h for details.
> -	 */
>  	ASSERT(log->l_iclog_size >= 4096);
>  	for (i = 0; i < log->l_iclog_bufs; i++) {
>  		size_t bvec_size = howmany(log->l_iclog_size, PAGE_SIZE) *
> -- 
> 2.47.3
> 
> 
