Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C5814A4C8
	for <linux-xfs@vger.kernel.org>; Fri,  2 Aug 2024 12:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722600511; cv=none; b=SoKwhQyAgYazyy+7NVZrv9tcr60OGYUZGNYabhdbwxh8lZXHlvrGiE2CBAe1p0RGUEz3sWkSvi2V98Ur4NoAC0Hox1XnBKmSDfqSfooWX3A18sOPVVF4LB1GfSvG1Um52o8tvAEZfDNnUpqp7MpIM3ZpyILzgCOvtGUc6gnhtPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722600511; c=relaxed/simple;
	bh=tYkEn77ZMSoIkM1qeIxxoc1gc1/xApbDbJ2Nf+moaoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UfcAhDaTxfthT+k5kp0ikxCd85zeJolhXrlWHkDfsQyQWRkpFJcn5DZSRUVn7T/E/Z2wQru9/zOPXcTPwWy7L2uaWpaJ5WdlBCaakd/izsVVc61vJFnHjiwLS/ur8lyR7Y25VZCizj8fLbu6GAbbGEIbfERhUdHPbxLBkP+ARjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T7+DzbFf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T7+DzbFf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722600507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gkovzc6ohBYgF9Late/GadMW73Fiv81QtRyAQ4mOCzc=;
	b=T7+DzbFfRA2Av/5v5HkYkw9b/SdnctMFdj1oBe9Du0FZNURt6GaMWAzgssHLe14vncbS2T
	RMpS/8gJyHlbD9z9j08zWilw2IGYMgttHLY6NZmrHKb5AHyZoBV+5veBzNJtbwPTe0WIuI
	IUK/RbpGpKjyuhAwkZMovorkx5ukFF8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-631-mb08m1GmPIStbpdUQMyjjA-1; Fri,
 02 Aug 2024 08:08:24 -0400
X-MC-Unique: mb08m1GmPIStbpdUQMyjjA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 95ADA1955D47;
	Fri,  2 Aug 2024 12:08:23 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.152])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C3B52300019E;
	Fri,  2 Aug 2024 12:08:22 +0000 (UTC)
Date: Fri, 2 Aug 2024 08:09:15 -0400
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: filesystem expansion design documentation
Message-ID: <ZqzMay58f0SvdWxV@bfoster>
References: <20240721230100.4159699-1-david@fromorbit.com>
 <20240723235801.GU612460@frogsfrogsfrogs>
 <ZqBO177pPLbovguo@dread.disaster.area>
 <20240724210833.GZ612460@frogsfrogsfrogs>
 <ZqGfTvAEzFbfe+Wa@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqGfTvAEzFbfe+Wa@dread.disaster.area>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Jul 25, 2024 at 10:41:50AM +1000, Dave Chinner wrote:
> On Wed, Jul 24, 2024 at 02:08:33PM -0700, Darrick J. Wong wrote:
> > On Wed, Jul 24, 2024 at 10:46:15AM +1000, Dave Chinner wrote:
> > > On Tue, Jul 23, 2024 at 04:58:01PM -0700, Darrick J. Wong wrote:
> > > > On Mon, Jul 22, 2024 at 09:01:00AM +1000, Dave Chinner wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > 
> > > > > xfs-expand is an attempt to address the container/vm orchestration
> > > > > image issue where really small XFS filesystems are grown to massive
> > > > > sizes via xfs_growfs and end up with really insane, suboptimal
> > > > > geometries.
> ....
> > > > > +Moving the data within an AG could be optimised to be space usage aware, similar
> > > > > +to what xfs_copy does to build sparse filesystem images. However, the space
> > > > > +optimised filesystem images aren't going to have a lot of free space in them,
> > > > > +and what there is may be quite fragmented. Hence doing free space aware copying
> > > > > +of relatively full small AGs may be IOPS intensive. Given we are talking about
> > > > > +AGs in the typical size range from 64-512MB, doing a sequential copy of the
> > > > > +entire AG isn't going to take very long on any storage. If we have to do several
> > > > > +hundred seeks in that range to skip free space, then copying the free space will
> > > > > +cost less than the seeks and the partial RAID stripe writes that small IOs will
> > > > > +cause.
> > > > > +
> > > > > +Hence the simplest, sequentially optimised data moving algorithm will be:
> > > > > +
> > > > > +.. code-block:: c
> > > > > +
> > > > > +	for (agno = sb_agcount - 1; agno > 0; agno--) {
> > > > > +		src = agno * sb_agblocks;
> > > > > +		dst = agno * new_agblocks;
> > > > > +		copy_file_range(src, dst, sb_agblocks);
> > > > > +	}
> > > > > +
> > > > > +This also leads to optimisation via server side or block device copy offload
> > > > > +infrastructure. Instead of streaming the data through kernel buffers, the copy
> > > > > +is handed to the server/hardware to moves the data internally as quickly as
> > > > > +possible.
> > > > > +
> > > > > +For filesystem images held in files and, potentially, on sparse storage devices
> > > > > +like dm-thinp, we don't even need to copy the data.  We can simply insert holes
> > > > > +into the underlying mapping at the appropriate place.  For filesystem images,
> > > > > +this is:
> > > > > +
> > > > > +.. code-block:: c
> > > > > +
> > > > > +	len = new_agblocks - sb_agblocks;
> > > > > +	for (agno = 1; agno < sb_agcount; agno++) {
> > > > > +		src = agno * sb_agblocks;
> > > > > +		fallocate(FALLOC_FL_INSERT_RANGE, src, len)
> > > > > +	}
> > > > > +
> > > > > +Then the filesystem image can be copied to the destination block device in an
> > > > > +efficient manner (i.e. skipping holes in the image file).
> > > > 
> > > > Does dm-thinp support insert range?
> > > 
> > > No - that would be a future enhancement. I mention it simly because
> > > these are things we would really want sparse block devices to
> > > support natively.
> > 
> > <nod> Should the next revision should cc -fsdevel and -block, then?
> 
> No. This is purely an XFS feature at this point. If future needs
> change and we require work outside of XFS to be done, then it can be
> taken up with external teams to design and implement the optional
> acceleration functions that we desire.
> 
> > > > In the worst case (copy_file_range,
> > > > block device doesn't support xcopy) this results in a pagecache copy of
> > > > nearly all of the filesystem, doesn't it?
> > > 
> > > Yes, it would.
> > 
> > Counter-proposal: Instead of remapping the AGs to higher LBAs, what if
> > we allowed people to create single-AG filesystems with large(ish)
> > sb_agblocks.  You could then format a 2GB image with (say) a 100G AG
> > size and copy your 2GB of data into the filesystem.  At deploy time,
> > growfs will expand AG 0 to 100G and add new AGs after that, same as it
> > does now.
> 
> We can already do this with existing tools.
> 
> All it requires is using xfs_db to rewrite the sb/ag geometry and
> adding new freespace records. Now you have a 100GB AG instead of 2GB
> and you can mount it and run growfs to add all the extra AGs you
> need.
> 

I'm not sure you have to do anything around adding new freespace records
as such. If you format a small agcount=1 fs and then bump the sb agblock
fields via xfs_db, then last I knew you could mount and run xfs_growfs
according to the outsized AG size with no further changes at all. The
grow will add the appropriate free space records as normal. I've not
tried that with actually copying in data first, but otherwise it
survives repair at least.

It would be interesting to see if that all still works with data present
as long as you update the agblock fields before copying anything in. The
presumption is that this operates mostly the same as extending an
existing runt AG to a size that's still smaller than the full AG size,
which obviously works today, just with the special circumstance that
said runt AG happens to be the only AG in the fs.

FWIW, Darrick's proposal here is pretty much exactly what I've thought
XFS should have been at least considering doing to mitigate this cloudy
deployment problem for quite some time. I agree with the caveats and
limitations that Eric points out, but for a narrowly scoped cloudy
deployment tool I have a hard time seeing how this wouldn't be anything
but a significant improvement over the status quo for a relatively small
amount of work (assuming it can be fully verified to work, of course ;).

ISTM that the major caveats can be managed with some reasonable amount
of guardrails or policy enforcement. For example, if mkfs.xfs supported
an "image mode" param that specified a target/min deployment size, that
could be used as a hint to set the superblock AG size, a log size more
reflective of the eventual deployment size, and perhaps even facilitate
some usage limitations until that expected deployment occurs.

I.e., perhaps also set an "image mode" feature flag that requires a
corresponding mount option in order to mount writeable (to populate the
base image), and otherwise the fs mounts in a restricted-read mode where
grow is allowed, and grow only clears the image mode state once the fs
grows to at least 2 AGs (or whatever), etc. etc. At that point the user
doesn't have to know or care about any of the underlying geometry
details, just format and deploy as documented.

That's certainly not perfect and I suspect we could probably come up
with a variety of different policy permutations or user interfaces to
consider, but ISTM there's real practical value to something like that.

> Maybe it wasn't obvious from my descriptions of the sparse address
> space diagrams, but single AG filesystems have no restrictions of AG
> size growth because there are no high bits set in any of the sparse
> 64 bit address spaces (i.e. fsbno or inode numbers). Hence we can
> expand the AG size without worrying about overwriting the address
> space used by higher AGs.
> 
> IOWs, the need for reserving sparse address space bits just doesn't
> exist for single AG filesystems.  The point of this proposal is to
> document a generic algorithm that avoids the problem of the higher
> AG address space limiting how large lower AGs can be made. That's
> the problem that prevents substantial resizing of AGs, and that's
> what this design document addresses.
> 

So in theory it sounds like you could also defer setting the final AG
size on a single AG fs at least until the first grow, right? If so, that
might be particularly useful for the typical one-shot
expansion/deployment use case. The mkfs could just set image mode and
single AG, and then the first major grow finalizes the ag size and
expands to a sane (i.e. multi AG) format.

I guess that potentially makes log sizing a bit harder, but we've had
some discussion around online moving and resizing the log in the past as
well and IIRC it wasn't really that hard to achieve so long as we keep
the environment somewhat constrained by virtue of switching across a
quiesce, for example. I don't recall all the details though; I'd have to
see if I can dig up that conversation...

> > > > Also, perhaps xfs_expand is a good opportunity to stamp a new uuid into
> > > > the superblock and set the metauuid bit?
> > > 
> > > Isn't provisioning software is generally already doing this via
> > > xfs_admin? We don't do this with growfs, and I'd prefer not to
> > > overload an expansion tool with random other administrative
> > > functions that only some use cases/environments might need. 
> > 
> > Yeah, though it'd be awfully convenient to do it while we've already got
> > the filesystem "mounted" in one userspace program.
> 
> "it'd be awfully convenient" isn't a technical argument. It's an
> entirely subjective observation and assumes an awful lot about the
> implementation design that hasn't been started yet.
> 
> Indeed, from an implementation perspective I'm considering that
> xfs_expand might even implemented as a simple shell script that
> wraps xfs_db and xfs_io. I strongly suspect that we don't need to
> write any custom C code for it at all. It's really that simple.
> 
> Hence talking about anything to do with optimising the whole expand
> process to take on other administration tasks before we've even
> started on a detailed implementation design is highly premature.  I
> want to make sure the high level design and algorithms are
> sufficient for all the use cases people can come up with, not define
> exactly how we are going to implement the functionality.
> 
> > > > > +Limitations
> > > > > +===========
> > > > > +
> > > > > +This document describes an offline mechanism for expanding the filesystem
> > > > > +geometery. It doesn't add new AGs, just expands they existing AGs. If the
> > > > > +filesystem needs to be made larger than maximally sized AGs can address, then
> > > > > +a subsequent online xfs_growfs operation is still required.
> > > > > +
> > > > > +For container/vm orchestration software, this isn't a huge issue as they
> > > > > +generally grow the image from within the initramfs context on first boot. That
> > > > > +is currently a "mount; xfs_growfs" operation pair; adding expansion to this
> > > > > +would simply require adding expansion before the mount. i.e. first boot becomes
> > > > > +a "xfs_expand; mount; xfs_growfs" operation. Depending on the eventual size of
> > > > > +the target filesystem, the xfs-growfs operation may be a no-op.
> > > > 
> > > > I don't know about your cloud, but ours seems to optimize vm deploy
> > > > times very heavily.  Right now their firstboot payload calls xfs_admin
> > > > to change the fs uuid, mounts the fs, and then growfs's it into the
> > > > container.
> > > > 
> > > > Adding another pre-mount firstboot program (and one that potentially
> > > > might do a lot of IO) isn't going to be popular with them.
> > > 
> > > There's nothing that requires xfs_expand to be done at first boot.
> > > First boot is just part of the deployment scripts and it may make
> > > sense to do the expansion as early as possible in the deployment
> > > process.
> > 
> > Yeah, but how often do you need to do a 10000x expansion on anything
> > other than a freshly cloned image?  Is that common in your cloudworld?
> > OCI usage patterns seem to be exploding the image on firstboot and
> > incremental growfs after that.
> 
> I've seen it happen many times outside of container/VMs - this was a
> even a significant problem 20+ years ago when AGs were limited to
> 4GB. That specific historic case was fixed by moving to 1TB max AG
> size, but there was no way to convert an existing filesystem. This
> is the "cloud case" in a nutshell, so it's clearly not a new
> problem.
> 
> Even ignoring the historic situation, we still see people have these
> problems with growing filesystems. It's especially prevalent with
> demand driven thin provisioned storage. Project starts small with
> only the space they need (e.g. for initial documentation), then as
> it ramps up and starts to generate TBs of data, the storage gets
> expanded from it's initial "few GBs" size. Same problem, different
> environment.
> 
> > I think the difference between you and I here is that I see this
> > xfs_expand proposal as entirely a firstboot assistance program, whereas
> > you're looking at this more as a general operation that can happen at
> > any time.
> 
> Yes. As I've done for the past 15+ years, I'm thinking about the
> best solution for the wider XFS and storage community first and
> commercial imperatives second. I've seen people use XFS features and
> storage APIs for things I've never considered when designing them.
> I'm constantly surprised by how people use the functionality we
> provide in innovative, unexpected ways because they are generic
> enough to provide building blocks that people can use to implement
> new ideas.
> 

I think Darrick's agcount=1 proposal here is a nice example of that,
taking advantage of existing design flexibility to provide a creative
and elegantly simple solution to a real problem with minimal change and
risk.

Again the concept obviously needs to be prototyped enough to establish
confidence that it can work, but I don't really see how this has to be
mutually exclusive from a generic and more flexible and robust expand
mechanism in the longer term.

Just my .02. Thanks for the nice writeup, BTW.

Brian

> Filesystem expansion is, IMO, one of those "generically useful"
> tools and algorithms.
> 
> Perhaps it's not an obvious jump, but I'm also thinking about how we
> might be able to do the opposite of AG expansion to shrink the
> filesystem online. Not sure it is possible yet, but having the
> ability to dynamically resize AGs opens up many new possibilities.
> That's way outside the scope of this discussion, but I mention it
> simply to point out that the core of this generic expansion idea -
> decoupling the AG physical size from the internal sparse 64 bit
> addressing layout - has many potential future uses...
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

