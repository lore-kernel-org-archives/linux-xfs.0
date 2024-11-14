Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFE81EABB7
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 06:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731565000; cv=none; b=scct0tK9xTJkXh0cKPndAzN3SJUgdU1ViGWRK7A6UwJlmxeB6+4EvpjgrDXlgJzdhfYJupntmNed1H2NO+DD4sewo9LMa3pk4+Oohfw3CatIqGC6Z4jalRA4E+e53xnhZgqI3D1TabJCC8bER/eaDj26xv9Cf4LgwykU6g/bkPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731565000; c=relaxed/simple;
	bh=0TMywlQlJ+kIFh/ngRcCJ+DimLzQ1yRiQA4x484LW+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tciycM8wu9wMTHarK6ijIl7625ZvXYJIC+6DVHO+e7yfnM2F5k9NIqD38iz433l9R3INlbvTQK64hBkWy6C0D4n5Qv7gJ9H+d+PlChAi7OfjcbSOFFNihw3RSL9kRcEfKY3VGQTX2zCxWe+kN2Zy4A6hclvaezrFheahXz45M2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nyQdD9H7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nyQdD9H7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35092C4CED0;
	Thu, 14 Nov 2024 06:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731565000;
	bh=0TMywlQlJ+kIFh/ngRcCJ+DimLzQ1yRiQA4x484LW+Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nyQdD9H79s6yVWjn6RkYfW2Ox9OThkMHU7IvhfL92ZcLOeD+1Wl2qBpXjtQq7Aq7M
	 6TjIoLc7zvtsUPdSgSY1ZnQ57M2Lgkmqk3EZwHHc/JUk6CW0TwplqGk1HXGUCoOAWe
	 KdMBEkB7UeuyThWMoEdF12uR/32MoTm8Lb3vrr3fFC/u6hR3gDBvBzFbtptsH8sixr
	 9KXKavA+ktCxn6YQVmK1cKvevFBFqcg6zxC6C9xPPOn3bOxMe3Y1RLtXmaZc2Ya5TU
	 39IlqYAPQ2ZhMdX9ryoksTFu8bWPv4cQq1BCt8ChZGMPeMszBpwEk6x8EIoGEC/VG6
	 7ro7K5GmIQvlg==
Date: Wed, 13 Nov 2024 22:16:39 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULLBOMB v5.6] xfs: metadata directories and realtime groups
Message-ID: <20241114061639.GN9438@frogsfrogsfrogs>
References: <20241114001637.GL9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241114001637.GL9438@frogsfrogsfrogs>

On Wed, Nov 13, 2024 at 04:16:37PM -0800, Darrick J. Wong wrote:
> Hi Carlos,
> 
> Please pull these fully reviewed patchsets for kernel 6.13.  This
> patchbomb corrects numerous paperwork errors in the v5.5 submission so
> that we can pass linux-next linter.
> 
> I have corrected my stgit wrapper program to invoke git checkpatch
> before issuing pull requests.  Despite its name, this means I now have
> automated checks for tagging errors in git commits.  Freeform text
> fields that require a lot of parsing cleverness to check and that can be
> corrupted easily buc*********.
> 
> The following excerpted range diff shows the differences between last
> week's PRs and this week's:
> 
>   1:  62027820eb4486 !   1:  03326f42d6ef7a xfs: fix simplify extent lookup in xfs_can_free_eofblocks
>     @@ Commit message
>          this patch, we'd invoke xfs_free_eofblocks on first close if anything
>          was in the CoW fork.  Now we don't do that.
>      
>          Fix the problem by reverting the removal of the i_delayed_blks check.
>      
>          Cc: <stable@vger.kernel.org> # v6.12-rc1
>     -    Fixes: 11f4c3a53adde ("xfs: simplify extent lookup in xfs_can_free_eofblocks")
>     +    Fixes: 11f4c3a53adde1 ("xfs: simplify extent lookup in xfs_can_free_eofblocks")
>          Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>          Reviewed-by: Christoph Hellwig <hch@lst.de>
>      
>       ## fs/xfs/xfs_bmap_util.c ##
>      @@ fs/xfs/xfs_bmap_util.c: xfs_can_free_eofblocks(
>       		end_fsb = xfs_rtb_roundup_rtx(mp, end_fsb);
>   2:  cd8ae42a82d2d7 =   2:  5bbfaf522b8c42 xfs: fix superfluous clearing of info->low in __xfs_getfsmap_datadev
> ...
>  68:  dcfc65befb76df !  68:  3065c8cf8c7082 xfs: clean up xfs_getfsmap_helper arguments
>     @@ Commit message
>          fsmap irec structure that contains exactly the data we need, once.
>      
>          Note that we actually do need rm_startblock for rmap key comparisons
>          when we're actually querying an rmap btree, so leave that field but
>          document why it's there.
>      
>     -    Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>     +    Signed-off-by: Christoph Hellwig <hch@lst.de>
>          Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>     +    [djwong: fix the SoB tag from hch, somehow my scripts replaced it...]
>          Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>      
>       ## fs/xfs/xfs_fsmap.c ##
>      @@ fs/xfs/xfs_fsmap.c: xfs_fsmap_owner_to_rmap(
>       	}
>       	return 0;
>  69:  87fe4c34a383d5 =  69:  15165713e812d9 xfs: create incore realtime group structures
> ...
>  83:  1029f08dc53920 !  83:  08ed382bba4f52 xfs: factor out a xfs_growfs_rt_alloc_fake_mount helper
>     @@ Commit message
>      
>          Note that this changes the rmblocks calculation method to be based
>          on the passed in rblocks and extsize and not the explicitly passed
>          one, but both methods will always lead to the same result.  The new
>          version just does a little bit more math while being more general.
>      
>     -    Signed-off-by: Christoph Hellwig <hch@lst.de>
>     -    Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>          Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>     +    Reviewed-by: Christoph Hellwig <hch@lst.de>

hch pointed out that I reversed the polarity on this change and the one
after it; both should be From/SOB him, and RVB me.  So I'll send a v5.7
with that fixed.  Never mind that it's 22:15 and I've been dragged back
to work because we're running the hell out of time.  I hate all this
petty bureaucratic shit that's hard to manage.

--D

>       ## fs/xfs/xfs_rtalloc.c ##
>      @@ fs/xfs/xfs_rtalloc.c: xfs_rtginode_ensure(
>       
>       	if (error != -ENOENT)
>       		return 0;
>  84:  fc233f1fb0588a =  84:  bc1cc1849a4bfe xfs: use xfs_growfs_rt_alloc_fake_mount in xfs_growfs_rt_alloc_blocks
> ...
> 110:  b91afef724710e ! 110:  2a81329aa08d66 xfs: don't merge ioends across RTGs
>     @@ Commit message
>          Unlike AGs, RTGs don't always have metadata in their first blocks, and
>          thus we don't get automatic protection from merging I/O completions
>          across RTG boundaries.  Add code to set the IOMAP_F_BOUNDARY flag for
>          ioends that start at the first block of a RTG so that they never get
>          merged into the previous ioend.
>      
>     -    Signed-off-by: Christoph Hellwig <hch@lst.de>
>     -    Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>          Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>     +    Reviewed-by: Christoph Hellwig <hch@lst.de>
>      
>       ## fs/xfs/libxfs/xfs_rtgroup.h ##
>      @@ fs/xfs/libxfs/xfs_rtgroup.h: xfs_rtb_to_rgbno(
>       	struct xfs_mount	*mp,
>       	xfs_rtblock_t		rtbno)
>       {
> 111:  d162491c5459f4 = 111:  4895d7326c2f49 xfs: make the RT allocator rtgroup aware
> ...
> 139:  13877bc79d8135 = 139:  b038df088d5bf2 xfs: port ondisk structure checks from xfs/122 to the kernel
> 
> Apologies for the last minute churn and paperwork stress.
> 
> --D
> 
