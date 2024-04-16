Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F35134424
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 18:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713290915; cv=none; b=fECo6eE2UvvPw0FT63Xd6CxhhI5lXi+S3P7AzJSp/Znuk/CgQu3QzgCX1Uy8hff0GY0OCfr1Dwpz+VQ+wF6JlYKM/rcYMcTgPef/s5BlEKpClXEnscADCw8yiOk80lQ0QU+aPYJYffYdAHAw8FDvxeOKomOroAkOYTHbmz8Wxek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713290915; c=relaxed/simple;
	bh=NYJpCpfJE5sWWmi8wTK0UnlevV82xLxw4e0MjbxeSXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LlCw7ahkALE1uwnYEKbzjptVff5lADneqW2BKSTuirNgEC3e1XKtrZndbeyvUAWYJbgSe00qoqZfMBkUZ9+Sq0RD7nDBma8pgWXvAr+O9nBGLWoyq9eTrr/Myva2gjKK8WcYtiFXwQP9MUwq8rPJ8r3U4N4oaGsRcXvxgnz/ftM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E57A968D07; Tue, 16 Apr 2024 20:08:26 +0200 (CEST)
Date: Tue, 16 Apr 2024 20:08:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>,
	allison.henderson@oracle.com, linux-xfs@vger.kernel.org,
	catherine.hoang@oracle.com
Subject: Re: [PATCH 26/31] xfs: add parent pointer ioctls
Message-ID: <20240416180826.GA10307@lst.de>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs> <171323028211.251715.6240463208868345727.stgit@frogsfrogsfrogs> <Zh4Kv9kTzBbgBxKC@infradead.org> <20240416175908.GU11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416175908.GU11948@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 16, 2024 at 10:59:08AM -0700, Darrick J. Wong wrote:
> On Mon, Apr 15, 2024 at 10:21:03PM -0700, Christoph Hellwig wrote:
> > > +	if (memcmp(&handle->ha_fsid, mp->m_fixedfsid, sizeof(struct xfs_fsid)))
> > > +		return -ESTALE;
> > > +
> > > +	if (handle->ha_fid.fid_len != xfs_filehandle_fid_len())
> > > +		return -EINVAL;
> > 
> > Maybe we should just stash the fid without the fsid?  The check for a
> > match fsid when userspace already had to resolve it to even call the
> > ioctl is a bit silly.
> 
> Remember a few revisions ago when this ioctl only returned the raw fid
> information?  At the time, I didn't want to bloat struct parent_rec with
> the full handle information, but then I changed it to export a full
> handle.  When I went to update libfrog/getparents.c, I realized that
> giving full handles to userspace is a much better interface because any
> code that's trying to walk up the directory tree to compute the file
> path can simply call getparents again with the handle it has been given.
> 
> It's much more ergonomic if userspace programs don't need to know how to
> construct handles from partial information they has been given.  If a
> calling program wants to open the parent directory, it can call
> open_by_fshandle directly:

Yeah.  I think I actually suggested that :)  So I'll take that back.
That just leaves us with the question if we want to validate the
fsid here and diverge from the mormal handle ops or not.  I think
I'd prefer behaving the same as the other handle ops just to avoid
confusion.
