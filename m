Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A306C1F4C93
	for <linux-xfs@vger.kernel.org>; Fri, 28 Feb 2025 17:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740764139; cv=none; b=a3KkXJRLE8PBh4VMYDwVmutbxtpQWOWw2DpFOTS0XxbNMYXd2qDKwRQ2v+unaqXJxV9HVQLLqGWdpwVvj4BPlhmnxceD25I6aqCM/5t/yf6LFJdpZPVQOHCnEMAAzInc9bQzuVvvUcerOU6F2ovfv6vcws4+aPzvedQMHrklIbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740764139; c=relaxed/simple;
	bh=doGHesXG5URa2Ud/wg8UGR1Bcn5ZNAyHC/l5exOV6os=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iwgU3w3dJiQXZdghrzUr3lqPkMEn0nNcXO7i4gTLBd8PbPJyWn/N6T+phSC7o3xdxaQ89dmiPN9akaZjYTfUozET+O2foxW60bqjWvyhufTC6GIWKJhH3M7OBPnZjMl6K/8/GynGcI89tOHVHAAt94WDOV7yfe5rpwSKfveCJkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TvghJ4po; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TvghJ4po"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB4CC4CED6;
	Fri, 28 Feb 2025 17:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740764139;
	bh=doGHesXG5URa2Ud/wg8UGR1Bcn5ZNAyHC/l5exOV6os=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TvghJ4poKaC+dovV6aDQCdjgNAbOEuodUTUJWoO64suslmavJ7fM3Dem//xuOZJtb
	 cu8dMBiGoUCuJbHMLMHAsnO0oF7vRKwnzAbxPwW8wHC6TgJij2rcemWwHcjbDAYHaC
	 UqDtUCNd5A3AysVAx8DX0qRx7aHqWHoPdIiFNKw4s+O0Q5FHTHw4wSVMiRSpx6PeRf
	 EPHj10RLDr/CIehKghuH9HqOAF9o5c4AYVoahqme/S0T5PbQsVwxNrrfhUx+5lcop0
	 GH9s9vGK8ltwcZB/GFcdYEKOximQJj075/19ARDFivTH6qPJEuk5TqxPptP4gVheO3
	 Xzan8vS1iBshw==
Date: Fri, 28 Feb 2025 09:35:37 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_repair: -EFSBADCRC needs action when read verifier
 detects it.
Message-ID: <20250228173537.GA6242@frogsfrogsfrogs>
References: <20250226173335.558221-1-bodonnel@redhat.com>
 <20250226182002.GU6242@frogsfrogsfrogs>
 <4rpfn4nxntgg6hwqtei7nhhuw7n5jl57xvtnb7zagzus5y4i2s@triion65snds>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4rpfn4nxntgg6hwqtei7nhhuw7n5jl57xvtnb7zagzus5y4i2s@triion65snds>

On Fri, Feb 28, 2025 at 09:27:31AM -0600, Bill O'Donnell wrote:
> On Wed, Feb 26, 2025 at 10:20:02AM -0800, Darrick J. Wong wrote:
> > On Wed, Feb 26, 2025 at 11:32:22AM -0600, bodonnel@redhat.com wrote:
> > > From: Bill O'Donnell <bodonnel@redhat.com>
> > > 
> > > For xfs_repair, there is a case when -EFSBADCRC is encountered but not
> > > acted on. Modify da_read_buf to check for and repair. The current
> > > implementation fails for the case:
> > > 
> > > $ xfs_repair xfs_metadump_hosting.dmp.image
> > > Phase 1 - find and verify superblock...
> > > Phase 2 - using internal log
> > >         - zero log...
> > >         - scan filesystem freespace and inode maps...
> > >         - found root inode chunk
> > > Phase 3 - for each AG...
> > >         - scan and clear agi unlinked lists...
> > >         - process known inodes and perform inode discovery...
> > >         - agno = 0
> > > Metadata CRC error detected at 0x46cde8, xfs_dir3_block block 0xd3c50/0x1000
> > > bad directory block magic # 0x16011664 in block 0 for directory inode 867467
> > > corrupt directory block 0 for inode 867467
> > 
> > Curious -- this corrupt directory block fails the magic checks but
> > process_dir2_data returns 0 because it didn't find any corruption.
> > So it looks like we release the directory buffer (without dirtying it to
> > reset the checksum)...
> > 
> > >         - agno = 1
> > >         - agno = 2
> > >         - agno = 3
> > >         - process newly discovered inodes...
> > > Phase 4 - check for duplicate blocks...
> > >         - setting up duplicate extent list...
> > >         - check for inodes claiming duplicate blocks...
> > >         - agno = 0
> > >         - agno = 1
> > >         - agno = 3
> > >         - agno = 2
> > > bad directory block magic # 0x16011664 in block 0 for directory inode 867467
> > 
> > ...and then it shows up here again...
> > 
> > > Phase 5 - rebuild AG headers and trees...
> > >         - reset superblock...
> > > Phase 6 - check inode connectivity...
> > >         - resetting contents of realtime bitmap and summary inodes
> > >         - traversing filesystem ...
> > > bad directory block magic # 0x16011664 for directory inode 867467 block 0: fixing magic # to 0x58444233
> > 
> > ...and again here.  Now we reset the magic and dirty the buffer...
> > 
> > >         - traversal finished ...
> > >         - moving disconnected inodes to lost+found ...
> > > Phase 7 - verify and correct link counts...
> > > Metadata corruption detected at 0x46cc88, xfs_dir3_block block 0xd3c50/0x1000
> > 
> > ...but I guess we haven't fixed anything in the buffer, so the verifier
> > trips.  What code does 0x46cc88 map to in the dir3 block verifier
> > function?  That might reflect some missing code in process_dir2_data.
> 
> 0x46cc88 maps to xfs_dir3_block_verify (bp=bp@entry=0x7fffbc103610) at xfs_dir2_block.c:56

On my git tree that maps to this code:

	struct xfs_mount	*mp = bp->b_mount;
	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;

	if (!xfs_verify_magic(bp, hdr3->magic))
		return __this_address;

	if (xfs_has_crc(mp)) {
		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
			return __this_address;

So I guess the UUID is broken too.  If you let process_dir2_data step
through the block, does it actually manage to parse whatever's there
without complaints?  And does it recover any entries from that mess?

I'm wondering if xfs_repair should junk the block if it fails the
verifier and there aren't any actual directory entries in it?

--D

> > 
> > > libxfs_bwrite: write verifier failed on xfs_dir3_block bno 0xd3c50/0x8
> > > xfs_repair: Releasing dirty buffer to free list!
> > > xfs_repair: Refusing to write a corrupt buffer to the data device!
> > > xfs_repair: Lost a write to the data device!
> > > 
> > > fatal error -- File system metadata writeout failed, err=117.  Re-run xfs_repair.
> > > 
> > > 
> > > With the patch applied:
> > > $ xfs_repair xfs_metadump_hosting.dmp.image
> > > Phase 1 - find and verify superblock...
> > > Phase 2 - using internal log
> > >         - zero log...
> > >         - scan filesystem freespace and inode maps...
> > >         - found root inode chunk
> > > Phase 3 - for each AG...
> > >         - scan and clear agi unlinked lists...
> > >         - process known inodes and perform inode discovery...
> > >         - agno = 0
> > > Metadata CRC error detected at 0x46ce28, xfs_dir3_block block 0xd3c50/0x1000
> > > bad directory block magic # 0x16011664 in block 0 for directory inode 867467
> > > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > >         - agno = 1
> > >         - agno = 2
> > >         - agno = 3
> > >         - process newly discovered inodes...
> > > Phase 4 - check for duplicate blocks...
> > >         - setting up duplicate extent list...
> > >         - check for inodes claiming duplicate blocks...
> > >         - agno = 0
> > >         - agno = 1
> > >         - agno = 2
> > >         - agno = 3
> > > bad directory block magic # 0x16011664 in block 0 for directory inode 867467
> > > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > > Phase 5 - rebuild AG headers and trees...
> > >         - reset superblock...
> > > Phase 6 - check inode connectivity...
> > >         - resetting contents of realtime bitmap and summary inodes
> > >         - traversing filesystem ...
> > > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > > Metadata CRC error detected at 0x46ce28, xfs_dir3_block block 0xd3c50/0x1000
> > > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > > bad directory block magic # 0x16011664 for directory inode 867467 block 0: fixing magic # to 0x58444233
> > > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > > rebuilding directory inode 867467
> > > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > >         - traversal finished ...
> > >         - moving disconnected inodes to lost+found ...
> > > Phase 7 - verify and correct link counts...
> > > done
> > > 
> > > Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> > > ---
> > >  repair/da_util.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/repair/da_util.c b/repair/da_util.c
> > > index 7f94f4012062..0a4785e6f69b 100644
> > > --- a/repair/da_util.c
> > > +++ b/repair/da_util.c
> > > @@ -66,6 +66,9 @@ da_read_buf(
> > >  	}
> > >  	libxfs_buf_read_map(mp->m_dev, map, nex, LIBXFS_READBUF_SALVAGE,
> > >  			&bp, ops);
> > > +	if (bp->b_error == -EFSBADCRC) {
> > > +		libxfs_buf_relse(bp);
> > 
> > This introduces a use-after-free on the buffer pointer.
> > 
> > --D
> > 
> > > +	}
> > >  	if (map != map_array)
> > >  		free(map);
> > >  	return bp;
> > > -- 
> > > 2.48.1
> > > 
> > > 
> > 
> 
> 
