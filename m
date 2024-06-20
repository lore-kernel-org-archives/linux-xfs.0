Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBC413777F
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718925214; cv=none; b=mg58z4c1q6SRLHE6vcOphaSxoVi94QdH7HQxn6Kl+ROepJQwoldWQZk5bTAgZzjs7oLxDnWlK9wmZ2OR/Vj+ZsjCmnBoflq+1scvFtLCSp4d5yKflKD3QGh6pcK5J0zpczwXJ0gMHYOehOSWdEOb58EngD/zFSi7ibz1UdFSIUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718925214; c=relaxed/simple;
	bh=fmXc1Hoy/w0IrB7HT3vDY4aZ7tzSaUpg069T73xqU8w=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=Opa6FmERCtvz7ulKDx3NdYSZp1RE3uN3utyvBEh6bva5+eWAsSNKnYgNT6lNFaQF2e9BjUkfABrrLH8GbMYPE7rCR1MM5SV8YsdQkCybEn8GSCwYeNIg5Ck6rIJQXbDSYnndVK8F40RE3iGiTR6t2P1tWpulNCVRLQn7u04NEmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SscEaTow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SscEaTow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46AAC2BD10;
	Thu, 20 Jun 2024 23:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718925214;
	bh=fmXc1Hoy/w0IrB7HT3vDY4aZ7tzSaUpg069T73xqU8w=;
	h=Date:Subject:From:To:Cc:From;
	b=SscEaTowXo3wioszFLiaPwWwzPeGWz7OAP4e2BJQOqR/QwKBOHvD94amRr6e57qDO
	 HA9n3qlGF2DNaolW29FimSfQIy9TMnbMrP9AZVhC7uUOZzdVHZbRypE2xjj+i5Uffm
	 QjoeWBj6e+z9IZIhfbL47/sRjbjQEBdowZynMs4zFpyC9gnqFpb6ZGunluFNL6WI9t
	 iGmgmc512RI0lYjUpwnsrizL2SrLlBUV6lIC2xZtOSST9+Fkom6JARIrShQZ7UeWTp
	 rPaPr1iCbx0kr3GUX3fcHQO6dx8OKspx5d9Nr7HVhO5+yGWa1M9YSLC9I6r5RqekQX
	 Fl7muTSp4J1WA==
Date: Thu, 20 Jun 2024 16:13:34 -0700
Subject: [PATCHSET v2] xfs: random fixes for 6.10
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, chandanbabu@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171892459218.3192151.10366641366672957906.stgit@frogsfrogsfrogs>
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

Here are some bugfixes for 6.10.  The first two patches are from hch,
and fix some longstanding delalloc leaks that only came to light now
that we've enabled it for realtime.

The second two fixes are from me -- one fixes a bug when we run out
of space for cow preallocations when alwayscow is turned on (xfs/205),
and the other corrects overzealous inode validation that causes log
recovery failure with generic/388.

The last patch is a debugging patch to ensure that transactions never
commit corrupt inodes, buffers, or dquots.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes-6.10
---
Commits in this patchset:
 * xfs: fix freeing speculative preallocations for preallocated files
 * xfs: restrict when we try to align cow fork delalloc to cowextsz hints
 * xfs: allow unlinked symlinks and dirs with zero size
 * xfs: verify buffer, inode, and dquot items every tx commit
 * xfs: fix direction in XFS_IOC_EXCHANGE_RANGE
 * xfs: honor init_xattrs in xfs_init_new_inode for !ATTR fs
---
 fs/xfs/Kconfig                |   12 ++++++++++++
 fs/xfs/libxfs/xfs_bmap.c      |   31 +++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_fs.h        |    2 +-
 fs/xfs/libxfs/xfs_inode_buf.c |   23 ++++++++++++++++++-----
 fs/xfs/xfs.h                  |    4 ++++
 fs/xfs/xfs_bmap_util.c        |   30 ++++++++++++++++++++++--------
 fs/xfs/xfs_bmap_util.h        |    2 +-
 fs/xfs/xfs_buf_item.c         |   32 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dquot_item.c       |   31 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.c           |    2 +-
 fs/xfs/xfs_inode.c            |   24 +++++++++++++-----------
 fs/xfs/xfs_inode_item.c       |   32 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.c            |   34 ++++++++++++----------------------
 13 files changed, 206 insertions(+), 53 deletions(-)

