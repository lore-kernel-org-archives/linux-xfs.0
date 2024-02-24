Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF8E1870
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738153; cv=none; b=QFN/RP/LL5wvo9r5YbNGjWECjNECBDXxcmvKVg4Ii8d1bXYFgce0WvonNM8GZLUfg5IyyFY5wFSPipQsEEaqhqQbx2MnthrVYc+778d6M8ZguxUr8KFDpQJHs+8HOAkvuoY/F6Xm40aKB5xcmXDhdvgQdB+YTp/7/6nA3pFRCPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738153; c=relaxed/simple;
	bh=7XBbzJKPNo+qPb9XHGP29LmYlgkqzuorzm9KaCQTsp0=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=oB4dWM39jUFndJXd0cc3vEtOaLWWJfNm5R4oiARYXJsrjeTSqeyXxXjAEV82lpAbt3VFnY+F4dsOfMerHZuTFQtK0aABz+OI7iydJNQtLMxA7+2U5sVLjY8mb2QzGhw0qJRvGJJqTADjJ5uzNeclSHVZN6feiYHHEAl7Mg3QGt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nV9FP3As; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nV9FP3As"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D24C433F1;
	Sat, 24 Feb 2024 01:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738153;
	bh=7XBbzJKPNo+qPb9XHGP29LmYlgkqzuorzm9KaCQTsp0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nV9FP3AsJ44+wQWWWG4zBh/Hm6TRSp2AsCPB5q+eXHJnFzWDtONY/qyllRChpX8M0
	 eA5ttwk+8y4d5lGWogcc6KBNf8e/BkfRDV0/o/16nLovKdgAUmzO7qrmJNoTBDRjOA
	 BT8HJFrQlSFgGmseufUJWHe2xQaS4T0tGNVn/zZbBvf1BYVQRS0IWqa9Ms0+a6obsU
	 O5lHXBmrb0hbBZi6CYaS6pJeiLiIJmRv0pp8q/pIofDwCaw2d3VGHnrAjHPmkOhQX5
	 7TPAloJ0YpnTLasONso5JhUsx/iWrmJNqsrLbt23ml463mPY0Kqd86i2WGYl7tIkZw
	 By0IoqySVdnPA==
Date: Fri, 23 Feb 2024 17:29:13 -0800
Subject: [GIT PULL 1/18] xfs: repair inode mode by scanning dirs
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170873800188.1891722.3806756019608757588.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240224010220.GN6226@frogsfrogsfrogs>
References: <20240224010220.GN6226@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.9-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 4b2f459d86252619448455013f581836c8b1b7da:

xfs: fix SEEK_HOLE/DATA for regions with active COW extents (2024-02-21 12:31:12 +0530)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-inode-mode-6.9_2024-02-23

for you to fetch changes up to 5385f1a60d4e5b73e8ecd2757865352b68f54fb9:

xfs: repair file modes by scanning for a dirent pointing to us (2024-02-22 12:30:51 -0800)

----------------------------------------------------------------
xfs: repair inode mode by scanning dirs [v29.3 01/18]

One missing piece of functionality in the inode record repair code is
figuring out what to do with a file whose mode is so corrupt that we
cannot tell us the type of the file.  Originally this was done by
guessing the mode from the ondisk inode contents, but Christoph didn't
like that because it read from data fork block 0, which could be user
controlled data.

Therefore, I've replaced all that with a directory scanner that looks
for any dirents that point to the file with the garbage mode.  If so,
the ftype in the dirent will tell us exactly what mode to set on the
file.  Since users cannot directly write to the ftype field of a dirent,
this should be safe.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (10):
xfs: speed up xfs_iwalk_adjust_start a little bit
xfs: implement live inode scan for scrub
xfs: allow scrub to hook metadata updates in other writers
xfs: stagger the starting AG of scrub iscans to reduce contention
xfs: cache a bunch of inodes for repair scans
xfs: iscan batching should handle unallocated inodes too
xfs: create a static name for the dot entry too
xfs: create a predicate to determine if two xfs_names are the same
xfs: create a macro for decoding ftypes in tracepoints
xfs: repair file modes by scanning for a dirent pointing to us

fs/xfs/Kconfig                |   5 +
fs/xfs/Makefile               |   2 +
fs/xfs/libxfs/xfs_da_format.h |  11 +
fs/xfs/libxfs/xfs_dir2.c      |   6 +
fs/xfs/libxfs/xfs_dir2.h      |  13 +
fs/xfs/scrub/dir.c            |   4 +-
fs/xfs/scrub/inode_repair.c   | 236 ++++++++++++-
fs/xfs/scrub/iscan.c          | 767 ++++++++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/iscan.h          |  84 +++++
fs/xfs/scrub/trace.c          |   2 +
fs/xfs/scrub/trace.h          | 194 +++++++++++
fs/xfs/xfs_hooks.c            |  52 +++
fs/xfs/xfs_hooks.h            |  65 ++++
fs/xfs/xfs_iwalk.c            |  13 +-
fs/xfs/xfs_linux.h            |   1 +
15 files changed, 1436 insertions(+), 19 deletions(-)
create mode 100644 fs/xfs/scrub/iscan.c
create mode 100644 fs/xfs/scrub/iscan.h
create mode 100644 fs/xfs/xfs_hooks.c
create mode 100644 fs/xfs/xfs_hooks.h

