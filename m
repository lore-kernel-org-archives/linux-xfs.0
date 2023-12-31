Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2C9B667
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ygw5IDSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13866C433C8;
	Sun, 31 Dec 2023 19:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052317;
	bh=RVLdrAlhUmpBnH6jOwFwUAH0giLDiosHKclzLFlpDiA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ygw5IDSbwjwsg2KivWUPLxsPZfInCSLcnVczklFyILxdxEga2t7qq4CRCyO3DuWqY
	 lgFOn/Br6Vbo9mXSKTVKjltULrVucDbcpYFmOJJZvdWJYSf9Tmmf1z7ZC+UKQQKeXW
	 vrx9oYXHfGyL8Z3yR66PIPoJAcSgmVtiLMx+0pUnZLigCqOX9i+Ikw1yCJpYQcdv3T
	 l4mUcQA+UQmzbnKpO21Dz7ddJrll/X0UWO6dsG1Gj3HDG5PzmLuy21El42cVnZZRRB
	 b3WnLGwAUR+//kQQXQAfLdsrxyLIr5efD4cWHE8rbQH/QnRYLofbU/lao8/koSI2Me
	 gWj/36qEGjLzA==
Date: Sun, 31 Dec 2023 11:51:56 -0800
Subject: [PATCHSET v2.0 01/17] xfsprogs: hoist inode operations to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182323.GU361584@frogsfrogsfrogs>
References: <20231231182323.GU361584@frogsfrogsfrogs>
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

Add libxfs code from the kernel from the inode refactoring, then fix up
xfs_repair and mkfs to use library functions instead of open-coding
inode (re)creation.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inode-refactor

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=inode-refactor
---
 configure.ac             |    1 
 db/iunlink.c             |  128 +-------
 db/namei.c               |   23 -
 include/builddefs.in     |    1 
 include/libxfs.h         |    1 
 include/xfs_inode.h      |   82 ++++-
 include/xfs_mount.h      |    1 
 include/xfs_trace.h      |    7 
 libxfs/Makefile          |    8 +
 libxfs/inode.c           |  280 ++++++++++++++++++
 libxfs/iunlink.c         |  163 ++++++++++
 libxfs/iunlink.h         |   24 ++
 libxfs/libxfs_api_defs.h |    9 +
 libxfs/libxfs_priv.h     |   52 +++
 libxfs/rdwr.c            |   95 ------
 libxfs/util.c            |  333 +--------------------
 libxfs/xfs_bmap.c        |   42 +++
 libxfs/xfs_bmap.h        |    3 
 libxfs/xfs_dir2.c        |  637 +++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_dir2.h        |   48 +++
 libxfs/xfs_ialloc.c      |   15 +
 libxfs/xfs_inode_util.c  |  720 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_util.h  |   71 +++++
 libxfs/xfs_shared.h      |    7 
 libxfs/xfs_trans_inode.c |    2 
 m4/package_libcdev.m4    |   15 +
 mkfs/proto.c             |  100 +++++-
 repair/phase6.c          |  224 ++++----------
 28 files changed, 2347 insertions(+), 745 deletions(-)
 create mode 100644 libxfs/inode.c
 create mode 100644 libxfs/iunlink.c
 create mode 100644 libxfs/iunlink.h
 create mode 100644 libxfs/xfs_inode_util.c
 create mode 100644 libxfs/xfs_inode_util.h

