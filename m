Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2124F353A6E;
	Thu,  2 Jul 2026 15:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783005751; cv=none; b=YbOxzG9cJakwzQHf5wFzoTpczu+9CgSYo+4T9de5dEwXoqiayWZAZ4b2o4raPAI+gt2d7gC3IkKqgLtEFPyEUkgrl4PlkGi5GEPI4Nnx5MS4Tvv5aU2bj/7H4FvLFuz9Mdd0EjRsoCx4DdJnyags3Krdh6GVsVoFOIKOG+yRDEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783005751; c=relaxed/simple;
	bh=1AWUu/FAEgFT/pLed5NB6DIHneq5vCw0kxkLe3QDJcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lc/HGfKi2UG/F7AY/uVxaOp4qLpLzl0ORzl+QLBnLRJuvbg4HN51oWYWw7leebTcUbOXtplnif9A+vCb0KNQ8rnRO5/RrlTkglE9UFeWGhB19lncQBF3b/NUc5Xhf/XHWKstZrkZGxUIUS6+TOCrsCKZ9DdmvqvSDCP9RKzEXBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FiUovpMh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FiUovpMh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BAF671F000E9;
	Thu,  2 Jul 2026 15:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783005749;
	bh=IfVwGO0PpTH1CW0k2GA39yk22CEviDMt95MXyqfpqbU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FiUovpMhXqguod9Qkx1vwt4a/RcjtJUxpUWvjUqcjNw1BeOgxERII5muXV6gMaSSw
	 dYkK5yUg6vkNHP2SVAhy7GBADLJUa5xG0OKJB8uV0Zl9tA6GHmD+/LI0aR49Gp/X/K
	 QCa569deadbcTZKpXwSTXtz32Ko2KiIolnO6qc6hqixS9BA+PejxdjGCX7r6JXUNf5
	 Zs1euYfAzfiVD8siM6lBsJKOIGhBJQ6encUuFFGALhYKpZpQEJdhqlKorvjT0Nsj9Y
	 0bM3o7sZuJSgUQGf2U6XrVZiGN4+kVowagfDw0pp1X6kXo778YPCTrcbWSnPxBeHrm
	 TWk24OFuY6Jig==
Date: Thu, 2 Jul 2026 08:22:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] formalize and fix disabling the RT subvolume
Message-ID: <20260702152229.GC9381@frogsfrogsfrogs>
References: <20260630113526.3601287-1-hch@lst.de>
 <20260630184018.GB6544@frogsfrogsfrogs>
 <20260701105407.GA14404@lst.de>
 <20260701165114.GD6517@frogsfrogsfrogs>
 <20260702103323.GA6816@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702103323.GA6816@lst.de>

On Thu, Jul 02, 2026 at 12:33:23PM +0200, Christoph Hellwig wrote:
> On Wed, Jul 01, 2026 at 09:51:14AM -0700, Darrick J. Wong wrote:
> > Ahaha ok with this patch applied, the regressions I see in generic/441
> > and xfs/656 go away.  generic/441 chokes because the scratch fs goes
> > down due to writeback error, so I assume it's ok to start excluding this
> > test.
> 
> There also is a dedicated patch disabling them for zoned on the list":
> 
> "common: skip data write EIO survival tests on fatal configs"
> 
> from Yao Sang.
> 
> > I'm guessing that the write failure takes down the filesystem, which is
> > why the subsequent xfs_io pread can't even open the file.
> 
> Yes.
> 
> > 
> > Also the comment in xfs/655 and 656 doesn't make sense:
> > 
> >  # Disable the scratch rt device to avoid test failures relating to the
> >  # rt bitmap consuming all the free space in our small data device.
> >  unset SCRATCH_RTDEV
> > 
> > We're creating a regular sized data device, so this shouldn't be an
> > issue.
> 
> I think this has been copy and pasted with the unsetting of SCRATCH_RTDEV,
> as several tests have it..

Yes.  I apologize for my contributions to the copy-pasta :(

--D
