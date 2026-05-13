Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22ED3921C8
	for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 07:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778657522; cv=none; b=r2WnHO2Nh20Yuf9sqzdU8es+idtsyLYPuSB7o2w1TkHJkiuZB+smXfQL1S8LuXjBVmOAc9pr2ZNwft1204MuuWTDD4nZ9i9YrNl50r2l/ka6u4E2jBbrhx2T5lSpkH6rxMHpvOmf33TY6PPMtxvu66DgakT7ia4vQZYMG+fugbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778657522; c=relaxed/simple;
	bh=RUDcoARpRCKW5dXlhNYKe34N5y5fXiCn7ZGtH/zNF18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cnvra5goZltZhYESIsXPoxn1veN68rJpH9dHUv3XT05kM+Oai2NxZNYEEWylFYqWO845OJSCjeQesmB9llUk9Cd7N/laiAmZYOO3jjEgNEBtDZDfQ5W017V5RtR+BoStxivKTD7o47hqPuX0zKX+fr4QbQKFpEdz5c+D8GfzZR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oC+EtJZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oC+EtJZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB8EC2BCC6;
	Wed, 13 May 2026 07:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778657522;
	bh=RUDcoARpRCKW5dXlhNYKe34N5y5fXiCn7ZGtH/zNF18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oC+EtJZyf6DvJcIBDMX06GnxCn4GrcusWwD1OgtoRWfBkel45KrUp5nUlK4e/KDJ/
	 e/xjRgk4b6QqS7SEwW+stcVNyZZ7BkkKSIhijS9YUNrKxicZBg9MpLCyacvJZGuq5p
	 3BKrRE81Z4wvRpzjIDHbybVRDQw5AaEbyoaB37TJWBfC+Es3dXntP/8kpBBIU/8XES
	 tWNadu/eGlXGBrDKCpfaP5MXod7MuLPxMumwZP6zXTqU2EyL8kCSTpWGNEB2Hdb0XW
	 pJARyMGbxsOlEdmaT6afsQyPA21Fw4AGO/ksTeINl1YIdznatDFq0OZvYyTT010Wxf
	 XHRDJ0esdX8Cg==
Date: Wed, 13 May 2026 09:31:58 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, 
	Damien Le Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: return -ENOENT for unallocated inodes in
 xfs_imap_lookup
Message-ID: <agQo5YwRcMPjhzNG@nidhogg.toxiclabs.cc>
References: <20260513063745.8067-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513063745.8067-1-hans.holmberg@wdc.com>

On Wed, May 13, 2026 at 08:37:45AM +0200, Hans Holmberg wrote:
> Under heavy garbage collection pressure from RocksDB workloads,
> filesystem shutdowns can occur in xfs_zone_gc_iter_irec when
> xfs_iget() returns -EINVAL.
> 
> xfs_zone_gc_iter_irec expects -ENOENT when garbage collection races
> with file deletion, so that blocks belonging to deleted files can be
> skipped gracefully. Returning -EINVAL instead causes the GC code to
> treat this as a fatal error and forces a shutdown.
> 
> Fix this by returning -ENOENT from xfs_imap_lookup for untrusted inodes
> when the inode has been deleted, allowing zone GC to safely ignore stale
> mappings.
> 
> Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
> 
> We could also fix this up in xfs_zone_gc_iter_irec, and handle -EINVAL
> as a non-fatal error, but returning -ENOENT from xfs_imap_lookup seems
> like the more right thing to do.
> 
> The check "that the returned record contains the required inode" in
> xfs_imap_lookup also returns -EINVAL and might be worth switching
> over to -ENOENT but I'm leaving that as is I did not hit that case
> in my testing.
> 
>  fs/xfs/libxfs/xfs_ialloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index dcef06ec0a02..702e1e853e45 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2442,7 +2442,7 @@ xfs_imap_lookup(
>  	/* for untrusted inodes check it is allocated first */
>  	if ((flags & XFS_IGET_UNTRUSTED) &&
>  	    (rec.ir_free & XFS_INOBT_MASK(agino - rec.ir_startino)))
> -		return -EINVAL;
> +		return -ENOENT;
>  
>  	*chunk_agbno = XFS_AGINO_TO_AGBNO(mp, rec.ir_startino);
>  	*offset_agbno = agbno - *chunk_agbno;
> -- 
> 2.34.1
> 
> 
