Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80635F4F1
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000337; cv=none; b=HKqH2ilUiIISGB0dk+gfYEWlngiw87YIpwE9pfDVfmmDQ/G6ORm8SIkN8iyKXN8ThGLNSZwi0jcZXFqtAChFd49vWeCscPP+kZRLuKftiS8l7H24q3EvEFiQbj9KWzn7CdTVw/hxcoVf68OJOg6b4cXlbtBGa1t/0FVVOMsILrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000337; c=relaxed/simple;
	bh=VPgRPIFfvbILCs16h5gz68U9fFeduD8DSvECisHzxrs=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=D9xFnjeMT6GhmZ+XkJRuMMpzj3Oi4lmZ+4SOjUhgIZRbECll+wsYvgTgCqPGfEPegcPb/8sivyNQh+/fcTca4CBb8viC7rWEq4N2wbm7WaR1G64S8TPexNaXT0sOt8bjBZZUHWAzNvT5VvEGuw9pWe2anjk7v9CTgAQ4x9VjCcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XLyohgr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XLyohgr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B43C433C7;
	Tue, 27 Feb 2024 02:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000337;
	bh=VPgRPIFfvbILCs16h5gz68U9fFeduD8DSvECisHzxrs=;
	h=Date:Subject:From:To:Cc:From;
	b=XLyohgr9pYUm/dR1AoP7LQzW9mNn66QidU2ugFATh82MsTI6ceLBt9JZEOM6AglPy
	 fqXlteJTlK/mxyIO5PLBCPMnZFJ/12G3FdQgmDt1dtS0y/+6NPQTjDcucCPt0f5q95
	 DbhDgBSTanVxVlYmypikw/WCqpMR3UkSq0IpYUmu1zNWPWnsuGK41c5e1odRbzD16A
	 iOJFMPnw08BBpKURvMhcbfFt3yIUvGXYNZ85/+lWFxAgZ+awU5UMqS0sPAnA2unBiG
	 WNQDcwQsvw4yqn22Hl4eKRmgyQbSmkNDHPc4mLJgujv1rdGizDeOEcXniSeTj28YyF
	 kT8KtjrL94QEA==
Date: Mon, 26 Feb 2024 18:18:56 -0800
Subject: [PATCHSET v29.4 13/13] xfs: inode-related repair fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900016032.940004.10036483809627191806.stgit@frogsfrogsfrogs>
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

While doing QA of the online fsck code, I made a few observations:
First, nobody was checking that the di_onlink field is actually zero;
Second, that allocating a temporary file for repairs can fail (and
thus bring down the entire fs) if the inode cluster is corrupt; and
Third, that file link counts do not pin at ~0U to prevent integer
overflows.  Fourth, the x{chk,rep}_metadata_inode_fork functions
should be subclassing the main scrub context, not modifying the
parent's setup willy-nilly.

This scattered patchset fixes those three problems.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inode-repair-improvements

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=inode-repair-improvements
---
Commits in this patchset:
 * xfs: check unused nlink fields in the ondisk inode
 * xfs: try to avoid allocating from sick inode clusters
 * xfs: pin inodes that would otherwise overflow link count
 * xfs: create subordinate scrub contexts for xchk_metadata_inode_subtype
---
 fs/xfs/libxfs/xfs_format.h    |    6 ++++
 fs/xfs/libxfs/xfs_ialloc.c    |   40 ++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_buf.c |    8 +++++
 fs/xfs/scrub/common.c         |   23 ++------------
 fs/xfs/scrub/dir_repair.c     |   11 ++-----
 fs/xfs/scrub/inode_repair.c   |   12 +++++++
 fs/xfs/scrub/nlinks.c         |    4 ++
 fs/xfs/scrub/nlinks_repair.c  |    8 +----
 fs/xfs/scrub/repair.c         |   67 ++++++++---------------------------------
 fs/xfs/scrub/scrub.c          |   63 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.h          |   11 +++++++
 fs/xfs/xfs_inode.c            |   33 +++++++++++++-------
 12 files changed, 187 insertions(+), 99 deletions(-)

