Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0634908A1
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 14:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789051185; cv=none; b=APHGGn0riCy6JbsM9xwQ8JGUvnwsepViku0Gwc0aTPQ28eEvO545tr/qftcbtmmW+fFYR4VozA8WP6V2mi+HATSdgUYVDreLFUYOlJNmt76mR4/VvqUg64k7fVLNUa/vme5vzZtb0sDVoD7PdYdH/hb9f9uVWuXnUEiMCMQK5I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789051185; c=relaxed/simple;
	bh=EEcFqEmiO98hXAH+4li1PZ1rZno8saCGbGZdVKCeHDo=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=C/Alw95rPWQWeeLVfQrGc/SHg9kNJews6GDUUjJijY6WzvC93oelKxSdFWCLl2ScVCttStAZpDo+HJz2AQuyMv75h9oIDhTYTpEesGG0jug4Qvfpqo9R1MgoaX3jKc7CISRMvtpn3sx6GgW1b1nCuBqPfQG/a5dDAtRszvCEcsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NgdhK+gy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NgdhK+gy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4861F000FF
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 14:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789051184;
	bh=XAYsclo3hQBkAGunE0/E2WQH90NR05M1TX2YNajqmBs=;
	h=Date:From:To:Subject;
	b=NgdhK+gyE84pklemEF7dK0PSqaAbgY/Xilq/Jm7oy9VnuzrXYKrr4NTqCqozIvGoz
	 D4+4FcxJRVl9cbiTz/FleYb0SsPmNGfGK6oG+u9rmdUV6xl1LHo/1gSi6sEJ11LPV7
	 9Owu/nZl8eL2X21i85trxZ/yKRJ4ueoZcPcrt9si/UOLPT/0ZWDE+2JHVgfXL5mUq9
	 ELksOYnx6JQ11e9lWi3/Nk/ll4MEYQNlMgfiCbo/EtNYx5c3FYcCEjLGuz8ZZ09D63
	 9xUxyX0NK8jgyFdkU4nxJQWgR+JeK//HuPqAAF8+lx3HnTSWLXgs5PIgAAoqljWk0B
	 0Fj07z6th5mLg==
Date: Thu, 10 Sep 2026 16:39:40 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next rebased to 6e91b1b9c694
Message-ID: <aqLASMeEdicH0L-D@andromeda.toxiclabs.cc>
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

	gitolite.kernel.org:/pub/scm/fs/xfs/xfs-linux.git

has just been *REBASED*.

Shigeru Yoshida noticed that something went wrong on the previous pull
with patch:
xfs: take hm->lock in xfs_ioc_health_monitor() before insert

For whatever reason the mutex_unlock() turned into a mutex_lock() when I
pulled it from the list.
I didn't manually touch any of the patches I committed today, so I
believe something went pretty wrong with git am while I was pulling the
patches.
I'm removing the patch from for-next and 7.3-fixes while I investigate
what happened. I'll manually pull the patch later today.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

6e91b1b9c694 Merge branch 'xfs-7.3-fixes' into for-next

12 new commits:

Anuj Gupta (1):
      [50ba24ccb9a9] xfs: set IOMAP_F_INTEGRITY for zoned writes on integrity devices

Carlos Maiolino (1):
      [6e91b1b9c694] Merge branch 'xfs-7.3-fixes' into for-next

Christoph Hellwig (3):
      [ad0033e2dbd3] xfs: also flush the RT device cache in xlog_write_iclog
      [c84455c683eb] xfs: don't continue on error in xfs_fsync
      [761e015e5a54] xfs: avoid extra cache flushes for multi-device file systems in xfs_fsync

Darrick J. Wong (6):
      [568a1588b906] xfs: snapshot scrub stats when rendering them
      [0ae61c331ec5] xfs: report healthy filesystem events in scrub stats
      [d3dc979a49df] xfs: report runtime failures in scrub
      [341f03865d07] xfs: remove redundant function declaration
      [3466dfef0a20] xfs: snapshot old AGFL before rewriting it
      [eaf580538eb1] xfs: bail out on bitmap errors in xrep_agfl_fill

Zizhi Wo (1):
      [157dcb8230a4] xfs: remove several unused and never-implemented declarations

Code Diffstat:

 fs/xfs/scrub/agheader_repair.c | 39 +++++++++++++++++++++++++----------
 fs/xfs/scrub/common.h          |  1 -
 fs/xfs/scrub/dabtree.h         |  2 --
 fs/xfs/scrub/scrub.h           |  1 -
 fs/xfs/scrub/stats.c           | 45 ++++++++++++++++++++++++++--------------
 fs/xfs/scrub/tempfile.h        |  4 ----
 fs/xfs/xfs_buf_item.h          |  1 -
 fs/xfs/xfs_file.c              | 47 +++++++++++++-----------------------------
 fs/xfs/xfs_inode.h             |  1 -
 fs/xfs/xfs_iomap.h             |  2 ++
 fs/xfs/xfs_log.c               | 45 +++++++++++++++++++++++++++-------------
 fs/xfs/xfs_log.h               |  2 --
 fs/xfs/xfs_log_cil.c           |  7 ++++---
 13 files changed, 108 insertions(+), 89 deletions(-)

