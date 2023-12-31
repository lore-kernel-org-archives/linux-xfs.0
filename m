Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79504B65D
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KfLaRgly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93D8C433C8;
	Sun, 31 Dec 2023 19:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704050831;
	bh=FhxbBSdong5IykbfDoOWIAYtfWTRtHlnag22LxwuCPc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KfLaRglydb2IE18AIVqtyVkV12IQJ/lYZzMntgKimZjY4bR4AH0KB0v+WN7R8lt0/
	 hE0OPm03CLLSEKZCvCHlxLHw72VDRObmrOoTYDdXHF6fXretyHm4Tbs4ek3P8u2GT/
	 Kn9d9i5S9VmBK+kmgRnXVcm+1ER3IOaXD80ZUHjep4wmMIMGtFhCXKDshVfnrtLF9A
	 B2NpMN4Luw/vt7nAkzfwTRA6NoETKJMQNpBGmmEfOYbB3H1BseFM5yjyU5/MNukGIh
	 0zceewLW+QlZeTTZJwFOTc5EwRDAmLbcZIvB3WnO8zzwOJhso54kZQqc1dZPymXyFd
	 s+P/Nh+vBrwYQ==
Date: Sun, 31 Dec 2023 11:27:10 -0800
Subject: [PATCHSET v29.0 07/28] xfs: online repair for fs summary counters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404829188.1748775.2308941843971231003.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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

A longstanding deficiency in the online fs summary counter scrubbing
code is that it hasn't any means to quiesce the incore percpu counters
while it's running.  There is no way to coordinate with other threads
are reserving or freeing free space simultaneously, which leads to false
error reports.  Right now, if the discrepancy is large, we just sort of
shrug and bail out with an incomplete flag, but this is lame.

For repair activity, we actually /do/ need to stabilize the counters to
get an accurate reading and install it in the percpu counter.  To
improve the former and enable the latter, allow the fscounters online
fsck code to perform an exclusive mini-freeze on the filesystem.  The
exclusivity prevents userspace from thawing while we're running, and the
mini-freeze means that we don't wait for the log to quiesce, which will
make both speedier.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-fscounters

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-fscounters
---
 fs/xfs/Makefile                  |    1 +
 fs/xfs/scrub/fscounters.c        |   27 +++++++-------
 fs/xfs/scrub/fscounters.h        |   20 +++++++++++
 fs/xfs/scrub/fscounters_repair.c |   72 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h            |    2 +
 fs/xfs/scrub/scrub.c             |    2 +
 fs/xfs/scrub/trace.c             |    1 +
 fs/xfs/scrub/trace.h             |   21 +++++++++--
 8 files changed, 128 insertions(+), 18 deletions(-)
 create mode 100644 fs/xfs/scrub/fscounters.h
 create mode 100644 fs/xfs/scrub/fscounters_repair.c

