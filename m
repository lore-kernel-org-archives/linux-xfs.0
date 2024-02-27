Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0CA1170F
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000298; cv=none; b=KtsBA9TvhSq1/gfKN5a52OqfDw2ZTmGAXCIrooTKFug1IgiEuTvdEZhBmgTSpI65fnMHSsQXbMoMJ60JWP6d2MYpi6kao++QswVRZ/FPqPw7xKnoeusxQppX/vAcveuWfYD8KlzJ4N3VoT6wuLpTXAdOLNP29gz/FECpdro6aaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000298; c=relaxed/simple;
	bh=n9Up9xRQBCvfD98seNvf+SArfQWPYCWO0e8UhBMmtaM=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=L7QGqn45d+ak4P+R855gnSc1Ey1bL275FtEwtTANMmfqzaWkoByOR4P0XJjKoHNR6e/LQu1N2HpBK19Z3NL85gxNLaqeaSKdSEsx7upbDrN5v1LwUolRRPevuYi5qzdLH+uGxKhNLChZoAjtWTA7ikMqh5GzXLdLe3PZx/LfH+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YWhreFZt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YWhreFZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE68C43390;
	Tue, 27 Feb 2024 02:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000297;
	bh=n9Up9xRQBCvfD98seNvf+SArfQWPYCWO0e8UhBMmtaM=;
	h=Date:Subject:From:To:Cc:From;
	b=YWhreFZtgctuuNzghD/izAN4TwM453hfO+D4wM9c65JS9RjAtfbuDHaolWfubjtgx
	 eXaT6LnMO1KY+T51T2PcmY6BmPYJ/Nin1A4P/R9GaeDXwgHFeHCImg5q/svAs4rNea
	 38bbBfbY+8mRwVpE5bMHWRFQZPgYniOltRw2DKPDpTCrWvcf6al7vsqgX4biUXw1TN
	 qIydHsikyFRTC17tgL8gVWffZ9SH95R0d2WbuO3GCxtO8zVS5S6/1n+cTbeGilvq1i
	 +fHh12qFQ+EeTCq3rnFnFNyD3283E3bD1Y4CMFOBm78uFdoo2lvQtTB03l/+WvOTzp
	 yZtPQEUL7xxsA==
Date: Mon, 26 Feb 2024 18:18:17 -0800
Subject: [PATCHSET v29.4 06/13] xfs: set and validate dir/attr block owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900013068.938940.1740993823820687963.stgit@frogsfrogsfrogs>
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
Commits in this patchset:
 * xfs: add an explicit owner field to xfs_da_args
 * xfs: use the xfs_da_args owner field to set new dir/attr block owner
 * xfs: validate attr leaf buffer owners
 * xfs: validate attr remote value buffer owners
 * xfs: validate dabtree node buffer owners
 * xfs: validate directory leaf buffer owners
 * xfs: validate explicit directory data buffer owners
 * xfs: validate explicit directory block buffer owners
 * xfs: validate explicit directory free block owners
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
 fs/xfs/libxfs/xfs_exchmaps.c    |    7 +-
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

