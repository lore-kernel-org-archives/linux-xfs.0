Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE799284B26
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 18:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764007859; cv=none; b=X5DRnuHCHj1FQTPKUIDpbjYQcNB959g+4xD0huUUnUmr4HvZOA/st/6KCJbBAazbkAS7m9cgsqqDKipDgr4tpWPvJ5GsFGgTzx5Un+GAqSdwOntko3j0kuU0/0/dSc3HDPspZ+watFkBkWmSUS96O8A/kjeG+hRLHZhNPYRMKDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764007859; c=relaxed/simple;
	bh=/xzgTNZ6XBd3EDVfeteoNUAi935p5aFij8rs2HqURvg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=itmaLiEl5ahOdTpqOCzQutbE36LRbsKnFi8agCDNKe/U5TA12ti613oXvWSU5VtqjL05UvUuVZIjoQgfRM6pmioAHXv0kkim4sVcn50PCCtQaMsP4zY4hogOlnqSdhs9LmuSovw0rw4cgLCm0niIZj6fHKLvOQIW4tmasEHRLbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f86KNlg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f86KNlg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA784C4CEF1
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 18:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764007858;
	bh=/xzgTNZ6XBd3EDVfeteoNUAi935p5aFij8rs2HqURvg=;
	h=Date:From:To:Subject:From;
	b=f86KNlg/3U+xSUNIpoej9NjM0hZgKgsbkuGB3x9Jj+bI7hVT4+2Wu+mHjyXJKPTqT
	 SGnoLnzMNyAbvyGl1CP6iEY1Rt9ZsIa/dOmTiqMx717JXyZ/QKDg+oer9Yi78odDMX
	 pAB1Mok0vQDcFZ0GdxPHsP52KRDfrW9Dnf6CGdG31hlQROnxdkUYYFeaUfgM+CboAn
	 TiMlZcL47qk0pHqmMubfzCaEjpW+rKn3qMBA5nYEPeIOKeLbnh9VO0QeztSKc91Kh4
	 aqT1sMJBV/HWLTxEpR9GTKa7KdwldhUS8rglqYbYppCQimm9t1Wvzs6NPHe6kXh1dM
	 BDpW1uNLUWr3g==
Date: Mon, 24 Nov 2025 19:10:54 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next *REBASED* to 68880072d89c
Message-ID: <q63m3zjlsshlwjj3wjjclwfjq3apdhyu2wly5vhvglghsn4agg@l4kplt4xblmg>
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

Christoph asked me to postpone his last series to the next merge window
instead of the one to be opened. So I need to move the patches to a
different order so that patches going to this merge window stays with
the same hashes once Rothwell pick them up.

There is no difference on the list of patches here other than the
ordering. And giving those are the first patches to the future 6.20, I
also have opened a merge branch for 6.20: xfs-6.20-merge.
Any questions please let me know.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

68880072d89c xfs: factor out a xlog_write_space_advance helper

12 new commits:

Carlos Maiolino (1):
      [161e40bbc59d] Merge branch 'xfs-6.19-merge' into for-next

Christoph Hellwig (11):
      [dcfa98bb5f78] xfs: move some code out of xfs_iget_recycle
      [eaa16dcba41b] xfs: add a xlog_write_one_vec helper
      [a67974a02441] xfs: set lv_bytes in xlog_write_one_vec
      [842062b1b79b] xfs: improve the ->iop_format interface
      [c1f58809c704] xfs: move struct xfs_log_iovec to xfs_log_priv.h
      [552d7e3834bb] xfs: move struct xfs_log_vec to xfs_log_priv.h
      [a596409935fa] xfs: regularize iclog space accounting in xlog_write_partial
      [2385c471fe7b] xfs: improve the calling convention for the xlog_write helpers
      [7f637bc9d9f4] xfs: add a xlog_write_space_left helper
      [bf3d2b6d962c] xfs: improve the iclog space assert in xlog_write_iovec
      [68880072d89c] xfs: factor out a xlog_write_space_advance helper

Code Diffstat:

 fs/xfs/libxfs/xfs_log_format.h |   7 -
 fs/xfs/xfs_attr_item.c         |  27 ++--
 fs/xfs/xfs_bmap_item.c         |  10 +-
 fs/xfs/xfs_buf_item.c          |  19 +--
 fs/xfs/xfs_dquot_item.c        |   9 +-
 fs/xfs/xfs_exchmaps_item.c     |  11 +-
 fs/xfs/xfs_extfree_item.c      |  10 +-
 fs/xfs/xfs_icache.c            |  31 ++---
 fs/xfs/xfs_icreate_item.c      |   6 +-
 fs/xfs/xfs_inode_item.c        |  49 ++++---
 fs/xfs/xfs_log.c               | 292 ++++++++++++++++-------------------------
 fs/xfs/xfs_log.h               |  65 ++-------
 fs/xfs/xfs_log_cil.c           | 111 ++++++++++++++--
 fs/xfs/xfs_log_priv.h          |  20 +++
 fs/xfs/xfs_refcount_item.c     |  10 +-
 fs/xfs/xfs_rmap_item.c         |  10 +-
 fs/xfs/xfs_trans.h             |   4 +-
 17 files changed, 326 insertions(+), 365 deletions(-)
