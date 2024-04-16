Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186065223
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230388; cv=none; b=f1ob3LnGwFx9B1Wasx5i2kLkfGQcrzUxas1zsIqYmKBytE5Mj9bl4fGwwWm7CnW2ngmVDvVzRbvOJiW8rYycW3fUXsvoBccwzM1WhAf8GNwN1YJDpEmn4ENXjM0vO5VjVuMXJnZzFRtrmPWQeUxcQ4MrTqYHPQGnx3Wu3IN5XaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230388; c=relaxed/simple;
	bh=daXkJOYeG9P7a3OZ57jCBXi2pdugLpOGGz4/vMl4o2U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PmvZB8Er8RHKfKNdIHOz9E5lxN0Wvf6aP+qNq7CWkdPsIPYbjhbnXzniT4jd8URaBoGCnrkQOAdq957BaUJHrTJqdtJr9YEIuGvTYPczlkKIcBYTIx+VFqjfohdAUSsdI3LS7evICUvIdhEbx6s43xbZxEJ9obLjUQZ3g3Wriq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U7T7Lprp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U7T7Lprp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A11C113CC;
	Tue, 16 Apr 2024 01:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230387;
	bh=daXkJOYeG9P7a3OZ57jCBXi2pdugLpOGGz4/vMl4o2U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U7T7LprpU6y1SDKHiEApwojPR5igXdtyPKd1qEnbfLgpsNGm5wcB9jaHNyuONqDzR
	 poqtRQRzF2YwSK2ud4ULapLcEjlbsbvmXBnFM8olUXiAvRxiB15fSXXw2Im4oh69Kd
	 yGvjjDKMg6n29rC6UKyyUBjpt3ZV3jV0ZBDAXZtIEbNWtRTYPSs308NYqXw6NNdO+K
	 tFX2JQXuXYOSua6YeyZfjU/6O4Avo9UPx6v00vBiWUUOWEZLCFXGdMW90sekKb4CcS
	 JLGkFbPkzgmpbeBcqOkj5ViF9AdeEYOyxqsLCxPC6u15ktVBmcMxp87ufMbA0llm++
	 C6bzRusB6WNSg==
Date: Mon, 15 Apr 2024 18:19:47 -0700
Subject: [PATCHSET v13.2 2/7] xfs: improve extended attribute validation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de,
 hch@infradead.org
Message-ID: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
In-Reply-To: <20240416011640.GG11948@frogsfrogsfrogs>
References: <20240416011640.GG11948@frogsfrogsfrogs>
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
 * xfs: check shortform attr entry flags specifically
 * xfs: restructure xfs_attr_complete_op a bit
 * xfs: use helpers to extract xattr op from opflags
 * xfs: validate recovered name buffers when recovering xattr items
 * xfs: always set args->value in xfs_attri_item_recover
 * xfs: use local variables for name and value length in _attri_commit_pass2
 * xfs: refactor name/length checks in xfs_attri_validate
 * xfs: refactor name/value iovec validation in xlog_recover_attri_commit_pass2
 * xfs: enforce one namespace per attribute
---
 fs/xfs/libxfs/xfs_attr.c      |   37 +++++-
 fs/xfs/libxfs/xfs_attr.h      |    9 +-
 fs/xfs/libxfs/xfs_attr_leaf.c |    7 +
 fs/xfs/libxfs/xfs_da_format.h |    5 +
 fs/xfs/scrub/attr.c           |   34 ++++--
 fs/xfs/scrub/attr_repair.c    |    4 -
 fs/xfs/xfs_attr_item.c        |  242 +++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_attr_list.c        |   18 ++-
 fs/xfs/xfs_mount.c            |   16 +++
 fs/xfs/xfs_mount.h            |    6 +
 fs/xfs/xfs_xattr.c            |    3 -
 11 files changed, 304 insertions(+), 77 deletions(-)

