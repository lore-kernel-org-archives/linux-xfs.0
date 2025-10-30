Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C542DBF49;
	Thu, 30 Oct 2025 15:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761836500; cv=none; b=na5zU7dShM5ByamnBa1xfYe9CIa3AQmmXhOqDwTfKxnwHQVuT9m5Ix5zU1R7JljdgNAy5BnDGHaOw9WNX9OJza1cVJ0TWGLGwo4WsCXJWs5wTOo6vQkVn3ZCz3sfLygs/SCb6/TTfU1ddHfM2sQrJUGed3JnaEN1UkRLFlyJQ2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761836500; c=relaxed/simple;
	bh=Vyj3uKibHH7cLagLYWhHKHCtG+qw5HDYt9fmo79ohf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OJySyvZqoMpqZwP6rDfppc8evhAsGH9IpCDV2CNTa+/U3wZPyNEfIJakYn/9PstteO/JMmk34uZQEVKac3f+UZvihfGrZe1VuVXMY9wre1XlR/Fjkbq5GcSssDehUF9wKbA7UQYbELUFgP53Q62apkyEflJyn+3YAFBGPetwum0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iUbaU+OI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iUbaU+OI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C68C4CEF1;
	Thu, 30 Oct 2025 15:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761836499;
	bh=Vyj3uKibHH7cLagLYWhHKHCtG+qw5HDYt9fmo79ohf8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iUbaU+OINRM/bCtu7MrN34CyW+n2FpqPtL8Bq2obPM3OnroJEocSKrpkENhtNA+kC
	 2NFprsKM98s+mGHsiVKyTM6d4Dc0GhzeiMlCybI4DTl+IRUaBuAfMt96CmI1TpyOnd
	 rsi7dwbJjiMDbOoDcLhZZwHc2ewK+8GEm3oW8RL1eTMXIYEkA+LyIhkQZyqPmbA350
	 xuvbtoRB686uV8F3/BAjKb4xV4vON/yJLECtY46oYmaTCOIxyG0OMyqchLqboqehR5
	 e2Mb9Pmu/KO386nvGBDKbyaqajH9Ochegta6tNfwTuXntuIjig+veoaT37uoL4ss6z
	 bBrcu7s3DOzyw==
Date: Thu, 30 Oct 2025 08:01:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Carlos Maiolino <cem@kernel.org>, Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
	Ritesh Harjani <ritesh.list@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix write failures in software-provided atomic
 writes
Message-ID: <20251030150138.GW4015566@frogsfrogsfrogs>
References: <cover.1758264169.git.ojaswin@linux.ibm.com>
 <c3a040b249485b02b569b9269b649d02d721d995.1758264169.git.ojaswin@linux.ibm.com>
 <20251029181132.GH3356773@frogsfrogsfrogs>
 <02af7e21-1a0f-4035-b2d1-b96c9db2f5c7@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02af7e21-1a0f-4035-b2d1-b96c9db2f5c7@oracle.com>

On Thu, Oct 30, 2025 at 01:52:46PM +0000, John Garry wrote:
> On 29/10/2025 18:11, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > With the 5 Oct 2025 release of fstests, generic/521 fails for me on
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
> > <snip>
> > 
> > with a warning in dmesg from iomap about XFS trying to give it a
> > delalloc mapping for a directio write.  Fix the software atomic write
> > iomap_begin code to convert the reservation into a written mapping.
> > This doesn't fix the data corruption problems reported by generic/760,
> > but it's a start.
> 
> I was seeing the corruption and, as expected, unfortunately this does not
> fix the issue. Indeed, I don't even touch the new codepath when testing (for
> that corruption).

Yeah, I know.  This fix enables me to move on to what I think is the
corruption that you and Ojaswin are seeing.

> As for that corruption, I am seeing the same behaviour as Ojaswin described.
> The failure is in a read operation.
> 
> It seems to be a special combo of atomic write, write, and then read which
> reliably shows the issue. The regular write seems to write to the cow fork,
> so I am guessing that the atomic write does not leave it in proper state.
> 
> I do notice for the atomic write that we are writing (calling
> xfs_atomic_write_cow_iomap_begin() -> xfs_bmapi_write()) for more blocks
> that are required for the atomic write. The regular write overwrites these
> blocks, and the read is corrupted in the blocks just after the atomic write.
> It's as if the blocks just after atomic write are not left in the proper
> state.

That's a good breadcrumb for me to follow; I will turn on the rmap
tracepoints to see if they give me a better idea of what's going on.
I mentioned earlier that I think the problem could be that iomap treats
srcmap::type == IOMAP_HOLE as if the srcmap isn't there, and so it'll
read from the cow fork blocks even though that's not right.

--D

> > 
> > Cc: <stable@vger.kernel.org> # v6.16
> > Fixes: bd1d2c21d5d249 ("xfs: add xfs_atomic_write_cow_iomap_begin()")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
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
