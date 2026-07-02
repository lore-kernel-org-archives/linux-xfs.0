Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A3C3CA4AD
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 19:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022356; cv=none; b=ipOZE7cz9HLwtXnNSv7X9cqEoXQwnbaOrKNV4niy8vNjXATANUn1fmoNggygRvSaV2utGpoMZJiTwu8UWI8PxdRqXTzMr9VtmuzVdzJA20v8rRVv9YCV2uwv1K/lhOG5Wu/E4l7cXIz3ZkfpXO4X6Q94YU1Ue/ZU162kCGPMkaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022356; c=relaxed/simple;
	bh=eASyvZmdyJQJdXjN4piZs/OqV2EkuaKFM64N1VlTSXs=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=EVCmtMNs4FKKmvPUTAF2fpWvfUD8pzmLVYYlkPnVCSMwgkq3koLl3InwJVyIEtLqJp7YOgDnMSILK+wOGhMiZei1ua1PUQXMLZoRKyDSoJTkK4UStascqWdyS4dq/BDt2Y76glLWui/paWjl1QaDr7vScStxDKafFrHZG/ru/ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fDKK+Adr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fDKK+Adr"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1907F1F00A3A;
	Thu,  2 Jul 2026 19:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022354;
	bh=1ywZCyl7Adq3KNamUs8/5Xr27YuyOLrsSAiFUe5UpnY=;
	h=Date:Subject:From:To:Cc;
	b=fDKK+AdrZMrXWxNPYZt89kK1IGI2Nrwj9BbxeVkyc1hze2WXbST9FKWfXYHqSMFRe
	 Zh8A8b+oBRU048HyIU+DYg5r37ma1DpbC0tPB8R9app5nHRc1qpdThJPuGdQ/1Vzjt
	 saBh4AuGJHcGndQyh1F3QgV/Vjmy6ondWdLktynlOiQXO2VjXYmdmN8OEhe7I15mL/
	 +TZDNO6k8VKO7Kv0XRcrCI1/PWOg5pvtLghAhsAFxxd9bEOdTXhtnOEV1ATAoV3PSo
	 lTKWX+p3gcj/bsAa6zNUZY0/W8rNhpTgtRArUplK3fEVf4bu7U7fsgucEiHWwLlxaZ
	 Y9I78+kZ1WaGg==
Date: Thu, 02 Jul 2026 12:59:13 -0700
Subject: [PATCHSET 2/2] xfsprogs: new libxfs code from kernel 7.2
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: chuck.lever@oracle.com, roland.mainz@nrubsig.org, cmaiolino@redhat.com,
 cem@kernel.org, hch@lst.de, brauner@kernel.org, gaoyingjie@uniontech.com,
 linux-xfs@vger.kernel.org
Message-ID: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series ports kernel libxfs code to userspace from 7.2-rc1.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-7.2-sync
---
Commits in this patchset:
 * libxfs: convert diff_items helpers to cmp_int
 * xfs: Report case sensitivity in fileattr_get
 * xfs: fix exchmaps reservation limit check
 * xfs: add a XFS_INODE_TO_AGNO helper
 * xfs: add a XFS_INODE_TO_AGINO helper
 * xfs: add a XFS_INO_TO_FSB helper
 * xfs: add a xfs_rmap_inode_bmbt_owner
 * xfs: add a xfs_rmap_inode_owner helper
 * xfs: remove the i_ino field in struct xfs_inode
 * xfs: cleanup xfs_imap
 * xfs: remove im_len field in struct xfs_imap
 * xfs: massage xfs_imap_to_bp into xfs_read_icluster
 * xfs: store an agbno in struct xfs_imap
 * xfs: mark struct xfs_imap as __packed
 * xfs: fix pointer arithmetic error on 32-bit systems
 * xfs: pass back updated nb from xfs_growfs_compute_deltas
 * xfs: cleanup xfs_growfs_compute_deltas
 * xfs: move XFS_LSN_CMP to xfs_log_format.h
---
 include/linux.h               |   17 +++++
 include/xfs_inode.h           |    7 ++
 libxfs/libxfs_api_defs.h      |    2 -
 libxfs/xfs_ag.h               |    5 +-
 libxfs/xfs_bmap_btree.h       |    2 -
 libxfs/xfs_format.h           |    6 ++
 libxfs/xfs_inode_buf.h        |   13 ++--
 libxfs/xfs_log_format.h       |   13 ++++
 libxfs/xfs_parent.h           |    2 -
 libxfs/xfs_rmap.h             |    4 +
 db/attrset.c                  |    2 -
 db/bmap_inflate.c             |    4 +
 db/dquot.c                    |    2 -
 db/iunlink.c                  |   13 +++-
 db/namei.c                    |   14 ++--
 db/rdump.c                    |    2 -
 libxfs/defer_item.c           |    8 +--
 libxfs/inode.c                |    8 +--
 libxfs/iunlink.c              |    4 +
 libxfs/listxattr.c            |    4 +
 libxfs/logitem.c              |   17 ++++-
 libxfs/util.c                 |    2 -
 libxfs/xfs_ag.c               |   42 ++++++-------
 libxfs/xfs_attr.c             |    2 -
 libxfs/xfs_attr_leaf.c        |    2 -
 libxfs/xfs_bmap.c             |   20 +++---
 libxfs/xfs_bmap_btree.c       |    8 +--
 libxfs/xfs_btree.c            |   18 +++---
 libxfs/xfs_btree_staging.c    |    2 -
 libxfs/xfs_da_btree.c         |    2 -
 libxfs/xfs_dir2.c             |   44 +++++++-------
 libxfs/xfs_dir2_node.c        |    2 -
 libxfs/xfs_dir2_sf.c          |    4 +
 libxfs/xfs_exchmaps.c         |   10 ++-
 libxfs/xfs_ialloc.c           |   90 ++++++++++++-----------------
 libxfs/xfs_inode_buf.c        |   24 ++++----
 libxfs/xfs_inode_fork.c       |    6 +-
 libxfs/xfs_inode_util.c       |   15 +++--
 libxfs/xfs_metadir.c          |    2 -
 libxfs/xfs_parent.c           |    8 +--
 libxfs/xfs_rmap.c             |    6 +-
 libxfs/xfs_rtbitmap.c         |    4 +
 libxfs/xfs_rtrefcount_btree.c |    4 +
 libxfs/xfs_rtrmap_btree.c     |    4 +
 libxfs/xfs_symlink_remote.c   |    6 +-
 mkfs/proto.c                  |   16 +++--
 repair/bmap_repair.c          |   12 +++-
 repair/bulkload.c             |    2 -
 repair/phase6.c               |  128 +++++++++++++++++++++--------------------
 repair/pptr.c                 |  100 ++++++++++++++++----------------
 repair/quotacheck.c           |    8 +--
 repair/rt.c                   |    6 +-
 repair/rtrefcount_repair.c    |    2 -
 repair/rtrmap_repair.c        |    2 -
 repair/xfs_repair.c           |    2 -
 55 files changed, 394 insertions(+), 360 deletions(-)

