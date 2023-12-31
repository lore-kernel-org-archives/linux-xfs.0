Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C21B645
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R1QZPz6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44184C433C8;
	Sun, 31 Dec 2023 19:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051238;
	bh=dRV7szHm5GbVV2otHysmZeE7x1/hdD59G1O+lkpQcaQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=R1QZPz6ELGSKpM9ivUL+aQoTUIm2x++0nUWchjBU4XsqQSSVoFqfW/1mkz0Jtndlb
	 gP9IXBGYj8JP9zOQrLibocBUOlwEPImaqxrKN1NJDHQcYSdLnyRBBgLepb9rwUfMWD
	 0yAmj8qMv+Nha3dbCejeNsbiBT5h7JgcKBQs0HAyAPi+NCFfKqaRVumPaTC648hNF0
	 BFvj0z+pQiTPXe1SGe2/VMKDBdn0i2cT5EwlAiLPT3EMFGZ8/lLsoOMdnVA3L4wNcW
	 K6ofcgtx/1ooWWxvPbWWSDCx3jD/ND1Sa40c0JFtZdhTOOFVRwQ2/HPc6uAWB6JCbb
	 DxzdaWQ4fzGUA==
Date: Sun, 31 Dec 2023 11:33:57 -0800
Subject: [PATCHSET v13.0 5/7] xfs: fsck for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404841699.1757392.2057683072581072853.stgit@frogsfrogsfrogs>
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
 fs/xfs/Makefile              |    2 
 fs/xfs/libxfs/xfs_attr.c     |   39 +
 fs/xfs/libxfs/xfs_attr.h     |    2 
 fs/xfs/libxfs/xfs_bmap.c     |   38 -
 fs/xfs/libxfs/xfs_bmap.h     |    3 
 fs/xfs/libxfs/xfs_dir2.c     |    2 
 fs/xfs/libxfs/xfs_dir2.h     |    2 
 fs/xfs/libxfs/xfs_parent.c   |  107 +++
 fs/xfs/libxfs/xfs_parent.h   |   18 +
 fs/xfs/scrub/attr.c          |    2 
 fs/xfs/scrub/attr_repair.c   |  502 ++++++++++++++++
 fs/xfs/scrub/attr_repair.h   |    4 
 fs/xfs/scrub/common.h        |    1 
 fs/xfs/scrub/dir.c           |  352 +++++++++++
 fs/xfs/scrub/dir_repair.c    |  567 +++++++++++++++++-
 fs/xfs/scrub/findparent.c    |   10 
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
 fs/xfs/scrub/parent_repair.c | 1316 +++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/readdir.c       |   57 ++
 fs/xfs/scrub/readdir.h       |    3 
 fs/xfs/scrub/scrub.c         |    2 
 fs/xfs/scrub/trace.c         |    1 
 fs/xfs/scrub/trace.h         |  217 +++++++
 32 files changed, 4113 insertions(+), 108 deletions(-)

