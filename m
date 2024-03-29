Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2193D3AC
	for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2024 18:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711737511; cv=none; b=N6yA4b5GiHreAFZkpygVvX+dl2Eg2kw8MxMZIJrnuI4E33OyuBfrtf7GrwxOzsNC0OvyR9xmwPM21s2xkIBNXVpj1e9pu/vBkh7AXApjOUMVzO6JpO7o4kF4E0XYo82BvdBLu0VMR/8SRtqFZB+HY1sjKs0mk7BnWagDlKczrNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711737511; c=relaxed/simple;
	bh=e1imsTsDc6VRw3jVzJsYBmp7xLpNWC191prVT2fSxLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yhrk+ZryTztTAMe/2IZscMN25k7xjCJp/nGQRBysdFGiLUvHFDZ5SJjgEMLDTXZj6A2uFjhHK9EZEhqIZl8xvl59a+Nj7MvW56wngH4fdPxXuCAydylZ8q/bEywGMM1G6thwH3Yn4/skejgzXQmM3P5ySV6x5gaIhx04asBuU80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NnROWT+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NnROWT+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F19C433C7;
	Fri, 29 Mar 2024 18:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711737510;
	bh=e1imsTsDc6VRw3jVzJsYBmp7xLpNWC191prVT2fSxLE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NnROWT+3qFgJl564w4LUVV/0gTm+ckmfjed5OdayY8m/2D7PLUdzll7IvCJyjGGVL
	 qpRWwGocQIoC14T3JqMPEZt1NdXa8rLI1WVXYl0Nk1u89SbNEYVeoCxILLMoaOmfbt
	 bapGrc/iddIjVfG5Pr60ahMBY+8DJIl/Hs8FJULdyJKPLSH2prrrNKXPfnY3kbnsSY
	 OfbEZuG3qRcwhr43WCXoKNnFWnDWmmCMf8nTZiO0hDnE7pUspLZYoae2iowe35Yv+U
	 Glbaz8NDSZDC2wZq2m88II7f2KAQCmkowptncMv1Y4vqYdV9KlHC6QeoIC4kWNNZ2B
	 aYPYm3XnAQNzQ==
Date: Fri, 29 Mar 2024 11:38:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: fix potential AGI <-> ILOCK ABBA deadlock in
 xrep_dinode_findmode_walk_directory
Message-ID: <20240329183829.GK6390@frogsfrogsfrogs>
References: <171150379369.3216268.2525451022899750269.stgit@frogsfrogsfrogs>
 <171150379387.3216268.6890967813601957901.stgit@frogsfrogsfrogs>
 <ZgRPw7o8-OcjN6ft@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgRPw7o8-OcjN6ft@infradead.org>

On Wed, Mar 27, 2024 at 09:56:35AM -0700, Christoph Hellwig wrote:
> > Thread 20558 holds an AGI buffer and is trying to grab the ILOCK of the
> > root directory.  Thread 20559 holds the root directory ILOCK and is
> > trying to grab the AGI of an inode that is one of the root directory's
> > children.  The AGI held by 20558 is the same buffer that 20559 is trying
> > to acquire.  In other words, this is an ABBA deadlock.
> > 
> > In general, the lock order is ILOCK and then AGI -- rename does this
> > while preparing for an operation involving whiteouts or renaming files
> > out of existence; and unlink does this when moving an inode to the
> > unlinked list.  The only place where we do it in the opposite order is
> > on the child during an icreate, but at that point the child is marked
> > INEW and is not visible to other threads.
> > 
> > Work around this deadlock by replacing the blocking ilock attempt with a
> > nonblocking loop that aborts after 30 seconds.  Relax for a jiffy after
> > a failed lock attempt.
> 
> Trylock and wait schemes are sketchy as hell.  Why do we need to hold
> the AGI lock when walking the directory?

The short answer is that we're holding the AGI to quiesce inode cache
activity in the AG containing the inode that xrep_dinode* is trying to
fix.  The goal of xrep_dinode* functions is to get the ondisk inode into
good enough shape that we can iget the inode and continue repairs with
the cached inode and all the functionality that you get with a cached
inode.

Longer answer:

When the xchk_setup_inode function fails to iget an inode, it grabs the
AGI buffer, computes the xfs_imap of the affected inode, and hands
things over to repair.  At this point, we've prevented any other threads
from trying to allocate or free an inode in that AG.

Repair uses the xfs_imap to read the inode cluster buffer, so now it
holds the top and the bottom of the inode structure.  One of two things
can happen:

1) If xrep_dinode_mode decides it doesn't need to do anything, we
continue correcting problems in the rest of the xfs_dinode, commit the
cluster buffer, and retry the untrusted iget.  Repair still holds the
AGI and the icluster buffer, so we know that nobody else could have
started a walk.  Therefore, we cannot deadlock with another thread
calling iget.

2) If xrep_dinode_mode does decide to scan the filesystem to try to
recover i_mode from ftypes, now we need to do untrusted igets of
every directory in the filesystem.  However, we still need to hold the
AGI and the cluster buffer.

Oh.  The xchk_iscan_iter in xrep_dinode_find_mode does a blocking
acquisition of every AGI in the filesystem.  If the busted inode is in a
high AGI, we'll end up taking AGIs in the wrong order.  Ok, I need to
fix that too.

--D
