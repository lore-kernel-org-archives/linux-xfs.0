Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1CE1DFCB
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jul 2024 16:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721234751; cv=none; b=f3aGbXXw3qpv2OiP/RvIT4ZE4kTV+LK/A8jcmPgolL1b8JcrWfdG7Z9anNKqqZUOoMnADz3YVYdlQJUBzZD8j9BXYvETR0Hnn0pwTzgSGg0Oavwl88AzBiSAkhtyRP1+kiIA1CJbBk17M3zrleniEPIfH3L2tBcuFGeGLmVT3Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721234751; c=relaxed/simple;
	bh=k/KKPxnr7idju25jSYsqEovbBI7yw6IV3+jIKdBE1iE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CMy2EBhFBWOtp0aYHUOSiwYhKxS2e61YaOfdGZU4Kcdvs3TAmqGtUIvbzmA7MtePUCikDw7YUKNs8XIDWZpv/8wqHuUHdyflFSxyP32r8dD7pQO8u5PZ5LUeNWh1F8lrgP3PVYZ1mXU9sSYB309dadpizud0OFhw9jPyCnd6KTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6951A68AA6; Wed, 17 Jul 2024 18:45:45 +0200 (CEST)
Date: Wed, 17 Jul 2024 18:45:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] debian: enable xfs_scrub_all systemd timer
 services by default
Message-ID: <20240717164544.GA21436@lst.de>
References: <171988120259.2008941.14570974653938645833.stgit@frogsfrogsfrogs> <20240702054419.GC23415@lst.de> <20240703025929.GV612460@frogsfrogsfrogs> <20240703043123.GD24160@lst.de> <20240703050154.GB612460@frogsfrogsfrogs> <20240709225306.GE612460@frogsfrogsfrogs> <20240710061838.GA25875@lst.de> <20240716164629.GB612460@frogsfrogsfrogs> <20240717045904.GA8579@lst.de> <20240717161546.GH612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240717161546.GH612460@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 17, 2024 at 09:15:46AM -0700, Darrick J. Wong wrote:
> > So I think the package split makes sense no matter what we do,
> > but I really want a per file system choice and not a global one.
> 
> <nod> How might we do that?
> 
> 1. touch $mnt/.selfheal to opt-in to online fsck?
> 2. touch $mnt/.noselfheal to opt-out?
> 3. attr -s system.selfheal to opt in?
> 4. attr -s system.noselfheal to opt out?
> 5. compat feature to opt-in
> 6. compat feature to opt-out?
> 7. filesystem property that we stuff in the metadir?
> 
> 1-2 most resemble the old /.forcefsck knob, and systemd has
> ConditionPathExists= that we could use to turn an xfs_scrub@<path>
> service invocation into a nop.
> 
> 3-4 don't clutter up the root filesystem with dotfiles, but then if we
> ever reset the root directory then the selfheal property is lost.

All four of of them are kinda scary that the contents of the file systems
affects policy.  Now maybe we should never chown the root directory to
an untrusted or not fully trusted user, but..

> 5-6 might be my preferred way, but then I think I have to add a fsgeom
> flag so that userspace can detect the selfheal preferences.

These actually sound like the most sensible to me, even if the flags
are of course a little annoying.

> b. Adding these knobs means more userspace code to manage them.  1-4 can
> be done easily in xfs_admin, 5-8 involve a new ioctl and io/db code.

Yeah, that's kindof the downside.

The other option would of course be some kind of global table in /etc.

