Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B30212E7E
	for <linux-xfs@vger.kernel.org>; Fri, 18 Jul 2025 16:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752854624; cv=none; b=dGIobMZv/qGddeQwXfwfW9L6AT/rqm4qXMfMHHTafoLuqFVNkvYeYbqDaNv2YqSDMb94wWRivmVocMKiIAkT3x31iEyUZ1OrgtKE90AM+fD3hC2uahFoBpB2+si7beTqrSSacybMcHjjcsvP4gMNXqmKbcoilqm3WlE3mJWP0WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752854624; c=relaxed/simple;
	bh=6tNHD5hOgxo+lNwk6MSZjoqbt4Hx4yepMH03/IlLP+I=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ad0pcbKC2nedJXhjHSz9y7VbFU0uhOwbIXJxrUfwxrL0GS6Fu0qFpzJJlZJ/l/KWxGj09zhpauWLHVqQg1Svz0lemSXbOSvyd6EZk/igVRM97KJEeJDVB+mFj+o4T+8zk24tEFp8x1kVYN/vnJMssKek4fc5cb/bCq2xiGtIXwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nFuYox9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nFuYox9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40499C4CEEB
	for <linux-xfs@vger.kernel.org>; Fri, 18 Jul 2025 16:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752854623;
	bh=6tNHD5hOgxo+lNwk6MSZjoqbt4Hx4yepMH03/IlLP+I=;
	h=Date:From:To:Subject:From;
	b=nFuYox9x3n0woXxBy4Sfk/+l5+gGdjH/7X1fsh9VFD8uN80+78yiD8N2v6v+oRfap
	 7mmTvy5SBgibQBxVUCanHcP8ugTJSVjIxDyGK/9sz+6kLieMmD5wUqee42NrAhrUmH
	 FJ2o1hfW9lrHcuZqLAWSMVA9x3yCIcPzy+JlUkjhpqta9OZNfQrU+LaYUbvwvnbReQ
	 vyGtpW1QlayQOguJbvyec1FZDx7ctzMMwj7ixZWrgAR8BEHjZUoXi4Hle0XWkn3K6+
	 NU+GkrckIAcznT+taMnMFa17pbAsHxX1GoekK0x6cGsHT1+wgY2kZYkW/g6kuMSQkG
	 qpN8axMEkD04A==
Date: Fri, 18 Jul 2025 18:03:40 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next *REBASED* to f69153451328
Message-ID: <rovwonlnzbjzgvk4pogemaly6g3a4hshnl4rc7psjsznoxqm5l@pflugywpaexm>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been *REBASED*.

There are no new patches here, the reason for the rebase is to
accommodate a memory-leak fix into the pull-request I'm about
to send without modifying hashes for patches already in linux-next.

All patches (except merge commits) that were in linux-next already
have their hashes unmodified.


The new head of the for-next branch is commit:

f69153451328 Merge branch 'xfs-6.16-fixes' into for-next

19 new commits:

Alan Huang (1):
      [414d21d65b8e] xfs: Remove unused label in xfs_dax_notify_dev_failure

Carlos Maiolino (2):
      [dde319fd3646] Merge branch 'xfs-6.17-merge' into for-next
      [f69153451328] Merge branch 'xfs-6.16-fixes' into for-next

Christoph Hellwig (15):
      [8f89c581c0da] xfs: use xfs_trans_reserve_more in xfs_trans_reserve_more_inode
      [e13f9ce5bec1] xfs: don't use xfs_trans_reserve in xfs_trans_reserve_more
      [ddf9708277eb] xfs: decouple xfs_trans_alloc_empty from xfs_trans_alloc
      [b4e174c374f6] xfs: don't use xfs_trans_reserve in xfs_trans_roll
      [e967dc40d501] xfs: return the allocated transaction from xfs_trans_alloc_empty
      [149b5cf8c7d2] xfs: return the allocated transaction from xchk_trans_alloc_empty
      [a766ae6fe120] xfs: remove xrep_trans_{alloc,cancel}_hook_dummy
      [d9dbddd143db] xfs: remove the xlog_ticket_t typedef
      [a10f18bc6778] xfs: improve the xg_active_ref check in xfs_group_free
      [c11330b4ac11] xfs: use a uint32_t to cache i_used_blocks in xfs_init_zone
      [8a034f984dfe] xfs: rename oz_write_pointer to oz_allocated
      [7a779c6867fa] xfs: stop passing an inode to the zone space reservation helpers
      [8196283484ec] xfs: improve the comments in xfs_max_open_zones
      [e381d3e2c80d] xfs: improve the comments in xfs_select_zone_nowait
      [5948705adbf1] xfs: don't allocate the xfs_extent_busy structure for zoned RTGs

Pranav Tyagi (1):
      [fe30244c817a] fs/xfs: replace strncpy with memtostr_pad()

Code Diffstat:

 fs/xfs/libxfs/xfs_format.h   |   2 +-
 fs/xfs/libxfs/xfs_group.c    |  17 ++--
 fs/xfs/libxfs/xfs_refcount.c |   4 +-
 fs/xfs/scrub/common.c        |   7 +-
 fs/xfs/scrub/common.h        |   2 +-
 fs/xfs/scrub/dir_repair.c    |   8 +-
 fs/xfs/scrub/fscounters.c    |   3 +-
 fs/xfs/scrub/metapath.c      |   4 +-
 fs/xfs/scrub/nlinks.c        |   8 +-
 fs/xfs/scrub/nlinks_repair.c |   4 +-
 fs/xfs/scrub/parent_repair.c |  12 +--
 fs/xfs/scrub/quotacheck.c    |   4 +-
 fs/xfs/scrub/repair.c        |  36 --------
 fs/xfs/scrub/repair.h        |   4 -
 fs/xfs/scrub/rmap_repair.c   |  14 +--
 fs/xfs/scrub/rtrmap_repair.c |  14 +--
 fs/xfs/scrub/scrub.c         |   5 +-
 fs/xfs/xfs_attr_item.c       |   5 +-
 fs/xfs/xfs_discard.c         |  12 +--
 fs/xfs/xfs_extent_busy.h     |   8 ++
 fs/xfs/xfs_file.c            |  24 ++---
 fs/xfs/xfs_fsmap.c           |   4 +-
 fs/xfs/xfs_icache.c          |   5 +-
 fs/xfs/xfs_inode.c           |   7 +-
 fs/xfs/xfs_ioctl.c           |   3 +-
 fs/xfs/xfs_iops.c            |   4 +-
 fs/xfs/xfs_itable.c          |  18 +---
 fs/xfs/xfs_iwalk.c           |  11 +--
 fs/xfs/xfs_log.c             |   6 +-
 fs/xfs/xfs_log_priv.h        |   4 +-
 fs/xfs/xfs_notify_failure.c  |   6 +-
 fs/xfs/xfs_qm.c              |  10 +--
 fs/xfs/xfs_rtalloc.c         |  13 +--
 fs/xfs/xfs_trace.h           |   8 +-
 fs/xfs/xfs_trans.c           | 207 ++++++++++++++++++++-----------------------
 fs/xfs/xfs_trans.h           |   3 +-
 fs/xfs/xfs_zone_alloc.c      |  45 +++++-----
 fs/xfs/xfs_zone_alloc.h      |   4 +-
 fs/xfs/xfs_zone_gc.c         |  18 ++--
 fs/xfs/xfs_zone_info.c       |   2 +-
 fs/xfs/xfs_zone_priv.h       |  16 ++--
 fs/xfs/xfs_zone_space_resv.c |  17 ++--
 42 files changed, 233 insertions(+), 375 deletions(-)
