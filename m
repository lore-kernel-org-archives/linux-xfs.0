Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CA62DC792;
	Tue,  6 Oct 2026 05:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791263607; cv=none; b=uYj//Po+B7ntLxTy3G9yhmpLgiy5jzFfwzXLfiqkSXYslH4SXZS7TBBgkCQ5LANiu8HiDoky9/OojUYHEidZaUqPeI12CGFsZJQ7tXgzmbu2oI4pHtSi8lyBu/YI3VWUTVU5HYLt6TUQsm/1tqFTL3zNKYYt4ITwapTiobQEM4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791263607; c=relaxed/simple;
	bh=G7/E9NSb+g9nF3NJXRM7t//sbhETCtMzAAg/iah6UuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h38yORLsk4DIzfKqt5cfrt5stILg01OyWva6IxQYBr7aWJXma3LYaNKYk/34rTZzcdMvVqO9bS19xfVGloueAzOSBPXG6Z3TpvxF2rX2/bJjdR9SenxJT7DsIIzr5BersWNNGYX5G0wZCrpvr496ah3pIeLyiAniAmzWdV7WpaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FrE9A7B7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FrE9A7B7"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 18EF31F000FF;
	Tue,  6 Oct 2026 05:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791263605;
	bh=9Sai79UzyLyMiCUObaR4mGisnpxjcvP58Zvr/GHun3k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FrE9A7B7wCyshXEHUeQ+44JsyBO4maHfbNuvzGw9XcJblI7g0/OCJeeGsQJV7h308
	 bFKj8MMirvQiY5HdgBTA6Dgxc2c8Wh3qRKjJN1iEuGn9kT65qCb8o0g+anmsEZnfZj
	 LXVrJ6nbam6AflfYYdTXem5GyzfgpfDFEip9+Pkug0ZDFtRKalxcJ3/Cf0Y/MenHzB
	 jRaaW+8zcbFl3JN7ZG+ke6Ho/ayssjdYL2PSrmPmh1hNvG/j2r/WChPoQrz0a7CPoP
	 naQgeCqHpINvcwyeCkqTU+tyXkPFVFSYnLvJELsTmQ53mCV+YB5QXxdaa5CehBwjTn
	 l9mT0axO+PJGw==
Date: Mon, 5 Oct 2026 22:13:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Daejun Park <daejun7.park@samsung.com>
Cc: "cem@kernel.org" <cem@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"dai.ngo@oracle.com" <dai.ngo@oracle.com>,
	"hch@lst.de" <hch@lst.de>, "dgc@kernel.org" <dgc@kernel.org>,
	"sergeybashirov@gmail.com" <sergeybashirov@gmail.com>,
	"cel@kernel.org" <cel@kernel.org>,
	"jlayton@kernel.org" <jlayton@kernel.org>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: map pNFS layouts to the end of the extent again
Message-ID: <20261006051324.GV2705364@frogsfrogsfrogs>
References: <CGME20261006003425epcms2p586728e55ff5f9bbabc506b672fc4a421@epcms2p5>
 <20261006003425epcms2p586728e55ff5f9bbabc506b672fc4a421@epcms2p5>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006003425epcms2p586728e55ff5f9bbabc506b672fc4a421@epcms2p5>

On Tue, Oct 06, 2026 at 09:34:25AM +0900, Daejun Park wrote:
> Since commit 36ca6f11424a ("xfs: fix overlapping extents returned for
> pNFS LAYOUTGET"), xfs_fs_map_blocks() maps only the range that nfsd asks
> for.  For O_DIRECT, the Linux block layout client asks for the range of
> the I/O at hand, so it now needs a LAYOUTGET for every O_DIRECT read or
> write to a part of a file it has no layout for yet, where the first
> LAYOUTGET used to return the whole extent.  Each LAYOUTGET is a round
> trip, and xfs_fs_map_blocks() takes the iolock exclusively and writes
> back and invalidates the page cache of the file for it.
> 
> On three QEMU VMs (an NVMe/TCP target, the server with nfsd and XFS, and
> a client) running the same kernel without KASAN or lock debugging, a
> client doing O_DIRECT I/O over the block layout of NFSv4.2 for 30
> seconds to a 1 GiB file of one written extent, in order unless noted and
> with an fsync every 16 MiB written, gets this many I/Os done (and
> LAYOUTGETs counted at the server), one run each:
> 
>                        unpatched   ENTIRE, no trim      this patch
>   4 KiB reads      41207 (41207)        334931 (1)      343749 (1)
>   4 KiB random     36670 (34148)        259527 (1)     263829 (15)
>   4 KiB overwrite  38556 (38556)        325533 (1)      307105 (1)
>   64 KiB reads     70241 (16384)         80829 (1)       91196 (1)
>   1 MiB reads       6857 (1024)           6759 (1)        6706 (1)
> 
> "ENTIRE, no trim" is a test kernel that maps with XFS_BMAPI_ENTIRE and
> does not trim.  The random reads need a LAYOUTGET each time they go
> before the lowest offset read so far, as the part of the extent before
> the offset asked for is not mapped.  1 MiB overwrites and writes to an
> unwritten extent also go from 1024 LAYOUTGETs to 1, with no clear change
> in I/Os done.  Appending to a new file needs a LAYOUTGET per 1 MiB
> appended either way, as XFS allocates only the range asked for on a
> filesystem without a stripe unit or an extent size hint.
> 
> The overlap fixed by that commit comes from XFS_BMAPI_ENTIRE reaching
> back.  nfsd4_block_proc_layoutget() calls ->map_blocks once per extent
> of a LAYOUTGET, each time for the range left after the previous extent.
> An allocation in one call can merge the extent that the next call starts
> in with the extents before it, and the whole extent then starts before
> the offset of that call and overlaps extents already in the layout.  The
> Linux client rejects such a layout (verify_extent() returns -EIO), and
> the I/O that needed it fails.
> 
> In the thread of that commit, Christoph Hellwig asked for
> XFS_BMAPI_ENTIRE to be dropped to stop the overlap, Darrick J. Wong
> agreed, and it was said that the flag makes no difference on the first
> call, which is for the whole range the client asked for.  The difference
> is past that range: the Linux client asks for the range of each O_DIRECT
> I/O and uses the rest of a longer layout for the I/Os that follow, which
> RFC 8881 allows (Table 22 sets only a minimum length).  A client could
> ask for more for a read layout, but for a write layout
> xfs_fs_map_blocks() allocates any hole in the range asked for.
> 
> Dave Chinner suggested keeping the flag for the first call and trimming
> the mappings of the calls that follow.  ->map_blocks cannot tell the
> first call from the others, and Christoph preferred to keep such a
> choice out of that interface, so trim every mapping to start at the
> offset asked for instead.  No mapping can then overlap the one before
> it, since each call starts where the previous extent ended.  Unlike
> Dave's suggestion, the first mapping loses the part of the extent before
> the offset, and the last mapping keeps the part past the end of the
> range, which the loop in nfsd4_block_proc_layoutget() already handles.
> Trimming in that loop instead would keep his suggestion exactly, but
> would change nfsd as well, while trimming in XFS keeps every mapping it
> returns free of overlap whatever the caller does.
> 
> Unlike before that commit, don't let the mapping reach past EOF beyond
> the range asked for.  On an inode without XFS_DIFLAG_PREALLOC or
> XFS_DIFLAG_APPEND, xfs_free_eofblocks() can free blocks past EOF, such
> as speculative preallocation, without breaking the layout, so a client
> that did not ask for them should not get them.  What a client gets for a
> range past EOF that it asks for does not change.
> 
> The aio group, the fsx tests and generic/013 (fsstress) of fstests over
> the block layout, and the fsx tests and generic/013 over the SCSI
> layout, give the same results with and without this patch.  generic/091
> and 263 fail with the ENTIRE, no trim kernel and pass with this patch,
> and so does the pynfs test BLOCK5, which checks a write layout over a
> hole between two allocated blocks against three rules of RFC 5663
> section 2.3.1.
> 
> Fixes: 36ca6f11424a ("xfs: fix overlapping extents returned for pNFS LAYOUTGET")
> Cc: stable@vger.kernel.org
> Suggested-by: Dave Chinner <dgc@kernel.org>
> Link: https://lore.kernel.org/r/ageSguSyf2kBY33a@dread
> Link: https://lore.kernel.org/r/agwDhixPAAA0-cTa@infradead.org
> Link: https://lore.kernel.org/r/agqfBPRWXQDR2ImG@infradead.org
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---
> This is meant as the small fix for stable.  It does not stand in the
> way of letting ->map_blocks return several mappings per call, which
> was raised in the thread of that commit.
> 
> Tested on nfsd-testing 32eb1a60b456 (7.3-rc4), on the three VMs above.
> Its fs/xfs/xfs_pnfs.c and xfs_bmap_util.c are the same as in this base;
> its xfs_iomap.c and libxfs/xfs_bmap.c differ only in the error path of
> xfs_iomap_write_direct(), zoned writes and two unused arguments.  For
> the SCSI layout, the target ran 7.3-rc1 with two fixes to
> nvmet_pr_preempt(), which fencing a client through a reservation preempt
> relies on:
> 
> - With KASAN, lockdep and CONFIG_XFS_DEBUG, 20 of the 31 tests of the
>   aio group, the fsx tests and generic/013 run over the block layout
>   (FSX_AVOID=-E), and the same ones fail with and without this patch:
>   generic/075, 112 and 127 with an fsx "Size error" within 390
>   operations, and 551 with the client out of memory.  Over the SCSI
>   layout, generic/013, 075, 091, 112, 127 and 263 run, and 075, 112 and
>   127 fail the same way.
> - Without KASAN or lock debugging, generic/551 passes with and without
>   this patch with 16 GiB of client memory.  With the ENTIRE, no trim
>   kernel, generic/075, 091 and 263 fail with a zero-length O_DIRECT
>   write or an msync() EIO, and bl_alloc_lseg() on the client returns
>   -EIO three times.  On the unpatched kernel and with this patch only
>   075 fails, with the "Size error", and bl_alloc_lseg() returns no
>   error.
> - The pynfs test BLOCK5 fails in five runs out of five with the ENTIRE,
>   no trim kernel, and passes in five out of five on the unpatched
>   kernel and with this patch.  It is at
>   https://lore.kernel.org/r/20261006002622epcms2p38e492aef17fdf79e48b05c9aada2918d@epcms2p3
> 
>  fs/xfs/xfs_pnfs.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index f8535ecde..ab3856170 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -183,13 +183,28 @@ xfs_fs_map_blocks(
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  
>  	lock_flags = xfs_ilock_data_map_shared(ip);
> -	/* request mappings for the specified range only */
> +	/*
> +	 * Map to the end of the extent that covers the start of the range,
> +	 * so that a client doing I/O in pieces gets a layout it can use for
> +	 * the pieces that follow.  Never map anything before the start of
> +	 * the range: nfsd calls in here once per extent of a LAYOUTGET, for
> +	 * the range that is left after the previous extent, and the mapping
> +	 * can change in between, so a mapping that reaches back can overlap
> +	 * one already in the layout.  Don't extend the mapping past EOF
> +	 * beyond the range either: xfs_free_eofblocks() can free blocks past
> +	 * EOF without breaking the layout.
> +	 */
>  	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
> -				&imap, &nimaps, 0);
> +				&imap, &nimaps, XFS_BMAPI_ENTIRE);
>  	if (error) {
>  		xfs_iunlock(ip, lock_flags);
>  		goto out_unlock;
>  	}
> +	if (nimaps)
> +		xfs_trim_extent(&imap, offset_fsb,
> +				max_t(xfs_fileoff_t, end_fsb,
> +				      XFS_B_TO_FSB(mp, XFS_ISIZE(ip))) -
> +				offset_fsb);

This is a clever solution -- report a mapping for at least the first
block at @offset, potentially going past @length up to EOF.

I wonder, though, should the caller (i.e. NFS) do this trimming to
protect itself from other filesystems making the same mistake?

--D

>  	seq = xfs_iomap_inode_sequence(ip, 0);
>  
>  	ASSERT(!nimaps || imap.br_startblock != DELAYSTARTBLOCK);
> 
> base-commit: b942c6919ac39870f8327d3123a2912d96e7e617
> 
