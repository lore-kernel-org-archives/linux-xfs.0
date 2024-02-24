Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25AD625
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738185; cv=none; b=nWrIkmo1TA/wRmtKFXm2jdPS0S64n5EGiRSkXtTeedQl3OZLoMZWuhoqaVhM68+yFjDKuzZLNqcPwQE260mnFOKI8a+VzhPk9QfYX8yAZ7rQlDT8OQ5zEDqRNVYEEEZ7EkmnQMd/D61mewlLag7mcm7mnvolCJn/9X8RwhB4LGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738185; c=relaxed/simple;
	bh=QZo2fZjDosVuMKI3QmLbvhw5aGQVZDFBPGL9qLIcbz8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=Og93JR17cVT8unpL3xHp27HQO8LSykBeF0B+C6oW7VmuU/rEdTLL8y9OkHMP+jLvnnlNo6AuH2Vj3sTZLNNuAfXz5uFzTu+n8+tgejaB5k2u9gW4MF3wr3C5Rkc4PwXhDHHNHcd4AK/eLLqcjWzzenJzP6nFxe1GC5sHTeKviFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xj9f63S3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xj9f63S3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF170C433F1;
	Sat, 24 Feb 2024 01:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738184;
	bh=QZo2fZjDosVuMKI3QmLbvhw5aGQVZDFBPGL9qLIcbz8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xj9f63S3n9Fyx/wwk/dEOcH9dtgKIAfRHgR3mXGNPgkXxb9IcTt8Qx36RvDPvsaW0
	 H4Aok8+t7EzUU5CRB/al1H67OsWx/lOAnKGZBdPUkp7UDt/juU3EStdJBhL9yNtWWP
	 AWSNsZBW50KlFNFusXIQu8iufBskazUEFBmCPCgCU7m4ql9PhmOIcHD+XdLXu+C3yq
	 uk+mpw+05C/bU6V4EFzPq504HxbPe20IjcVNZM0rZZ/03+eul4KO9wsgSR9FH70p7s
	 80/VoVloPxDeQvCN6oGwiCR6e/VscBcWkkq1hzxkWuRasLkBUlXDLk9cfo16Xc1GGT
	 qvgZ5TWh3fu4Q==
Date: Fri, 23 Feb 2024 17:29:44 -0800
Subject: [GIT PULL 3/18] xfs: online repair of file link counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170873801105.1891722.3134162492855847646.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 96ed2ae4a9b06b417e1c20c086c77755a43284bf:

xfs: repair dquots based on live quotacheck results (2024-02-22 12:30:57 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-nlinks-6.9_2024-02-23

for you to fetch changes up to 6b631c60c90a1e5264bc9bcdca2c0adb492d7a62:

xfs: teach repair to fix file nlinks (2024-02-22 12:31:00 -0800)

----------------------------------------------------------------
xfs: online repair of file link counts [v29.3 03/18]

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

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs: report health of inode link counts
xfs: teach scrub to check file nlinks
xfs: track directory entry updates during live nlinks fsck
xfs: teach repair to fix file nlinks

fs/xfs/Makefile              |   2 +
fs/xfs/libxfs/xfs_fs.h       |   4 +-
fs/xfs/libxfs/xfs_health.h   |   4 +-
fs/xfs/scrub/common.c        |   3 +
fs/xfs/scrub/common.h        |   1 +
fs/xfs/scrub/health.c        |   1 +
fs/xfs/scrub/nlinks.c        | 930 +++++++++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/nlinks.h        | 102 +++++
fs/xfs/scrub/nlinks_repair.c | 223 +++++++++++
fs/xfs/scrub/repair.h        |   2 +
fs/xfs/scrub/scrub.c         |   9 +
fs/xfs/scrub/scrub.h         |   5 +-
fs/xfs/scrub/stats.c         |   1 +
fs/xfs/scrub/trace.c         |   2 +
fs/xfs/scrub/trace.h         | 183 ++++++++-
fs/xfs/xfs_health.c          |   1 +
fs/xfs/xfs_inode.c           | 117 ++++++
fs/xfs/xfs_inode.h           |  31 ++
fs/xfs/xfs_mount.h           |   3 +
fs/xfs/xfs_super.c           |   2 +
fs/xfs/xfs_symlink.c         |   1 +
21 files changed, 1623 insertions(+), 4 deletions(-)
create mode 100644 fs/xfs/scrub/nlinks.c
create mode 100644 fs/xfs/scrub/nlinks.h
create mode 100644 fs/xfs/scrub/nlinks_repair.c

