Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DBEB64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cLxnAQF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89EA7C433C7;
	Sun, 31 Dec 2023 19:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704050752;
	bh=PjapwCz3PbQo1kMMYQAUXj0I7V5qKEwvpZmCtSNSqaY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cLxnAQF1UtSYLp5vQ2QHe95lPPhxuJuqhAQnxaspBxuQpBaTdKjWwTyx5dOK8HIIS
	 Bg8Q80O/elzC1lIujipo/m8Z9knjCtv4gzaczrT2p54wfg/gF/m6RhWnvLA2hSY+AR
	 8jJNV30Rz056pgQrrAjPtw2RpeUytZuEiXNCq5sgbaQ4ViJOPDVvUoHlD8nDgz0JGw
	 4eRyMWA/yd/z2tpMDz5T+KTn3fHgeAaepLgXEqqKzUvpE9B1KeCe3nwvA9ikLKFNKE
	 ejGATHqb9vNnfU5qVc4L7rdR3ANKOrvr9vLbnq/CO6VZ+YOT8cWBehSaxrWl7kLYJf
	 qUy0lL3iz5bnQ==
Date: Sun, 31 Dec 2023 11:25:51 -0800
Subject: [PATCHSET v29.0 02/28] xfs: repair inode mode by scanning dirs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404826964.1747851.15684326001874060927.stgit@frogsfrogsfrogs>
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

One missing piece of functionality in the inode record repair code is
figuring out what to do with a file whose mode is so corrupt that we
cannot tell us the type of the file.  Originally this was done by
guessing the mode from the ondisk inode contents, but Christoph didn't
like that because it read from data fork block 0, which could be user
controlled data.

Therefore, I've replaced all that with a directory scanner that looks
for any dirents that point to the file with the garbage mode.  If so,
the ftype in the dirent will tell us exactly what mode to set on the
file.  Since users cannot directly write to the ftype field of a dirent,
this should be safe.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-inode-mode

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-inode-mode
---
 fs/xfs/libxfs/xfs_da_format.h |   11 ++
 fs/xfs/libxfs/xfs_dir2.c      |    6 +
 fs/xfs/libxfs/xfs_dir2.h      |   10 ++
 fs/xfs/scrub/dir.c            |    4 -
 fs/xfs/scrub/inode_repair.c   |  236 ++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/iscan.c          |   29 +++++
 fs/xfs/scrub/iscan.h          |    3 +
 fs/xfs/scrub/trace.c          |    1 
 fs/xfs/scrub/trace.h          |   49 +++++++++
 9 files changed, 341 insertions(+), 8 deletions(-)

