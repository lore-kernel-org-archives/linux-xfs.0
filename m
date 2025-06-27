Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178C82EBDC4
	for <linux-xfs@vger.kernel.org>; Fri, 27 Jun 2025 19:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751052275; cv=none; b=Zv+BFokjaOt/arJ7scaB71ku/noc6lF/0qcoEnoAyIX/Kz+5V0zwFe78V/0GA3VdPixzgl1OdZh0Z73mjyw3sYvUIm+eWq3w76GEUv9+rDF6ZKsBIOzavs8spV8ftO5fZjbeIswcpdy1W+CYRzcey04icXWQPRYWd64sJE3FWus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751052275; c=relaxed/simple;
	bh=ysxkERBY/Izo2swdGLkOr0uxnGwGMUx3tZKiW8dkUYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tP+CGWmmKSSnVPzMPdf/lrYVm42lISF8aCgDvxIgZLqRaDl4KY/98DSG3PCKvDxPpgqRGTZgSlfpxRlBTWHrIrPnEql8w9PkzUzhZ/5eXLC/kcWgLmEhprJDlFvjV0Pv2VtSy5R2GX55+KWmW/cI9TP1/UwUg9Lcqp2uEvlM/0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OCu3fUMx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OCu3fUMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA05C4CEF7;
	Fri, 27 Jun 2025 19:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751052273;
	bh=ysxkERBY/Izo2swdGLkOr0uxnGwGMUx3tZKiW8dkUYU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OCu3fUMxgHiRLWFMKEKgey6IPl87AEYluB9XoeGgw9TEj7wZJWcRKJoK7jN+uLhF1
	 mCn9diIvzOLY+aqtqj+Do5kWqxvsPXrirP/W5gKnbwzqxkyhsZ95M1riP4SaabsX54
	 jc0ZRvUQ69gWhTZtwI5zoBtr/b4Ilm3Cif/XrpKMq2vwG9PPLDELlzoOjH1RyxUuhv
	 oRju0QUkS/z3DXpyx/4V1iGKedVZkYXmEBmOVJc7CB0HI52V+uj0xx7jmdkScMDWom
	 LledmWaWs5MHGl8yqAxa7HnGaEAfAh8VcyUQ5/eFFhzJRGpquoSaQ0anOPilk7wpaF
	 5OKKhZyIN5qfw==
Date: Fri, 27 Jun 2025 21:24:29 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: IO error handling in xfs_repair
Message-ID: <77tpktkf5crzil62efoq5rxrzsi2rdz6axatvugj2zfv7qecar@e6c57jiebhmi>
References: <RqbhOWAnTss1XJ3HuLRM056kHzvQab82moL4vq9btD1T0gH6JOPtM2N97utM_IQ1fwl65CM4Qoo90BmpcE7mJg==@protonmail.internalid>
 <aF5ArCN0M9940yK7@firstfloor.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aF5ArCN0M9940yK7@firstfloor.org>

On Thu, Jun 26, 2025 at 11:56:44PM -0700, Andi Kleen wrote:
> Hi,
> 
> I have a spinning disk with XFS that corrupted a sector containing some inodes.
> Reading it always gave a IO error (ENODATA).
> 
> xfs_repair unfortunately couldn't handle this at all, running into this
> gem:
> 
>          if (process_inode_chunk(mp, agno, num_inos, first_ino_rec,
>                                 ino_discovery, check_dups, extra_attr_check,
>                                 &bogus))  {
>                         /* XXX - i/o error, we've got a problem */
>                         abort();
>          }
> 
> TBH I was a bit shocked that XFS repair doesn't handle IO errors.
> Surely that's a common occurrence?

Hi Andi.

This behavior is well documented on xfs_repair man page:

"
Disk Errors
	xfs_repair  aborts on most disk I/O errors. Therefore, if you are
	trying to repair a filesystem that was damaged due to a disk drive
	failure, steps should be taken to ensure that all blocks in the
	filesystem are readable and writable before attempting to use
	xfs_repair to repair the filesystem.
	A  possible  method  is  using dd(8) to copy the data onto a good disk.
"
I don't think IO errors could be classified as a common occurrence.

> 
> Anyways, what I ended up doing was to use strace to get the seek offset
> of the bad sector and then write a little python program to clear the block
> (which then likely got remapped, or simply rewritten on the medium),
> and apart from a few lost inodes everything was fine.
> 
> It seems that xfs_repair should have an option to clear erroring blocks that
> it encounters? I realize that this option could be dangerous, but in many cases
> it would seem like the only way to recover.

I believe one of the problems is xfsprogs can't really pinpoint what
happened. Could be a transient failure due a link problem or a bad
block on disk, or whatever else. So it has been designed to bail out and
let the admin handle it.

IMO Adding an option to force to 'clear errored blocks', which basically
means forcing a write() on the block so that it could possibly be
relocated by the disk's firmware is not a good strategy.
Depending how many bad sectors are in the disk, or the nature of the IO
error, this would might end up damaging the filesystem beyond recovery,
as you mentioned yourself.
So, in some cases, you either gotta try to force the disk to relocate
the block manually or copy the still not bad data somewhere else, both
achievable with `dd` for example.

> 
> Or at a minimum print the seek offset on an error so that it can be cleared manually.
> 

This seems weird. If xfs bailed where you pointed, calling
process_inode_chunk(), this likely bailed from here:


if (error) {
	do_warn(_("cannot read inode %" PRIu64 ", disk block %" PRId64 ", cnt %d\n"),
		XFS_AGINO_TO_INO(mp, agno, first_irec->ino_startnum),
		XFS_AGB_TO_DADDR(mp, agno, agbno),
		XFS_FSB_TO_BB(mp,
			M_IGEO(mp)->blocks_per_cluster));
	while (bp_index > 0) {
		bp_index--;
		libxfs_buf_relse(bplist[bp_index]);
	}
	free(bplist);
	return(1);
}

process_inode_chunk() was supposed to log the inode and disk block,
perhaps the abort() prevented the stderr buffer to be flushed, do you
still have the whole xfs_repair output to the point where it failed?

