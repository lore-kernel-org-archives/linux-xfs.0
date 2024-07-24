Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CFF4C62
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 00:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721781982; cv=none; b=jAbSP/qS8HL6W6KWdVrHZ/5oW1oP+ym83jlBd4XbdNj5TVK06wruKIsvtvSDvLuvCPyHLbelcuXVGB8bi6eCSlvnPkcE108i41IpIrXDDh+hmOu9Li53npf+VxV2qGP+aVrDHdKkbMN0lnF9ShmvCkCth0FBQDU4tDmzURBFOhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721781982; c=relaxed/simple;
	bh=o78cMzoRERQ0hH4p+oi6XeUjaodZqkIaIij34jIVdV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GP519Vs6MsLUwL7Auhghf8Tz6mrvII2agFxibHyp17KVYWl8Ieuer8kOmH3MQYG3crsh43coTnwMeTh+gq+XcqOasVGNRqvXmx3QT+MFGMSdiirSqIHHaKynxAu1HdL48hHGL6STQR/x/KTjKyaU6+6zds4zR6Nl7Xq+NnsA4t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=e1fH4FGg; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="e1fH4FGg"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1fc56fd4de1so2809685ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2024 17:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1721781980; x=1722386780; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dBP3fJ2Twvbe3RANIUCzmSUBe7vQnImZy+x0NUPjOCI=;
        b=e1fH4FGgZQMrgHXCKPS6woekZpZ229GSO0sG1GnIyJSh2m+QoOmfG8JkTgQiy0aeC9
         2rN92wPefSvNeeug6nlpMvS4LQ9U9kYN9qmNypoaz04rsVSXQ7qrp6QTJ6sgWCdWSVfW
         C88QjQVfbYTlshnmE+cFRLPzwJ/QSOcr+XX87ehnUnpwxOVuvTV4cVHAl75b0XDd/lMn
         XSYBKT4fXgAhz+3qiihWfFg0QUxkj7FNB2h2c8oQA+PbNk67VV53QVq0hcqWj3Fom7Fc
         sSgonE+uhl8UASbdKzWdehImAFDzjV5YTNBxLfbOI6yF2QEZSH29TVkF+XnRZiANQXmY
         0JLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721781980; x=1722386780;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dBP3fJ2Twvbe3RANIUCzmSUBe7vQnImZy+x0NUPjOCI=;
        b=QB22Sy6y/+noRi8xtvSTdcZehSijWzVbTzfThvjIshvY4hBj1bCkKwcHcPlKQBc3eT
         +tSnr2Ny2BStrPEyj790eDUG9qHwhpy62JxOpFSYFotmVlpHvdOoEASrWjEcGYDFyUWP
         RuMk0KxF1bVBI0bKS9YnJ05+80We9PvLMOUsQgkp6/alhIUp7TOzsmfr11GXmbQAJcle
         Fyo+LgZ3h422I0G177xTUdwXpXeF1TlrwJZV+zYBVKydUt8vngRTFjBSlsawOXDok+7x
         Mntmf8KKPXCFwZW/e5FoHU3Cn6DYLGpIPBOldF9pLSVYDeB7b6vfvOumndWPxTBSsTsl
         1ghA==
X-Gm-Message-State: AOJu0YwgAXDjPNtDgpGRzztWgb1HxdV1IPSY87OJEil4VjoVU7E45lqT
	4ZsdFWtWQP3boBY+tb6Iz58mYkMSBwrjIkxxj5RsN3z0fxxG+1guKMbw5CyK9Jg=
X-Google-Smtp-Source: AGHT+IHqVofknqMbDhqFqeeglxjORTin+hToSVWvqqgUzG3NGBvZKBgflFGTixApGNKxr0eZvNItHw==
X-Received: by 2002:a17:903:189:b0:1fd:71cd:4431 with SMTP id d9443c01a7336-1fdd6e7a904mr4271075ad.24.1721781979466;
        Tue, 23 Jul 2024 17:46:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f48cd7csm81349115ad.286.2024.07.23.17.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 17:46:18 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sWQ91-00967O-0K;
	Wed, 24 Jul 2024 10:46:15 +1000
Date: Wed, 24 Jul 2024 10:46:15 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: filesystem expansion design documentation
Message-ID: <ZqBO177pPLbovguo@dread.disaster.area>
References: <20240721230100.4159699-1-david@fromorbit.com>
 <20240723235801.GU612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240723235801.GU612460@frogsfrogsfrogs>

On Tue, Jul 23, 2024 at 04:58:01PM -0700, Darrick J. Wong wrote:
> On Mon, Jul 22, 2024 at 09:01:00AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs-expand is an attempt to address the container/vm orchestration
> > image issue where really small XFS filesystems are grown to massive
> > sizes via xfs_growfs and end up with really insane, suboptimal
> > geometries.
> > 
> > Rather that grow a filesystem by appending AGs, expanding a
> > filesystem is based on allowing existing AGs to be expanded to
> > maximum sizes first. If further growth is needed, then the
> > traditional "append more AGs" growfs mechanism is triggered.
> > 
> > This document describes the structure of an XFS filesystem needed to
> > achieve this expansion, as well as the design of userspace tools
> > needed to make the mechanism work.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  Documentation/filesystems/xfs/index.rst       |   1 +
> >  .../filesystems/xfs/xfs-expand-design.rst     | 312 ++++++++++++++++++
> >  2 files changed, 313 insertions(+)
> >  create mode 100644 Documentation/filesystems/xfs/xfs-expand-design.rst
> > 
> > diff --git a/Documentation/filesystems/xfs/index.rst b/Documentation/filesystems/xfs/index.rst
> > index ab66c57a5d18..cb570fc886b2 100644
> > --- a/Documentation/filesystems/xfs/index.rst
> > +++ b/Documentation/filesystems/xfs/index.rst
> > @@ -12,3 +12,4 @@ XFS Filesystem Documentation
> >     xfs-maintainer-entry-profile
> >     xfs-self-describing-metadata
> >     xfs-online-fsck-design
> > +   xfs-expand-design
> > diff --git a/Documentation/filesystems/xfs/xfs-expand-design.rst b/Documentation/filesystems/xfs/xfs-expand-design.rst
> > new file mode 100644
> > index 000000000000..fffc0b44518d
> > --- /dev/null
> > +++ b/Documentation/filesystems/xfs/xfs-expand-design.rst
> > @@ -0,0 +1,312 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +===============================
> > +XFS Filesystem Expansion Design
> > +===============================
> > +
> > +Background
> > +==========
> > +
> > +XFS has long been able to grow the size of the filesystem dynamically whilst
> > +mounted. The functionality has been used extensively over the past 3 decades
> > +for managing filesystems on expandable storage arrays, but over the past decade
> > +there has been significant growth in filesystem image based orchestration
> > +frameworks that require expansion of the filesystem image during deployment.
> > +
> > +These frameworks want the initial image to be as small as possible to minimise
> > +the cost of deployment, but then want that image to scale to whatever size the
> > +deployment requires. This means that the base image can be as small as a few
> > +hundred megabytes and be expanded on deployment to tens of terabytes.
> > +
> > +Growing a filesystem by 4-5 orders of magnitude is a long way outside the scope
> > +of the original xfs_growfs design requirements. It was designed for users who
> > +were adding physical storage to already large storage arrays; a single order of
> > +magnitude in growth was considered a very large expansion.
> > +
> > +As a result, we have a situation where growing a filesystem works well up to a
> > +certain point, yet we have orchestration frameworks that allows users to expand
> > +filesystems a long way past this point without them being aware of the issues
> > +it will cause them further down the track.
> 
> Ok, same growfs-on-deploy problem that we have.  Though, the minimum OCI
> boot volume size is ~47GB so at least we're not going from 2G -> 200G.
> Usually.
> 
> > +Scope
> > +=====
> > +
> > +The need to expand filesystems with a geometry optimised for small storage
> > +volumes onto much larger storage volumes results in a large filesystem with
> > +poorly optimised geometry. Growing a small XFS filesystem by several orders of
> > +magnitude results in filesystem with many small allocation groups (AGs). This is
> > +bad for allocation effciency, contiguous free space management, allocation
> > +performance as the filesystem fills, and so on. The filesystem will also end up
> > +with a very small journal for the size of the filesystem which can limit the
> > +metadata performance and concurrency in the filesystem drastically.
> > +
> > +These issues are a result of the filesystem growing algorithm. It is an
> > +append-only mechanism which takes advantage of the fact we can safely initialise
> > +the metadata for new AGs beyond the end of the existing filesystem without
> > +impacting runtime behaviour. Those newly initialised AGs can then be enabled
> > +atomically by running a single transaction to expose that newly initialised
> > +space to the running filesystem.
> > +
> > +As a result, the growing algorithm is a fast, transparent, simple and crash-safe
> > +algorithm that can be run while the filesystem is mounted. It's a very good
> > +algorithm for growing a filesystem on a block device that has has new physical
> > +storage appended to it's LBA space.
> > +
> > +However, this algorithm shows it's limitations when we move to system deployment
> > +via filesystem image distribution. These deployments optimise the base
> > +filesystem image for minimal size to minimise the time and cost of deploying
> > +them to the newly provisioned system (be it VM or container). They rely on the
> > +filesystem's ability to grow the filesystem to the size of the destination
> > +storage during the first system bringup when they tailor the deployed filesystem
> > +image for it's intented purpose and identity.
> > +
> > +If the deployed system has substantial storage provisioned, this means the
> > +filesystem image will be expanded by multiple orders of magnitude during the
> > +system initialisation phase, and this is where the existing append-based growing
> > +algorithm falls apart. This is the issue that this design seeks to resolve.
> 
> I very much appreciate the scope definition here.  I also very much
> appreciate starting off with a design document!  Thank you.
> 
> <snip out parts I'm already familiar with>
> 
> > +Optimising Physical AG Realignment
> > +==================================
> > +
> > +The elephant in the room at this point in time is the fact that we have to
> > +physically move data around to expand AGs. While this makes AG size expansion
> > +prohibitive for large filesystems, they should already have large AGs and so
> > +using the existing grow mechanism will continue to be the right tool to use for
> > +expanding them.
> > +
> > +However, for small filesystems and filesystem images in the order of hundreds of
> > +MB to a few GB in size, the cost of moving data around is much more tolerable.
> > +If we can optimise the IO patterns to be purely sequential, offload the movement
> > +to the hardware, or even use address space manipulation APIs to minimise the
> > +cost of this movement, then resizing AGs via realignment becomes even more
> > +appealing.
> > +
> > +Realigning AGs must avoid overwriting parts of AGs that have not yet been
> > +realigned. That means we can't realign the AGs from AG 1 upwards - doing so will
> > +overwrite parts of AG2 before we've realigned that data. Hence realignment must
> > +be done from the highest AG first, and work downwards.
> > +
> > +Moving the data within an AG could be optimised to be space usage aware, similar
> > +to what xfs_copy does to build sparse filesystem images. However, the space
> > +optimised filesystem images aren't going to have a lot of free space in them,
> > +and what there is may be quite fragmented. Hence doing free space aware copying
> > +of relatively full small AGs may be IOPS intensive. Given we are talking about
> > +AGs in the typical size range from 64-512MB, doing a sequential copy of the
> > +entire AG isn't going to take very long on any storage. If we have to do several
> > +hundred seeks in that range to skip free space, then copying the free space will
> > +cost less than the seeks and the partial RAID stripe writes that small IOs will
> > +cause.
> > +
> > +Hence the simplest, sequentially optimised data moving algorithm will be:
> > +
> > +.. code-block:: c
> > +
> > +	for (agno = sb_agcount - 1; agno > 0; agno--) {
> > +		src = agno * sb_agblocks;
> > +		dst = agno * new_agblocks;
> > +		copy_file_range(src, dst, sb_agblocks);
> > +	}
> > +
> > +This also leads to optimisation via server side or block device copy offload
> > +infrastructure. Instead of streaming the data through kernel buffers, the copy
> > +is handed to the server/hardware to moves the data internally as quickly as
> > +possible.
> > +
> > +For filesystem images held in files and, potentially, on sparse storage devices
> > +like dm-thinp, we don't even need to copy the data.  We can simply insert holes
> > +into the underlying mapping at the appropriate place.  For filesystem images,
> > +this is:
> > +
> > +.. code-block:: c
> > +
> > +	len = new_agblocks - sb_agblocks;
> > +	for (agno = 1; agno < sb_agcount; agno++) {
> > +		src = agno * sb_agblocks;
> > +		fallocate(FALLOC_FL_INSERT_RANGE, src, len)
> > +	}
> > +
> > +Then the filesystem image can be copied to the destination block device in an
> > +efficient manner (i.e. skipping holes in the image file).
> 
> Does dm-thinp support insert range?

No - that would be a future enhancement. I mention it simly because
these are things we would really want sparse block devices to
support natively.

> In the worst case (copy_file_range,
> block device doesn't support xcopy) this results in a pagecache copy of
> nearly all of the filesystem, doesn't it?

Yes, it would.

> What about the log?  If sb_agblocks increases, that can cause
> transaction reservations to increase, which also increases the minimum
> log size.

Not caring, because the current default minimum of 64MB is big enough for
any physical filesystem size. Further, 64MB is big enough for decent
metadata performance even on large filesystem, so we really don't
need to touch the journal here.

> If mkfs is careful, then I suppose xfs_expand could move the
> log and make it bigger?  Or does mkfs create a log as if sb_agblocks
> were 1TB, which will make the deployment image bigger?

making the log bigger is not as straight forward as it could be.
If the log is dirty when we expand the filesystem and the dirty
section wraps the end of the log, expansion just got really complex.
So I'm just going to say "make the log large enough in the image
file to begin with" and assert that we already do this with a
current mkfs.

> Also, perhaps xfs_expand is a good opportunity to stamp a new uuid into
> the superblock and set the metauuid bit?

Isn't provisioning software is generally already doing this via
xfs_admin? We don't do this with growfs, and I'd prefer not to
overload an expansion tool with random other administrative
functions that only some use cases/environments might need. 

> I think the biggest difficulty for us (OCI) is that our block storage is
> some sort of software defined storage system that exposes iscsi and
> virtio-scsi endpoints.  For this to work, we'd have to have an
> INSERT_RANGE SCSI command that the VM could send to the target and have
> the device resize.  Does that exist today?

Not that I know of, but it's laregely irrelevant to the operation of
xfs_expand what go fast features the underlying
storage devices support . If they support INSERT_RANGE, we can use
it. If they support FICLONERANGE we can use it. If the storage
supports copy offload, copy_file_range() can use it. If all else
fails, the kernel will just bounce the data through internal
buffers (page cache for buffered IO or pipe buffers for direct IO).

> > +Limitations
> > +===========
> > +
> > +This document describes an offline mechanism for expanding the filesystem
> > +geometery. It doesn't add new AGs, just expands they existing AGs. If the
> > +filesystem needs to be made larger than maximally sized AGs can address, then
> > +a subsequent online xfs_growfs operation is still required.
> > +
> > +For container/vm orchestration software, this isn't a huge issue as they
> > +generally grow the image from within the initramfs context on first boot. That
> > +is currently a "mount; xfs_growfs" operation pair; adding expansion to this
> > +would simply require adding expansion before the mount. i.e. first boot becomes
> > +a "xfs_expand; mount; xfs_growfs" operation. Depending on the eventual size of
> > +the target filesystem, the xfs-growfs operation may be a no-op.
> 
> I don't know about your cloud, but ours seems to optimize vm deploy
> times very heavily.  Right now their firstboot payload calls xfs_admin
> to change the fs uuid, mounts the fs, and then growfs's it into the
> container.
> 
> Adding another pre-mount firstboot program (and one that potentially
> might do a lot of IO) isn't going to be popular with them.

There's nothing that requires xfs_expand to be done at first boot.
First boot is just part of the deployment scripts and it may make
sense to do the expansion as early as possible in the deployment
process.

e.g. It could be run immediately after the image file is cloned from
the source golden image. At that point it's still just an XFS file,
right? INSERT_RANGE won't affect the fact the extents are shared
with the golden image, and it will be fast enough that it likely
won't make a measurable impact on deployment speed. Four insert
range calls on a largely contiguous file will take less than 100ms
in most cases.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
