Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF4150095E
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 16:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767974875; cv=none; b=kgEOIeGeTV2nlwaYSQ4W6QCY2gKQsMUFatd6P4LiVx1kOLuNbBxxPCx38edtOKOctYYvqlcVfj0AvUABStsaJNbuyIbsewwGI7ufQ+AHX8hr9qMc8Krhcf3ifKxSQ8ctzyB5zO25kIVXLqbXFQKlSvKq2VKfFn8P/IO5MjVAMXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767974875; c=relaxed/simple;
	bh=sPgnV2r9/TQZ/j1WTtABfucRTLOrmvmAh0I5bN9MzVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mLTecooztlvNu27ZQBXdJ4+WBiMZOyW1T71ywP5vqtlmHdpiqb6VPxarxBprkwSZ3QQ/6PioR9lA65tQ4//9BsrSrCXHvmxxWFUoVtzAjQzdKArHX1IaS15Y697jZEBpY5rwtTfoNQIDqJZKgFPHi6YE/etGTbO/RrOzQCZ4WDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fyVo3h8c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fyVo3h8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49194C4CEF7;
	Fri,  9 Jan 2026 16:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767974875;
	bh=sPgnV2r9/TQZ/j1WTtABfucRTLOrmvmAh0I5bN9MzVA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fyVo3h8ctPmJIaflegCZ9TmIY5sDc+EK/g7GYxml7Dq5kYrjdy6MbI6XmqVxubNg2
	 OGSh2T9YumnRlsYRK+pAg23i+HgEM8y8mg5/HJDG5fGxdFhv3tWP8wfcgJZsNhvO2F
	 EDH/RjqSy92m3W6c3hTKshFXJKwdgSIALCFZohICKSAw2lkJwxLTwCwZh6pNUu0Uzp
	 ieRc6ISereTQpPqLt6Af8X42hssSWmNOX97eIbLYnNiUf0w2O5ShqU3RHdovKPL/up
	 CpzYxALPep9hfW2y33eQDuLn2TrtoBPVUIxzCfMaqklF/5QSPmbVQeOq3m+S88CusA
	 5gzrMRU5aDt/g==
Date: Fri, 9 Jan 2026 08:07:54 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: set max_agbno to allow sparse alloc of last full
 inode chunk
Message-ID: <20260109160754.GM15551@frogsfrogsfrogs>
References: <20260108141129.7765-1-bfoster@redhat.com>
 <20260108171047.GL15551@frogsfrogsfrogs>
 <aWAH4Is4X9GDtOAz@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWAH4Is4X9GDtOAz@bfoster>

On Thu, Jan 08, 2026 at 02:39:12PM -0500, Brian Foster wrote:
> On Thu, Jan 08, 2026 at 09:10:47AM -0800, Darrick J. Wong wrote:
> > On Thu, Jan 08, 2026 at 09:11:29AM -0500, Brian Foster wrote:
> > > Sparse inode cluster allocation sets min/max agbno values to avoid
> > > allocating an inode cluster that might map to an invalid inode
> > > chunk. For example, we can't have an inode record mapped to agbno 0
> > > or that extends past the end of a runt AG of misaligned size.
> > > 
> > > The initial calculation of max_agbno is unnecessarily conservative,
> > > however. This has triggered a corner case allocation failure where a
> > > small runt AG (i.e. 2063 blocks) is mostly full save for an extent
> > > to the EOFS boundary: [2050,13]. max_agbno is set to 2048 in this
> > > case, which happens to be the offset of the last possible valid
> > > inode chunk in the AG. In practice, we should be able to allocate
> > > the 4-block cluster at agbno 2052 to map to the parent inode record
> > > at agbno 2048, but the max_agbno value precludes it.
> > > 
> > > Note that this can result in filesystem shutdown via dirty trans
> > > cancel on stable kernels prior to commit 9eb775968b68 ("xfs: walk
> > > all AGs if TRYLOCK passed to xfs_alloc_vextent_iterate_ags") because
> > > the tail AG selection by the allocator sets t_highest_agno on the
> > > transaction. If the inode allocator spins around and finds an inode
> > > chunk with free inodes in an earlier AG, the subsequent dir name
> > > creation path may still fail to allocate due to the AG restriction
> > > and cancel.
> > > 
> > > To avoid this problem, update the max_agbno calculation to the agbno
> > > prior to the last chunk aligned agbno in the AG. This is not
> > > necessarily the last valid allocation target for a sparse chunk, but
> > > since inode chunks (i.e. records) are chunk aligned and sparse
> > > allocs are cluster sized/aligned, this allows the sb_spino_align
> > > alignment restriction to take over and round down the max effective
> > > agbno to within the last valid inode chunk in the AG.
> > > 
> > > Note that even though the allocator improvements in the
> > > aforementioned commit seem to avoid this particular dirty trans
> > > cancel situation, the max_agbno logic improvement still applies as
> > > we should be able to allocate from an AG that has been appropriately
> > > selected. The more important target for this patch however are
> > > older/stable kernels prior to this allocator rework/improvement.
> > 
> > <nod> It makes sense to me that we ought to be able to examine space out
> > to the final(ish) agbno of the runt AG.
> > 
> > Question for you: There are 16 holemask bits for 64 inodes per inobt
> > record, or in other words the new allocation has to be aligned at least
> > to the number of blocks needed to write 4 inodes.  I /think/
> > sb_spino_align reflects that, right?
> > 
> 
> Pretty much.. If I recall all the details correctly, the holemask bit
> per 4-inode ratio was more of a data structure thing. That was just
> based on how much space we had in the standard inode chunk record
> freecount field to repurpose to track "holes" in an inode chunk.
> 
> The alignment rules had to change for higher level design raisins,
> because if we allocated some sparse chunk out of fragmented free space
> we need a consistent way to map it back to an inode record without
> causing conflicts across multiple inode records (i.e. accidental record
> overlap or whatever else). So therefore when sparse inodes are enabled,
> at mkfs time we change inode chunk alignment from cluster size to full
> inode chunk size, and set sparse chunk alignment to the cluster size.
> 
> This creates an inherent mapping for a sparse inode chunk to an inode
> record because the cluster aligned sparse chunk always maps to whatever
> chunk aligned record covers it (so we know whether to allocate a new
> inode record or use one that might already be sparse based on the sparse
> alloc, etc.).

<nod> Ok, that's what I was thinking, so I'm glad I asked. :)

> > > Fixes: 56d1115c9bc7 ("xfs: allocate sparse inode chunks on full chunk allocation failure")
> > 
> > Cc: <stable@vger.kernel.org> # v4.2
> > 
> 
> Thanks. Do you want me to repost with that or shall the maintainer
> handle it? ;)

Well first things first ;)

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

If you want to repost with the cc and the rvb tag then please do that.
If not, then Carlos, can you include both when you add this to for-next,
please?

--D


> Brian
> 
> > --D
> > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_ialloc.c | 11 ++++++-----
> > >  1 file changed, 6 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > > index d97295eaebe6..c19d6d713780 100644
> > > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > > @@ -848,15 +848,16 @@ xfs_ialloc_ag_alloc(
> > >  		 * invalid inode records, such as records that start at agbno 0
> > >  		 * or extend beyond the AG.
> > >  		 *
> > > -		 * Set min agbno to the first aligned, non-zero agbno and max to
> > > -		 * the last aligned agbno that is at least one full chunk from
> > > -		 * the end of the AG.
> > > +		 * Set min agbno to the first chunk aligned, non-zero agbno and
> > > +		 * max to one less than the last chunk aligned agbno from the
> > > +		 * end of the AG. We subtract 1 from max so that the cluster
> > > +		 * allocation alignment takes over and allows allocation within
> > > +		 * the last full inode chunk in the AG.
> > >  		 */
> > >  		args.min_agbno = args.mp->m_sb.sb_inoalignmt;
> > >  		args.max_agbno = round_down(xfs_ag_block_count(args.mp,
> > >  							pag_agno(pag)),
> > > -					    args.mp->m_sb.sb_inoalignmt) -
> > > -				 igeo->ialloc_blks;
> > > +					    args.mp->m_sb.sb_inoalignmt) - 1;
> > >  
> > >  		error = xfs_alloc_vextent_near_bno(&args,
> > >  				xfs_agbno_to_fsb(pag,
> > > -- 
> > > 2.52.0
> > > 
> > > 
> > 
> 
> 
