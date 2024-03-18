Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7705915E
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798120; cv=none; b=rCUBJts+5rMo+BEUU68D43SIVWQCZLFbdjAa6Ovu/AK/qw3gCA3UM0U4MXK5GpF0B8FZh9+3soSVfisK9HTnFZY86DWRkJ/a3K8nmgGwPUoNZ9Zz+z3KcSXFb41qMW1e87HsNNBUHpEjT58q8WUxt0FDY3kdCd7hS5lPoek/Kc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798120; c=relaxed/simple;
	bh=QkO5X2uf/yDk9/DWlI2NJaXZUyETzPHIn4BimeSSlsE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d2ND+8s9Sz5WitdOmrlXEgMwF83pYO0Fh+qw6LIVIl9z+8u6ztsf03XBpUYkkIexTF9vYbSgQKwlLJlltx/PBXBICSusf513Et4GtDjzHMz04itda/L0frnEMpqeu73TIrxQQ1io6EFi5wlS7QhUf9mEL+CvQ2NgMRd6i9i3HjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q+eCe4gC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q+eCe4gC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57001C433C7;
	Mon, 18 Mar 2024 21:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798120;
	bh=QkO5X2uf/yDk9/DWlI2NJaXZUyETzPHIn4BimeSSlsE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q+eCe4gCJ/SIJrTq5JgcaZlYd97ZgQmA/dqWma96oMDuWOvlE8wrW3u0DUfhP0Qty
	 9TB587N0A5X2smAIL+QnvRkf9poiLqY4LPomg4jPHIt2KWH6x3VsC34Yqd7c6QZRga
	 Cl/LDgx5H+Yv3C1HGy/ntuAD2zqaBEMjU02gQivDZmAKbEBY8l9DHZEYW2Hopzmku+
	 eKU3yQPP5paW9bCFS1DIDUWD59dxxilB1ZTnEEUjhH5ZUNWQQtVpNUc/upqTddM3HU
	 rcAYIKMXq6AtLuHkiS8UhIyZ2/YBUG31J8cEy3MTw5ytTiHVQ0xbMTv4mvf6bCFb3+
	 81buwYecUdL0Q==
Date: Mon, 18 Mar 2024 14:41:59 -0700
Subject: [PATCHSET v13.0 2/2] xfs: fsck for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
In-Reply-To: <20240318213921.GJ6188@frogsfrogsfrogs>
References: <20240318213921.GJ6188@frogsfrogsfrogs>
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

This series implements online checking and repair for directory parent
pointer metadata.  The checking half is fairly straightforward -- for
each outgoing directory link (forward or backwards), grab the inode at
the other end, and confirm that there's a corresponding link.  If we
can't grab an inode or lock it, we'll save that link for a slower loop
that cycles all the locks, confirms the continued existence of the link,
and rechecks the link if it's actually still there.

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
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-fsck

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-fsck
---
Commits in this patchset:
 * xfs: check dirents have parent pointers
 * xfs: deferred scrub of dirents
 * xfs: create a parent pointer walk function for scrubbers
 * xfs: scrub parent pointers
 * xfs: deferred scrub of parent pointers
 * xfs: walk directory parent pointers to determine backref count
 * xfs: add raw parent pointer apis to support repair
 * xfs: set child file owner in xfs_da_args when changing parent pointers
 * xfs: check parent pointer xattrs when scrubbing
 * xfs: salvage parent pointers when rebuilding xattr structures
 * xfs: replace namebuf with parent pointer in directory repair
 * xfs: repair directories by scanning directory parent pointers
 * xfs: implement live updates for directory repairs
 * xfs: replay unlocked parent pointer updates that accrue during xattr repair
 * xfs: replace namebuf with parent pointer in parent pointer repair
 * xfs: repair directory parent pointers by scanning for dirents
 * xfs: implement live updates for parent pointer repairs
 * xfs: remove pointless unlocked assertion
 * xfs: split xfs_bmap_add_attrfork into two pieces
 * xfs: actually rebuild the parent pointer xattrs
 * xfs: adapt the orphanage code to handle parent pointers
 * xfs: repair link count of nondirectories after rebuilding parent pointers
 * xfs: inode repair should ensure there's an attr fork to store parent pointers
---
 fs/xfs/Makefile              |    2 
 fs/xfs/libxfs/xfs_attr.c     |   39 +
 fs/xfs/libxfs/xfs_attr.h     |    1 
 fs/xfs/libxfs/xfs_bmap.c     |   38 -
 fs/xfs/libxfs/xfs_bmap.h     |    3 
 fs/xfs/libxfs/xfs_dir2.c     |    2 
 fs/xfs/libxfs/xfs_dir2.h     |    2 
 fs/xfs/libxfs/xfs_parent.c   |  107 +++
 fs/xfs/libxfs/xfs_parent.h   |   18 +
 fs/xfs/scrub/attr.c          |   16 -
 fs/xfs/scrub/attr_repair.c   |  502 ++++++++++++++++
 fs/xfs/scrub/attr_repair.h   |    4 
 fs/xfs/scrub/common.h        |    1 
 fs/xfs/scrub/dir.c           |  352 +++++++++++
 fs/xfs/scrub/dir_repair.c    |  568 +++++++++++++++++-
 fs/xfs/scrub/findparent.c    |   12 
 fs/xfs/scrub/findparent.h    |   10 
 fs/xfs/scrub/inode_repair.c  |   41 +
 fs/xfs/scrub/listxattr.c     |   94 +++
 fs/xfs/scrub/listxattr.h     |   13 
 fs/xfs/scrub/nlinks.c        |   71 ++
 fs/xfs/scrub/nlinks.h        |    3 
 fs/xfs/scrub/nlinks_repair.c |    2 
 fs/xfs/scrub/orphanage.c     |   42 +
 fs/xfs/scrub/orphanage.h     |    3 
 fs/xfs/scrub/parent.c        |  695 ++++++++++++++++++++++
 fs/xfs/scrub/parent_repair.c | 1317 +++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/readdir.c       |   78 ++
 fs/xfs/scrub/readdir.h       |    3 
 fs/xfs/scrub/scrub.c         |    2 
 fs/xfs/scrub/trace.c         |    1 
 fs/xfs/scrub/trace.h         |  217 +++++++
 32 files changed, 4151 insertions(+), 108 deletions(-)

