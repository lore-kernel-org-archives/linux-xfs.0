Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C16B645
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q18zf+0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9051DC433C8;
	Sun, 31 Dec 2023 19:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051269;
	bh=2Ut2hQJGgUz57xsBsISYS35k2OAXPYR49DuJ7E5ZreI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q18zf+0abv3wO5px3QSPKkfqLWzUmXWZNBQ/ZcRDy+5nQIFgpYLtxnXv1Q+vYQFmY
	 lCWGaYlZ3eOvajDNlbfAYOWhR2bj+rwMRwj7Z/NSUXOYHjgNrnzV8BcpiFQb53l35Y
	 qUOqYoWDn2wNGqaPFUHBjqW7YmAxcQ2jSH8+RV0xb870VMr02YwHMLaV480J7PZU8B
	 4PYXvxOIjuapufJOl3WD8j3JfnqVZbH1VJw+qNS+5F6t0epndtaM2aoPnRFZSfCljm
	 +o2ZZ0Psq17/Q+3/eUKIFXbFyOfDKXg5yzRAwx7k4RcACw602B/EG6Vg1eJ9qjz0NU
	 pbrEEhtfrbxjg==
Date: Sun, 31 Dec 2023 11:34:29 -0800
Subject: [PATCHSET v13.0 7/7] xfs: vectorize scrub kernel calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404842857.1758126.13889834380054922462.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_fs.h         |   10 ++
 fs/xfs/libxfs/xfs_fs_staging.h |   32 ++++++++
 fs/xfs/scrub/common.h          |   25 ------
 fs/xfs/scrub/scrub.c           |  168 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.h           |   64 +++++++++++++++
 fs/xfs/scrub/trace.h           |   78 ++++++++++++++++++-
 fs/xfs/scrub/xfarray.c         |   10 +-
 fs/xfs/scrub/xfarray.h         |    3 +
 fs/xfs/scrub/xfile.c           |   10 +-
 fs/xfs/scrub/xfs_scrub.h       |    2 
 fs/xfs/xfs_ioctl.c             |   50 ++++++++++++
 11 files changed, 415 insertions(+), 37 deletions(-)

