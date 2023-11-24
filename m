Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D133DB85
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="McDIDH5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DEFC433C7;
	Fri, 24 Nov 2023 23:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700869599;
	bh=y9es8WvtaRI46J7/EfS9mAZ2lC0LKSPL7Rfw+e++fds=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=McDIDH5raRv9bfyPG9XIRP6ZDmerasW/N73rdr8iFit0sEUd2VL71VtTgEmoyHRuv
	 dBgPITK+1MTU/d3t0zidY2wuInksH9CtbbScPZdeWGa3wuTZxWo6S8j0TVrmGclwc5
	 BGi3oWO3wVnrUI46MasgBx4jR/oxOnhJKpUMOvwMpC5FIZ9CRopWyXkWt5NcBP8xMq
	 59lP6z6GU7eK1CPWv6fazHS2ejUA5BiXzf0bFbX25h8UzWC4GJ6dRroEFX4tkJ7MwD
	 PfaYm4/Aelw9AcMZCA9+EPNwFeqUkSEyj6ETHSHQ7MIJRPB1xmsPJOt4RC1hNxHq28
	 v9ixrsAv8YwRQ==
Date: Fri, 24 Nov 2023 15:46:38 -0800
Subject: [PATCHSET v28.0 0/5] xfs: online repair of quota and rt metadata
 files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086928781.2771741.1842650188784688715.stgit@frogsfrogsfrogs>
In-Reply-To: <20231124233940.GK36190@frogsfrogsfrogs>
References: <20231124233940.GK36190@frogsfrogsfrogs>
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

XFS stores quota records and free space bitmap information in files.
Add the necessary infrastructure to enable repairing metadata inodes and
their forks, and then make it so that we can repair the file metadata
for the rtbitmap.  Repairing the bitmap contents (and the summary file)
is left for subsequent patchsets.

We also add the ability to repair file metadata the quota files.  As
part of these repairs, we also reinitialize the ondisk dquot records as
necessary to get the incore dquots working.  We can also correct
obviously bad dquot record attributes, but we leave checking the
resource usage counts for the next patchsets.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-quota

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-quota

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-quota
---
 fs/xfs/Makefile             |    9 +
 fs/xfs/libxfs/xfs_format.h  |    3 
 fs/xfs/scrub/dqiterate.c    |  211 ++++++++++++++++
 fs/xfs/scrub/quota.c        |  107 +++++++-
 fs/xfs/scrub/quota.h        |   36 +++
 fs/xfs/scrub/quota_repair.c |  575 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h       |    7 +
 fs/xfs/scrub/scrub.c        |    6 
 fs/xfs/scrub/trace.c        |    3 
 fs/xfs/scrub/trace.h        |   78 ++++++
 fs/xfs/xfs_dquot.c          |   37 ---
 fs/xfs/xfs_dquot.h          |    8 -
 12 files changed, 1026 insertions(+), 54 deletions(-)
 create mode 100644 fs/xfs/scrub/dqiterate.c
 create mode 100644 fs/xfs/scrub/quota.h
 create mode 100644 fs/xfs/scrub/quota_repair.c

