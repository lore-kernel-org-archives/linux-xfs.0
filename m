Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E545191F9E
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 13:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723210241; cv=none; b=li3Dq+JMBRPsvpNfY4HXjl0vucvpDTzshSwS8+C3L+aLDdkk78WyB0LiHe/8MdLrAVmZmvYkA9bG5uBXj+OaXZPQjuZ+QrNdYvBla7Y9+NXJfwlqfB8rdKOTjPBkJk6TV987yB4KBFF0CNQ06lxlhb5vlnG7Whfx4Bg6Hbcyvmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723210241; c=relaxed/simple;
	bh=vluptnC/jl7Kacxg6/9t9Jy4Z8VtUqycOZ0dwQlx+C0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XIFoYkIt/S1a5Md05nEaV/2HecFC7gbI36bPO1amUkUTJ6wOVGOWiDYday8mCg0ys7ATp+zbzbmbSd7hEvdCti8I6lEVtopj4ZSHmugaAKv6zORaG5Q9HawVsQcxfTc+jk5YXY7qG2r2JazcEM/5i8iHhGRyu0AVKEoL2peVGM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AVTuu5WP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AVTuu5WP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723210237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2ak0mdwToD2z0Oy1yKzNDnQKqX54buMfDD+wrZLgEdY=;
	b=AVTuu5WPPY+b6UPDhlogjn6taB00JOmFk31ccLWU7wQ1ZWKceTRJ9/kSkenFJq3xaWoCc8
	O5Jrv29mGmNRpRUbhWh6kZWAyMxsqS5jBTuPNfOTNns/+JiBpT8UeN1HMyuSDycLct8Z0x
	HiT0LJXLsGsfBd6XjyeUYKFWurAhGRU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-164-vrAD0ytzOXKBvfviz0FF7g-1; Fri,
 09 Aug 2024 09:30:32 -0400
X-MC-Unique: vrAD0ytzOXKBvfviz0FF7g-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 770331944CCC;
	Fri,  9 Aug 2024 13:30:30 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.152])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A74819560AD;
	Fri,  9 Aug 2024 13:30:29 +0000 (UTC)
Date: Fri, 9 Aug 2024 09:31:21 -0400
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: filesystem expansion design documentation
Message-ID: <ZrYaKYrt5NeWvKiM@bfoster>
References: <20240721230100.4159699-1-david@fromorbit.com>
 <20240723235801.GU612460@frogsfrogsfrogs>
 <ZqBO177pPLbovguo@dread.disaster.area>
 <20240724210833.GZ612460@frogsfrogsfrogs>
 <ZqGfTvAEzFbfe+Wa@dread.disaster.area>
 <ZqzMay58f0SvdWxV@bfoster>
 <ZrGEECeOb7X3aS20@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrGEECeOb7X3aS20@dread.disaster.area>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Tue, Aug 06, 2024 at 12:01:52PM +1000, Dave Chinner wrote:
> On Fri, Aug 02, 2024 at 08:09:15AM -0400, Brian Foster wrote:
> > On Thu, Jul 25, 2024 at 10:41:50AM +1000, Dave Chinner wrote:
> > > On Wed, Jul 24, 2024 at 02:08:33PM -0700, Darrick J. Wong wrote:
> > > > Counter-proposal: Instead of remapping the AGs to higher LBAs, what if
> > > > we allowed people to create single-AG filesystems with large(ish)
> > > > sb_agblocks.  You could then format a 2GB image with (say) a 100G AG
> > > > size and copy your 2GB of data into the filesystem.  At deploy time,
> > > > growfs will expand AG 0 to 100G and add new AGs after that, same as it
> > > > does now.
> > > 
> > > We can already do this with existing tools.
> > > 
> > > All it requires is using xfs_db to rewrite the sb/ag geometry and
> > > adding new freespace records. Now you have a 100GB AG instead of 2GB
> > > and you can mount it and run growfs to add all the extra AGs you
> > > need.
> > > 
> > 
> > I'm not sure you have to do anything around adding new freespace records
> > as such. If you format a small agcount=1 fs and then bump the sb agblock
> > fields via xfs_db, then last I knew you could mount and run xfs_growfs
> > according to the outsized AG size with no further changes at all. The
> > grow will add the appropriate free space records as normal. I've not
> > tried that with actually copying in data first, but otherwise it
> > survives repair at least.
> 
> Yes, we could do it that way, too. It's just another existing
> tool, but it requires the kernel to support an on-disk format
> variant we have never previously supported.
> 
> > It would be interesting to see if that all still works with data present
> > as long as you update the agblock fields before copying anything in. The
> > presumption is that this operates mostly the same as extending an
> > existing runt AG to a size that's still smaller than the full AG size,
> > which obviously works today, just with the special circumstance that
> > said runt AG happens to be the only AG in the fs.
> 
> Yes, exactly. Without significant effort to audit the code to ensure
> this is safe I'm hesitant to say it'll actually work correctly. And
> given that we can avoid such issues completely with a little bit of
> xfs_db magic, the idea of having to support a weird one-off on
> disk format variant forever just to allow growfs to do this One Neat
> Trick doesn't seem like a good one to me.
> 

The One Neat Trick is to enable growfs to work exactly as it does today,
so it seems like a good idea to me.

> > FWIW, Darrick's proposal here is pretty much exactly what I've thought
> > XFS should have been at least considering doing to mitigate this cloudy
> > deployment problem for quite some time. I agree with the caveats and
> > limitations that Eric points out, but for a narrowly scoped cloudy
> > deployment tool I have a hard time seeing how this wouldn't be anything
> > but a significant improvement over the status quo for a relatively small
> > amount of work (assuming it can be fully verified to work, of course ;).
> 
> I've considered it, too, and looked at what it means in the bigger
> picture of the proliferation of cloud providers out there that have
> their own image build/deploy implementations.
> 
> These cloud implementations would need all the client side
> kernels and userspace to support this new way of deploying XFS
> images. It will also need the orchestration software to buy into
> this new XFS toolchain for image building and deployment. There are
> a -lot- of moving parts to make this work, but it cannot replace the
> existing build/deploy pipeling because clouds have to support older
> distros/kernels that do stuff the current way.
> 

The whole point is to use a format that fundamentally works with
existing workflows. The customization is at image creation time and
doesn't introduce any special deployment requirements.

Here's a repeat of the previous experiment, now with throwing some data
in...

# truncate -s 512M img
# ~/xfsprogs-dev/mkfs/mkfs.xfs -f img -dagcount=1 -lsize=64m
(creates 512MB fs based on underlying image file size)
# xfs_db -xc "sb 0" -c "write -d agblocks 2097152" -c "write -d agblklog 21" ./img
(bump AG size to 8GB)

# xfs_repair -nf -o force_geometry ./img
(passes)
<mount, copy in xfsprogs source repo, umount>
# xfs_repair -nf -o force_geometry ./img
(still passes)

# truncate -s 40G ./img
# mount ./img /mnt/
# xfs_growfs /mnt/
meta-data=/dev/loop0             isize=512    agcount=1, agsize=2097152 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
data     =                       bsize=4096   blocks=131072, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 131072 to 10485760
# xfs_info /mnt/
meta-data=/dev/loop0             isize=512    agcount=5, agsize=2097152 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
data     =                       bsize=4096   blocks=10485760, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

... and repair still passes and I can clean/compile the xfsprogs source
repo copied in above without any userspace or filesystem level errors.

This is on an upstream xfsprogs/kernel with the only change being I
removed the agcount=1 restriction from mkfs to format the fs. So there
are essentially zero functional changes and this produces a 5xAG fs in a
use case where we otherwise currently produce something like ~300.

> That's one of the driving factors behind the expansion design - it
> requires little in the way of changes to the build/deploy pipeline.
> There are minimal kernel changes needed to support it, so backports
> to LTS kernels could be done and they would filter through to
> distros automatically.
> 
> To use it we need to add a mkfs flag to the image builder.
> xfs_expand can be added to the boot time deploy scripts
> unconditionally because it is a no-op if the feature bit is not set
> on the image. The existing growfs post mount can remain because that
> is a no-op if expansion to max size has already been done. If it
> hasn't been expanded or growing is still required after expansion,
> then the existing growfs callout just does the right thing.
> 
> So when you look at the bigger picture, expansion slots into the
> existing image build/deploy pipelines in a backwards compatible way
> with minimal changes to those pipelines. It's a relatively simple
> tool that provides the mechanism, and it's relatively simple for
> cloud infrastructure developers to slot that mechanism into their
> pipelines.
> 
> It is the simplicity with which expansion fits into existing cloud
> infrastructures that makes it a compelling solution to the
> problem.
> 

Compared to the sequence above, you'd have the same sort of mkfs flag,
xfs_expand is not involved, and growfs works exactly as it does today.

I don't dispute the value of the expansion concept, particularly for the
additional flexibility and some of the other benefits you've brought up.
I am skeptical it is the most elegant solution for the basic cloud image
copy -> grow deployment use case though.

> > ISTM that the major caveats can be managed with some reasonable amount
> > of guardrails or policy enforcement. For example, if mkfs.xfs supported
> > an "image mode" param that specified a target/min deployment size, that
> > could be used as a hint to set the superblock AG size, a log size more
> > reflective of the eventual deployment size, and perhaps even facilitate
> > some usage limitations until that expected deployment occurs.
> > 
> > I.e., perhaps also set an "image mode" feature flag that requires a
> > corresponding mount option in order to mount writeable (to populate the
> > base image), and otherwise the fs mounts in a restricted-read mode where
> > grow is allowed, and grow only clears the image mode state once the fs
> > grows to at least 2 AGs (or whatever), etc. etc. At that point the user
> > doesn't have to know or care about any of the underlying geometry
> > details, just format and deploy as documented.
> >
> > That's certainly not perfect and I suspect we could probably come up
> > with a variety of different policy permutations or user interfaces to
> > consider, but ISTM there's real practical value to something like that.
> 
> These are more creative ideas, but there are a lot of conditionals
> like "perhaps", "maybe", "suspect", "just", "if", etc in the above
> comments. It is blue-sky thinking, not technical design review
> feedback I can actually make use of.
> 
> > > Maybe it wasn't obvious from my descriptions of the sparse address
> > > space diagrams, but single AG filesystems have no restrictions of AG
> > > size growth because there are no high bits set in any of the sparse
> > > 64 bit address spaces (i.e. fsbno or inode numbers). Hence we can
> > > expand the AG size without worrying about overwriting the address
> > > space used by higher AGs.
> > > 
> > > IOWs, the need for reserving sparse address space bits just doesn't
> > > exist for single AG filesystems.  The point of this proposal is to
> > > document a generic algorithm that avoids the problem of the higher
> > > AG address space limiting how large lower AGs can be made. That's
> > > the problem that prevents substantial resizing of AGs, and that's
> > > what this design document addresses.
> > > 
> > 
> > So in theory it sounds like you could also defer setting the final AG
> > size on a single AG fs at least until the first grow, right? If so, that
> > might be particularly useful for the typical one-shot
> > expansion/deployment use case. The mkfs could just set image mode and
> > single AG, and then the first major grow finalizes the ag size and
> > expands to a sane (i.e. multi AG) format.
> 
> Sure, we could do that, too. 
> 
> However, on top of everything else, we need to redesign the kernel
> growfs code to make AG sizing decisions. It needs to be able to
> work out things like alignment of AG headers for given filesystem
> functionality (e.g. stripe units, forced alignment for atomic
> writes, etc), etc instead of just replicating what the userspace mkfs
> logic decided at mkfs time.
> 
> Hence what seems like a simple addition to growfs gets much more
> complex the moment we look at what "growing the AG size" really
> means. It's these sorts of "how do we do that sanely in the kernel"
> issues that lead me to doing AG expansion offline in userspace
> because all the information to make these decisions correctly and
> then implement them efficiently already exists in xfsprogs.
> 

Yeah, that's a fair concern. That's an idea for an optional usability
enhancement, so it's not a show stopper if it just didn't work.

> > I guess that potentially makes log sizing a bit harder, but we've had
> > some discussion around online moving and resizing the log in the past as
> > well and IIRC it wasn't really that hard to achieve so long as we keep
> > the environment somewhat constrained by virtue of switching across a
> > quiesce, for example. I don't recall all the details though; I'd have to
> > see if I can dig up that conversation...
> 
> We addressed that problem a couple of years ago by making the log
> a minimum of 64MB in size.
> 
> commit 6e0ed3d19c54603f0f7d628ea04b550151d8a262
> Author: Darrick J. Wong <djwong@kernel.org>
> Date:   Thu Aug 4 21:27:01 2022 -0500
> 
>     mkfs: stop allowing tiny filesystems
> 
>     Refuse to format a filesystem that are "too small", because these
>     configurations are known to have performance and redundancy problems
>     that are not present on the volume sizes that XFS is best at handling.
> 
>     Specifically, this means that we won't allow logs smaller than 64MB, we
>     won't allow single-AG filesystems, and we won't allow volumes smaller
>     than 300MB.  There are two exceptions: the first is an undocumented CLI
>     option that can be used for crafting debug filesystems.
> 
>     The second exception is that if fstests is detected, because there are a
>     lot of fstests that use tiny filesystems to perform targeted regression
>     and functional testing in a controlled environment.  Fixing the ~40 or
>     so tests to run more slowly with larger filesystems isn't worth the risk
>     of breaking the tests.
> 
>     Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>     Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
>     Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> For the vast majority of applications, 64MB is large enough to run
> decently concurrent sustained metadata modification workloads at
> speeds within 10-15% of a maximally sized 2GB journal. This amount
> of performance is more than sufficient for most image based cloud
> deployments....
> 

Seems like that would make a reasonable default size for the cloud
deployment case then.

> > > > I think the difference between you and I here is that I see this
> > > > xfs_expand proposal as entirely a firstboot assistance program, whereas
> > > > you're looking at this more as a general operation that can happen at
> > > > any time.
> > > 
> > > Yes. As I've done for the past 15+ years, I'm thinking about the
> > > best solution for the wider XFS and storage community first and
> > > commercial imperatives second. I've seen people use XFS features and
> > > storage APIs for things I've never considered when designing them.
> > > I'm constantly surprised by how people use the functionality we
> > > provide in innovative, unexpected ways because they are generic
> > > enough to provide building blocks that people can use to implement
> > > new ideas.
> > > 
> > 
> > I think Darrick's agcount=1 proposal here is a nice example of that,
> > taking advantage of existing design flexibility to provide a creative
> > and elegantly simple solution to a real problem with minimal change and
> > risk.
> >
> > Again the concept obviously needs to be prototyped enough to establish
> > confidence that it can work, but I don't really see how this has to be
> > mutually exclusive from a generic and more flexible and robust expand
> > mechanism in the longer term.
> 
> I never said it was mutually exclusive nor that it is a bad idea.  I
> just don't think this potential new functionality is a relevant
> consideration when it comes to reviewing the design of an expansion
> tool.
> 

It was raised as a counterproposal for the problem/use case stated in
the doc.

> If we want to do image generation and expansion in a completely
> different way in future, then nothing in the xfs_expand proposal
> prevents that. Whoever wants this new functionality can spend the
> time to form these ideas into a solid proposal and write up the
> requirements and the high level design into a document we can
> review.
> 
> However, for the moment I need people to focus on the fundamental
> architectural change that the expansion tool relies on: breaking the
> AG size relationship between logical and physical addressing inside
> the filesystem. This is the design change that needs focussed
> review, not the expansion functionality that is built on top of it.
> 
> If this architectural change is solid, then it leads directly into
> variable sized AGs and, potentially, a simple offline shrink
> mechanism that works the opposite way to expansion.
> 

I think the doc could be improved to expand on those things, and maybe
less imply the expansion tool is solely intended to address the
problematic cloudy image growfs use case.

Brian

> IOWs, focussing on alternative ideas for image generation and
> filesystem growing completely misses the important underlying
> architectural change that expansion requires that I need reviewers
> to scrutinise closely.
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

