Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84367B64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZOAoeNkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4AAAC433C8;
	Sun, 31 Dec 2023 19:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051503;
	bh=fywUoerXQHOEJGH54SW8xQyyfES0eH2Sw61MpZtGDg4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZOAoeNkM3wjC/nIIQ8fWeGsHcuxUuEyiSCyxv7eaA22HmI6easJdEV8/hlm2Dihpi
	 iMIjpGlFCrZCDiobtCZTrxLgWUayCjq5DB6N4pCb2XPLgSad5HDRguTyZvYEob5U/1
	 IMaTd0fX6Cb0EMKZhlk+xSqnkGgSiiUYzxv+aBY5MBztEhsDIrvUTKyycvqhFXTUsN
	 4FQG0OYjAbxqlUU387LGyQqEuK0gZG4VXMSV6iNtFrnFeCOAJxYdcsYELD8NlRf7CZ
	 5RgMuMCYvNYshaOsP1E/OtsDAO+wGK9qNqagCTtnOEgCvxsSeJvmoe364B7+uiSknV
	 5rhLpZjCMCBdw==
Date: Sun, 31 Dec 2023 11:38:23 -0800
Subject: [PATCHSET v2.0 15/15] xfs: enable quota for realtime voluems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404853163.1767666.1660746530012636507.stgit@frogsfrogsfrogs>
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

At some point, I realized that I've refactored enough of the quota code
in XFS that I should evaluate whether or not quota actually works on
realtime volumes.  It turns out that with two exceptions, it actually
does seem to work properly!  There are three broken pieces that I've
found so far: chown doesn't work, the quota accounting goes wrong when
the rt bitmap changes size, and the VFS quota ioctls don't report the
realtime warning counts or limits.  Hence this series fixes two things
in XFS and re-enables rt quota after a break of a couple decades.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-quotas

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-quotas

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-quotas
---
 fs/xfs/xfs_mount.c   |    4 ++-
 fs/xfs/xfs_qm.c      |   76 +++++++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_qm_bhv.c  |   20 +++++++++----
 fs/xfs/xfs_quota.h   |    4 +--
 fs/xfs/xfs_rtalloc.c |   46 ++++++++++++++++++++----------
 fs/xfs/xfs_rtalloc.h |    3 ++
 fs/xfs/xfs_stats.c   |   12 ++++++--
 fs/xfs/xfs_super.c   |   11 +++----
 fs/xfs/xfs_trans.c   |   31 +++++++++++++++++++-
 9 files changed, 141 insertions(+), 66 deletions(-)

