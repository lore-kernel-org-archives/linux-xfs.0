Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8882BFC1F
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 16:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713286257; cv=none; b=n+cTmPQIZnPLHHXRN2dxALhFbI/I4wwUncGa0NjA3PoTLNf2DnbN7MimbWiAHBHQZvX5wg7N1yF/dxd9walaio8qhnid3W6ueNlvyNH9XUcN4HhVLNZrPN5oMJ30vS8YBv1RO2D0NrFsHkyuLGE/DrxkEbdblyTIu7DCSDqMJH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713286257; c=relaxed/simple;
	bh=iLSQmOuilYW6ElH3WpXWetEikrbggq7OPvkqGIw7VW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=moFzToZs0IihwI8Oar2yLd1U61CQtHb6saUCt8AGGzpIcHgz8ahUnqJITOiIDJmALEeT42+V2W3iDB8c8NxhtQVfrsPb0Ij3mbC4vUAVoTOmGn6qYlhU95ps98Cok9v53C3aA/I5b3Laxrj97yaQSvjPjj1W0n3otwARUfkzajg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uaKWFmRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uaKWFmRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096A0C113CE;
	Tue, 16 Apr 2024 16:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713286257;
	bh=iLSQmOuilYW6ElH3WpXWetEikrbggq7OPvkqGIw7VW4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uaKWFmRbpYeXEq9BVkH+/tSXnrAQsfWJVgHWqgiFkFkYXdUmj+6eLrGfLi6SpoeWT
	 piCktxY33UWPdkxXXY/CYTHUjIm1MtbnA8kXH8vJcyptSmR3ElQZ9XkNTGJICFsLec
	 A/KH2zYQi+sfHj2YDvbI8IWASrC6lESHXajth3xwCWO+RVFJcQ0egf3PEKbFwcBqL5
	 usVPYmn+3iXwWy1y/fJEazYOh33F06FvbcO5ABtL4//nm7Km+0O03WQmAgE75tK+cw
	 SN60gxFsefiD/LxkQf3TtaVlXVeQDjsqJqR0IpKqE/DpEVIIMzP6PtSQJARv1ZNgKk
	 BxFEn+sCXFd6A==
Date: Tue, 16 Apr 2024 09:50:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/32] xfs: Add parent pointer ioctls
Message-ID: <20240416165056.GO11948@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270970008.3631889.8274576756376203769.stgit@frogsfrogsfrogs>
 <20240412173957.GB11948@frogsfrogsfrogs>
 <20240414051816.GA1323@lst.de>
 <20240415194036.GD11948@frogsfrogsfrogs>
 <20240416044716.GA23062@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416044716.GA23062@lst.de>

On Tue, Apr 16, 2024 at 06:47:16AM +0200, Christoph Hellwig wrote:
> On Mon, Apr 15, 2024 at 12:40:36PM -0700, Darrick J. Wong wrote:
> > True, libhandle is a very nice wrapper for the kernel ioctls.  I wish
> > Linux projects did that more often.  But suppose you're calling the
> > ioctls directly without libhandle and mess it up?
> 
> The you get different inodes back.  Not really any different from
> pointing your path name based code to the wrong fs or directory,
> is it?

I suppose not.  But why bother setting the fsid at all, then?

> > > In theory no one cares as all operations work just fine with disconnected
> > > dentries, and exportfs_decode_fh doesn't do these checks unless the
> > > accpetable parameter is passed to it.  The real question is why we (which
> > > in this case means 15 years younger me) decided back then we want this
> > > checking for XFS handle operations?  I can't really think of one
> > > right now..
> > 
> > Me neither.  Though at this point there are a lot of filesystems that
> > implement ->get_parent, so I think removing XFS's will need a discussion
> > at least on linux-xfs, if not fsdevel.  In the meantime, getparents can
> > do minimal validation + iget for now and if it makes sense to port it
> > back to xfs_khandle_to_dentry, I can do that easily.
> 
> Uhh, I'm not advocating for removing ->get_parent at all.  We actually
> do need that for security on NFS, where the file handles are used
> undernath pathname based operations.

Ahh, I wasn't aware of that, beyond a sense that "a lot of
NFS-exportable fses do this, so there's likely a general desire for this
to be wired up."

> And it turns out my previous analysis wasn't quite sport on.  The
> exportfs code always reconnects directories, because we basically
> have to, not connecting them would make the VFS locking scheme
> not work.

Noted.

> But as we never generate the file handles that encode the parent
> we already never connect files to their parent directory anyway.

I pondered whether or not we should encode parent info in a regular
file's handle.  Would that result in an invalid handle if the file gets
moved to another directory?  That doesn't seem to fit with the behavior
that fds remain attached to the file even if it gets moved/deleted.

> OTOH we should be able to optimize ->get_parent a bit with parent
> pointers, as we can find the name in the parent directory for
> a directory instead of doing linear scans in the parent directory.
> (for non-directory files we currenty don't fully connect anwyay)

<nod> But does exportfs actually want parent info for a nondirectory?
There aren't any stubs or XXX/FIXME comments, and I've never heard any
calls (at least on fsdevel) for that functionality.

--D
