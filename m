Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1326FB64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bnd7tgb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C8DC433C7;
	Sun, 31 Dec 2023 19:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052285;
	bh=HsNh9RGirdIllByU5JE/FyOUBuUnhdXm8FVNQ6VPjng=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bnd7tgb+E2pvkkL6vBD2nnAcGSmBeM4zMgJJsg6OkFT7QLDrcUtK3sdwT1ErBlQXx
	 tJH7+RoEsmam2uTskilieycvrU98+G2UTwBPvwK2oeigasdoI7Akg5EGd1tMW8SPqE
	 YE3oV2EAUVM6Z+qsQLSt+irNuwWd97LDU6wCL1p3PgJx3HV3fRtjWV2OsU8b2tx+sH
	 yjjjnutsy7+8jeXMMhGu31uUnUFWzG2/gz5JP1s7skGl7U0+EMcXdvvRmH9jSB6IVN
	 VvRQh6UuIzITOXDYIKIchtp2zQsbjE0qjD6G7/I8mF0xgVTUQ8mkG23068Zpb8LU+5
	 FKqc7YEP7mwuw==
Date: Sun, 31 Dec 2023 11:51:25 -0800
Subject: [PATCHSET v13.0 5/6] xfs: detect and correct directory tree problems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405007429.1805996.15935827855068032438.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181849.GT361584@frogsfrogsfrogs>
References: <20231231181849.GT361584@frogsfrogsfrogs>
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

Historically, checking the tree-ness of the directory tree structure has
not been complete.  Cycles of subdirectories break the tree properties,
as do subdirectories with multiple parents.  It's easy enough for DFS to
detect problems as long as one of the participants is reachable from the
root, but this technique cannot find unconnected cycles.

Directory parent pointers change that, because we can discover all of
these problems from a simple walk from a subdirectory towards the root.
For each child we start with, if the walk terminates without reaching
the root, we know the path is disconnected and ought to be attached to
the lost and found.  If we find ourselves, we know this is a cycle and
can delete an incoming edge.  If we find multiple paths to the root, we
know to delete an incoming edge.

Even better, once we've finished walking paths, we've identified the
good ones and know which other path(s) to remove.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-directory-tree

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-directory-tree

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-directory-tree
---
 db/namei.c                          |  374 +++++++++++++++++++++++++++++++++++
 include/xfs_inode.h                 |    4 
 libfrog/scrub.c                     |    5 
 libxfs/libxfs_api_defs.h            |    6 +
 libxfs/xfs_fs.h                     |    4 
 libxfs/xfs_health.h                 |    4 
 man/man2/ioctl_xfs_bulkstat.2       |    3 
 man/man2/ioctl_xfs_fsbulkstat.2     |    3 
 man/man2/ioctl_xfs_scrub_metadata.2 |   14 +
 man/man8/xfs_db.8                   |   20 ++
 scrub/phase5.c                      |  271 ++++++++++++++++++++++++-
 scrub/repair.c                      |   13 +
 scrub/repair.h                      |    2 
 spaceman/health.c                   |    4 
 14 files changed, 711 insertions(+), 16 deletions(-)

