Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B37480C
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713227636; cv=none; b=tKiLDPS2+FJGGJprrDf9KHTC0WUBEOeRVHvTiQoz+F1/7naeE7JhlHQCqrYCd0CZb5Ue7lIpd/EM2HMMiY3NRMc4NQOBMOg+tJeONvlroQKcB9VDCdR1smBoJKPrGCw+LSLREfJaBQhmdrLekGdX01Dm8emxZdQEmfvHOC9yhko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713227636; c=relaxed/simple;
	bh=aKkS88VDZf0oC+/C8nrN6FLIfB+N4nQMqwtWKYYAbF0=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=WzBLgWE3dGoO6rZz+KVWcjylHJsqUWe8vk2zkEtxSS40RBVJnQHOy7B7dyJTdVvr/+GGoRqiY2N9eUs6rulA4GVW/E0E/lRZUJmstSnGc1xloVAm0knyE1QmoBR3kaEO8Mzav9z45xyxkASLPM4pKCva/fk7doCa85DBmtFu10Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cxuRxh73; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cxuRxh73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E23C113CC;
	Tue, 16 Apr 2024 00:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713227635;
	bh=aKkS88VDZf0oC+/C8nrN6FLIfB+N4nQMqwtWKYYAbF0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cxuRxh73OR2J5Cm+j8GSbI9hY7U/mVfvSiQQgoTvLj4Qg2oYDr5vZ5E+uS/prfZd+
	 3TFQC2zpELH9J00AJLNHIAOq8/3nk3F1seb9L+o7s3+F2/Vv3s4biqVSHz2qlKc9QL
	 sVLMCneEobxyo0ph3ddUAdcSRcaOm8SKGX/dfTf6ZhZyN3UYbyT/iFERc+lOToM51C
	 M9U2i3CgfqlNuJPtMRU0S6YKid7CVlaE/jFUpiIRKvBligybK11X6VXfgGlBvtAw7k
	 GgdLtSoeRNIfE6evYbgZg1mHBlG1sekV7gmWmdZ+sq1Xn9h/t9QluLx6X2MFfcs5wW
	 2Zte+QEr5U2hA==
Date: Mon, 15 Apr 2024 17:33:55 -0700
Subject: [GIT PULL 16/16] xfs: retain ILOCK during directory updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322719997.141687.18094380315256577049.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240416002427.GB11972@frogsfrogsfrogs>
References: <20240416002427.GB11972@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 67bdcd499909708195b9408c106b94250955c5ff:

docs: describe xfs directory tree online fsck (2024-04-15 14:59:01 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/retain-ilock-during-dir-ops-6.10_2024-04-15

for you to fetch changes up to df760471477400ccd3ddcea85d2d6d92f4dad28c:

xfs: unlock new repair tempfiles after creation (2024-04-15 14:59:03 -0700)

----------------------------------------------------------------
xfs: retain ILOCK during directory updates [v13.2 16/16]

This series changes the directory update code to retain the ILOCK on all
files involved in a rename until the end of the operation.  The upcoming
parent pointers patchset applies parent pointers in a separate chained
update from the actual directory update, which is why it is now
necessary to keep the ILOCK instead of dropping it after the first
transaction in the chain.

As a side effect, we no longer need to hold the IOLOCK during an rmapbt
scan of inodes to serialize the scan with ongoing directory updates.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Allison Henderson (5):
xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
xfs: Increase XFS_QM_TRANS_MAXDQS to 5
xfs: Hold inode locks in xfs_ialloc
xfs: Hold inode locks in xfs_trans_alloc_dir
xfs: Hold inode locks in xfs_rename

Darrick J. Wong (2):
xfs: don't pick up IOLOCK during rmapbt repair scan
xfs: unlock new repair tempfiles after creation

fs/xfs/libxfs/xfs_defer.c  |  6 ++-
fs/xfs/libxfs/xfs_defer.h  |  8 +++-
fs/xfs/scrub/rmap_repair.c | 16 +-------
fs/xfs/scrub/tempfile.c    |  2 +
fs/xfs/xfs_dquot.c         | 41 +++++++++++++++++++
fs/xfs/xfs_dquot.h         |  1 +
fs/xfs/xfs_inode.c         | 98 ++++++++++++++++++++++++++++++++++------------
fs/xfs/xfs_inode.h         |  2 +
fs/xfs/xfs_qm.c            |  4 +-
fs/xfs/xfs_qm.h            |  2 +-
fs/xfs/xfs_symlink.c       |  6 ++-
fs/xfs/xfs_trans.c         |  9 ++++-
fs/xfs/xfs_trans_dquot.c   | 15 ++++---
13 files changed, 156 insertions(+), 54 deletions(-)

