Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF2D5788E
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 02:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711421700; cv=none; b=tXIPpUF6le4W7lwV36YI4x5cbN/nBnOga9C2AenKG3egp+M114/jw/WKH1wtDlpslZ9H5S5WjVTYUoQfIghZGlN4+fDAlKdGOI3Wav7cGtS7SNRuSgGV1nzwIPtWAKHseO9EdIT7TaS2LcaBh+5fk1jg3/XwDY3966tQ+4cFHys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711421700; c=relaxed/simple;
	bh=hlPuqQVgKhfOc0N+vxvB+d+gnJetmVu+WWix7P8T0FM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tJhisDTSQZj0fj+lufM+f6Qz1C16D3gTkO5vex12llYYhwLoLAJDKbPjOlxJSUGOXxXxWd/VjB6Tof/CJvpp+/yciIo/GyY4Ta5EmRLQAB+TAO4IR4uhjVIEgjkuRSGsFu80KohFeK0QhsC/BLZ8148SJmMXkTAqayiE8suHfYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WvPEQSH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WvPEQSH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8FA6C433C7;
	Tue, 26 Mar 2024 02:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711421700;
	bh=hlPuqQVgKhfOc0N+vxvB+d+gnJetmVu+WWix7P8T0FM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WvPEQSH4mz8TFxH+apmou4UQ5XdaMU46yeGL612cEeCaHG0Cjs95kfYj9wDs8Wscm
	 mhNtD67uvEYf58u081hKxg/1bpAJCR3GmU80jlUTed6APXYoCjEC5ZsvLL1IiY2BmI
	 ALLRvJNAvZrlcfSaX4d078LYjR5jqSLaaZYW0xf4kG8V4BXfD0cKzSxh7MWkzpNLdK
	 eSLr5DFcoOQGc9qZOau2SXkAWk+2sCmfXpkZwHU1tHr7kXoTj6u4IanbB163qIpaxV
	 /FwF5Dc95Ngp9yxPAdcdXtjjzo035inWS13dhYTmqijQFJHEPIYcrqr9Xpwl00BkI6
	 Satx48OL8d3Ew==
Date: Mon, 25 Mar 2024 19:54:59 -0700
Subject: [PATCHSET 01/18] xfsprogs: convert utilities to use new rt helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs>
In-Reply-To: <20240326024549.GE6390@frogsfrogsfrogs>
References: <20240326024549.GE6390@frogsfrogsfrogs>
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

The patches in this series clean up a lot of realtime space usage code
the userspace utilities.  This involves correcting incorrect type usage,
renaming variables to reflect their actual usage; and converting open
code logic to use the new helpers that were just added to libxfs.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=fix-realtime-units
---
Commits in this patchset:
 * libxfs: fix incorrect porting to 6.7
 * mkfs: fix log sunit rounding when external logs are in use
 * xfs_repair: fix confusing rt space units in the duplicate detection code
 * libxfs: create a helper to compute leftovers of realtime extents
 * libxfs: use helpers to convert rt block numbers to rt extent numbers
 * xfs_repair: convert utility to use new rt extent helpers and types
 * mkfs: convert utility to use new rt extent helpers and types
 * xfs_{db,repair}: convert open-coded xfs_rtword_t pointer accesses to helper
 * xfs_repair: convert helpers for rtbitmap block/wordcount computations
 * xfs_{db,repair}: use accessor functions for bitmap words
 * xfs_{db,repair}: use helpers for rtsummary block/wordcount computations
 * xfs_{db,repair}: use accessor functions for summary info words
 * xfs_{db,repair}: use m_blockwsize instead of sb_blocksize for rt blocks
---
 db/check.c               |   90 ++++++++++++++++++++++++++++++++++++----------
 include/libxfs.h         |    4 ++
 libxfs/Makefile          |    1 +
 libxfs/init.c            |    8 ++--
 libxfs/libxfs_api_defs.h |    8 ++++
 libxfs/logitem.c         |    3 +-
 libxfs/trans.c           |    3 +-
 libxfs/xfs_rtbitmap.c    |    2 +
 libxfs/xfs_rtbitmap.h    |    3 --
 mkfs/proto.c             |   41 ++++++++++++++-------
 mkfs/xfs_mkfs.c          |   16 ++++++--
 repair/agheader.h        |    2 +
 repair/dinode.c          |   21 ++++++-----
 repair/globals.c         |    4 +-
 repair/globals.h         |    4 +-
 repair/incore.c          |   16 ++++----
 repair/incore.h          |   15 +++-----
 repair/incore_ext.c      |   74 ++++++++++++++++++++------------------
 repair/phase4.c          |   16 ++++----
 repair/phase6.c          |   28 +++++++++++---
 repair/rt.c              |   64 ++++++++++++++++++++++-----------
 repair/rt.h              |    6 +--
 repair/scan.c            |    2 +
 23 files changed, 278 insertions(+), 153 deletions(-)

