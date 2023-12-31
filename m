Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACEBB65D
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q5ADvvP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94605C433C7;
	Sun, 31 Dec 2023 19:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704050799;
	bh=5sikE85t3jpyLhSL9UTV4HjmtZ9WjltuOlQlXAMeh9Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q5ADvvP/BrJo/OEiys3yBjyS9SNpzWzNW0BDCap/RZv+jsIqfn+IRvG9enlhBSDyu
	 TQM31BsTJd8L2NvsnHgM/xpSX8vzXoePAIb8NtGLdtr4PB+pjyW48CcA7e8Ngm9Y9s
	 YPAdUIkT2F/yKp50jqU2dzd+EBoD2A3H7jjD5T9cNfIxPsDFsFG1cNpMk8tfY9/dnK
	 aprKnTkPT+kATndq91kHAb5zyK+GQIe3UlG52IM2TknJei29OFPGMTiVjoE4b9L/xO
	 4QEp4CzVRz1SsHqKEMiu3LHhmZk0ZQXF+2NXlbr1HQaH784TdDVcZyQml2oYBqK8Yr
	 Vk1ShON328Czg==
Date: Sun, 31 Dec 2023 11:26:39 -0800
Subject: [PATCHSET v29.0 05/28] xfs: report corruption to the health trackers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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

Any time that the runtime code thinks it has found corrupt metadata, it
should tell the health tracking subsystem that the corresponding part of
the filesystem is sick.  These reports come primarily from two places --
code that is reading a buffer that fails validation, and higher level
pieces that observe a conflict involving multiple buffers.  This
patchset uses automated scanning to update all such callsites with a
mark_sick call.

Doing this enables the health system to record problem observed at
runtime, which (for now) can prompt the sysadmin to run xfs_scrub, and
(later) may enable more targetted fixing of the filesystem.

Note: Earlier reviewers of this patchset suggested that the verifier
functions themselves should be responsible for calling _mark_sick.  In a
higher level language this would be easily accomplished with lambda
functions and closures.  For the kernel, however, we'd have to create
the necessary closures by hand, pass them to the buf_read calls, and
then implement necessary state tracking to detach the xfs_buf from the
closure at the necessary time.  This is far too much work and complexity
and will not be pursued further.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=corruption-health-reports

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=corruption-health-reports

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=corruption-health-reports
---
 fs/xfs/libxfs/xfs_ag.c          |    5 +
 fs/xfs/libxfs/xfs_alloc.c       |  105 ++++++++++++++++++++----
 fs/xfs/libxfs/xfs_attr_leaf.c   |    4 +
 fs/xfs/libxfs/xfs_attr_remote.c |   35 +++++---
 fs/xfs/libxfs/xfs_bmap.c        |  135 +++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_btree.c       |   39 ++++++++-
 fs/xfs/libxfs/xfs_da_btree.c    |   37 +++++++-
 fs/xfs/libxfs/xfs_dir2.c        |    5 +
 fs/xfs/libxfs/xfs_dir2_block.c  |    2 
 fs/xfs/libxfs/xfs_dir2_data.c   |    3 +
 fs/xfs/libxfs/xfs_dir2_leaf.c   |    3 +
 fs/xfs/libxfs/xfs_dir2_node.c   |    7 ++
 fs/xfs/libxfs/xfs_health.h      |   35 +++++++-
 fs/xfs/libxfs/xfs_ialloc.c      |   57 +++++++++++--
 fs/xfs/libxfs/xfs_inode_buf.c   |   12 ++-
 fs/xfs/libxfs/xfs_inode_fork.c  |    8 ++
 fs/xfs/libxfs/xfs_refcount.c    |   43 +++++++++-
 fs/xfs/libxfs/xfs_rmap.c        |   83 ++++++++++++++++++-
 fs/xfs/libxfs/xfs_rtbitmap.c    |    9 ++
 fs/xfs/libxfs/xfs_sb.c          |    2 
 fs/xfs/scrub/health.c           |   20 +++--
 fs/xfs/scrub/refcount_repair.c  |    9 ++
 fs/xfs/xfs_attr_inactive.c      |    4 +
 fs/xfs/xfs_attr_list.c          |   18 +++-
 fs/xfs/xfs_dir2_readdir.c       |    6 +
 fs/xfs/xfs_discard.c            |    2 
 fs/xfs/xfs_dquot.c              |   30 +++++++
 fs/xfs/xfs_health.c             |  172 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.c             |    9 ++
 fs/xfs/xfs_inode.c              |   16 +++-
 fs/xfs/xfs_iomap.c              |   15 +++
 fs/xfs/xfs_iwalk.c              |    5 +
 fs/xfs/xfs_mount.c              |    5 +
 fs/xfs/xfs_qm.c                 |    8 +-
 fs/xfs/xfs_reflink.c            |    6 +
 fs/xfs/xfs_rtalloc.c            |    6 +
 fs/xfs/xfs_symlink.c            |   17 +++-
 37 files changed, 867 insertions(+), 110 deletions(-)

