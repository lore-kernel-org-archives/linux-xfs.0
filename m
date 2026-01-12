Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CF7346A0C
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 21:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768254809; cv=none; b=com3Wvw1PLbsZYxX85hEeX0GYhpfXNFJCBJpW7gUbSHuxOf2C/xOEMjfg0oO/o+9zto2XUjz5P0H33CkgO2bnu9KSQnuQlBmbUdyfhSw0sek6j6RrPIIZ1KqWuLcK5Cfzd3iks3lATAxsaNkIW7rvHquJzm7YuGGmJloW4oiOGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768254809; c=relaxed/simple;
	bh=7LzybpzmdIJhKMDOJYw2SK/pmp+Vp/SHv95Fo7aJGzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SLcq2UR374WfmjxHvCodFILTIdW1RVEalhAp6Eub34JmcEKKAi7+cnlnajBTa/Vr1o+vt/woA5cB2eGhl9MUijph5JXKKk+yBOyYTX9sO31YDUXc8Dtzkrsfq6j19iXVOTxIbfOrVEAWGf7jR0Y867bLWN0oEHsXNqOJaF1Djhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dPXqry9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dPXqry9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2525C19421;
	Mon, 12 Jan 2026 21:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768254808;
	bh=7LzybpzmdIJhKMDOJYw2SK/pmp+Vp/SHv95Fo7aJGzg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dPXqry9xOXpEgyLjseTjalXM8AAw0gdQ/AeEHgoFSAJOofSLT1YauQj6ZRsR/5SIH
	 cAAjZny9eh3YSwx+/vZxfk4AVAozXqG+ko0cICPNv5n2C5oMVp1QIlB4xWEJRsqm6X
	 TT/ATYoYpBKvACkpqUUbW3ojIK7+UxLI92baNUFnN7OtY+eq2mj08rISFxSl52rlFz
	 TnTCiSPHUVZITmcFFEa2AB/znWnpgx0E1POUr0defGbcVVzEHxb+K00BXv6nAp2plN
	 R5TjI28roy17Nh/BbeYYJ/l3MkKChxlU0BUdNZVVa5Y5MK+X+rQ/KiOxTIrA7Y6se2
	 EQ1IqyFFC6i1A==
Date: Mon, 12 Jan 2026 13:53:28 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, linux-xfs@vger.kernel.org
Subject: Re: Shrinking XFS - is that happening?
Message-ID: <20260112215328.GF15551@frogsfrogsfrogs>
References: <B96A5598-3A5F-4166-8566-2792E5AADB3E@karlsbakk.net>
 <8a9071104eec47d91ab44c86465d08d76e0cf808.camel@gmail.com>
 <aJnKcktFW6jPBETP@infradead.org>
 <20250811152532.GH7965@frogsfrogsfrogs>
 <2f9c2c7d-a6c1-4f79-b7e5-6bc369bb585b@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f9c2c7d-a6c1-4f79-b7e5-6bc369bb585b@gmail.com>

On Mon, Jan 12, 2026 at 08:05:12PM +0530, Nirjhar Roy (IBM) wrote:
> 
> On 8/11/25 20:55, Darrick J. Wong wrote:
> > On Mon, Aug 11, 2025 at 03:48:18AM -0700, Christoph Hellwig wrote:
> > > On Tue, Aug 05, 2025 at 10:20:15AM +0530, Nirjhar Roy (IBM) wrote:
> > > > On Mon, 2025-08-04 at 17:13 +0200, Roy Sigurd Karlsbakk wrote:
> > > > > Hi all!
> > > > > 
> > > > > I beleive I heard something from someone some time back about work in progress on shrinking xfs filesystems. Is this something that's been worked with or have I been lied to or just had a nice dream?
> > > > > 
> > > > > roy
> > > > I have recently posted an RFC[1]. The work is based/inspired from an old RFC[2] by Gao and ideas
> > > > given by Dave Chinner.
> > > Like the previous attempts it doesn't seem to include an attempt to
> > > address the elephant in the room:  moving inodes out of the to be
> > > removed AGs or tail blocks of an AG.
> > Anyone who wants to finish the evacuation part is welcome to pick this
> > up:
> > https://lore.kernel.org/linux-xfs/173568777852.2709794.6356870909327619205.stgit@frogsfrogsfrogs/
> 
> Hi Darrick,
> 
> I am working on the extending my online shrink fs work [1] to realtime fs
> shrink and as a part of that project, I am looking into the patchbomb above
> - specifically " [PATCHSET 3/5] xfsprogs: defragment free space". I have a
> high level questions before I delve deep into the patches above:
> 
> 1. Can you please elaborate a bit on what do you mean by "finish the
> evacuation part"? I took a very high level look at the patch, and it seems
> it is already adding support to move data from one rtg/AG to another?

It can evacuate fully mapped blocks, but it can't do that for the EOF
block if the EOF is in the middle of that block.

--D

> --NR
> 
> > 
> > --D
> 
> -- 
> Nirjhar Roy
> Linux Kernel Developer
> IBM, Bangalore
> 
> 
