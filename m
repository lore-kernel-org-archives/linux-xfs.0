Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4052B65D
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="shJA836Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7271DC433C7;
	Sun, 31 Dec 2023 19:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051316;
	bh=ID6QoEGxyxngknjv6OE3Z2BrUo3Qmzl9S5c3Ca8gmbU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=shJA836Qfg1d9eTN2ALMyzKo8vwEqzBXCerBYJHy//WO+zqnrRYov4BiwMit4Nvdu
	 N1BHzpf1C6ExWaDmHQNj/VlLDeAtpDudf/UZePnpDydA9423MnYibNTDm4kTQlc0ql
	 XrDGmS7mv8WAf8RyJlfcfJtPwuZSpXhaKkIuXzh4j6i/Mhb0rOudAl5PALFd2sf+9K
	 A6YuTDSDz1E/mVrKHg7n0MnGk0OoFRA9soO+4eTC5bYgoLMhOxF4LgayNSxLNozT6V
	 0l8BedYEQTVAK0zwXTa4Z2Nc1LnO1cWiYLcz2Qtx07n2MK4RkmZfWkwmx6tJ4jPXtq
	 Le2XHlaNxgFTg==
Date: Sun, 31 Dec 2023 11:35:15 -0800
Subject: [PATCHSET v2.0 03/15] xfs: refactor realtime meta inode locking
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845722.1761787.5477037333223536717.stgit@frogsfrogsfrogs>
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

Replace all the open-coded locking of realtime metadata inodes with a
single rtlock function that can lock all the pieces that the caller
wants in a single call.  This will be important for maintaining correct
locking order later when we start adding more realtime metadata inodes.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refactor-rt-locking

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=refactor-rt-locking
---
 fs/xfs/libxfs/xfs_bmap.c     |    7 +---
 fs/xfs/libxfs/xfs_rtbitmap.c |   57 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtbitmap.h |   17 ++++++++++
 fs/xfs/scrub/bmap.c          |    2 +
 fs/xfs/scrub/common.c        |   70 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h        |   18 +++++++++++
 fs/xfs/scrub/fscounters.c    |    4 +-
 fs/xfs/scrub/rtbitmap.c      |    7 +---
 fs/xfs/scrub/rtsummary.c     |   12 ++-----
 fs/xfs/scrub/scrub.c         |    1 +
 fs/xfs/scrub/scrub.h         |    9 +++++
 fs/xfs/xfs_bmap_util.c       |    5 +--
 fs/xfs/xfs_fsmap.c           |    4 +-
 fs/xfs/xfs_inode.c           |    3 +-
 fs/xfs/xfs_inode.h           |   13 ++------
 fs/xfs/xfs_rtalloc.c         |   62 ++++++++++++++++++++++++++-----------
 16 files changed, 235 insertions(+), 56 deletions(-)

