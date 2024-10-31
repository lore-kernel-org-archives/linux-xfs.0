Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2007197A87
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416044; cv=none; b=Sq3WcnJkLLoxrjGi2MiLbnM62xqrYQ8iEJFZ9f7AHJEFc+6Eh1c5L3QLpPgCCDhjp6XDEoL2PlFjpNOzACN1KL+sTHuoX6nCevOykaKa6e9uNALraQ8713GjYKmjjJzXGgfAXOgUOGvf1fNj53ExG4TK2q1Ws34THTw8pHfs4A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416044; c=relaxed/simple;
	bh=qFQcpkKrfliT/o0lcXd2lOus4sfyZVdlmVTjgiP8pZI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JB70Vz1YzT7gfJSbBA/4G9/IsZKOrQs9xyRaJsgqWfro2v35r7Z1v5Xa8M9idJQa0m+YkKJwNVGOndU0S2+Q0KN1tfluOgEO24FOVCq+RzM0eSHKEyr5enIfkyPJQPfVYDxiTJRBYsFvpkAC+33FHPKov34APKCA0aeDoEghNcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aeAsczM2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aeAsczM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B85C4CEC3;
	Thu, 31 Oct 2024 23:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416044;
	bh=qFQcpkKrfliT/o0lcXd2lOus4sfyZVdlmVTjgiP8pZI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aeAsczM2JmYk/Q6CRc3nEKLETRpgz+Vk2QZmAKFySkmtOQzubKujhIgQeI4i1VRIe
	 RtF2Ws6BExQO7L6BUsyYVQl0q1vLzPcqTVx9pzHiRa5BRbXay7iln1wba+p7gA7N/L
	 PwY12LePeeFZy0VFme282Y7csG/POip1GZfI/x+HAqcJtqHVf3lNvgLsP0BlpVSMr6
	 QFxMc8HFxlfhqZUKHrry0wyAKuLFmO70bHrG8TH7ny5H13Vk9agALTP1blH7bEeCHI
	 NK3BNsbCmbt7gV8Bq61kzYaccEhwsBFcoPHVPm86ufVc+shehnnLGyRM+UfhyUNnPz
	 zvBgPfWGZPcgg==
Date: Thu, 31 Oct 2024 16:07:23 -0700
Subject: [PATCHSET v31.3 2/7] xfsprogs: atomic file content commits
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566899.963918.1566223803606797457.stgit@frogsfrogsfrogs>
In-Reply-To: <20241031225721.GC2386201@frogsfrogsfrogs>
References: <20241031225721.GC2386201@frogsfrogsfrogs>
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

