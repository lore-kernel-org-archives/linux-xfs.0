Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD502391AB;
	Thu,  5 Dec 2024 07:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733382968; cv=none; b=sO8o3IkcwEAXijqLlHuwkA7BYAEm0BdIBzp6PlYR4J94ChgLfFY/1aIFIm/SIu6JchsbW8Q9+TwIyJXog3XI6XJfGP7BeW9v2Bje+VpqRc3+HmorLF5DzN84h0FBTW6vq6e5FFBHF+8FvR7sEAPVCG+JtvW3Hq4bG2nqxCrFTQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733382968; c=relaxed/simple;
	bh=JEeGimCKZKKB78Nmofr3jCIRWRxB9qGOIIcHAu1YwaA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SjgD6JqGijTNt3YD2iq2TtcMgLBU+TZYFZffA5+Gj034/F6gCqiEK1Vxhr1EHzpJRIdM9GCiKcejSNQdF3fucT7c0zI4ugYANUOqoCxsuZ+Dnp9BEoN2aOac7iMH/bPVUkfGctP6yvQwnLJkQRb/osYPDCYSyZ4wqAsUlymQyYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=apeYVqyb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="apeYVqyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A19C4CED1;
	Thu,  5 Dec 2024 07:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733382968;
	bh=JEeGimCKZKKB78Nmofr3jCIRWRxB9qGOIIcHAu1YwaA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=apeYVqyb30Su/T58pwx4LsG5vFYvvf3yVDfOMm5ujx6LKttk25l6g2Wjungg/vJ9A
	 xixRvqgT9DeUXdvis2MB1YUKEda/AEahaLdxgOnB+KnIrfP05BzpXs7WaEnb42hYaD
	 BGJTa4XrzoEaYtphKk3J8qPlhPoIKDqzla8MOwyxXN/+8AMAiadvs7MgQj5lm3FvYo
	 XHWbgcGD7jO/HcdHilsh+cwd3JVR+mJvXtkAGi29CtpWCa1lFkZMh6Wf0lOAvgqC51
	 V/ieeeczfpIbfYrcVuqg5Wm9EahzKxqk8xDQaD2KGLfn4SYYlEuVuurbaGCpU+W8zV
	 CMY2ykGF0iByg==
Date: Wed, 4 Dec 2024 23:16:08 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 1/6] xfs: don't move nondir/nonreg temporary repair files
 to the metadir namespace
Message-ID: <20241205071608.GF7837@frogsfrogsfrogs>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
 <173328106602.1145623.16395857710576941601.stgit@frogsfrogsfrogs>
 <Z1ARxgqwLYNvpdYS@infradead.org>
 <20241205061450.GC7837@frogsfrogsfrogs>
 <Z1FMPzO9DX9YKTmx@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1FMPzO9DX9YKTmx@infradead.org>

On Wed, Dec 04, 2024 at 10:46:23PM -0800, Christoph Hellwig wrote:
> On Wed, Dec 04, 2024 at 10:14:50PM -0800, Darrick J. Wong wrote:
> > The function opportunistically moves sc->tempip from the regular
> > directory tree to the metadata directory tree if sc->ip is part of the
> > metadata directory tree.  However, the scrub setup functions grab sc->ip
> > and create sc->tempip before we actually get around to checking if the
> > file is the right type for the scrubber.
> > 
> > IOWs, you can invoke the symlink scrubber with the file handle of a
> > subdirectory in the metadir.  xrep_setup_symlink will create a temporary
> > symlink file, xrep_tempfile_adjust_directory_tree will foolishly try to
> > set the METADATA flag on the temp symlink, which trips the inode
> > verifier in the inode item precommit, which shuts down the filesystem
> > when expensive checks are turned on.  If they're /not/ turned on, then
> > xchk_symlink will return ENOENT when it sees that it's been passed a
> > symlink.
> 
> Maybe just write this down in a big fat comment?

Will do.

--D
