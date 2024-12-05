Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658941CDA1A;
	Thu,  5 Dec 2024 07:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733384004; cv=none; b=MSL9+CkxSR5mkS4jdKyFLvnV0VV7yRl8ZbwY9zx6xTAH/PBny/MTcNUJjI5PGxjzyN7WG1VgLQP9Fip14XiRJS++BV3K2776ZVdLmbXnZH39Ncm2lGYSHUDFwvLPmjld009L6trmtnyaQ9kMc6EFHyzij3QmIIqmevHXZtJtQI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733384004; c=relaxed/simple;
	bh=HxS/nkPAFuAjuB8ZGlmMi4h97q2g8J6nyu5SmuFmHAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oi0X3XPM5/ERGLYIme7Pn0ai1SqCiO9TQN4iNh4p9TvYy+MsSTHFhTRy0OZrVzwKECRsyxl7NdeCxhk1L+deSdp0iKm8YXDaP9BHk86QqWVvYL89fxC/hk7ud+qLZSYpg+V5+kSrTL7huT0AEQjvLH/RI0QPb597SIN1XnRPbBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kbyq0vc5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kbyq0vc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FCDC4CEE8;
	Thu,  5 Dec 2024 07:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733384002;
	bh=HxS/nkPAFuAjuB8ZGlmMi4h97q2g8J6nyu5SmuFmHAA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kbyq0vc5/16SCp5I1eMYruTYXVxycSgJJFJTkjVjGZOx30MDjsT0FeRQuvr5585Ms
	 36hlmGeakiBe8Ov/G/Hi/RMcl17R+T3Om2o6c+GhysaQ3dcGbYzE1MysmF+7UY/VgB
	 14tItgys6G7oa0Xk5YW1R7Uu60SMpv6YfiDGGVbgWWlhP5tKG/GzClc2zqBvwIUz8u
	 CbDLlFMW5/DqG3KA/+v3y8Slx/czDhVFnMnB4wztpQbVdinhsp5vLpEnzV1Qm33prJ
	 YaOI044DXYNJSq+MdVk0FHI05LBbH3/Rv2AWjthRA1RGK1pOA468eTwqDmHXUKSl51
	 tNTRmdUfxCGPA==
Date: Wed, 4 Dec 2024 23:33:21 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	stable@vger.kernel.org, jlayton@kernel.org,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCHSET v2] xfs: proposed bug fixes for 6.13
Message-ID: <20241205073321.GH7837@frogsfrogsfrogs>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
 <Z1EBXqpMWGL306sh@redhat.com>
 <20241205064243.GD7837@frogsfrogsfrogs>
 <Z1FNqV27x5hjnqQ9@redhat.com>
 <Z1FPGXpTIJ1Fc2Xy@infradead.org>
 <Z1FQdYEXLR5BoOE-@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1FQdYEXLR5BoOE-@redhat.com>

On Thu, Dec 05, 2024 at 01:04:21AM -0600, Bill O'Donnell wrote:
> On Wed, Dec 04, 2024 at 10:58:33PM -0800, Christoph Hellwig wrote:
> > On Thu, Dec 05, 2024 at 12:52:25AM -0600, Bill O'Donnell wrote:
> > > > 1) Our vaunted^Wshitty review process didn't catch various coding bugs,
> > > > and testing didn't trip over them until I started (ab)using precommit
> > > > hooks for spot checking of inode/dquot/buffer log items.
> > > 
> > > You give little time for the review process.

Seriously?!

Metadir has been out for review in some form or another since January
2019[1].  If five years and eleven months is not sufficient for you to
review a patchset or even to make enough noise that I'm aware that
you're even reading my code, then I don't want you ever to touch any of
my patchsets ever again.

> > I don't really think that is true.  But if you feel you need more time
> > please clearly ask for it.  I've done that in the past and most of the
> > time the relevant people acted on it (not always).
> > 
> > > > 2) Most of the metadir/rtgroups fixes are for things that hch reworked
> > > > towards the end of the six years the patchset has been under
> > > > development, and that introduced bugs.  Did it make things easier for a
> > > > second person to understand?  Yes.
> > > 
> > > No.
> > 
> > So you speak for other people here?
> 
> No. I speak for myself. A lowly downstream developer.
> 
> > 
> > > I call bullshit. You guys are fast and loose with your patches. Giving
> > > little time for review and soaking.
> > 
> > I'm not sure who "you" is, but please say what is going wrong and what
> > you'd like to do better.
> 
> You and Darrick. Can I be much clearer?
> 
> > 
> > > > > becoming rather dodgy these days. Do things need to be this
> > > > > complicated?
> > > > 
> > > > Yeah, they do.  We left behind the kindly old world where people didn't
> > > > feed computers fuzzed datafiles and nobody got fired for a computer
> > > > crashing periodically.  Nowadays it seems that everything has to be
> > > > bulletproofed AND fast. :(
> > > 
> > > Cop-out answer.
> > 
> > What Darrick wrote feels a little snarky, but he has a very valid
> > point.  A lot of recent bug fixes come from better test coverage, where
> > better test coverage is mostly two new fuzzers hitting things, or
> > people using existing code for different things that weren't tested
> > much before.  And Darrick is single handedly responsible for a large
> > part of the better test coverage, both due to fuzzing and specific
> > xfstests.  As someone who's done a fair amount of new development
> > recently I'm extremely glad about all this extra coverage.
> > 
> I think you are killing xfs with your fast and loose patches.

Go work on the maintenance mode filesystems like JFS then.  Shaggy would
probably love it if someone took on some of that.

> Downstreamers like me are having to clean up the mess you make of
> things.

What are you doing downstream these days, exactly?  You don't
participate in the LTS process at all, and your employer boasts about
ignoring that community process.  If your employer chooses to perform
independent forklift upgrades of the XFS codebase in its product every
three months and you don't like that, take it up with them, not
upstream.

--D

[1] https://lore.kernel.org/linux-xfs/154630934595.21716.17416691804044507782.stgit@magnolia/


> 
> > 
> 
> 
