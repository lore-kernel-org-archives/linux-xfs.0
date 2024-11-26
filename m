Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC88A366;
	Tue, 26 Nov 2024 01:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584033; cv=none; b=JmimpC3X8cqoKaIPPZdtCeD+yIJALY/KEqCvnZmhkZd+oyUnz8RdBgMn3KA5aOWRDgTZsIGVzHC3x++Z7onXNSlctrn4hkSu7pveS9rF8qf+Loe9dXYdKPC8w0H4pLn6M+jGS+UwgSASrn3dD2w4i6LSCcu6+CPx6LKdqMjcJJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584033; c=relaxed/simple;
	bh=SxQmFw1pSl0evDPGJiU5BfvWKUS46tXgAy/pY1+q/ZA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hG4k+6J/JO2+MGYyROVF188O/F0ChKjYRGEiE4XORov5W6t99foJumAovYlsw5mkVFw5CPwhW0bNCTNIcR+jmbJ78hzaX8HlziZiChlCj7MniOS5OZ8V62W2nJ1FSAjRxcsbSZtK6oV72+xcIwZxrEnuOudIUXajWiMAu/bioQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mp2MPaYS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mp2MPaYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581AAC4CECE;
	Tue, 26 Nov 2024 01:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584032;
	bh=SxQmFw1pSl0evDPGJiU5BfvWKUS46tXgAy/pY1+q/ZA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mp2MPaYS3NPCFQXlThgS7ZmywjB6QpTHof/xJYw1pnJVoaKq3CeuTh7WQpsokcYeX
	 zvmYUBdsz8xEQe5dSD/n7ht9T7iMEjpnHT0gjZanvcsaVXdkeBXoM5OlONpGpUXJTV
	 tf97YrpGZno8WW8JQy3QIAi8vZvoqvtt6f4D4O9UVwX9SljEk1TTXyuBrr8CVjLUnw
	 CUgZjtAJ9kD3/Op8ZB35AUwMAS+HJjvHsnkooaoZTrfvEZrdK9of3O7i2kGT28JKMK
	 JtVEThHl5/HNIZLfA29TQD4HuQmR5pk1fspo5n3YxSOfjypX5DGZrMl7eUey+yc3v/
	 P0TI5HHuxI7Ag==
Date: Mon, 25 Nov 2024 17:20:31 -0800
Subject: [PATCHSET] xfs: bug fixes for 6.13
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, wozizhi@huawei.com,
 dan.carpenter@linaro.org, linux-xfs@vger.kernel.org
Message-ID: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
In-Reply-To: <20241126011838.GI9438@frogsfrogsfrogs>
References: <20241126011838.GI9438@frogsfrogsfrogs>
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

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-6.13-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfs-6.13-fixes
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
 * xfs: update btree keys correctly when _insrec splits an inode root block
 * xfs: fix scrub tracepoints when inode-rooted btrees are involved
 * xfs: unlock inodes when erroring out of xfs_trans_alloc_dir
 * xfs: only run precommits once per transaction object
 * xfs: remove recursion in __xfs_trans_commit
 * xfs: don't lose solo superblock counter update transactions
 * xfs: don't lose solo dquot update transactions
 * xfs: separate dquot buffer reads from xfs_dqflush
 * xfs: clean up log item accesses in xfs_qm_dqflush{,_done}
 * xfs: attach dquot buffer to dquot log item buffer
 * xfs: convert quotacheck to attach dquot buffers
---
 fs/xfs/libxfs/xfs_btree.c        |   33 +++++--
 fs/xfs/libxfs/xfs_btree.h        |    2 
 fs/xfs/libxfs/xfs_ialloc_btree.c |    4 +
 fs/xfs/libxfs/xfs_rtgroup.c      |    2 
 fs/xfs/scrub/agheader.c          |    6 +
 fs/xfs/scrub/agheader_repair.c   |    6 +
 fs/xfs/scrub/fscounters.c        |    2 
 fs/xfs/scrub/health.c            |   57 +++++++-----
 fs/xfs/scrub/ialloc.c            |    4 -
 fs/xfs/scrub/metapath.c          |   68 +++++---------
 fs/xfs/scrub/refcount.c          |    2 
 fs/xfs/scrub/scrub.h             |    6 +
 fs/xfs/scrub/symlink_repair.c    |    3 -
 fs/xfs/scrub/tempfile.c          |   10 ++
 fs/xfs/scrub/trace.h             |    2 
 fs/xfs/xfs_bmap_util.c           |    2 
 fs/xfs/xfs_dquot.c               |  185 ++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_dquot.h               |    5 +
 fs/xfs/xfs_dquot_item.c          |   51 ++++++++--
 fs/xfs/xfs_dquot_item.h          |    7 +
 fs/xfs/xfs_file.c                |    8 ++
 fs/xfs/xfs_fsmap.c               |   38 +++++---
 fs/xfs/xfs_inode.h               |    2 
 fs/xfs/xfs_qm.c                  |   92 +++++++++++++------
 fs/xfs/xfs_qm.h                  |    1 
 fs/xfs/xfs_quota.h               |    7 +
 fs/xfs/xfs_rtalloc.c             |    2 
 fs/xfs/xfs_trans.c               |   58 ++++++------
 fs/xfs/xfs_trans_ail.c           |    2 
 fs/xfs/xfs_trans_dquot.c         |   31 +++++-
 30 files changed, 475 insertions(+), 223 deletions(-)

