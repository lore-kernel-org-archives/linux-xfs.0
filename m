Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0597D19CD14
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 15:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719244225; cv=none; b=YrQM3h0kqEO2bHWXKZeuAbChSYY9qeywXpHsfMENlrFHXFN3jbHCF+DaBOsAMky42PPO4DbNrXt6OHu9BHvegCoZwtxgATmMjWlQG3iYrnEUwYmmjrOP2H4nOUbcv9za4NE/QCWh6GXXdznpKv1JBti0jfnIZSAczB/aX1TnVoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719244225; c=relaxed/simple;
	bh=UizD6yXh/JA9ESznxVJAIpJZAx7dwbupqCnjVbTxrrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b4p/SbHYpcI36SpHQWIGQUuDmm2lBNw8e4FiSQ6mSq2nLtlpZBeuRR7HwieTymzu9ljk2pVYZZV/XZz2Mwd4vYRa6DTaVSTxsLLpM8pcG7hrZu4DisFY/j9uLy0deiIcc1qMr/tFS09AsEhWngwndYlL5lcOWo6gq38FDJXP2dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XRJWh6S+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XRJWh6S+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DA1C2BBFC;
	Mon, 24 Jun 2024 15:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719244223;
	bh=UizD6yXh/JA9ESznxVJAIpJZAx7dwbupqCnjVbTxrrM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XRJWh6S+wPQoJmwMCparg6tUYu09yyI4NPQVRP+mWEyuc9h0JCN1TaA+nTbiPdsyT
	 UnhcfPlnD5tdHd5rXk9Qr4vi5AH2NNZY7SUSoVmilt1bw8Fr+AA8KYGJTuZxhW94l2
	 jWsCanLCCOqRAvtjVEFOP2fVEOcZumCfann8Hf5/RiNzGTfunsmzvJPljwj62zWQJ9
	 qCIQ/PEkOOU6XuBgp1yS6hRTOkN/qLx8b20l5C/MZn0yIrYxm7itk5fXfZ7a1BXVIL
	 LftDq6X/D2tRPLwNYqBz7t0vPISAJ8I3rzhHNzK64RcAQrj8Jo1wn4z38qc/ryL1WV
	 huQnDBAfeKXow==
Date: Mon, 24 Jun 2024 08:50:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/10] xfs: check XFS_IDIRTY_RELEASE earlier in
 xfs_release_eofblocks
Message-ID: <20240624155022.GL3058325@frogsfrogsfrogs>
References: <20240623053532.857496-1-hch@lst.de>
 <20240623053532.857496-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240623053532.857496-9-hch@lst.de>

On Sun, Jun 23, 2024 at 07:34:53AM +0200, Christoph Hellwig wrote:
> If the XFS_IDIRTY_RELEASE flag is set, we are not going to free

         XFS_EOFBLOCKS_RELEASED ?

> the eofblocks, so don't bother locking the inode or performing the
> checks in xfs_can_free_eofblocks.

It'll still be the case that ->destroy_inode will have the chance to
delete the eofblocks if we don't do it here, correct?

If so, then
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index de52aceabebc27..1903fa5568a37d 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1245,9 +1245,9 @@ xfs_file_release(
>  	 */
>  	if (inode->i_nlink &&
>  	    (file->f_mode & FMODE_WRITE) &&
> +	    !xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
>  	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> -		if (xfs_can_free_eofblocks(ip) &&
> -		    !xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED)) {
> +		if (xfs_can_free_eofblocks(ip)) {
>  			xfs_free_eofblocks(ip);
>  			xfs_iflags_set(ip, XFS_EOFBLOCKS_RELEASED);
>  		}
> -- 
> 2.43.0
> 
> 
