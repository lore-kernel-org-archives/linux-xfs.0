Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99001191F60;
	Wed,  5 Feb 2025 15:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738771061; cv=none; b=YxA8knOY9kKRU2RNagKdVYTCA12LR6+ED8BO5FqDsONYZ/HlFeUz6morNqYzXALEhW/yrv+0GDhBPbLs8Jah+bl2pYWr+gcu2r5Q68bpC5BEffKr7PqoMBGTf0RMnEWI7wZu4BVZ2f0JDC2ypC6P9ebXy+WsQO6OdSSbsxQzmKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738771061; c=relaxed/simple;
	bh=QFkhLhypgMKJUz2HnvhEp0cFF6CX4Q853aKfaj/oZCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vAqJzOlMdooAo9SIAxW5yoR6geML7MIB1kfyNEdlXgUKv9+UcEDLpHMmmvcc+PlaywbzI9lixki63lFRaYEIvTOF1MWwQehAgcjL3MnaztZHz7tE3/GCLcnZ0rCGvqavoRBFupo5mKcg6KJz6yNpCx9Kam56fC3Np4g53rdYDEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tJx+fhHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tJx+fhHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120D3C4CED6;
	Wed,  5 Feb 2025 15:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738771061;
	bh=QFkhLhypgMKJUz2HnvhEp0cFF6CX4Q853aKfaj/oZCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tJx+fhHS+vCMoCqvkhHym0kspkfiUt1fHyQ2c9SStfaLwRBVkEK2qddVeIJ+9knM2
	 3tneyD9UA5+fyOqzeWAJe8/uw54QdqYjGaXTaOmvOFuacqly68ocd7R5ZbR8r/iVUT
	 +BnjTTixoe/5an4D+1fBohuc8Rtr3sZq0fvfh3YB2bP5iikdEKhlXYmfWL4mg+44sY
	 6HSkmm9VHrJ+CKhgc88WbqRNVBPlBDMlbfkP2m5vsLuSQ/Z1Y0pKqR1Neh1yK7AR6v
	 nX/HCeEYeN2mQQeQ/jpuYG4Bnt3rKGbOz77DfM21VxSCeGNcvY1DKxSX5HFvlFBzln
	 2hB14apWUsGfg==
Date: Wed, 5 Feb 2025 07:57:40 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Catherine Hoang <catherine.hoang@oracle.com>,
	xfs-stable@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6.6 CANDIDATE 00/24] xfs backports for 6.6.y (from 6.12)
Message-ID: <20250205155740.GH21808@frogsfrogsfrogs>
References: <RXFziXyTkkJs02L8mR-Um70po2IisADFkG9XGfYFGhNPh-xy7gNJ_tSvG1ZYBchOAp07owM1mgnBRF1Iw0-TzQ==@protonmail.internalid>
 <20250205030732.29546-1-catherine.hoang@oracle.com>
 <ucnnyrtkfv2rn5bxv6q7en4zekwhksgfxs7wr35m6lk7lwdi4m@xhkswa4a4jvg>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ucnnyrtkfv2rn5bxv6q7en4zekwhksgfxs7wr35m6lk7lwdi4m@xhkswa4a4jvg>

On Wed, Feb 05, 2025 at 09:12:07AM +0100, Carlos Maiolino wrote:
> On Tue, Feb 04, 2025 at 07:07:08PM -0800, Catherine Hoang wrote:
> > Hi all,
> > 
> > This series contains backports for 6.6 from the 6.12 release. Tested on
> > 30 runs of kdevops with the following configurations:
> 
> Hi Catherine.
> 
> I believe the idea of xfs-stable creation was exactly to not flood linux-xfs
> with LTS kernel backports?
> 
> It's not a big deal, but IIRC, the whole idea of xfs-stable was to reduce
> linux-xfs traffic. If we keep Cc'ing both lists on those backports, xfs-stable
> kind of lose its meaning?

Yes, stable patches should be sent to xfs-stable and not linux-xfs.

(Says me who's guilty of doing exactly the same thing.)

--D

> Cheers,
> Carlos
> 
> > 
> > 1. CRC
> > 2. No CRC (512 and 4k block size)
> > 3. Reflink (1K and 4k block size)
> > 4. Reflink without rmapbt
> > 5. External log device
> > 
> > Andrew Kreimer (1):
> >   xfs: fix a typo
> > 
> > Brian Foster (2):
> >   xfs: skip background cowblock trims on inodes open for write
> >   xfs: don't free cowblocks from under dirty pagecache on unshare
> > 
> > Chi Zhiling (1):
> >   xfs: Reduce unnecessary searches when searching for the best extents
> > 
> > Christoph Hellwig (15):
> >   xfs: assert a valid limit in xfs_rtfind_forw
> >   xfs: merge xfs_attr_leaf_try_add into xfs_attr_leaf_addname
> >   xfs: return bool from xfs_attr3_leaf_add
> >   xfs: distinguish extra split from real ENOSPC from
> >     xfs_attr3_leaf_split
> >   xfs: distinguish extra split from real ENOSPC from
> >     xfs_attr_node_try_addname
> >   xfs: fold xfs_bmap_alloc_userdata into xfs_bmapi_allocate
> >   xfs: don't ifdef around the exact minlen allocations
> >   xfs: call xfs_bmap_exact_minlen_extent_alloc from xfs_bmap_btalloc
> >   xfs: support lowmode allocations in xfs_bmap_exact_minlen_extent_alloc
> >   xfs: pass the exact range to initialize to xfs_initialize_perag
> >   xfs: update the file system geometry after recoverying superblock
> >     buffers
> >   xfs: error out when a superblock buffer update reduces the agcount
> >   xfs: don't use __GFP_RETRY_MAYFAIL in xfs_initialize_perag
> >   xfs: update the pag for the last AG at recovery time
> >   xfs: streamline xfs_filestream_pick_ag
> > 
> > Darrick J. Wong (2):
> >   xfs: validate inumber in xfs_iget
> >   xfs: fix a sloppy memory handling bug in xfs_iroot_realloc
> > 
> > Ojaswin Mujoo (1):
> >   xfs: Check for delayed allocations before setting extsize
> > 
> > Uros Bizjak (1):
> >   xfs: Use try_cmpxchg() in xlog_cil_insert_pcp_aggregate()
> > 
> > Zhang Zekun (1):
> >   xfs: Remove empty declartion in header file
> > 
> >  fs/xfs/libxfs/xfs_ag.c         |  47 ++++----
> >  fs/xfs/libxfs/xfs_ag.h         |   6 +-
> >  fs/xfs/libxfs/xfs_alloc.c      |   9 +-
> >  fs/xfs/libxfs/xfs_alloc.h      |   4 +-
> >  fs/xfs/libxfs/xfs_attr.c       | 190 ++++++++++++++-------------------
> >  fs/xfs/libxfs/xfs_attr_leaf.c  |  40 +++----
> >  fs/xfs/libxfs/xfs_attr_leaf.h  |   2 +-
> >  fs/xfs/libxfs/xfs_bmap.c       | 140 ++++++++----------------
> >  fs/xfs/libxfs/xfs_da_btree.c   |   5 +-
> >  fs/xfs/libxfs/xfs_inode_fork.c |  10 +-
> >  fs/xfs/libxfs/xfs_rtbitmap.c   |   2 +
> >  fs/xfs/xfs_buf_item_recover.c  |  70 ++++++++++++
> >  fs/xfs/xfs_filestream.c        |  96 ++++++++---------
> >  fs/xfs/xfs_fsops.c             |  18 ++--
> >  fs/xfs/xfs_icache.c            |  39 ++++---
> >  fs/xfs/xfs_inode.c             |   2 +-
> >  fs/xfs/xfs_inode.h             |   5 +
> >  fs/xfs/xfs_ioctl.c             |   4 +-
> >  fs/xfs/xfs_log.h               |   1 -
> >  fs/xfs/xfs_log_cil.c           |  11 +-
> >  fs/xfs/xfs_log_recover.c       |   9 +-
> >  fs/xfs/xfs_mount.c             |   4 +-
> >  fs/xfs/xfs_reflink.c           |   3 +
> >  fs/xfs/xfs_reflink.h           |  19 ++++
> >  24 files changed, 375 insertions(+), 361 deletions(-)
> > 
> > --
> > 2.39.3
> > 
> > 
> 
