Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC771CA89
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504010; cv=none; b=MlF4hkN6TgGJX6yqWtHKV+FVNgqEHyQ8bbnzaLMDnuliu/s9ydPRWzJVdt8qQVja5ONCzWX65z3aIxrs1rZxnM2qvJvhhwZmFkDSut1KkZ9sT1ZUpKvrBm3BMP7L4a5Ivqd9vODWd2d1QCpOTdrMYShK9pRHhVNErUzQ/CV3BiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504010; c=relaxed/simple;
	bh=mDcJO+A8XvmfHARYxayx3sYhkqDA7kD0dij/v6eR25M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BSz1uoFWcVOx7p7wfq5sDDIQnBcE85pTPQFRjV+DUWpsMeBSI5DeqIz3e46cliv5Ss6LnSgmzGlHIU2phoLbRLw0u87ii55Ou5pB38ijXYAiWcC4NjsKDQOfZ2B9JZrF86riO0WMWENbhohpJffirQKjZ1aS8vvtr0ln3dR+5YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dt9LgG1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dt9LgG1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42854C433F1;
	Wed, 27 Mar 2024 01:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504010;
	bh=mDcJO+A8XvmfHARYxayx3sYhkqDA7kD0dij/v6eR25M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Dt9LgG1U+ezDCAPizuGVUf+K1EFfyvcbzMQ5ppw+KqCosLqk8686DgjwpK7RJpW4d
	 jCPnRSM6qJZT4m//ZObnnn5RAJ6gB4y4rHnYVMXXEtQYPrs5YJHJtAekY/5uGtD1W7
	 fdjlb3u9TmR+/GLzHP6b+VCvmRvlJ0OiNyMqOWN66T9pNaIcXNzjxfJoRcVAzEmMR+
	 tZfzD2eDdm2H832AHPeWO6vwbSrhkkJonZhOnpaFRKSvRg3UDuUlX/iGJ5k0btKHnX
	 UmsybC+U3B8qKWvBXwf5/cWlhRkTn1mbjXnUsrLXo/HbTDEYEAowguxKqPuO29dHo7
	 iF4oMeam+EzkA==
Date: Tue, 26 Mar 2024 18:46:49 -0700
Subject: [PATCHSET v30.1 02/15] xfs: improve log incompat feature handling
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150379721.3216346.4387266050277204544.stgit@frogsfrogsfrogs>
In-Reply-To: <20240327014040.GU6390@frogsfrogsfrogs>
References: <20240327014040.GU6390@frogsfrogsfrogs>
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

This patchset improves the performance of log incompat feature bit
handling by making a few changes to how the filesystem handles them.
First, we now only clear the bits during a clean unmount to reduce calls
to the (expensive) upgrade function to once per bit per mount.  Second,
we now only allow incompat feature upgrades for sysadmins or if the
sysadmin explicitly allows it via mount option.  Currently the only log
incompat user is logged xattrs, which requires CONFIG_XFS_DEBUG=y, so
there should be no user visible impact to this change.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=log-incompat-permissions
---
Commits in this patchset:
 * xfs: only clear log incompat flags at clean unmount
 * xfs: only add log incompat features with explicit permission
---
 Documentation/admin-guide/xfs.rst                  |    7 +++
 .../filesystems/xfs/xfs-online-fsck-design.rst     |    3 -
 fs/xfs/xfs_log.c                                   |   28 -------------
 fs/xfs/xfs_log.h                                   |    2 -
 fs/xfs/xfs_log_priv.h                              |    3 -
 fs/xfs/xfs_log_recover.c                           |   15 -------
 fs/xfs/xfs_mount.c                                 |   34 ++++++++++++++++
 fs/xfs/xfs_mount.h                                 |    9 ++++
 fs/xfs/xfs_super.c                                 |   12 +++++-
 fs/xfs/xfs_xattr.c                                 |   42 +++-----------------
 10 files changed, 66 insertions(+), 89 deletions(-)

