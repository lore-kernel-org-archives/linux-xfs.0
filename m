Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608991DA21
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224261; cv=none; b=oRJInmTyKk4oovZK8UQErloTQDIu4FM1BFcmEtfdE6syDdnuCdZUra4o/02cABQES+JXpNmiAox9aFWCThRZ2sKVceU9DnvBuyvsceMiiuF1oPwA+VhUIbuEk1PjsHpnBJJXL/xposwv4bQWSyQa5Pw3J8wH2kKTkbVN/zXTzd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224261; c=relaxed/simple;
	bh=x4efajZ16UsMhwaCQFQ5lDbgaJJzPFJE0S/D4ImglXA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OSzdpqYnZFv4ofmH7PJG05BsCLh0nvJ83C3kGrQISS/9A2cL0VYjC7OXpMjbXuLKIRivlx9Ibtj/p97J81n7o8dm+iFlKgDXlB2tDqpwol3PdrPQEKtJ6JLAFDs7d4LBRvP/iuFfPRIaBdSnickkCDVRWySrNiRGVzsoF0fCRvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZT8IUyR8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZT8IUyR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A16C113CC;
	Mon, 15 Apr 2024 23:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224261;
	bh=x4efajZ16UsMhwaCQFQ5lDbgaJJzPFJE0S/D4ImglXA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZT8IUyR8VJkLm526Vbhos53Ns+opzpuRVU6jSfk+aY68UWiS+sGSnPM+FSLlRlbIj
	 3KPaLJ8jjaTfhbYgzscfcdruRS9d8v5lFrwV0w846yY2d6dGd4pp0HMD1auM00BYig
	 iGl78Y4LCG0qTZbubWv5xqGoSl9te0N24kVSYZeVM0dbEIxCAdr5K3khTkM1Db5u0e
	 Ng8YjQ++mMGsA8Phna+mPr8FBqRskEdmoVVK9CMu8JDAJ+wSX1+6oG1O9pDeCwzfK+
	 TXInnmYyQYtH/lEa8EiYSw+aBbY+zozyMQTz2ENEqhNKvr+yPZDks21UQE/uB9I2yx
	 NNXXVjT4MLIYg==
Date: Mon, 15 Apr 2024 16:37:40 -0700
Subject: [PATCHSET v13.2 16/16] xfs: retain ILOCK during directory updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
 Catherine Hoang <catherine.hoang@oracle.com>,
 Allison Henderson <allison.henderson@oracle.com>, hch@lst.de,
 allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171322386495.92087.3714112630678704273.stgit@frogsfrogsfrogs>
In-Reply-To: <20240415232853.GE11948@frogsfrogsfrogs>
References: <20240415232853.GE11948@frogsfrogsfrogs>
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

This series changes the directory update code to retain the ILOCK on all
files involved in a rename until the end of the operation.  The upcoming
parent pointers patchset applies parent pointers in a separate chained
update from the actual directory update, which is why it is now
necessary to keep the ILOCK instead of dropping it after the first
transaction in the chain.

As a side effect, we no longer need to hold the IOLOCK during an rmapbt
scan of inodes to serialize the scan with ongoing directory updates.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=retain-ilock-during-dir-ops-6.10
---
Commits in this patchset:
 * xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
 * xfs: Increase XFS_QM_TRANS_MAXDQS to 5
 * xfs: Hold inode locks in xfs_ialloc
 * xfs: Hold inode locks in xfs_trans_alloc_dir
 * xfs: Hold inode locks in xfs_rename
 * xfs: don't pick up IOLOCK during rmapbt repair scan
 * xfs: unlock new repair tempfiles after creation
---
 fs/xfs/libxfs/xfs_defer.c  |    6 ++-
 fs/xfs/libxfs/xfs_defer.h  |    8 +++-
 fs/xfs/scrub/rmap_repair.c |   16 -------
 fs/xfs/scrub/tempfile.c    |    2 +
 fs/xfs/xfs_dquot.c         |   41 ++++++++++++++++++
 fs/xfs/xfs_dquot.h         |    1 
 fs/xfs/xfs_inode.c         |   98 ++++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_inode.h         |    2 +
 fs/xfs/xfs_qm.c            |    4 +-
 fs/xfs/xfs_qm.h            |    2 -
 fs/xfs/xfs_symlink.c       |    6 ++-
 fs/xfs/xfs_trans.c         |    9 +++-
 fs/xfs/xfs_trans_dquot.c   |   15 ++++---
 13 files changed, 156 insertions(+), 54 deletions(-)

