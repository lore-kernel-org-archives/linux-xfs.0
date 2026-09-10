Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC0534DCE4;
	Thu, 10 Sep 2026 05:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789018957; cv=none; b=BGLynwYnc4J6PwXCEGXANaGf8MXrHNBimb9wguUlknLl9q2p0R9Nhd4fs/KSvnzu/J6DQ4S/aVj67mgf/Iz08/flQH4wk8rEyf16Nz3O2fsnZ3A/N72Tq/5u6hvUnxjjB5hA1zpNF61Sbs0Q2vrWXuLeJtTtTR1Wr9XHXWaeObw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789018957; c=relaxed/simple;
	bh=QrslRF6hiu8Xv38xtplUGLT6382NiF41R2AxjTgY8fA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pW2+3vs7aIh0Vvcwc+WjXKwafR3z0mFuSta9+mYcNunsIQWo6LrrKZU9hmXRt4AaOYYVTSxtswhdeX+a/YmNRLZv4K8dxlClbxSJ76SEBSOLWTflv0YeSJiZo2pu6tXy/swz7IkmS1DcD2GjRzr/8hCZUA9nzlxUqeiY/AjUyso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M/5cGuLi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M/5cGuLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2A91F000FF;
	Thu, 10 Sep 2026 05:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789018949;
	bh=XLHUPUsY4zU609kLOwL6OpA1t12rkCqpJqfIp94AxNI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M/5cGuLiPI+PZrShMD+QBpHZwl39PKn96B6aCQE7HAJGmFI/kRVhDpFUoUcEFBjDd
	 fKc2Qx+CGOiMY043qCdT4JWlbyCaI9/jfKf5mhC1SOGHQujAKLVleIyoOdHxvwH8fQ
	 xgPB65dTPj8b3b9CwnJzkCFzhfHVQE0ajfpRU0SHd7BRKJ1LojCzTkkUqliD2BiJYq
	 rOYw9liftX7tGZvmL68x1zU9akeN2bo4m4XoH0cJgoRwGkDpIJHhSR2zEgufEFke8M
	 BrmdMFL7eUWbMJMXxavKA+lWeSNQwaDHAaPkJLvfZqfsHjLqz8xBSqLqzh+aYmQT45
	 OWeK8WAeAPUOg==
Date: Thu, 10 Sep 2026 07:42:24 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: actually check internal-rtdev fields in the
 superblock
Message-ID: <aqJDNZLzHfzNV52Z@andromeda.toxiclabs.cc>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
 <178892936663.4057962.1670503099807440927.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892936663.4057962.1670503099807440927.stgit@frogsfrogsfrogs>

On Tue, Sep 08, 2026 at 11:04:50PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM points out that the superblock scrubber doesn't check the new
> fields that were added for internal realtime volumes when we added zoned
> device support.
> 
> Cc: <stable@vger.kernel.org> # v6.15
> Fixes: 2167eaabe2fadd ("xfs: define the zoned on-disk format")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Assisted-by: LOLLM # finding obvious bugs

This looks fine

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/scrub/agheader.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index 1fa66aa68e169f..fa5d32ec020aec 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -418,6 +418,13 @@ xchk_superblock(
>  			xchk_block_set_corrupt(sc, bp);
>  	}
>  
> +	if (xfs_has_zoned(mp)) {
> +		if (sb->sb_rtstart != cpu_to_be64(mp->m_sb.sb_rtstart))
> +			xchk_block_set_corrupt(sc, bp);
> +		if (sb->sb_rtreserved != cpu_to_be64(mp->m_sb.sb_rtreserved))
> +			xchk_block_set_corrupt(sc, bp);
> +	}
> +
>  	/* Everything else must be zero. */
>  	sblen = xchk_superblock_ondisk_size(mp);
>  	if (memchr_inv((char *)sb + sblen, 0, BBTOB(bp->b_length) - sblen))
> 
> 
