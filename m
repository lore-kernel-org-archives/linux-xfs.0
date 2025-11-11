Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAC33451D9
	for <linux-xfs@vger.kernel.org>; Tue, 11 Nov 2025 11:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762859040; cv=none; b=J5AduZX67vCP1VVzW+DO8BVbmTmaxABXKRTudVF4FGpNvuuB3wHfRfR7pI3bk70YQryDfxTmCeZTDpoZAuR/RjwVi/PX48jJVaLGsssaWKiAEE5RezOq3pOvYu8Qamp8E0BMGs50Fr5HM0j9aMkBh+32wPq/hHVv9+UIV4L3Q1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762859040; c=relaxed/simple;
	bh=53WAc8T0M7c56azQzTEvvKtGpteeAcKq5+xsoJ7+WdI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=F/V874EoF5P40ME7gEasr46JsOrB9r25PeScD140+QW4jgoWaeW/nyJYRjdHeXmIe3wJKQQSbnGlzHqD35FRVlY2i8OeiP4DPXYrR5yt1pqzk+JUo0TVsGW/+0gDrAQ5QW+cZZDbKkw/z0iQb0BfFSlcW3zFIu8MYQgv1xV3DTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WWBQC+pF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WWBQC+pF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9ECFC4CEF7
	for <linux-xfs@vger.kernel.org>; Tue, 11 Nov 2025 11:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762859039;
	bh=53WAc8T0M7c56azQzTEvvKtGpteeAcKq5+xsoJ7+WdI=;
	h=Date:From:To:Subject:From;
	b=WWBQC+pF+UTbocp1zvlMOxTpY2RssLepdICl4H1ZlC0sDwK8+1BqoYlTIdF2tZouQ
	 tLi4KbbgLhPtJeviPMXxt4Bzx6+qOmY8fa+6b4zZh3mTLgXq5rAnY5LdnYXydNNi0F
	 QWF4fPRT8l8ccczEOxMeaK7zaj0iuGcGTbDi9enkwsG76lVooFGvb0SMAgnV1A43cM
	 fhTEiuHH+OzYJXu0Nt6LtwirObjHHFSizymn4bdWwNqJmIPDIdzFApCh+QNbZeH4uL
	 qqQBao+IMxJqHFiund3Mh49blleQ+it+VAB0ZqZfffWJxXqbsMC2gezTAuMyTrxKEg
	 /87sLw/khhBLw==
Date: Tue, 11 Nov 2025 12:03:55 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 6a7bb6ccd005
Message-ID: <xqdp23rsefpokhwqtqts4ooq4mqmne7qbkxe4fsiq23or2b4f3@ch74xearjddq>
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

6a7bb6ccd005 xfs: reduce ilock roundtrips in xfs_qm_vop_dqalloc

19 new commits:

Christoph Hellwig (19):
      [0ec73eb3f123] xfs: add a xfs_groups_to_rfsbs helper
      [204c8f77e8d4] xfs: don't leak a locked dquot when xfs_dquot_attach_buf fails
      [005d5ae0c585] xfs: make qi_dquots a 64-bit value
      [36cebabde786] xfs: don't treat all radix_tree_insert errors as -EEXIST
      [6129b088e1f1] xfs: remove xfs_dqunlock and friends
      [0c5e80bd579f] xfs: use a lockref for the xfs_dquot reference count
      [6b6e6e752116] xfs: remove xfs_qm_dqput and optimize dropping dquot references
      [0494f04643de] xfs: consolidate q_qlock locking in xfs_qm_dqget and xfs_qm_dqget_inode
      [d0f93c0d7c9d] xfs: xfs_qm_dqattach_one is never called with a non-NULL *IO_idqpp
      [bf5066e169ee] xfs: fold xfs_qm_dqattach_one into xfs_qm_dqget_inode
      [55c1bc3eb9d0] xfs: return the dquot unlocked from xfs_qm_dqget
      [e85e74e4c9a6] xfs: remove q_qlock locking in xfs_qm_scall_setqlim
      [a536bf9bec6a] xfs: push q_qlock acquisition from xchk_dquot_iter to the callers.
      [bfca8760f47e] xfs: move q_qlock locking into xchk_quota_item
      [7dd30acb4b37] xfs: move q_qlock locking into xqcheck_compare_dquot
      [a2ebb21f8ae1] xfs: move quota locking into xqcheck_commit_dquot
      [b6d2ab27cc84] xfs: move quota locking into xrep_quota_item
      [13d3c1a04562] xfs: move xfs_dquot_tree calls into xfs_qm_dqget_cache_{lookup,insert}
      [6a7bb6ccd005] xfs: reduce ilock roundtrips in xfs_qm_vop_dqalloc

Code Diffstat:

 fs/xfs/libxfs/xfs_group.h        |   9 +++
 fs/xfs/libxfs/xfs_quota_defs.h   |   4 +-
 fs/xfs/libxfs/xfs_rtgroup.h      |   8 ++
 fs/xfs/scrub/quota.c             |   8 +-
 fs/xfs/scrub/quota_repair.c      |  18 ++---
 fs/xfs/scrub/quotacheck.c        |  11 ++-
 fs/xfs/scrub/quotacheck_repair.c |  21 +-----
 fs/xfs/xfs_dquot.c               | 143 +++++++++++++++---------------------
 fs/xfs/xfs_dquot.h               |  22 +-----
 fs/xfs/xfs_dquot_item.c          |   6 +-
 fs/xfs/xfs_qm.c                  | 154 +++++++++++----------------------------
 fs/xfs/xfs_qm.h                  |   2 +-
 fs/xfs/xfs_qm_bhv.c              |   4 +-
 fs/xfs/xfs_qm_syscalls.c         |  10 ++-
 fs/xfs/xfs_quotaops.c            |   2 +-
 fs/xfs/xfs_trace.h               |   6 +-
 fs/xfs/xfs_trans_dquot.c         |  18 ++---
 fs/xfs/xfs_zone_gc.c             |   3 +-
 fs/xfs/xfs_zone_space_resv.c     |   8 +-
 19 files changed, 169 insertions(+), 288 deletions(-)
