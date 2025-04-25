Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20C5259C8B
	for <linux-xfs@vger.kernel.org>; Fri, 25 Apr 2025 15:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745593259; cv=none; b=KLINjWSP435TrOhugKly14KLMz9Ywsz21hxKTAFWBnMHdwRSM/2j3PdK6Mc/sxO5Z3whALEEOwEn+KRetfm6U5Sih7Df64eD6enOWicEE4mIoDbVea6ksHcSiJmK/2I0DQSiN8ubn3lY2XanXaXIQEc/fc8oJA0KbdEA6H87JFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745593259; c=relaxed/simple;
	bh=iRo3xNVeKi9uzmRJ6hbAEGR72ayfhRoBZD3PLWFh2vg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BNAImi9LxtEOODobmp4O/EZ3rrGkwIU7U1+0+dB9o0e1GbI84IRF93Lw1Mv086vqvBSA1iupkYdUJI1PPONo+4J5sXHQ8s87e45LeEFW2e6VP0cV6KOcnyBy8Y6KYyb/SsoWzZjxcY/KCIRRlQYEUpJ0zKBaQxWwe0Kt97vOiSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jCBFkjrh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jCBFkjrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FD4C4CEE4;
	Fri, 25 Apr 2025 15:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745593258;
	bh=iRo3xNVeKi9uzmRJ6hbAEGR72ayfhRoBZD3PLWFh2vg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jCBFkjrhhCxN9V72ChrbEN2sAfSXN9ORyCHWa75D9BXcWNAUTMyabBB8Fm7NtvUei
	 L83S9k2BIraiW9PXJjNDFfEnRH0dPLl8g5mO/r7oh0oQvHG3ZKcLdROdeOI/COSyg5
	 1IoYYgQGZmN1po6W1RnhfgbW3r47VPNk6tncQ0JTkCMK65HzYZb8GCf0cK8mF9VeUs
	 4BgVrTRDGEY+qZEZsoau3kL/4tKfEswc8PC4xlt+Na7L/bRHMBriOiQfvkdWvyGZma
	 Y1LMPTef9999kGWA/TjLyn1lEF9BTw75dwsBFMgSxLhroe7ytrQWFfchMa76Rei3sq
	 MlF1td5R4JIqA==
Date: Fri, 25 Apr 2025 08:00:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Luca Di Maio <luca.dimaio1@gmail.com>, linux-xfs@vger.kernel.org,
	dimitri.ledkov@chainguard.dev, smoser@chainguard.dev
Subject: Re: [PATCH v6 2/4] populate: add ability to populate a filesystem
 from a directory
Message-ID: <20250425150055.GM25675@frogsfrogsfrogs>
References: <20250423160319.810025-1-luca.dimaio1@gmail.com>
 <20250423160319.810025-3-luca.dimaio1@gmail.com>
 <20250423202358.GI25675@frogsfrogsfrogs>
 <vmiujkqli3d4c7ohgegpxvwacowl2tdaps6m4wyvwh6dcfado7@csca7fs5y7ss>
 <20250424220041.GK25675@frogsfrogsfrogs>
 <aAuJtnJQXOlZ6LLi@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAuJtnJQXOlZ6LLi@infradead.org>

On Fri, Apr 25, 2025 at 06:10:14AM -0700, Christoph Hellwig wrote:
> On Thu, Apr 24, 2025 at 03:00:41PM -0700, Darrick J. Wong wrote:
> > The thing is, if you were relying on atime/mtime for detection of "file
> > data changed since last read" then /not/ copying atime into the
> > filesystem breaks that property in the image.
> 
> I don't think that matter for images, because no software will keep
> running over the upgrade of the image.  Also plenty of people run
> with noatime, and btrfs even defaulted to it for a while (not sure if
> it still does).
> 
> At the same time having the same behavior as mkfs.ext4 is a good thing
> by itself because people obviously have been using it and consistency
> is always a good thing.

I don't see where mke2fs -d actually copies i_mtime into the filesystem.
In misc/create_inode.c I see a lot of:

	now = fs->now ? fs->now : time(0);
	ext2fs_inode_xtime_set(&inode, i_atime, now);
	ext2fs_inode_xtime_set(&inode, i_ctime, now);
	ext2fs_inode_xtime_set(&inode, i_mtime, now);

which implies that all three are set to a predetermined timestamp or the
current timestamp.

Also while I'm scanning create_inode.c, do you want to preserve
hardlinks?

> > How about copying [acm]time from the source file by default, but then
> > add a new -p noatime option to skip the atime?
> 
> I'd probably invert the polarity.  When building an image keeping
> atime especially and also ctime is usually not very useful.  But that
> would give folks who need it for some reason a way to do so.

Either's fine with me.

--D
