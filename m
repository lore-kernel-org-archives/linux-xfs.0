Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAF9B64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l7FPoBmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23DDC433C8;
	Sun, 31 Dec 2023 19:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051253;
	bh=OVD29D/QPhSfoe/aiQW53qqzo6jC3N2r0NajpWdMYHI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l7FPoBmvmnFepvh9tku1ChHhqKsSfe1Edw7ZueRE8lPucz8EfKS7u41aV2FVMvgcL
	 Ej/59qQT96njSBHRzqFpwNcjOGwHt4WxSibaCGCicOdscfz9YcdkiyPSeK2sm7KPvJ
	 neDxof9nZKjTgvk9mWXiYZmh0o8VIPI8lmSVw8/0Y1v8P1xHDQve28aeEeFU0DUztt
	 Ts3GKJVn66Ef5gGFNdArikVickoQnLLvDVtPfEpFb6RP8b4gcIt8kO5LhrQJWTOBmQ
	 Z8uADnP0a67My6CKNcTnNiDjoua6wyroBG6oIn4EdbC/i5k+7OlG3Vtzn79vm+xXCz
	 HndmRZ20Kkpeg==
Date: Sun, 31 Dec 2023 11:34:13 -0800
Subject: [PATCHSET v13.0 6/7] xfs: detect and correct directory tree problems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404842446.1757975.532228960833173146.stgit@frogsfrogsfrogs>
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
 fs/xfs/Makefile               |    2 
 fs/xfs/libxfs/xfs_fs.h        |    4 
 fs/xfs/libxfs/xfs_health.h    |    4 
 fs/xfs/scrub/common.h         |    1 
 fs/xfs/scrub/dirtree.c        |  938 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/dirtree.h        |  171 +++++++
 fs/xfs/scrub/dirtree_repair.c |  824 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/health.c         |    1 
 fs/xfs/scrub/ino_bitmap.h     |   37 ++
 fs/xfs/scrub/orphanage.c      |    6 
 fs/xfs/scrub/orphanage.h      |    8 
 fs/xfs/scrub/repair.h         |    4 
 fs/xfs/scrub/scrub.c          |    7 
 fs/xfs/scrub/scrub.h          |    1 
 fs/xfs/scrub/stats.c          |    1 
 fs/xfs/scrub/trace.c          |    4 
 fs/xfs/scrub/trace.h          |  270 ++++++++++++
 fs/xfs/scrub/xfarray.h        |    1 
 fs/xfs/xfs_health.c           |    1 
 fs/xfs/xfs_inode.c            |    2 
 fs/xfs/xfs_inode.h            |    1 
 21 files changed, 2284 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/scrub/dirtree.c
 create mode 100644 fs/xfs/scrub/dirtree.h
 create mode 100644 fs/xfs/scrub/dirtree_repair.c
 create mode 100644 fs/xfs/scrub/ino_bitmap.h

