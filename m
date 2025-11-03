Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8CC2AC17;
	Mon,  3 Nov 2025 18:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762192876; cv=none; b=k3krEeUhBeaZbfoqHGmlHhS1d0gOfDRILj/WcnSZSImvPcNd8WSSYPYLqhOR35ySPuutv0s6w5S8UuGusFuWDuAw4jGHmKuZTycFV6KiO8OSVM9qQI7YanTuSiRxUpNSXCs6TkEjPEj0DkXtXpvWuCTEcbNg3naMezNGyWRpugw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762192876; c=relaxed/simple;
	bh=7HTYtUcUDRGSi62eH3549dwdAhLi3dT65De6zVka2CY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M3knMdduo+YjGoou3xUdkKCGEJ22xZrG/DHka2X8470E/y4vyPtnpvbbA2mY6fhdWT0LvJxFHUyD72v2xCff7PUZdtwj75Jt6HNSG2J1jkSSrlDBEfdKn70lQxYRlugx9Iw79JTGKGUdBAu1EfPZEKb5SUdNWwm5sK3+WANrjU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g7jshOdl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g7jshOdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9191EC4CEF8;
	Mon,  3 Nov 2025 18:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762192873;
	bh=7HTYtUcUDRGSi62eH3549dwdAhLi3dT65De6zVka2CY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g7jshOdlYo7hZ1VJ+dLwupR6KJ213QXUme8l1tKvhPfSfk+bl0vnjxlj3Dhe5Dbd0
	 pAAxb3k1VE/dgk/gcv2UPYssvkhexqjwmo8ngovb0yi0vHVag8hv9Zk3vlct4muCy0
	 Hm2m6wHuJCYUcscEtlgpLy/zrCl3wfimlveoGgpZBn2t4opPXVeQd2adrHYk8HYO9j
	 XYBGsVme64RkEEpC5duycddIoFvNXUAjlC3sQnbFYseIGbkocjUc662cmdBB6SKsHg
	 8eIk+LF9wp0KHmkfnR37xFVBvzXPoffR5rFq5MVUdCDkzyxpjw0xkILs1g//JQglM+
	 J6f4jQR3z9ZyA==
Date: Mon, 3 Nov 2025 10:01:12 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Carlos Maiolino <cem@kernel.org>, Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
	Ritesh Harjani <ritesh.list@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix write failures in software-provided atomic
 writes
Message-ID: <20251103180112.GD196370@frogsfrogsfrogs>
References: <c3a040b249485b02b569b9269b649d02d721d995.1758264169.git.ojaswin@linux.ibm.com>
 <20251029181132.GH3356773@frogsfrogsfrogs>
 <02af7e21-1a0f-4035-b2d1-b96c9db2f5c7@oracle.com>
 <20251030150138.GW4015566@frogsfrogsfrogs>
 <c3cdd46f-7169-48c9-ae7a-9c315713e31f@oracle.com>
 <0c25aaf1-e813-475f-ac7e-a05e33af91f1@oracle.com>
 <20251031043024.GP3356773@frogsfrogsfrogs>
 <d787aed1-19ad-4fb9-ba64-33d754d46e5f@oracle.com>
 <20251031171330.GC6178@frogsfrogsfrogs>
 <64128e92-44a7-4830-86e7-2c98383a9f28@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64128e92-44a7-4830-86e7-2c98383a9f28@oracle.com>

On Mon, Nov 03, 2025 at 12:16:14PM +0000, John Garry wrote:
> On 31/10/2025 17:13, Darrick J. Wong wrote:
> > On Fri, Oct 31, 2025 at 10:17:56AM +0000, John Garry wrote:
> > > On 31/10/2025 04:30, Darrick J. Wong wrote:
> > > > > @@ -1215,6 +1216,7 @@ xfs_atomic_write_cow_iomap_begin(
> > > > >    	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
> > > > > 
> > > > > I think that the problem may be that we were converting an inappropriate
> > > > > number of blocks from unwritten to real allocations (but never writing to
> > > > > the excess blocks). Does it look ok?
> > > > That looks like a good correction to me; I'll run that on my test fleet
> > > > overnight and we'll see what happens.  Thanks for putting this together!
> > > 
> > > Cool, but I am not confident that it is a completely correct. Here's the
> > > updated code:
> > > 
> > >   	int			error;
> > >   	u64			seq;
> > > +	xfs_filblks_t		count_fsb_orig = count_fsb;
> > > 
> > >   	ASSERT(flags & IOMAP_WRITE);
> > >   	ASSERT(flags & IOMAP_DIRECT);
> > > @@ -1202,7 +1203,7 @@ xfs_atomic_write_cow_iomap_begin(
> > >   found:
> > >   	if (cmap.br_state != XFS_EXT_NORM) {
> > >   		error = xfs_reflink_convert_cow_locked(ip, offset_fsb,
> > > -				count_fsb);
> > > +				count_fsb_orig);
> > >   		if (error)
> > >   			goto out_unlock;
> > >   		cmap.br_state = XFS_EXT_NORM;
> > 
> > Er... this is exactly the same snippet as yesterday. <confused>
> 
> Yes, I was just showing it for context.
> 
> > 
> > (That snippet seems to have survived overnight fsx)
> > 
> > > cmap may be longer than count_fsb_orig (which was the failing scenario). In
> > > that case, after calling xfs_reflink_convert_cow_locked(), we would have
> > > partially converted cmap, so it is proper to set cmap.br_state =
> > > XFS_EXT_NORM?
> > 
> > Hrm.  Let me walk through this function again.
> > 
> > At the start, {offset,count}_fsb express the offset/length parameters,
> > but in fsblock units and expanded to align with an fsblock.
> 
> I do also note that the usage of xfs_iomap_end_fsb() is a bit dubious, as
> this will truncate the write if it goes over s_maxbytes. However, we never
> want to truncate an atomic write.
> 
> > 
> > If the cow fork has a mapping (cmap) that starts before the offset, we
> > trim the mapping to the desired range and goto found.  cmap cannot end
> > before offset_fsb because that's how xfs_iext_lookup_extent works.
> > 
> > If the cow fork doesn't have a mapping or the one it does have doesn't
> > start until after offset_fsb, then we trim count_fsb so that
> > (offset_fsb, count_fsb) is the range that isn't mapped to space.
> > 
> > Then we cycle the ILOCK to get a transaction and do the lookup again
> > due to "extent layout could have changed since the unlock".  Same rules
> > as the first lookup.  I wonder if that second xfs_trim_extent should be
> > using orig_count_fsb, because at this point it's trimming the cmap to
> > the shorter range.
> 
> Yes, I think so.
> 
> > It's probably not a big deal because iomap will
> > just call ->iomap_begin on the rest of the range, but it's more work.
> > 
> > If the second lookup doesn't produce a mapping, then we call
> > xfs_bmapi_write to fill the hole and drop down to @found.
> > 
> > Now, we're at the found: label, having arrived here in one of three
> > ways:
> > 
> > 1) The first cmap lookup found at least one block that it can use.
> >     (offset_fsb, count_fsb) is the original range that iomap asked for.
> >     This mapping could be written or unwritten, and it's been trimmed
> >     so that it won't extend outside the requested write range.
> > 
> > 2) The second cmap lookup found at least one block that it can use.
> >     (offset_fsb, count_fsb) is a truncated range because the cow fork
> >     has a mapping that starts at (offset_fsb + count_fsb).  This mapping
> >     could also be written or unwritten, and it also has been trimmed so
> >     that it won't extend outside the hole range.
> > 
> >     Why do we trim cmap to the hole range?  The original write range
> >     will suite iomap just fine.
> 
> I think that the xfs_iext_lookup_extent() and xfs_trim_extent() pattern may
> have been just copied without considering this.
> 
> > 
> > 3) We xfs_bmapi_write'd a hole, and now we have an unwritten mapping.
> >     (offset_fsb, count_fsb) is the same truncated range from 2).
> >     cmap is potentially much larger than (offset_fsb, count_fsb).
> > 
> >     Why do we not trim this mapping to the original write range?
> > 
> 
> I don't know, but this is what I was suggesting should happen.
> 
> > If at this point the mapping is unwritten, we convert it to written
> > mapping with xfs_reflink_convert_cow_locked.  offset_fsb retains its
> > original value, but what is count_fsb?  It's either the original value
> > (1) or the smaller one from filling the hole (2) or (3)?  Why don't we
> > pass the cmap startoff/blockcount to this function?
> 
> I think that we should
> 
> > 
> > As an aside: Changing count_fsb makes it harder for me to understand
> > what's going on in this function.
> > 
> > Now, having converted either the range we arrived at via (1-3) (or with
> > your patch, the original range) to written state, we set br_state and
> > pass that back to iomap.  I think in case (3) it's possible that xfs
> > incorrectly reports to iomap an overly large mapping that might not
> > actually reflect the cow fork contents, because we only converted so
> > much of the mapping state.
> > 
> > > We should trim cmap to count_fsb_orig also, right?
> > 
> > iomap doesn't care if the mapping it receives spans more space than just
> > the range it asked for, but XFS shouldn't be exposing mappings that
> > don't reflect the actual state of the cow fork.
> > 
> > I think there are several things wrong with this function:
> > 
> > A) xfs_bmapi_write can return a much larger unwritten mapping than what
> >     the caller asked for.  We convert part of that range to written, but
> >     return the entire written mapping to iomap even though that's
> >     inaccurate.
> > 
> > B) The arguments to xfs_reflink_convert_cow_locked are wrong -- an
> >     unwritten mapping could be *smaller* than the write range (or even
> >     the hole range).  In this case, we convert too much file range to
> >     written state because we then return a smaller mapping to iomap.
> > 
> > C) It doesn't handle delalloc mappings.  This I covered in the patch
> >     that I already sent to the list.
> > 
> > D) Reassigning count_fsb to handle the hole means that if the second
> >     cmap lookup attempt succeeds (due to racing with someone else) we
> >     trim the mapping more than is strictly necessary.  The changing
> >     meaning of count_fsb makes this harder to notice.
> > 
> > E) The tracepoint is kinda wrong because @length is mutated.  That makes
> >     it harder to chase the data flows through this function because you
> >     can't just grep on the pos/bytecount strings.
> 
> Yes, I was noticing this also.
> 
> > 
> > F) We don't actually check that the br_state = XFS_EXT_NORM assignment
> >     is accurate, i.e. that the cow fork contains a written mapping for
> >     the range that we're interested in.
> > 
> > G) Somewhat inadequate documentation of why we need to xfs_trim_extent
> >     so aggressively in this function.
> > 
> > H) Not sure why xfs_iomap_end_fsb is used here, the vfs already clamped
> >     the write range to s_maxbytes.
> 
> Please note that I mentioned about this above.
> 
> > 
> > > I don't think that it makes much of a difference, but it seems the proper
> > > thing to do. Maybe the subsequent traces length values would be inconsistent
> > > with other path to @found label if we don't trim.
> > 
> > With A-H fixed, all the atomic writes issues I was seeing went away.
> > I'll run this through the atomic writes QA tests and send a fix series
> > to the list.
> 
> ok, thanks!

<nod> Fixes have now been sent to the list.

--D
