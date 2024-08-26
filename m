Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1119186619
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 16:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724688445; cv=none; b=NpU9Pu0nIoZMcihLRKCmu8HlPzt/51eeQG290L8wG2Xc0+w5LuleEXEgjlqQ0bIYDErXYHJJjGuc7Z3vWnu99+dtGCmbf2oY8vkIGfgxfAS9sY5ZLqRIjChKzzgoX4Cr/P8138+8CAH+2PqVmwzpnGDI3P9v38i0tqb6G67CpFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724688445; c=relaxed/simple;
	bh=bNFliZ2efuinksxsBlFzQ6qtH1D65FOAxk5P3C1pPVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o4xSm5rp/ZLvWnHmYF5fkAa6eZqMpj3Itm4kz3/Kd/ColTDIFevHljaazBUjKeeaG/2wgnNMfi83oXhyKFXcjldmcaMhf2Qjtm5JWLIhcj7j3Mi2RMDIuInp3ch+a2vKzQiYFSiJLr/DpNWetXuM3ssq/ShfqO4IC2XzH4MkWEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N+Bl1/aw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N+Bl1/aw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724688442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E0FmvmGwQ6HWygdp0LPdAJQHOw+7V9tkwrozL1mQTu0=;
	b=N+Bl1/awREwISbOMSrJNhwVVfEdjKbV04zpCRjJjTq9pNbQAKM0zl6//5DQ7QpkWlMxvpv
	dwaQ6RSrVT7KLOgDbVIiNI2CikhdywrBQeqqlBZNFRIfzqUKxrgbT9VUYAKk9X5lw4eqQs
	slUdgZ1QSofGuTQu3fzvCYyx0GditIU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-241-NVuJRgHbM7yszvccNNEs7Q-1; Mon,
 26 Aug 2024 12:07:19 -0400
X-MC-Unique: NVuJRgHbM7yszvccNNEs7Q-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5DE8D1955BF6;
	Mon, 26 Aug 2024 16:07:18 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.22])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B09E1955DD8;
	Mon, 26 Aug 2024 16:07:17 +0000 (UTC)
Date: Mon, 26 Aug 2024 12:08:13 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net
Subject: Re: [RFD] xfsprogs/mkfs: prototype XFS image mode format for
 scalable AG growth
Message-ID: <Zsyobbqa_yMptsvy@bfoster>
References: <20240812135652.250798-1-bfoster@redhat.com>
 <20240823011502.GV6082@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823011502.GV6082@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Thu, Aug 22, 2024 at 06:15:02PM -0700, Darrick J. Wong wrote:
> On Mon, Aug 12, 2024 at 09:56:52AM -0400, Brian Foster wrote:
> > Tweak a few checks to facilitate experimentation with an agcount=1
> > filesystem format with a larger agsize than the filesystem data
> > size. The purpose of this is to POC a filesystem image mode format
> > for XFS that better supports the typical cloud filesystem image
> > deployment use case where a very small fs image is created and then
> > immediately grown orders of magnitude in size once deployed to
> > container environments. The large grow size delta produces
> > filesystems with excessive AG counts, which leads to various other
> > functional problems that eventually derive from this sort of
> > pathological geometry.
> > 
> > To experiment with this patch, format a small fs with something like
> > the following:
> > 
> >   mkfs.xfs -f -lsize=64m -dsize=512m,agcount=1,agsize=8g <imgfile>
> > 
> > Increase the underlying image file size, mount and grow. The
> > filesystem will grow according to the format time AG size as if the
> > AG was a typical runt AG on a traditional multi-AG fs.
> > 
> > This means that the filesystem remains with an AG count of 1 until
> > fs size grows beyond AG size. Since the typical deployment workflow
> > is an immediate very small -> very large, one-time grow, the image
> > fs can set a reasonable enough default or configurable AG size
> > (based on user input) that ensures deployed filesystems end up in a
> > generally supportable geometry (i.e. with multiple AGs for
> > superblock redundancy) before seeing production workloads.
> > 
> > Further optional changes are possible on the kernel side to help
> > provide some simple guardrails against misuse of this mechanism. For
> > example, the kernel could do anything from warn/fail or restrict
> > runtime functionality for an insufficient grow. The image mode
> > itself could set a backwards incompat feature bit that requires a
> > mount option to enable full functionality (with the exception of
> > growfs). More discussion is required to determine whether this
> > provides a usable solution for the common cloud workflows that
> > exhibit this problem and what the right interface and/or limitations
> > are to ensure it is used correctly.
> > 
> > Not-Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > Hi all,
> > 
> > This is a followup to the idea Darrick brought up in the expansion
> > discussion here [1]. I poked through the code a bit and found it
> > somewhat amusing how little was in the way of experimenting with this,
> > so threw this against an fstests run over the weekend. I see maybe
> > around ~10 or so test failures, most of which look like simple failures
> > related to either not expecting agcount == 1 fs' or my generally
> > hacky/experimental changes. There are a couple or so that require a bit
> > more investigation to properly characterize before I would consider this
> > fully sane.
> > 
> > I'm posting this separately from the expansion discussion to hopefully
> > avoid further conflating the two. My current sense is that if this turns
> > out to be a fundamentally workable approach, mkfs would more look
> > something like 'mkfs --image-size 40g ...' and the kernel side may grow
> > some optional guardrail logic mentioned above and in the previous
> > discussion here [2], but others might have different ideas.
> > 
> > Darrick, you originally raised this idea and then Eric brought up some
> > legitimate technical concerns in the expansion design thread. I'm
> > curious if either of you have any further thoughts/ideas on this.
> 
> Well, it /does/ seem to work as intended -- you can create a filesystem
> with a 100G agsize even on a 8G filesystem.  We've been over the
> drawbacks of this approach vs. Dave's (i.e. explodefs is really only a
> one-time event) so I won't rehash that here.
> 

Yeah.. I view this as kind of an incremental step in the broader
expandfs topic to opportunistically solve a real (and lingering) problem
with a minimal amount of complexity.

> But it does solve the much more constrained problem of disk images
> deployed from a gold master image undergoing a massive onetime expansion
> during firstboot.  The lack of secondary superblocks and xfs_repair
> warnings are concerning, but to that, I have these things to say:
> 
> a. If it's a gold master image from a trusted distributor, they should
> be installing verity information on all the read-mostly files so that
> one can validate the vendor's signatures.  The fs metadata being corrupt
> is moot if fsverity fails.
> 

This crossed my mind at one point as well. I thought these sort of image
repo setups at least had per-image checksum files or whatever that would
hopefully somewhat mitigate this sort of problem.

> b. We can turn off the xfs_repair hostility to single-AG filesystems
> so that people who /do/ want to fsck their goldmaster images don't get
> annoying warnings.  We /could/ add a new compat flag to say it's ok to
> single-AG, or we could hang that on the fsverity sb flag.
> 
> c. Over on our end, we know the minimum cloud boot volume size -- it's
> 47GB.  My canned OL9 image seems to come with a 36GB root filesystem.
> My guess is that most of our users will say yes to the instance creator
> asking them if they want more space (a princely 67GB minimum if you're
> stingy like I am!) so I think one could tweak the image creator to spit
> out a 36GB AG XFS, knowing that only the Ferengi users *won't* end up
> with a double-AG rootfs.
> 

Do you mean that the image size is 37GB, or it's grown to that size at
some point during the deployment? If the latter, any idea on the
ballpark size of a typical install image before it's deployed and grown?

> IOWs, this more or less works for the usecase that generates the most
> internal complaints about xfs sucking.  As I said earlier, I've not
> heard about people wanting to 10000x growfs after firstboot; usually
> they only grow incrementally as they decide that extra $$$$$ is worth
> another 10GB.
> 

This is my understanding as well.

> I think this is worth prototyping a bit more.  Do you?
> 

I do as well..

Eric and I had a random discussion about this the other week and one of
the concerns he brought up is the risk that some deployment might grow
and still end up on a single AG fs because maybe the deployment just
didn't provide sufficient storage as expected for the image. This was
part of the reason I brought up the whole image mode feature bit in the
expandfs discussion, because we could always do something to enforce
that fs functionality is hobbled until sufficiently grown to at least
2xAGs and thus clear the image mode feature bit.

That said, another thing I played around a bit with after posting this
was the ability to just grow the AG size at runtime. I.e., for a single
AG fs, it's fairly easy to just change the AG size at growfs time. I
currently have that prototyped by using a separate transaction to avoid
some verifier failure madness I didn't want to sift through to prove the
concept, but this could also be prototyped to exist as a separate,
optional GROWFS_AGSIZE ioctl without much additional fuss.

So for example, suppose that we just created an image file fs with
something like "mkfs.xfs -d agcount=1 -lsize=64m <file>," where the
superblock AG size is not actually larger than the single AG. Then we
update xfs_growfs to look at the current block device size, make a
decision on an ideal AG size from that, and run an ioctl(GROWFS_AGSIZE,
agsize) followed by the typical ioctl(GROWFS_DATA, bdev_size). The
GROWFS_AGSIZE can either update the sb ag size as appropriate before the
grow, or just fail and we fall back to default growfs behavior.

That would allow a bit more dynamic runtime behavior and maybe ensure we
end up with a more typical 4xAG fs in most cases. Dave had pointed out
that there might be concerns around AG sizing logic, but this would
exist in userspace and could be lifted straight from mkfs if need be.
TBH, on my first look it looked like it was mostly alignment (i.e.
stripe unit, etc.) related stuff, so I'd probably just punt and let
GROWFS_AGSIZE fail if any such unsupported fields are set. Worst case we
just fall back to existing behavior.

Thoughts on that? If that sounds interesting enough I can follow up with
a v2 prototype along those lines. Appreciate the discussion.

Brian

P.S. Semi-random thought after writing up the above.. it occurred to me
that we already have a provisional shrink mechanism, so in theory
perhaps we could also do something like "mkfs.xfs --image-mode <file>"
where we just hardcoded agcount=1,agsize=1TB, and then let userspace
grow shrink to the appropriate agsize in the delta < 0 && agsize >
fssize case and then grow out normally from there. Maybe that's just
another way of doing the same thing, but something else to think about
at least..

> --D
> 
> > Brian
> > 
> > [1] https://lore.kernel.org/linux-xfs/20240721230100.4159699-1-david@fromorbit.com/
> > [2] https://lore.kernel.org/linux-xfs/ZqzMay58f0SvdWxV@bfoster/
> > 
> >  mkfs/xfs_mkfs.c | 11 +++++------
> >  1 file changed, 5 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 6d2469c3c..50a874a03 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -325,8 +325,7 @@ static struct opt_params dopts = {
> >  	},
> >  	.subopt_params = {
> >  		{ .index = D_AGCOUNT,
> > -		  .conflicts = { { &dopts, D_AGSIZE },
> > -				 { &dopts, D_CONCURRENCY },
> > +		  .conflicts = { { &dopts, D_CONCURRENCY },
> >  				 { NULL, LAST_CONFLICT } },
> >  		  .minval = 1,
> >  		  .maxval = XFS_MAX_AGNUMBER,
> > @@ -368,8 +367,7 @@ static struct opt_params dopts = {
> >  		  .defaultval = SUBOPT_NEEDS_VAL,
> >  		},
> >  		{ .index = D_AGSIZE,
> > -		  .conflicts = { { &dopts, D_AGCOUNT },
> > -				 { &dopts, D_CONCURRENCY },
> > +		  .conflicts = { { &dopts, D_CONCURRENCY },
> >  				 { NULL, LAST_CONFLICT } },
> >  		  .convert = true,
> >  		  .minval = XFS_AG_MIN_BYTES,
> > @@ -1233,7 +1231,7 @@ validate_ag_geometry(
> >  		usage();
> >  	}
> >  
> > -	if (agsize > dblocks) {
> > +	if (agsize > dblocks && agcount != 1) {
> >  		fprintf(stderr,
> >  	_("agsize (%lld blocks) too big, data area is %lld blocks\n"),
> >  			(long long)agsize, (long long)dblocks);
> > @@ -2703,7 +2701,8 @@ validate_supported(
> >  	 * Filesystems should not have fewer than two AGs, because we need to
> >  	 * have redundant superblocks.
> >  	 */
> > -	if (mp->m_sb.sb_agcount < 2) {
> > +	if (mp->m_sb.sb_agcount < 2 &&
> > +	    mp->m_sb.sb_agblocks <= mp->m_sb.sb_dblocks) {
> >  		fprintf(stderr,
> >   _("Filesystem must have at least 2 superblocks for redundancy!\n"));
> >  		usage();
> > -- 
> > 2.45.0
> > 
> 

