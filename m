Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F7D2E7391
	for <linux-xfs@vger.kernel.org>; Fri, 29 May 2026 04:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780029195; cv=none; b=u1onj6q/NwOHVcCLR/9TTzmeVczkf/mF7eJbmtr04I9WIOepn+tuY8tXIahn620Yppi/VwHepZ7mvmbJ7gmF3EhADIbhEagCE8uNfAs43gaoVfcV3L4LFE6niLBLhuVbkAiWMV6tVYRPb+DmBcWzYU6OGIQOBNxtZ2GV9ZyuvQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780029195; c=relaxed/simple;
	bh=MqCLGcLtYL7b7+UXxjgN6mxgMoOiYdrRW0vdRr8/62Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FfGb+X12q118mlSuILcfHEn8qGEDP3AFE2fFE1/zVKSa7c/cSV/NrbAu1SdYsUYXOfTTY42CrXrpLUqBPB0vgexYtFVC1mpqbFpBwC3G8LFDs+ph/yY7xRrn023SF1hYE5SBm6c2yLwmOkOd4zyj72OKrXB9ctIvRolsZIXto6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lvvDiOUg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lvvDiOUg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E498F1F00893;
	Fri, 29 May 2026 04:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780029194;
	bh=pgpsBIduSmsSHDrKI23BrEZlAPpYhQEx/QMoR3u3AeM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lvvDiOUguaTB3TSAgVg9A/Z2jtUla3Q0M7syp9yAlvM9qbMFVxFtwAxKsvE8cudd5
	 uWEckr7aFg7wxnFh/MU232lKgqusApZtDIdfJaF79dLO4zHt2fwpP3N6uBoMZt339o
	 w33VRViN7seHVgeAqJtB4EzWj92ZmEBMld20IdweiBtPADTuUB8ywGkAc62HjMmqOh
	 mpv4vAuytiXNIDjdiNMf9F/nQNOEBksiDMkSHd5kvnk7KsW4ZdDteIGpHk/AxKTThS
	 X8s2kwic/X9Ft1x+2Hlc3Ep8UrHG7xZQxgEAFkgaOZrdjKfTc0YJTkVRRG6fAwP0bi
	 GYCu11/CI+jWg==
Date: Thu, 28 May 2026 21:33:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: remove struct xfs_inode.i_ino
Message-ID: <20260529043313.GL6078@frogsfrogsfrogs>
References: <20260515135103.4042407-1-hch@lst.de>
 <20260528052444.GK6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528052444.GK6078@frogsfrogsfrogs>

On Wed, May 27, 2026 at 10:24:44PM -0700, Darrick J. Wong wrote:
> On Fri, May 15, 2026 at 03:50:21PM +0200, Christoph Hellwig wrote:
> > Hi all,
> > 
> > now that the VFS inode i_ino field is always a u64, there is no need
> > to duplicate the inode number in the XFS inode.
> > 
> > This series first adds a few helpers to reduce i_ino reference, and
> > then switches the rest of the code over.  A new I_INO helper is added
> > to shorten the dereference and to make userspace porting easier.
> > 
> > After this and the rw_semaphore shrink that went into 7.1-rc, it might
> > be time to look into re-packing the xfs_inode, but that is left for
> > another series.
> 
> Mechanically these patches all look ok to me, aside from my question
> about why not use static inline helpers instead of macros.

...and now that you've answered those questions, I'm satisfied that this
series is all good to go (to the QA system for further testing), so:

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> --D
> 
> > Diffstat:
> >  libxfs/xfs_attr.c             |    2 
> >  libxfs/xfs_attr_leaf.c        |    2 
> >  libxfs/xfs_bmap.c             |   20 ++----
> >  libxfs/xfs_bmap_btree.c       |    8 +-
> >  libxfs/xfs_btree.c            |   18 ++---
> >  libxfs/xfs_btree_staging.c    |    2 
> >  libxfs/xfs_da_btree.c         |    2 
> >  libxfs/xfs_dir2.c             |   44 +++++++-------
> >  libxfs/xfs_dir2_node.c        |    2 
> >  libxfs/xfs_dir2_sf.c          |    4 -
> >  libxfs/xfs_exchmaps.c         |    8 +-
> >  libxfs/xfs_format.h           |    6 +
> >  libxfs/xfs_ialloc.c           |    4 -
> >  libxfs/xfs_inode_buf.c        |    4 -
> >  libxfs/xfs_inode_fork.c       |    6 -
> >  libxfs/xfs_inode_util.c       |   13 +---
> >  libxfs/xfs_metadir.c          |    2 
> >  libxfs/xfs_parent.c           |    8 +-
> >  libxfs/xfs_parent.h           |    2 
> >  libxfs/xfs_rmap.c             |    6 -
> >  libxfs/xfs_rmap.h             |    4 +
> >  libxfs/xfs_rtbitmap.c         |    4 -
> >  libxfs/xfs_rtrefcount_btree.c |    4 -
> >  libxfs/xfs_rtrmap_btree.c     |    4 -
> >  libxfs/xfs_symlink_remote.c   |    6 -
> >  scrub/agheader_repair.c       |   20 ++----
> >  scrub/attr.c                  |    4 -
> >  scrub/attr_repair.c           |   16 ++---
> >  scrub/bmap.c                  |   24 +++----
> >  scrub/bmap_repair.c           |    8 +-
> >  scrub/common.c                |   26 ++++----
> >  scrub/common.h                |    6 +
> >  scrub/cow_repair.c            |    3 
> >  scrub/dabtree.c               |    4 -
> >  scrub/dir.c                   |   24 +++----
> >  scrub/dir_repair.c            |   42 ++++++-------
> >  scrub/dirtree.c               |   24 +++----
> >  scrub/dirtree_repair.c        |    4 -
> >  scrub/findparent.c            |   33 +++++-----
> >  scrub/inode.c                 |   18 ++---
> >  scrub/inode_repair.c          |    5 -
> >  scrub/iscan.c                 |    2 
> >  scrub/listxattr.c             |   10 +--
> >  scrub/metapath.c              |   16 ++---
> >  scrub/newbt.c                 |    8 --
> >  scrub/nlinks.c                |   34 +++++------
> >  scrub/nlinks_repair.c         |    6 -
> >  scrub/orphanage.c             |   10 +--
> >  scrub/parent.c                |   31 ++++------
> >  scrub/parent_repair.c         |   18 ++---
> >  scrub/quotacheck.c            |    2 
> >  scrub/readdir.c               |   12 +--
> >  scrub/reap.c                  |    5 -
> >  scrub/repair.c                |    2 
> >  scrub/rmap_repair.c           |    2 
> >  scrub/rtbitmap.c              |   16 ++---
> >  scrub/rtbitmap_repair.c       |    2 
> >  scrub/rtrefcount.c            |    2 
> >  scrub/rtrefcount_repair.c     |    2 
> >  scrub/rtrmap.c                |    3 
> >  scrub/rtrmap_repair.c         |    4 -
> >  scrub/rtsummary.c             |   14 ++--
> >  scrub/rtsummary_repair.c      |    2 
> >  scrub/scrub.c                 |    2 
> >  scrub/symlink_repair.c        |    8 +-
> >  scrub/tempfile.c              |    2 
> >  scrub/trace.c                 |    2 
> >  scrub/trace.h                 |  116 ++++++++++++++++++-------------------
> >  xfs_aops.c                    |    2 
> >  xfs_attr_item.c               |    4 -
> >  xfs_attr_list.c               |   12 +--
> >  xfs_bmap_item.c               |    4 -
> >  xfs_bmap_util.c               |    4 -
> >  xfs_dir2_readdir.c            |    4 -
> >  xfs_error.c                   |    2 
> >  xfs_exchmaps_item.c           |    4 -
> >  xfs_exchrange.c               |    4 -
> >  xfs_export.c                  |    8 +-
> >  xfs_filestream.c              |    6 -
> >  xfs_handle.c                  |    4 -
> >  xfs_healthmon.c               |    6 -
> >  xfs_icache.c                  |   56 +++++++++---------
> >  xfs_inode.c                   |   37 +++++-------
> >  xfs_inode.h                   |   19 ++----
> >  xfs_inode_item.c              |    8 +-
> >  xfs_inode_item_recover.c      |    4 -
> >  xfs_ioctl.c                   |    2 
> >  xfs_iomap.c                   |    4 -
> >  xfs_iops.c                    |    3 
> >  xfs_iunlink_item.c            |    2 
> >  xfs_mount.c                   |    2 
> >  xfs_qm.c                      |   10 +--
> >  xfs_quotaops.c                |    2 
> >  xfs_reflink.c                 |    4 -
> >  xfs_symlink.c                 |    6 -
> >  xfs_trace.h                   |  129 ++++++++++++++++++++----------------------
> >  xfs_trans.c                   |    2 
> >  xfs_trans_dquot.c             |    6 -
> >  xfs_xattr.c                   |    2 
> >  99 files changed, 564 insertions(+), 577 deletions(-)
> > 
> 
