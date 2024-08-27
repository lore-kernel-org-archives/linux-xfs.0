Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78C617C6C
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 03:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724727636; cv=none; b=CRKLA0sttvI4D96TC1+CUHExOhSp0GBQ8QXnunUOIep+Ko0yfbXU5OUX0CDoDc0wPn2VWoh/oHAyHEbKaV1t7RZK4HLkHyrWwEY5aWkv7afuCQY1g6LfY+/JJBdQCE6Xn8jXcjP2XyiZ/S2kfFzt99ztZiRBgjv9CS/YCjmofko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724727636; c=relaxed/simple;
	bh=yBdKW5TmsjmJSLMA7h8ar8lpDLYpeRpBeO/8EDxPIfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hOUS4EUD7N87gJmudWZ+vVSx3NpLfGRoYZf++mMDnCq6hYvRq/J65K8Pr+x1WPZoNjCpxHkNHqlfwhiTREMqLhPXTYiirX200EMJkB4eIuCOA9EVdRZ9Er2uChAEoFUUw+A9YtkQnDli2o3FF2z0I6Ux7ucgYf42F5L+052fNR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ueqYQPNE; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ueqYQPNE"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7143ae1b560so2730476b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 20:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724727634; x=1725332434; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EBmvtuxD9pS8G7rZdR8g+yUBQwrvoZgVeIr4a50INu4=;
        b=ueqYQPNE6MGmZCNXRN2DVZQ8KXmynRbMSEYCU5vWSv/+glZtbqFEbvCzpEkpJFYyjO
         JixwDMhFiHO/6z55gEvvbFu9JO15KhgjRewud7O1klfendk4kK5a7djHdzQs5B0avzEk
         dmk7Dp8Alv7rhHsNy79UA4LkN75arqDbUkLW9yMSKJuVF/fB8dBC5oy/JFENtgLHkx7a
         15keDSvvgq/TUl1v4zgNqqSea16AnOc44qN6miLZwdWM1MvoLHAxTd9J+fy29qaMGIXv
         I9iPz9rriYMTDbfOLev9fpd7aySUfkamso+IRqYtDh2QZ38dhgGmVuK3DXg2bcBaxemu
         dcLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724727634; x=1725332434;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EBmvtuxD9pS8G7rZdR8g+yUBQwrvoZgVeIr4a50INu4=;
        b=iJSGgW9dh9K2oWolZv7RHyt2ktHfmI/GcWEz2/luF2xbVMHEeUXx4ecaoN2U1sW66F
         woT5LAxGD8ONU55UqIdpDNfO4qPgcvnxkXzKnx3d+jTyIXRgPCR5HgN0kM7FRq/imCYq
         rdnvCUTSxo+oDAkXROik6Oz9OFVzYGVfzp0dx8L9N7o+2GQRLQbyqHJ5VH5V1/fNcQJi
         PHBeyLrZMY4IyescWbpdSf50hEwBUopLmQElIohvoA4Xw+HGJ0teh6W9QjVzJ+K/QUzT
         y7JqVHbZ0HBMiQrLDgHIEcoixSTaneMSYXbpqxc6AuchAib7m9QRVs9eIR81UdhVlIRG
         q9Zg==
X-Forwarded-Encrypted: i=1; AJvYcCWDegNF366p3I/5q4hvhyiF97rCdMC8MdAimG6Tp3y6hNEbfgTzZbJRfZRZIg6WowFuRB8ZauW9w/Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YySaGkIWFTiwhsqy9xfnA+3fPIck5RvitE2wwW3QLTAKFoHzD6k
	Wyeck0ZskZ3xQZa+clI7h84hDZQQlNFZ0EsaUWDwL8DdafhrjEPx+37VMltzZJRtMwubQC/MWVB
	v
X-Google-Smtp-Source: AGHT+IHOcCIGEJQBHD0tYf4bd1dAhhq+WnKOaU0Ol89NG/tBwuRVPN45XKxpB2eY7S6umkYBjYwvqg==
X-Received: by 2002:a05:6a20:c91c:b0:1ca:dbf7:f740 with SMTP id adf61e73a8af0-1ccc0865818mr1547765637.3.1724727632456;
        Mon, 26 Aug 2024 20:00:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20385566568sm73899885ad.37.2024.08.26.20.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 20:00:31 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1simRY-00E4pA-1K;
	Tue, 27 Aug 2024 13:00:28 +1000
Date: Tue, 27 Aug 2024 13:00:28 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/24] xfs: create incore realtime group structures
Message-ID: <Zs1BTGCxlQpUSpKZ@dread.disaster.area>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087433.59588.10419191726395528458.stgit@frogsfrogsfrogs>
 <ZsvEmInHRA6GVuz3@dread.disaster.area>
 <20240826191404.GC865349@frogsfrogsfrogs>
 <Zs0kfidzTGC7KACX@dread.disaster.area>
 <20240827015558.GD6082@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827015558.GD6082@frogsfrogsfrogs>

On Mon, Aug 26, 2024 at 06:55:58PM -0700, Darrick J. Wong wrote:
> On Tue, Aug 27, 2024 at 10:57:34AM +1000, Dave Chinner wrote:
> > On Mon, Aug 26, 2024 at 12:14:04PM -0700, Darrick J. Wong wrote:
> > > On Mon, Aug 26, 2024 at 09:56:08AM +1000, Dave Chinner wrote:
> > > > On Thu, Aug 22, 2024 at 05:17:31PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > Create an incore object that will contain information about a realtime
> > > > > allocation group.  This will eventually enable us to shard the realtime
> > > > > section in a similar manner to how we shard the data section, but for
> > > > > now just a single object for the entire RT subvolume is created.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > ---
> > > > >  fs/xfs/Makefile             |    1 
> > > > >  fs/xfs/libxfs/xfs_format.h  |    3 +
> > > > >  fs/xfs/libxfs/xfs_rtgroup.c |  196 ++++++++++++++++++++++++++++++++++++++++
> > > > >  fs/xfs/libxfs/xfs_rtgroup.h |  212 +++++++++++++++++++++++++++++++++++++++++++
> > > > >  fs/xfs/libxfs/xfs_sb.c      |    7 +
> > > > >  fs/xfs/libxfs/xfs_types.h   |    4 +
> > > > >  fs/xfs/xfs_log_recover.c    |   20 ++++
> > > > >  fs/xfs/xfs_mount.c          |   16 +++
> > > > >  fs/xfs/xfs_mount.h          |   14 +++
> > > > >  fs/xfs/xfs_rtalloc.c        |    6 +
> > > > >  fs/xfs/xfs_super.c          |    1 
> > > > >  fs/xfs/xfs_trace.c          |    1 
> > > > >  fs/xfs/xfs_trace.h          |   38 ++++++++
> > > > >  13 files changed, 517 insertions(+), 2 deletions(-)
> > > > >  create mode 100644 fs/xfs/libxfs/xfs_rtgroup.c
> > > > >  create mode 100644 fs/xfs/libxfs/xfs_rtgroup.h
> > > > 
> > > > Ok, how is the global address space for real time extents laid out
> > > > across rt groups? i.e. is it sparse similar to how fsbnos and inode
> > > > numbers are created for the data device like so?
> > > > 
> > > > 	fsbno = (agno << agblklog) | agbno
> > > > 
> > > > Or is it something different? I can't find that defined anywhere in
> > > > this patch, so I can't determine if the unit conversion code and
> > > > validation is correct or not...
> > > 
> > > They're not sparse like fsbnos on the data device, they're laid end to
> > > end.  IOWs, it's a straight linear translation.  If you have an rtgroup
> > > that is 50 blocks long, then rtgroup 1 starts at (50 * blocksize).
> > 
> > Yes, I figured that out later. I think that's less than optimal,
> > because it essentially repeats the problems we have with AGs being
> > fixed size without the potential for fixing it easily. i.e. the
> > global sharded fsbno address space is sparse, so we can actually
> > space out the sparse address regions to allow future flexibility in
> > group size and location work.
> > 
> > By having the rtgroup addressing being purely physical, we're
> > completely stuck with fixed sized rtgroups and there is no way
> > around that. IOWs, the physical address space sharding repeats the
> > existing grow and shrink problems we have with the existing fixed
> > size AGs.
> > 
> > We're discussing how to use the sparse fsbno addressing to allow
> > resizing of AGs, but we will not be able to do that at all with
> > rtgroups as they stand. The limitation is a 64 bit global rt extent
> > address is essential the physical address of the extent in the block
> > device LBA space.
> 
> <nod> I /think/ it's pretty simple to convert the rtgroups rtblock
> numbers to sparse ala xfs_fsblock_t -- all we have to do is make sure
> that mp->m_rgblklog is set to highbit64(rtgroup block count) and then
> delete all the multiply/divide code, just like we do on the data device.
> 
> The thing I *don't* know is how will this affect hch's zoned device
> support -- he's mentioned that rtgroups will eventually have both a size
> and a "capacity" to keep the zones aligned to groups, or groups aligned
> to zones, I don't remember which.  I don't know if segmenting
> br_startblock for rt mappings makes things better or worse for that.

I can't really comment on that because I haven't heard anything
about this requirement. It kinda sounds like sparse addressing just
with different names, but I'm just guessing there. Maybe Christoph
can educate us here...

> > > > This is all duplicates of the xfs_perag code. Can you put together a
> > > > patchset to abstract this into a "xfs_group" and embed them in both
> > > > the perag and and rtgroup structures?
> > > > 
> > > > That way we only need one set of lookup and iterator infrastructure,
> > > > and it will work for both data and rt groups...
> > > 
> > > How will that work with perags still using the radix tree and rtgroups
> > > using the xarray?  Yes, we should move the perags to use the xarray too
> > > (and indeed hch already has a series on list to do that) but here's
> > > really not the time to do that because I don't want to frontload a bunch
> > > more core changes onto this already huge patchset.
> > 
> > Let's first assume they both use xarray (that's just a matter of
> > time, yes?) so it's easier to reason about. Then we have something
> > like this:
> > 
> > /*
> >  * xfs_group - a contiguous 32 bit block address space group
> >  */
> > struct xfs_group {
> > 	struct xarray		xarr;
> > 	u32			num_groups;
> > };
> 
> Ah, that's the group head.  I might call this struct xfs_groups?

Sure.

> 
> So ... would it theoretically make more sense to use an rhashtable here?
> Insofar as the only place that totally falls down is if you want to
> iterate tagged groups; and that's only done for AGs.

The index is contiguous and starts at zero, so it packs extremely
well into an xarray. For small numbers of groups (i.e. the vast
majority of installations) item lookup is essentially O(1) (single
node), and it scales out at O(log N) for large numbers and random
access.  It also has efficient sequential iteration, which is what
we mostly do with groups.

rhashtable has an advantage at scale of being mostly O(1), but it
comes at an increased memory footprint and has terrible for ordered
iteration behaviour even ignoring tags (essentially random memory
access).

> I'm ok with using an xarray here, fwiw.

OK.

> > then we pass the group to each of the "for_each_group..." iterators
> > like so:
> > 
> > 	for_each_group(&mp->m_perags, agno, pag) {
> > 		/* do stuff with pag */
> > 	}
> > 
> > or
> > 	for_each_group(&mp->m_rtgroups, rtgno, rtg) {
> > 		/* do stuff with rtg */
> > 	}
> > 
> > And we use typeof() and container_of() to access the group structure
> > within the pag/rtg. Something like:
> > 
> > #define to_grpi(grpi, gi)	container_of((gi), typeof(grpi), g)
> > #define to_gi(grpi)		(&(grpi)->g)
> > 
> > #define for_each_group(grp, gno, grpi)					\
> > 	(gno) = 0;							\
> > 	for ((grpi) = to_grpi((grpi), xfs_group_grab((grp), (gno)));	\
> > 	     (grpi) != NULL;						\
> > 	     (grpi) = to_grpi(grpi, xfs_group_next((grp), to_gi(grpi),	\
> > 					&(gno), (grp)->num_groups))
> > 
> > And now we essentially have common group infrstructure for
> > access, iteration, geometry and address verification purposes...
> 
> <nod> That's pretty much what I had drafted, albeit with different
> helper macros since I kept the for_each_{perag,rtgroup} things around
> for type safety.  Though I think for_each_perag just becomes:
> 
> #define for_each_perag(mp, agno, pag) \
> 	for_each_group((mp)->m_perags, (agno), (pag))
> 
> Right?

Yeah, that's what I though of doing first, but then figured a little
bit of compiler magic gets rid of the need for the type specific
iterator wrappers altogether...

> > > > > diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> > > > > index a8cd44d03ef64..1ce4b9eb16f47 100644
> > > > > --- a/fs/xfs/libxfs/xfs_types.h
> > > > > +++ b/fs/xfs/libxfs/xfs_types.h
> > > > > @@ -9,10 +9,12 @@
> > > > >  typedef uint32_t	prid_t;		/* project ID */
> > > > >  
> > > > >  typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
> > > > > +typedef uint32_t	xfs_rgblock_t;	/* blockno in realtime group */
> > > > 
> > > > Is that right? The rtg length is 2^32 * rtextsize, and rtextsize can
> > > > be 2^20 bytes:
> > > > 
> > > > #define XFS_MAX_RTEXTSIZE (1024 * 1024 * 1024)
> > > 
> > > No, the maximum rtgroup length is 2^32-1 blocks.
> > 
> > I couldn't tell if the max length was being defined as the maximum
> > number of rt extents that the rtgroup could index, of whether it was
> > the maximum number of filesystem blocks (i.e. data device fsblock
> > size) tha an rtgroup could index...
> 
> The max rtgroup length is defined in blocks; the min is defined in rt
> extents.

I think that's part of the problem - can we define min and max in
the same units? Or have two sets of definitions - one for each unit?

> I might want to bump up the minimum a bit, but I think
> Christoph should weigh in on that first -- I think his zns patchset
> currently assigns one rtgroup to each zone?  Because he was muttering
> about how 130,000x 256MB rtgroups really sucks.

Ah, that might be the capacity vs size thing - to allow rtgroups to
be sized as an integer multiple of the zone capacity and so have an
rtgroup for every N contiguous zones....

> Would it be very messy
> to have a minimum size of (say) 1GB?

I was thinking of larger than that, but the question comes down to
how *small* do we need to support for rtg based rtdevs? I was
thinking that hundreds of GB would be the smallest size device we
might deploy this sort of feature on, in which case somewhere around
50GB would be the typical minimum rtg size...

I'm kind worried that 1GB sizes still allows the crazy growfs small
to huge capacity problems we have with AGs. It's probably a good
place to start, but I think larger would be better...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
