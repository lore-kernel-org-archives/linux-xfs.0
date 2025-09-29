Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D01D2459EA
	for <linux-xfs@vger.kernel.org>; Mon, 29 Sep 2025 18:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759170878; cv=none; b=uZLWwq7fhyMdI6NONzGTZA2i6SmI9eofUzBEGpuIt3YD+OXrFJV4zY8Glw+brJicCmBfFB4/VO3BKK4wyuWvziphTMSUy3/yBdDj4bltHm09RFkSZuhnSxQ4VdpDpZJePpe5O8maY/pOYRacXOCGoggOrZ2K3icbzEWzsWbHHx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759170878; c=relaxed/simple;
	bh=/JBOBm31auERDF7m1sAUYVLp0VbVhgupY5BToa1TotI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NK9ReRcQATO0gfanzLq/UB+pj4fno0DGkWRjnBYd93nKKe2vWBrXZGS8eHdM75pe0hek4sQLSjRrQ+hdB0tKozrMaxTMBsZjku1IOqTWufFhGikp4eWJegmPTcnFJ6S+nyD/BAzP44cTCYpjlQ17V/dGglovlltR81qrFUpJqN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uIMnuyqE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uIMnuyqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0806C4CEF4;
	Mon, 29 Sep 2025 18:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759170878;
	bh=/JBOBm31auERDF7m1sAUYVLp0VbVhgupY5BToa1TotI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uIMnuyqEEkVWnSEZhKVHl/f2Pbs7MxXgY9NVPG+fWpxE/ql6HpkgANTafybzfjtrt
	 VhJRc+Keb/jHPRRb2mY/DquFc2NxeR48OesvbSGZ2pMn19/ZbA11SQlgu1/kRv6EOR
	 nadPAu5/FzJJXSVgPmF8cm40x6AgDKXE2pxXAdHg6CsLFBnSPtEfis4JvaZ6As/uF7
	 RW74jWTfcY4qDoQ8njzMBoF3nvKNKv+eBjpDhBsYAoo5aTb40LvKNx4LotcztAunEn
	 Kp9KTs6YRK56GqyP/XveoU6lZDtXeXWR5OvSluOeFvKKMNUGxsqvYnYKtGBfaUBI7E
	 xc3LgDf2S95AQ==
Date: Mon, 29 Sep 2025 11:34:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't use __GFP_NOFAIL in xfs_init_fs_context
Message-ID: <20250929183437.GB8096@frogsfrogsfrogs>
References: <20250929064154.2239442-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250929064154.2239442-1-hch@lst.de>

On Mon, Sep 29, 2025 at 08:41:54AM +0200, Christoph Hellwig wrote:
> xfs_init_fs_context is early in the mount process, and if we really
> are out of memory there we'd better give up ASAP.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Is this the fix for that recent sysbot report?  If so, maybe you ought
to link to the syzbot thread:
Link: https://lore.kernel.org/linux-xfs/3d54a546-77dd-4913-bcd0-7472aec8f53c@suse.cz/T/#md6876fda5ae060700801623ee18fa59317c5cbc4

In any case the logic is sound and it's quite easy to bloat xfs_mount
to be larger than 4k so the kzalloc is simply fallible:

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index bb0a82635a77..a8fe8b042331 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -2275,7 +2275,7 @@ xfs_init_fs_context(
>  	struct xfs_mount	*mp;
>  	int			i;
>  
> -	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL | __GFP_NOFAIL);
> +	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL);
>  	if (!mp)
>  		return -ENOMEM;
>  
> -- 
> 2.47.3
> 
> 
