Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA1A2D46B2;
	Fri, 17 Oct 2025 22:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760741215; cv=none; b=jfvWNZMEiVnKB+WthgXhbs2SrO4K3IlgMcWc43vXxLLG296c8YjIzh/BUK9XrMXoe0b8kBLq9L5+DjMvDEkcnUfZAAxWdaY41aJyAJplU0cI+rdYjfTsBX8Ipck4Gj3oDZZZwU/Eo2JlIrjd5uCfylzFdOKeuAca/4+qcV88rVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760741215; c=relaxed/simple;
	bh=YO8DzMDW26ohWy+lzK1i1ZZlv8Qwvd+okwGogpUlkHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GhiYmoEPDeXEu+g4UKSJR0Vgy7ubHLXs54VPouC101j5N/NZA08QqnrILN50UF7Pr8NEUNuzywQvKjyVKhfORX8ZydjgLLuvE7kCmYWTTb25cYvWQFh6PxNBMuJXb8DvCERkt/FeVCGcXAU7+BcKLDciIPi99HtgvEpsCfUHPBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pae1ZKs0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pae1ZKs0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B843C4CEE7;
	Fri, 17 Oct 2025 22:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760741214;
	bh=YO8DzMDW26ohWy+lzK1i1ZZlv8Qwvd+okwGogpUlkHo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pae1ZKs0WhVqN4MGCJ8+lgbDEDnNdLt30/Tdn1LMLpbZIreeN0ZkqSBoEdNLmBCvW
	 Jl8lWMc59LB4d2VSu8TJQcXEa9E5mcIjktwjyTC6nV4vM02Ca6Xgwowm8OftIMR/Je
	 hURhyktZHJTGkDfqLcsrBL4ApHkcyRfZzQM44g1SJPnsI4XLNnfzYx+DOxtSViBdK1
	 21SZLbeuZdofLS4v6ykX8STXYGSmy2M1TSEXApiQleHgj4z8soRJqcDvH0NBtD01yb
	 LRfC+xYQdacL2zMu+af7u3nr5tSgRJLQAq2oAiXZMn/5VEMw8urSsey6OpgElQ+ZrP
	 BnORx0xiI5o7Q==
Date: Fri, 17 Oct 2025 15:46:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: mkfs.xfs "concurrency" change concerns
Message-ID: <20251017224652.GJ6215@frogsfrogsfrogs>
References: <84c8a5e5-938d-4745-996d-4237009c9cc5@sandeen.net>
 <20251010191713.GE6188@frogsfrogsfrogs>
 <f7d5eaab-c2fe-4a11-82d5-a7c5ca563e75@sandeen.net>
 <20251014023228.GU6188@frogsfrogsfrogs>
 <f41be58e-071b-4179-a0e2-7fbbef1e534e@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f41be58e-071b-4179-a0e2-7fbbef1e534e@sandeen.net>

On Tue, Oct 14, 2025 at 10:36:14AM -0500, Eric Sandeen wrote:
> On 10/13/25 9:32 PM, Darrick J. Wong wrote:
> >> This was 6.17. The backing file get the nonrotational/concurrency treatment
> >> but the loop device does. This probably says more about the xfsprogs test
> >> (ddev_is_solidstate) than the kernel.
> >>
> >> ioctl(3, BLKROTATIONAL, 0x7ffd9d48f696) = -1 ENOTTY (Inappropriate ioctl for device)
> >>
> >> fails, so ddev_is_solidstate returns false. For the loop dev, BLKROTATIONAL
> >> says rotational == 0 so we get true for solidstate.
> >>
> >> But TBH this might be the right answer for mkfsing a file directly, as it is
> >> likely an image destined for another machine.
> >>
> >> Perhaps ddev_is_solidstate() should default to "not solidstate" for regular
> >> files /and/ loopback devices if possible?
> > It's *possible*, but why would mkfs ignore what the kernel tells us?
> 
> Because for one, it's not reliable or consistent. A loop device and its backing
> file are on the same storage, of course. We get different answers when we try to
> query one vs the other via the ioctl, currently.

The way I see things, I've told you how to turn off the ssd
optimizations for golden image creation.  You don't appear to like that
solution and would prefer some sort of heuristic based on stat::st_rdev.
I suggest you send a patch with your exact solution so that we can all
discuss on list.

--D

> And for two, the actual access patterns and behavior or writing to a loopback
> file aren't really the same as either flavor of block device any way, right?
> 
> > Suppose you're creating an image file on a filesystem sitting on a SSD
> > with the intent of deploying the image in a mostly non-rotational
> > environment.  Now those people don't get any of the SSD optimizations
> > even though the creator had an SSD
> 
> Now suppose you're creating it for deployment on rotating storage, instead.
> 
> My point is if the admin is making an image file, mkfs.xfs has absolutely
> no idea where that image will be deployed. The administrator might, and 
> could explicitly set parameters as needed based on that knowledge.
> 
> ...
> 
> >>> What I tell our internal customers is:
> >>>
> >>> 1. Defer formatting until deployment whenever possible so that mkfs can
> >>> optimize the filesystem for the storage and machine it actually gets.
> >>>
> >>> 2. If you can't do that, then try to make the image creator machine
> >>> match the deployment hardware as much as possible in terms of
> >>> rotationality and CPU count.
> 
> >> I just don't think that's practical in real life when you're creating a
> >> generic OS image for wide distribution into unknown environments.
> > Uhhh well I exist in real life too.
> 
> Of course...?
> 
> I read #2 as "make sure the system you run mkfs on has the same CPU count
> as any system you'll deploy that image on" and that's not possible for
> a generic image destined for wide deployment into varied environments.
> 
> rotationality is pretty trivial and is almost always "not rotational" so
> that's not really my major concern. My concern is how CPU count affects
> geometry now, by default, once nonrotationality has been determined.
> 
> For example if there's some fleet of machines used to produce
> an OS and its images, the images may vary depending on which build machine
> the image build task lands on unless they all have exactly the same CPU
> count. Or say you build for ppc64, aarch64, and x86_64. By default, you're
> almost guaranteed to get different fs geometry for each. I just think that's
> odd and unexpected. (I understand that it can be overridden but this is
> nothing anyone likely expects to be necessary.)
> 
> I agree that it makes sense to optimize for nonrotationality more than we
> have in the past, by default, for image files. I totally get your point about
> how 4 AGs is an optimization for the old world.
> 
> So I think my rambling boils down to a few things:
> 
> 1) mkfsing a file-backed image should be consistent whether you access
>    it through a loop device or you open the file directly. That's not
>    currently the case.
> 
> 2) When you are a mkfsing a file-backed image instead of a block device,
>    that's a big hint that the filesystem is destined for use on other
>    machines, about which mkfs.xfs knows nothing.
> 
> 3) To meet in the middle, rather than falling back to the old rotational
>    behavior of 4 AGs for image files, maybe a new image-file-specific
>    heuristic of "more AGs than before, but not scaled by local CPU count"
>    would be reasonable. This would make image file generation yield
>    consistent and repeatable geometries, by default.
> 
> -Eric
