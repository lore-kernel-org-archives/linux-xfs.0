Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC58C19E
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712709957; cv=none; b=gaouux5N3jBPfzXRAjZzhRW76MssHNBwbol85+xXECfOTDCTGZGAfUKwIkafBjuWpzeNtjEEUoFu8WakRzSPqNUY0ivEaHW1fdhgFK++C65h2X9VA7IAPMtlUfJLYoGh6kWvGGaeY+8lm203Uy7d8IjWgsTw8pB+ojLAtkDHovc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712709957; c=relaxed/simple;
	bh=uedsrlCWNdkT+L/m65ca3+QhvJ37DMFYOtubxj+Ihhc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TLWidJEGaV6ERW632Hrpx2Wmszl6NfsI82625HhRupIW7PFHaPxv5sDLjQuYOhZJQiS+2uwQ3AJaUkbXrtPSfKERzluFVO1EEWL7URmZQisDRdQ78cgnvClrnqfkaWrX1A0gHLB0Scg9mhoKvQSY3evKrL8kP/vdH+Myr6G469U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PBFWE7Ra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PBFWE7Ra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9F9C433F1;
	Wed, 10 Apr 2024 00:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712709957;
	bh=uedsrlCWNdkT+L/m65ca3+QhvJ37DMFYOtubxj+Ihhc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PBFWE7RafoNSCKsdiSf/seigtBq+XKF6i7AxhuB3h3L8VvTPRlJRJIZKttTkzGVOw
	 HOSuxGxQXITlu8OuRgJqjEAsiOfGyd1SgG0KEZm9XVQ7oLgSCJgfiavpC8BxUOxOlN
	 K3igyFXgQWXjzv0/W06yUVqaH5GFqvORtwF4kUibtvwd4h8JXzOj2DLJib38suXzoT
	 4osqrCzzXNzV51cXGRBOmOc9Vhd8185I7tqeWpK15v+JFoS/XvwNnf25GUen6eIcpJ
	 VYTmqqQ5F0JCrqWS75fSlGqFEtMk5QWtAK8B6Y8qEWbW0MIBxLE2fyuzPybfAQps6u
	 AOssMZIiRA+nQ==
Date: Tue, 09 Apr 2024 17:45:56 -0700
Subject: [PATCHSET v13.1 7/9] xfs: online repair for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
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
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-pptrs

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-pptrs
---
Commits in this patchset:
 * xfs: add xattr setname and removename functions for internal users
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
 fs/xfs/libxfs/xfs_attr.c     |  230 +++++++
 fs/xfs/libxfs/xfs_attr.h     |    4 
 fs/xfs/libxfs/xfs_bmap.c     |   38 -
 fs/xfs/libxfs/xfs_bmap.h     |    3 
 fs/xfs/libxfs/xfs_dir2.c     |    2 
 fs/xfs/libxfs/xfs_dir2.h     |    2 
 fs/xfs/libxfs/xfs_parent.c   |   64 ++
 fs/xfs/libxfs/xfs_parent.h   |    6 
 fs/xfs/scrub/attr.c          |    2 
 fs/xfs/scrub/attr_repair.c   |  459 +++++++++++++++
 fs/xfs/scrub/attr_repair.h   |    4 
 fs/xfs/scrub/dir_repair.c    |  564 +++++++++++++++++-
 fs/xfs/scrub/findparent.c    |   12 
 fs/xfs/scrub/findparent.h    |   10 
 fs/xfs/scrub/inode_repair.c  |   41 +
 fs/xfs/scrub/listxattr.c     |   10 
 fs/xfs/scrub/listxattr.h     |    4 
 fs/xfs/scrub/nlinks.c        |    3 
 fs/xfs/scrub/orphanage.c     |   38 +
 fs/xfs/scrub/orphanage.h     |    3 
 fs/xfs/scrub/parent.c        |    7 
 fs/xfs/scrub/parent_repair.c | 1301 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c         |    2 
 fs/xfs/scrub/trace.h         |  115 ++++
 24 files changed, 2816 insertions(+), 108 deletions(-)

