Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF50B64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T3yfJNgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E098DC433C7;
	Sun, 31 Dec 2023 19:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704050783;
	bh=58S+guDpzdk92wNDSEedweyZeaG9YiMrbvY6oQY3gZk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=T3yfJNgQrZ4Y+FHabiOS08vWgu6Tzxou+DMgKwX11YN/c9pcIsl8AjVsszGWoYmtH
	 LZ/0Cg5bRMC4ZUWiFxI6hDrNC7/dqap3HGcY6TflBpapXaA4qB8e9R1wUx5qjoyBnD
	 JYieBlC1KdpvnoLmu+or5d0+ubhHRaH7v2PVS/9boCA2ZWouC5m21pd3ayiZOZTSlj
	 AyNipO2xaSVvg2RiuMBUOCJT42yXQb6bvI57Mr202sBZnrj24lH6r9kKbaBX1R7PRP
	 TbOjLUOykPjcTWjpyc+7fYjSk6XXb2NavLUIKuCVn/EJ+2Tcd8hkfLyZCBRmqh7sUY
	 GeIIqxk4HCjrw==
Date: Sun, 31 Dec 2023 11:26:23 -0800
Subject: [PATCHSET v29.0 04/28] xfs: online repair of file link counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404827820.1748178.11128292961813747066.stgit@frogsfrogsfrogs>
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

Now that we've created the infrastructure to perform live scans of every
file in the filesystem and the necessary hook infrastructure to observe
live updates, use it to scan directories to compute the correct link
counts for files in the filesystem, and reset those link counts.

This patchset creates a tailored readdir implementation for scrub
because the regular version has to cycle ILOCKs to copy information to
userspace.  We can't cycle the ILOCK during the nlink scan and we don't
need all the other VFS support code (maintaining a readdir cursor and
translating XFS structures to VFS structures and back) so it was easier
to duplicate the code.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-nlinks

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-nlinks

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-nlinks
---
 fs/xfs/Makefile              |    2 
 fs/xfs/libxfs/xfs_fs.h       |    4 
 fs/xfs/libxfs/xfs_health.h   |    4 
 fs/xfs/scrub/common.c        |    3 
 fs/xfs/scrub/common.h        |    1 
 fs/xfs/scrub/health.c        |    1 
 fs/xfs/scrub/nlinks.c        |  930 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/nlinks.h        |  102 +++++
 fs/xfs/scrub/nlinks_repair.c |  223 ++++++++++
 fs/xfs/scrub/repair.h        |    2 
 fs/xfs/scrub/scrub.c         |    9 
 fs/xfs/scrub/scrub.h         |    5 
 fs/xfs/scrub/stats.c         |    1 
 fs/xfs/scrub/trace.c         |    2 
 fs/xfs/scrub/trace.h         |  183 ++++++++
 fs/xfs/xfs_health.c          |    1 
 fs/xfs/xfs_inode.c           |  108 +++++
 fs/xfs/xfs_inode.h           |   31 +
 fs/xfs/xfs_mount.h           |    3 
 fs/xfs/xfs_super.c           |    2 
 fs/xfs/xfs_symlink.c         |    1 
 21 files changed, 1614 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/scrub/nlinks.c
 create mode 100644 fs/xfs/scrub/nlinks.h
 create mode 100644 fs/xfs/scrub/nlinks_repair.c

