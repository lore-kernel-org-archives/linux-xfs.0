Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E58BE4D
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928011; cv=none; b=VKpadGUIjI1lE55GkZ7gcfDUQ5mZU7stOd/0wHf+46zI8W1PEC0mFAxgWbqRbbynOSApXFsvBi1JujYHUG+FKdTzUKTLoNi/kW7iOv77ndS0+dTsjZO/M4qFttcaUUUGtYkx2qtZsGc27J7m0+qLiDGuYChCONdC1QRSq7UWaAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928011; c=relaxed/simple;
	bh=MHxvgKRXpYqr545jbw2HKhRWL6s8b4HTAeKyH2+WcA0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d1FEHnzDL+wnwVej1oCPvDZ8SXe+r7qLoNE2wMwCV7AHboTdhANTuH9cNYtou5h2ycKFfsuf7m2younjqGXW86+2yxlWuf02EsyzJJwlDYwaKnxtcapPywKryz1OI1OuHltMpog2qiiN8usP2aDqdU0SK8wZyrQvYib1xPtQv9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BbmL+yZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BbmL+yZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18672C116B1;
	Wed, 24 Apr 2024 03:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928011;
	bh=MHxvgKRXpYqr545jbw2HKhRWL6s8b4HTAeKyH2+WcA0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BbmL+yZX8dv4o7uI+qYkkhSSErkQy9Dz+7LNDgL+YiA0PZhWIBcZzFsYL0ocUCDIb
	 IbdPBFvSdNQUNScipkKqBbDFrOkBq5Ilnl2LUirL5ysRZHJ+FiNvJkANwB7r/8IIua
	 eR6qti6nWNutwfqv46FECrPgh3zQO+wxc08M7A/FDrAVjpaHIE4VWDnAQtoygsfNty
	 K7ssa52NX44nzqPI3a3jh+0uCXCxDmfQ2eR1gx9ku7s/QOfnPLZzrt3XxGewuKAMo3
	 rgu6FZ39hSlE3xbV7tn6NG3WKfvcnAP1W8lsmTJuHDgmRHkSew5ELFr+kz0TCKeb58
	 bUdo6kqs4TbEA==
Date: Tue, 23 Apr 2024 20:06:50 -0700
Subject: [PATCHSET v13.4 6/9] xfs: detect and correct directory tree problems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392785243.1906995.3930834516122962087.stgit@frogsfrogsfrogs>
In-Reply-To: <20240424030246.GB360919@frogsfrogsfrogs>
References: <20240424030246.GB360919@frogsfrogsfrogs>
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
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-directory-tree-6.10
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

