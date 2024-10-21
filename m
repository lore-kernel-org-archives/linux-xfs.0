Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9C31CBEBC;
	Mon, 21 Oct 2024 17:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729531673; cv=none; b=HzqqGEqBNye1h2NWb/ejgRtziKsQhboldEqH5oUkgO366uPAhI91LkJeM0MjPlEql3b4E0TzQ1tZkMDU46aI0m3dIGnvoMzW+Bi/0x9cmaIDOPNOkgFDHE/RMWc39f0XxLDECNTP7KlfC6hByjrzeWGOAU8bH89oEtk430/5Lr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729531673; c=relaxed/simple;
	bh=zymD5Jz9hHHvRashOHtZ4xYE1WIv9K+qIsMmGfXhfC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LnTeJCjTkaG1xVQbnD2O8Cb9XskP1DJIib7CwKjwLAVJu/xh3e9j9JtWUEM4k+0U8SJHrIRJ+LIcwF3uZDqELBRTTTMd1X3OjMZqLtadpqBj954ZqeSQEYebR8T6vwPDRGwMxqxV/GKRiAvWXvWDwpaDRz7HpEMRN0PGvU1wS4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eZYzw7zw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eZYzw7zw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7118BC4CEC3;
	Mon, 21 Oct 2024 17:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729531672;
	bh=zymD5Jz9hHHvRashOHtZ4xYE1WIv9K+qIsMmGfXhfC0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eZYzw7zwyjw27JVH5pvazlzdQCYdteUAb0BId+HL3BT8cji0Lan4fignfVLWVVX4X
	 mBwNkqy6KV/GLydZvEPxq4w4PALDvRjS0V1LoQJntdd0KylAS6SAWsNoVuBEby/wNp
	 o+JV959Sq2wMuVKIX+x2RRjhpFT2eKn3vR+DLpJ9Q8QDSXrUprfe0jieb5gkQ3LUhj
	 ASTBws38i03nUGlgVlqeB6kt0PR1EmqV/hftauXSRh7zYqi1q76lVq6XJINs4al97B
	 GeCfhB7OP0Io9RGNKBRe0rBMlpJECaH0flJUn1YMMBxBDWN72ZoN6d47jezERgGtRb
	 OZT33rNrkfV5A==
Date: Mon, 21 Oct 2024 10:27:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH 20/29] xfs: don't fail repairs on metadata files with no
 attr fork
Message-ID: <20241021172751.GA21853@frogsfrogsfrogs>
References: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
 <172919069796.3451313.2227454340362290952.stgit@frogsfrogsfrogs>
 <2024101838-thickness-exposure-ec78@gregkh>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024101838-thickness-exposure-ec78@gregkh>

On Fri, Oct 18, 2024 at 08:00:21AM +0200, Greg KH wrote:
> On Thu, Oct 17, 2024 at 11:58:10AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Fix a minor bug where we fail repairs on metadata files that do not have
> > attr forks because xrep_metadata_inode_subtype doesn't filter ENOENT.
> > 
> > Cc: <stable@vger.kernel.org> # v6.8
> > Fixes: 5a8e07e799721b ("xfs: repair the inode core and forks of a metadata inode")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/scrub/repair.c |    8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> Why is a bugfix / stable-tagged-patch, number 20 in a 29 patch series?
> Why isn't it first, or better yet, on it's own if it is fixing a bug
> that people want merged "soon"?

I have too many patches, and every time I try to get a set through the
review process I end up having to write *more* patches to appease the
reviewers, and fixes get lost.  Look at the copyrights on the other
patches, I've been trying to get this upstreamed since 2018.

This particular bugfix got lost last month probably because I forgot to
ping cem to take it for 6.12-rc1.  Thanks for pushing on this, Greg.

Hey Carlos, can you queue this one up for 6.12-rc5, please?

--D

> thanks,
> 
> greg k-h
> 
