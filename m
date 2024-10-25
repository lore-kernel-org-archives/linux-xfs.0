Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB450170A16
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729837885; cv=none; b=czDLltaqtBLp9X96bGe76wI/XKyZufTE19Yq8P7FZdAA4p47v91muAMrLqAMLCiZ6k+bZQlIDnPwPxhcc05QG681gytnnFfNRh+0p6NuqJbZgpYcEsubP0MiaFAvV8q391roKNH3mrUOLTM7KW8SXsxLJkKJTPNq0+HP4Hvka00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729837885; c=relaxed/simple;
	bh=qFQcpkKrfliT/o0lcXd2lOus4sfyZVdlmVTjgiP8pZI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=koYo3BdUKuhD1p7tFk4O4Q2l6/bPDSzSZ06ImqGQSdZKoXOCgQLZuX/xXZjewt0mKdBcspy/o+XxQPaLxmaOlmwiFK9piIS9E9LZj4zpqxwdEZ7BHcTODnig3kdWgpN6/Vs9olKEPjD+ZAbpy1vDsL6YvGchFyK7JgchE1aXuL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G6Erz7IH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G6Erz7IH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C48BC4CEC3;
	Fri, 25 Oct 2024 06:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729837885;
	bh=qFQcpkKrfliT/o0lcXd2lOus4sfyZVdlmVTjgiP8pZI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G6Erz7IHVfkZOBSgMHplznYQZ9Xe71kuUxi7YgS+uUjtMeTbCvbCPR9ALCG7/fERi
	 gPOMssEz1PK5+jBgNKRtL80FZbdr7FYkvxmBdjMJCk3LFsO6Upcsy61HUgzIR8CDye
	 xjsUaaLVcfsBr2yHF2RghHaeFX3RYiOIW3/Uyo+WuDoHfG3XhFha6vU8KJJwfB7IB9
	 T2/jCfmzHRhI+iMwjSaNGMrM3CFvIgYFYe14fl669eaA++e7Tfo4SvgQoBFwvmU/BI
	 s8lUwJhGl5bbqPq7ao/OaqELpqZ98D/R3cLpCfakcqdsloL44QQFm4JdZGv9eRzhle
	 cUZJyW4fYrcJA==
Date: Thu, 24 Oct 2024 23:31:24 -0700
Subject: [PATCHSET v31.2 1/5] xfsprogs: atomic file content commits
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172983773323.3040944.5615240418900510348.stgit@frogsfrogsfrogs>
In-Reply-To: <20241025062602.GH2386201@frogsfrogsfrogs>
References: <20241025062602.GH2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

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

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=atomic-file-commits-6.12

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=atomic-file-commits-6.12
---
Commits in this patchset:
 * man: document file range commit ioctls
 * libfrog: add support for commit range ioctl family
 * libxfs: remove unused xfs_inode fields
 * libxfs: validate inumber in xfs_iget
 * xfs_fsr: port to new file exchange library function
 * xfs_io: add a commitrange option to the exchangerange command
 * xfs_io: add atomic file update commands to exercise file commit range
---
 fsr/xfs_fsr.c                     |   74 +++----
 include/xfs_inode.h               |    4 
 io/exchrange.c                    |  390 +++++++++++++++++++++++++++++++++++++
 io/io.h                           |    4 
 io/open.c                         |   27 ++-
 libfrog/file_exchange.c           |  194 ++++++++++++++++++
 libfrog/file_exchange.h           |   10 +
 libxfs/inode.c                    |    2 
 man/man2/ioctl_xfs_commit_range.2 |  296 ++++++++++++++++++++++++++++
 man/man2/ioctl_xfs_fsgeometry.2   |    2 
 man/man2/ioctl_xfs_start_commit.2 |    1 
 man/man8/xfs_io.8                 |   35 +++
 12 files changed, 983 insertions(+), 56 deletions(-)
 create mode 100644 man/man2/ioctl_xfs_commit_range.2
 create mode 100644 man/man2/ioctl_xfs_start_commit.2

