Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B921EB645
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QLp85t6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34201C433C7;
	Sun, 31 Dec 2023 19:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051019;
	bh=fmcM78EXKtfFDwhM7pbLh8UHYeA8wDBEklRm622/jGs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QLp85t6sPloKv5V3LYmDbZ9L2BCGrzUclMOX9sjM5BNS3Qzeu3i3nLDAUB6EJSgUn
	 WjpfD+s/x+3H0z9YmNm+qalNAC1mwPPNJVFdXRTgVpSZHqmrdLRF2cDbztettPEIE0
	 TFHwUGkmi1msshM+prVDwcakex2xZ7RqftG50ZA8+4ByftsDln4Gnw9/7x0WD8/0YU
	 smhgvt9KUphL2VfVyUo1DjHkP4roLuiDFvCVwP2Cr8y+ZbO4JTjfP84AuiVBWnDv+g
	 DLL4u+y7Th6VrNDTx6kljBSh2vjSF4TJ/GoG0202kuF0xlhq2V01irFy44AbOzcj8a
	 aoOA0TeCpYz7A==
Date: Sun, 31 Dec 2023 11:30:18 -0800
Subject: [PATCHSET v29.0 19/28] xfs: set and validate dir/attr block owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404834676.1753044.18168629400918360020.stgit@frogsfrogsfrogs>
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

There are a couple of significant changes that need to be made to the
directory and xattr code before we can support online repairs of those
data structures.

The first change is because online repair is designed to use libxfs to
create a replacement dir/xattr structure in a temporary file, and use
atomic extent swapping to commit the corrected structure.  To avoid the
performance hit of walking every block of the new structure to rewrite
the owner number before the swap, we instead change libxfs to allow
callers of the dir and xattr code the ability to set an explicit owner
number to be written into the header fields of any new blocks that are
created.  For regular operation this will be the directory inode number.

The second change is to update the dir/xattr code to actually *check*
the owner number in each block that is read off the disk, since we don't
currently do that.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=dirattr-validate-owners

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=dirattr-validate-owners
---
 fs/xfs/libxfs/xfs_attr.c        |   10 +-
 fs/xfs/libxfs/xfs_attr_leaf.c   |   59 +++++++++++---
 fs/xfs/libxfs/xfs_attr_leaf.h   |    4 +
 fs/xfs/libxfs/xfs_attr_remote.c |   13 +--
 fs/xfs/libxfs/xfs_bmap.c        |    1 
 fs/xfs/libxfs/xfs_da_btree.c    |  168 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_da_btree.h    |    3 +
 fs/xfs/libxfs/xfs_dir2.c        |    5 +
 fs/xfs/libxfs/xfs_dir2.h        |    4 +
 fs/xfs/libxfs/xfs_dir2_block.c  |   44 ++++++----
 fs/xfs/libxfs/xfs_dir2_data.c   |   17 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c   |   99 ++++++++++++++++++-----
 fs/xfs/libxfs/xfs_dir2_node.c   |   44 ++++++----
 fs/xfs/libxfs/xfs_dir2_priv.h   |   11 +--
 fs/xfs/libxfs/xfs_swapext.c     |    7 +-
 fs/xfs/scrub/attr.c             |    1 
 fs/xfs/scrub/dabtree.c          |    8 ++
 fs/xfs/scrub/dir.c              |   23 +++--
 fs/xfs/scrub/readdir.c          |    6 +
 fs/xfs/xfs_acl.c                |    2 
 fs/xfs/xfs_attr_item.c          |    1 
 fs/xfs/xfs_attr_list.c          |   35 +++++++-
 fs/xfs/xfs_dir2_readdir.c       |    6 +
 fs/xfs/xfs_ioctl.c              |    2 
 fs/xfs/xfs_iops.c               |    1 
 fs/xfs/xfs_trace.h              |    7 +-
 fs/xfs/xfs_xattr.c              |    2 
 27 files changed, 464 insertions(+), 119 deletions(-)

