Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B8A6124
	for <linux-xfs@vger.kernel.org>; Fri, 22 Dec 2023 02:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mw0mzg5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57061C433C8;
	Fri, 22 Dec 2023 02:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703212270;
	bh=Rj6iR86sh66bgjXJfZtlfNu8Mv39wkCL66nrFQHpy1Y=;
	h=Date:Subject:From:To:Cc:From;
	b=Mw0mzg5ExsnTKBcz3Fct/4QIibMSBV/XIi/5kWrVK6ziEClMuGnRO1WF7BtyRsWHy
	 8t8Sd2QeLPuqTbsy7iCh+00AasbmZDSLl2j9EvOgJYZI4GLx9Q4jXoq6Jd07LuWP48
	 x7e5VbtEy6B0QWC3etqWigafngRdV3Oiq9f0kkCej3W3cBMvDhmMbPTwM5WVS4sNrQ
	 7M9K5X1QYvfP/KFE2vQJdf6I0xU9WiUl2Wk0WGcvMw5Y0TBqoQrCiaMSW1ia9it9o9
	 LYjYs4f2+2VjVdNB0n2LnpF+bsCRn9YEZ01P6PX7w1cI6rXGCRqPeeVH6eFM6Wxx0S
	 Q41gLWz23F9nA==
Date: Thu, 21 Dec 2023 18:31:09 -0800
Subject: [GIT PULL 1/4] xfsprogs: various bug fixes for 6.6
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170321220608.2974519.4401807541250057118.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit fc83c7574b1fb2258c9403461e55b0cb091c670c:

libxfs: split out a libxfs_dev structure from struct libxfs_init (2023-12-18 14:57:50 +0100)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/xfsprogs-fixes-6.6_2023-12-21

for you to fetch changes up to 1665923a8302088744a69403ff60a1709f5d24ed:

xfs_db: report the device associated with each io cursor (2023-12-21 18:29:14 -0800)

----------------------------------------------------------------
xfsprogs: various bug fixes for 6.6 [1/8]

This series fixes a couple of bugs that I found in the userspace support
libraries.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (5):
libfrog: move 64-bit division wrappers to libfrog
libxfs: don't UAF a requeued EFI
xfs_copy: distinguish short writes to EOD from runtime errors
xfs_copy: actually do directio writes to block devices
xfs_db: report the device associated with each io cursor

copy/xfs_copy.c      | 24 +++++++++----
db/block.c           | 14 +++++++-
db/io.c              | 35 +++++++++++++++++--
db/io.h              |  3 ++
include/libxfs.h     |  1 +
libfrog/Makefile     |  1 +
libfrog/div64.h      | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++++
libxfs/defer_item.c  |  7 ++++
libxfs/libxfs_priv.h | 77 +----------------------------------------
9 files changed, 171 insertions(+), 87 deletions(-)
create mode 100644 libfrog/div64.h

