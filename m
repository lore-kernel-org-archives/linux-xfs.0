Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D6BB666
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hflMwMko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9095DC433C7;
	Sun, 31 Dec 2023 19:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051597;
	bh=BKiRMj7q4JPUeV98pBtRByANts4WpOtcJ0zjrnXXfd4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hflMwMkoTJ48sDreCTnElj8iIk5ZgKTXQrOO+5ed0GaQ7GhjIZgabm2r6NeE9ounf
	 xRL1XQ532MDS6oiG3dhvc1oNJBGlvXmiCxnXTzEh0ynv6YYTpfHSNaJfhojfKXxFLp
	 lWeWO8BbgC7+jGVvjQULuu8bHL1Bn7FRBxRlWhllOfk5tkds/Ry+WIhaVYzmSRqazj
	 W0Lc4zPoR+kDUFJi2UeN/5Tqk0fQBsDq0KOyRhv7A2SC4fNdHpoLrYkH+WpqPvH7zI
	 KtN6vjscQznJYHNu61h0lOa8iLoNntNzmdV3kNpnJpsDYxjqhThmBYZGo9jtL6b1FG
	 39e3vbmN0e5zQ==
Date: Sun, 31 Dec 2023 11:39:57 -0800
Subject: [PATCHSET v29.0 01/40] xfs_scrub: fix licensing and copyright notices
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404989091.1791307.1449422318127974555.stgit@frogsfrogsfrogs>
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

Fix various attribution problems in the xfs_scrub source code, such as
the author's contact information, out of date SPDX tags, and a rough
estimate of when the feature was under heavy development.  The most
egregious parts are the files that are missing license information
completely.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-fix-legalese

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-fix-legalese
---
 scrub/Makefile                   |    2 +-
 scrub/common.c                   |    6 +++---
 scrub/common.h                   |    6 +++---
 scrub/counter.c                  |    6 +++---
 scrub/counter.h                  |    6 +++---
 scrub/descr.c                    |    4 ++--
 scrub/descr.h                    |    4 ++--
 scrub/disk.c                     |    6 +++---
 scrub/disk.h                     |    6 +++---
 scrub/filemap.c                  |    6 +++---
 scrub/filemap.h                  |    6 +++---
 scrub/fscounters.c               |    6 +++---
 scrub/fscounters.h               |    6 +++---
 scrub/inodes.c                   |    6 +++---
 scrub/inodes.h                   |    6 +++---
 scrub/phase1.c                   |    6 +++---
 scrub/phase2.c                   |    6 +++---
 scrub/phase3.c                   |    6 +++---
 scrub/phase4.c                   |    6 +++---
 scrub/phase5.c                   |    6 +++---
 scrub/phase6.c                   |    6 +++---
 scrub/phase7.c                   |    6 +++---
 scrub/progress.c                 |    6 +++---
 scrub/progress.h                 |    6 +++---
 scrub/read_verify.c              |    6 +++---
 scrub/read_verify.h              |    6 +++---
 scrub/repair.c                   |    6 +++---
 scrub/repair.h                   |    6 +++---
 scrub/scrub.c                    |    6 +++---
 scrub/scrub.h                    |    6 +++---
 scrub/spacemap.c                 |    6 +++---
 scrub/spacemap.h                 |    6 +++---
 scrub/unicrash.c                 |    6 +++---
 scrub/unicrash.h                 |    6 +++---
 scrub/vfs.c                      |    6 +++---
 scrub/vfs.h                      |    6 +++---
 scrub/xfs_scrub.c                |    6 +++---
 scrub/xfs_scrub.h                |    6 +++---
 scrub/xfs_scrub@.service.in      |    5 +++++
 scrub/xfs_scrub_all.cron.in      |    5 +++++
 scrub/xfs_scrub_all.in           |    6 +++---
 scrub/xfs_scrub_all.service.in   |    5 +++++
 scrub/xfs_scrub_all.timer        |    5 +++++
 scrub/xfs_scrub_fail             |    5 +++++
 scrub/xfs_scrub_fail@.service.in |    5 +++++
 45 files changed, 143 insertions(+), 113 deletions(-)

