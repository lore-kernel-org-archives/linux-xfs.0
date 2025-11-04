Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428587083C;
	Tue,  4 Nov 2025 17:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762277094; cv=none; b=NJmFrvtYPxpWfmM1o/wEBTSjSxQtr3maKBVdlCvmgNlHoAge8BTEhoLBN7UWfGn4w891/dJrSfMWYZ96xp1iYC/jNanXeamRkxx2+r38HeNX/d8IPP4UGunlakjPn9Oms1cIXKKGfxYh4Te7+uoNAikH0Za4lZtRa0vo6yJ1LG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762277094; c=relaxed/simple;
	bh=5Iw7O26S9lKlP1jRVcvy+OhqJVgX7BIdjCH6DDmPqVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ci/GAZXXP3G3AftQBpiUm9CUpCUl2inXKKHQ8WeljtzgHH9vNMIF1Y/zv7CXV//a8/zy3Y9st7jmzjO78JFOKNXMzSW/UxRKec4czgjvJjRCrsvHMf7CdRW06LLzNilu3TNCL73jnNRsJBZ/fWnWcNDl8yQhZFGchknqI/1eXrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vHwCsRFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vHwCsRFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8EE6C4CEF7;
	Tue,  4 Nov 2025 17:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762277093;
	bh=5Iw7O26S9lKlP1jRVcvy+OhqJVgX7BIdjCH6DDmPqVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vHwCsRFbRwpTz73SllFx0xVeeVtVtTl0waI1IU6PJ4AgA4RHwjV1W6PPpCotZT85l
	 8XukH8Jk47eGwZufQiJ4FJQBqLvEpT/2I0OMotA0QoTuLDyuL5OKFGGKyAAOjo23xt
	 sq04xu8JEUFJuAJaJErrTvRRjUGnONDamEcxU0igdnQGi+XwNTAU5eUk3JgKX9lIlH
	 XabfO+baxD+rt6hYWXbRZ44SeMnYDR6WhXBSLP7/fyRW2adag9INklmyu0meYFGva6
	 U4/Ke6+OL9zOpqXNjEjRlZlKWlkhzsirG0DMicqo1OYThFhJCrzJRjPnwHNkRenRbd
	 gpwNQVTvXJD8A==
Date: Tue, 4 Nov 2025 09:24:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Carlos Maiolino <cem@kernel.org>, Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
	Ritesh Harjani <ritesh.list@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: fix delalloc write failures in
 software-provided atomic writes
Message-ID: <20251104172453.GM196370@frogsfrogsfrogs>
References: <20251103174024.GB196370@frogsfrogsfrogs>
 <cb1f1963-8ca4-460f-b620-6026a26ce9eb@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb1f1963-8ca4-460f-b620-6026a26ce9eb@oracle.com>

On Tue, Nov 04, 2025 at 10:08:10AM +0000, John Garry wrote:
> On 03/11/2025 17:40, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > With the 20 Oct 2025 release of fstests, generic/521 fails for me on
> > regular (aka non-block-atomic-writes) storage:
> > 
> > QA output created by 521
> > dowrite: write: Input/output error
> > LOG DUMP (8553 total operations):
> > 1(  1 mod 256): SKIPPED (no operation)
> > 2(  2 mod 256): WRITE    0x7e000 thru 0x8dfff	(0x10000 bytes) HOLE
> > 3(  3 mod 256): READ     0x69000 thru 0x79fff	(0x11000 bytes)
> > 4(  4 mod 256): FALLOC   0x53c38 thru 0x5e853	(0xac1b bytes) INTERIOR
> > 5(  5 mod 256): COPY 0x55000 thru 0x59fff	(0x5000 bytes) to 0x25000 thru 0x29fff
> > 6(  6 mod 256): WRITE    0x74000 thru 0x88fff	(0x15000 bytes)
> > 7(  7 mod 256): ZERO     0xedb1 thru 0x11693	(0x28e3 bytes)
> > 
> > with a warning in dmesg from iomap about XFS trying to give it a
> > delalloc mapping for a directio write.  Fix the software atomic write
> > iomap_begin code to convert the reservation into a written mapping.
> > This doesn't fix the data corruption problems reported by generic/760,
> > but it's a start.
> > 
> > Cc: <stable@vger.kernel.org> # v6.16
> > Fixes: bd1d2c21d5d249 ("xfs: add xfs_atomic_write_cow_iomap_begin()")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> FWIW:
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> 
> > ---
> >   fs/xfs/xfs_iomap.c |   21 +++++++++++++++++++--
> >   1 file changed, 19 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index d3f6e3e42a1191..e1da06b157cf94 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -1130,7 +1130,7 @@ xfs_atomic_write_cow_iomap_begin(
> >   		return -EAGAIN;
> >   	trace_xfs_iomap_atomic_write_cow(ip, offset, length);
> > -
> > +retry:
> >   	xfs_ilock(ip, XFS_ILOCK_EXCL);
> >   	if (!ip->i_cowfp) {
> > @@ -1141,6 +1141,8 @@ xfs_atomic_write_cow_iomap_begin(
> >   	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &cmap))
> >   		cmap.br_startoff = end_fsb;
> >   	if (cmap.br_startoff <= offset_fsb) {
> > +		if (isnullstartblock(cmap.br_startblock))
> 
> This following comment is unrelated to this patch and is only relevant to
> pre-existing code:
> 
> isnullstartblock() seems to be a check specific to delayed allocation, so I
> don't why "null" is used in the name, and not "delalloc" or something else
> more specific.
> 
> I guess that there is some history here (behind the naming).

I think the "null" is meant in the sense of "null pointer to storage
device", which is an odd way of saying "file range space reservation" :)

If you use high-level function xfs_bmapi_read(), then it sets
br_startblock to DELAYSTARTBLOCK which is a little more clear.

But here we're doing a direct lookup in the iext tree, so we have to
interpret the raw incore record.  For a delayed allocation of N blocks,
we reserve those N blocks from the free space counter and stuff that in
br_blockcount; and enough space to handle btree expansions in the lower
17 bits of br_startblock.  That's why isnullstartblock does a bunch of
masking magic.

> > +			goto convert;
> >   		xfs_trim_extent(&cmap, offset_fsb, count_fsb);
> >   		goto found;
> >   	}
> > @@ -1169,8 +1171,10 @@ xfs_atomic_write_cow_iomap_begin(
> >   	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &cmap))
> >   		cmap.br_startoff = end_fsb;
> >   	if (cmap.br_startoff <= offset_fsb) {
> > -		xfs_trim_extent(&cmap, offset_fsb, count_fsb);
> >   		xfs_trans_cancel(tp);
> > +		if (isnullstartblock(cmap.br_startblock))
> > +			goto convert;
> > +		xfs_trim_extent(&cmap, offset_fsb, count_fsb);
> >   		goto found;
> >   	}
> > @@ -1210,6 +1214,19 @@ xfs_atomic_write_cow_iomap_begin(
> >   	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >   	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
> > +convert:
> 
> minor comment:
> 
> could convert_delay be a better name, like used in
> xfs_buffered_write_iomap_begin()?

Yeah, that'll be more consistent.  Thanks for reviewing both patches.

--D

> > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > +	error = xfs_bmapi_convert_delalloc(ip, XFS_COW_FORK, offset, iomap,
> > +			NULL);
> > +	if (error)
> > +		return error;
> > +
> > +	/*
> > +	 * Try the lookup again, because the delalloc conversion might have
> > +	 * turned the COW mapping into unwritten, but we need it to be in
> > +	 * written state.
> > +	 */
> > +	goto retry;
> >   out_unlock:
> >   	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >   	return error;
> 
> 
