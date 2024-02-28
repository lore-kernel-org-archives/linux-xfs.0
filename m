Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FFA3BBC5
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709141606; cv=none; b=k3dFRQOxXkwrn1xkFH60TWPtoLz0WofToiMIQGR9F3FIBPpihysv5obSuDH13F0NFnCLt49cW3NyaV9IbYjgKmk30cBu7DyYiTDJ+CQ9tNbhh0gnzzuAqhHcGS5y65a9dtOjYCvQYiVKMnEUcvXMJrclMULb/ncTwnhA6htfIpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709141606; c=relaxed/simple;
	bh=AkchHvxOqPK7Ih5+D73ffCNaIzrN2AXSrtOhzFsN+ys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eakSsm/DiS1/dIL59jVWWAlYXKwUK9y7BUxCrne3xysleh5oVqZKpn+p/lJIc+UK2fNoLbVBMN/MH08Vg7AFKbgWPuKK/9Apr1I1kqe8vP0Pb3FSX4vBoQWooUnNvOr7gEJuHTReRdVnOQ9M/PYsPNRY/crX32lygheZwMXz7jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UqlNzms3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UqlNzms3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23AAC433C7;
	Wed, 28 Feb 2024 17:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709141605;
	bh=AkchHvxOqPK7Ih5+D73ffCNaIzrN2AXSrtOhzFsN+ys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UqlNzms3FAp/FAKjZdiblgvv5Pay+4J2pQpmUsa2jPb+/YeuxWe/1+uesVlNoFvWJ
	 Q3dtcgf9YdCdbvYh9fq59ck/al8wn6iFsvQyfVhFsk+FXOMF63dlP+yWBAnFtGGOSp
	 ruVaP14dbQseVzCgDhnMwsw5k8Ln/BG7MPJ8MQC3bH88DdFTixazseYCoMcQjzpnzp
	 GKwlbVUh6yTELM6VZecTXFoiIZaBkakpWinpIYtGkvyLGqKL+q9V2nIOu4TMQpR6mG
	 ukX0/t0srlGHUGLc7LsQeGF0BS22XaYK+W6vwg049+KP/13q19c2XThZjljLMACbp9
	 tXGisdNq/QNEQ==
Date: Wed, 28 Feb 2024 09:33:25 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: hide private inodes from bulkstat and handle
 functions
Message-ID: <20240228173325.GI1927156@frogsfrogsfrogs>
References: <170900012206.938660.3603038404932438747.stgit@frogsfrogsfrogs>
 <170900012232.938660.16382530364290848736.stgit@frogsfrogsfrogs>
 <Zd4mxB5alRUsAS7o@infradead.org>
 <20240228165227.GH1927156@frogsfrogsfrogs>
 <Zd9nJj3Lw4kUYIY6@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd9nJj3Lw4kUYIY6@infradead.org>

On Wed, Feb 28, 2024 at 09:02:30AM -0800, Christoph Hellwig wrote:
> On Wed, Feb 28, 2024 at 08:52:27AM -0800, Darrick J. Wong wrote:
> > that are private to XFS.  What this means is that userspace should never
> > be able to access any information about these files, and should not be
> > able to open these files by handle.
> > 
> > "Callers must not be allowed to link these files into the directory
> > tree, which should suffice to keep these private inodes actually
> > private.  I_LINKABLE is therefore left unset.
> 
> I_LINKABLE is only set for O_TMPFILE, so I wouldn't even bother with
> that.  But thinking about this:  what i_nlink do these private inodes
> have?  If it is >= 1, we probably want to add an IS_PRIVATE check
> to xfs_link just in case they ever leak out to a place where ->link
> could be called.

Ooh, that's a good catch.  I'll check for IS_PRIVATE in xfs_vn_link.

"We're about to start adding functionality that uses internal inodes
that are private to XFS.  What this means is that userspace should never
be able to access any information about these files, and should not be
able to open these files by handle.

"To prevent userspace from ever finding the file, or mis-interactions
with the security apparatus, set S_PRIVATE on the inode.  Don't allow
bulkstat, open-by-handle, or linking of S_PRIVATE files into the
directory tree.  This should keep private inodes actually private."

--D
