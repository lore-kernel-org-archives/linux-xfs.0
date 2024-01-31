Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DCF21341
	for <linux-xfs@vger.kernel.org>; Wed, 31 Jan 2024 03:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706672994; cv=none; b=MnbmR4i6lX+jk3D15VuTI7jGja3le7yZijNt+vwSQap8Ara1862XAxKyBQmNRjDNUrlxhJLyicagc4mMRDWe1WJgisqfc/r7eA61HXQDhb+kzjcxO4aM5uCVHTBN92RtsAe2XyfL6idBIisC+lgfgH26S5SV9nNiFqnMq5k5QMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706672994; c=relaxed/simple;
	bh=Wiy82803vjuQGhT1L1REFL3zBjeucPnSlUdt9RIH+fY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nK1wxvCeaB0BE5RDnHR4L9HyFyvCrzJH2Z9DF2Th8ZUxuTE5DlT/pCy4ABEFv/k/Qoa9EgwHDD/VWLwlTuk0SThvBGEhnFV+K46n2dXuR56OAZfXrkodGdVSN+pS8/EzDgwCnsNJx3hf7tCl9Mkbo2EuijPa0zM2ctNKGUzWZkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nsCcxThu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nsCcxThu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5F9C433C7;
	Wed, 31 Jan 2024 03:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706672993;
	bh=Wiy82803vjuQGhT1L1REFL3zBjeucPnSlUdt9RIH+fY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nsCcxThu0jN2LM9tD8s8EmoLS7T2j4Z9UsMBOspN7MGt4oJstOg0TDkmWDCdNSERv
	 Gb2mubfM8BqkAvqqVYxWVgSxfPO9LvvW5HzdFTc4AYPNCh7wR0XirCPWjY0ULl85Vm
	 2qNC76Kfh5OemHTl7klbzB0ubWJtaBxqfl3MPpluQmAnIrd3jOMe/Hyas6xNTGmeKu
	 vuMNFmsd4bJIEZznd9PI0Az+stKp5zaeNWC/g1As+PZ5Ajy8fd7MoOO6nzKfztzwVX
	 QsCX76nmN5Kt+iuRjA3HOPHJ5ebhU/DH/CZYNiViQEzITMXskwG+E1ajDE4hBbdp18
	 s8AJltIOeud+Q==
Date: Tue, 30 Jan 2024 19:49:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6.6 CANDIDATE v1 00/21] xfs backports for 6.6.y (from
 v6.7)
Message-ID: <20240131034953.GK1371843@frogsfrogsfrogs>
References: <20240130234419.45896-1-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130234419.45896-1-catherine.hoang@oracle.com>

On Tue, Jan 30, 2024 at 03:43:58PM -0800, Catherine Hoang wrote:
> Hi all,
> 
> This series contains backports for 6.6 from the 6.7 release. Tested on 30
> runs of kdevops with the following configurations:
> 
> 1. CRC
> 2. No CRC (512 and 4k block size)
> 3. Reflink (1k and 4k block size)
> 4. Reflink without rmapbt
> 5. External log device
> 
> The patches included are from the following series:
> 
> [PATCHSET v1.1 0/4] xfs: minor bugfixes for rt stuff
> xfs: bump max fsgeom struct version
> xfs: hoist freeing of rt data fork extent mappings
> xfs: prevent rt growfs when quota is enabled
> xfs: rt stubs should return negative errnos when rt disabled
> 
> [PATCHSET v1.1 0/8] xfs: clean up realtime type usage
> xfs: fix units conversion error in xfs_bmap_del_extent_delay
> xfs: make sure maxlen is still congruent with prod when rounding down
> 
> [PATCH v6] xfs: introduce protection for drop nlink
> 
> [PATCH v2] xfs: handle nimaps=0 from xfs_bmapi_write in xfs_alloc_file_space
> 
> [PATCH v4] xfs: allow read IO and FICLONE to run concurrently
> 
> [PATCH v3 0/3] xfs: fix two problem when recovery intents fails
> xfs: factor out xfs_defer_pending_abort
> xfs: abort intent items when recovery intents fail
> 
> [PATCH] xfs: only remap the written blocks in xfs_reflink_end_cow_extent
> 
> [PATCH v3] xfs: up(ic_sema) if flushing data device fails
> 
> [PATCH v3] xfs: fix internal error from AGFL exhaustion
> 
> [PATCH] xfs: fix again select in kconfig XFS_ONLINE_SCRUB_STATS
> 
> [PATCH 0/2] xfs: fix recovery corruption on s390 w/ nrext64
> xfs: inode recovery does not validate the recovered inode
> 
> [PATCHSET 0/2] xfs: dquot recovery validation strengthening
> xfs: clean up dqblk extraction
> xfs: dquot recovery does not validate the recovered dquot
> 
> add and use a per-mapping stable writes flag v2
> filemap: add a per-mapping stable writes flag 
> xfs: clean up FS_XFLAG_REALTIME handling in xfs_ioctl_setattr_xflags 
> xfs: respect the stable writes flag on the RT device

Looks good to me, though you ought to update MAINTAINERS to list
yourself as the maintainer of the 6.6LTS branch.

--D

> 
> 
> Anthony Iliopoulos (1):
>   xfs: fix again select in kconfig XFS_ONLINE_SCRUB_STATS
> 
> Catherine Hoang (1):
>   xfs: allow read IO and FICLONE to run concurrently
> 
> Cheng Lin (1):
>   xfs: introduce protection for drop nlink
> 
> Christoph Hellwig (5):
>   xfs: handle nimaps=0 from xfs_bmapi_write in xfs_alloc_file_space
>   xfs: only remap the written blocks in xfs_reflink_end_cow_extent
>   filemap: add a per-mapping stable writes flag
>   xfs: clean up FS_XFLAG_REALTIME handling in xfs_ioctl_setattr_xflags
>   xfs: respect the stable writes flag on the RT device
> 
> Darrick J. Wong (8):
>   xfs: bump max fsgeom struct version
>   xfs: hoist freeing of rt data fork extent mappings
>   xfs: prevent rt growfs when quota is enabled
>   xfs: rt stubs should return negative errnos when rt disabled
>   xfs: fix units conversion error in xfs_bmap_del_extent_delay
>   xfs: make sure maxlen is still congruent with prod when rounding down
>   xfs: clean up dqblk extraction
>   xfs: dquot recovery does not validate the recovered dquot
> 
> Dave Chinner (1):
>   xfs: inode recovery does not validate the recovered inode
> 
> Leah Rumancik (1):
>   xfs: up(ic_sema) if flushing data device fails
> 
> Long Li (2):
>   xfs: factor out xfs_defer_pending_abort
>   xfs: abort intent items when recovery intents fail
> 
> Omar Sandoval (1):
>   xfs: fix internal error from AGFL exhaustion
> 
>  fs/inode.c                      |  2 ++
>  fs/xfs/Kconfig                  |  2 +-
>  fs/xfs/libxfs/xfs_alloc.c       | 27 ++++++++++++--
>  fs/xfs/libxfs/xfs_bmap.c        | 21 +++--------
>  fs/xfs/libxfs/xfs_defer.c       | 28 +++++++++------
>  fs/xfs/libxfs/xfs_defer.h       |  2 +-
>  fs/xfs/libxfs/xfs_inode_buf.c   |  3 ++
>  fs/xfs/libxfs/xfs_rtbitmap.c    | 33 +++++++++++++++++
>  fs/xfs/libxfs/xfs_sb.h          |  2 +-
>  fs/xfs/xfs_bmap_util.c          | 24 +++++++------
>  fs/xfs/xfs_dquot.c              |  5 +--
>  fs/xfs/xfs_dquot_item_recover.c | 21 +++++++++--
>  fs/xfs/xfs_file.c               | 63 ++++++++++++++++++++++++++-------
>  fs/xfs/xfs_inode.c              | 24 +++++++++++++
>  fs/xfs/xfs_inode.h              | 17 +++++++++
>  fs/xfs/xfs_inode_item_recover.c | 14 +++++++-
>  fs/xfs/xfs_ioctl.c              | 30 ++++++++++------
>  fs/xfs/xfs_iops.c               |  7 ++++
>  fs/xfs/xfs_log.c                | 23 ++++++------
>  fs/xfs/xfs_log_recover.c        |  2 +-
>  fs/xfs/xfs_reflink.c            |  5 +++
>  fs/xfs/xfs_rtalloc.c            | 33 +++++++++++++----
>  fs/xfs/xfs_rtalloc.h            | 27 ++++++++------
>  include/linux/pagemap.h         | 17 +++++++++
>  mm/page-writeback.c             |  2 +-
>  25 files changed, 331 insertions(+), 103 deletions(-)
> 
> -- 
> 2.39.3
> 
> 
