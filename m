Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9953210A18;
	Mon, 16 Sep 2024 16:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726505762; cv=none; b=nFdvi1IO7/7S+3H0t4dYrNrWNrH7ihFn3rXBmhC6udvY8ZZosJKZMcvJ9S/RJxhkIv9aVWRvkWmTgusXiZMUJGucXU3BRCMYvHYR6wJJUElnaFO2TzMMf+L68RMoxYnpBPjglv73tMqC8SBKgV6LCu6Of0iB+b0sMqv5pmVNYrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726505762; c=relaxed/simple;
	bh=ppIg8LRzbyGQG9QXLZlYoEZ/7zPlqNNFEql//NfyhqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sza7urHOtI7OxnWF0/tS04xsCKEXCAy0632VVHGPoSpN7u08sIboxyPn0TRlKMmeFTP3JgfE+ko9J4zigvlEcW4+kGLLKkQYwMbqtl2YZOIyFtR/jeCCID4bny8/Z3iXNjUvzxpIy0SWC0SbmZ+ryxKlAdSqzpWYbr6oDIrQDtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kh0PPngC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kh0PPngC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10151C4CEC4;
	Mon, 16 Sep 2024 16:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726505762;
	bh=ppIg8LRzbyGQG9QXLZlYoEZ/7zPlqNNFEql//NfyhqI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kh0PPngCUSz5LHP93IoBz2VkMwvPdVpSFJMWrPOh/c1mKAxpEc/QtRPkTkn3HyP6H
	 qiv0GFRki5WHb56DdopLeO9WrTuln4tEue1n1w9lL5Ltd6bBbHKdOBjJl+aIyhb0VY
	 8p7/VFi0QnsRnJ68vD2k7Ysb1j47hoB2YIEBnsQFDlMEO6MJc7Fo68AVay04VwdxHq
	 tf6NcT6fEyiYQ8vjJ2SUegq6MAL4IfxDnRtcRN880vYuGUgPSOdqGLnKFV6oEttQTe
	 ynu/0ODJfLPC+ntgQGzHgo0dvn3A+7CK0vAFqWksvPt0UZc0T8Sn9hfABRPjc3TmwH
	 WgLfKezRSUb8Q==
Date: Mon, 16 Sep 2024 09:56:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chen Ni <nichen@iscas.ac.cn>
Cc: chandan.babu@oracle.com, aalbersh@redhat.com, willy@infradead.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: convert comma to semicolon
Message-ID: <20240916165601.GB182194@frogsfrogsfrogs>
References: <20240903073931.781113-1-nichen@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240903073931.781113-1-nichen@iscas.ac.cn>

On Tue, Sep 03, 2024 at 03:39:31PM +0800, Chen Ni wrote:
> Replace a comma between expression statements by a semicolon.
> 
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_remote.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 4c44ce1c8a64..5a55819f50f3 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -525,7 +525,7 @@ xfs_attr_rmtval_set_value(
>  		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
>  		       (map.br_startblock != HOLESTARTBLOCK));
>  
> -		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
> +		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock);
>  		dblkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
>  
>  		error = xfs_buf_get(mp->m_ddev_targp, dblkno, dblkcnt, &bp);
> -- 
> 2.25.1
> 
> 
