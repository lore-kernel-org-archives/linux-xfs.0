Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0125199EAD
	for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2025 17:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740504431; cv=none; b=FJYVGdOsahtsYJ4LihOxL/LIOpz/nMYgv5iDEtS8t+bhKieRp5F3X0hsuMwnh+cxDdVzGELJUH2nrmK9UeZZC9evFNffoowOMp1khGXSKs8cwb3SeODgtQZ5ZcOWyHc2W/NrfFVKvhXHPxYBFvqcaJquLdNMJ1pa4EJUKv591HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740504431; c=relaxed/simple;
	bh=PRxcGtbJShzxOBwquVE5diXov+BOnee1QKPqHBRMc6Y=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=KXlyMEjOtTTv20yp7K/84dMLKSd4WwiKjb1plCtazvLxOwtGqmN57PFMMa9k9y6NjLonYVatBt4JoGP1fBNfl99XeBtChK15Uq4olna1ckqnRaoRiNrdKgziO07A/dF3MMklJ/afC50zTU/hxBny3ToOticPiC4OgU99FX3LfGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HjpLKdA1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HjpLKdA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3106C4CEE2;
	Tue, 25 Feb 2025 17:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740504431;
	bh=PRxcGtbJShzxOBwquVE5diXov+BOnee1QKPqHBRMc6Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HjpLKdA1/kCJvdIJ2ug/VDlWt565FPAAFQEKkn3JfgO+ZNeweBOqQoCdZllgBjxmG
	 LclchPpt0ir+VTtyxNp/VNPnAdalIblSupxvzUOMMPiDSbUFNfDfIxAfn5S1iX0DBq
	 Y4v5C4NFJcfj0h3u3WyJcZWVs/gr0W5S4TjygNJ4PMGyFpSERj38/COk6IkXAxkCwu
	 wxVlyounxQustTjZNi01mDU4qN+BrPsOKGIhwe1ZDiXPdxjLSziOEktiRYNWLPV1P+
	 xtW2A679HhKmm37eRfGpVmyRMrEOdAb2ypdxo/GAlVofCrCM68rKd2mCQdTjc+gyjT
	 +lD98ei0kBTNQ==
Date: Tue, 25 Feb 2025 09:27:10 -0800
Subject: [GIT PULL 3/7] xfsprogs: new libxfs code from kernel 6.14
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: alexjlzheng@tencent.com, cem@kernel.org, david@fromorbit.com, dchinner@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174050432891.404908.18381873135352522684.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250225172123.GB6242@frogsfrogsfrogs>
References: <20250225172123.GB6242@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.14-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 7ae92e1cb0aeeb333ac38393a5b3dbcda1ac769e:

xfs_scrub: try harder to fill the bulkstat array with bulkstat() (2025-02-25 09:15:57 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/libxfs-sync-6.14_2025-02-25

for you to fetch changes up to c89b1f70b43dc7d1dd7147d5147170db651131a4:

xfs: fix the entry condition of exact EOF block allocation optimization (2025-02-25 09:16:00 -0800)

----------------------------------------------------------------
xfsprogs: new libxfs code from kernel 6.14 [3/7]

Port kernel libxfs code to userspace.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (51):
xfs: tidy up xfs_iroot_realloc
xfs: refactor the inode fork memory allocation functions
xfs: make xfs_iroot_realloc take the new numrecs instead of deltas
xfs: make xfs_iroot_realloc a bmap btree function
xfs: tidy up xfs_bmap_broot_realloc a bit
xfs: hoist the node iroot update code out of xfs_btree_new_iroot
xfs: hoist the node iroot update code out of xfs_btree_kill_iroot
xfs: add some rtgroup inode helpers
xfs: prepare to reuse the dquot pointer space in struct xfs_inode
xfs: simplify the xfs_rmap_{alloc,free}_extent calling conventions
xfs: support storing records in the inode core root
xfs: allow inode-based btrees to reserve space in the data device
xfs: introduce realtime rmap btree ondisk definitions
xfs: realtime rmap btree transaction reservations
xfs: add realtime rmap btree operations
xfs: prepare rmap functions to deal with rtrmapbt
xfs: add a realtime flag to the rmap update log redo items
xfs: pretty print metadata file types in error messages
xfs: support file data forks containing metadata btrees
xfs: add realtime reverse map inode to metadata directory
xfs: add metadata reservations for realtime rmap btrees
xfs: wire up a new metafile type for the realtime rmap
xfs: wire up rmap map and unmap to the realtime rmapbt
xfs: create routine to allocate and initialize a realtime rmap btree inode
xfs: report realtime rmap btree corruption errors to the health system
xfs: scrub the realtime rmapbt
xfs: scrub the metadir path of rt rmap btree files
xfs: online repair of realtime bitmaps for a realtime group
xfs: online repair of the realtime rmap btree
xfs: create a shadow rmap btree during realtime rmap repair
xfs: namespace the maximum length/refcount symbols
xfs: introduce realtime refcount btree ondisk definitions
xfs: realtime refcount btree transaction reservations
xfs: add realtime refcount btree operations
xfs: prepare refcount functions to deal with rtrefcountbt
xfs: add a realtime flag to the refcount update log redo items
xfs: add realtime refcount btree inode to metadata directory
xfs: add metadata reservations for realtime refcount btree
xfs: wire up a new metafile type for the realtime refcount
xfs: wire up realtime refcount btree cursors
xfs: create routine to allocate and initialize a realtime refcount btree inode
xfs: update rmap to allow cow staging extents in the rt rmap
xfs: compute rtrmap btree max levels when reflink enabled
xfs: allow inodes to have the realtime and reflink flags
xfs: recover CoW leftovers in the realtime volume
xfs: fix xfs_get_extsz_hint behavior with realtime alwayscow files
xfs: apply rt extent alignment constraints to CoW extsize hint
xfs: enable extent size hints for CoW operations
xfs: report realtime refcount btree corruption errors to the health system
xfs: scrub the realtime refcount btree
xfs: scrub the metadir path of rt refcount btree files

Jinliang Zheng (1):
xfs: fix the entry condition of exact EOF block allocation optimization

include/libxfs.h              |    2 +
include/xfs_inode.h           |    5 +-
include/xfs_mount.h           |   19 +
include/xfs_trace.h           |    7 +
libxfs/libxfs_priv.h          |   11 +
libxfs/xfs_bmap_btree.h       |    3 +
libxfs/xfs_btree.h            |   28 +-
libxfs/xfs_defer.h            |    2 +
libxfs/xfs_errortag.h         |    4 +-
libxfs/xfs_format.h           |   51 +-
libxfs/xfs_fs.h               |   10 +-
libxfs/xfs_health.h           |    6 +-
libxfs/xfs_inode_fork.h       |    6 +-
libxfs/xfs_log_format.h       |   10 +-
libxfs/xfs_metafile.h         |   13 +
libxfs/xfs_ondisk.h           |    4 +
libxfs/xfs_refcount.h         |   23 +-
libxfs/xfs_rmap.h             |   12 +-
libxfs/xfs_rtbitmap.h         |    9 +
libxfs/xfs_rtgroup.h          |   58 ++-
libxfs/xfs_rtrefcount_btree.h |  189 ++++++++
libxfs/xfs_rtrmap_btree.h     |  210 +++++++++
libxfs/xfs_shared.h           |   21 +
libxfs/xfs_trans_space.h      |   13 +
libxfs/xfs_types.h            |    7 +
io/inject.c                   |    1 +
libxfs/Makefile               |    4 +
libxfs/xfs_ag_resv.c          |    3 +
libxfs/xfs_attr.c             |    4 +-
libxfs/xfs_bmap.c             |   47 +-
libxfs/xfs_bmap_btree.c       |  111 +++++
libxfs/xfs_btree.c            |  410 ++++++++++++----
libxfs/xfs_btree_mem.c        |    1 +
libxfs/xfs_btree_staging.c    |   10 +-
libxfs/xfs_exchmaps.c         |    4 +-
libxfs/xfs_inode_buf.c        |   65 ++-
libxfs/xfs_inode_fork.c       |  201 ++++----
libxfs/xfs_metadir.c          |    3 +
libxfs/xfs_metafile.c         |  221 +++++++++
libxfs/xfs_refcount.c         |  277 +++++++++--
libxfs/xfs_rmap.c             |  178 +++++--
libxfs/xfs_rtbitmap.c         |    2 +-
libxfs/xfs_rtgroup.c          |   72 ++-
libxfs/xfs_rtrefcount_btree.c |  755 ++++++++++++++++++++++++++++++
libxfs/xfs_rtrmap_btree.c     | 1034 +++++++++++++++++++++++++++++++++++++++++
libxfs/xfs_sb.c               |   14 +
libxfs/xfs_trans_resv.c       |   37 +-
mkfs/proto.c                  |    2 +-
repair/rmap.c                 |    2 +-
repair/scan.c                 |    2 +-
50 files changed, 3805 insertions(+), 378 deletions(-)
create mode 100644 libxfs/xfs_rtrefcount_btree.h
create mode 100644 libxfs/xfs_rtrmap_btree.h
create mode 100644 libxfs/xfs_rtrefcount_btree.c
create mode 100644 libxfs/xfs_rtrmap_btree.c

