Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A77EA4
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713227306; cv=none; b=dimPV3rn2/EI2LXJfIDBo5HQ+D1gJpYwbc1/A+X9yHV1ItLnuz+rgdo/L/BSDdMksK0TKgOkqHMR+jUEv3+QthgyN3lKKS1xmoJOBJacuaWpmLYSbVJVDDjZKvjEvdSw5xC6nAWcARDiLSsT8N4Vp5Hl3L1nQdS5SET6SLkCmxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713227306; c=relaxed/simple;
	bh=2uEvsEL+NVt2qZqeKUx6nDwS+dDYGPMyz4g2v0d6mVw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=Mav4wcYWwACTqPwVhaCN1VcoHtrvXERftD+vXSFnIX07QtbBmwigvQN2oMWLw6ZOonHHvO3vS5k1lbCX+pOIfY6H0zfWSddmh6Ws7zTo+EtocDxv+TOzRXyasL+XeaHxF1lk5ISyBS8nDlkrGBwSt+65Gn0kNLk0MGj3jAzwgxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GUen+Zrs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GUen+Zrs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00445C113CC;
	Tue, 16 Apr 2024 00:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713227306;
	bh=2uEvsEL+NVt2qZqeKUx6nDwS+dDYGPMyz4g2v0d6mVw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GUen+ZrsJclr5YqXvVcIMqhSNLT9XXAoJPVIkvw1b+6rDYJU/XDO7YxwKDYv+8Mv4
	 3gwuHvyG0a3knwrWEUM+7mEy6MM9CzL2SV2JKO/VMgbCCzytk+BeuaJDe9xw0HQy/T
	 Rvlgh1cTOP0JP19VdkosMJHiDMYJYb01DK8VJK84hP7b9sDZvygqLlXL5Z63Fhqh25
	 6P4ti13d5BRoEiqRQCVWtY/UkDqqhrpv9s9RKOEwp3miP5dIyHDui/UfwTVI2N9V4+
	 7O0Ul7fuhZu7dk6I2z1cwusjpYUuOwvrMH1iD9o/DqgBjCWQG1rGpXyEve1B7XSg5b
	 JnzIFNK+ii+gg==
Date: Mon, 15 Apr 2024 17:28:25 -0700
Subject: [GIT PULL 04/16] xfs: create temporary files for online repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322716036.141687.5941639935061854826.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 0730e8d8ba1d1507f1d7fd719e1f835ce69961fe:

xfs: enable logged file mapping exchange feature (2024-04-15 14:54:26 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-tempfiles-6.10_2024-04-15

for you to fetch changes up to 5befb047b9f4de1747bf48c63cab997a97e0088b:

xfs: add the ability to reap entire inode forks (2024-04-15 14:58:49 -0700)

----------------------------------------------------------------
xfs: create temporary files for online repair [v30.3 04/16]

As mentioned earlier, the repair strategy for file-based metadata is to
build a new copy in a temporary file and swap the file fork mappings
with the metadata inode.  We've built the atomic extent swap facility,
so now we need to build a facility for handling private temporary files.

The first step is to teach the filesystem to ignore the temporary files.
We'll mark them as PRIVATE in the VFS so that the kernel security
modules will leave it alone.  The second step is to add the online
repair code the ability to create a temporary file and reap extents from
the temporary file after the extent swap.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs: hide private inodes from bulkstat and handle functions
xfs: create temporary files and directories for online repair
xfs: refactor live buffer invalidation for repairs
xfs: add the ability to reap entire inode forks

fs/xfs/Makefile         |   1 +
fs/xfs/scrub/parent.c   |   2 +-
fs/xfs/scrub/reap.c     | 445 +++++++++++++++++++++++++++++++++++++++++++++---
fs/xfs/scrub/reap.h     |  21 +++
fs/xfs/scrub/scrub.c    |   3 +
fs/xfs/scrub/scrub.h    |   4 +
fs/xfs/scrub/tempfile.c | 251 +++++++++++++++++++++++++++
fs/xfs/scrub/tempfile.h |  28 +++
fs/xfs/scrub/trace.h    |  96 +++++++++++
fs/xfs/xfs_export.c     |   2 +-
fs/xfs/xfs_inode.c      |   3 +-
fs/xfs/xfs_inode.h      |   2 +
fs/xfs/xfs_iops.c       |   3 +
fs/xfs/xfs_itable.c     |   8 +
14 files changed, 843 insertions(+), 26 deletions(-)
create mode 100644 fs/xfs/scrub/tempfile.c
create mode 100644 fs/xfs/scrub/tempfile.h

