Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483851292D8
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 04:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425921; cv=none; b=YlDs2UabhLFlX6fIL8ftcr6tjerowa32+3l2wlI30rHbtR1aelzmreHFYc5XWGQjlDxGzDVbDIN4jD0S2WTzta6AU7v7fJ/Aqmbb6N7NzeM+aS4nLmT6r1LO1RoTbUf8O69MJufTk87oypqB3QqvRsDDmgQPxuzY9t1JDUo1B1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425921; c=relaxed/simple;
	bh=T2VI1I4UGK7R1vop/ezMfJnC6h99eQyUKZaaT9iLn6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iD9cH/djgRIEppDUsuddrGuT69tpmwrmMvZS8fYwYSrHBmQCZubc7hHT5YEzTIzIZN4ul8G/lg/oJy8HEgqzk8VAcv90W/91h7pBkfmZSFbFnh+aQdIliAFnR6y9b3gvYnTUWOkSWH7oYoVzhQ1FXje/g+RdwdSe7N1m4XX8wnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oVlByy+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oVlByy+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC490C433F1;
	Tue, 26 Mar 2024 04:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425920;
	bh=T2VI1I4UGK7R1vop/ezMfJnC6h99eQyUKZaaT9iLn6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oVlByy+jjSW185DR+UXkOLO40el9vuZFh0BixjcVw7Sq0x9+NPnNWLUAp3PJYSSBJ
	 Nn70jaByWwg+L6hlbmJoR+A+2WdPxzmGHIdeTojz4KiTUAfRACPVElyHtDzT+GdyUv
	 +lU2zLPXnSvCKBzjrc5Bg7ucCq1AwG91iYs+/mOyM4H2Tid3GILQETgby0Dyx/65aI
	 QFTIFowbbd8C3Gg4XY0aTV9THG5k5fQNUwz3tnqbZuGT5NOuYlBt8qiF/AfnR8t2MU
	 fYU5GDVhGOIcoqTFJIMY3LTRsyqZGjkgMBd1VyBcik0ldjtZolEkGjaE/tobfH4DoU
	 sXo42WFy6z2cA==
Date: Mon, 25 Mar 2024 21:05:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6.6 CANDIDATE 00/24] xfs backports for 6.6.y (from 6.8)
Message-ID: <20240326040520.GH6390@frogsfrogsfrogs>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>

On Mon, Mar 25, 2024 at 03:07:00PM -0700, Catherine Hoang wrote:
> Hi all,
> 
> This series contains backports for 6.6 from the 6.8 release. Tested on
> 30 runs of kdevops with the following configurations:
> 
> 1. CRC
> 2. No CRC (512 and 4k block size)
> 3. Reflink (1K and 4k block size)
> 4. Reflink without rmapbt
> 4. External log device
> 
> Note that patch 1-2 are backported as dependencies of patch 8, 10, and
> 24.

Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Andrey Albershteyn (1):
>   xfs: reset XFS_ATTR_INCOMPLETE filter on node removal
> 
> Christoph Hellwig (1):
>   xfs: consider minlen sized extents in xfs_rtallocate_extent_block
> 
> Darrick J. Wong (16):
>   xfs: move the xfs_rtbitmap.c declarations to xfs_rtbitmap.h
>   xfs: convert rt bitmap extent lengths to xfs_rtbxlen_t
>   xfs: don't leak recovered attri intent items
>   xfs: use xfs_defer_pending objects to recover intent items
>   xfs: pass the xfs_defer_pending object to iop_recover
>   xfs: transfer recovered intent item ownership in ->iop_recover
>   xfs: make rextslog computation consistent with mkfs
>   xfs: fix 32-bit truncation in xfs_compute_rextslog
>   xfs: don't allow overly small or large realtime volumes
>   xfs: make xchk_iget safer in the presence of corrupt inode btrees
>   xfs: remove unused fields from struct xbtree_ifakeroot
>   xfs: recompute growfsrtfree transaction reservation while growing rt
>     volume
>   xfs: fix an off-by-one error in xreap_agextent_binval
>   xfs: force all buffers to be written during btree bulk load
>   xfs: add missing nrext64 inode flag check to scrub
>   xfs: remove conditional building of rt geometry validator functions
> 
> Dave Chinner (1):
>   xfs: initialise di_crc in xfs_log_dinode
> 
> Eric Sandeen (1):
>   xfs: short circuit xfs_growfs_data_private() if delta is zero
> 
> Jiachen Zhang (1):
>   xfs: ensure logflagsp is initialized in xfs_bmap_del_extent_real
> 
> Long Li (2):
>   xfs: add lock protection when remove perag from radix tree
>   xfs: fix perag leak when growfs fails
> 
> Zhang Tianci (1):
>   xfs: update dir3 leaf block metadata after swap
> 
>  fs/xfs/libxfs/xfs_ag.c            |  36 +++++++--
>  fs/xfs/libxfs/xfs_ag.h            |   2 +
>  fs/xfs/libxfs/xfs_attr.c          |   6 +-
>  fs/xfs/libxfs/xfs_bmap.c          |  75 ++++++++-----------
>  fs/xfs/libxfs/xfs_btree_staging.c |   4 +-
>  fs/xfs/libxfs/xfs_btree_staging.h |   6 --
>  fs/xfs/libxfs/xfs_da_btree.c      |   7 ++
>  fs/xfs/libxfs/xfs_defer.c         | 105 +++++++++++++++++++-------
>  fs/xfs/libxfs/xfs_defer.h         |   5 ++
>  fs/xfs/libxfs/xfs_format.h        |   2 +-
>  fs/xfs/libxfs/xfs_log_recover.h   |   5 ++
>  fs/xfs/libxfs/xfs_rtbitmap.c      |   2 +
>  fs/xfs/libxfs/xfs_rtbitmap.h      |  83 +++++++++++++++++++++
>  fs/xfs/libxfs/xfs_sb.c            |  20 ++++-
>  fs/xfs/libxfs/xfs_sb.h            |   2 +
>  fs/xfs/libxfs/xfs_types.h         |  13 ++++
>  fs/xfs/scrub/common.c             |   6 +-
>  fs/xfs/scrub/common.h             |  25 +++++++
>  fs/xfs/scrub/fscounters.c         |   2 +-
>  fs/xfs/scrub/inode.c              |   8 +-
>  fs/xfs/scrub/reap.c               |   2 +-
>  fs/xfs/scrub/rtbitmap.c           |   3 +-
>  fs/xfs/scrub/rtsummary.c          |   3 +-
>  fs/xfs/scrub/trace.h              |   3 +-
>  fs/xfs/xfs_attr_item.c            |  23 +++---
>  fs/xfs/xfs_bmap_item.c            |  14 ++--
>  fs/xfs/xfs_buf.c                  |  44 ++++++++++-
>  fs/xfs/xfs_buf.h                  |   1 +
>  fs/xfs/xfs_extfree_item.c         |  14 ++--
>  fs/xfs/xfs_fsmap.c                |   2 +-
>  fs/xfs/xfs_fsops.c                |   9 ++-
>  fs/xfs/xfs_inode_item.c           |   3 +
>  fs/xfs/xfs_log.c                  |   1 +
>  fs/xfs/xfs_log_priv.h             |   1 +
>  fs/xfs/xfs_log_recover.c          | 118 ++++++++++++++++--------------
>  fs/xfs/xfs_refcount_item.c        |  13 ++--
>  fs/xfs/xfs_rmap_item.c            |  14 ++--
>  fs/xfs/xfs_rtalloc.c              |  14 +++-
>  fs/xfs/xfs_rtalloc.h              |  73 ------------------
>  fs/xfs/xfs_trans.h                |   4 +-
>  40 files changed, 492 insertions(+), 281 deletions(-)
>  create mode 100644 fs/xfs/libxfs/xfs_rtbitmap.h
> 
> -- 
> 2.39.3
> 
> 
