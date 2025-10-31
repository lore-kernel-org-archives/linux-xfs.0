Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861082F693E;
	Fri, 31 Oct 2025 17:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761930811; cv=none; b=ATryLPZA63lnyQctvjMTQSlkfo77gn7FnKkzWOk+8pf4/pPr1jFkeaaVTVd1UUE1Jy6GfsRRahPqWm58Gent7Wnw3Mu2HROP/IuVqWatwc05gEg/uAa4dZFz9E5SCpfc+eW1RLV38KazgZcLnIoPzEgz0bySOHbipotmPg4CpB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761930811; c=relaxed/simple;
	bh=tAdXN2zbCPP/INxZXjgumnsShszUSv4hGYOUGVFqkuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ikMaZ42HR9GEjt6bt426yoHF6sH9iF1phnOpZ6mWIuAjmlphXaO5KIWf0lJYrPQcEeZHv12PRbLindJvXIUdkpR0ukGv/czl7LPcoDw7uZfx35c7S4rr+vFAQj1Y2MiarG3JztAExPo+0pJbkwOart5aLTs4H6qGOPAGC+GpDqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=emadYfGE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="emadYfGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1C8C4CEE7;
	Fri, 31 Oct 2025 17:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761930811;
	bh=tAdXN2zbCPP/INxZXjgumnsShszUSv4hGYOUGVFqkuE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=emadYfGE9g+5MH91aj/0/WrTGZ7kgBYQ9TqjGVxrhixIpbyXZnOt8wRVPIpaCZ5IX
	 SO2iDljc9AG+i14MblfOlpbWKfWIwBcs54X9yM8ApRDpGWBUmhNqh9oHawUGfjNTXN
	 LD3Z4Y5pob/S9O4vZHkKlo8OibKqs7apwjDuJXbZ10xvWTqid/Q+U8ICcdKm6AAvLN
	 BvhN0F+nsbLb7aBcdvo1HEvqQZCUTDveUbRRLCekfaNLYqCK3oqHJyiVB6Swvn30sK
	 8K9FxDWFkxdIgPS19tRptGQg7ImDqQ3gzZD1WUyCAuFXlpdfIggTZAGRKFRT8VDHgc
	 ueeeXiCMAV4Jg==
Date: Fri, 31 Oct 2025 10:13:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Carlos Maiolino <cem@kernel.org>, Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
	Ritesh Harjani <ritesh.list@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix write failures in software-provided atomic
 writes
Message-ID: <20251031171330.GC6178@frogsfrogsfrogs>
References: <cover.1758264169.git.ojaswin@linux.ibm.com>
 <c3a040b249485b02b569b9269b649d02d721d995.1758264169.git.ojaswin@linux.ibm.com>
 <20251029181132.GH3356773@frogsfrogsfrogs>
 <02af7e21-1a0f-4035-b2d1-b96c9db2f5c7@oracle.com>
 <20251030150138.GW4015566@frogsfrogsfrogs>
 <c3cdd46f-7169-48c9-ae7a-9c315713e31f@oracle.com>
 <0c25aaf1-e813-475f-ac7e-a05e33af91f1@oracle.com>
 <20251031043024.GP3356773@frogsfrogsfrogs>
 <d787aed1-19ad-4fb9-ba64-33d754d46e5f@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d787aed1-19ad-4fb9-ba64-33d754d46e5f@oracle.com>

On Fri, Oct 31, 2025 at 10:17:56AM +0000, John Garry wrote:
> On 31/10/2025 04:30, Darrick J. Wong wrote:
> > > @@ -1215,6 +1216,7 @@ xfs_atomic_write_cow_iomap_begin(
> > >   	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
> > > 
> > > I think that the problem may be that we were converting an inappropriate
> > > number of blocks from unwritten to real allocations (but never writing to
> > > the excess blocks). Does it look ok?
> > That looks like a good correction to me; I'll run that on my test fleet
> > overnight and we'll see what happens.  Thanks for putting this together!
> 
> Cool, but I am not confident that it is a completely correct. Here's the
> updated code:
> 
>  	int			error;
>  	u64			seq;
> +	xfs_filblks_t		count_fsb_orig = count_fsb;
> 
>  	ASSERT(flags & IOMAP_WRITE);
>  	ASSERT(flags & IOMAP_DIRECT);
> @@ -1202,7 +1203,7 @@ xfs_atomic_write_cow_iomap_begin(
>  found:
>  	if (cmap.br_state != XFS_EXT_NORM) {
>  		error = xfs_reflink_convert_cow_locked(ip, offset_fsb,
> -				count_fsb);
> +				count_fsb_orig);
>  		if (error)
>  			goto out_unlock;
>  		cmap.br_state = XFS_EXT_NORM;

Er... this is exactly the same snippet as yesterday. <confused>

(That snippet seems to have survived overnight fsx)

> cmap may be longer than count_fsb_orig (which was the failing scenario). In
> that case, after calling xfs_reflink_convert_cow_locked(), we would have
> partially converted cmap, so it is proper to set cmap.br_state =
> XFS_EXT_NORM?

Hrm.  Let me walk through this function again.

At the start, {offset,count}_fsb express the offset/length parameters,
but in fsblock units and expanded to align with an fsblock.

If the cow fork has a mapping (cmap) that starts before the offset, we
trim the mapping to the desired range and goto found.  cmap cannot end
before offset_fsb because that's how xfs_iext_lookup_extent works.

If the cow fork doesn't have a mapping or the one it does have doesn't
start until after offset_fsb, then we trim count_fsb so that
(offset_fsb, count_fsb) is the range that isn't mapped to space.

Then we cycle the ILOCK to get a transaction and do the lookup again
due to "extent layout could have changed since the unlock".  Same rules
as the first lookup.  I wonder if that second xfs_trim_extent should be
using orig_count_fsb, because at this point it's trimming the cmap to
the shorter range.  It's probably not a big deal because iomap will
just call ->iomap_begin on the rest of the range, but it's more work.

If the second lookup doesn't produce a mapping, then we call
xfs_bmapi_write to fill the hole and drop down to @found.

Now, we're at the found: label, having arrived here in one of three
ways:

1) The first cmap lookup found at least one block that it can use.
   (offset_fsb, count_fsb) is the original range that iomap asked for.
   This mapping could be written or unwritten, and it's been trimmed
   so that it won't extend outside the requested write range.

2) The second cmap lookup found at least one block that it can use.
   (offset_fsb, count_fsb) is a truncated range because the cow fork
   has a mapping that starts at (offset_fsb + count_fsb).  This mapping
   could also be written or unwritten, and it also has been trimmed so
   that it won't extend outside the hole range.

   Why do we trim cmap to the hole range?  The original write range
   will suite iomap just fine.

3) We xfs_bmapi_write'd a hole, and now we have an unwritten mapping.
   (offset_fsb, count_fsb) is the same truncated range from 2).
   cmap is potentially much larger than (offset_fsb, count_fsb).

   Why do we not trim this mapping to the original write range?

If at this point the mapping is unwritten, we convert it to written
mapping with xfs_reflink_convert_cow_locked.  offset_fsb retains its
original value, but what is count_fsb?  It's either the original value
(1) or the smaller one from filling the hole (2) or (3)?  Why don't we
pass the cmap startoff/blockcount to this function?

As an aside: Changing count_fsb makes it harder for me to understand
what's going on in this function.

Now, having converted either the range we arrived at via (1-3) (or with
your patch, the original range) to written state, we set br_state and
pass that back to iomap.  I think in case (3) it's possible that xfs
incorrectly reports to iomap an overly large mapping that might not
actually reflect the cow fork contents, because we only converted so
much of the mapping state.

> We should trim cmap to count_fsb_orig also, right?

iomap doesn't care if the mapping it receives spans more space than just
the range it asked for, but XFS shouldn't be exposing mappings that
don't reflect the actual state of the cow fork.

I think there are several things wrong with this function:

A) xfs_bmapi_write can return a much larger unwritten mapping than what
   the caller asked for.  We convert part of that range to written, but
   return the entire written mapping to iomap even though that's
   inaccurate.

B) The arguments to xfs_reflink_convert_cow_locked are wrong -- an
   unwritten mapping could be *smaller* than the write range (or even
   the hole range).  In this case, we convert too much file range to
   written state because we then return a smaller mapping to iomap.

C) It doesn't handle delalloc mappings.  This I covered in the patch
   that I already sent to the list.

D) Reassigning count_fsb to handle the hole means that if the second
   cmap lookup attempt succeeds (due to racing with someone else) we
   trim the mapping more than is strictly necessary.  The changing
   meaning of count_fsb makes this harder to notice.

E) The tracepoint is kinda wrong because @length is mutated.  That makes
   it harder to chase the data flows through this function because you
   can't just grep on the pos/bytecount strings.

F) We don't actually check that the br_state = XFS_EXT_NORM assignment
   is accurate, i.e. that the cow fork contains a written mapping for
   the range that we're interested in.

G) Somewhat inadequate documentation of why we need to xfs_trim_extent
   so aggressively in this function.

H) Not sure why xfs_iomap_end_fsb is used here, the vfs already clamped
   the write range to s_maxbytes.

> I don't think that it makes much of a difference, but it seems the proper
> thing to do. Maybe the subsequent traces length values would be inconsistent
> with other path to @found label if we don't trim.

With A-H fixed, all the atomic writes issues I was seeing went away.
I'll run this through the atomic writes QA tests and send a fix series
to the list.

--D

> Thank,
> John
> 
> 
> 
