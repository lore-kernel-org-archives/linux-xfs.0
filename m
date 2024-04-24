Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F54113340B
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929713; cv=none; b=o4QmaeOwLOMHJcJLDkQw84qFN7cZh2RymIBq6cP467WlpyfLy3+PMtrdJUQySZ5PGdLL0mOj47iUPCZrh36Cb78sc739QsXMfR2Dl4jxGvAlYAxrWf76qvyshjy0b7BqcEWYR0dY5wmPK9+g7dlir14/L5/64i/l7C7+DbT9BIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929713; c=relaxed/simple;
	bh=B+Xj8HGakEKyOOzCB35nTqDlD8aYzx2Gr5g2sgddbco=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=l0lYdOdZX6pXe3hSKAFeO6Vax0z6P4LSllhXaC9IlhJ9IyFsr+UKE+GqXDZbSNhCQO+cXgAmXu9lUKzttf7INWkUfyFMyiikt9VDcXLC19Pxan23CZptDyu4KPrm9asOmv9im6xcWsR225Ql3rjVqxX9uQhqMN+WvmQXOdgsBZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MtQdozPc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MtQdozPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30959C116B1;
	Wed, 24 Apr 2024 03:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929713;
	bh=B+Xj8HGakEKyOOzCB35nTqDlD8aYzx2Gr5g2sgddbco=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MtQdozPcHSeLimbxKhGWVaj7NrqJJAGH7KVFaLvhtXNwWt05/yiTdf+wEjiS1hEjM
	 0VwBYo4l1XJfBurBDOP386B6+u8d4I1XxhRc5/ufuSVjnXdhqFzKhOgodXMUmMbc+L
	 48Jd7UQUMOp6AB4dUrxdhUYcSQOjVBMq9wqCEdpgvNzjPJaS9YUtzY+anEcwzdproi
	 YdvmQKk0Io7VXiAyqWGLoMTJIofN+hu/pdF1tbHH1TQPL/LgPMBi3Bf/ADqbEqblVY
	 wY41Ue0QZ9ma+jFDppp+rwB/W9rRxdse3HbddQ2RJ4tp05K0Qp4AEWKSLhMM1/BcHW
	 lgCTmUAHba2wQ==
Date: Tue, 23 Apr 2024 20:35:12 -0700
Subject: [GIT PULL 6/9] xfs: detect and correct directory tree problems
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392952262.1941278.14474287012383303820.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240424033018.GB360940@frogsfrogsfrogs>
References: <20240424033018.GB360940@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 327ed702d84034879572812f580cb769848af7ae:

xfs: inode repair should ensure there's an attr fork to store parent pointers (2024-04-23 16:55:16 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-directory-tree-6.10_2024-04-23

for you to fetch changes up to 3f31406aef493b3f19020909d29974e28253f91c:

xfs: fix corruptions in the directory tree (2024-04-23 16:55:17 -0700)

----------------------------------------------------------------
xfs: detect and correct directory tree problems [v13.4 6/9]

Historically, checking the tree-ness of the directory tree structure has
not been complete.  Cycles of subdirectories break the tree properties,
as do subdirectories with multiple parents.  It's easy enough for DFS to
detect problems as long as one of the participants is reachable from the
root, but this technique cannot find unconnected cycles.

Directory parent pointers change that, because we can discover all of
these problems from a simple walk from a subdirectory towards the root.
For each child we start with, if the walk terminates without reaching
the root, we know the path is disconnected and ought to be attached to
the lost and found.  If we find ourselves, we know this is a cycle and
can delete an incoming edge.  If we find multiple paths to the root, we
know to delete an incoming edge.

Even better, once we've finished walking paths, we've identified the
good ones and know which other path(s) to remove.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs: teach online scrub to find directory tree structure problems
xfs: invalidate dirloop scrub path data when concurrent updates happen
xfs: report directory tree corruption in the health information
xfs: fix corruptions in the directory tree

fs/xfs/Makefile               |   2 +
fs/xfs/libxfs/xfs_fs.h        |   4 +-
fs/xfs/libxfs/xfs_health.h    |   4 +-
fs/xfs/scrub/common.h         |   1 +
fs/xfs/scrub/dirtree.c        | 985 ++++++++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/dirtree.h        | 178 ++++++++
fs/xfs/scrub/dirtree_repair.c | 821 +++++++++++++++++++++++++++++++++++
fs/xfs/scrub/health.c         |   1 +
fs/xfs/scrub/ino_bitmap.h     |  37 ++
fs/xfs/scrub/orphanage.c      |   6 +
fs/xfs/scrub/orphanage.h      |   8 +
fs/xfs/scrub/repair.h         |   4 +
fs/xfs/scrub/scrub.c          |   7 +
fs/xfs/scrub/scrub.h          |   1 +
fs/xfs/scrub/stats.c          |   1 +
fs/xfs/scrub/trace.c          |   4 +
fs/xfs/scrub/trace.h          | 272 +++++++++++-
fs/xfs/scrub/xfarray.h        |   1 +
fs/xfs/xfs_health.c           |   1 +
fs/xfs/xfs_inode.c            |   2 +-
fs/xfs/xfs_inode.h            |   1 +
21 files changed, 2337 insertions(+), 4 deletions(-)
create mode 100644 fs/xfs/scrub/dirtree.c
create mode 100644 fs/xfs/scrub/dirtree.h
create mode 100644 fs/xfs/scrub/dirtree_repair.c
create mode 100644 fs/xfs/scrub/ino_bitmap.h

