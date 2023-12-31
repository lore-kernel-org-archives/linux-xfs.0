Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB738B65C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IIetVEbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BEEC433C8;
	Sun, 31 Dec 2023 19:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704050768;
	bh=pG8oIK3HV+89haj4JJcILsvR8rXN7gh7wtjNwri+O2g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IIetVEbI1VQ7ogjHE6kU6p6f0mg/HdTpatsvR4CNyBS5X+lfmnU4VFB1XYBkQmN1S
	 k/p6VpEpvsRlq46RV70zOWSqL9wROfDS4fY8hU8cxDrkKDJ0XDTaRRq9BVSohcH+Y/
	 sU4aWoAHQfAoBqz7FYI56A1YVkZtqDhP9b8P+XqZ2ZRxDpXBJBnRFsPX1S3Z8iyxyN
	 SXafn8tHjqnBQFtcm195tI0Rol3e6e8pBLDRHPIpoebXPfgGtP7LhwASPiwKaOOc11
	 7PO9nttNtKH1xJ1AT539gLJcQ+omviF8hpMsVilqwHZrXq3E9EI/fnigt5zDYoi6FG
	 EuYwl6TxNnSZQ==
Date: Sun, 31 Dec 2023 11:26:07 -0800
Subject: [PATCHSET v29.0 03/28] xfs: online repair of quota counters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404827380.1748002.1474710373694082536.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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
 fs/xfs/Makefile                  |    2 
 fs/xfs/libxfs/xfs_fs.h           |    4 
 fs/xfs/libxfs/xfs_health.h       |    4 
 fs/xfs/scrub/common.c            |   47 ++
 fs/xfs/scrub/common.h            |   11 
 fs/xfs/scrub/fscounters.c        |    2 
 fs/xfs/scrub/health.c            |    1 
 fs/xfs/scrub/quotacheck.c        |  862 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/quotacheck.h        |   76 +++
 fs/xfs/scrub/quotacheck_repair.c |  261 ++++++++++++
 fs/xfs/scrub/repair.c            |   46 ++
 fs/xfs/scrub/repair.h            |    5 
 fs/xfs/scrub/scrub.c             |    9 
 fs/xfs/scrub/scrub.h             |   10 
 fs/xfs/scrub/stats.c             |    1 
 fs/xfs/scrub/trace.h             |   30 +
 fs/xfs/scrub/xfarray.h           |   19 +
 fs/xfs/xfs_health.c              |    1 
 fs/xfs/xfs_inode.c               |   21 +
 fs/xfs/xfs_inode.h               |    2 
 fs/xfs/xfs_qm.c                  |   23 +
 fs/xfs/xfs_qm.h                  |   16 +
 fs/xfs/xfs_qm_bhv.c              |    1 
 fs/xfs/xfs_quota.h               |   45 ++
 fs/xfs/xfs_trans_dquot.c         |  158 +++++++
 25 files changed, 1632 insertions(+), 25 deletions(-)
 create mode 100644 fs/xfs/scrub/quotacheck.c
 create mode 100644 fs/xfs/scrub/quotacheck.h
 create mode 100644 fs/xfs/scrub/quotacheck_repair.c

