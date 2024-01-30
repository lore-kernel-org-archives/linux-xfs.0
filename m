Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C08376F2
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591003; cv=none; b=eNnH+oLor+Rifo2nI6mKebQpOVCRhR326MEt2xSAfsMlQH8JXyqv3kNK7eT43/A0W6EnYJg5SGLwaO7jxdo3iSPaEygqJzlXmxzd05m0pYotC6DszwZR/ssFRT4fMX47rEZEso0Od+lm+n6XYYDMOxOE/T+80e1dHdEwX4wlHbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591003; c=relaxed/simple;
	bh=LADgwTdqn5Oc83qC7EXaIDUFQoUUBSqnl64C95FVGhA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=Vq4QWoxsNw6Z/M+E1A7+GsacKDTWCJBmppRBBxceML9PS3w1cbP62DQr/QTqRNgGIlPdAlZJMbLjyaUaA76tVhfLD65AKOiinhAwASmzsrXAQSrtuROxm0UiP4taA9ykyd1S7KaG5bulIne9YuszKmlRv8cbxwgF1H+zM369ZKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mYUuBqtQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mYUuBqtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA26C433C7;
	Tue, 30 Jan 2024 05:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591003;
	bh=LADgwTdqn5Oc83qC7EXaIDUFQoUUBSqnl64C95FVGhA=;
	h=Date:Subject:From:To:Cc:From;
	b=mYUuBqtQNfJPZPXiWNkSsqRA6dGhzGPXHysbPA4Y6igNxTYk/LoAtZCVGhsodA9d/
	 oppUwJWmLB5u2i+sOz5sS3MgySA5/9QN4tbDFj05L6PX5efW0emmDQSpENlBAhnMeA
	 LFNvXLNVh92sIvmuqe9qhfR/ar8izj1HH23znQ5gY5VRzJHDCKmd6WxX/ky4mrP4EM
	 ZnY5UxnytIxkTu+GbR+T9PSNkzfP50Fr1Y5oNcGfpw8Ik0/Mh/fGo32XirbYqhzbJW
	 J9s3WGXzRd5H7w19hLB/MOZXi2B4cq4RLBBNQX/OAs/j2B7fBsiV+AzyMznpPrUbGZ
	 VSCzRxYcxMH2w==
Date: Mon, 29 Jan 2024 21:03:22 -0800
Subject: [PATCHSET v29.2 4/7] xfs: online repair of file link counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659063247.3353617.664642117268018311.stgit@frogsfrogsfrogs>
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

Now that we've created the infrastructure to perform live scans of every
file in the filesystem and the necessary hook infrastructure to observe
live updates, use it to scan directories to compute the correct link
counts for files in the filesystem, and reset those link counts.

This patchset creates a tailored readdir implementation for scrub
because the regular version has to cycle ILOCKs to copy information to
userspace.  We can't cycle the ILOCK during the nlink scan and we don't
need all the other VFS support code (maintaining a readdir cursor and
translating XFS structures to VFS structures and back) so it was easier
to duplicate the code.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-nlinks

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-nlinks

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-nlinks
---
Commits in this patchset:
 * xfs: report health of inode link counts
 * xfs: teach scrub to check file nlinks
 * xfs: track directory entry updates during live nlinks fsck
 * xfs: teach repair to fix file nlinks
---
 fs/xfs/Makefile              |    2 
 fs/xfs/libxfs/xfs_fs.h       |    4 
 fs/xfs/libxfs/xfs_health.h   |    4 
 fs/xfs/scrub/common.c        |    3 
 fs/xfs/scrub/common.h        |    1 
 fs/xfs/scrub/health.c        |    1 
 fs/xfs/scrub/nlinks.c        |  930 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/nlinks.h        |  102 +++++
 fs/xfs/scrub/nlinks_repair.c |  223 ++++++++++
 fs/xfs/scrub/repair.h        |    2 
 fs/xfs/scrub/scrub.c         |    9 
 fs/xfs/scrub/scrub.h         |    5 
 fs/xfs/scrub/stats.c         |    1 
 fs/xfs/scrub/trace.c         |    2 
 fs/xfs/scrub/trace.h         |  183 ++++++++
 fs/xfs/xfs_health.c          |    1 
 fs/xfs/xfs_inode.c           |  108 +++++
 fs/xfs/xfs_inode.h           |   31 +
 fs/xfs/xfs_mount.h           |    3 
 fs/xfs/xfs_super.c           |    2 
 fs/xfs/xfs_symlink.c         |    1 
 21 files changed, 1614 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/scrub/nlinks.c
 create mode 100644 fs/xfs/scrub/nlinks.h
 create mode 100644 fs/xfs/scrub/nlinks_repair.c

