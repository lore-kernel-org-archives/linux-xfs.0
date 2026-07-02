Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5777C2D7814
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 16:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008217; cv=none; b=TQy+KvRwzf4cGqzeKlbtyWmSAFVL0Dcwo7go41Fo7o42EnQSeFanWKCESHm62dkDGZZcNGFCzCtk7vZFU300bvyTLeZ27inA7A6RRed29o7prxFL/oclD6SkkqoxhSRBE08riIfcSjsdwO/wxkN72ITnVDbcF6yHE1wpamBm/Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008217; c=relaxed/simple;
	bh=6Q/cyBctqm036UDchof43gnlAagqHTZHC9sHOAFoHeU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HZdJuCUMUqmckOaKbkL/lK0rwjfeHdHrhQM2NHI3t5k4f8hY14N1kyoF4CpfXeKdPF0yZxxM72PfWysFBSxkcl4bWvWKMYSWSeP3Brp2qaqQbb2V+sZ/OinZrKnNb/2rRQrsd9aThetRLIju59i+NHn89C3JetxslC0++/QTB+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oOEe2PLs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oOEe2PLs"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3082C1F000E9;
	Thu,  2 Jul 2026 16:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008216;
	bh=m4u6X6eORBjv3Tn0qq1O7Q1th7eBjJFfeEzDieX32uo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oOEe2PLsLpNFkjCG6oLrsudyFeD6PrkGan2rOkKtr6PcT4kDJrYkEPFzyWp8zYKhM
	 E+LMisYKYMaNoZxtQIpQ0pwaubv89SJj2/NJ+IzhNSPLMHmhl+Polp8vcy6NaQnc2X
	 mR7tkYUKBqdeGUwnYHZhNyUGm4Rp9XX0CHWNrz/o0bg91Mp3tDV7OETZ4ZdstUrj8E
	 O/0gLJjBEqTNPPYYtaEh3bqtvZH3F9ZIJESXr2mjbgINRk6scbgZC/JK2PMpOQlqG5
	 l2cFJKPHwrI64Zlyk+fYeuhESPSdMpXVujpZ1+7OX3izhO5xUQk5m8s2PER7n8xXUl
	 6z8hKqSCQPiwg==
Date: Thu, 2 Jul 2026 09:03:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pankaj Raghav <pankaj.raghav@linux.dev>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, lukas@herbolt.com,
	dgc@kernel.org, gost.dev@samsung.com,
	Zhang Yi <yi.zhang@huaweicloud.com>, andres@anarazel.de,
	kundan.kumar@samsung.com, hch@lst.de, cem@kernel.org,
	hch@infradead.org, Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v8 2/2] xfs: add support for FALLOC_FL_WRITE_ZEROES
Message-ID: <20260702160335.GG9392@frogsfrogsfrogs>
References: <20260625114550.4109104-1-p.raghav@samsung.com>
 <20260625114550.4109104-3-p.raghav@samsung.com>
 <20260625172006.GC6078@frogsfrogsfrogs>
 <75dd0085-e847-47de-aa67-a4f714d3d417@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <75dd0085-e847-47de-aa67-a4f714d3d417@linux.dev>

On Thu, Jul 02, 2026 at 12:37:31PM +0200, Pankaj Raghav wrote:
> 
> >> +	/*
> >> +	 * Allocate written, zeroed extents across the range.  xfs_alloc_file_space()
> >> +	 * rounds outward to block granularity:
> >> +	 *  - holes (the punched interior and any unallocated edge block) are
> >> +	 *    allocated and zeroed;
> >> +	 *  - unwritten extents (including unwritten edge blocks) are converted to
> >> +	 *    written and zeroed;
> >> +	 *  - Already written edge blocks are skipped. The out-of-range bytes of
> >> +	 *    a written edge block keep their data (offset_rd -> offset and
> >> +	 *    end -> end_rd); their in-range bytes (offset -> offset_ru and
> >> +	 *    end_ru -> end were already zeroed by xfs_free_file_space().
> >> +	 */
> >> +	return xfs_alloc_file_space(ip, offset, len,
> >> +			XFS_ALLOC_FILE_SPACE_WRITE_ZEROES);
> > 
> > ...and now we can just do an accelerated "write zeroes to disk" which is
> > conveniently always within EOF now.  I /think/ this looks ok to me now,
> > though I'm curious how extensively the new fallocate mode has been
> > tested with fsx and unaligned file ranges?  And rt volumes with rt
> > extent size > 1 fsblock.
> > 
> 
> I am running into an issue with rtvol.
> 
> Ran generic/363 (fsx) on rt, rextsize=2 (4k block / 8k rt extent). First I ran into this:
> 
> xfs_bmap_rtalloc: ASSERT(xfs_extlen_to_rtxmod == 0). WRITE_ZEROES uses
> XFS_BMAPI_CONVERT, and xfs_bmap_extsize_align() bails early on convert, so the
> rt-unaligned range becomes a sub-rt-extent allocation. I fixed it by rounding the alloc range
> out to whole rt extents, like xfs_free_file_space() does for rt extents.
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 855602cb35e8..e52ad4c25b66 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -710,6 +710,13 @@ xfs_alloc_file_space(
>         imapp = &imaps[0];
>         startoffset_fsb = XFS_B_TO_FSBT(mp, offset);
>         endoffset_fsb = XFS_B_TO_FSB(mp, offset + count);
> +
> +       if (mode == XFS_ALLOC_FILE_SPACE_WRITE_ZEROES &&
> +           xfs_inode_has_bigrtalloc(ip)) {
> +               startoffset_fsb = xfs_fileoff_rounddown_rtx(mp, startoffset_fsb);
> +               endoffset_fsb = xfs_fileoff_roundup_rtx(mp, endoffset_fsb);
> +       }
> +
>         allocatesize_fsb = endoffset_fsb - startoffset_fsb;
> 
>         /*
> 
> With that "fixed", I ran into WARN_ON_ONCE(folio_pos > i_size) in iomap_zero_iter,
> via xfs_falloc_setsize -> xfs_setattr_size -> xfs_zero_range. The
> rt-aligned alloc now leaves written zeroed blocks past a non-rt-aligned
> EOF. So WRITE_ZEROES on rtvol breaks "no written blocks past EOF".

Ah, right, because you can't have a dirty folio totally beyond EOF.
I think you have to leave the blocks beyond EOF unwritten, then.

> I am not sure what would be the most clean way of solving this issue for rtvol.

Or I guess you could EOPNOTSUPP :P

--D

> Let me know your thoughts!
> 
> @Zhang yi: did you test this on bigalloc configurations? Maybe you run into a similar problem
> when cluster size (extsize for XFS) > block size?
> 
> --
> Pankaj
> 
