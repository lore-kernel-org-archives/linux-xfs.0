Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E9D376EA
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706590998; cv=none; b=NTCKoyLVvztTWfEAxxlaIGTfM5t5nYkBeTLAMofBUqsfKolbpAJBu80kLmEZlbcSE8+fLEVrpCRvQeuuK4mkEpZxqTy/cBKgH3ANF6bH477D03JmJczF0vPxFtjK0GHj+n/DtmVq1JgTjLcNDCpmWMM0OpAEVy5JLj0xTgoeLu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706590998; c=relaxed/simple;
	bh=jZynGVwwZ+CkZVqpislJQI4X14DcCXidA6q6AA9efFI=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=JXNjLEhUVy5MBlTuX97+lZj+llapDB6NN1/iLRnREkl+Y+k6yKgUAVJMflPJPyk/R2y8W9JctDUkBTRaKI7m1jDtyjq6zywloo1H2bwSXvc4PEGXoNaRRJUUJNNTk/ltqNeIP/MZrD+yE204Lwgm4GkGQRa4/XJ6CM984xwIFM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ni3F0/N5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ni3F0/N5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A20CC433F1;
	Tue, 30 Jan 2024 05:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706590997;
	bh=jZynGVwwZ+CkZVqpislJQI4X14DcCXidA6q6AA9efFI=;
	h=Date:Subject:From:To:Cc:From;
	b=Ni3F0/N5BoMM0yY2xrmQ8HrmWu4obQU1IPOYWA8joGHE3IZFICCyj1m3OtquS5sex
	 dphlUOdzIWbMOqzx8Jqr1srCtkRNLOEIBfnWVtw7CW3bF4Ma7/CIJU98gSCOYCKMxl
	 BCC9j5qvlOEb8AV783H1ufrckGHKB9zzxjyJVyhv59lPJz7E/+WKxtM11Yh4M8Tp08
	 6R+aYD0xoEfJIiVkj3QqqeAyR1EX8S7Tmk4LwXvFTuZJN69ic1mvdoH8M1I//1TeWR
	 x0c9u/8NDSs8bs5JtUtZ/IZY74CfvmhWFGGnI5uLM9uwlveXDkHQX6xmyS3waIT9nP
	 goWZgV08CjhAg==
Date: Mon, 29 Jan 2024 21:03:16 -0800
Subject: [PATCHSET v29.2 3/7] xfs: online repair of quota counters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659062732.3353369.13810986670900011827.stgit@frogsfrogsfrogs>
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

This series uses the inode scanner and live update hook functionality
introduced in the last patchset to implement quotacheck on a live
filesystem.  The quotacheck scrubber builds an incore copy of the
dquot resource usage counters and compares it to the live dquots to
report discrepancies.

If the user chooses to repair the quota counters, the repair function
visits each incore dquot to update the counts from the live information.
The live update hooks are key to keeping the incore copy up to date.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-quotacheck

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-quotacheck

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-quotacheck
---
Commits in this patchset:
 * xfs: report the health of quota counts
 * xfs: create a xchk_trans_alloc_empty helper for scrub
 * xfs: create a helper to count per-device inode block usage
 * xfs: create a sparse load xfarray function
 * xfs: implement live quotacheck inode scan
 * xfs: track quota updates during live quotacheck
 * xfs: repair cannot update the summary counters when logging quota flags
 * xfs: repair dquots based on live quotacheck results
---
 fs/xfs/Makefile                  |    2 
 fs/xfs/libxfs/xfs_fs.h           |    4 
 fs/xfs/libxfs/xfs_health.h       |    4 
 fs/xfs/scrub/common.c            |   49 ++
 fs/xfs/scrub/common.h            |   11 
 fs/xfs/scrub/fscounters.c        |    2 
 fs/xfs/scrub/health.c            |    1 
 fs/xfs/scrub/quotacheck.c        |  867 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/quotacheck.h        |   76 +++
 fs/xfs/scrub/quotacheck_repair.c |  261 +++++++++++
 fs/xfs/scrub/repair.c            |   46 ++
 fs/xfs/scrub/repair.h            |    5 
 fs/xfs/scrub/scrub.c             |    9 
 fs/xfs/scrub/scrub.h             |   10 
 fs/xfs/scrub/stats.c             |    1 
 fs/xfs/scrub/trace.h             |   30 +
 fs/xfs/scrub/xfarray.h           |   19 +
 fs/xfs/xfs_health.c              |    1 
 fs/xfs/xfs_inode.c               |   16 +
 fs/xfs/xfs_inode.h               |    2 
 fs/xfs/xfs_qm.c                  |   23 +
 fs/xfs/xfs_qm.h                  |   16 +
 fs/xfs/xfs_qm_bhv.c              |    1 
 fs/xfs/xfs_quota.h               |   45 ++
 fs/xfs/xfs_trans_dquot.c         |  158 +++++++
 25 files changed, 1633 insertions(+), 26 deletions(-)
 create mode 100644 fs/xfs/scrub/quotacheck.c
 create mode 100644 fs/xfs/scrub/quotacheck.h
 create mode 100644 fs/xfs/scrub/quotacheck_repair.c

