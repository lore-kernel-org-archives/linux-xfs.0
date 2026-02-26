Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D629A427A18
	for <linux-xfs@vger.kernel.org>; Thu, 26 Feb 2026 15:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121390; cv=none; b=Eq8bER5BiL1TlmFtkN+KQbctzqy0jqGe+XEAYChjL93gf29ij5qoiPvxpG1McpwvC/jxe3wUwWM1GTOvdd6a/L6BtYdiCeeiYskllckERY1lFtRLh4rTsHBgNEEZwYgoyiZ7T9HnvQA6parzNEP1IijNy6GNoKQMuqK1+f6DkKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121390; c=relaxed/simple;
	bh=+PzQldwcaTwqHjSCI5sv50Qyzpk5+hwbacWTcVzKejE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SE6hGf7F4k961JsOpgTMuS2/oAInSCWrS8bXNTXgZNq8OAXLuUCwGWBRe7w2Lj8Ikehsg1GsbyxFdUArw4uiqBvwGGz/tL99LzRQqZMukj4VyKqsUJ1isvHHCX1WPdc8lHphcmEU/fYKMPmez0LqnE4NaZa3RpcciU0+65nkWqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uUA/mB7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uUA/mB7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A055FC2BCB0;
	Thu, 26 Feb 2026 15:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121390;
	bh=+PzQldwcaTwqHjSCI5sv50Qyzpk5+hwbacWTcVzKejE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uUA/mB7q+YskaErn5TgV3nfgNyl9uy3K/SkKx6hdMqKOTF+WsRl0MS96M+ig4di5V
	 CjyEUNczjZlEOhVPVb8WzeNz/SQAE1FG6byRWAQzIeefIB3MfqCgLpIL4jlUI/5VOk
	 MTj1K4KKYZtOmxAYqdAXMyTTIfYiHksLV/idSKnZ527M8OEpbDwyPAgk7plfROUzst
	 BZP61aAPgfdi9Iz+3Kiq+W2W4O9v6EN/rk6/APzJ/6r0YDrA6iMRMlW1pea/qMUk8r
	 j/2ahriWUe7Pc3tNDoLZrb6GBiAWfgLOC4NmXfi9zuNFWNCg05jmDgnwybeq3lcHmX
	 3b5TtYkOT6/aQ==
Date: Thu, 26 Feb 2026 16:56:25 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove scratch field from struct xfs_gc_bio
Message-ID: <aaBtIcWrgeVpnDt8@nidhogg.toxiclabs.cc>
References: <20260225224646.2103434-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225224646.2103434-1-dlemoal@kernel.org>

On Thu, Feb 26, 2026 at 07:46:46AM +0900, Damien Le Moal wrote:
> The scratch field in struct xfs_gc_bio is unused. Remove it.
> 
> Fixes: 102f444b57b3 ("xfs: rework zone GC buffer management")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Looks good,
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_zone_gc.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 48c6cf584447..d78e29cdcc45 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -96,7 +96,6 @@ struct xfs_gc_bio {
>  	 */
>  	xfs_fsblock_t			old_startblock;
>  	xfs_daddr_t			new_daddr;
> -	struct xfs_zone_scratch		*scratch;
>  
>  	/* Are we writing to a sequential write required zone? */
>  	bool				is_seq;
> @@ -779,7 +778,6 @@ xfs_zone_gc_split_write(
>  	ihold(VFS_I(chunk->ip));
>  	split_chunk->ip = chunk->ip;
>  	split_chunk->is_seq = chunk->is_seq;
> -	split_chunk->scratch = chunk->scratch;
>  	split_chunk->offset = chunk->offset;
>  	split_chunk->len = split_len;
>  	split_chunk->old_startblock = chunk->old_startblock;
> -- 
> 2.53.0
> 
> 
