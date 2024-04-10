Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0009C37C
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712709911; cv=none; b=ljzI4r4UAI3yqDYQNeFKqD/1vpbPTWefsXqoNd/R0qxQKHCYNN7sGB0d/PITH7QDj/azyqm+dhjSOf41en1lEsMaNCjMB1GSpNEB5pYATrKvNTBRIwRnr06iN3ZOp04msszHd0I9vtWJzDRKNi3gRABrpDWQ/7q6tQuvUYvkTOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712709911; c=relaxed/simple;
	bh=Vbfzdrb6ven3KQKsgrkxior/IsKJfcco6y5B+fQCzpo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hdl/9lk5cyeFl/M27rYaxC3Efb0UO34nxYormS1GlziE2xNwNX00iGboZN2dMNHahfDY/CvEY1KItfDiVrzgPjXvJZ7QZEBXs7c4q71wsYE7UaxCj9scudvoOBu9alesbheVjQT5Z+dPU+0RtupTVnM9a9evUNC7lzeSbvM8vOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WNqAgety; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WNqAgety"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EE7C433F1;
	Wed, 10 Apr 2024 00:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712709910;
	bh=Vbfzdrb6ven3KQKsgrkxior/IsKJfcco6y5B+fQCzpo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WNqAgetylTRznynGCThS7xocoPMjTmGEKDYeX7dW4ggBZmu7UiG2N0FX508UowGRU
	 Bv7Uir2Ejuf4YPts7AFIRg+6hq/jZ3d9+F8YdXFCE+K2gZgmhkX1UpYawC6HZRsNAo
	 xBXrUl7zAqU4ets+3k3tUPFLxJzWkGapA1UoarbIMMo3JXh6dG0SQpTJcxjGy1YMpE
	 FSmCESvqqMxf+P9bDPHQOa0+thNA1CnpBVYurMs8lOZU1bKpDD6D2o6ZEi1i8bkmAM
	 xsxMX1rBSNzV/wpPc8C0GbpQrk479O9WG1JJbG6e4d+SaH7kxDKvSK9UFvvnhBPnvY
	 LUNSiTZ4WuyBA==
Date: Tue, 09 Apr 2024 17:45:10 -0700
Subject: [PATCHSET v13.1 4/9] xfs: improve extended attribute validation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
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

Prior to introducing parent pointer extended attributes, let's spend
some time cleaning up the attr code and strengthening the validation
that it performs on attrs coming in from the disk.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=improve-attr-validation

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=improve-attr-validation
---
Commits in this patchset:
 * xfs: attr fork iext must be loaded before calling xfs_attr_is_leaf
 * xfs: require XFS_SB_FEAT_INCOMPAT_LOG_XATTRS for attr log intent item recovery
 * xfs: use an XFS_OPSTATE_ flag for detecting if logged xattrs are available
 * xfs: check opcode and iovec count match in xlog_recover_attri_commit_pass2
 * xfs: fix missing check for invalid attr flags
 * xfs: restructure xfs_attr_complete_op a bit
 * xfs: use helpers to extract xattr op from opflags
 * xfs: validate recovered name buffers when recovering xattr items
 * xfs: always set args->value in xfs_attri_item_recover
 * xfs: use local variables for name and value length in _attri_commit_pass2
 * xfs: refactor name/length checks in xfs_attri_validate
 * xfs: enforce one namespace per attribute
---
 fs/xfs/libxfs/xfs_attr.c      |   41 ++++++++-
 fs/xfs/libxfs/xfs_attr.h      |    9 ++
 fs/xfs/libxfs/xfs_attr_leaf.c |    7 +
 fs/xfs/libxfs/xfs_da_format.h |    5 +
 fs/xfs/scrub/attr.c           |   25 +++--
 fs/xfs/scrub/attr_repair.c    |    4 -
 fs/xfs/xfs_attr_item.c        |  192 ++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_attr_list.c        |   18 +++-
 fs/xfs/xfs_mount.c            |   16 +++
 fs/xfs/xfs_mount.h            |    6 +
 fs/xfs/xfs_xattr.c            |    3 -
 11 files changed, 258 insertions(+), 68 deletions(-)

