Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7EC13343F
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 18:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713291132; cv=none; b=TvDNbUVgocEsdnM+i4UAIocWqDvl56CpF0/7VrJyOdmtnkCQLa/aekGmVU36Q8Qj0rb068gWPLxyRxUmCC9SwAXqXbecYCPMRZlUy1q11vVkF+dKasD2vlB9Wxwd5DirRTCqlC+TVZDaG2IN5cakPLjrKgj6nJt5LcB21nYdLm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713291132; c=relaxed/simple;
	bh=aCERMGvFGS0AUyVI/QF7HjmXU4ock0X+h8O3hrS8mRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s+6vIFZcZ30sfhyiSsDjCT4wx9G98xzYXUwm2WBSxjOsnrz+jqefL+hsI9X93aTSsXB56erRvgeA/uWZjzpsYujE6+NG7lz4OSBA4UqbaXTjI/9Bxfosuk4FU4eLSR/CS9m6DFzrqp3vwzJE8Z+6ppQeUeGOnN9ieEyhp/pLksM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OYpo6n0n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OYpo6n0n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B3FC113CE;
	Tue, 16 Apr 2024 18:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713291131;
	bh=aCERMGvFGS0AUyVI/QF7HjmXU4ock0X+h8O3hrS8mRQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OYpo6n0nBETAVzmaox1kejC/68F0EIUXni4xK0f2vq+Pk1H/nYWYSpF1lykCaSUj2
	 egBI/clT9Or3+yxIguMkHsVbFYCrSNLTK0o4XP2WACch5OJ9LTzdvA/Z4CljM88fpc
	 /rk+s4EE0D5aRFpbGX6hvmqNZbfmkgba5ia3YJ4pXXjIwmp9erxPalwErEdxLgigOz
	 EJjXYxCB7OrwiZ+UlOHj2bsY0tAbNlJI1RxvRbwOfP2Qc1E8zi2G4rObmAW5n4xw6s
	 5SBT5GBJw4dOIjzUitbrGNx2abwJIVfyeh2ag8RXhFI6lwnFFGV9KTv11C1W42UNKV
	 PFFLUnOhXiRCA==
Date: Tue, 16 Apr 2024 11:12:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christoph Hellwig <hch@infradead.org>, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org, catherine.hoang@oracle.com
Subject: Re: [PATCH 26/31] xfs: add parent pointer ioctls
Message-ID: <20240416181211.GV11948@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
 <171323028211.251715.6240463208868345727.stgit@frogsfrogsfrogs>
 <Zh4Kv9kTzBbgBxKC@infradead.org>
 <20240416175908.GU11948@frogsfrogsfrogs>
 <20240416180826.GA10307@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416180826.GA10307@lst.de>

On Tue, Apr 16, 2024 at 08:08:26PM +0200, Christoph Hellwig wrote:
> On Tue, Apr 16, 2024 at 10:59:08AM -0700, Darrick J. Wong wrote:
> > On Mon, Apr 15, 2024 at 10:21:03PM -0700, Christoph Hellwig wrote:
> > > > +	if (memcmp(&handle->ha_fsid, mp->m_fixedfsid, sizeof(struct xfs_fsid)))
> > > > +		return -ESTALE;
> > > > +
> > > > +	if (handle->ha_fid.fid_len != xfs_filehandle_fid_len())
> > > > +		return -EINVAL;
> > > 
> > > Maybe we should just stash the fid without the fsid?  The check for a
> > > match fsid when userspace already had to resolve it to even call the
> > > ioctl is a bit silly.
> > 
> > Remember a few revisions ago when this ioctl only returned the raw fid
> > information?  At the time, I didn't want to bloat struct parent_rec with
> > the full handle information, but then I changed it to export a full
> > handle.  When I went to update libfrog/getparents.c, I realized that
> > giving full handles to userspace is a much better interface because any
> > code that's trying to walk up the directory tree to compute the file
> > path can simply call getparents again with the handle it has been given.
> > 
> > It's much more ergonomic if userspace programs don't need to know how to
> > construct handles from partial information they has been given.  If a
> > calling program wants to open the parent directory, it can call
> > open_by_fshandle directly:
> 
> Yeah.  I think I actually suggested that :)  So I'll take that back.
> That just leaves us with the question if we want to validate the
> fsid here and diverge from the mormal handle ops or not.  I think
> I'd prefer behaving the same as the other handle ops just to avoid
> confusion.

Yeah, let's drop the fsid memcmp.  Now I have:

/* Convert handle already copied to kernel space into an xfs_inode. */
static struct xfs_inode *
xfs_khandle_to_inode(
	struct file		*file,
	struct xfs_handle	*handle)
{
	struct xfs_inode	*ip = XFS_I(file_inode(file));
	struct xfs_mount	*mp = ip->i_mount;
	struct inode		*inode;

	if (!S_ISDIR(VFS_I(ip)->i_mode))
		return ERR_PTR(-ENOTDIR);

	if (handle->ha_fid.fid_len != xfs_filehandle_fid_len())
		return ERR_PTR(-EINVAL);

	inode = xfs_nfs_get_inode(mp->m_super, handle->ha_fid.fid_ino,
			handle->ha_fid.fid_gen);
	if (IS_ERR(inode))
		return ERR_CAST(inode);

	return XFS_I(inode);
}

and later:

	/*
	 * We don't use exportfs_decode_fh because it does too much work here.
	 * If the handle refers to a directory, the exportfs code will walk
	 * upwards through the directory tree to connect the dentries to the
	 * root directory dentry.  For GETPARENTS we don't care about that
	 * because we're not actually going to open a file descriptor; we only
	 * want to open an inode and read its parent pointers.
	 *
	 * Note that xfs_scrub uses GETPARENTS to log that it will try to fix a
	 * corrupted file's metadata.  For this usecase we would really rather
	 * userspace single-step the path reconstruction to avoid loops or
	 * other strange things if the directory tree is corrupt.
	 */
	gpx.ip = xfs_khandle_to_inode(file, handle);
	if (IS_ERR(gpx.ip))
		return PTR_ERR(gpx.ip);

--D
