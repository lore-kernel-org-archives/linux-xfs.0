Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FBD156225
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224167; cv=none; b=BsnOLMZfLR6lDvuaXq+6T7Pc3uXkxBc4Tvv1msQMd1Liy8T0jA6ouu3rhlFt1aZLlb+ijk7Iqs7iAyzyfzuoTNNtUsgwo3rxHhzhzzBrHZTdqVUeFcjcyZLcnac+U1m4tVh1yw4GMJ/LVkRUG4ZD47hX5XWJZcILo+O7qBqtrOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224167; c=relaxed/simple;
	bh=EQSE/b/pX98cdMEa8VHTlysimCkLzLSAwoN3zyuApt8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pC1euYMbSceTzwn/u2YzMCPqR53k0Un+NL8m2IpOPUV80OceQkUo0O1d463APTF5ZUhvw1Tv3VS8H0ZASbog1CjIn5dXORUK9/hQ2DxPn9bG+6QfLn3WHpo6zh9FQRN4y23EyCbzvLkU71nTmkbWVmgJHKhWQtS2+PHg7oh6i+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ktrzZ0nN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ktrzZ0nN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8D0C113CC;
	Mon, 15 Apr 2024 23:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224167;
	bh=EQSE/b/pX98cdMEa8VHTlysimCkLzLSAwoN3zyuApt8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ktrzZ0nN0+iZDTwCTQbWR1u/3ScDIkojvKOyrBwQwX1erNcXDaC9PYqIu2N+Sq6OY
	 YwGdcv9Y+KbgcsxOvtJvyo7TA3Tvp9Kv5ZLmLUN9SnZ+wRme42SmdyTzkzfVkfc7j+
	 /PnJsTkp8g4kRbT+ICVOqyJj/ScJ88riErRcVYzP+BEzHS7QC6w7T0UGthwVjHlAql
	 etXSilmna/K81cU+Ch8lGm1cNENNMTK19GpzzDCdJ8WudvqBPVFnIQkLpP8EGMpKmJ
	 nQxGg2xliJXBPHaLe6Gqr4kzaJC5QgQFLKeyrixXfSd8nDkNMjvyREGsCFlZmBZNuh
	 2NKYT2RuLUd8Q==
Date: Mon, 15 Apr 2024 16:36:06 -0700
Subject: [PATCHSET v30.3 10/16] xfs: move orphan files to lost and found
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322384265.89422.12835876074903686240.stgit@frogsfrogsfrogs>
In-Reply-To: <20240415232853.GE11948@frogsfrogsfrogs>
References: <20240415232853.GE11948@frogsfrogsfrogs>
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

Orphaned files are defined to be files with nonzero ondisk link count
but no observable parent directory.  This series enables online repair
to reparent orphaned files into the filesystem directory tree, and wires
up this reparenting ability into the directory, file link count, and
parent pointer repair functions.  This is how we fix files with positive
link count that are not reachable through the directory tree.

This patch will also create the orphanage directory (lost+found) if it
is not present.  In contrast to xfs_repair, we follow e2fsck in creating
the lost+found without group or other-owner access to avoid accidental
disclosure of files that were previously hidden by an 0700 directory.
That's silly security, but people have been known to do it.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-orphanage-6.10
---
Commits in this patchset:
 * xfs: move orphan files to the orphanage
 * xfs: move files to orphanage instead of letting nlinks drop to zero
 * xfs: ensure dentry consistency when the orphanage adopts a file
---
 .../filesystems/xfs/xfs-online-fsck-design.rst     |   20 -
 fs/xfs/Makefile                                    |    1 
 fs/xfs/scrub/dir_repair.c                          |  130 ++++
 fs/xfs/scrub/nlinks.c                              |   20 +
 fs/xfs/scrub/nlinks.h                              |    7 
 fs/xfs/scrub/nlinks_repair.c                       |  123 ++++
 fs/xfs/scrub/orphanage.c                           |  589 ++++++++++++++++++++
 fs/xfs/scrub/orphanage.h                           |   75 +++
 fs/xfs/scrub/parent_repair.c                       |  100 +++
 fs/xfs/scrub/repair.h                              |    2 
 fs/xfs/scrub/scrub.c                               |    2 
 fs/xfs/scrub/scrub.h                               |    4 
 fs/xfs/scrub/trace.c                               |    1 
 fs/xfs/scrub/trace.h                               |   96 +++
 fs/xfs/xfs_inode.c                                 |    6 
 fs/xfs/xfs_inode.h                                 |    1 
 16 files changed, 1139 insertions(+), 38 deletions(-)
 create mode 100644 fs/xfs/scrub/orphanage.c
 create mode 100644 fs/xfs/scrub/orphanage.h

