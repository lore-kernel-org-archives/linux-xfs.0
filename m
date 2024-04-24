Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23C0BE4D
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713927996; cv=none; b=Ve+vigki8M6c3+Y8uwIO8bNcd0WjOTOX1fFt+x5KrdhAoqMucGY0m+AtZ16zR3hC21X1vDCOTiMUU3CAzOwRRXwcYLjQrM2Vpq49KefUiZ+AD7XwyMp7NeshfQhsqlWrdhDRjYH3ykcuMjH8XakE5OXj7IvXnWT5Z2xDpJIsacU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713927996; c=relaxed/simple;
	bh=iw2dfrK8OgrpiJxqUawxKhe8vVUSeaRRxM/bHvvktDo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kuu7iPOC9VbaQBxvP+qG0O3pOYY4FEtHBaQE1sdMZZMAQNMwJiAYP/Auu7NgJALZPXnVJqaq8sfO4Qm8wHkayFpLeQJWpryRSuNXLHepZm/O2MPUuaKbLlG3S4bb6SxiZjN293Ph27IFAmNu/Kot4jJoDttgi1gWMuZI5DlCSZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZRtBfLZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZRtBfLZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831C5C116B1;
	Wed, 24 Apr 2024 03:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713927995;
	bh=iw2dfrK8OgrpiJxqUawxKhe8vVUSeaRRxM/bHvvktDo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZRtBfLZVOLwAyKCF7kuw71AKTof1PImL8uKs6Yal7rqvDb23o6JVcq2QyF7xt0FZd
	 tXfi2CGV+UTjUuNlPJCLg2UwDXRXHaiKj3D/F9LvGgci9d+Ico+jL6fkCd8S/9Si7y
	 jN+dPzZjO0I2p/4g4Jd8CZFme4f9xboot6hSz1jPKk4lpq5civAwM3kZhLIAlx2+A7
	 7q+7gCLhQMvyUNKPV4CkQoozRRjgM9j+Gay2OxXp64erxWfL+srBM32Fg7ZLuhdH58
	 5NRLDlgdc9YorMYZ20sNJOBXPwb57cvEhPC8guAFiEtsyi9bu3wiAl01rTxn6lyJY2
	 Kha0/xTlJtUSg==
Date: Tue, 23 Apr 2024 20:06:34 -0700
Subject: [PATCHSET v13.4 5/9] xfs: online repair for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
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

This series implements online repair for directory parent pointer
metadata.  The checking half is fairly straightforward -- for each
outgoing directory link (forward or backwards), grab the inode at the
other end, and confirm that there's a corresponding link.  If we can't
grab an inode or lock it, we'll save that link for a slower loop that
cycles all the locks, confirms the continued existence of the link, and
rechecks the link if it's actually still there.

Repairs are a bit more involved -- for directories, we walk the entire
filesystem to rebuild the dirents from parent pointer information.
Parent pointer repairs do the same walk but rebuild the pptrs from the
dirent information, but with the added twist that it duplicates all the
xattrs so that it can use the atomic extent swapping code to commit the
repairs atomically.

This introduces an added twist to the xattr repair code -- we use dirent
hooks to detect a colliding update to the pptr data while we're not
holding the ILOCKs; if one is detected, we restart the xattr salvaging
process but this time hold all the ILOCKs until the end of the scan.

For offline repair, the phase6 directory connectivity scan generates an
index of all the expected parent pointers in the filesystem.  Then it
walks each file and compares the parent pointers attached to that file
against the index generated, and resyncs the results as necessary.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-pptrs-6.10
---
Commits in this patchset:
 * xfs: remove some boilerplate from xfs_attr_set
 * xfs: make the reserved block permission flag explicit in xfs_attr_set
 * xfs: salvage parent pointers when rebuilding xattr structures
 * xfs: add raw parent pointer apis to support repair
 * xfs: repair directories by scanning directory parent pointers
 * xfs: implement live updates for directory repairs
 * xfs: replay unlocked parent pointer updates that accrue during xattr repair
 * xfs: repair directory parent pointers by scanning for dirents
 * xfs: implement live updates for parent pointer repairs
 * xfs: remove pointless unlocked assertion
 * xfs: split xfs_bmap_add_attrfork into two pieces
 * xfs: add a per-leaf block callback to xchk_xattr_walk
 * xfs: actually rebuild the parent pointer xattrs
 * xfs: adapt the orphanage code to handle parent pointers
 * xfs: repair link count of nondirectories after rebuilding parent pointers
 * xfs: inode repair should ensure there's an attr fork to store parent pointers
---
 fs/xfs/libxfs/xfs_attr.c     |   76 ++
 fs/xfs/libxfs/xfs_attr.h     |    3 
 fs/xfs/libxfs/xfs_bmap.c     |   38 -
 fs/xfs/libxfs/xfs_bmap.h     |    3 
 fs/xfs/libxfs/xfs_dir2.c     |    2 
 fs/xfs/libxfs/xfs_dir2.h     |    2 
 fs/xfs/libxfs/xfs_parent.c   |   64 ++
 fs/xfs/libxfs/xfs_parent.h   |    6 
 fs/xfs/scrub/attr.c          |    2 
 fs/xfs/scrub/attr_repair.c   |  484 +++++++++++++++-
 fs/xfs/scrub/attr_repair.h   |    4 
 fs/xfs/scrub/dir_repair.c    |  567 +++++++++++++++++-
 fs/xfs/scrub/findparent.c    |   12 
 fs/xfs/scrub/findparent.h    |   10 
 fs/xfs/scrub/inode_repair.c  |   41 +
 fs/xfs/scrub/listxattr.c     |   10 
 fs/xfs/scrub/listxattr.h     |    4 
 fs/xfs/scrub/nlinks.c        |    3 
 fs/xfs/scrub/orphanage.c     |   38 +
 fs/xfs/scrub/orphanage.h     |    3 
 fs/xfs/scrub/parent.c        |    7 
 fs/xfs/scrub/parent_repair.c | 1307 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c         |    2 
 fs/xfs/scrub/trace.h         |  153 +++++
 fs/xfs/xfs_xattr.c           |   26 +
 25 files changed, 2743 insertions(+), 124 deletions(-)

