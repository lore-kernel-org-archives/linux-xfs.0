Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76BC156225
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224152; cv=none; b=b5smzAikAIVKj7iOLmyrHGNXy5AyV6lgTFwdbs6XnPFSkBQuJ9WVXVVaa5f7FXc3d9vReihMcVI6eDWbphEMuV5fUBhza2H0Qm/13wu59dt+v8z0kuZYLhGg1ljOQuggW3cnwUaZqY+ZCPgVcdClRQyxvaJ4JtnFCwRfSX2cKNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224152; c=relaxed/simple;
	bh=bEUYyIByTD79O+bIC7emhIn9k/3e3xEboqgS75c4uuM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HtEXuMISuoWw4WPJXdFYIUmVrKrsbocCalB7tAf6KFi+h59wcNe/Adtz4RzGMWL/FDpnuc1+3pfXEt9IsAPJKLarR0T1lX++cHxdV8RCtuuwgvSxKs/YSjvfw+hhOjT58gNvyMdHgrk6dQpSDL9ZqrdwY84Z65mrHIvH1U7Ybys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HlE1yUJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HlE1yUJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A9DC113CC;
	Mon, 15 Apr 2024 23:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224151;
	bh=bEUYyIByTD79O+bIC7emhIn9k/3e3xEboqgS75c4uuM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HlE1yUJnYwxpfOy2oK4aIExEBJPTiXkfAuNZk9IhKvPvDcasIJ1643oueQ7iifu/7
	 IBckrOz8HsrRY0l0YFP+VhgdMUbAFYWCi+ZfA9Asq7qmAXRKKek8R6kZtIZoZUCDDC
	 AQF/P1L038vbG9V0cNLoMkjtFN4EWb8RHQUrwcnxOMriETicGeCVKeTFDMtuioP1dG
	 xwyX1y6KY0VuaUVDa7XK0tC5nCgXOxBfUrkEs1sMrQ92ifKTKroxmdXcS4YrD9WHij
	 MTD1cnmKQA10BVa/L3n9OQmD2kflD6/Xrw4CkLaGtc0m1lt2V5QRr2XcbymlIJ7TsC
	 GvGOVp6ZDpCTA==
Date: Mon, 15 Apr 2024 16:35:51 -0700
Subject: [PATCHSET v30.3 09/16] xfs: online repair of directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322383857.89193.15436066970892287907.stgit@frogsfrogsfrogs>
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

This series employs atomic extent swapping to enable safe reconstruction
of directory data.  For now, XFS does not support reverse directory
links (aka parent pointers), so we can only salvage the dirents of a
directory and construct a new structure.

Directory repair therefore consists of five main parts:

First, we walk the existing directory to salvage as many entries as we
can, by adding them as new directory entries to the repair temp dir.

Second, we validate the parent pointer found in the directory.  If one
was not found, we scan the entire filesystem looking for a potential
parent.

Third, we use atomic extent swaps to exchange the entire data fork
between the two directories.

Fourth, we reap the old directory blocks as carefully as we can.

To wrap up the directory repair code, we need to add to the regular
filesystem the ability to free all the data fork blocks in a directory.
This does not change anything with normal directories, since they must
still unlink and shrink one entry at a time.  However, this will
facilitate freeing of partially-inactivated temporary directories during
log recovery.

The second half of this patchset implements repairs for the dotdot
entries of directories.  For now there is only rudimentary support for
this, because there are no directory parent pointers, so the best we can
do is scanning the filesystem and the VFS dcache for answers.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-dirs-6.10
---
Commits in this patchset:
 * xfs: inactivate directory data blocks
 * xfs: online repair of directories
 * xfs: scan the filesystem to repair a directory dotdot entry
 * xfs: online repair of parent pointers
 * xfs: ask the dentry cache if it knows the parent of a directory
---
 fs/xfs/Makefile              |    3 
 fs/xfs/scrub/dir.c           |    9 
 fs/xfs/scrub/dir_repair.c    | 1402 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/findparent.c    |  448 +++++++++++++
 fs/xfs/scrub/findparent.h    |   50 +
 fs/xfs/scrub/inode_repair.c  |    5 
 fs/xfs/scrub/iscan.c         |   18 +
 fs/xfs/scrub/iscan.h         |    1 
 fs/xfs/scrub/nlinks.c        |   23 +
 fs/xfs/scrub/nlinks_repair.c |    9 
 fs/xfs/scrub/parent.c        |   14 
 fs/xfs/scrub/parent_repair.c |  234 +++++++
 fs/xfs/scrub/readdir.c       |    7 
 fs/xfs/scrub/repair.c        |    1 
 fs/xfs/scrub/repair.h        |    8 
 fs/xfs/scrub/scrub.c         |    4 
 fs/xfs/scrub/tempfile.c      |   13 
 fs/xfs/scrub/tempfile.h      |    2 
 fs/xfs/scrub/trace.h         |  115 +++
 fs/xfs/scrub/xfblob.h        |   24 +
 fs/xfs/xfs_inode.c           |   51 ++
 21 files changed, 2437 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/scrub/dir_repair.c
 create mode 100644 fs/xfs/scrub/findparent.c
 create mode 100644 fs/xfs/scrub/findparent.h
 create mode 100644 fs/xfs/scrub/parent_repair.c

