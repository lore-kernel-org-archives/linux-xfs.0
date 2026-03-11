Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E8834FF58
	for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2026 14:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773239213; cv=none; b=E07+omIhxh+PRxJOcRt9EbdeLteOEpq/EfJv0Eur+Im5DzMu1sOlKslnrYIzLkJAtI+A44ji2HsUw5Ql61D1QJrqCyhjOEjbY+SpOWwBcYumFmrSR6UT/xHGf/D6HtwTe5yBn7i7lQG9HEZRW7IfE/G/PFVMN+Mq+sPW9VKTYyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773239213; c=relaxed/simple;
	bh=YUuCZwsuDEmKg9fQr4pIQngjh/inA1g+0cE5fEhR5to=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Aqiw7HKQgtKYGvDU8jngcWtWZlcsObJwD26uQ68jRVe5DGAZLpK9w+1PVsmP+Xa4FyEfQmnLRXul1sGDqmXr52aVat/6BHaeCoGSfFNRzIdajD5172yqDXzP/ekwSq6Z+gidtV5TGQ2w1l/U2aDVcHAHU3wd3wSEuvO6bmwS/WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SpDYWIaQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SpDYWIaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA457C4CEF7;
	Wed, 11 Mar 2026 14:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773239212;
	bh=YUuCZwsuDEmKg9fQr4pIQngjh/inA1g+0cE5fEhR5to=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SpDYWIaQ+ysfDTi/58gxg2eqr04pSKTMpIyxY4c3HVcGrjnMa5Tz/ij+21NVCrgBN
	 yftL5xbbhOGfKTbr3kO136by8yj6yrFJFot5PU+LQfqe3oLaeBXQ5dd4beyo8z8a4d
	 rSESKje/8f4CGFvkx2YQl9fz1xaWquFJkJgYMKSWXW14Y9jaMaE6N0g/IeCLC9lztD
	 Kl+bW8wizw5BK7W4BwkJIenUns2e46ShJ4xZOnXpEFkVawT7bAcWsgl59QmcW5Xo6E
	 eY5FUiiyzAKq9BA2qRlVtuw4Fxq5c7YTqoDunHGczKfdcCS6Xz0GSOr0YNaRZDA99O
	 F0unKF1mjKCJQ==
Date: Wed, 11 Mar 2026 07:26:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_io: fix fsmap help
Message-ID: <20260311142652.GB1770774@frogsfrogsfrogs>
References: <20260311092503.995666-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311092503.995666-1-hch@lst.de>

On Wed, Mar 11, 2026 at 10:25:00AM +0100, Christoph Hellwig wrote:
> By default fsmap prints the reverse mapping for all devices.  Update the
> help text to correctly reflect that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  io/fsmap.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/io/fsmap.c b/io/fsmap.c
> index 005d32e500a0..0182154fee47 100644
> --- a/io/fsmap.c
> +++ b/io/fsmap.c
> @@ -24,7 +24,8 @@ fsmap_help(void)
>  "\n"
>  " Prints the block mapping for the filesystem hosting the current file"
>  "\n"
> -" fsmap prints the map of disk blocks used by the whole filesystem.\n"
> +" fsmap prints the map of disk blocks used on a given file system filesystem.\n"

                                               redundant ^^^^^^^^^^^

Otherwise this reads ok to me.

--D

> +" By default, the blocks for all devices are printed.\n"
>  " When possible, owner and offset information will be included in the\n"
>  " space report.\n"
>  "\n"
> @@ -32,7 +33,7 @@ fsmap_help(void)
>  "     extent: major:minor [startblock..endblock]: owner startoffset..endoffset length\n"
>  " The owner field is either an inode number or a special value.\n"
>  " All the file offsets and disk blocks are in units of 512-byte blocks.\n"
> -" -d -- query only the data device (default).\n"
> +" -d -- query only the data device.\n"
>  " -l -- query only the log device.\n"
>  " -r -- query only the realtime device.\n"
>  " -n -- query n extents at a time.\n"
> -- 
> 2.47.3
> 
> 
