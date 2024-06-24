Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F8E19DFAC
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 16:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719247788; cv=none; b=dx6jiSghJhsXw+PU2IOVoO9UrgLr0u27mDhbQoIeOtgz9ltrqhQqyeCwC6qSYjhHC+ijMd3WJoJysmXX4bsTd9264Hrvglv02fQMcAid5PM3RYq2fwvaJuN9CAF9CzpbsLj8zi0YHN6uVZVqQ449hGwtsROOgoPbAS0ByzyJSxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719247788; c=relaxed/simple;
	bh=hTboe+fV7XQlmqzbpZmcsT1Nv+FPQcGCuHaLT2MdJJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c/dHIG9S6TE5LpMDFzUQBzame3E4NEL4FFQIalbln40Ez7cJgLXzXh4IIquWMwsv3mn73PuBCHZELVWUMybP2LsHA13rZOiN50oCCP+6kmgW6TdHa/z9fVh+tWhApDlfy/2l3Z0d4okrotuDdDRnUe63vNnkAuBtsJLn42MztBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aaPz+YDU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aaPz+YDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F9FC2BBFC;
	Mon, 24 Jun 2024 16:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719247787;
	bh=hTboe+fV7XQlmqzbpZmcsT1Nv+FPQcGCuHaLT2MdJJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aaPz+YDUZRzZxahhmoToxF7bKrQ2h9WPpJkABAMfzVe0Sr9RfV7DIvinT2R6JBBcI
	 kMsHNe055ybCGXYQYKUVD6tHM17maqUgL9vw77IV2dPGrEqpJ1NMPtL0JayodozHjv
	 q7PssMIM6qKxqqLp+InQoNf4RfItEfTdCkUocWnSkJgispXoC+00PRQor/+quhBySY
	 RknOrx/j3djuu8BCa+851dx41u1r8Oc3Lr9sDebQcKvxO0qlw9kgPaNMYBl93Nxxwu
	 Z4Y+ZSy3FM27JNWX0xiGN3uHs7fbZW73VW4RDfENTf6WFUDFozQCcGGc1oklGRw0CN
	 rPTdfc7suKolQ==
Date: Mon, 24 Jun 2024 09:49:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] xfs: only free posteof blocks on first close
Message-ID: <20240624164947.GQ3058325@frogsfrogsfrogs>
References: <20240623053532.857496-1-hch@lst.de>
 <20240623053532.857496-8-hch@lst.de>
 <20240624154621.GK3058325@frogsfrogsfrogs>
 <20240624160823.GB15941@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240624160823.GB15941@lst.de>

On Mon, Jun 24, 2024 at 06:08:23PM +0200, Christoph Hellwig wrote:
> On Mon, Jun 24, 2024 at 08:46:21AM -0700, Darrick J. Wong wrote:
> > On Sun, Jun 23, 2024 at 07:34:52AM +0200, Christoph Hellwig wrote:
> > > From: "Darrick J. Wong" <djwong@kernel.org>
> > > 
> > > Certain workloads fragment files on XFS very badly, such as a software
> > > package that creates a number of threads, each of which repeatedly run
> > > the sequence: open a file, perform a synchronous write, and close the
> > > file, which defeats the speculative preallocation mechanism.  We work
> > > around this problem by only deleting posteof blocks the /first/ time a
> > > file is closed to preserve the behavior that unpacking a tarball lays
> > > out files one after the other with no gaps.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > [hch: rebased, updated comment, renamed the flag]
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Someone please review this?  The last person to try was Dave, five years
> > ago, and I do not know if he ever saw what it did to various workloads.
> > 
> > https://lore.kernel.org/linux-xfs/20190315034237.GL23020@dastard/
> 
> Well, the read-only check Dave suggested is in the previous patch,
> and the tests he sent cover the relevant synthetic workloads.  What
> else are you looking for?

Nothing -- it looks fine to me, but as it's authored by me, I can't
meaningfully slap an RVB tag on it, can I?

Eh I've done the rest of the series; let's try it anyway:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D
