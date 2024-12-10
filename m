Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C4E1E515
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 13:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733838939; cv=none; b=hjLd55CwtbwCA0K6z4nNJLmGBp+6R5bwlkHdGRHuVdXcqcnAp9U+FV+nAzeLijTYNWm9Yx82tBSxhFxlVj9zrFtWHj74eh7SxDFpWk+/y7paM6NEm1QKpRldnIAKJH3pV6ak1Q5b2THkeNrSUkts9YommmSSvklPQU193u0dpFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733838939; c=relaxed/simple;
	bh=E4ujjDO87k392cx6c4hlnSVS+fa+8jQM4ihg5c+uwZw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=QV8I3mwhYaHmH+A5QFBxvACtSlOfUGvqtTLVxZFj3mJszH4seNfn+XVTuTev7LHPM4L3rn6VqrzzdKPNlnVBfGCFwg1Iw8CJdprydKbSRcQCpdhtaCik2NC8+rVCoclKk1hwbWTjvIvLhT60ATf1P5UNjN/M7eOlaPzvf5sgIHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=filFh7bV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="filFh7bV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BD2C4CED6
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 13:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733838938;
	bh=E4ujjDO87k392cx6c4hlnSVS+fa+8jQM4ihg5c+uwZw=;
	h=Date:From:To:Subject:From;
	b=filFh7bVSSeQyV3j5NxossPnnxv7rJP+5AToyZcj+QGyvJZQqhGMuCqOCwseqnLpE
	 uxPPGrwz1/Mook7xse2U+cFqfo+JBBB2zke/QFF/zKR/290kLMX6GaCaw1YQ53HyDn
	 XmtVJfyMrcfIcXBxVZxzwrh2BfLXV6oKXVZLQchJYUbVoHdPoSXjVSvLOjXFQtdU+e
	 CxRdUo0Bwh4Qmoa7wJ3CZXnj+q3Xf9NVGWlAO9osR8lvSIa/FdpCUH/0iro0M412J5
	 z+ZZRhpWvzvjOSXqWExAAqgCj8weE9TVzn6cKmYHKttEy5PKV/RZjBFIyREZn2j30v
	 8/mUg4LARA5zw==
Date: Tue, 10 Dec 2024 14:55:35 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 3c171ea60082
Message-ID: <gh764lducbjqmk4v6jnxs3z5qdjd5x7u5wpav5ioqnxn5ozhy7@o4lrqwjvx4ba>
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

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

3c171ea60082 Merge tag 'fixes-6.13_2024-12-03' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into next-rc

23 new commits:

Carlos Maiolino (1):
      [3c171ea60082] Merge tag 'fixes-6.13_2024-12-03' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into next-rc

Darrick J. Wong (22):
      [6f5cf7b030a3] xfs: fix off-by-one error in fsmap's end_daddr usage
      [8bda08ee97f1] xfs: metapath scrubber should use the already loaded inodes
      [9fb12e14e1f9] xfs: keep quota directory inode loaded
      [9ce95c57eb9c] xfs: return a 64-bit block count from xfs_btree_count_blocks
      [a8e58ad54559] xfs: don't drop errno values when we fail to ficlone the entire range
      [2b26fbe377b1] xfs: separate healthy clearing mask during repair
      [5c7dde704acf] xfs: set XFS_SICK_INO_SYMLINK_ZAPPED explicitly when zapping a symlink
      [1e5279617f51] xfs: mark metadir repair tempfiles with IRECOVERY
      [5f15f81fcc07] xfs: fix null bno_hint handling in xfs_rtallocate_rtg
      [3d769dee32d4] xfs: fix error bailout in xfs_rtginode_create
      [815e5ba08043] xfs: update btree keys correctly when _insrec splits an inode root block
      [f600b68e406a] xfs: fix scrub tracepoints when inode-rooted btrees are involved
      [65b447932c86] xfs: unlock inodes when erroring out of xfs_trans_alloc_dir
      [676b18e4fa11] xfs: only run precommits once per transaction object
      [7f5fd31c19f1] xfs: avoid nested calls to __xfs_trans_commit
      [e8db9fed7d5e] xfs: don't lose solo superblock counter update transactions
      [03d23e3ebeb7] xfs: don't lose solo dquot update transactions
      [b498f5586e97] xfs: separate dquot buffer reads from xfs_dqflush
      [bf3c79cd4cd9] xfs: clean up log item accesses in xfs_qm_dqflush{,_done}
      [c7f5c6bc0166] xfs: attach dquot buffer to dquot log item buffer
      [2a9415a4dce5] xfs: convert quotacheck to attach dquot buffers
      [641a4a631548] xfs: fix sb_spino_align checks for large fsblock sizes

Code Diffstat:

 fs/xfs/libxfs/xfs_btree.c        |  33 +++++--
 fs/xfs/libxfs/xfs_btree.h        |   2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c |   4 +-
 fs/xfs/libxfs/xfs_rtgroup.c      |   2 +-
 fs/xfs/libxfs/xfs_sb.c           |  11 ++-
 fs/xfs/scrub/agheader.c          |   6 +-
 fs/xfs/scrub/agheader_repair.c   |   6 +-
 fs/xfs/scrub/fscounters.c        |   2 +-
 fs/xfs/scrub/health.c            |  57 +++++++-----
 fs/xfs/scrub/ialloc.c            |   4 +-
 fs/xfs/scrub/metapath.c          |  68 ++++++--------
 fs/xfs/scrub/refcount.c          |   2 +-
 fs/xfs/scrub/scrub.h             |   6 ++
 fs/xfs/scrub/symlink_repair.c    |   3 +-
 fs/xfs/scrub/tempfile.c          |  10 +-
 fs/xfs/scrub/trace.h             |   2 +-
 fs/xfs/xfs_bmap_util.c           |   2 +-
 fs/xfs/xfs_dquot.c               | 195 +++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_dquot.h               |   6 +-
 fs/xfs/xfs_dquot_item.c          |  51 +++++++---
 fs/xfs/xfs_dquot_item.h          |   7 ++
 fs/xfs/xfs_file.c                |   8 ++
 fs/xfs/xfs_fsmap.c               |  38 ++++----
 fs/xfs/xfs_inode.h               |   2 +-
 fs/xfs/xfs_qm.c                  |  95 +++++++++++++------
 fs/xfs/xfs_qm.h                  |   1 +
 fs/xfs/xfs_quota.h               |   7 +-
 fs/xfs/xfs_rtalloc.c             |   2 +-
 fs/xfs/xfs_trans.c               |  56 ++++++-----
 fs/xfs/xfs_trans_ail.c           |   2 +-
 fs/xfs/xfs_trans_dquot.c         |  31 ++++++-
 31 files changed, 494 insertions(+), 227 deletions(-)
