Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2E5523D
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230450; cv=none; b=oMgasJT0Ih6jqive3F87qnUxJNTrehyTSrH5mUjOgzNFF97gW9/IrbnMEXbUBSzHnaRXkruSHf5TpiVjLxf1e5KeFVvcLKcUrEE84izKbjhIEhtEMq0+CL9TgqZ3sxr9M2TuKM1ERIhPZBkeC1098W1yjTDpkwtCpC17D5oWCNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230450; c=relaxed/simple;
	bh=KCEGs9sIO0dolLdj7KfH7ARSc+p/MjbDvpJxeCk/j3k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bACQwGUu6/4MM8fwcP/fQuX+oIkbauQjtDdGoJp+/sI+mVTglro9DHdsIpgcvcmtrJFY/39uHU58DHiz42YO/t8UhZfZSTcshJEc4MOM10lMLgGEbH+L3Dqp4SgF5TsxiijvYwRIT326q86fp/UjnRJXIbyXuac6VXJ1i8WI2K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LoNfLKWc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LoNfLKWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC6BC113CC;
	Tue, 16 Apr 2024 01:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230450;
	bh=KCEGs9sIO0dolLdj7KfH7ARSc+p/MjbDvpJxeCk/j3k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LoNfLKWcEF5wXitn0P95S6KG2uGk0NazEpC8+8BY/aP9bWzyBtluaKxOxjMA1lC5L
	 6OmuQmUMzkJ6C4+oxkKJGCH2jPGTcgsia84ZgT6RoscbJ7YAUAxRVNeCbA/2O/OXaw
	 W3W9LGrV3bdPCFjoR2BZVeghVmppCJjcZH5y/inPSet8IrjrCMmVmhyoAfV14yOWeu
	 KR1BJeCV6nI8wIoE7SzWAzfX2IKgwJCNhXazPpZ1fk8iZj2OThv9m7ihRdL58Qeez/
	 LdodvEo74pEPJclD8zh3Yd/4RdOa6S5tfX/RpFRwMnx8fbJPWHgEbqL4P7kWBk1Tlc
	 +9X3PybT9N7QQ==
Date: Mon, 15 Apr 2024 18:20:49 -0700
Subject: [PATCHSET v13.2 6/7] xfs: detect and correct directory tree problems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de,
 hch@infradead.org
Message-ID: <171323029803.253678.14863175875387657276.stgit@frogsfrogsfrogs>
In-Reply-To: <20240416011640.GG11948@frogsfrogsfrogs>
References: <20240416011640.GG11948@frogsfrogsfrogs>
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
Commits in this patchset:
 * xfs: teach online scrub to find directory tree structure problems
 * xfs: invalidate dirloop scrub path data when concurrent updates happen
 * xfs: report directory tree corruption in the health information
 * xfs: fix corruptions in the directory tree
---
 fs/xfs/Makefile               |    2 
 fs/xfs/libxfs/xfs_fs.h        |    4 
 fs/xfs/libxfs/xfs_health.h    |    4 
 fs/xfs/scrub/common.h         |    1 
 fs/xfs/scrub/dirtree.c        |  985 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/dirtree.h        |  178 +++++++
 fs/xfs/scrub/dirtree_repair.c |  821 ++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/health.c         |    1 
 fs/xfs/scrub/ino_bitmap.h     |   37 ++
 fs/xfs/scrub/orphanage.c      |    6 
 fs/xfs/scrub/orphanage.h      |    8 
 fs/xfs/scrub/repair.h         |    4 
 fs/xfs/scrub/scrub.c          |    7 
 fs/xfs/scrub/scrub.h          |    1 
 fs/xfs/scrub/stats.c          |    1 
 fs/xfs/scrub/trace.c          |    4 
 fs/xfs/scrub/trace.h          |  272 +++++++++++
 fs/xfs/scrub/xfarray.h        |    1 
 fs/xfs/xfs_health.c           |    1 
 fs/xfs/xfs_inode.c            |    2 
 fs/xfs/xfs_inode.h            |    1 
 21 files changed, 2337 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/scrub/dirtree.c
 create mode 100644 fs/xfs/scrub/dirtree.h
 create mode 100644 fs/xfs/scrub/dirtree_repair.c
 create mode 100644 fs/xfs/scrub/ino_bitmap.h

