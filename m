Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8608B65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gYMIEDkx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA47C433C7;
	Sun, 31 Dec 2023 19:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052301;
	bh=7JnyM4KJGDjq1CEcIpv5Cf2VNIbgxoyDEIZ/mvixioc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gYMIEDkxId1Mw/fikAUhL1n75X4QuPs2RQ9UFWNxXSfo79iwqIcflwp6A0juuhdWA
	 BCXe/j5hGYFBiWex809WDCdQaAvlSJwi+ljVKJXHyolesAQmju6GMPgCUPfo42w+PY
	 gUKKWxyFk1KFK3oUqKSZFfq66eiZQTtIOn34nwegulbetisYGXr/l38thTLCvfjylC
	 EXkBG8vGSizX341+NrtXmpJ8fwZd92B6Y8ZaLUaK9sDQmBbzHlFahgQGh8X3yn1v5T
	 mMjozVFPVnLVSzJe4JxVXuATNijP+TvjNnefYavUTeBujCN1bVtyC4YYR3RniviQ2W
	 h5W+RqqcWlDug==
Date: Sun, 31 Dec 2023 11:51:41 -0800
Subject: [PATCHSET 6/6] xfs_scrub: vectorize kernel calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405007836.1806194.11810681886556560484.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181849.GT361584@frogsfrogsfrogs>
References: <20231231181849.GT361584@frogsfrogsfrogs>
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

Create a vectorized version of the metadata scrub and repair ioctl, and
adapt xfs_scrub to use that.  This is an experiment to measure overhead
and to try refactoring xfs_scrub.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=vectorized-scrub

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=vectorized-scrub

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=vectorized-scrub
---
 io/scrub.c                           |  371 ++++++++++++++++++++++++++++++----
 libfrog/fsgeom.h                     |    6 +
 libfrog/scrub.c                      |  124 +++++++++++
 libfrog/scrub.h                      |    4 
 libxfs/xfs_fs.h                      |   10 +
 libxfs/xfs_fs_staging.h              |   32 +++
 man/man2/ioctl_xfs_scrubv_metadata.2 |  168 +++++++++++++++
 man/man8/xfs_io.8                    |   51 +++++
 scrub/phase1.c                       |    2 
 scrub/phase2.c                       |   93 +++++++--
 scrub/phase3.c                       |   84 ++++++--
 scrub/repair.c                       |  354 ++++++++++++++++++++------------
 scrub/scrub.c                        |  348 ++++++++++++++++++++++++--------
 scrub/scrub.h                        |   19 ++
 scrub/scrub_private.h                |   62 ++++--
 15 files changed, 1422 insertions(+), 306 deletions(-)
 create mode 100644 man/man2/ioctl_xfs_scrubv_metadata.2

