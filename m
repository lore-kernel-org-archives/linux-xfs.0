Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D4B1CB50F
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725302618; cv=none; b=Ouavds7VdcOjlT+Y2MIrBtWVhs7UU5h07gnMl/ouoyjXB0lFBJ4dLzBSNHw64pyp4LOxkm/aRXzG6+eKYXtosfhJgBLJf1KtuwnyDTw+4KmGf1lsFNP/ExPtQZ4wofYlHi33Lm+vEYhTYci5iM/hhMFE8n2VkMPTZH9Zugyyvx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725302618; c=relaxed/simple;
	bh=5NudYtpqF7XHNh7K6AUtYmIaJoO+k+smGo4wsWteGt8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=DDZR+6jT7vM7vqx65avo0LARppBicliYAApE5E3PcIOV/40XgnUazV3GpE+kd2sOr6WZu1kKjLXL14fkkYCiW+Id4UtnwVZAQapL8nn8XGgup8mxwrSYPGwoCtPHV08uBpU2VTOLvfBi7dzDtI1VKrV1vH+NC88cQAWmo7SDb8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CbKhGUYP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CbKhGUYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4204BC4CEC2;
	Mon,  2 Sep 2024 18:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725302618;
	bh=5NudYtpqF7XHNh7K6AUtYmIaJoO+k+smGo4wsWteGt8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CbKhGUYPy1ZjGHrp/m0AAAwzlm+mCw+Frip76+AQ6D3OlcqF+xxaFVqh+dJhNj+84
	 wGY5PJTkfvJojqtXLsly2OYOXEbFB5MnRr/kTukHy6P2ZX671C2nYdluPX9fS2YE7L
	 38Jma8bpSJ2Ekppx+4nXgWOVgVN+9VBqSn4utz4kJ763VR6WzR6MEJXD2EzQish1wH
	 ZsVnC2an3S5qg2xI2gDvJqap3TtLDGIDkJvhx0vMHZLbNTyUgpfEsG3OHFBExtQB60
	 YuJ6JktiwqpV/pt3/n0xrErY2TDeBDTOaxuyiI7KsZHeg8Ckq8FmyxxRvFQZjHik7F
	 OsY65/rY/28jA==
Date: Mon, 02 Sep 2024 11:43:37 -0700
Subject: [GIT PULL 8/8] xfs: cleanups for inode rooted btree code
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172530248669.3348968.12555145296914101501.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240902184002.GY6224@frogsfrogsfrogs>
References: <20240902184002.GY6224@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.12-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit de55149b6639e903c4d06eb0474ab2c05060e61d:

xfs: fix a sloppy memory handling bug in xfs_iroot_realloc (2024-09-01 08:58:20 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/btree-cleanups-6.12_2024-09-02

for you to fetch changes up to 411a71256de6f5a0015a28929cfbe6bc36c503dc:

xfs: standardize the btree maxrecs function parameters (2024-09-01 08:58:20 -0700)

----------------------------------------------------------------
xfs: cleanups for inode rooted btree code [v4.2 8/8]

This series prepares the btree code to support realtime reverse mapping btrees
by refactoring xfs_ifork_realloc to be fed a per-btree ops structure so that it
can handle multiple types of inode-rooted btrees.  It moves on to refactoring
the btree code to use the new realloc routines.

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: replace shouty XFS_BM{BT,DR} macros
xfs: standardize the btree maxrecs function parameters

fs/xfs/libxfs/xfs_alloc_btree.c    |   6 +-
fs/xfs/libxfs/xfs_alloc_btree.h    |   3 +-
fs/xfs/libxfs/xfs_attr_leaf.c      |   8 +-
fs/xfs/libxfs/xfs_bmap.c           |  42 ++++----
fs/xfs/libxfs/xfs_bmap_btree.c     |  24 ++---
fs/xfs/libxfs/xfs_bmap_btree.h     | 207 +++++++++++++++++++++++++------------
fs/xfs/libxfs/xfs_ialloc.c         |   4 +-
fs/xfs/libxfs/xfs_ialloc_btree.c   |   6 +-
fs/xfs/libxfs/xfs_ialloc_btree.h   |   3 +-
fs/xfs/libxfs/xfs_inode_fork.c     |  34 +++---
fs/xfs/libxfs/xfs_refcount_btree.c |   5 +-
fs/xfs/libxfs/xfs_refcount_btree.h |   3 +-
fs/xfs/libxfs/xfs_rmap_btree.c     |   7 +-
fs/xfs/libxfs/xfs_rmap_btree.h     |   3 +-
fs/xfs/libxfs/xfs_sb.c             |  16 +--
fs/xfs/libxfs/xfs_trans_resv.c     |   2 +-
fs/xfs/scrub/bmap_repair.c         |   2 +-
fs/xfs/scrub/inode_repair.c        |  12 +--
fs/xfs/xfs_bmap_util.c             |   4 +-
19 files changed, 237 insertions(+), 154 deletions(-)

