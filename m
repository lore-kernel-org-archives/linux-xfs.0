Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB676AD7
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 05:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712121501; cv=none; b=DPUXEfEwwRNI+SWRABdH9jnGJAnEXPwsknMg3mYaSxjfv6KUiCzpHzLDwci6V6VRPz8TW7yHbzhEeF0xrFGj/R+Uy5o5GIQsuDYysw3z67NoqiHQOSMzyjATbJxLs4Lsgy91uOYdh/EZeNivrZb1TbiKbDPJbWltwsTuLlNvmpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712121501; c=relaxed/simple;
	bh=VsJZiSRy7mJSBBdFIZyzaKDqjj6pfM4B7Dvf+ukPU0c=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FXfO4ixvoDgQ3//36P8TCoSSLDQ08UQO0e6ngFrgg9SpcwdW5Zp5Ib/idRsLnxUC0vNfd06p/0wr96kw+wRukQWmDw06ubPO49YUvsX4X4CJ/ydnidb5Ip1J6qOu8T32vx1aSzuk9ozX4gsnl9pUAa05mz9QOVaK/UvyDGOU3mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=udoaMTT8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="udoaMTT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC5EC433C7;
	Wed,  3 Apr 2024 05:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712121501;
	bh=VsJZiSRy7mJSBBdFIZyzaKDqjj6pfM4B7Dvf+ukPU0c=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=udoaMTT89vDHh+FpyeOacd1JTYp6SFIiK2y6nAD4Ia54JREbBe5sJXi41G/DpQ6me
	 4cIeeCUtH2Ifaph0+XBEMaMUBEc01dR6sYgf4QpuCWTljZQWCUSSVSjswJAw4zloaY
	 l1c+7MNqdB+qWjk1k/DNI5MzVQDUWnziagVaLQDNSWuVGG7xZ1Qz/7Ct4ExN7bRWJi
	 4wSEXIDMRv9nD8Vt3g9V2tfw0BpTBm5X6gFTcd3ForNFjft2MmDtlOR1kV5M5AMyhi
	 XNP/lPQJZYtr8+uI9/1+vbT2YVRJ9arFhpp48AUeRGtsZphF1kNxsxbOVeb0UNx3ep
	 k2NJo/orR/86Q==
Subject: [PATCHSET] xfs: bug fixes for 6.9
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Date: Tue, 02 Apr 2024 22:18:20 -0700
Message-ID: <171212150033.1535150.8307366470561747407.stgit@frogsfrogsfrogs>
In-Reply-To: <171150379369.3216268.2525451022899750269.stgit@frogsfrogsfrogs>
References: <171150379369.3216268.2525451022899750269.stgit@frogsfrogsfrogs>
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

Bug fixes for XFS for 6.9.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-6.9-fixes
---
Commits in this patchset:
 * xfs: pass xfs_buf lookup flags to xfs_*read_agi
 * xfs: fix an AGI lock acquisition ordering problem in xrep_dinode_findmode
 * xfs: fix potential AGI <-> ILOCK ABBA deadlock in xrep_dinode_findmode_walk_directory
---
 fs/xfs/libxfs/xfs_ag.c           |    8 +++---
 fs/xfs/libxfs/xfs_ialloc.c       |   16 ++++++++----
 fs/xfs/libxfs/xfs_ialloc.h       |    5 ++--
 fs/xfs/libxfs/xfs_ialloc_btree.c |    4 ++-
 fs/xfs/scrub/common.c            |    4 ++-
 fs/xfs/scrub/fscounters.c        |    2 +-
 fs/xfs/scrub/inode_repair.c      |   50 +++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/iscan.c             |   36 +++++++++++++++++++++++++++
 fs/xfs/scrub/iscan.h             |   15 +++++++++++
 fs/xfs/scrub/repair.c            |    6 ++---
 fs/xfs/scrub/trace.h             |   10 ++++++--
 fs/xfs/xfs_inode.c               |    8 +++---
 fs/xfs/xfs_iwalk.c               |    4 ++-
 fs/xfs/xfs_log_recover.c         |    4 ++-
 14 files changed, 140 insertions(+), 32 deletions(-)

