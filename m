Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79826330641;
	Tue,  5 May 2026 23:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778022288; cv=none; b=dNOJnusxd+CavZu4597HC52KZyW++L+aMgncDs0E+TSoErkTCGcVJm7kxLHAdu9LZG2DxBhgtms66foPdg9umbtFDTtGo4xefmO4r+nAQvT83WN4rT+B0q8rP+xAh34fr0kP6UTSeq5j+BABKvBYaIuSHWyFITTl7RozJDEupF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778022288; c=relaxed/simple;
	bh=wvBT1rpt4iq97r2xbOeittPobLD2mTYuMqnQveUNnzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BQtRUmonvJiBo3fevbc9x/VwzCAu3aI9EDeFCiJiTbbeE4fGLQmaW/37yW2xukdhQKpesmtir7dUXOWtkBm+D1Q/8v1G/gN1ZOeWX9/B/pWY7qoxeLjVU6ZJ+QCksQg68CjwOw7fBJTqchDdizPDiKgy9JaRSc0LywaADqOeWYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vKnIaHfn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vKnIaHfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9939CC2BCB4;
	Tue,  5 May 2026 23:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778022287;
	bh=wvBT1rpt4iq97r2xbOeittPobLD2mTYuMqnQveUNnzQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vKnIaHfnkbT1ylGIYXqAWeG2ElNc2jeb4ThDgLX1dObpTuzgwQ5bjGTcrnIt+6n0w
	 RRUTQ/GBndHWbpTSBaKY5d5yYU2AtU1bZ36Ss6quHYn6OeT4JVfn2KDFWo38BfOw2z
	 EYJZ1rzTfnYpgbyTbuZlPypwMMPGfe8dqGrAGvUwJTNjRi1g1IqCx3sc56q29ByZWM
	 bPfDTx8jwyVoa87EJALWaaK961BOUO76d6LqfBjIEBJLKSjluvK+loUI2eqZmy0Z/H
	 KswxPXEsvCkADeIuM4/WVpb7VnJpZgVUOT+cje/bXGUQ1FwvDm7JrJ5zm/Dx4Ru2sX
	 /nM5jFXUY9/og==
Date: Tue, 5 May 2026 16:04:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Md Shofiqul Islam <shofiqtest@gmail.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Fix typo in comment
Message-ID: <20260505230447.GI7751@frogsfrogsfrogs>
References: <20260505225044.6484-1-shofiqtest@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505225044.6484-1-shofiqtest@gmail.com>

On Wed, May 06, 2026 at 01:50:44AM +0300, Md Shofiqul Islam wrote:
> Fix spelling mistake in comment:
>  - occured -> occurred
> ---
>  fs/xfs/xfs_notify_failure.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
> index 64c8afb93..b994ff15d 100644
> --- a/fs/xfs/xfs_notify_failure.c
> +++ b/fs/xfs/xfs_notify_failure.c
> @@ -350,7 +350,7 @@ xfs_dax_notify_dev_failure(
>  	/*
>  	 * Shutdown fs from a force umount in pre-remove case which won't fail,
>  	 * so errors can be ignored.  Otherwise, shutdown the filesystem with
> -	 * CORRUPT flag if error occured or notify.want_shutdown was set during
> +	 * CORRUPT flag if error occurred or notify.want_shutdown was set during

It occured to me that although this is a small change, it is technically
correct. ;)

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  	 * RMAP querying.
>  	 */
>  	if (mf_flags & MF_MEM_PRE_REMOVE)
> -- 
> 2.51.1
> 
> 
