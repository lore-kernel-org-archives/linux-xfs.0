Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD69C1946BC
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730418176; cv=none; b=YNdS6vkpzlDyQjKkCJPplxQi2pdMWHcRf1meuI1xjI6NwRkf2F6GQlgzcVfZ1h7pdHYeCE3FtCMi4NVcapkhjbsWglu4z2moU308R4TvtAQbArgWg6JAihlT0bAYMlLwg2+zXAkokIo1YqGS00wjiGLsc4qKv96dBheZpzY+0x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730418176; c=relaxed/simple;
	bh=tns1ZrLu2KPMclcoagj8+aNqASFC+0URglOnyP5nHtg=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=MD48PDBrZb0FIlzOK143QKSSonZ1NZsFxsAj7dYBHv6NEsxZDntCpvZIn2F4Uz0IIkOttJIE90aRfi/8fiO0+EZRC9SvmjrG+X0cPmCCctB4sej5rGjSV5U+OzVFSZtT+sTcE/5DvV7gbnzdvnER6WYbUAnozQvZ3v2Gmal4URo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=elk+7H/f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="elk+7H/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328D0C4CECF;
	Thu, 31 Oct 2024 23:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730418176;
	bh=tns1ZrLu2KPMclcoagj8+aNqASFC+0URglOnyP5nHtg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=elk+7H/fcfH6/j3Nh19+nuuSObwMHWfjn4cRN5spXrWi5ZpYWqsFNC7J/Of9Ks2U4
	 HwSrKd4/OL9vG7gt13vdZImBpbauHCrm7oy07Owh2diXmzCsCBAwa4FSn7BWOlzFyb
	 Ji6ssoBqIJx4DYCzT4+Y+zHu22sSHYWUXLZv4iI0HeFNAL+tUOBmyGFRLTxnqtexgC
	 /U5XaAOSAzq67vh+b5trNM/XLQaB0+LmgATs5tfeKyppSItNOe1Spozn2jzDsUb3Cg
	 dhP4zTJq2ENuAjScsr6ETA9/qECJvr43XIUY2yVcWCEYVwzgKwogS6J2DkVBwnv8YW
	 XZW7mUAfYCyaQ==
Date: Thu, 31 Oct 2024 16:42:55 -0700
Subject: [GIT PULL 2/7] xfsprogs: atomic file content commits
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173041764501.994242.4495986757240413891.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241031233336.GD2386201@frogsfrogsfrogs>
References: <20241031233336.GD2386201@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.11-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 6611215e3d441a5e6d9d6a2f85c5ea1bf573a8d0:

xfs: update the pag for the last AG at recovery time (2024-10-31 15:45:04 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/atomic-file-commits-6.12_2024-10-31

for you to fetch changes up to 1cf7afbc0c8bcb450ebc3acab7616c9da49087de:

xfs_io: add atomic file update commands to exercise file commit range (2024-10-31 15:45:04 -0700)

----------------------------------------------------------------
xfsprogs: atomic file content commits [v31.3 2/7]

This series creates XFS_IOC_START_COMMIT and XFS_IOC_COMMIT_RANGE ioctls
to perform the exchange only if the target file has not been changed
since a given sampling point.

This new functionality uses the mechanism underlying EXCHANGE_RANGE to
stage and commit file updates such that reader programs will see either
the old contents or the new contents in their entirety, with no chance
of torn writes.  A successful call completion guarantees that the new
contents will be seen even if the system fails.  The pair of ioctls
allows userspace to perform what amounts to a compare and exchange
operation on entire file contents.

Note that there are ongoing arguments in the community about how best to
implement some sort of file data write counter that nfsd could also use
to signal invalidations to clients.  Until such a thing is implemented,
this patch will rely on ctime/mtime updates.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (7):
man: document file range commit ioctls
libfrog: add support for commit range ioctl family
libxfs: remove unused xfs_inode fields
libxfs: validate inumber in xfs_iget
xfs_fsr: port to new file exchange library function
xfs_io: add a commitrange option to the exchangerange command
xfs_io: add atomic file update commands to exercise file commit range

fsr/xfs_fsr.c                     |  74 ++++----
include/xfs_inode.h               |   4 -
io/exchrange.c                    | 390 +++++++++++++++++++++++++++++++++++++-
io/io.h                           |   4 +
io/open.c                         |  27 ++-
libfrog/file_exchange.c           | 194 +++++++++++++++++++
libfrog/file_exchange.h           |  10 +
libxfs/inode.c                    |   2 +-
man/man2/ioctl_xfs_commit_range.2 | 296 +++++++++++++++++++++++++++++
man/man2/ioctl_xfs_fsgeometry.2   |   2 +-
man/man2/ioctl_xfs_start_commit.2 |   1 +
man/man8/xfs_io.8                 |  35 +++-
12 files changed, 983 insertions(+), 56 deletions(-)
create mode 100644 man/man2/ioctl_xfs_commit_range.2
create mode 100644 man/man2/ioctl_xfs_start_commit.2

