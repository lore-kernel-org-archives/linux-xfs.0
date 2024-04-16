Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808C2652
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713227400; cv=none; b=eUAbGfFwszAT9vxJC1Kuqz/6wrLtYuzQ1lCNjluLYpGXUEMSZ1ZxcEU8QfgH8CqfNfgz4AnssxFweqE0J5zXJZ2W1UMEdHdxZvWP3Qe6qWc1elGxD6PX9lNlNN2E6aBZ1dwzco6uIVzYMaeROQUOJvI3Zke7KSJUs9dRLCJmAB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713227400; c=relaxed/simple;
	bh=vt/b72xFxysxc27+OHDyWkgk0vjgnlsHHNrEdJ2+EA8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=OSR3gycm8EbY4zeHdqYC2Npvdu411lBISpSnyRqIxaSJXZTqvJV79bXJoeA0d/XMgDuWJoaA1VhOBN5K/5StDnChGV7GFNhy7L79WAxpU5rb03pBq/1WkRXPf4iWB66IfpBCg6LUlrWRFeYX04IXuTeC0K5uI2Ui793xpK4d1a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XLEukIKf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XLEukIKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2C6C2BD11;
	Tue, 16 Apr 2024 00:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713227400;
	bh=vt/b72xFxysxc27+OHDyWkgk0vjgnlsHHNrEdJ2+EA8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XLEukIKfwpChUzHVREsB6/w3/E+I6Nw9vlChfce5DGTjWtjGbOgn6+2K70wCiNEoj
	 jv9bWgAuh3FH3xq8NJtcsiGUxU+eGEMKdU0Up+4T0l5jzFugHEghWUMVB0Tj6lwMQG
	 ZEjGbASUQQkUZx/X3ePqr3qTyqcR4HNcuNbMJyQweC+nnjiS8pOxfn8eF1HzkQGpOd
	 F/f7xtoKq0eSpGsqIZGciITBa9vRczh+XdptHVx5ERIcAMrKPQl5V/0E/bnnCpo9u3
	 rTXDiiqALJVsDIV8XFu5CDuJ2/8zrrw7XTr85mvKocHMc0mg96PYebimSm3G5/W9H9
	 frBQ6WOXypHBg==
Date: Mon, 15 Apr 2024 17:29:59 -0700
Subject: [GIT PULL 10/16] xfs: move orphan files to lost and found
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322718011.141687.9955601436581822988.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240416002427.GB11972@frogsfrogsfrogs>
References: <20240416002427.GB11972@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 34c9382c128270d0f4c8b36783b30f3c8085b2dd:

xfs: ask the dentry cache if it knows the parent of a directory (2024-04-15 14:58:56 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-orphanage-6.10_2024-04-15

for you to fetch changes up to 73597e3e42b4a15030e6f93b71b53a04377ea419:

xfs: ensure dentry consistency when the orphanage adopts a file (2024-04-15 14:58:57 -0700)

----------------------------------------------------------------
xfs: move orphan files to lost and found [v30.3 10/16]

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

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs: move orphan files to the orphanage
xfs: move files to orphanage instead of letting nlinks drop to zero
xfs: ensure dentry consistency when the orphanage adopts a file

.../filesystems/xfs/xfs-online-fsck-design.rst     |  20 +-
fs/xfs/Makefile                                    |   1 +
fs/xfs/scrub/dir_repair.c                          | 130 ++++-
fs/xfs/scrub/nlinks.c                              |  20 +-
fs/xfs/scrub/nlinks.h                              |   7 +
fs/xfs/scrub/nlinks_repair.c                       | 123 ++++-
fs/xfs/scrub/orphanage.c                           | 589 +++++++++++++++++++++
fs/xfs/scrub/orphanage.h                           |  75 +++
fs/xfs/scrub/parent_repair.c                       | 100 +++-
fs/xfs/scrub/repair.h                              |   2 +
fs/xfs/scrub/scrub.c                               |   2 +
fs/xfs/scrub/scrub.h                               |   4 +
fs/xfs/scrub/trace.c                               |   1 +
fs/xfs/scrub/trace.h                               |  96 ++++
fs/xfs/xfs_inode.c                                 |   6 +-
fs/xfs/xfs_inode.h                                 |   1 +
16 files changed, 1139 insertions(+), 38 deletions(-)
create mode 100644 fs/xfs/scrub/orphanage.c
create mode 100644 fs/xfs/scrub/orphanage.h

