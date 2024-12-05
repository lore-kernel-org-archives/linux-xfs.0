Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0161B2192;
	Thu,  5 Dec 2024 07:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733384351; cv=none; b=V2CKoxBqtTzxpwuP0D4KzrjDOWoh/38cHPPSZ+qzXknT+FCXiM2oUZBESZ7o+cANzGJoH3rN/3JSZwlLVEga9zyuApJ8NMWIvHSVWOIoJeCEIIsA1jSUnnrBG07EXxDKHFSJ8OV9flbaj7Tv3WUkUswVwIAtaZ5qoLZzVzv7bkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733384351; c=relaxed/simple;
	bh=W0vsV76GQ9avyGC42PvizHxokJ+l1aCOuAd2OO3DhkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VuxpGhyXck7yDU3u/cyCwM83ArzdSGqcuK0DtBwOv3dNTsWEJAQPxghku+kM04KdZvh/xznEBp2R82LYLOfC5mq9eJ7+bQkBGZ7GqKdUGYqgQ/oqF4k5Ne2WUfwUXnraamnR3FkLU7tYQ/MLr57x7LcwN/m2ZONo12ZCSGAfsJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pyvzgMmA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pyvzgMmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D46C4CED1;
	Thu,  5 Dec 2024 07:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733384350;
	bh=W0vsV76GQ9avyGC42PvizHxokJ+l1aCOuAd2OO3DhkE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pyvzgMmA1VQRPAMRaHzig15iR6YHsODbdi7YLNlEigIqMQPiWN8zFU0/f5aeGnyaT
	 4TT4OICbP047NCObVK60MbGXKgy9nx2EaDIyjjWYND5a0RxAkK4rawXQ5YtNnp90P6
	 8CFDNADF5l7P2WjavxiH/CsgxcuSmL9Nq0JKIZqm0vKY3Q7s0hufKFBl1PPqNS0aaZ
	 z+sPsZmDIxMg0klrbXxVBp8il2V73IAIgJC18/uIIocADdL5596kmWcXNu2Ljs88xv
	 CuxmxXkYJtFi5svqMDmcjOKw5j4aICzLJK6oeeIuYMV4AgXKnqshK8F0YVqTkGGS59
	 4xQIr22TyziDQ==
Date: Wed, 4 Dec 2024 23:39:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	stable@vger.kernel.org, jlayton@kernel.org,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCHSET v2] xfs: proposed bug fixes for 6.13
Message-ID: <20241205073909.GI7837@frogsfrogsfrogs>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
 <Z1EBXqpMWGL306sh@redhat.com>
 <20241205064243.GD7837@frogsfrogsfrogs>
 <Z1FNqV27x5hjnqQ9@redhat.com>
 <Z1FPGXpTIJ1Fc2Xy@infradead.org>
 <Z1FQdYEXLR5BoOE-@redhat.com>
 <Z1FWojAndtCxEt-d@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1FWojAndtCxEt-d@redhat.com>

On Thu, Dec 05, 2024 at 01:30:42AM -0600, Bill O'Donnell wrote:
> On Thu, Dec 05, 2024 at 01:04:21AM -0600, Bill O'Donnell wrote:
> > On Wed, Dec 04, 2024 at 10:58:33PM -0800, Christoph Hellwig wrote:
> > > On Thu, Dec 05, 2024 at 12:52:25AM -0600, Bill O'Donnell wrote:
> > > > > 1) Our vaunted^Wshitty review process didn't catch various coding bugs,
> > > > > and testing didn't trip over them until I started (ab)using precommit
> > > > > hooks for spot checking of inode/dquot/buffer log items.
> > > > 
> > > > You give little time for the review process.
> > > 
> > > I don't really think that is true.  But if you feel you need more time
> > > please clearly ask for it.  I've done that in the past and most of the
> > > time the relevant people acted on it (not always).
> > > 
> > > > > 2) Most of the metadir/rtgroups fixes are for things that hch reworked
> > > > > towards the end of the six years the patchset has been under
> > > > > development, and that introduced bugs.  Did it make things easier for a
> > > > > second person to understand?  Yes.
> > > > 
> > > > No.
> > > 
> > > So you speak for other people here?
> > 
> > No. I speak for myself. A lowly downstream developer.
> > 
> scrub is the worst offender. What the hell is it, and why do you insist its imortance?

Online fsck, so you can check and repair metadata errors without needing
to incur downtime for xfs_repair.  This is information that was posted
in the design document review that was started in June 2022[1] and
merged in the kernel[2] last year before the code was merged.

[1] https://lore.kernel.org/linux-xfs/165456652256.167418.912764930038710353.stgit@magnolia/
[2] https://docs.kernel.org/filesystems/xfs/xfs-online-fsck-design.html

--D

> > > 
> > > > I call bullshit. You guys are fast and loose with your patches. Giving
> > > > little time for review and soaking.
> > > 
> > > I'm not sure who "you" is, but please say what is going wrong and what
> > > you'd like to do better.
> > 
> > You and Darrick. Can I be much clearer?
> > 
> > > 
> > > > > > becoming rather dodgy these days. Do things need to be this
> > > > > > complicated?
> > > > > 
> > > > > Yeah, they do.  We left behind the kindly old world where people didn't
> > > > > feed computers fuzzed datafiles and nobody got fired for a computer
> > > > > crashing periodically.  Nowadays it seems that everything has to be
> > > > > bulletproofed AND fast. :(
> > > > 
> > > > Cop-out answer.
> > > 
> > > What Darrick wrote feels a little snarky, but he has a very valid
> > > point.  A lot of recent bug fixes come from better test coverage, where
> > > better test coverage is mostly two new fuzzers hitting things, or
> > > people using existing code for different things that weren't tested
> > > much before.  And Darrick is single handedly responsible for a large
> > > part of the better test coverage, both due to fuzzing and specific
> > > xfstests.  As someone who's done a fair amount of new development
> > > recently I'm extremely glad about all this extra coverage.
> > > 
> > I think you are killing xfs with your fast and loose patches. Downstreamers
> > like me are having to clean up the mess you make of things.
> > 
> > 
> > > 
> > 
> > 
> 
> 
