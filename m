Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836E37EEED
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 13:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716299945; cv=none; b=agdYFpcJIkD5iuwMAws9jZo4Z5wRGZUjFP6GwhOyeJK570pYGj3fgJKqK/N8S0iilOFdvQRTLibDoVQZN00AJhhV5XNTTGeTWpOBQU3T4a7dCczw4ORt+705e+h5OrMjtRSHmbocoh85QTFEC8ZS/Bz/uwOMZeoRQ1FmLezPvLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716299945; c=relaxed/simple;
	bh=UEZ0WMZ4XArP6KLLkJ6qgnUPdgmhbpCZWin5M8esxRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VmHoN9d61+9WPm8i+JeNrCPco942wtvuCVg3eM62MVBHyd3VXdC1yE4HV697qDNAo2ZtVAx+IXNJqKazbBMcJVrG/APwj+VP41UNNWEju0w2J9nWO5GGn9Ax+HETwbrMILH19O3EHgwBC+P0jrU22FYSGDXRxP04DWsiwNpPXgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=m3avxQXa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m3avxQXa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=APnWJvM6F7iuTj7cj3iFBMrZlAdC5FbnyIBf45t3ZyA=; b=m3avxQXaP0tgoNY8FCZdOfu2b9
	5pVJ++Eybowa+Ujms+GJ4v4wGCkZdx9boBZY6RKVavWgXpo0bzbhSlAVB4UiE7zgviT5Yd0v5D0NM
	uGY6d7g0CZpWh5tuNJmR3VepWmMCBlpnnfiA2ML94H6/pEI89OkCVKXndblOuHtiUe1PE9CrzQKIn
	I6l8VxSJAyu1LBa1ArSuPFWin817TkbXuonXXTtU4dLtSDNKX+1oaPvL+j5M5ut1FXN3yRpAu7qUd
	jCgJQrjR7tCCJNlzZVIz5GYalSCTwnMBasbdxNdwTFmDvYealChs5j7xCRmfCNkCRroHcMgN3wdiW
	Ziq3QS2Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9Q19-000000004vd-0GE9;
	Tue, 21 May 2024 13:59:03 +0000
Date: Tue, 21 May 2024 06:59:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: allow symlinks with short remote targets
Message-ID: <Zkyop1TZclqNIpRs@infradead.org>
References: <20240521010447.GM25518@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521010447.GM25518@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, May 20, 2024 at 06:04:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> An internal user complained about log recovery failing on a symlink
> ("Bad dinode after recovery") with the following (excerpted) format:
> 
> core.magic = 0x494e
> core.mode = 0120777
> core.version = 3
> core.format = 2 (extents)
> core.nlinkv2 = 1
> core.nextents = 1
> core.size = 297
> core.nblocks = 1
> core.naextents = 0
> core.forkoff = 0
> core.aformat = 2 (extents)
> u3.bmx[0] = [startoff,startblock,blockcount,extentflag]
> 0:[0,12,1,0]
> 
> This is a symbolic link with a 297-byte target stored in a disk block,
> which is to say this is a symlink with a remote target.  The forkoff is
> 0, which is to say that there's 512 - 176 == 336 bytes in the inode core
> to store the data fork.
> 
> Eventually, testing of generic/388 failed with the same inode corruption
> message during inode recovery.  In writing a debugging patch to call
> xfs_dinode_verify on dirty inode log items when we're committing
> transactions, I observed that xfs/298 can reproduce the problem quite
> quickly.
> 
> xfs/298 creates a symbolic link, adds some extended attributes, then
> deletes them all.  The test failure occurs when the final removexattr
> also deletes the attr fork because that does not convert the remote
> symlink back into a shortform symlink.  That is how we trip this test.
> The only reason why xfs/298 only triggers with the debug patch added is
> that it deletes the symlink, so the final iflush shows the inode as
> free.
> 
> I wrote a quick fstest to emulate the behavior of xfs/298, except that
> it leaves the symlinks on the filesystem after inducing the "corrupt"
> state.  Kernels going back at least as far as 4.18 have written out
> symlink inodes in this manner and prior to 1eb70f54c445f they did not
> object to reading them back in.
> 
> Because we've been writing out inodes this way for quite some time, the
> only way to fix this is to relax the check for symbolic links.
> Directories don't have this problem because di_size is bumped to
> blocksize during the sf->data conversion.
> 
> Fixes: 1eb70f54c445f ("xfs: validate inode fork size against fork format")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 2305e64a4d5a9..88f4f2a1855ae 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -375,16 +375,27 @@ xfs_dinode_verify_fork(
>  	 * For fork types that can contain local data, check that the fork
>  	 * format matches the size of local data contained within the fork.
>  	 *
> +	 * A symlink with a small target can have a data fork can be in extents

This doesn't parse.  Do you mean something like:

	 * Even a symlink with a target small enough to fit into the inode can
	 * be stored in extent format if ...

?

The existing parts of the comment could also use a bit of an overhaul
and be moved closer to the code they are documenting while you are at
it.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
