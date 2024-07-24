Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070D213AD1C
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 21:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721855315; cv=none; b=Z8gs3snCQnmxA0vv1U2txjACQiUUvK5breLr7mA+GkZguW2O4UqUkdCcsUX6LqVFJ8DwZqk4nN0Yq2qwVZXPi4zr0VQnLo17qyWks/mVQRy8ectIvhY+4101e4K92As8u7iQa7q2ksqRj/4BqjbP3zfB9X+pzyIO4ciIelGh060=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721855315; c=relaxed/simple;
	bh=esVTDge0e15j98v/4HBX6Tln4d4WZwl8tR8HVx3GDQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KR1/6LpIQsRZFi6Q89Z082MheSfsaWL6WZfa78j9P/wlKrAtIvkDoAhXtboQYdEwja+A4KUAST5UY7YSjGd+6ShJ/0F6+GvzfybrUQKmtU4pFVRn1iD3KdZJFDGFCo8H+mpRINmWJmJqx8WSw94VxhXi3O+16Xrn/ajEZ+zpTwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hNpPtFiD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hNpPtFiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804C2C32781;
	Wed, 24 Jul 2024 21:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721855314;
	bh=esVTDge0e15j98v/4HBX6Tln4d4WZwl8tR8HVx3GDQE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hNpPtFiDESk/HSZJvD4iv4kmqNMiIEYE9jfTN3IhSqiHXzMN5Lim/GZM6gsTaPrxM
	 w5Of/45L91Q1d8l8cZwP365ojcDb4m6r1noedCfExSeVcRrQ0ug6TMYBil21UNmVyk
	 +uPEp63og/+lNo5MDaANR1VZNPZ0TKBZ1mmu3/xefRbAGIcoaddnc81kv5BqWEysRH
	 nWplrTN5HpE744vMsbZ2s5kE7dUCsWFMQGG7TSPkngP5htaUBXUq3ogZdbT8/rZjAL
	 k9gLfkw6AsJfl5on/S6Y+2h3Px4L2cFoL7//02dTDCoWutfW7x0Lv+P+z9/CbyKnTV
	 15Vd/M1GcDgSw==
Date: Wed, 24 Jul 2024 14:08:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: filesystem expansion design documentation
Message-ID: <20240724210833.GZ612460@frogsfrogsfrogs>
References: <20240721230100.4159699-1-david@fromorbit.com>
 <20240723235801.GU612460@frogsfrogsfrogs>
 <ZqBO177pPLbovguo@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqBO177pPLbovguo@dread.disaster.area>

On Wed, Jul 24, 2024 at 10:46:15AM +1000, Dave Chinner wrote:
> On Tue, Jul 23, 2024 at 04:58:01PM -0700, Darrick J. Wong wrote:
> > On Mon, Jul 22, 2024 at 09:01:00AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > xfs-expand is an attempt to address the container/vm orchestration
> > > image issue where really small XFS filesystems are grown to massive
> > > sizes via xfs_growfs and end up with really insane, suboptimal
> > > geometries.
> > > 
> > > Rather that grow a filesystem by appending AGs, expanding a
> > > filesystem is based on allowing existing AGs to be expanded to
> > > maximum sizes first. If further growth is needed, then the
> > > traditional "append more AGs" growfs mechanism is triggered.
> > > 
> > > This document describes the structure of an XFS filesystem needed to
> > > achieve this expansion, as well as the design of userspace tools
> > > needed to make the mechanism work.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  Documentation/filesystems/xfs/index.rst       |   1 +
> > >  .../filesystems/xfs/xfs-expand-design.rst     | 312 ++++++++++++++++++
> > >  2 files changed, 313 insertions(+)
> > >  create mode 100644 Documentation/filesystems/xfs/xfs-expand-design.rst
> > > 
> > > diff --git a/Documentation/filesystems/xfs/index.rst b/Documentation/filesystems/xfs/index.rst
> > > index ab66c57a5d18..cb570fc886b2 100644
> > > --- a/Documentation/filesystems/xfs/index.rst
> > > +++ b/Documentation/filesystems/xfs/index.rst
> > > @@ -12,3 +12,4 @@ XFS Filesystem Documentation
> > >     xfs-maintainer-entry-profile
> > >     xfs-self-describing-metadata
> > >     xfs-online-fsck-design
> > > +   xfs-expand-design
> > > diff --git a/Documentation/filesystems/xfs/xfs-expand-design.rst b/Documentation/filesystems/xfs/xfs-expand-design.rst
> > > new file mode 100644
> > > index 000000000000..fffc0b44518d
> > > --- /dev/null
> > > +++ b/Documentation/filesystems/xfs/xfs-expand-design.rst
> > > @@ -0,0 +1,312 @@
> > > +.. SPDX-License-Identifier: GPL-2.0
> > > +
> > > +===============================
> > > +XFS Filesystem Expansion Design
> > > +===============================
> > > +
> > > +Background
> > > +==========
> > > +
> > > +XFS has long been able to grow the size of the filesystem dynamically whilst
> > > +mounted. The functionality has been used extensively over the past 3 decades
> > > +for managing filesystems on expandable storage arrays, but over the past decade
> > > +there has been significant growth in filesystem image based orchestration
> > > +frameworks that require expansion of the filesystem image during deployment.
> > > +
> > > +These frameworks want the initial image to be as small as possible to minimise
> > > +the cost of deployment, but then want that image to scale to whatever size the
> > > +deployment requires. This means that the base image can be as small as a few
> > > +hundred megabytes and be expanded on deployment to tens of terabytes.
> > > +
> > > +Growing a filesystem by 4-5 orders of magnitude is a long way outside the scope
> > > +of the original xfs_growfs design requirements. It was designed for users who
> > > +were adding physical storage to already large storage arrays; a single order of
> > > +magnitude in growth was considered a very large expansion.
> > > +
> > > +As a result, we have a situation where growing a filesystem works well up to a
> > > +certain point, yet we have orchestration frameworks that allows users to expand
> > > +filesystems a long way past this point without them being aware of the issues
> > > +it will cause them further down the track.
> > 
> > Ok, same growfs-on-deploy problem that we have.  Though, the minimum OCI
> > boot volume size is ~47GB so at least we're not going from 2G -> 200G.
> > Usually.
> > 
> > > +Scope
> > > +=====
> > > +
> > > +The need to expand filesystems with a geometry optimised for small storage
> > > +volumes onto much larger storage volumes results in a large filesystem with
> > > +poorly optimised geometry. Growing a small XFS filesystem by several orders of
> > > +magnitude results in filesystem with many small allocation groups (AGs). This is
> > > +bad for allocation effciency, contiguous free space management, allocation
> > > +performance as the filesystem fills, and so on. The filesystem will also end up
> > > +with a very small journal for the size of the filesystem which can limit the
> > > +metadata performance and concurrency in the filesystem drastically.
> > > +
> > > +These issues are a result of the filesystem growing algorithm. It is an
> > > +append-only mechanism which takes advantage of the fact we can safely initialise
> > > +the metadata for new AGs beyond the end of the existing filesystem without
> > > +impacting runtime behaviour. Those newly initialised AGs can then be enabled
> > > +atomically by running a single transaction to expose that newly initialised
> > > +space to the running filesystem.
> > > +
> > > +As a result, the growing algorithm is a fast, transparent, simple and crash-safe
> > > +algorithm that can be run while the filesystem is mounted. It's a very good
> > > +algorithm for growing a filesystem on a block device that has has new physical
> > > +storage appended to it's LBA space.
> > > +
> > > +However, this algorithm shows it's limitations when we move to system deployment
> > > +via filesystem image distribution. These deployments optimise the base
> > > +filesystem image for minimal size to minimise the time and cost of deploying
> > > +them to the newly provisioned system (be it VM or container). They rely on the
> > > +filesystem's ability to grow the filesystem to the size of the destination
> > > +storage during the first system bringup when they tailor the deployed filesystem
> > > +image for it's intented purpose and identity.
> > > +
> > > +If the deployed system has substantial storage provisioned, this means the
> > > +filesystem image will be expanded by multiple orders of magnitude during the
> > > +system initialisation phase, and this is where the existing append-based growing
> > > +algorithm falls apart. This is the issue that this design seeks to resolve.
> > 
> > I very much appreciate the scope definition here.  I also very much
> > appreciate starting off with a design document!  Thank you.
> > 
> > <snip out parts I'm already familiar with>
> > 
> > > +Optimising Physical AG Realignment
> > > +==================================
> > > +
> > > +The elephant in the room at this point in time is the fact that we have to
> > > +physically move data around to expand AGs. While this makes AG size expansion
> > > +prohibitive for large filesystems, they should already have large AGs and so
> > > +using the existing grow mechanism will continue to be the right tool to use for
> > > +expanding them.
> > > +
> > > +However, for small filesystems and filesystem images in the order of hundreds of
> > > +MB to a few GB in size, the cost of moving data around is much more tolerable.
> > > +If we can optimise the IO patterns to be purely sequential, offload the movement
> > > +to the hardware, or even use address space manipulation APIs to minimise the
> > > +cost of this movement, then resizing AGs via realignment becomes even more
> > > +appealing.
> > > +
> > > +Realigning AGs must avoid overwriting parts of AGs that have not yet been
> > > +realigned. That means we can't realign the AGs from AG 1 upwards - doing so will
> > > +overwrite parts of AG2 before we've realigned that data. Hence realignment must
> > > +be done from the highest AG first, and work downwards.
> > > +
> > > +Moving the data within an AG could be optimised to be space usage aware, similar
> > > +to what xfs_copy does to build sparse filesystem images. However, the space
> > > +optimised filesystem images aren't going to have a lot of free space in them,
> > > +and what there is may be quite fragmented. Hence doing free space aware copying
> > > +of relatively full small AGs may be IOPS intensive. Given we are talking about
> > > +AGs in the typical size range from 64-512MB, doing a sequential copy of the
> > > +entire AG isn't going to take very long on any storage. If we have to do several
> > > +hundred seeks in that range to skip free space, then copying the free space will
> > > +cost less than the seeks and the partial RAID stripe writes that small IOs will
> > > +cause.
> > > +
> > > +Hence the simplest, sequentially optimised data moving algorithm will be:
> > > +
> > > +.. code-block:: c
> > > +
> > > +	for (agno = sb_agcount - 1; agno > 0; agno--) {
> > > +		src = agno * sb_agblocks;
> > > +		dst = agno * new_agblocks;
> > > +		copy_file_range(src, dst, sb_agblocks);
> > > +	}
> > > +
> > > +This also leads to optimisation via server side or block device copy offload
> > > +infrastructure. Instead of streaming the data through kernel buffers, the copy
> > > +is handed to the server/hardware to moves the data internally as quickly as
> > > +possible.
> > > +
> > > +For filesystem images held in files and, potentially, on sparse storage devices
> > > +like dm-thinp, we don't even need to copy the data.  We can simply insert holes
> > > +into the underlying mapping at the appropriate place.  For filesystem images,
> > > +this is:
> > > +
> > > +.. code-block:: c
> > > +
> > > +	len = new_agblocks - sb_agblocks;
> > > +	for (agno = 1; agno < sb_agcount; agno++) {
> > > +		src = agno * sb_agblocks;
> > > +		fallocate(FALLOC_FL_INSERT_RANGE, src, len)
> > > +	}
> > > +
> > > +Then the filesystem image can be copied to the destination block device in an
> > > +efficient manner (i.e. skipping holes in the image file).
> > 
> > Does dm-thinp support insert range?
> 
> No - that would be a future enhancement. I mention it simly because
> these are things we would really want sparse block devices to
> support natively.

<nod> Should the next revision should cc -fsdevel and -block, then?

> > In the worst case (copy_file_range,
> > block device doesn't support xcopy) this results in a pagecache copy of
> > nearly all of the filesystem, doesn't it?
> 
> Yes, it would.

Counter-proposal: Instead of remapping the AGs to higher LBAs, what if
we allowed people to create single-AG filesystems with large(ish)
sb_agblocks.  You could then format a 2GB image with (say) a 100G AG
size and copy your 2GB of data into the filesystem.  At deploy time,
growfs will expand AG 0 to 100G and add new AGs after that, same as it
does now.

I think all we'd need is to add a switch to mkfs to tell it that it's
creating one of these gold master images, which would disable this
check:

	if (agsize > dblocks) {
		fprintf(stderr,
	_("agsize (%lld blocks) too big, data area is %lld blocks\n"),
			(long long)agsize, (long long)dblocks);
			usage();
	}

and set a largeish default AG size.  We might want to set a compat bit
so that xfs_repair won't complain about the single AG.

Yes, there are drawbacks, like the lack of redundant superblocks.  But
if growfs really runs at firstboot, then the deployed customer system
will likely have more than 1 AG and therefore be fine.

As for validating the integrity of the GM image, well, maybe the vendor
should enable fsverity. ;)

> > What about the log?  If sb_agblocks increases, that can cause
> > transaction reservations to increase, which also increases the minimum
> > log size.
> 
> Not caring, because the current default minimum of 64MB is big enough for
> any physical filesystem size. Further, 64MB is big enough for decent
> metadata performance even on large filesystem, so we really don't
> need to touch the journal here.
> 
> > If mkfs is careful, then I suppose xfs_expand could move the
> > log and make it bigger?  Or does mkfs create a log as if sb_agblocks
> > were 1TB, which will make the deployment image bigger?
> 
> making the log bigger is not as straight forward as it could be.
> If the log is dirty when we expand the filesystem and the dirty
> section wraps the end of the log, expansion just got really complex.
> So I'm just going to say "make the log large enough in the image
> file to begin with" and assert that we already do this with a
> current mkfs.
> 
> > Also, perhaps xfs_expand is a good opportunity to stamp a new uuid into
> > the superblock and set the metauuid bit?
> 
> Isn't provisioning software is generally already doing this via
> xfs_admin? We don't do this with growfs, and I'd prefer not to
> overload an expansion tool with random other administrative
> functions that only some use cases/environments might need. 

Yeah, though it'd be awfully convenient to do it while we've already got
the filesystem "mounted" in one userspace program.

> > I think the biggest difficulty for us (OCI) is that our block storage is
> > some sort of software defined storage system that exposes iscsi and
> > virtio-scsi endpoints.  For this to work, we'd have to have an
> > INSERT_RANGE SCSI command that the VM could send to the target and have
> > the device resize.  Does that exist today?
> 
> Not that I know of, but it's laregely irrelevant to the operation of
> xfs_expand what go fast features the underlying
> storage devices support . If they support INSERT_RANGE, we can use
> it. If they support FICLONERANGE we can use it. If the storage
> supports copy offload, copy_file_range() can use it. If all else
> fails, the kernel will just bounce the data through internal
> buffers (page cache for buffered IO or pipe buffers for direct IO).

I suspect copy offload will suffice for this, provided we can get the
OCI block storage folks to support it.  Now that support has landed in
the kernel, we can start those discussions internally.

> > > +Limitations
> > > +===========
> > > +
> > > +This document describes an offline mechanism for expanding the filesystem
> > > +geometery. It doesn't add new AGs, just expands they existing AGs. If the
> > > +filesystem needs to be made larger than maximally sized AGs can address, then
> > > +a subsequent online xfs_growfs operation is still required.
> > > +
> > > +For container/vm orchestration software, this isn't a huge issue as they
> > > +generally grow the image from within the initramfs context on first boot. That
> > > +is currently a "mount; xfs_growfs" operation pair; adding expansion to this
> > > +would simply require adding expansion before the mount. i.e. first boot becomes
> > > +a "xfs_expand; mount; xfs_growfs" operation. Depending on the eventual size of
> > > +the target filesystem, the xfs-growfs operation may be a no-op.
> > 
> > I don't know about your cloud, but ours seems to optimize vm deploy
> > times very heavily.  Right now their firstboot payload calls xfs_admin
> > to change the fs uuid, mounts the fs, and then growfs's it into the
> > container.
> > 
> > Adding another pre-mount firstboot program (and one that potentially
> > might do a lot of IO) isn't going to be popular with them.
> 
> There's nothing that requires xfs_expand to be done at first boot.
> First boot is just part of the deployment scripts and it may make
> sense to do the expansion as early as possible in the deployment
> process.

Yeah, but how often do you need to do a 10000x expansion on anything
other than a freshly cloned image?  Is that common in your cloudworld?
OCI usage patterns seem to be exploding the image on firstboot and
incremental growfs after that.

I think the difference between you and I here is that I see this
xfs_expand proposal as entirely a firstboot assistance program, whereas
you're looking at this more as a general operation that can happen at
any time.

> e.g. It could be run immediately after the image file is cloned from
> the source golden image. At that point it's still just an XFS file,
> right?

OCI block volumes are software defined storage; client VMs and
hypervisors don't have access to the internals of the storage nodes.

>        INSERT_RANGE won't affect the fact the extents are shared
> with the golden image, and it will be fast enough that it likely
> won't make a measurable impact on deployment speed. Four insert
> range calls on a largely contiguous file will take less than 100ms
> in most cases.

Let's hope so!

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
