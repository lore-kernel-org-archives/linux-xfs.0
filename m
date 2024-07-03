Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9AA1803E
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 05:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719983064; cv=none; b=o0rVTOLwtZ3S0tbn4aVYDVY4dKtpgveh+UVOxKch5n5gP3+dESH3eYJwknJMQJTAm1FZpmwEPe6fDZefaO7mlcXWpBPDlD0Qv8MQnuNCi8aP7P0FRR14kUPniYH9zuMfZEnUgvyZMkVLtlMXC/5STJxd3CLi5V3DIn2j3eJuoF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719983064; c=relaxed/simple;
	bh=q5yOzw5ELh1nAG3YyClRYkIA9CifsjK2tqsYsRNa4M0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ESNs/uYZ5d1uOGsgkcq8v6oY6kPsLM63Tvncc6jS1p0YWP2vQVCHUS1ic9dRKVJka9e1frkv5AzXhJxO2tDJG3vdkRPtIzmrluNF4IQt3+DvWyPgXUAT+sHQ41C+KAQAJ8dvpIK3L2HZgZu23Vij0PgP83isVvAG98IpRU0nshI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cX6dS1er; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cX6dS1er"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D320C32781;
	Wed,  3 Jul 2024 05:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719983064;
	bh=q5yOzw5ELh1nAG3YyClRYkIA9CifsjK2tqsYsRNa4M0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cX6dS1er14TYbzL0fTmCoh9sWZY9skhqdQFq/uC1Kvrb6wHjbB3YGdeJ8izqjIj6P
	 8GAfkcgEa0SNdLBDc+Xd7OPPhA/8okgitNYwcWD3D+D7OpgIgURQNCE5jpekR8/WtZ
	 qIKJ59Y9s+ZIW9uNay4CWjSCLIs6wLBYoasFHXwSEHVa7aCqUGqF5LfUSHjUh4DLzd
	 Bus9AM06mVy40UBiZTIAA+3h5NzGNoPMqZXU5Z5qYdHdNuqH6+p29IQUvr0QnemMj2
	 xWC6UfJLROpyVnMkie/7SIKSaqgVYwbbe2oUqS6DseAq6Yhq61m32XIzil3hF2xRrA
	 yErKd8cjIrn8Q==
Date: Tue, 2 Jul 2024 22:04:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs_scrub: tune fstrim minlen parameter based on
 free space histograms
Message-ID: <20240703050422.GD612460@frogsfrogsfrogs>
References: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs>
 <171988118687.2007921.1260012940783338117.stgit@frogsfrogsfrogs>
 <20240702053627.GN22804@lst.de>
 <20240703022914.GT612460@frogsfrogsfrogs>
 <20240703042922.GB24160@lst.de>
 <20240703045539.GZ612460@frogsfrogsfrogs>
 <20240703045812.GA24691@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703045812.GA24691@lst.de>

On Wed, Jul 03, 2024 at 06:58:12AM +0200, Christoph Hellwig wrote:
> On Tue, Jul 02, 2024 at 09:55:39PM -0700, Darrick J. Wong wrote:
> > > Good question.  As far as I can tell there is no simply ioctl for it.
> > > I really wonder if we need an extensible block topology ioctl that we
> > > can keep adding files for new queue limits, to make it easy to query
> > > them from userspace without all that sysfs mess..
> > 
> > Yeah.  Or implement FS_IOC_GETSYSFSPATH for block devices? :P
> 
> I know people like to fetishize file access (and to be honest from a
> shell it is really nice), but from a C program would you rather do
> one ioctl to find a sysfs base path, then do string manipulation to
> find the actual attribute, then open + read + close it, or do a single
> ioctl and read a bunch of values from a struct?

Single ioctl and read from a struct.

Or single ioctl and read a bunch of json (LOL)

I wish the BLK* ioctls had kept pace with the spread of queue limits.

> > > > That's going to take a day or so, I suspect. :/
> > > 
> > > No rush, just noticed it.  Note that for the discard granularity
> > > we should also look at the alignment and not just the size.
> > 
> > <nod> AFAICT the xfs discard code doesn't check the alignment.  Maybe
> > the block layer does, but ..
> 
> The block layer checks the alignment and silently skips anything not
> matching it.  So not adhering it isn't an error, it might just cause
> pointless work.

<nod>

--D
