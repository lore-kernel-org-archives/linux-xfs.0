Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F34035E94F;
	Mon, 21 Sep 2026 06:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971232; cv=none; b=rpVTYEM0RO2Sa9zs1QJ0xvo7hdSGQGRaNaK+cjmorH9QT5Rr8ARZQe+QBHU158K86wmhtHlSS1Xm+HOnMRK6rqNPiW1ea3nAzXDej1YGW2gF/gFLz57hi+jn+t3su54i0PK5kIiDqzZPqhy0SuYvMtKy4vH330qksVj7ENmjhnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971232; c=relaxed/simple;
	bh=O7wiP4RoYNefZXtG2d+PyVcnq4CLXr/mfK4r/ArfLeE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=ay90LxX8nV0CMYB6XRgqYG3NOtb4ICpgKuMrcGmSjXkDj8dy2r0Z1FgatGqITuIu3n3zwKMTbUffepzLkf5vQkzTiCwKPHbsmvQlHNyuJqXjqVCZwfN9UaFmyhpK4DqxrHIYnILfuyERy0bCjau4DA8qnEaA0s9qqRk7k6+XX1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mJorVSS0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mJorVSS0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0458B1F000FF;
	Mon, 21 Sep 2026 06:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971231;
	bh=bnHVGm1Oyh/jGCDxOySP77NwK38sjXrSjs5MWPA98N8=;
	h=Date:Subject:From:To:Cc;
	b=mJorVSS0m+ZJVVFWCmEepnGszTmC3oxt7xozTrRU1fqfMfy5McL0t38t43jrbsDGr
	 npE4186AyYZojU+3Rbv0wjsdXBzU8iapahCG2BTzh0laBRm5UDO8mSmWJ0UvfaPH4a
	 h2RrXD6gn6QFLa+DOQJ+z3XSOhlNlEj2zYL2NI+43QZdHZ0LJ5ckOVA5Cxymr61i9w
	 51g+NOsrej+VRAhiyVNsKLM7eqE0gf3sCE3V/ysEzrtVytkDTE4aKydCMPdIiS5iI3
	 HxOeaLykt6r2nZm0AZQDCGBnHKEpgDb69f0er8bCWLTdZo3RYBTaLcHPRGbIBfTHmg
	 9kNiybmbM+Twg==
Date: Sun, 20 Sep 2026 23:13:50 -0700
Subject: [PATCHSET] xfs: LLM-inspired bug fixes, part 16
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a sixteenth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-16
---
Commits in this patchset:
 * xfs: fix missing xfs_qm_adjust_dqlimits call in quotacheck repair
 * xfs: online quotacheck must dirty dquot if enforcement adjustments needed
 * xfs: fix buffer overruns in xfs_ioc_attr_list
 * xfs: clean up after failed metafile relinking
 * xfs: pass xfs_trans_resv object to reservation calculation helpers
 * xfs: fix xfs_rename_space_res for non-pptr filesystems
 * xfs: fix ondisk symlink target validation in xrep_dinode_check_dfork
 * xfs: fix maximum atomic cow length computation
 * xfs: add missing healthmon trace strings
 * xfarray: don't crash when sorting if array element crosses a folio
 * xfarray: don't allow users to unset in the middle of an array
 * xfs: don't allow sorting sparse arrays
 * xfs: simply the free space btree repair code
 * xfarray: warn against sorting arrays with identical elements
---
 fs/xfs/libxfs/xfs_metadir.h                        |    5 -
 fs/xfs/libxfs/xfs_symlink_remote.h                 |    2 
 fs/xfs/scrub/xfarray.h                             |    9 +
 fs/xfs/xfs_dquot.h                                 |    3 
 fs/xfs/xfs_trace.h                                 |   28 ++++
 .../filesystems/xfs/xfs-online-fsck-design.rst     |   13 --
 fs/xfs/libxfs/xfs_dquot_buf.c                      |   13 --
 fs/xfs/libxfs/xfs_inode_fork.c                     |    4 -
 fs/xfs/libxfs/xfs_metadir.c                        |   30 ++++-
 fs/xfs/libxfs/xfs_symlink_remote.c                 |    8 +
 fs/xfs/libxfs/xfs_trans_resv.c                     |   38 +++---
 fs/xfs/libxfs/xfs_trans_space.c                    |    6 -
 fs/xfs/scrub/alloc_repair.c                        |   15 +-
 fs/xfs/scrub/inode_repair.c                        |   26 ++++
 fs/xfs/scrub/quota_repair.c                        |    5 -
 fs/xfs/scrub/quotacheck_repair.c                   |   54 ++++++++
 fs/xfs/scrub/xfarray.c                             |  133 ++++++--------------
 fs/xfs/xfs_dquot.c                                 |   27 +++-
 fs/xfs/xfs_handle.c                                |    2 
 fs/xfs/xfs_qm.c                                    |    6 -
 fs/xfs/xfs_qm_syscalls.c                           |   17 +--
 fs/xfs/xfs_reflink.c                               |    7 +
 fs/xfs/xfs_trans_dquot.c                           |    6 -
 23 files changed, 252 insertions(+), 205 deletions(-)

