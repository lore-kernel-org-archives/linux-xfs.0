Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330F32EAB98
	for <linux-xfs@vger.kernel.org>; Wed,  3 Sep 2025 14:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756911588; cv=none; b=QSGtiEJ69y5Fz1HhWCdr7+lAXwlKdKqvc8AQfvZAfwu2umAVqChXozrp+DWDsuezSSKmdoWGtkHNUOQv6YQ/tnTgY/bZ2bqzG4t4fVpFdn9kEvZLnmFpbtmVvdYOizWKkQyK1G9GlS7ca2d+ifJBQamjRNstqT/WAWvgKAOxVic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756911588; c=relaxed/simple;
	bh=ZjISSDlAMNIqlSnoEnXhlmighWAqj3yjFxO6J9F79XY=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=aj6NNibiCoAG5kuJiXNHDQcae58FIDEDyYuh3/KDn88LWlIOgDE4wCDxZPBnEwkRw0b9pR8qQ/X1Letqc5W9yV2prf3wpb8trB2BtVCaB4cPjqjSdqarhd7EtowmAzOp463th2CW1RSCWU34xaz4LmChwXTXfUTcmqSLMzTAflo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mvhns9lG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mvhns9lG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEC5C4CEE7;
	Wed,  3 Sep 2025 14:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756911587;
	bh=ZjISSDlAMNIqlSnoEnXhlmighWAqj3yjFxO6J9F79XY=;
	h=Date:Subject:From:To:Cc:From;
	b=mvhns9lG1CicuC2vNYer1mt4rL3Co12RMhJBYpDGyj0vkYnL+wMLrMq/aEmLmnhpo
	 giiNtsdjAlUYdsGoxCBnd93hZvzz6/yiCC9XiQkKXXB1xE+HFMGrzil97Ho85AKbiL
	 iR5s/GJOGP0SYFHqHaUay095u9kRaKfrFgvPVUL915vepj1S0pp7KM1SWiVGcEK6i7
	 HiH6fM0FLzkLK/kP/JR2v0Z+QC1esdenPyUHMXOgf1Et5+qd0LHJBa8YfAU5Q/hQtm
	 w/ntkbESkkkvl6tu3w9GsXj+upO5q67kBRy7z6q4hqFRFk0Ov2jlPDy2Lkz+rQpZTO
	 Cl8vcI93pPz2Q==
Date: Wed, 03 Sep 2025 07:59:47 -0700
Subject: [PATCHSET] xfs: kconfig and feature changes for 2025 LTS
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: preichl@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <175691147603.1206750.9285060179974032092.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Ahead of the 2025 LTS kernel, disable by default the two features that
we promised to turn off in September 2025: V4 filesystems, and the
long-broken ASCII case insensitive directories.

Since online fsck has not had any major issues in the 16 months since it
was merged upstream, let's also turn that on by default.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=kconfig-2025-changes
---
Commits in this patchset:
 * xfs: disable deprecated features by default in Kconfig
 * xfs: remove deprecated mount options
 * xfs: remove deprecated sysctl knobs
 * xfs: enable online fsck by default in Kconfig
---
 fs/xfs/xfs_linux.h                |    2 -
 fs/xfs/xfs_mount.h                |   12 ++++---
 fs/xfs/xfs_sysctl.h               |    3 --
 Documentation/admin-guide/xfs.rst |   57 +++++------------------------------
 fs/xfs/Kconfig                    |   16 ++++------
 fs/xfs/libxfs/xfs_attr_leaf.c     |   23 +++-----------
 fs/xfs/libxfs/xfs_bmap.c          |   14 ++-------
 fs/xfs/libxfs/xfs_ialloc.c        |    4 +-
 fs/xfs/libxfs/xfs_inode_util.c    |   11 -------
 fs/xfs/libxfs/xfs_sb.c            |    9 ++----
 fs/xfs/xfs_globals.c              |    2 -
 fs/xfs/xfs_icache.c               |    6 +---
 fs/xfs/xfs_iops.c                 |   12 +++----
 fs/xfs/xfs_mount.c                |   13 --------
 fs/xfs/xfs_super.c                |   60 +------------------------------------
 fs/xfs/xfs_sysctl.c               |   29 +-----------------
 16 files changed, 43 insertions(+), 230 deletions(-)

