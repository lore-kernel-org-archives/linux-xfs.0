Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5DE8C04
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jul 2024 16:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721232948; cv=none; b=IqaSt+WieAD7193VdniT0nWY/v0KKDckwAV2rrkI1nutd7s7WqAK670P9awnqDt/qUVMO3nAt+CngblFVbTL8HRG5zRzfIO7Phv5Liga7N/3+DDeO8/ZFxfcLLiAH0chLEPj983rXMQhcK99lDnmsdkI7Y1IR7OL7hDxgg4RQEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721232948; c=relaxed/simple;
	bh=PNjl72aI+/BMgSoUr1h9094Zbwux+OnKlLBck7MU8eM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UAIZwbbYziKy1ZToKiV0/tugqT/RLPS86XLw59XC9BegUrhF02V1FAXDklHo1GZwXN/SR4cwaolJP5KRUp2zyLDUbi1oqcT4uTZW/1Q5GCT+MvMAnUYngYnG+gf/P9IBL0JIBfgvT6W/ZfGcKQfungtHcu4TfAQKM1vTr9+b7Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fktVZ0l5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fktVZ0l5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DE6C2BD10;
	Wed, 17 Jul 2024 16:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721232947;
	bh=PNjl72aI+/BMgSoUr1h9094Zbwux+OnKlLBck7MU8eM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fktVZ0l5T5Gv4pIY5+UesZkapgjvpAyKQV3M9tKAy8jGBEHyqt4u/uq6fzCu9+cNC
	 BuPa/W+OunFnDS4qX/KzgJlac/rG+RUAf41gCytiFItrhUWu0u5yXDTY2UT+woRTO0
	 C5TNpCYRZDCOm5mYEmDSPTgS0owfLa2iMggpdSPjRqBCu2tptzYLrALJVr3MVuallZ
	 stRAMZqD6B434JJIFJRnpNJ/nqZe6aHtPiVvGB1yyuAWFmhRXStcqhi+shchpBGnBt
	 IxLzEjXyuYPYsKPO3FPH4eBYvnvS1qMVdDxx95qptAm8NmK9Ebb9jzhK/27exjjiSR
	 qw4JB+eTsf6jw==
Date: Wed, 17 Jul 2024 09:15:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] debian: enable xfs_scrub_all systemd timer services
 by default
Message-ID: <20240717161546.GH612460@frogsfrogsfrogs>
References: <171988120209.2008941.9839121054654380693.stgit@frogsfrogsfrogs>
 <171988120259.2008941.14570974653938645833.stgit@frogsfrogsfrogs>
 <20240702054419.GC23415@lst.de>
 <20240703025929.GV612460@frogsfrogsfrogs>
 <20240703043123.GD24160@lst.de>
 <20240703050154.GB612460@frogsfrogsfrogs>
 <20240709225306.GE612460@frogsfrogsfrogs>
 <20240710061838.GA25875@lst.de>
 <20240716164629.GB612460@frogsfrogsfrogs>
 <20240717045904.GA8579@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240717045904.GA8579@lst.de>

On Wed, Jul 17, 2024 at 06:59:04AM +0200, Christoph Hellwig wrote:
> On Tue, Jul 16, 2024 at 09:46:29AM -0700, Darrick J. Wong wrote:
> > Hm, xfs could do that, but that would clutter up the mount options.
> > Or perhaps the systemd service could look for $mountpoint/.autoheal or
> > something.
> > 
> > It might be easier still to split the packages, let me send an RFC of
> > what that looks like.
> 
> So I think the package split makes sense no matter what we do,
> but I really want a per file system choice and not a global one.

<nod> How might we do that?

1. touch $mnt/.selfheal to opt-in to online fsck?
2. touch $mnt/.noselfheal to opt-out?
3. attr -s system.selfheal to opt in?
4. attr -s system.noselfheal to opt out?
5. compat feature to opt-in
6. compat feature to opt-out?
7. filesystem property that we stuff in the metadir?

1-2 most resemble the old /.forcefsck knob, and systemd has
ConditionPathExists= that we could use to turn an xfs_scrub@<path>
service invocation into a nop.

3-4 don't clutter up the root filesystem with dotfiles, but then if we
ever reset the root directory then the selfheal property is lost.

5-6 might be my preferred way, but then I think I have to add a fsgeom
flag so that userspace can detect the selfheal preferences.

7 is a special snowflake currently :P

Other issues:

a. Are there really two bits that we might want to store in the *heal
attribute?

   00 == never allow online fsck at all
   01 == allow invocations of xfs_scrub but don't let xfs_scrub_all
         invoke it
   11 == allow all invocations of online fsck

and probably useless:

   10 == allow invocations of xfs_scrub only from xfs_scrub_all

b. Adding these knobs means more userspace code to manage them.  1-4 can
be done easily in xfs_admin, 5-8 involve a new ioctl and io/db code.

c. 1-4 can be lost if something torches the root directory.  Is that ok?
7 also has that problem, but as nobody's really designed a filesystem
properties feature, I don't know if that's acceptable.

> As a fіle system developer I always have scratch file systems around
> that I definitely never want checked.  I'd also prefer scrub to not
> randomly start checking external file system that are only temporarily
> mounted and that I want to remove again.

Another thing I need to figure out if systemd has a handy way of
terminating a service as a "prerequisite" to "stopping" a mount.
Right now you can unmount an fs that's being scrubbed from your mount
hierarchy, but the service keeps running and the mount is still
active.

> Maybe we'll indeed want some kind of marker in the file system.
> 
> Btw, the code in scrub_all that parses lsblk output to find file systems
> also looks a bit odd.  I'd expect it to use whatever is the python
> equivalent of setmntent/getmntent on /proc/self/mounts.

It parses the lsblk json output so that it can trace all the xfs mounts
back to raw block devices so that it can try to kick off as many scrubs
in parallel as it can so long as no two scrubs will hit the same bdev.

--D
