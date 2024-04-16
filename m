Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5941849
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713227384; cv=none; b=AB5nKkVn+uui5cba2slXfoBNn5zwQTZBn/+rR1O8ls3JudNo/uAajfiUVIY32HrtbKzLoNX04cz0Q8cPnFuHBsf/5ScYqO31SoMZQT2henVC3Mj8PfoVNgGpZ/yyvA0O3XZ7MzVUhAnaouRH+h2yCeiNxfTHzKgHwQ/zSsVGv6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713227384; c=relaxed/simple;
	bh=7USljy29UwbUBLeIxG0O4iAYoT5AWOiKpxU40umtisw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=cguuYxEhOAce7SrYsJSzrb93lA52hy8k6I6FpihrQox2aymr2BVatfh3Mz021GnLYuN9ejFekQcf+TSdozZtIJSQdQt0eSDS/3nD711d1QOwF0Qc4LpLcKQGw5QgO4RmP5V66vQBtro74/O9nsqPUGyPsMZKWyH5cx4K9yGfzVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OxsI/qVr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OxsI/qVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C3AC113CC;
	Tue, 16 Apr 2024 00:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713227384;
	bh=7USljy29UwbUBLeIxG0O4iAYoT5AWOiKpxU40umtisw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OxsI/qVrHFdHp/tnJagzSX9IQQVofFtbMHf6Z2PUTkAR688ePlyXKYqTN909EFLXM
	 VdtJa1XAgG88RCzXpvYYd4ro2TKZSNA6S2syIRolMAnz/MEdX1zmBUQ89xbzbcBoa1
	 QR2zDQo/id12S7VtQOXkue0K30Y58B689V7SyT1K9fcsi296laMSzil2maa4tKCcpJ
	 7UN3SsWXf93P9MbeMBJNhz8hL21RC0qpGYKBq7fWDyGDOiK2qGKqhuM20/pzhH1lgf
	 9w07a+uOQHjdDutGWPq/VCwt6N8O9fLxyPDuW+AOgRKgRgj2Wssh/4R402wtdoJiWO
	 TReo5dnmvs0Og==
Date: Mon, 15 Apr 2024 17:29:43 -0700
Subject: [GIT PULL 09/16] xfs: online repair of directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322717675.141687.2316228706475122308.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 669dfe883c8e20231495f80a28ec7cc0b8fdddc4:

xfs: update the unlinked list when repairing link counts (2024-04-15 14:58:55 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-dirs-6.10_2024-04-15

for you to fetch changes up to 34c9382c128270d0f4c8b36783b30f3c8085b2dd:

xfs: ask the dentry cache if it knows the parent of a directory (2024-04-15 14:58:56 -0700)

----------------------------------------------------------------
xfs: online repair of directories [v30.3 09/16]

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

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (5):
xfs: inactivate directory data blocks
xfs: online repair of directories
xfs: scan the filesystem to repair a directory dotdot entry
xfs: online repair of parent pointers
xfs: ask the dentry cache if it knows the parent of a directory

fs/xfs/Makefile              |    3 +
fs/xfs/scrub/dir.c           |    9 +
fs/xfs/scrub/dir_repair.c    | 1402 ++++++++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/findparent.c    |  448 ++++++++++++++
fs/xfs/scrub/findparent.h    |   50 ++
fs/xfs/scrub/inode_repair.c  |    5 +
fs/xfs/scrub/iscan.c         |   18 +-
fs/xfs/scrub/iscan.h         |    1 +
fs/xfs/scrub/nlinks.c        |   23 +
fs/xfs/scrub/nlinks_repair.c |    9 +
fs/xfs/scrub/parent.c        |   14 +-
fs/xfs/scrub/parent_repair.c |  234 +++++++
fs/xfs/scrub/readdir.c       |    7 +
fs/xfs/scrub/repair.c        |    1 +
fs/xfs/scrub/repair.h        |    8 +
fs/xfs/scrub/scrub.c         |    4 +-
fs/xfs/scrub/tempfile.c      |   13 +
fs/xfs/scrub/tempfile.h      |    2 +
fs/xfs/scrub/trace.h         |  115 ++++
fs/xfs/scrub/xfblob.h        |   24 +
fs/xfs/xfs_inode.c           |   51 ++
21 files changed, 2437 insertions(+), 4 deletions(-)
create mode 100644 fs/xfs/scrub/dir_repair.c
create mode 100644 fs/xfs/scrub/findparent.c
create mode 100644 fs/xfs/scrub/findparent.h
create mode 100644 fs/xfs/scrub/parent_repair.c

