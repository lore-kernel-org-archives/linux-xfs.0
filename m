Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3F7B64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lnKfgNz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF647C433C8;
	Sun, 31 Dec 2023 19:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052160;
	bh=xZpnX2Hy1UdyHn0T1b9Z7QYfkWnFCWbKfU/BNNwAfAM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lnKfgNz7ssrh9ZTzaHWTTWBzFdcGU4N1DaCa+FT36CDlskaFvKoljnuIAD7AXUkEE
	 BEHT/jjDu9+HwMsAHInGK7NSPpKS+IP8IISH4+1LQjIyV01BMJER2HzewJmhsuSHla
	 UPB14aYGGeeXJIpgFsKC1LOACxRZQpfeVGhWt7dyMWUzbyrWaVfqjiJm1EHN0mAaja
	 Zv1FBY26SB1voZwlbGCC5u+wsoSH7P0dm3eCVo0qTfBPPHwIopQsgesFdEwozPGIJ5
	 KwPCeRVF8aHRLC5M3WCOMoZ0GyswQq7+6/jC0JOYTJy+z4oz2qJDW+cQV+Ean4ZdZf
	 tKcQTju5t1pog==
Date: Sun, 31 Dec 2023 11:49:20 -0800
Subject: [PATCHSET v29.0 37/40] xfs_scrub_all: automatic media scan service
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405002977.1801496.15279364480135878968.stgit@frogsfrogsfrogs>
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

Now that we've completed the online fsck functionality, there are a few
things that could be improved in the automatic service.  Specifically,
we would like to perform a more intensive metadata + media scan once per
month, to give the user confidence that the filesystem isn't losing data
silently.  To accomplish this, enhance xfs_scrub_all to be able to
trigger media scans.  Next, add a duplicate set of system services that
start the media scans automatically.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-media-scan-service
---
 debian/rules                           |    3 +
 include/builddefs.in                   |    3 +
 man/man8/Makefile                      |    7 ++
 man/man8/xfs_scrub_all.8.in            |   20 +++++
 scrub/Makefile                         |   21 +++++-
 scrub/xfs_scrub@.service.in            |    2 -
 scrub/xfs_scrub_all.cron.in            |    2 -
 scrub/xfs_scrub_all.in                 |  122 ++++++++++++++++++++++++++------
 scrub/xfs_scrub_all.service.in         |    9 ++
 scrub/xfs_scrub_all_fail.service.in    |   71 +++++++++++++++++++
 scrub/xfs_scrub_fail.in                |   46 +++++++++---
 scrub/xfs_scrub_fail@.service.in       |    2 -
 scrub/xfs_scrub_media@.service.in      |  100 ++++++++++++++++++++++++++
 scrub/xfs_scrub_media_fail@.service.in |   76 ++++++++++++++++++++
 14 files changed, 439 insertions(+), 45 deletions(-)
 rename man/man8/{xfs_scrub_all.8 => xfs_scrub_all.8.in} (59%)
 create mode 100644 scrub/xfs_scrub_all_fail.service.in
 create mode 100644 scrub/xfs_scrub_media@.service.in
 create mode 100644 scrub/xfs_scrub_media_fail@.service.in

