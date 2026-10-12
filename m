Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A013AAF49;
	Mon, 12 Oct 2026 12:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791808885; cv=none; b=dsQ055LdxZ8kxwkcM87SlL2CRjVwpcGlCJjohT8SQOiDTPT+WTuUvVtwdMBzx2Ckj7G4tv1xX807AQIyhLouUvFa2L9PKAw61x4lHQaSaoppEcSDQ9x7q4p3a1Rih7bOp88omg4Whl6wTFkkSNKjXeg0gCfhE0vWEGOoYvn5exI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791808885; c=relaxed/simple;
	bh=+FOho3qb91Jw2HbYyPDX5kdahRb6n60x3+jpBElUeuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oMwPvYE0KdLEbuQOxKTdcEIlG1PUEcGlHLkA5P44iu8tvrc8XVIA+lJqy3JvTbZ6PC/J0F8Sb2bdvIVO1vEcXVppMC9BJHY2WaEzyJMJqxmMVFtGWfA/h61yrSlE4sZd7/qykKJETfdDYfytl2nPWJzKEmwKoIeTEQc6DEGW+qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E58626732A; Mon, 12 Oct 2026 14:41:18 +0200 (CEST)
Date: Mon, 12 Oct 2026 14:41:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] xfs: mark the inode preallocated for pNFS write
 layouts past EOF
Message-ID: <20261012124118.GB32488@lst.de>
References: <20261012-xfs-pnfs-eof-prealloc-v1-1-e4864d917a00@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012-xfs-pnfs-eof-prealloc-v1-1-e4864d917a00@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 12, 2026 at 12:04:42PM +0900, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> xfs_fs_map_blocks() marks the inode XFS_DIFLAG_PREALLOC after it
> allocates blocks for a write layout, so that xfs_free_eofblocks() does
> not free blocks past EOF that a client may write to. But a write layout
> for a range past EOF where blocks are already allocated, such as the
> speculative preallocation of buffered writes, gets those blocks without
> an allocation, and the inode is not marked. blockgc, or the release of
> the file, then frees them without breaking the layout. The client still
> writes to them, and they may belong to another file by then.
> 
> With pynfs as the client, a file grown to 1 MiB by two buffered writes
> on the server had 960 KiB preallocated past EOF, and an RW LAYOUTGET for
> that range got it as one INVALID_DATA extent, without the inode being
> marked. About 300 seconds later, with the default
> speculative_prealloc_lifetime, blockgc freed those blocks while the
> layout was still held. When the client then wrote through the layout and
> sent LAYOUTCOMMIT, xfs_fs_commit_blocks() found a hole where the
> unwritten extent had been, and xfs_iomap_write_unwritten() allocated for
> it with no blocks reserved:
> 
>   XFS (nvme0n1): Corruption of in-memory data (0x8) detected at
>     xfs_trans_mod_sb+0x817/0x960 (fs/xfs/xfs_trans.c:351).
>     Shutting down filesystem.
>   ...
>    xfs_trans_mod_sb+0x817/0x960
>    xfs_alloc_vextent_finish+0x2e7/0x990
>    xfs_alloc_vextent_start_ag+0x25d/0x720
>    xfs_bmap_btalloc+0xdd2/0x1720
>    xfs_bmapi_allocate+0x197/0xf90
>    xfs_bmapi_write+0x4d0/0xb60
>    xfs_iomap_write_unwritten+0x307/0x7e0
>    xfs_fs_commit_blocks+0x1d9/0x630
>    nfsd4_block_proc_layoutcommit+0x5c2/0x7d0
>    nfsd4_layoutcommit+0x4b5/0xa20
> 
> The client got NFS4ERR_IO, in six runs out of six. When small files were
> written on the server after blockgc, with a sync first so that the freed
> extents were no longer busy, they got those blocks, and the client's
> write through the layout replaced 978944 bytes of their data before the
> LAYOUTCOMMIT. A LAYOUTGET and LAYOUTCOMMIT 30 seconds apart, before
> blockgc runs, leave the client's data in place.
> 
> Mark the inode also when a write mapping ends past EOF and nothing was
> allocated, the same way as for an allocation, before the blocks are
> handed out. With this, the same test keeps the blocks past blockgc, and
> the LAYOUTCOMMIT after 360 seconds succeeds with the data in place.
> 
> Fixes: 527851124d10 ("xfs: implement pNFS export operations")
> Cc: stable@vger.kernel.org
> Reported-by: Chuck Lever <cel@kernel.org>
> Link: https://lore.kernel.org/r/4de5356f-bc4d-4f1a-9c81-fce09b1b46fd@slotpi15m67
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---
> Tested with this patch on nfsd-testing (3af417ce0f30), where xfs_pnfs.c
> differs from xfs for-next only by commit e3c682dd1130 ("xfs: map pNFS
> layouts to the end of the extent again"), with KASAN and lockdep, XFS on
> an NVMe/TCP namespace shared by the server and the client:
> 
> - the reproducer above (a local pynfs test, not posted);
> - pynfs block, blockextent and a local multi-extent test, 2 runs: 15
>   pass, BLOCK3 fails with NFS4ERR_BADXDR for its empty layoutupdate, as
>   without this patch;
> - fstests generic/075, 091 and 263 with the Linux client over the block
>   layout: only 075 fails, as without this patch.
> 
> Chuck pointed this out in the review of the ->map_blocks series, whose
> patch 7 will carry the same check for all mappings of a call:
> https://lore.kernel.org/r/4de5356f-bc4d-4f1a-9c81-fce09b1b46fd@slotpi15m67
> ---
>  fs/xfs/xfs_pnfs.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index ab38561700..490b48e2ce 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -235,6 +235,23 @@ xfs_fs_map_blocks(
>  
>  	} else {
>  		xfs_iunlock(ip, lock_flags);
> +
> +		/*
> +		 * Blocks past EOF that were allocated for buffered writes, such
> +		 * as speculative preallocation, can be freed by
> +		 * xfs_free_eofblocks() without breaking the layout unless the
> +		 * inode is marked as preallocated. Mark it before handing them
> +		 * out for writing, as for blocks allocated above.
> +		 */
> +		if (write && !(ip->i_diflags & XFS_DIFLAG_PREALLOC) &&
> +		    imap.br_startoff + imap.br_blockcount >
> +		    XFS_B_TO_FSB(mp, XFS_ISIZE(ip))) {
> +			error = xfs_fs_map_update_inode(ip);
> +			if (!error)
> +				error = xfs_log_force_inode(ip);
> +			if (error)
> +				goto out_unlock;
> +		}

Let's avoid the code duplication here.  Add a boolean flag that
we need the update, set it both for the new allocation in the if
le, and based on the condition here, and then do the update
in a separate conditional below.

And mayne the xfs_log_force_inode should move into
xfs_fs_map_update_inode while we're at it.
