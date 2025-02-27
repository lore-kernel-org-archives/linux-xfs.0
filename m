Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9565B1487D5
	for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2025 10:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740652245; cv=none; b=dX9raVX0oLrJsH95K/STKAhzrQyu+0Q1w/Knj8FcD3Gvi1fOmIqq//0kNOJn1x/6zm8tZrmnbx2ydhPbbFQV+TU8FHulttZkpQYPzartgKLYFZTEQGTLky0LTgJe+AgMPUo1TCoV4zxtjpgdz7jb1uOa0rf3CpH3u8VkJYVYa6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740652245; c=relaxed/simple;
	bh=uq+MxPj1lO4mY+6txmJUOYkZ8aweUl3zCgnWj28ZLk4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L+hJW1IUpvHguS7FzAc3ownzUqPOZ6QvnfAjea5mWwvMGWo5ZNvuFkU9P/wpmrThQ2GlTHp2c6hwH/7ic+l3YJ5jY4oNplzlbHjEj989ceBGY+YLnD6F6+f1NG5xthlZraiDDeBUkvXCcmp32ZDVTnVQIE8zEVYH2TjsawM7Pis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UZ3jVUwu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UZ3jVUwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDB2C4CEDD;
	Thu, 27 Feb 2025 10:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740652243;
	bh=uq+MxPj1lO4mY+6txmJUOYkZ8aweUl3zCgnWj28ZLk4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UZ3jVUwu923HApsCvRUEfAcnDnkIPcOOz5rnG388QI+Qxm1VkanfhsCbTlODHf/rc
	 vkqvq3mIf4OTgAgtM4hXhUuV+1EwTQS+zR8tYsiOOaR3o6o1a/MwXuLSEXvkssysUP
	 3veQGoFjy0nStJ+es82U0cPZRpotgNOBozkGtHDsqF4Z+SYRQIUZlRhTc9BPS5RJah
	 YTdPYBSCZDU0bBfoq+/emImO1jdAySd3258f+UeCCMQkVh2S0BNrgUurfpAdqxRhSO
	 7EU96S0BIhILXrmEbYPwnzxtuRxzX7feMBhCSBJpWHIAiRPnaq1r/KM8ho5c3xMcKY
	 I6x58IgbgLsog==
Date: Thu, 27 Feb 2025 11:30:39 +0100
From: Christian Brauner <brauner@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 1/2] iomap: make buffered writes work with RWF_DONTCACHE
Message-ID: <20250227-beulen-tragbar-2873bd766761@brauner>
References: <20250204184047.356762-1-axboe@kernel.dk>
 <SujyHEXdLL7UN_WtUztdhJ4EVptQ0_LCUdvNOf1xxqSNH50lT37n_wi_zDG7Jrg8Ar87Nvn8D3HaH4B0KscrRQ==@protonmail.internalid>
 <20250204184047.356762-2-axboe@kernel.dk>
 <hij4ycssasmyuzawb2mhq44wec7ybquxxpgxqutbdutfmgaizs@cvpx2km2pg6j>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <hij4ycssasmyuzawb2mhq44wec7ybquxxpgxqutbdutfmgaizs@cvpx2km2pg6j>

On Thu, Feb 27, 2025 at 10:51:40AM +0100, Carlos Maiolino wrote:
> On Tue, Feb 04, 2025 at 11:39:59AM -0700, Jens Axboe wrote:
> > Add iomap buffered write support for RWF_DONTCACHE. If RWF_DONTCACHE is
> > set for a write, mark the folios being written as uncached. Then
> > writeback completion will drop the pages. The write_iter handler simply
> > kicks off writeback for the pages, and writeback completion will take
> > care of the rest.
> > 
> 
> [Adding Brauner to the loop as this usually goes through his tree.]
> 
> Christian, I'm pulling this into my tree for 6.15 if this is ok with you?
> Not sure if you're subscribed to linux-xfs, so, just in case, the link for the
> whole 2-patches series is below.
> 
> https://lore.kernel.org/linux-xfs/20250204184047.356762-1-axboe@kernel.dk/

vfs-6.15.iomap has a lot of iomap changes already so we should use a
shared tree we can both merge. I've put this on:

vfs-6.15.shared.iomap

Just pull it into your branch, please and I pull it into vfs-6.15.iomap.

I see that 2/2 adds a new FOP_UNCACHED flag to the VFS FOP_UNCACHED
please make sure to Cc fsdevel for such additions and remind
contributors as well.

> 
> 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > ---
> >  Documentation/filesystems/iomap/design.rst     | 5 +++++
> >  Documentation/filesystems/iomap/operations.rst | 2 ++
> >  fs/iomap/buffered-io.c                         | 4 ++++
> >  include/linux/iomap.h                          | 1 +
> >  4 files changed, 12 insertions(+)
> > 
> > diff --git a/Documentation/filesystems/iomap/design.rst b/Documentation/filesystems/iomap/design.rst
> > index b0d0188a095e..7b91546750f5 100644
> > --- a/Documentation/filesystems/iomap/design.rst
> > +++ b/Documentation/filesystems/iomap/design.rst
> > @@ -352,6 +352,11 @@ operations:
> >     ``IOMAP_NOWAIT`` is often set on behalf of ``IOCB_NOWAIT`` or
> >     ``RWF_NOWAIT``.
> > 
> > + * ``IOMAP_DONTCACHE`` is set when the caller wishes to perform a
> > +   buffered file I/O and would like the kernel to drop the pagecache
> > +   after the I/O completes, if it isn't already being used by another
> > +   thread.
> > +
> >  If it is necessary to read existing file contents from a `different
> >  <https://lore.kernel.org/all/20191008071527.29304-9-hch@lst.de/>`_
> >  device or address range on a device, the filesystem should return that
> > diff --git a/Documentation/filesystems/iomap/operations.rst b/Documentation/filesystems/iomap/operations.rst
> > index 2c7f5df9d8b0..584ff549f9a6 100644
> > --- a/Documentation/filesystems/iomap/operations.rst
> > +++ b/Documentation/filesystems/iomap/operations.rst
> > @@ -131,6 +131,8 @@ These ``struct kiocb`` flags are significant for buffered I/O with iomap:
> > 
> >   * ``IOCB_NOWAIT``: Turns on ``IOMAP_NOWAIT``.
> > 
> > + * ``IOCB_DONTCACHE``: Turns on ``IOMAP_DONTCACHE``.
> > +
> >  Internal per-Folio State
> >  ------------------------
> > 
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index d303e6c8900c..ea863c3cf510 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -603,6 +603,8 @@ struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
> > 
> >  	if (iter->flags & IOMAP_NOWAIT)
> >  		fgp |= FGP_NOWAIT;
> > +	if (iter->flags & IOMAP_DONTCACHE)
> > +		fgp |= FGP_DONTCACHE;
> >  	fgp |= fgf_set_order(len);
> > 
> >  	return __filemap_get_folio(iter->inode->i_mapping, pos >> PAGE_SHIFT,
> > @@ -1034,6 +1036,8 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
> > 
> >  	if (iocb->ki_flags & IOCB_NOWAIT)
> >  		iter.flags |= IOMAP_NOWAIT;
> > +	if (iocb->ki_flags & IOCB_DONTCACHE)
> > +		iter.flags |= IOMAP_DONTCACHE;
> > 
> >  	while ((ret = iomap_iter(&iter, ops)) > 0)
> >  		iter.processed = iomap_write_iter(&iter, i);
> > diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> > index 75bf54e76f3b..26b0dbe23e62 100644
> > --- a/include/linux/iomap.h
> > +++ b/include/linux/iomap.h
> > @@ -183,6 +183,7 @@ struct iomap_folio_ops {
> >  #define IOMAP_DAX		0
> >  #endif /* CONFIG_FS_DAX */
> >  #define IOMAP_ATOMIC		(1 << 9)
> > +#define IOMAP_DONTCACHE		(1 << 10)
> > 
> >  struct iomap_ops {
> >  	/*
> > --
> > 2.47.2
> > 
