Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1BF19C55E;
	Thu,  6 Feb 2025 22:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738880993; cv=none; b=XJYUY6HJNvOnLgM2Cvj+HKXSGwRVhYcYtTigz+2UlrWjHg8/bwf339PpckFDF4DEzweptjIdvP6w8dsi3AQP08d+cQy9Tp34/QQ00lL1m/9+mfD2v1JkjvEFVLYhAtrP3eZ0I4HQ1b6hrcxfRAlaBlY25qpzJN0eGqBWT7O/gdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738880993; c=relaxed/simple;
	bh=/PLIPgyGBzrsuvtgvd/c6lZJZiW64Jw51aLGkg/HfTo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bSA+VUISupeEVdlgIe36K+RPCyObnYRxnQ4EirDmbJ9ayMCgcvgq6NFcdK2NT2Blh4ebdjy8+yRkpE28QqfhMCX2PhIQO8NQi2zxh6dgCaCZOAl74J2JzpWvq1jRfJK0gUPbdQd7EW5Aw6ooyczmlFJH3RWfwQo1CblQE5Z1i7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UcgXxijA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UcgXxijA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7392AC4CEDD;
	Thu,  6 Feb 2025 22:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738880992;
	bh=/PLIPgyGBzrsuvtgvd/c6lZJZiW64Jw51aLGkg/HfTo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UcgXxijASpIEK9dJTsTlU8TLFtkvhILhzOuKAw+4bLeiNhJIHaGKieF1zIoqiUBvT
	 ruXP8uC51SEH9cT72EIpa2UOm34gOVXirkhxLgf9gu2EMzqEJ7Kh6Rs9xFJUlJZ0oT
	 nqYbAHGhHdPC7zVAGGYy32E3TxumZTbr9j8BdZX2kL0WcnWid/d741VfScHvZveSKv
	 sdHa1tNKyWO3P4iBA9D9Xa9e9l3xtGfvUaqg6DzAjuLjKinMzU57M4USBa6enw278C
	 0ataHlcXysKdq2vxW1waGi2jxB0cRO7/s3gSOLuAfyKej8L1PEGakaQBv0M5kaCzua
	 4tNbT+jQAFa5w==
Date: Thu, 06 Feb 2025 14:29:51 -0800
Subject: [PATCHSET 2/5] xfsprogs: new libxfs code from kernel 6.14
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: david@fromorbit.com, alexjlzheng@tencent.com, chandanbabu@kernel.org,
 mtodorovac69@gmail.com, cem@kernel.org, dchinner@redhat.com,
 linux-kernel@vger.kernel.org, cmaiolino@redhat.com,
 linux-xfs@vger.kernel.org, hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
In-Reply-To: <20250206222122.GA21808@frogsfrogsfrogs>
References: <20250206222122.GA21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Port kernel libxfs code to userspace.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-sync-6.14
---
Commits in this patchset:
 * xfs: tidy up xfs_iroot_realloc
 * xfs: refactor the inode fork memory allocation functions
 * xfs: make xfs_iroot_realloc take the new numrecs instead of deltas
 * xfs: make xfs_iroot_realloc a bmap btree function
 * xfs: tidy up xfs_bmap_broot_realloc a bit
 * xfs: hoist the node iroot update code out of xfs_btree_new_iroot
 * xfs: hoist the node iroot update code out of xfs_btree_kill_iroot
 * xfs: add some rtgroup inode helpers
 * xfs: prepare to reuse the dquot pointer space in struct xfs_inode
 * xfs: simplify the xfs_rmap_{alloc,free}_extent calling conventions
 * xfs: support storing records in the inode core root
 * xfs: allow inode-based btrees to reserve space in the data device
 * xfs: introduce realtime rmap btree ondisk definitions
 * xfs: realtime rmap btree transaction reservations
 * xfs: add realtime rmap btree operations
 * xfs: prepare rmap functions to deal with rtrmapbt
 * xfs: add a realtime flag to the rmap update log redo items
 * xfs: pretty print metadata file types in error messages
 * xfs: support file data forks containing metadata btrees
 * xfs: add realtime reverse map inode to metadata directory
 * xfs: add metadata reservations for realtime rmap btrees
 * xfs: wire up a new metafile type for the realtime rmap
 * xfs: wire up rmap map and unmap to the realtime rmapbt
 * xfs: create routine to allocate and initialize a realtime rmap btree inode
 * xfs: report realtime rmap btree corruption errors to the health system
 * xfs: scrub the realtime rmapbt
 * xfs: scrub the metadir path of rt rmap btree files
 * xfs: online repair of realtime bitmaps for a realtime group
 * xfs: online repair of the realtime rmap btree
 * xfs: create a shadow rmap btree during realtime rmap repair
 * xfs: namespace the maximum length/refcount symbols
 * xfs: introduce realtime refcount btree ondisk definitions
 * xfs: realtime refcount btree transaction reservations
 * xfs: add realtime refcount btree operations
 * xfs: prepare refcount functions to deal with rtrefcountbt
 * xfs: add a realtime flag to the refcount update log redo items
 * xfs: add realtime refcount btree inode to metadata directory
 * xfs: add metadata reservations for realtime refcount btree
 * xfs: wire up a new metafile type for the realtime refcount
 * xfs: wire up realtime refcount btree cursors
 * xfs: create routine to allocate and initialize a realtime refcount btree inode
 * xfs: update rmap to allow cow staging extents in the rt rmap
 * xfs: compute rtrmap btree max levels when reflink enabled
 * xfs: allow inodes to have the realtime and reflink flags
 * xfs: recover CoW leftovers in the realtime volume
 * xfs: fix xfs_get_extsz_hint behavior with realtime alwayscow files
 * xfs: apply rt extent alignment constraints to CoW extsize hint
 * xfs: enable extent size hints for CoW operations
 * xfs: report realtime refcount btree corruption errors to the health system
 * xfs: scrub the realtime refcount btree
 * xfs: scrub the metadir path of rt refcount btree files
 * xfs: fix the entry condition of exact EOF block allocation optimization
 * xfs: mark xfs_dir_isempty static
 * xfs: remove XFS_ILOG_NONCORE
 * xfs: constify feature checks
 * xfs/libxfs: replace kmalloc() and memcpy() with kmemdup()
---
 include/kmem.h                |    9 
 include/libxfs.h              |    2 
 include/xfs_inode.h           |    5 
 include/xfs_mount.h           |   27 +
 include/xfs_trace.h           |    7 
 io/inject.c                   |    1 
 libxfs/Makefile               |    4 
 libxfs/libxfs_priv.h          |   11 
 libxfs/xfs_ag_resv.c          |    3 
 libxfs/xfs_attr.c             |    4 
 libxfs/xfs_bmap.c             |   47 +-
 libxfs/xfs_bmap_btree.c       |  111 ++++
 libxfs/xfs_bmap_btree.h       |    3 
 libxfs/xfs_btree.c            |  410 +++++++++++++---
 libxfs/xfs_btree.h            |   28 +
 libxfs/xfs_btree_mem.c        |    1 
 libxfs/xfs_btree_staging.c    |   10 
 libxfs/xfs_defer.h            |    2 
 libxfs/xfs_dir2.c             |    9 
 libxfs/xfs_dir2.h             |    1 
 libxfs/xfs_errortag.h         |    4 
 libxfs/xfs_exchmaps.c         |    4 
 libxfs/xfs_format.h           |   51 ++
 libxfs/xfs_fs.h               |   10 
 libxfs/xfs_health.h           |    6 
 libxfs/xfs_inode_buf.c        |   65 ++-
 libxfs/xfs_inode_fork.c       |  201 +++-----
 libxfs/xfs_inode_fork.h       |    6 
 libxfs/xfs_log_format.h       |   16 -
 libxfs/xfs_metadir.c          |    3 
 libxfs/xfs_metafile.c         |  221 +++++++++
 libxfs/xfs_metafile.h         |   13 +
 libxfs/xfs_ondisk.h           |    4 
 libxfs/xfs_refcount.c         |  277 +++++++++--
 libxfs/xfs_refcount.h         |   23 +
 libxfs/xfs_rmap.c             |  178 ++++++-
 libxfs/xfs_rmap.h             |   12 
 libxfs/xfs_rtbitmap.c         |    2 
 libxfs/xfs_rtbitmap.h         |    9 
 libxfs/xfs_rtgroup.c          |   74 ++-
 libxfs/xfs_rtgroup.h          |   58 ++
 libxfs/xfs_rtrefcount_btree.c |  755 ++++++++++++++++++++++++++++++
 libxfs/xfs_rtrefcount_btree.h |  189 +++++++
 libxfs/xfs_rtrmap_btree.c     | 1034 +++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrmap_btree.h     |  210 ++++++++
 libxfs/xfs_sb.c               |   14 +
 libxfs/xfs_shared.h           |   21 +
 libxfs/xfs_trans_resv.c       |   37 +
 libxfs/xfs_trans_space.h      |   13 +
 libxfs/xfs_types.h            |    7 
 repair/rmap.c                 |    2 
 repair/scan.c                 |    2 
 52 files changed, 3822 insertions(+), 394 deletions(-)
 create mode 100644 libxfs/xfs_rtrefcount_btree.c
 create mode 100644 libxfs/xfs_rtrefcount_btree.h
 create mode 100644 libxfs/xfs_rtrmap_btree.c
 create mode 100644 libxfs/xfs_rtrmap_btree.h

