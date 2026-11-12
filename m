Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794490450;
	b=2n6Ssjo6jBep5OTRtHjGnAoNaAAfzopdEupB2prE2O9RNGrPXawIt4i5RyxOuOmKAvOJ
	 sa1AcItfrxIQ1sQngeW7zSPK2z9KhspJCZ0HA2Q9AXWItckNOCZ82Q1jdnZbNy3PFjauD
	 /P1r/V627sYHUCtN2KCwlkyFao633RmFii6GAopmX9vZLK7anBVeLAdmreSh20t0qaF6+
	 dx/LY6dbz1t/8gvrR9n68RptpKVpiJUw2UHpbNFtWXWNpqxe1+kLFte8IX170vi57chvx
	 5JDMvEkkDwuQ31p314fvp6KBtBn04jgYND5Bus2EplaACmpn2GY8UNIRyjCNGW25MmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794490450;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=CBKekYMv1yODu1Hhni9YQMRnZ2R0/Puj1Zsf+AAfSZg=;
	b=VQgJnhCTr2F2LhT6ehMEv5U+J1MuYC1ecpV0jV1muphfo099TvqO0EVnbYAK6XJpFMld
	 +ju+GCyGjvmicoibSwBdOwoUwKxRaqGgQURL5I9jwsyk4WFwj//TWInHqFytN1LrxA9PK
	 M3CW2XKHJN1QZMV9A0obh3/qaeq46i59qlcIHC6YeMvyxyt2frfaJ88Cgmg2OKvTVLeuE
	 Xl3aJCIRQm2+Hv2RNz0PU4QjTXxx17dSq6hJRxt525NqRbqdTJBf8j0+Bido9J9Ner4rZ
	 Pp0aKfEYNWnlteGP6Obox+2YmtV3hi45Iggs+aI+eSuz86v55Ax1SCJi5RsbCct+qSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A74D606A31C;
	Thu, 12 Nov 2026 13:34:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A74D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7C4E06732A; Thu, 12 Nov 2026 14:34:03 +0100 (CET)
Date: Thu, 12 Nov 2026 14:34:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chris Mason <mason@kernel.org>
Cc: tytso@mit.edu, cem@kernel.org, david@fromorbit.com, jack@suse.cz,
	djwong@kernel.org, josef@toxicpanda.com, hch@lst.de,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, tz2294@columbia.edu, brauner@kernel.org
Subject: Re: [PATCH v8 11/15] xfs: restart faults racing with realtime flag
 changes
Message-ID: <20261112133403.GA22165@lst.de>
References: <20261112010229.51029-1-mason@kernel.org> <20261112010229.51029-12-mason@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112010229.51029-12-mason@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 11, 2026 at 08:02:40PM -0500, Chris Mason wrote:
> On a zoned XFS, a store through a shared mapping can dereference a NULL
> pointer, or corrupt the free block counter, if the realtime flag of the
> file changes during the write fault.
> 
> xfs_write_fault() reserves zoned space only for a zoned inode, and tests
> for that with no lock held. xfs_buffered_write_iomap_begin() tests again
> before it takes the ILOCK. FS_IOC_FSSETXATTR can change the flag of a
> file with no blocks between the two tests, since a fault never takes the
> IOLOCK:
> 
>     write fault                           FS_IOC_FSSETXATTR
>     ===========                           =================
>     xfs_write_fault()
>       sees that the inode is not zoned
>                                           sets the realtime flag
>     xfs_buffered_write_iomap_begin()
>       sees that the inode is zoned
>       /* ac is NULL */
> 
> If the flag is cleared instead, xfs_zoned_buffered_write_iomap_begin()
> can be waiting for the ILOCK at that time. It then reserves blocks the
> zoned way on a regular inode, and the free block counter ends up too
> high.
> 
> The fix used here is to test again under the ILOCK, before blocks are
> reserved or allocated, and to make the fault start over if the flag has
> changed. Any other caller that gets there fails, as a write does.
> 
> Fixes: 058dd70c65ab ("xfs: implement buffered writes to zoned RT devices")
> Signed-off-by: Chris Mason <mason@kernel.org>
> ---
> 
> Notes:
>     v7->v8:
>     - Only a page fault gets -EAGAIN. Any other caller that gets to one of
>       the tests fails with -EINVAL, as a write and an fallocate do. pNFS can
>       get there: xfs_fs_map_blocks() tests the flag before it takes its
>       locks (Christoph Hellwig).
>     - The warning now says "during block mapping".
>     - The helper reads the inode number with I_INO(), and its comment no
>       longer says that the flag is stable once the inode has blocks.
>     - Was 11/11.
>     
>     v6->v7:
>     - xfs_direct_write_iomap_begin() tests the flag too, as soon as it holds
>       the ILOCK. It could allocate blocks for a COW fork extent before it
>       got to the test in xfs_iomap_write_direct().
>     - The assert on the extent size hint in
>       xfs_zoned_buffered_write_iomap_begin() moved below the test of the
>       flag.
>     - Dropped the Reviewed-by of Christoph Hellwig, since the patch changed.
>     - Was 10/10.
> 
>  fs/xfs/xfs_iomap.c | 42 ++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index c3465204b8d5..d36650450cbb 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -264,6 +264,25 @@ xfs_iomap_eof_align_last_fsb(
>  	return end_fsb;
>  }
>  
> +/*
> + * A write fault picks the zoned or the regular path before it takes a lock, and
> + * it never takes the IOLOCK.  The realtime flag cannot change under the ILOCK,
> + * so look at it again there, before reserving or allocating blocks.  Only a
> + * fault can start over, so refuse any other caller, as the write path does.
> + */
> +static int
> +xfs_iomap_rtflag_changed(
> +	struct xfs_inode	*ip,
> +	unsigned int		flags)
> +{
> +	xfs_warn_ratelimited(ip->i_mount,
> +		"RT flag modifying during block mapping for inode 0x%llx.",
> +		I_INO(ip));
> +	if (flags & IOMAP_FAULT)
> +		return -EAGAIN;
> +	return -EINVAL;
> +}
> +
>  int
>  xfs_iomap_write_direct(
>  	struct xfs_inode	*ip,
> @@ -334,6 +353,11 @@ xfs_iomap_write_direct(
>  	if (error)
>  		return error;
>  
> +	if (xfs_is_zoned_inode(ip)) {
> +		error = xfs_iomap_rtflag_changed(ip, flags);
> +		goto out_trans_cancel;
> +	}
> +
>  	error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK, nr_exts);
>  	if (error)
>  		goto out_trans_cancel;
> @@ -919,6 +943,11 @@ xfs_direct_write_iomap_begin(
>  	if (error)
>  		return error;
>  
> +	if (xfs_is_zoned_inode(ip)) {
> +		error = xfs_iomap_rtflag_changed(ip, flags);
> +		goto out_unlock;
> +	}
> +
>  	/*
>  	 * The reflink iflag could have changed since the earlier unlocked
>  	 * check, check if it again and relock if needed.
> @@ -1666,9 +1695,7 @@ xfs_zoned_buffered_write_iomap_begin(
>  	struct xfs_iext_cursor	icur;
>  	int			error = 0;
>  
> -	ASSERT(!xfs_get_extsz_hint(ip));
>  	ASSERT(!(flags & IOMAP_UNSHARE));
> -	ASSERT(ac);
>  
>  	if (xfs_is_shutdown(mp))
>  		return -EIO;
> @@ -1682,6 +1709,12 @@ xfs_zoned_buffered_write_iomap_begin(
>  	if (error)
>  		return error;
>  
> +	if (!xfs_is_zoned_inode(ip) || !ac) {
> +		error = xfs_iomap_rtflag_changed(ip, flags);
> +		goto out_unlock;
> +	}

For actual writes this can't happens as we're under the IOLOCK (i_rwsem)
taken in xfs_file_buffered_write here, and the only way to change
the REALTIME flag is through vfs_fileattr_set which also takes
i_rwsem in exclusive mode.  So this should probably assert that
IOMAP_FAULT is set.

Given that the MMAPLOCK (invalidate_lock) nests inside the IOLOCK,
it might makes sense to also take the MMAPLOCK exclusive in
xfs_fileattr_set and just check for the rtflag check early in
__xfs_write_fault instead of leaking this into iomap for buffered
I/O.  This would also remove the need for the extra ac check.

> @@ -1865,6 +1898,11 @@ xfs_buffered_write_iomap_begin(
>  	if (error)
>  		return error;
>  
> +	if (xfs_is_zoned_inode(ip)) {
> +		error = xfs_iomap_rtflag_changed(ip, flags);
> +		goto out_unlock;
> +	}

Same here.

>  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(&ip->i_df)) ||
>  	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
>  		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
> -- 
> 2.55.0
---end quoted text---
