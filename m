Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF461DE8AA
	for <linux-xfs@vger.kernel.org>; Tue,  8 Oct 2024 12:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392135; cv=none; b=efNXt3e6hTwlAWHqL7nbuhG/F0eGfiJ/I7suZd5xv4TDY9VlDzBfpz4OW+pBt69M3EkMCH+D7XQCUxfySkojeGrmFg2wSChE8442kK8zEfdRdNfO1ILjRRUZRXmU2U5lu1Dn6iJ94VDd6I7Jj62TTM5+LAZUnf+DwLA8sR6RRAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392135; c=relaxed/simple;
	bh=QVKkRb0npAAuTD3oV0hdf/lcYYP4X/yWHV7HSSNIsEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c+Ew+/o8ufgx3ajL/yJ7yNFBFjyTVWbKn8mS7ixomDTwIPdR1yHXfL7pxwZxIUhdy3RTcWz2DAWlDAiq4dZqCOd3FOM3H9rUUT+Dawa1u6Ut3M50BCkePwPUlDKWwoj1b68UDGiZmyzu0w08kjNoDbH0AkZs+vBpgGFxqedpu8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TnRvgMEW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TnRvgMEW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728392131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pMRURXFHKbug19LwE1PdGEx9fW3qCe6rX31RF90vzLw=;
	b=TnRvgMEWHeO8i1gNhGa6151D27dsXdfuLQlrmLykjil2EpK5Dc32CYK595c5VhfCtNEutR
	Cxv9Ez9z/LcFeyuVstaSpYzjt2ymQ5bUpFBohdF3k5M15WeNxrGpHGG/a6Ev7JVhx0Ov/Q
	bPvZCTrPYWCAvEo11oNq1Z9RQKMPiSE=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-245-t8fAM7vePWiWJeU609oKXg-1; Tue,
 08 Oct 2024 08:55:28 -0400
X-MC-Unique: t8fAM7vePWiWJeU609oKXg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 930B81955EE7;
	Tue,  8 Oct 2024 12:55:27 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.133])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B561319560A3;
	Tue,  8 Oct 2024 12:55:26 +0000 (UTC)
Date: Tue, 8 Oct 2024 08:56:42 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net
Subject: Re: [RFD] xfsprogs/mkfs: prototype XFS image mode format for
 scalable AG growth
Message-ID: <ZwUsCiBUc1t4NVhE@bfoster>
References: <20240812135652.250798-1-bfoster@redhat.com>
 <20240823011502.GV6082@frogsfrogsfrogs>
 <Zsyobbqa_yMptsvy@bfoster>
 <20240826211720.GF865349@frogsfrogsfrogs>
 <Zs3oXI_AHHBCa9oU@bfoster>
 <20240827210023.GC1977952@frogsfrogsfrogs>
 <Zs8sCYRzy6cUWgAJ@bfoster>
 <20240917184226.GJ182194@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240917184226.GJ182194@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Sep 17, 2024 at 11:42:26AM -0700, Darrick J. Wong wrote:
> On Wed, Aug 28, 2024 at 09:54:17AM -0400, Brian Foster wrote:
> > On Tue, Aug 27, 2024 at 02:00:23PM -0700, Darrick J. Wong wrote:
> > > On Tue, Aug 27, 2024 at 10:53:16AM -0400, Brian Foster wrote:
> > > > On Mon, Aug 26, 2024 at 02:17:20PM -0700, Darrick J. Wong wrote:
> > > > > On Mon, Aug 26, 2024 at 12:08:13PM -0400, Brian Foster wrote:
> > > > > > On Thu, Aug 22, 2024 at 06:15:02PM -0700, Darrick J. Wong wrote:
> > > > > > > On Mon, Aug 12, 2024 at 09:56:52AM -0400, Brian Foster wrote:
> > > > > > > > Tweak a few checks to facilitate experimentation with an agcount=1
> > > > > > > > filesystem format with a larger agsize than the filesystem data
> > > > > > > > size. The purpose of this is to POC a filesystem image mode format
> > > > > > > > for XFS that better supports the typical cloud filesystem image
> > > > > > > > deployment use case where a very small fs image is created and then
> > > > > > > > immediately grown orders of magnitude in size once deployed to
> > > > > > > > container environments. The large grow size delta produces
> > > > > > > > filesystems with excessive AG counts, which leads to various other
> > > > > > > > functional problems that eventually derive from this sort of
> > > > > > > > pathological geometry.
> > > > > > > > 
> > > > > > > > To experiment with this patch, format a small fs with something like
> > > > > > > > the following:
> > > > > > > > 
> > > > > > > >   mkfs.xfs -f -lsize=64m -dsize=512m,agcount=1,agsize=8g <imgfile>
> > > > > > > > 
> > > > > > > > Increase the underlying image file size, mount and grow. The
> > > > > > > > filesystem will grow according to the format time AG size as if the
> > > > > > > > AG was a typical runt AG on a traditional multi-AG fs.
> > > > > > > > 
> > > > > > > > This means that the filesystem remains with an AG count of 1 until
> > > > > > > > fs size grows beyond AG size. Since the typical deployment workflow
> > > > > > > > is an immediate very small -> very large, one-time grow, the image
> > > > > > > > fs can set a reasonable enough default or configurable AG size
> > > > > > > > (based on user input) that ensures deployed filesystems end up in a
> > > > > > > > generally supportable geometry (i.e. with multiple AGs for
> > > > > > > > superblock redundancy) before seeing production workloads.
> > > > > > > > 
> > > > > > > > Further optional changes are possible on the kernel side to help
> > > > > > > > provide some simple guardrails against misuse of this mechanism. For
> > > > > > > > example, the kernel could do anything from warn/fail or restrict
> > > > > > > > runtime functionality for an insufficient grow. The image mode
> > > > > > > > itself could set a backwards incompat feature bit that requires a
> > > > > > > > mount option to enable full functionality (with the exception of
> > > > > > > > growfs). More discussion is required to determine whether this
> > > > > > > > provides a usable solution for the common cloud workflows that
> > > > > > > > exhibit this problem and what the right interface and/or limitations
> > > > > > > > are to ensure it is used correctly.
> > > > > > > > 
> > > > > > > > Not-Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > > > > > ---
> > > > > > > > 
> > > > > > > > Hi all,
> > > > > > > > 
> > > > > > > > This is a followup to the idea Darrick brought up in the expansion
> > > > > > > > discussion here [1]. I poked through the code a bit and found it
> > > > > > > > somewhat amusing how little was in the way of experimenting with this,
> > > > > > > > so threw this against an fstests run over the weekend. I see maybe
> > > > > > > > around ~10 or so test failures, most of which look like simple failures
> > > > > > > > related to either not expecting agcount == 1 fs' or my generally
> > > > > > > > hacky/experimental changes. There are a couple or so that require a bit
> > > > > > > > more investigation to properly characterize before I would consider this
> > > > > > > > fully sane.
> > > > > > > > 
> > > > > > > > I'm posting this separately from the expansion discussion to hopefully
> > > > > > > > avoid further conflating the two. My current sense is that if this turns
> > > > > > > > out to be a fundamentally workable approach, mkfs would more look
> > > > > > > > something like 'mkfs --image-size 40g ...' and the kernel side may grow
> > > > > > > > some optional guardrail logic mentioned above and in the previous
> > > > > > > > discussion here [2], but others might have different ideas.
> > > > > > > > 
> > > > > > > > Darrick, you originally raised this idea and then Eric brought up some
> > > > > > > > legitimate technical concerns in the expansion design thread. I'm
> > > > > > > > curious if either of you have any further thoughts/ideas on this.
> > > > > > > 
> > > > > > > Well, it /does/ seem to work as intended -- you can create a filesystem
> > > > > > > with a 100G agsize even on a 8G filesystem.  We've been over the
> > > > > > > drawbacks of this approach vs. Dave's (i.e. explodefs is really only a
> > > > > > > one-time event) so I won't rehash that here.
> > > > > > > 
> > > > > > 
> > > > > > Yeah.. I view this as kind of an incremental step in the broader
> > > > > > expandfs topic to opportunistically solve a real (and lingering) problem
> > > > > > with a minimal amount of complexity.
> > > > > > 
> > > > > > > But it does solve the much more constrained problem of disk images
> > > > > > > deployed from a gold master image undergoing a massive onetime expansion
> > > > > > > during firstboot.  The lack of secondary superblocks and xfs_repair
> > > > > > > warnings are concerning, but to that, I have these things to say:
> > > > > > > 
> > > > > > > a. If it's a gold master image from a trusted distributor, they should
> > > > > > > be installing verity information on all the read-mostly files so that
> > > > > > > one can validate the vendor's signatures.  The fs metadata being corrupt
> > > > > > > is moot if fsverity fails.
> > > > > > > 
> > > > > > 
> > > > > > This crossed my mind at one point as well. I thought these sort of image
> > > > > > repo setups at least had per-image checksum files or whatever that would
> > > > > > hopefully somewhat mitigate this sort of problem.
> > > > > > 
> > > > > > > b. We can turn off the xfs_repair hostility to single-AG filesystems
> > > > > > > so that people who /do/ want to fsck their goldmaster images don't get
> > > > > > > annoying warnings.  We /could/ add a new compat flag to say it's ok to
> > > > > > > single-AG, or we could hang that on the fsverity sb flag.
> > > > > > > 
> > > > > > > c. Over on our end, we know the minimum cloud boot volume size -- it's
> > > > > > > 47GB.  My canned OL9 image seems to come with a 36GB root filesystem.
> > > > > > > My guess is that most of our users will say yes to the instance creator
> > > > > > > asking them if they want more space (a princely 67GB minimum if you're
> > > > > > > stingy like I am!) so I think one could tweak the image creator to spit
> > > > > > > out a 36GB AG XFS, knowing that only the Ferengi users *won't* end up
> > > > > > > with a double-AG rootfs.
> > > > > > > 
> > > > > > 
> > > > > > Do you mean that the image size is 37GB, or it's grown to that size at
> > > > > > some point during the deployment? If the latter, any idea on the
> > > > > > ballpark size of a typical install image before it's deployed and grown?
> > > > > 
> > > > > I think the actual gold master images have ~37G root filesystems.  I
> > > > > didn't choose to expand my stingy OL8 image at firstboot, and it has 4
> > > > > AGs like you'd expect.  Most of the time the deployment control panel
> > > > > tries to convince you to upgrade to 67G, if not ~200G.
> > > > > 
> > > > 
> > > > Interesting, that seems notably larger than I'd expect. Wouldn't this
> > > > concern you if you just ended up with a 37GB single AG fs?
> > > 
> > > Not that much if I had fsverity to ensure that the deployed files hadn't
> > > been tampered with.
> > > 
> > 
> > Well that covers the deployment part, but personally for anything more
> > than a scratch/test vm I'd be a little worried about repairability and
> > not having enough redundancy and whatnot for ongoing usage.
> 
> <nod> Going all in on single-AG filesystems would likely create problems
> with old(er) versions of xfs_repair not liking the lack of redundancy.
> I concede that we shouldn't be doing that generally...
> 

That might be reason enough for a feature bit. I've been waffling on the
idea personally just because I'm a little concerned the existence of it
might lead to overengineering of what ends up tied to it, but really if
it existed for the mere purpose of backwards compatibility and letting
newer ones spit out a warning for "absent or insufficient grow"
situations, that seems pretty reasonable to me.

That said, I do think it's only really useful for the approach where
we'd rely on growfs to fix up the fs before it should be used in
production. If we ended up just changing mkfs to enforce larger AGs or
whatever then it seems unnecessary IMO.

> > > > Do you know how much of that might be free space on the image side?
> > > 
> > > $ xfs_info /
> > > meta-data=/dev/mapper/ocivolume-root isize=512    agcount=4, agsize=2324736 blks
> > >          =                       sectsz=4096  attr=2, projid32bit=1
> > >          =                       crc=1        finobt=1, sparse=1, rmapbt=0
> > >          =                       reflink=1
> > > data     =                       bsize=4096   blocks=9298944, imaxpct=25
> > >          =                       sunit=0      swidth=0 blks
> > > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > > log      =internal log           bsize=4096   blocks=4540, version=2
> > >          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> > > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > > $ df /
> > > Filesystem                 1K-blocks     Used Available Use% Mounted on
> > > /dev/mapper/ocivolume-root  37177616 14264712  22912904  39% /
> > > 
> > > So I think the 9G AGs aren't that much of a problem.  OTOH 
> > > 
> > 
> > Yeah.. so even if this weren't formatted as a larger sparse image, say
> > the image file size were reduced to 15G or so, even something like a
> > 2xAG w/ 10GB agsize seems plausible as an initial format. That doesn't
> > require any growing tricks at all, and even if it never grows and
> > performance is not a huge concern, you at least have some basic
> > superblock redundancy.
> 
> ...to continue my line of thought above, what do you think about runt
> AGs?  If say the gold master image has a 36G / partition, what if
> instead of formatting 2x18G AGs, we instead format a 35G AG0 and a 1G
> AG0?  That way we always have two superblocks, and in the common case
> the runt won't stay a runt for long.
> 

Definitely seems like a reasonable mkfs time approach to me.

I'm going to post a prototype of the dynamic AG size grow thing shortly.
The heuristic I hacked in for that is basically to try for 4xAGs or
otherwise set a minimum AG size of 4GB. IOW, a tiny fs that sees small,
incremental grows would come out of single AG mode as soon as the fs
size crosses 4GB plus the minimum number of blocks for a runt second AG.

Note that I'm not convinced any user would actually do such a thing with
cloud fs images, so this is more just trying to be robust and cover the
unexpected use cases than anything else. The larger point though is I
don't see why mkfs couldn't do something similar with a runt AG if we
wanted to go that route.

> > That raises yet another thought.. I wonder if we could incrementally
> > improve things by say just modernizing some of the format time
> > heuristics for image files. I.e., if we see we're formatting a regular
> > file in the tens of GBs in size, perhaps having a 2xAG minimum with a
> > larger agsize is more appropriate than the typical 4xAG geometry we'd
> > otherwise use on a 20GB hard drive from 25+ years ago.
> 
> Yeah.  Especially since these days the cloud rootfs storage is rather
> ssdlike.
> 
> > Even if that custom heuristic were buried behind a 'mkfs.xfs --cloud
> > ...' param, that would at the very least give us something to evangelize
> > to users as these "why does my 3TB 128MB agsize fs suck?" reports
> > continue to come in..
> 
> Yes!
> 
> > > > I.e., I'm wondering if the size is that large because you really need
> > > > the space for data, or rather as a workaround where it could otherwise
> > > > be formatted much smaller if the deployment side could grow it out to
> > > > well beyond 37GB without having issues.
> > > 
> > > It depends on the workload -- vanilla OL images only give you a rootfs
> > > and assume that you'll create a separate higher iops block volume for
> > > actual data storage.  $database automates provisioning and autotuning
> > > the separate block device for you.
> > > 
> > 
> > Right.. so I assume these filesystems can be sized appropriately from
> > the start.
> 
> <nod>
> 
> > > Another problem is that we don't necessarily know how many CPUs the
> > > system will have.  I've seen a system with ~200 cores all pounding on a
> > > fs with four AGs (oops!  lots of AGF contention!) or 10000 AGs (all cpus
> > > pounding on the radix tree).
> > > 
> > 
> > Indeed.
> > 
> > > IOWs, the deploy image could be a lot smaller, but apparently they're
> > > 48GB in size.  My guess is that these are sparse images, since the
> > > billable size is about a tenth of that.
> > > 
> > > > With a 37GB 4xAG fs, that's still closer to ~9GB AGs, which doesn't seem
> > > > all that bad from a grow perspective. IIRC the insane filesystems I've
> > > > seen tend to have much smaller (< 1GB maybe?) AG sizes. Have you seen
> > > > grow issues with these ~9GB AG size fs'?
> > > 
> > > Not on our homegrown images.  The problems crop up when people try to
> > > import images from outside $cloud and generate those minified images
> > > with 1G AGs.  Unfortunately some of those people aren't even outside the
> > > org, but I'll get to them... ;)
> > > 
> > 
> > Ok. This is the part that is still somewhat mysterious to me.
> 
> Yeah, the outside image thing is mysterious to us as well.  Customers
> make those images, so we need sane(ish) defaults, or some serious
> evangelization of the --cloud option.
> 

Hm yeah. One of the things I've discussed with Eric a bit is how all
over the place and unknown the use cases seem to be. I actually think
there's benefit in just doing something simple with an abstracted mkfs
param because if whatever initial heuristic we come up with isn't the
best, it won't be any worse than current default behavior and we at
least start to get some feedback and can iterate on it.

> > Given what we know about your internal images and how they are sized and
> > whatnot, and expanding on the whole mkfs.xfs --cloud thought a bit, I'm
> > wondering if we could just use something like that to enforce a minimum
> > image size as well.
> > 
> > IOW, suppose 'mkfs.xfs --cloud ...' imposed a 20GB minimum file size and
> > 10GB minimum AG size, documented that this is required for sane
> > growability, and explained that the additional metadata over a 3GB image
> > or whatever is mostly noise given sparse file image formats... do we
> > think that would be sufficient to mostly avoid the problem? Would users
> > adopt it if beat over the head enough with it when reporting problems
> > with these ridiculous agcount filesystems? Hm?
> 
> I'd argue for a min sparse cloud image file size of 32G, and maybe even
> the one-and-runt AG setup above.  But otherwise this sounds ok to me.
> 

Sure, I've no strong opinion on the size limit.. Another thing Eric
brought up that I'm not sure about with the whole "min file size" idea
is whether any cloud environments would have issues with larger images
because sparse files aren't handled efficiently enough by their infra,
for whatever reason.

That seems like something that's easy enough to address with compression
and such, but practicality doesn't always line up with theory and if
that's not something that's tied well enough into the cloudy management
infrastructure such that admins just don't use it, then that kind of
defeats the purpose. I'm really not sure either way.. :/

Anyways, to be continued.. I'm curious on any thoughts you and others
might have on the prototype.

Brian

> > > > > > > IOWs, this more or less works for the usecase that generates the most
> > > > > > > internal complaints about xfs sucking.  As I said earlier, I've not
> > > > > > > heard about people wanting to 10000x growfs after firstboot; usually
> > > > > > > they only grow incrementally as they decide that extra $$$$$ is worth
> > > > > > > another 10GB.
> > > > > > > 
> > > > > > 
> > > > > > This is my understanding as well.
> > > > > > 
> > > > > > > I think this is worth prototyping a bit more.  Do you?
> > > > > > > 
> > > > > > 
> > > > > > I do as well..
> > > > > > 
> > > > > > Eric and I had a random discussion about this the other week and one of
> > > > > > the concerns he brought up is the risk that some deployment might grow
> > > > > > and still end up on a single AG fs because maybe the deployment just
> > > > > > didn't provide sufficient storage as expected for the image. This was
> > > > > > part of the reason I brought up the whole image mode feature bit in the
> > > > > > expandfs discussion, because we could always do something to enforce
> > > > > > that fs functionality is hobbled until sufficiently grown to at least
> > > > > > 2xAGs and thus clear the image mode feature bit.
> > > > > > 
> > > > > > That said, another thing I played around a bit with after posting this
> > > > > > was the ability to just grow the AG size at runtime. I.e., for a single
> > > > > > AG fs, it's fairly easy to just change the AG size at growfs time. I
> > > > > > currently have that prototyped by using a separate transaction to avoid
> > > > > > some verifier failure madness I didn't want to sift through to prove the
> > > > > > concept, but this could also be prototyped to exist as a separate,
> > > > > > optional GROWFS_AGSIZE ioctl without much additional fuss.
> > > > > 
> > > > > What if we rev the growfsdata ioctl to allow the user to specify an
> > > > > agsize?  Userspace (i.e. xfs_growfs) can then try to set the AG size, or
> > > > > if that fails, fall back to the current growfsdata.
> > > > > 
> > > > 
> > > > Either way seems reasonable. I think we're mostly talking about the same
> > > > thing. For a functional prototype I'd be more concerned with just
> > > > showing whether it works and then if so, whether it's useful/flexible
> > > > enough for the intended use cases.
> > > 
> > > Agreed!
> > > 
> > 
> > Ok. It's on my todo list to clean up what I've hacked up wrt the whole
> > grow agsize idea enough so it can be at least put on the list for
> > discussion/posterity.. thanks.
> 
> NP.
> 
> --D
> 
> > Brian
> > 
> > > > Brian
> > > > 
> > > > > > So for example, suppose that we just created an image file fs with
> > > > > > something like "mkfs.xfs -d agcount=1 -lsize=64m <file>," where the
> > > > > > superblock AG size is not actually larger than the single AG. Then we
> > > > > > update xfs_growfs to look at the current block device size, make a
> > > > > > decision on an ideal AG size from that, and run an ioctl(GROWFS_AGSIZE,
> > > > > > agsize) followed by the typical ioctl(GROWFS_DATA, bdev_size). The
> > > > > > GROWFS_AGSIZE can either update the sb ag size as appropriate before the
> > > > > > grow, or just fail and we fall back to default growfs behavior.
> > > > > > 
> > > > > > That would allow a bit more dynamic runtime behavior and maybe ensure we
> > > > > > end up with a more typical 4xAG fs in most cases. Dave had pointed out
> > > > > > that there might be concerns around AG sizing logic, but this would
> > > > > > exist in userspace and could be lifted straight from mkfs if need be.
> > > > > > TBH, on my first look it looked like it was mostly alignment (i.e.
> > > > > > stripe unit, etc.) related stuff, so I'd probably just punt and let
> > > > > > GROWFS_AGSIZE fail if any such unsupported fields are set. Worst case we
> > > > > > just fall back to existing behavior.
> > > > > 
> > > > > I wouldn't have a problem with hoisting that to libxfs and sharing with
> > > > > the kernel.
> > > > > 
> > > > > > Thoughts on that? If that sounds interesting enough I can follow up with
> > > > > > a v2 prototype along those lines. Appreciate the discussion.
> > > > > > 
> > > > > > Brian
> > > > > > 
> > > > > > P.S. Semi-random thought after writing up the above.. it occurred to me
> > > > > > that we already have a provisional shrink mechanism, so in theory
> > > > > > perhaps we could also do something like "mkfs.xfs --image-mode <file>"
> > > > > > where we just hardcoded agcount=1,agsize=1TB, and then let userspace
> > > > > > grow shrink to the appropriate agsize in the delta < 0 && agsize >
> > > > > > fssize case and then grow out normally from there. Maybe that's just
> > > > > > another way of doing the same thing, but something else to think about
> > > > > > at least..
> > > > > 
> > > > > <shrug> I'd rather do the ag resizing explicitly than implied if someone
> > > > > says to shrink (or grow) and the agcount is zero and magic compat flag
> > > > > is set.
> > > > > 
> > > > > --D
> > > > > 
> > > > > > 
> > > > > > > --D
> > > > > > > 
> > > > > > > > Brian
> > > > > > > > 
> > > > > > > > [1] https://lore.kernel.org/linux-xfs/20240721230100.4159699-1-david@fromorbit.com/
> > > > > > > > [2] https://lore.kernel.org/linux-xfs/ZqzMay58f0SvdWxV@bfoster/
> > > > > > > > 
> > > > > > > >  mkfs/xfs_mkfs.c | 11 +++++------
> > > > > > > >  1 file changed, 5 insertions(+), 6 deletions(-)
> > > > > > > > 
> > > > > > > > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > > > > > > > index 6d2469c3c..50a874a03 100644
> > > > > > > > --- a/mkfs/xfs_mkfs.c
> > > > > > > > +++ b/mkfs/xfs_mkfs.c
> > > > > > > > @@ -325,8 +325,7 @@ static struct opt_params dopts = {
> > > > > > > >  	},
> > > > > > > >  	.subopt_params = {
> > > > > > > >  		{ .index = D_AGCOUNT,
> > > > > > > > -		  .conflicts = { { &dopts, D_AGSIZE },
> > > > > > > > -				 { &dopts, D_CONCURRENCY },
> > > > > > > > +		  .conflicts = { { &dopts, D_CONCURRENCY },
> > > > > > > >  				 { NULL, LAST_CONFLICT } },
> > > > > > > >  		  .minval = 1,
> > > > > > > >  		  .maxval = XFS_MAX_AGNUMBER,
> > > > > > > > @@ -368,8 +367,7 @@ static struct opt_params dopts = {
> > > > > > > >  		  .defaultval = SUBOPT_NEEDS_VAL,
> > > > > > > >  		},
> > > > > > > >  		{ .index = D_AGSIZE,
> > > > > > > > -		  .conflicts = { { &dopts, D_AGCOUNT },
> > > > > > > > -				 { &dopts, D_CONCURRENCY },
> > > > > > > > +		  .conflicts = { { &dopts, D_CONCURRENCY },
> > > > > > > >  				 { NULL, LAST_CONFLICT } },
> > > > > > > >  		  .convert = true,
> > > > > > > >  		  .minval = XFS_AG_MIN_BYTES,
> > > > > > > > @@ -1233,7 +1231,7 @@ validate_ag_geometry(
> > > > > > > >  		usage();
> > > > > > > >  	}
> > > > > > > >  
> > > > > > > > -	if (agsize > dblocks) {
> > > > > > > > +	if (agsize > dblocks && agcount != 1) {
> > > > > > > >  		fprintf(stderr,
> > > > > > > >  	_("agsize (%lld blocks) too big, data area is %lld blocks\n"),
> > > > > > > >  			(long long)agsize, (long long)dblocks);
> > > > > > > > @@ -2703,7 +2701,8 @@ validate_supported(
> > > > > > > >  	 * Filesystems should not have fewer than two AGs, because we need to
> > > > > > > >  	 * have redundant superblocks.
> > > > > > > >  	 */
> > > > > > > > -	if (mp->m_sb.sb_agcount < 2) {
> > > > > > > > +	if (mp->m_sb.sb_agcount < 2 &&
> > > > > > > > +	    mp->m_sb.sb_agblocks <= mp->m_sb.sb_dblocks) {
> > > > > > > >  		fprintf(stderr,
> > > > > > > >   _("Filesystem must have at least 2 superblocks for redundancy!\n"));
> > > > > > > >  		usage();
> > > > > > > > -- 
> > > > > > > > 2.45.0
> > > > > > > > 
> > > > > > > 
> > > > > > 
> > > > > > 
> > > > > 
> > > > 
> > > > 
> > > 
> > 
> > 
> 

