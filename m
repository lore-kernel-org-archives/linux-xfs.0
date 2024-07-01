Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10B62F29
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jul 2024 23:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719877070; cv=none; b=EInMeqeX+N/HLk9CN1Lbm+GkuUuoYnZXUgt0MJgWbDNejWm3jBrcqlf91bT3oEurkIeqzk84oWPbuYhE/ORepK+BpX9H/SRH2L+st46zSX5sq7f7RLY4pWFDCkz2mctHI1yPyeTpPKp6hoseISUlEnXYcmk/EcSfHZi1/7yUGd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719877070; c=relaxed/simple;
	bh=7He6HTyS2IrRQ4w/F6K49rMGqQNJshY5m+mOTu8FOEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GLR0owhZfSB96lrvJ+XsRS7B7o4JmQekFV0RCguolkXAkageJg04V+cecyQ+K7buPrftCk3h6esfnDH0pcPwS8EuuLL/sMslKiO3oDFFBzGITK5xEbFoqG/iRY1Bx/M/Iq0d3OLxOsHhL5z1tdFcUjtPRDNYlFzrNSOJI8oreTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nBvhdQ1Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nBvhdQ1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFC8C116B1;
	Mon,  1 Jul 2024 23:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719877070;
	bh=7He6HTyS2IrRQ4w/F6K49rMGqQNJshY5m+mOTu8FOEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nBvhdQ1Z6EA3O+ech6QP7JnaCXw/NL/HbeWCK5YZm9eylXq9ukUd28Ez+klPksMlc
	 lufpbROQRm9nIiliTr1DX6BDo2qgiqGH92c8sutRU/5o6ehx9QPs0qX4Hu4mpVLNxq
	 oaKQh7FiZQ3EEZK8Lk6bxYG62kV5MC9W9hxVAmjoSlu9dzfLPiZ81U0z6UR4MQ7v0V
	 KCPNlxJXhxWVu0AhrAJXNjljdvGp5A16pQOjvi//1eFTUZ+6fQWGg3f9rLRUi5XUzT
	 NGelBqluvwzJI5defLTtGTf70Vwz2rL+FRmLMnspu6VNnY4G0ktfQjblvSafsnYDjo
	 hQ+LxsOd1Uj2w==
Date: Mon, 1 Jul 2024 16:37:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: honor init_xattrs in xfs_init_new_inode for !attr
 && attr2 fs
Message-ID: <20240701233749.GF612460@frogsfrogsfrogs>
References: <20240618232112.GF103034@frogsfrogsfrogs>
 <20240619010622.GI103034@frogsfrogsfrogs>
 <ZoIF7dEBkd4YPlSh@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoIF7dEBkd4YPlSh@dread.disaster.area>

On Mon, Jul 01, 2024 at 11:27:09AM +1000, Dave Chinner wrote:
> On Tue, Jun 18, 2024 at 06:06:22PM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 18, 2024 at 04:21:12PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > xfs_init_new_inode ignores the init_xattrs parameter for filesystems
> > > that have ATTR2 enabled but not ATTR.  As a result, the first file to be
> > > created by the kernel will not have an attr fork created to store acls.
> > > Storing that first acl will add ATTR to the superblock flags, so chances
> > > are nobody has noticed this previously.
> > > 
> > > However, this is disastrous on a filesystem with parent pointers because
> > > it requires that a new linkable file /must/ have a pre-existing attr
> > > fork.
> 
> How are we creating a parent pointer filesystem that doesn't have
> XFS_SB_VERSION_ATTRBIT set in it? I thought that mkfs.xfs was going
> to always set this....

<shrug> The first three versions didn't set ATTRBIT; somewhere between
v4 and v5 Allison changed mkfs to set ATTRBIT; and as of v13 it still
does.

That said, there aren't actually any parent pointers on an empty
filesystem because the root dir is empty and the rt/quota inode are
children of the superblock.  So, technically speaking, it's not
*required* for mkfs to set it, at least not until we start adding
metadir inodes.

At no point during the development of parent pointers has xfs_repair
ever validated that ATTRBIT is set if PARENT is enabled -- it only
checks that ATTRBIT is set if any attr forks are found.

> > > The preproduction version of mkfs.xfs have always set this, but
> > > as xfs_sb.c doesn't validate that pptrs filesystems have ATTR set, we
> > > must catch this case.
> 
> Which is sounds like it is supposed to - how is parent pointers
> getting enabled such that XFS_SB_VERSION_ATTRBIT is not actually
> set?

Someone who fuzzes the filesystem could turn off ATTRBIT on an empty fs.
That's a valid configuration since there are also no parent pointers.

Or at least I'm assuming it is since xfs_repair has never complained
about ATTRBIT being set on a filesystem with no attr forks, and nobody's
suggested adding that enforcement in the 6 years the parent pointer
series has been out for review.

Getting back to the story, if someone mounts that empty filesystem and
tries to create a directory structure, the fs blows up.  This patch
fixes that situation without adding more ways that mount can fail.

> > > Note that the sb verifier /does/ require ATTR2 for V5 filesystems, so we
> > > can fix both problems by amending xfs_init_new_inode to set up the attr
> > > fork for either ATTR or ATTR2.
> 
> True, but it still seems to me like we should be fixing mkfs.xfs and
> the superblock verifier to do the right thing given this is all
> still experimental and we're allowed to fix on-disk format bugs
> like this.
> 
> Can we add that to the superblock verifier so that the parent
> pointer filesystems will not mount if mkfs is not setting the 
> XFS_SB_VERSION_ATTRBIT correctly when the parent pointer feature is
> enabled?
> 
> Worst case is that early testers will need to use xfs_db to set the
> XFS_SB_VERSION_ATTRBIT and then the filesystem will mount again...

Patches welcome.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
