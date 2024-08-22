Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECAF18732C
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 23:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371018; cv=none; b=bCl+MjGKs5pvrg1AFPy1328k0WBhIV82/XHTijFxHteqnF/a/WPrUKNTspkNsS41VCgWqrbu+JCryZtXCGit471P95MEk2ohwnU+ZV1i5Wbq3vb95w+Hs/epUfJONHT2U9un6oxhp903jhslU4vi7//0Sn1ZdFS8r+MKQq3UVrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371018; c=relaxed/simple;
	bh=jFMrfMl+zJZr8O2C/4hfpXW7oaD7ntIjNqF9Mwv7ALQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LHiQTkpohUWydvAfiFk78WFbHwRK1bCBJwc7gY3udolXEhgcvALTLckCroj5myuoKPBpNbApy0cgcdSSH+q5GCBBMfc5uyTq0GvJXGT8XJJtld3WBLx/sU4sGTNDx1sG9Db4a19pgdPNDbd1rlYMYR/dTAkfR+7fUDaaQM+Qf/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EBp+NxMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EBp+NxMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B521C32782;
	Thu, 22 Aug 2024 23:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371017;
	bh=jFMrfMl+zJZr8O2C/4hfpXW7oaD7ntIjNqF9Mwv7ALQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EBp+NxMofQZgRiCyecBt4LbdOZOQf1Zj+Jcs9FcV99j4P+XXo8JPGaUnXxaC8FKuw
	 zq/08d6K0BrB4hNfzqrU8fdq02gCRpvx5FY976rfnO9CTgxqslvvmH3IMNXj6ohgvN
	 3evcermGf7KsJ8LGLxR281cf7LLujTZhCqKhkJvw8CrctgBgN4h4boZpCOScrcI1rh
	 Xk/AWKQjUubt6b0Z6pbnGKjNy3yOhuBqkWD+0GTwrun1AJH83xxx1dNd45fzLog6vl
	 yPidlfkofMyR3isRTNw+8ubEKP/yPqSZr9J+em4pZhXz7esL03UdY2YapL/r5NvddO
	 idF0vAqC4xs2g==
Date: Thu, 22 Aug 2024 16:56:56 -0700
Subject: [PATCHSET v4.0 03/10] xfs: cleanups before adding metadata
 directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437084629.57308.17035804596151035899.stgit@frogsfrogsfrogs>
In-Reply-To: <20240822235230.GJ6043@frogsfrogsfrogs>
References: <20240822235230.GJ6043@frogsfrogsfrogs>
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

Before we start adding code for metadata directory trees, let's clean up
some warts in the realtime bitmap code and the inode allocator code.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadir-cleanups
---
Commits in this patchset:
 * xfs: validate inumber in xfs_iget
 * xfs: match on the global RT inode numbers in xfs_is_metadata_inode
 * xfs: pass the icreate args object to xfs_dialloc
---
 fs/xfs/libxfs/xfs_ialloc.c |    5 +++--
 fs/xfs/libxfs/xfs_ialloc.h |    4 +++-
 fs/xfs/scrub/tempfile.c    |    2 +-
 fs/xfs/xfs_icache.c        |    2 +-
 fs/xfs/xfs_inode.c         |    4 ++--
 fs/xfs/xfs_inode.h         |    7 ++++---
 fs/xfs/xfs_qm.c            |    2 +-
 fs/xfs/xfs_symlink.c       |    2 +-
 8 files changed, 16 insertions(+), 12 deletions(-)

