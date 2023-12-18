Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFC749893
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 22:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H4Zorb0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B065C433C7;
	Mon, 18 Dec 2023 22:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702939142;
	bh=0E0B7WI6p51JTl2drAu4/PJxsO+1FxtIPQJ/qaNCZFU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H4Zorb0+ySUsLE0QhwbgVEo88qTlu900jliV232kT4Beh8ghXrjClAzAXdCJN49nf
	 wRt3uhbSrXKlCbXclqKWyn6YY526XAiB2ezAOQFPsjmfZNwKXePICmozZZWQMhnmGd
	 mn0RVvaOs5dInI/HiBnAHPG9eul2xtIQzwqQRRXUmkHt7PAaYhghutPe1AUQKBMQfX
	 GXwNAg5SXb1WXwrdtARMv2/dbvwQgoYeqCegIljSPE5d4KCxW0uguz4ehQ9gr/cD9I
	 T2F0HF6MdJEvBc2WlvfWXTniFNN+IU1c7cWjoEG39u21lPV/lQL2WCcwTn9vzGjrIp
	 41qTCMtd+TOtA==
Date: Mon, 18 Dec 2023 14:39:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: move the xfs_attr_sf_lookup tracepoint
Message-ID: <20231218223902.GC361584@frogsfrogsfrogs>
References: <20231217170350.605812-1-hch@lst.de>
 <20231217170350.605812-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231217170350.605812-4-hch@lst.de>

On Sun, Dec 17, 2023 at 06:03:45PM +0100, Christoph Hellwig wrote:
> trace_xfs_attr_sf_lookup is currently only called by
> xfs_attr_shortform_lookup, which despit it's name is a simple helper for
> xfs_attr_shortform_addname, which has it's own tracing.  Move the
> callsite to xfs_attr_shortform_getvalue, which is the closest thing to
> a high level lookup we have for the Linux xattr API.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 2e3334ac32287a..37474af8ee4633 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -876,8 +876,6 @@ xfs_attr_shortform_lookup(
>  	struct xfs_attr_sf_entry	*sfe;
>  	int				i;
>  
> -	trace_xfs_attr_sf_lookup(args);
> -
>  	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
>  	sfe = &sf->list[0];
>  	for (i = 0; i < sf->hdr.count;
> @@ -905,6 +903,9 @@ xfs_attr_shortform_getvalue(
>  	int				i;
>  
>  	ASSERT(args->dp->i_af.if_format == XFS_DINODE_FMT_LOCAL);
> +
> +	trace_xfs_attr_sf_lookup(args);

Shouldn't this get renamed to trace_xfs_attr_shortform_getvalue to match
the function?  Especially since xfs_attr_shortform_lookup disappears
later, AFAICT.

--D

> +
>  	sfe = &sf->list[0];
>  	for (i = 0; i < sf->hdr.count;
>  				sfe = xfs_attr_sf_nextentry(sfe), i++) {
> -- 
> 2.39.2
> 
> 
