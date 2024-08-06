Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A0C15E88
	for <linux-xfs@vger.kernel.org>; Tue,  6 Aug 2024 02:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722909719; cv=none; b=LhdfhHm5HQJsW3sHG1VYVWzJwoBNmtxfWhDQsGnTEFeoYPe3uBcTxcdi3ifU9PtOZF4FRfsFWfhu68TZz5x0IhpjjZ0KLWcbJwoFo42xLTflPMBDRc8B4kskAmxMJeHckYz0Kt3oHRqJ3hiO3mY8kWPViyTgfPpg0tpoL1ObIro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722909719; c=relaxed/simple;
	bh=RraXDWYZbKzYeH3LPlG09dtvRNywLMizTG9KJUiKCOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I7MGOqweO1a7HhM9w/usYdVwjQIeQbxKmHf+XcppFeWrzSbTWOgSeNQJmjVme7msK5vtVG5inbAlkH5PyBGQghukCgtHcL+2F/WFQ1u57lGOslGNx14OFwA8WW574naYurt2RcZX49/aWiRwuJyyCieUubIOZGNW4ZA3TqRY/kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=EdaeLKpl; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="EdaeLKpl"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-7afd1aeac83so4800026a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2024 19:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1722909716; x=1723514516; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1UpjjudR43ss4YDgAwlVXQA+atryIAL8LI4QIJZiWBM=;
        b=EdaeLKplAutp3BzHg3F5TLpbJWA3+LYQgT+vzncC/zPDbRlBpyXTMqex57anhY/uhG
         ovltxv1a8mhOoLXyYklZMHtvP1n4Uqi0nkqHJo13ughqsAzJAa6o1CGkmSKpIAkFK+xh
         PpuWDxXNN8UKItGq2UZ9X9zBHrseFqaeOvcB/RiAxQGq6/QI088AXgsvH5hTDt4ucj3H
         XbHZhElpQx9I35hmXAd3a+ukvMmWrks2ynnnFgZcsxsdmY5tdjZpIPyE/KuwyAQ55ncQ
         Aen6Hw6jOlQO98LQp3mtjnx2a4zC7unGUlb+wOyMvEpwAIvCV+GFmcq8KU9n0zxwKZHg
         Xkzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722909716; x=1723514516;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1UpjjudR43ss4YDgAwlVXQA+atryIAL8LI4QIJZiWBM=;
        b=G8zDa4u1C2Xvh+R+m97goLhbFu++5BrvSbBGlTrs3uyAhmtHPTIKenQ1arKtxLD3Gr
         YraXS8hm5ZsYIbHlZEcoYTZBTR0HJXhmV6vz4Qc76it+xwQmaIzEQJa0yJIoWzbx2v4F
         M3fyO7eRp7dzZ5OBUdK0Q9uOsj61+5VnEOJEsCSfkCxMAl7LAdaDkVrE2sFAvh2G//dQ
         yJM4Kzgh4XuDnKMCI/v8lZIPe8yVkGwYPUU925E7Lnyw/1QYwrhOovC/CPI/lSbtlzcA
         nfjqRSmp9NvSjvgBHoS1OVlXUktE5gV40RBAt8Q8PuDziMnH5542FA/Y90k6sJ5FINk7
         fE5g==
X-Forwarded-Encrypted: i=1; AJvYcCW+o7aWScudTKh5PCXA6lzvLWFNPHvncMlyr2FSVQ/Q2wYR/XfE2Em6T9JldGw2KtgN4SHadEdn53L1hMZ+jv6mrY7xJiUJ8Q83
X-Gm-Message-State: AOJu0Yxxks/ZCM7IR1U1IZAec2jnJlFPZaDAuJuxRQvnYf49DGuFNR4u
	O0l1Eh0xk0S6bYkp++ij/X98aheMXhP/+Vwzd8DzhIK5/PGvnfag26zqCT1bjLU=
X-Google-Smtp-Source: AGHT+IH35GDf5UFItxpMw2PhnISo4dZqqq/3AEaCmdN6cNSIYzyJHNjuuKtwyuZHHZ7vW1M81/tzqA==
X-Received: by 2002:a17:90a:4685:b0:2cb:5883:8fb0 with SMTP id 98e67ed59e1d1-2cff0b24ef8mr22925922a91.14.1722909716229;
        Mon, 05 Aug 2024 19:01:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cffb3901a8sm7841165a91.52.2024.08.05.19.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Aug 2024 19:01:55 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sb9WK-006r18-1M;
	Tue, 06 Aug 2024 12:01:52 +1000
Date: Tue, 6 Aug 2024 12:01:52 +1000
From: Dave Chinner <david@fromorbit.com>
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: filesystem expansion design documentation
Message-ID: <ZrGEECeOb7X3aS20@dread.disaster.area>
References: <20240721230100.4159699-1-david@fromorbit.com>
 <20240723235801.GU612460@frogsfrogsfrogs>
 <ZqBO177pPLbovguo@dread.disaster.area>
 <20240724210833.GZ612460@frogsfrogsfrogs>
 <ZqGfTvAEzFbfe+Wa@dread.disaster.area>
 <ZqzMay58f0SvdWxV@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqzMay58f0SvdWxV@bfoster>

On Fri, Aug 02, 2024 at 08:09:15AM -0400, Brian Foster wrote:
> On Thu, Jul 25, 2024 at 10:41:50AM +1000, Dave Chinner wrote:
> > On Wed, Jul 24, 2024 at 02:08:33PM -0700, Darrick J. Wong wrote:
> > > Counter-proposal: Instead of remapping the AGs to higher LBAs, what if
> > > we allowed people to create single-AG filesystems with large(ish)
> > > sb_agblocks.  You could then format a 2GB image with (say) a 100G AG
> > > size and copy your 2GB of data into the filesystem.  At deploy time,
> > > growfs will expand AG 0 to 100G and add new AGs after that, same as it
> > > does now.
> > 
> > We can already do this with existing tools.
> > 
> > All it requires is using xfs_db to rewrite the sb/ag geometry and
> > adding new freespace records. Now you have a 100GB AG instead of 2GB
> > and you can mount it and run growfs to add all the extra AGs you
> > need.
> > 
> 
> I'm not sure you have to do anything around adding new freespace records
> as such. If you format a small agcount=1 fs and then bump the sb agblock
> fields via xfs_db, then last I knew you could mount and run xfs_growfs
> according to the outsized AG size with no further changes at all. The
> grow will add the appropriate free space records as normal. I've not
> tried that with actually copying in data first, but otherwise it
> survives repair at least.

Yes, we could do it that way, too. It's just another existing
tool, but it requires the kernel to support an on-disk format
variant we have never previously supported.

> It would be interesting to see if that all still works with data present
> as long as you update the agblock fields before copying anything in. The
> presumption is that this operates mostly the same as extending an
> existing runt AG to a size that's still smaller than the full AG size,
> which obviously works today, just with the special circumstance that
> said runt AG happens to be the only AG in the fs.

Yes, exactly. Without significant effort to audit the code to ensure
this is safe I'm hesitant to say it'll actually work correctly. And
given that we can avoid such issues completely with a little bit of
xfs_db magic, the idea of having to support a weird one-off on
disk format variant forever just to allow growfs to do this One Neat
Trick doesn't seem like a good one to me.

> FWIW, Darrick's proposal here is pretty much exactly what I've thought
> XFS should have been at least considering doing to mitigate this cloudy
> deployment problem for quite some time. I agree with the caveats and
> limitations that Eric points out, but for a narrowly scoped cloudy
> deployment tool I have a hard time seeing how this wouldn't be anything
> but a significant improvement over the status quo for a relatively small
> amount of work (assuming it can be fully verified to work, of course ;).

I've considered it, too, and looked at what it means in the bigger
picture of the proliferation of cloud providers out there that have
their own image build/deploy implementations.

These cloud implementations would need all the client side
kernels and userspace to support this new way of deploying XFS
images. It will also need the orchestration software to buy into
this new XFS toolchain for image building and deployment. There are
a -lot- of moving parts to make this work, but it cannot replace the
existing build/deploy pipeling because clouds have to support older
distros/kernels that do stuff the current way.

That's one of the driving factors behind the expansion design - it
requires little in the way of changes to the build/deploy pipeline.
There are minimal kernel changes needed to support it, so backports
to LTS kernels could be done and they would filter through to
distros automatically.

To use it we need to add a mkfs flag to the image builder.
xfs_expand can be added to the boot time deploy scripts
unconditionally because it is a no-op if the feature bit is not set
on the image. The existing growfs post mount can remain because that
is a no-op if expansion to max size has already been done. If it
hasn't been expanded or growing is still required after expansion,
then the existing growfs callout just does the right thing.

So when you look at the bigger picture, expansion slots into the
existing image build/deploy pipelines in a backwards compatible way
with minimal changes to those pipelines. It's a relatively simple
tool that provides the mechanism, and it's relatively simple for
cloud infrastructure developers to slot that mechanism into their
pipelines.

It is the simplicity with which expansion fits into existing cloud
infrastructures that makes it a compelling solution to the
problem.

> ISTM that the major caveats can be managed with some reasonable amount
> of guardrails or policy enforcement. For example, if mkfs.xfs supported
> an "image mode" param that specified a target/min deployment size, that
> could be used as a hint to set the superblock AG size, a log size more
> reflective of the eventual deployment size, and perhaps even facilitate
> some usage limitations until that expected deployment occurs.
> 
> I.e., perhaps also set an "image mode" feature flag that requires a
> corresponding mount option in order to mount writeable (to populate the
> base image), and otherwise the fs mounts in a restricted-read mode where
> grow is allowed, and grow only clears the image mode state once the fs
> grows to at least 2 AGs (or whatever), etc. etc. At that point the user
> doesn't have to know or care about any of the underlying geometry
> details, just format and deploy as documented.
>
> That's certainly not perfect and I suspect we could probably come up
> with a variety of different policy permutations or user interfaces to
> consider, but ISTM there's real practical value to something like that.

These are more creative ideas, but there are a lot of conditionals
like "perhaps", "maybe", "suspect", "just", "if", etc in the above
comments. It is blue-sky thinking, not technical design review
feedback I can actually make use of.

> > Maybe it wasn't obvious from my descriptions of the sparse address
> > space diagrams, but single AG filesystems have no restrictions of AG
> > size growth because there are no high bits set in any of the sparse
> > 64 bit address spaces (i.e. fsbno or inode numbers). Hence we can
> > expand the AG size without worrying about overwriting the address
> > space used by higher AGs.
> > 
> > IOWs, the need for reserving sparse address space bits just doesn't
> > exist for single AG filesystems.  The point of this proposal is to
> > document a generic algorithm that avoids the problem of the higher
> > AG address space limiting how large lower AGs can be made. That's
> > the problem that prevents substantial resizing of AGs, and that's
> > what this design document addresses.
> > 
> 
> So in theory it sounds like you could also defer setting the final AG
> size on a single AG fs at least until the first grow, right? If so, that
> might be particularly useful for the typical one-shot
> expansion/deployment use case. The mkfs could just set image mode and
> single AG, and then the first major grow finalizes the ag size and
> expands to a sane (i.e. multi AG) format.

Sure, we could do that, too. 

However, on top of everything else, we need to redesign the kernel
growfs code to make AG sizing decisions. It needs to be able to
work out things like alignment of AG headers for given filesystem
functionality (e.g. stripe units, forced alignment for atomic
writes, etc), etc instead of just replicating what the userspace mkfs
logic decided at mkfs time.

Hence what seems like a simple addition to growfs gets much more
complex the moment we look at what "growing the AG size" really
means. It's these sorts of "how do we do that sanely in the kernel"
issues that lead me to doing AG expansion offline in userspace
because all the information to make these decisions correctly and
then implement them efficiently already exists in xfsprogs.

> I guess that potentially makes log sizing a bit harder, but we've had
> some discussion around online moving and resizing the log in the past as
> well and IIRC it wasn't really that hard to achieve so long as we keep
> the environment somewhat constrained by virtue of switching across a
> quiesce, for example. I don't recall all the details though; I'd have to
> see if I can dig up that conversation...

We addressed that problem a couple of years ago by making the log
a minimum of 64MB in size.

commit 6e0ed3d19c54603f0f7d628ea04b550151d8a262
Author: Darrick J. Wong <djwong@kernel.org>
Date:   Thu Aug 4 21:27:01 2022 -0500

    mkfs: stop allowing tiny filesystems

    Refuse to format a filesystem that are "too small", because these
    configurations are known to have performance and redundancy problems
    that are not present on the volume sizes that XFS is best at handling.

    Specifically, this means that we won't allow logs smaller than 64MB, we
    won't allow single-AG filesystems, and we won't allow volumes smaller
    than 300MB.  There are two exceptions: the first is an undocumented CLI
    option that can be used for crafting debug filesystems.

    The second exception is that if fstests is detected, because there are a
    lot of fstests that use tiny filesystems to perform targeted regression
    and functional testing in a controlled environment.  Fixing the ~40 or
    so tests to run more slowly with larger filesystems isn't worth the risk
    of breaking the tests.

    Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

For the vast majority of applications, 64MB is large enough to run
decently concurrent sustained metadata modification workloads at
speeds within 10-15% of a maximally sized 2GB journal. This amount
of performance is more than sufficient for most image based cloud
deployments....

> > > I think the difference between you and I here is that I see this
> > > xfs_expand proposal as entirely a firstboot assistance program, whereas
> > > you're looking at this more as a general operation that can happen at
> > > any time.
> > 
> > Yes. As I've done for the past 15+ years, I'm thinking about the
> > best solution for the wider XFS and storage community first and
> > commercial imperatives second. I've seen people use XFS features and
> > storage APIs for things I've never considered when designing them.
> > I'm constantly surprised by how people use the functionality we
> > provide in innovative, unexpected ways because they are generic
> > enough to provide building blocks that people can use to implement
> > new ideas.
> > 
> 
> I think Darrick's agcount=1 proposal here is a nice example of that,
> taking advantage of existing design flexibility to provide a creative
> and elegantly simple solution to a real problem with minimal change and
> risk.
>
> Again the concept obviously needs to be prototyped enough to establish
> confidence that it can work, but I don't really see how this has to be
> mutually exclusive from a generic and more flexible and robust expand
> mechanism in the longer term.

I never said it was mutually exclusive nor that it is a bad idea.  I
just don't think this potential new functionality is a relevant
consideration when it comes to reviewing the design of an expansion
tool.

If we want to do image generation and expansion in a completely
different way in future, then nothing in the xfs_expand proposal
prevents that. Whoever wants this new functionality can spend the
time to form these ideas into a solid proposal and write up the
requirements and the high level design into a document we can
review.

However, for the moment I need people to focus on the fundamental
architectural change that the expansion tool relies on: breaking the
AG size relationship between logical and physical addressing inside
the filesystem. This is the design change that needs focussed
review, not the expansion functionality that is built on top of it.

If this architectural change is solid, then it leads directly into
variable sized AGs and, potentially, a simple offline shrink
mechanism that works the opposite way to expansion.

IOWs, focussing on alternative ideas for image generation and
filesystem growing completely misses the important underlying
architectural change that expansion requires that I need reviewers
to scrutinise closely.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
