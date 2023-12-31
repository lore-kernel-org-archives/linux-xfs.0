Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641DCB64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qRiwiVSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A44C433C8;
	Sun, 31 Dec 2023 19:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052270;
	bh=H6WwjLRFj8FJRnXnGzQ97g/+DPyuVBPamCqiANxDFh4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qRiwiVSgUTaNDq6YKe2+qsLWHdUD52/k6yjrVsAmj24L9f27SqpO67KAa6FcXPSSq
	 U9vbkplLjx+KAURK80jqHyJgtf0cHGFL79VO1USyPBrDzmFEY9K2JUpYbF49e5H5uH
	 rXhM79+vMFdau0VaycLKfAoYuU1P9aw6EXw3c0J+XYepyuPqNDvnhBltmmt/yWqGWY
	 vxoF17hb0oUzylr49rxkgThrUIzZKxhh8rxGNOR0ZgdXnh1QW2rZIxVLzThU/tYPAD
	 UtL/EksXwpdl0GDpMjO2jRBGo40F10TraNqs5hR2AWVBcyPq/lLTA7Rt6mlOo4+7qr
	 KMRIZ31KYGDqw==
Date: Sun, 31 Dec 2023 11:51:09 -0800
Subject: [PATCHSET v13.0 4/6] xfsprogs: fsck for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
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

The last patch teaches xfs_scrub to report pathnames of files that are
being repaired, when possible.

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
 libxfs/Makefile                     |    2 
 libxfs/libxfs_api_defs.h            |    4 
 libxfs/xfblob.c                     |  156 ++++
 libxfs/xfblob.h                     |   26 +
 libxfs/xfile.c                      |   11 
 libxfs/xfile.h                      |    1 
 libxfs/xfs_attr.c                   |   39 +
 libxfs/xfs_attr.h                   |    2 
 libxfs/xfs_bmap.c                   |   38 -
 libxfs/xfs_bmap.h                   |    3 
 libxfs/xfs_dir2.c                   |    2 
 libxfs/xfs_dir2.h                   |    2 
 libxfs/xfs_parent.c                 |  107 +++
 libxfs/xfs_parent.h                 |   18 
 man/man2/ioctl_xfs_scrub_metadata.2 |   20 -
 man/man8/xfs_admin.8                |    8 
 repair/Makefile                     |    6 
 repair/globals.c                    |    1 
 repair/globals.h                    |    1 
 repair/listxattr.c                  |  271 +++++++
 repair/listxattr.h                  |   15 
 repair/phase2.c                     |   39 +
 repair/phase6.c                     |  118 +++
 repair/pptr.c                       | 1303 +++++++++++++++++++++++++++++++++++
 repair/pptr.h                       |   17 
 repair/strblobs.c                   |  211 ++++++
 repair/strblobs.h                   |   24 +
 repair/xfs_repair.c                 |   11 
 scrub/phase6.c                      |   75 ++
 29 files changed, 2481 insertions(+), 50 deletions(-)
 create mode 100644 libxfs/xfblob.c
 create mode 100644 libxfs/xfblob.h
 create mode 100644 repair/listxattr.c
 create mode 100644 repair/listxattr.h
 create mode 100644 repair/pptr.c
 create mode 100644 repair/pptr.h
 create mode 100644 repair/strblobs.c
 create mode 100644 repair/strblobs.h

