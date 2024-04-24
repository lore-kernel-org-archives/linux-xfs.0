Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFEE85C59
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713927949; cv=none; b=e23LPyiX1oggfoydiPts4bKwIoFJqtw6cOYibGULvQidjaYbF6+ouO0Y1dMZpyFZ3lCfHXCdADr4HsIVFnqNcp50HrEVPO43ZJYcci82HUxlsm2f7Nrs9GnGdiwGX9RBAbD5GEZE81TEXgebaCnv8P5CdLo6XytA6CU9F8HekTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713927949; c=relaxed/simple;
	bh=2yc+FDO6AZmGx3007cXJWcGYJ7KgdjI01Hl4RnyfIQw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KPYyXYZ7sV9nR9dbi2crOugGNi2yEcqOycx6G8rNCqqBrz6cUB3uq+QR8uWlMfaFM3Bm3fKvUNAgytYamg8uQa5eOiKaCfz5S7j0peno58IrJw0Bq6p3r7/TeEgkoc36IG41L/yAgkUOcQaZRp4/64fRjsAzi78lJli7DIRJ36c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Izyeq6Uk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Izyeq6Uk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF09C116B1;
	Wed, 24 Apr 2024 03:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713927948;
	bh=2yc+FDO6AZmGx3007cXJWcGYJ7KgdjI01Hl4RnyfIQw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Izyeq6UkNDWeDis5XyoOejPa1NQdHD++UdcLhIZNU7zkKlBmX/HKkbk6Opc67SWk1
	 81mIXypGGBqdIKc5Bgju4e5qS6Ogu3ILyqbn+D6PKznowI1hW69CbKz8/KuHrXtyXn
	 fDueIAKW+nlDM9E5oMPR+fHVEOMf83oGQqQ2QfMokaHq70Fzvte4/IcCO/7z/DBy+Y
	 H+wFjfldEY/fu+UTFEjgJVrowtT+iniz8G1sGZxlbjPKna3gVJeVTJ58ewENo/T4sq
	 b5M215+PlaSFbHuGpvWb1LeZgnycA2m97qFY0UssPpshz+DKF/Jo6D6p/+H+SM+foR
	 ApH5uY2cAGf3Q==
Date: Tue, 23 Apr 2024 20:05:47 -0700
Subject: [PATCHSET v13.4 2/9] xfs: improve extended attribute validation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392782539.1904599.4346314665349138617.stgit@frogsfrogsfrogs>
In-Reply-To: <20240424030246.GB360919@frogsfrogsfrogs>
References: <20240424030246.GB360919@frogsfrogsfrogs>
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
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=improve-attr-validation-6.10
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

