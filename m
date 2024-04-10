Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C69A37C
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712709973; cv=none; b=KYPIv1SPWUAhoYWtgoYUPFZ9LH31C+rOrVb5ZwU3+U0oaH5ti2QFBKU1KOgv9PIiPiy2Fl3GJnWs6ZK6c6tSFM9uZGF9KqEh19nOhpgi6LY+VAx9phXd9x0Q1eyv6Mybm7ztsFPMD9DsbC+w5cTDeK/u3yqGt+QT8rMg5afVW9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712709973; c=relaxed/simple;
	bh=767j3IrWsrbEcMlJPGtv9cgTDLru52rFfSKYU/rQqtY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n51pR3GecBfkWn1rHKyYjcELFXwFwz+pallnW1qYNOp0wI7O9YAdK8UwyAqRxykExm18idO+nV2vCGyk+/3YRW8jMbjMdisSGVdpUNUFVBYXWlEE+wQ7IoX7IcwG4uszeSbzxq08RYKEOObXcKLPTrKylgRi2f4io+AwHmNK6Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jT1p0Ykk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jT1p0Ykk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D310C433F1;
	Wed, 10 Apr 2024 00:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712709973;
	bh=767j3IrWsrbEcMlJPGtv9cgTDLru52rFfSKYU/rQqtY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jT1p0YkkSbAsFt2h0Tb+/MGPtBy9WTrkCF56+EqogdAwChJA/Log2YPkOB6KlxPpR
	 eLuh+BG7owjuZHjvMNVg0V6/aC5DsT22wcXG+IaesliNjS5BAiJObMnL8cada211ub
	 hgqMzs43ZseFbJZcMWyNn4h8K0kYk9TUjYRMRHYRO8dijIxC9GSKFUFa0whyBQYGXi
	 TJPoNCy2g4KcyuNtpHsEbObtsZyJmAP+7G3F3ReK8SaEFaV2v97/coUKcmRLSXBaH1
	 C8KzIGgTnGwfhvvweNSbNFBFq2tc5tkxDDj9ZWeQUGL03VTaeKJtI2tom0P7WaRlXr
	 HFaxdyrbf6yRA==
Date: Tue, 09 Apr 2024 17:46:12 -0700
Subject: [PATCHSET v13.1 8/9] xfs: detect and correct directory tree problems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270971578.3633329.3916047777798574829.stgit@frogsfrogsfrogs>
In-Reply-To: <20240410003646.GS6390@frogsfrogsfrogs>
References: <20240410003646.GS6390@frogsfrogsfrogs>
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
 fs/xfs/scrub/dirtree.c        |  979 +++++++++++++++++++++++++++++++++++++++++
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
 21 files changed, 2331 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/scrub/dirtree.c
 create mode 100644 fs/xfs/scrub/dirtree.h
 create mode 100644 fs/xfs/scrub/dirtree_repair.c
 create mode 100644 fs/xfs/scrub/ino_bitmap.h

