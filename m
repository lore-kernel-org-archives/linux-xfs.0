Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5614F221DAA
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740594003; cv=none; b=cwVQxYRI/Z2s4IKBRxHkYVscUPE2grnFRq//yRyhFG3fYoXuzGFgOyj5Y8kk1XFhBGlia7r6anMM+9GsakCkurag33Io0uGMxKTmAPqXfd59CkVvQIOjkkpvLHbuvguyOllhXI7FK1lIfMFBL6+Sb8lbBo0BD5hfyNFvIO8mugA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740594003; c=relaxed/simple;
	bh=IW2S8fvhVTEAZc3b3VbSgbZOk6fvr8Nqj/cu44cK8e8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CJWXHb/JebU/R7ZTwk0QeQvDU4mA3M1RezPBmh+ofRD8yG8qVsG05Us4yKOz8+6yv4bjwVbjNWdKGj0yX0Ha33YO/DWw3A/wQiHe5fJXb4AW0LIieq62EMsT92siaRxM9z+/9rpzAvBbbuc9P76jRv5EA69numZ7eVh65re/4zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rLXTKdZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rLXTKdZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96FFC4CEE7;
	Wed, 26 Feb 2025 18:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740594002;
	bh=IW2S8fvhVTEAZc3b3VbSgbZOk6fvr8Nqj/cu44cK8e8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rLXTKdZAq6P+rZlHCpWnSEgJoae6yDWd1sp/hhYCOIq4bjp1rpwuzew2slqHWhnIM
	 cdS4F9zAcb/rqTtUivj+EbEGDu991olZ9HsmzJlIXByzNJZ9A1BTpJ+bB5NpPomwZy
	 YYDETfuyI48C7/8vTy06uZy9ns3WWpDNkD2Ejm2PYo6Q+v+/BFw/42ehOAQd5+hTyB
	 C0JupQEO+ajeb9fsa8jiBfiWxp75CaOLYg7oyC6zcxrveyJzTfiW2UKtL6Fd+l6g2k
	 uotWpap+sN28yd9oTSSbq6U5zNo9/rAIANn85XNo3pfcSC9LBqyK1EGGonW5W+6RP/
	 uxFAa8Z1v6Hyw==
Date: Wed, 26 Feb 2025 10:20:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: bodonnel@redhat.com
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_repair: -EFSBADCRC needs action when read verifier
 detects it.
Message-ID: <20250226182002.GU6242@frogsfrogsfrogs>
References: <20250226173335.558221-1-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226173335.558221-1-bodonnel@redhat.com>

On Wed, Feb 26, 2025 at 11:32:22AM -0600, bodonnel@redhat.com wrote:
> From: Bill O'Donnell <bodonnel@redhat.com>
> 
> For xfs_repair, there is a case when -EFSBADCRC is encountered but not
> acted on. Modify da_read_buf to check for and repair. The current
> implementation fails for the case:
> 
> $ xfs_repair xfs_metadump_hosting.dmp.image
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
> Metadata CRC error detected at 0x46cde8, xfs_dir3_block block 0xd3c50/0x1000
> bad directory block magic # 0x16011664 in block 0 for directory inode 867467
> corrupt directory block 0 for inode 867467

Curious -- this corrupt directory block fails the magic checks but
process_dir2_data returns 0 because it didn't find any corruption.
So it looks like we release the directory buffer (without dirtying it to
reset the checksum)...

>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 3
>         - agno = 2
> bad directory block magic # 0x16011664 in block 0 for directory inode 867467

...and then it shows up here again...

> Phase 5 - rebuild AG headers and trees...
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
> bad directory block magic # 0x16011664 for directory inode 867467 block 0: fixing magic # to 0x58444233

...and again here.  Now we reset the magic and dirty the buffer...

>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify and correct link counts...
> Metadata corruption detected at 0x46cc88, xfs_dir3_block block 0xd3c50/0x1000

...but I guess we haven't fixed anything in the buffer, so the verifier
trips.  What code does 0x46cc88 map to in the dir3 block verifier
function?  That might reflect some missing code in process_dir2_data.

> libxfs_bwrite: write verifier failed on xfs_dir3_block bno 0xd3c50/0x8
> xfs_repair: Releasing dirty buffer to free list!
> xfs_repair: Refusing to write a corrupt buffer to the data device!
> xfs_repair: Lost a write to the data device!
> 
> fatal error -- File system metadata writeout failed, err=117.  Re-run xfs_repair.
> 
> 
> With the patch applied:
> $ xfs_repair xfs_metadump_hosting.dmp.image
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
> Metadata CRC error detected at 0x46ce28, xfs_dir3_block block 0xd3c50/0x1000
> bad directory block magic # 0x16011664 in block 0 for directory inode 867467
> cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
> bad directory block magic # 0x16011664 in block 0 for directory inode 867467
> cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> Phase 5 - rebuild AG headers and trees...
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
> cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> Metadata CRC error detected at 0x46ce28, xfs_dir3_block block 0xd3c50/0x1000
> cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> bad directory block magic # 0x16011664 for directory inode 867467 block 0: fixing magic # to 0x58444233
> cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> rebuilding directory inode 867467
> cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify and correct link counts...
> done
> 
> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> ---
>  repair/da_util.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/repair/da_util.c b/repair/da_util.c
> index 7f94f4012062..0a4785e6f69b 100644
> --- a/repair/da_util.c
> +++ b/repair/da_util.c
> @@ -66,6 +66,9 @@ da_read_buf(
>  	}
>  	libxfs_buf_read_map(mp->m_dev, map, nex, LIBXFS_READBUF_SALVAGE,
>  			&bp, ops);
> +	if (bp->b_error == -EFSBADCRC) {
> +		libxfs_buf_relse(bp);

This introduces a use-after-free on the buffer pointer.

--D

> +	}
>  	if (map != map_array)
>  		free(map);
>  	return bp;
> -- 
> 2.48.1
> 
> 
