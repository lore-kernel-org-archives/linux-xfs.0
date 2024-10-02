Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3E71803D
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831098; cv=none; b=i3fKYpoW+VfTgSEsYrZVk4ToFFBWMT1oFgET9nzg73rY59/OchI6WoS+Juit6M+P+NCt1H+HAc/iOW6Gl6p5tg1fdYQT44V530Wk7gJIlLKErlq7Tfx44cusfdwGC4L6ycWQLE0vFBbFdAuTO/YwdMDB3gPVECCjRwk07ZwcvjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831098; c=relaxed/simple;
	bh=Q+DFu3RIQ6T0dHB87wanM039IGDBonCPYVzARBTZpKI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tLD0kJunuWTPNql74V1Gzf8Bn8PwlceFGIS4U75aX64ovqNEYSpfGdMzgAhZ3XKdhcgAyEd1xl5YuTh9dp0BlviHivMfuqcfMt7oDO7n0bHNZjxq3d9doatLTf0Hfvov4u23mTWrOLdoHqBrB40k6JdKOvHYECspNORp9pwfcxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TpsAVWZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TpsAVWZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE3BC4CEC6;
	Wed,  2 Oct 2024 01:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831097;
	bh=Q+DFu3RIQ6T0dHB87wanM039IGDBonCPYVzARBTZpKI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TpsAVWZKhOkwduh8dahcEPdV4DxMtNFxQCWT4PFe8bGk0RvEmx2+Z5tqtUmpZIw3Z
	 8n5hHgfv/popVpHKupwbG6fX0pxMwODLX/SNlrelkV01VWuh/Qr6zjie/97Zxaq1lS
	 YJHIU54WMZM+ro4czedu0ARAQ5OFRcVi0InHuhl73BpOpX9c7fQhnS7WDqKhnHrYxM
	 EoVLAxM9JfrAnLAYTxvTBdA8L6KkQzvMbGr0NRRMId4bB6opGfQSXL/MKzz4uZ27hD
	 AM8juJZyjzzoWOdFOVRbPPxXdTbV5uj32MBO5UpsctUvw/7+oy4tbc2MFBDes0NUv3
	 zRid3eeNwLOJA==
Date: Tue, 01 Oct 2024 18:04:57 -0700
Subject: [PATCHSET v2.5 3/6] libxfs: resync with 6.11
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Zizhi Wo <wozizhi@huawei.com>, kjell.m.randa@gmail.com,
 Wenchao Hao <haowenchao22@gmail.com>, lei lu <llfamsec@gmail.com>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Julian Sun <sunjunchao2870@gmail.com>,
 Gao Xiang <hsiangkao@linux.alibaba.com>,
 Anders Blomdell <anders.blomdell@gmail.com>, Christoph Hellwig <hch@lst.de>,
 Dave Chinner <dchinner@redhat.com>, Long Li <leo.lilong@huawei.com>,
 linux-xfs@vger.kernel.org
Message-ID: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
In-Reply-To: <20241002010022.GA21836@frogsfrogsfrogs>
References: <20241002010022.GA21836@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Port code from Linux 6.11.  For this release there are a lot of libxfs patches
scattered in this sync branch because we're unifying the icreate code paths
between userspace and the kernel.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-sync-6.11
---
Commits in this patchset:
 * xfs: avoid redundant AGFL buffer invalidation
 * xfs: don't walk off the end of a directory data block
 * xfs: Remove header files which are included more than once
 * xfs: hoist extent size helpers to libxfs
 * xfs: hoist inode flag conversion functions to libxfs
 * xfs: hoist project id get/set functions to libxfs
 * libxfs: put all the inode functions in a single file
 * libxfs: pass IGET flags through to xfs_iread
 * xfs: pack icreate initialization parameters into a separate structure
 * libxfs: pack icreate initialization parameters into a separate structure
 * xfs: implement atime updates in xfs_trans_ichgtime
 * libxfs: rearrange libxfs_trans_ichgtime call when creating inodes
 * libxfs: set access time when creating files
 * libxfs: when creating a file in a directory, set the project id based on the parent
 * libxfs: pass flags2 from parent to child when creating files
 * xfs: split new inode creation into two pieces
 * libxfs: split new inode creation into two pieces
 * libxfs: backport inode init code from the kernel
 * libxfs: remove libxfs_dir_ialloc
 * libxfs: implement get_random_u32
 * xfs: hoist new inode initialization functions to libxfs
 * xfs: hoist xfs_iunlink to libxfs
 * xfs: hoist xfs_{bump,drop}link to libxfs
 * xfs: separate the icreate logic around INIT_XATTRS
 * xfs: create libxfs helper to link a new inode into a directory
 * xfs: create libxfs helper to link an existing inode into a directory
 * xfs: hoist inode free function to libxfs
 * xfs: create libxfs helper to remove an existing inode/name from a directory
 * xfs: create libxfs helper to exchange two directory entries
 * xfs: create libxfs helper to rename two directory entries
 * xfs: move dirent update hooks to xfs_dir2.c
 * xfs: don't use the incore struct xfs_sb for offsets into struct xfs_dsb
 * xfs: clean up extent free log intent item tracepoint callsites
 * xfs: convert "skip_discard" to a proper flags bitset
 * xfs: pass the fsbno to xfs_perag_intent_get
 * xfs: add a xefi_entry helper
 * xfs: reuse xfs_extent_free_cancel_item
 * xfs: remove duplicate asserts in xfs_defer_extent_free
 * xfs: remove xfs_defer_agfl_block
 * xfs: move xfs_extent_free_defer_add to xfs_extfree_item.c
 * xfs: give rmap btree cursor error tracepoints their own class
 * xfs: pass btree cursors to rmap btree tracepoints
 * xfs: clean up rmap log intent item tracepoint callsites
 * xfs: add a ri_entry helper
 * xfs: reuse xfs_rmap_update_cancel_item
 * xfs: don't bother calling xfs_rmap_finish_one_cleanup in xfs_rmap_finish_one
 * xfs: simplify usage of the rcur local variable in xfs_rmap_finish_one
 * xfs: move xfs_rmap_update_defer_add to xfs_rmap_item.c
 * xfs: give refcount btree cursor error tracepoints their own class
 * xfs: create specialized classes for refcount tracepoints
 * xfs: pass btree cursors to refcount btree tracepoints
 * xfs: clean up refcount log intent item tracepoint callsites
 * xfs: add a ci_entry helper
 * xfs: reuse xfs_refcount_update_cancel_item
 * xfs: don't bother calling xfs_refcount_finish_one_cleanup in xfs_refcount_finish_one
 * xfs: simplify usage of the rcur local variable in xfs_refcount_finish_one
 * xfs: move xfs_refcount_update_defer_add to xfs_refcount_item.c
 * xfs: Avoid races with cnt_btree lastrec updates
 * xfs: AIL doesn't need manual pushing
 * xfs: background AIL push should target physical space
 * xfs: get rid of xfs_ag_resv_rmapbt_alloc
 * xfs: remove unused parameter in macro XFS_DQUOT_LOGRES
 * xfs: fix di_onlink checking for V1/V2 inodes
 * xfs: xfs_finobt_count_blocks() walks the wrong btree
---
 configure.ac                |    1 
 db/iunlink.c                |   17 +
 include/builddefs.in        |    1 
 include/libxfs.h            |    1 
 include/xfs_inode.h         |   93 ++++-
 include/xfs_mount.h         |   11 +
 include/xfs_trace.h         |   11 -
 include/xfs_trans.h         |    2 
 libxfs/Makefile             |    9 +
 libxfs/defer_item.c         |  222 +++++++------
 libxfs/defer_item.h         |   16 +
 libxfs/inode.c              |  254 +++++++++++++++
 libxfs/iunlink.c            |  163 +++++++++
 libxfs/iunlink.h            |   24 +
 libxfs/libxfs_api_defs.h    |    2 
 libxfs/libxfs_priv.h        |   26 +
 libxfs/rdwr.c               |   95 -----
 libxfs/util.c               |  336 +------------------
 libxfs/xfs_ag.c             |    2 
 libxfs/xfs_ag_resv.h        |   19 -
 libxfs/xfs_alloc.c          |  235 ++++++++------
 libxfs/xfs_alloc.h          |   18 +
 libxfs/xfs_alloc_btree.c    |   64 ----
 libxfs/xfs_bmap.c           |   55 +++
 libxfs/xfs_bmap.h           |    3 
 libxfs/xfs_bmap_btree.c     |    2 
 libxfs/xfs_btree.c          |   51 ---
 libxfs/xfs_btree.h          |   16 -
 libxfs/xfs_defer.c          |    2 
 libxfs/xfs_dir2.c           |  661 ++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_dir2.h           |   49 +++
 libxfs/xfs_dir2_data.c      |   31 +-
 libxfs/xfs_dir2_priv.h      |    7 
 libxfs/xfs_format.h         |    9 -
 libxfs/xfs_ialloc.c         |   20 +
 libxfs/xfs_ialloc_btree.c   |    4 
 libxfs/xfs_inode_buf.c      |   14 +
 libxfs/xfs_inode_util.c     |  746 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_util.h     |   62 ++++
 libxfs/xfs_ondisk.h         |    1 
 libxfs/xfs_quota_defs.h     |    2 
 libxfs/xfs_refcount.c       |  156 +++------
 libxfs/xfs_refcount.h       |   11 -
 libxfs/xfs_refcount_btree.c |    2 
 libxfs/xfs_rmap.c           |  268 +++++----------
 libxfs/xfs_rmap.h           |   15 +
 libxfs/xfs_rmap_btree.c     |    7 
 libxfs/xfs_shared.h         |    7 
 libxfs/xfs_trans_inode.c    |    2 
 libxfs/xfs_trans_resv.c     |   29 +-
 m4/package_libcdev.m4       |   15 +
 mkfs/proto.c                |  101 +++++-
 repair/bulkload.c           |    3 
 repair/phase6.c             |   63 ++--
 54 files changed, 2829 insertions(+), 1207 deletions(-)
 create mode 100644 libxfs/inode.c
 create mode 100644 libxfs/iunlink.c
 create mode 100644 libxfs/iunlink.h
 create mode 100644 libxfs/xfs_inode_util.c
 create mode 100644 libxfs/xfs_inode_util.h

