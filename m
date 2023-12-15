Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D327A5D910
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 21:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="daeJ1HgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0438C433C8;
	Fri, 15 Dec 2023 21:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702677375;
	bh=A6JNK9tQFi0gXvNGDmHvLkFwsaRNbALYqz4ZFZPEyQc=;
	h=Date:Subject:From:To:Cc:From;
	b=daeJ1HgT8hORQLvYpJ4+zGHWvy3vjkhqPZf/+jvTu0QgkW9+0VVpZ8WaPfA2XXDRH
	 cuI1XGH9CN2Kv6jQ7nkSUkQ5p1Tlal45pcl2hgz/lbZFX7meVMfm4VN/F85pPGhXJB
	 QZxGyzrYkPemYQeGhi/Zh6B5DfkMCpPRjZWmzljL8EG/Tjzbym+bqIgU44Yg5r9TG8
	 64kZAGKZTGbTY6tVTbbU2Gjo26BbqL2tS87PtvSxGiztw4AVJgvRDXBsZ+1+AjpQbz
	 0pKPCuoKC1GL6sm5mVOPI58ubP1Kj0mfzMfo9ByyxlBr3xQdWcgHbmYGYuFNXBzHhU
	 lFGWrGLyquGsQ==
Date: Fri, 15 Dec 2023 13:56:15 -0800
Subject: [GIT PULL 5/6] xfs: online repair of rt bitmap file
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <170267713665.2577253.13608710440348653318.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.8-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit dbbdbd0086320a026903ca34efedb6abf55230ed:

xfs: repair problems in CoW forks (2023-12-15 10:03:40 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-rtbitmap-6.8_2023-12-15

for you to fetch changes up to ffd37b22bd2b7cca7749c85a0a08268158903e55:

xfs: online repair of realtime bitmaps (2023-12-15 10:03:43 -0800)

----------------------------------------------------------------
xfs: online repair of rt bitmap file [v28.3]

Add in the necessary infrastructure to check the inode and data forks of
metadata files, then apply that to the realtime bitmap file.  We won't
be able to reconstruct the contents of the rtbitmap file until rmapbt is
added for realtime volumes, but we can at least get the basics started.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (6):
xfs: check rt bitmap file geometry more thoroughly
xfs: check rt summary file geometry more thoroughly
xfs: always check the rtbitmap and rtsummary files
xfs: repair the inode core and forks of a metadata inode
xfs: create a new inode fork block unmap helper
xfs: online repair of realtime bitmaps

fs/xfs/Makefile                |   4 +
fs/xfs/libxfs/xfs_bmap.c       |  41 ++++++++-
fs/xfs/libxfs/xfs_bmap.h       |   5 +-
fs/xfs/scrub/bmap_repair.c     |  17 +++-
fs/xfs/scrub/repair.c          | 153 +++++++++++++++++++++++++++++++
fs/xfs/scrub/repair.h          |   9 ++
fs/xfs/scrub/rtbitmap.c        | 103 +++++++++++++++++----
fs/xfs/scrub/rtbitmap.h        |  22 +++++
fs/xfs/scrub/rtbitmap_repair.c | 202 +++++++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/rtsummary.c       | 137 ++++++++++++++++++++++------
fs/xfs/scrub/scrub.c           |   4 +-
fs/xfs/xfs_inode.c             |  24 +----
12 files changed, 647 insertions(+), 74 deletions(-)
create mode 100644 fs/xfs/scrub/rtbitmap.h
create mode 100644 fs/xfs/scrub/rtbitmap_repair.c

