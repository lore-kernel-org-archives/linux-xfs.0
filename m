Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8904A3D42;
	Wed,  7 Oct 2026 13:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791378708; cv=none; b=I1l24NQEYPKUWFoT6FOXLsZrD5OK5pECzbzQm1UKPovZua9gueEq9rTN3ic5PdmBmafWTmCsWszh8L29TYjro7gOAerfLShF3Q5cZHCGIaPez8UhFINiwSbr2jNn/G+Y4TcEGrFMmMTXlF6+NMw+850DiEPw37bLAyvS5ZehChU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791378708; c=relaxed/simple;
	bh=Jl1fGslSq23PuWAgeHPLvlMIsxoSFG51VMiODGM2w7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QHOc+bkfYNNEoOEeK7sp/HqyHqY/k+cYxPlqJ82VBmtfm/ZgWzI9njvrnasTPRCMB1RbaEsiW3sUtLdUpcpJiPTAZfTYEwb17ZYflRI+gDJgt3CZ08z96aHRjreRaiM/2/ejtYyZDzDqPuizbEVUtfXdLfOha63hLxOCUlfJbl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 12A1468AFE; Wed,  7 Oct 2026 15:11:34 +0200 (CEST)
Date: Wed, 7 Oct 2026 15:11:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: daejun7.park@samsung.com
Cc: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>, linux-nfs@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfsd: do not return overlapping extents in a block
 layout
Message-ID: <20261007131133.GB30647@lst.de>
References: <20261007-nfsd-block-trim-v1-1-53370f97047a@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007-nfsd-block-trim-v1-1-53370f97047a@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 07, 2026 at 11:03:01AM +0900, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> Since commit cc6c40e09d7b ("NFSD/blocklayout: Support multiple extents
> per LAYOUTGET"), nfsd4_block_proc_layoutget() calls ->map_blocks once
> per extent of a LAYOUTGET, each time for the range left after the
> previous extent. nfsd4_block_map_extent() takes a mapping that starts at
> the offset asked for or below it, but only the first extent may start
> below it. A later extent that starts below its offset overlaps the
> extents before it, which RFC 5663 section 2.3.1 does not allow. The
> Linux client rejects such a layout (verify_extent() returns -EIO), and
> the I/O that needed it fails. The block and SCSI layouts share this
> code.
> 
> XFS, the only ->map_blocks implementation, used to map the whole extent
> that contains the offset. Together with one call per extent, that gave
> overlapping layouts in v6.19 and v7.0: allocating the blocks for one
> extent of a write layout could merge the extent that the next call
> starts in with the unwritten extents before it. Since commit
> 36ca6f11424a ("xfs: fix overlapping extents returned for pNFS
> LAYOUTGET"), XFS does not map below the offset, so this patch changes
> nothing with current XFS. It only stops nfsd from relying on that: trim
> each extent after the first so that it starts at the offset asked for,
> and move its volume offset by the same amount unless it is a NONE_DATA
> extent, which has none.
> 
> nfsd leaves the end of a mapping alone, as only the filesystem knows
> where it should end. It does need a mapping that contains the offset
> asked for, which RFC 5663 section 2.3.1 also requires of the first
> extent. A mapping that does not would leave a gap in the layout or make
> the length computed from it wrap around, so warn and return
> NFS4ERR_LAYOUTUNAVAILABLE; the client then does the I/O through the
> metadata server. iomap_iter_done() has the same check, as a
> WARN_ON_ONCE(), for ->iomap_begin(), and nfsd4_block_map_extent()
> already warns and fails this way for a mapping of an unexpected type.
> Document in exportfs_block.h that the mapping must contain the offset.
> 
> On a test kernel whose xfs_fs_map_blocks() maps with XFS_BMAPI_ENTIRE
> and does not trim, as XFS did before that commit, a write layout over a
> hole between two unwritten blocks comes back as 0+4096, 4096+4096 and
> 0+12288, and the pynfs test BLOCK5 fails in five runs out of five.
> fstests generic/075, 091 and 263 over the block layout fail with an EIO
> or a zero-length O_DIRECT write, and bl_alloc_lseg() on the client
> returns -EIO three times. With this patch on top, the third extent is
> 8192+4096, BLOCK5 passes in five runs out of five, generic/091 and 263
> pass, generic/075 fails with the fsx "Size error" that it also fails
> with on nfsd-testing, and bl_alloc_lseg() returns no error.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But given that you're pretty active in this part of nfsd now, can you
also look into my earlier suggestion to allow a single map_blocks
return multiple mappings?  That solves more of the root cause of
creating incoherencies.

