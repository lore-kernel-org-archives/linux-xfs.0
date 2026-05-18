Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B504430DD2A
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 07:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779090514; cv=none; b=kDI/C/jIJYi9xVL12Xy54QIl55imwXaNrgZy6wUqezmimyj2TzRUc6jrhjwH30aKuxGcZ3eotnd5nOkN9bpzbV3WkZZyt+Ry61S7sv8N4wqZWwRWA1a8Tn0m0PtDDIe9IgxMdmwiRUOxlp/wMxEm/Eu5X7gkUMvYu8dhqApcgKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779090514; c=relaxed/simple;
	bh=rMzp0qfUHnF9f04nGuPrn/8SqqXO98c0htgWsn/lOEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QkhiNWO5Az6/hRlnH7Rdgv0yn7yKJHp6M4NYbn7Eb4cq2QqxA1+WRkeaNrbWr5EYmpJgkOK7BELFH7/+pTiauFKeQlLeuo4hA9fN5Svh/X5tSGE2/SZPlgIgqwVz6JJb/4ZIPMtEP9Hn7qPfwDc66Uti/YDA4vfUMEBctzGL064=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lvKeniwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lvKeniwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C93C2BCB7;
	Mon, 18 May 2026 07:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779090513;
	bh=rMzp0qfUHnF9f04nGuPrn/8SqqXO98c0htgWsn/lOEM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lvKeniwBKMgEu/jS71pigeOYd9FX814VBUl6Il5ZL5RJ+aZNmBM1EmZY92C5WlizF
	 gBv5LXbpymhmQ49KU9FAMu6zfRupGz+OtLF+Z8mvohNPMkTYzy0u20K2moRMrLqTCC
	 lMI85sW/+1CpKKq2GtdMNDPvC2IfexSuFpY1mZ3zFsMPNx08JErqmsm6L9V52qqDy/
	 f8LgzMizuKoCWghkxl3Peyu+WoZvbyuFIQDx3/9a6t3K3nWoVjeYQ0PKVtEae64uGm
	 fHR7RXU/mVb7HO7wqap3nNrkIpz18e9ZpVO7t5JG8AjZv9SfO8l6D+3cwcg77i7fkF
	 iLFzBcp3ysOjQ==
Date: Mon, 18 May 2026 17:48:22 +1000
From: Dave Chinner <dgc@kernel.org>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: handle racing deletions in xfs_zone_gc_iter_irec
Message-ID: <agrERjRq10bm0rrY@dread>
References: <20260518065224.9066-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518065224.9066-1-hans.holmberg@wdc.com>

On Mon, May 18, 2026 at 08:52:24AM +0200, Hans Holmberg wrote:
> Under heavy garbage collection pressure from RocksDB workloads,
> filesystem shutdowns can occur in xfs_zone_gc_iter_irec when
> xfs_iget() returns -EINVAL for deleted files.
> 
> Fix this by handling -EINVAL just like we handle -ENOENT, allowing
> zone GC to safely ignore stale mappings.
> 
> Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> ---
> 
> v2:
> - handle -EINVAL in the the caller in stead of switching error code
>   in xfs_imap_lookup
> 
> v1:
> https://lore.kernel.org/linux-xfs/20260513063745.8067-1-hans.holmberg@wdc.com/
> 
> 
>  fs/xfs/xfs_zone_gc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index fedcc47048af..96f14d811db2 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -400,7 +400,7 @@ xfs_zone_gc_iter_irec(
>  		/*
>  		 * If the inode was already deleted, skip over it.
>  		 */
> -		if (error == -ENOENT) {
> +		if (error == -ENOENT || error == -EINVAL) {
>  			iter->rec_idx++;
>  			goto retry;
>  		}

Why did you choose to do this? I was expecting the updated fix to be
dropping XFS_IGET_UNTRUSTED from the xfs_iget() call because the
inode numbers are coming from a trusted source (i.e. the rmapbt) and
this would then return the expected -ENOENT on unlink races instead
of -EINVAL....

-Dave.
-- 
Dave Chinner
dgc@kernel.org
