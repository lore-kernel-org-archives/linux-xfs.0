Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530D01EBA0C;
	Mon, 18 Nov 2024 23:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731970895; cv=none; b=c2fnFIcGfCvDOaP2L4ijdXLLjnlrsVAD2piWzUOX5vxAgiZYsmaf6PqNZPyTNavEKtEtd5CTb0n0cBP7dCTd3O6LYQAGKJVMOk+RaZgb1MliGr9A/fZEpi7RvQ6ookbpF0jsMR9xyAhxqkWPjkhRUPjseroLfI2vIth6X14jk3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731970895; c=relaxed/simple;
	bh=bARq+IanWDi+o1bAx7pNfFQRqEtVG7WdE58XWrS4hxg=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=VM0hokOgUL3eav746jDutuRFfkRYtTQfUBRh3zdSRafZFbLCEZ4QUoS/If3fhEOtPV/6en8LdaJxYatQNu+r/1aTSC5iKJqwrBMbzpLVXKJwd9e7AgDesJwrrCEwNcQp+1lCNdlAnbTxQs5ZSsy4SRRQiIkx361PYSyT/uJ3mxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dna9yI5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dna9yI5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF073C4CED0;
	Mon, 18 Nov 2024 23:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731970893;
	bh=bARq+IanWDi+o1bAx7pNfFQRqEtVG7WdE58XWrS4hxg=;
	h=Date:Subject:From:To:Cc:From;
	b=Dna9yI5EladsgbJ1MBrR8PDiEsgRFQZcS9NSrUP5vDfjeh0yxiJh8xMTjVL8eV/VP
	 pKQZiA7p8FrJJGOOAKjZ3q2cHHAVnBS4PuekYSVj/W/96gpJ4TG5D7y1M6uQCBRjLt
	 ypuBru4xzkQRX/lLzwPpWfQ9nHvNme4qDwySTSIFLY4pX5YQy/LRPXH/ifa+GclMO5
	 8NlkwHxJR0gwom8KMbQ6RgEbAunl4lIG73Brh4+TEAHDHSZ2wkMK8drOQpcbULqnNH
	 E4wx7gYJSeu5mIzgfFsqnnrT5/bw0+n2YCZGgfTNQ30YmJ3Z85O890JWwutAvZq018
	 FIRbLN6epYeWA==
Date: Mon, 18 Nov 2024 15:01:33 -0800
Subject: [PATCHSET] xfs: bug fixes for 6.13
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: dan.carpenter@linaro.org, hch@lst.de, stable@vger.kernel.org,
 wozizhi@huawei.com, linux-xfs@vger.kernel.org
Message-ID: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Bug fixes for 6.13.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-fixes-6.13
---
Commits in this patchset:
 * xfs: fix off-by-one error in fsmap's end_daddr usage
 * xfs: metapath scrubber should use the already loaded inodes
 * xfs: keep quota directory inode loaded
 * xfs: return a 64-bit block count from xfs_btree_count_blocks
 * xfs: don't drop errno values when we fail to ficlone the entire range
 * xfs: separate healthy clearing mask during repair
 * xfs: set XFS_SICK_INO_SYMLINK_ZAPPED explicitly when zapping a symlink
 * xfs: mark metadir repair tempfiles with IRECOVERY
 * xfs: fix null bno_hint handling in xfs_rtallocate_rtg
 * xfs: fix error bailout in xfs_rtginode_create
---
 fs/xfs/libxfs/xfs_btree.c        |    4 +-
 fs/xfs/libxfs/xfs_btree.h        |    2 +
 fs/xfs/libxfs/xfs_ialloc_btree.c |    4 ++
 fs/xfs/libxfs/xfs_rtgroup.c      |    2 +
 fs/xfs/scrub/agheader.c          |    6 ++-
 fs/xfs/scrub/agheader_repair.c   |    6 ++-
 fs/xfs/scrub/fscounters.c        |    2 +
 fs/xfs/scrub/health.c            |   57 ++++++++++++++++++--------------
 fs/xfs/scrub/ialloc.c            |    4 +-
 fs/xfs/scrub/metapath.c          |   68 +++++++++++++++-----------------------
 fs/xfs/scrub/refcount.c          |    2 +
 fs/xfs/scrub/scrub.h             |    6 +++
 fs/xfs/scrub/symlink_repair.c    |    3 +-
 fs/xfs/scrub/tempfile.c          |   10 ++++--
 fs/xfs/xfs_bmap_util.c           |    2 +
 fs/xfs/xfs_file.c                |    8 ++++
 fs/xfs/xfs_fsmap.c               |   38 ++++++++++++---------
 fs/xfs/xfs_inode.h               |    2 +
 fs/xfs/xfs_qm.c                  |   47 ++++++++++++++------------
 fs/xfs/xfs_qm.h                  |    1 +
 fs/xfs/xfs_rtalloc.c             |    2 +
 21 files changed, 151 insertions(+), 125 deletions(-)

