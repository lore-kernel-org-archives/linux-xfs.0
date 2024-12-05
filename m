Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA6984A22;
	Thu,  5 Dec 2024 06:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733379291; cv=none; b=YivxYO6KT8EaMOGHH8uDselE0v9XUHFhnKDmy8BjInCVyi2+zXPt2kujRtU4hjjIOyN6mR64eWXmwn78bFW7LpNXm7kp6IFAjiN9CAqdzPGuLKew3t21XlW04MUm9bzuiE4PTxtbxXEsf368Hk1RXQrb4wRpwAFFhyV4CusX1ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733379291; c=relaxed/simple;
	bh=aZaJjr75f+gabcWtmc7Y0K9NrVI2G5ELlyWmSalqyYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jMzBO57447FKBEOaypE1WNumpJmW2GDnrQLSgjI8p7zCRf7skI0J1dn0rmWa7xPqEVqc/afqXaZpAM9+Fq6KyrMEtu1u08HxTi4dehhqCW5HgfYP1JX1McNmtnVjOHUu97wX48E1ho2mhpr1W5nmCxcZgbTp37/7VkKEsAMDCy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mF3dwzoQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mF3dwzoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA1EC4CED1;
	Thu,  5 Dec 2024 06:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733379290;
	bh=aZaJjr75f+gabcWtmc7Y0K9NrVI2G5ELlyWmSalqyYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mF3dwzoQLVux6qeGwceMV/WJhRiNUQDQFLk8hMhcOyM1nOCgRV445BHUmOoRtvglh
	 uVB19+l7nN4hCYDwkKdtuHWe1D7ZZvYmeMUk2im3M32to5WXOn6a1FunG4qV14jakO
	 +ACzgzChgGg/jD+Zx9sQP6EZSxuRONi/QcHmSP/lrgQc/NpSHi2kJMrmgCkZ6bF5M1
	 mDQ76fpdaKGrFCdnw+bWlngkM320gkTfjeBn9ZetWgfQoySDCIRSj176nx+aKvGLc/
	 nGiGT7C6vBoGlrZv9loI5VzByq0i2DyyMiYBwOi8J/BAn91s0Kl9RAtHfT4aeuwOBF
	 /qD/rNc/Jj0gQ==
Date: Wed, 4 Dec 2024 22:14:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 1/6] xfs: don't move nondir/nonreg temporary repair files
 to the metadir namespace
Message-ID: <20241205061450.GC7837@frogsfrogsfrogs>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
 <173328106602.1145623.16395857710576941601.stgit@frogsfrogsfrogs>
 <Z1ARxgqwLYNvpdYS@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1ARxgqwLYNvpdYS@infradead.org>

On Wed, Dec 04, 2024 at 12:24:38AM -0800, Christoph Hellwig wrote:
> On Tue, Dec 03, 2024 at 07:02:29PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Only directories or regular files are allowed in the metadata directory
> > tree.  Don't move the repair tempfile to the metadir namespace if this
> > is not true; this will cause the inode verifiers to trip.
> 
> Shouldn't this be an error instead of silently returning?  Either way
> the function could probably use a lot more comments explaining what is
> doing and why.

The function opportunistically moves sc->tempip from the regular
directory tree to the metadata directory tree if sc->ip is part of the
metadata directory tree.  However, the scrub setup functions grab sc->ip
and create sc->tempip before we actually get around to checking if the
file is the right type for the scrubber.

IOWs, you can invoke the symlink scrubber with the file handle of a
subdirectory in the metadir.  xrep_setup_symlink will create a temporary
symlink file, xrep_tempfile_adjust_directory_tree will foolishly try to
set the METADATA flag on the temp symlink, which trips the inode
verifier in the inode item precommit, which shuts down the filesystem
when expensive checks are turned on.  If they're /not/ turned on, then
xchk_symlink will return ENOENT when it sees that it's been passed a
symlink.

I considered modifying xchk_setup_inode_contents to check the mode if
desired and return ENOENT to abort the scrub without calling
_adjust_directory_tree, but it seemed simpler to leave the tempfile code
inside tempfile.c.

<shrug> I'm ok doing it that way too.

--D
