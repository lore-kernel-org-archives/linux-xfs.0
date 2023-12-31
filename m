Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB479B65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b0T8T6fc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47544C433C8;
	Sun, 31 Dec 2023 19:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052098;
	bh=lcEinqPeNjd0JlSCz3SLsaHva8ebepLfG+awIn81wVA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b0T8T6fcIoinb5uJfo83/yQg/ypoyJL/Gqib/DVoBNEYi9ePmV+xTft2qE90RgRyF
	 xGaIBcx+171ZAp3Ov7WecvcNsQRvEQfbWh4yfAvlM7kTijw+/QiWxNmdRkjxcjZ+IQ
	 H7uUzt838EZfKBwGvvAcYJL8tz3gdKo2D2pPSbrghY4qQZnRysFu082I7fsqeKVCGo
	 4MQUcFk6azai0rX3E0mpul6lEJY03E7nftaT4ORB200A3HIdnhAr1NeHGjISa1/lsI
	 73VgsTL80dZFaefK0anM08TYPYSgnNfpZlNRqCoRryJnG/eQcRzniY+miK74aEhPa6
	 MJ6AWGWfoidMA==
Date: Sun, 31 Dec 2023 11:48:17 -0800
Subject: [PATCHSET v29.0 33/40] xfs_scrub: use free space histograms to reduce
 fstrim runtime
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405001452.1798998.1713163893791596567.stgit@frogsfrogsfrogs>
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

This patchset dramatically reduces the runtime of the FITRIM calls made
during phase 8 of xfs_scrub.  It turns out that phase 8 can really get
bogged down if the free space contains a large number of very small
extents.  In these cases, the runtime can increase by an order of
magnitude to free less than 1% of the free space.  This is not worth the
time, since we're spending a lot of time to do very little work.  The
FITRIM ioctl allows us to specify a minimum extent length, so we can use
statistical methods to compute a minlen parameter.

It turns out xfs_db/spaceman already have the code needed to create
histograms of free space extent lengths.  We add the ability to compute
a CDF of the extent lengths, which make it easy to pick a minimum length
corresponding to 99% of the free space.  In most cases, this results in
dramatic reductions in phase 8 runtime.  Hence, move the histogram code
to libfrog, and wire up xfs_scrub, since phase 7 already walks the
fsmap.

We also add a new -o suboption to xfs_scrub so that people who /do/ want
to examine every free extent can do so.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-fstrim-minlen-freesp-histogram

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-fstrim-minlen-freesp-histogram
---
 db/freesp.c          |   83 +++-------------
 libfrog/Makefile     |    2 
 libfrog/histogram.c  |  252 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/histogram.h  |   54 +++++++++++
 man/man8/xfs_scrub.8 |   16 +++
 scrub/phase7.c       |   47 +++++++++
 scrub/phase8.c       |   75 ++++++++++++++-
 scrub/spacemap.c     |   11 +-
 scrub/vfs.c          |    4 +
 scrub/vfs.h          |    2 
 scrub/xfs_scrub.c    |   45 +++++++++
 scrub/xfs_scrub.h    |   16 +++
 spaceman/freesp.c    |   93 +++++-------------
 13 files changed, 544 insertions(+), 156 deletions(-)
 create mode 100644 libfrog/histogram.c
 create mode 100644 libfrog/histogram.h

