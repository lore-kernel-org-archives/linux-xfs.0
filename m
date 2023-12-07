Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE5C20E5
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EkdXt8kp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372B0C433C7;
	Thu,  7 Dec 2023 02:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701917654;
	bh=duy+hzAR1QSkZyGJKNpjqrOEVyRPwHo+WX6O6JQGqzM=;
	h=Date:From:To:Cc:From;
	b=EkdXt8kpL/BNndRe1wrL3Io409bQeicN8Ski+WsaKKIiQl2ii/D7DpQb47d9cuRPI
	 2jS3CM4YnIPiVWFTa8yaggiovOyMkkl291xAWucQpitAGSzlD41k8b3babLRipkf9x
	 +QeaHtiRJbThhJ9AQHjMfB/H6MdoG6JbPuXitGUmQi2gLfKRp4fVNum0I/fgnMUQwU
	 5oExftGR09iaCA/uJiu2YfI9l9yWcPW7swi0L6kpMYHxsevBjR0p6l2kxJDUtWJIye
	 EWdzDCFF0QsApWcwpk7u5aejPfWIPxQTuxDYdAY6qks0opThgb6VgGe+coum3mqKZ7
	 6cmvcaeCdANoQ==
Date: Wed, 06 Dec 2023 18:54:13 -0800
6ubject: [GIT PULL 3/6] xfs: fix realtime geometry integer overflows
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191741827.1195961.12759694921166879611.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit a49c708f9a445457f6a5905732081871234f61c6:

xfs: move ->iop_relog to struct xfs_defer_op_type (2023-12-06 18:45:17 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/fix-rtmount-overflows-6.8_2023-12-06

for you to fetch changes up to e14293803f4e84eb23a417b462b56251033b5a66:

xfs: don't allow overly small or large realtime volumes (2023-12-06 18:45:17 -0800)

----------------------------------------------------------------
xfs: fix realtime geometry integer overflows [v2]

While reading through the realtime geometry support code in xfsprogs, I
noticed a discrepancy between the sb_rextslog computation used when
writing out the superblock during mkfs and the validation code used in
xfs_repair.  This discrepancy would lead to system failure for a runt rt
volume having more than 1 rt block but zero rt extents in length.  Most
people aren't going to configure a 1M extent size for their 360k rt
floppy disk volume, but I did!

In the process of studying that code, it occurred to me that there is a
second bug in the computation -- the use of highbit32 for a 64-bit
value means that the upper 32 bits are not considered in the search for
a high bit.  This causes the creation of a realtime summary file that is
the wrong length.  If rextents is a multiple of U32_MAX then this will
appear to work fine because highbit32 returns -1 for an input of 0; but
for all other cases the rt summary is undersized, leading to failures.

Fix the first problem by standardizing the computation with a helper in
libxfs; and the second problem by correcting the computation.  This will
cause any existing rt volumes larger than 2^32 blocks to fail validation
but they probably were already crashing anyway.

v2: pick up review tags

This has been lightly tested with fstests.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs: make rextslog computation consistent with mkfs
xfs: fix 32-bit truncation in xfs_compute_rextslog
xfs: don't allow overly small or large realtime volumes

fs/xfs/libxfs/xfs_rtbitmap.c | 14 ++++++++++++++
fs/xfs/libxfs/xfs_rtbitmap.h | 16 ++++++++++++++++
fs/xfs/libxfs/xfs_sb.c       |  6 ++++--
fs/xfs/xfs_rtalloc.c         |  6 ++++--
4 files changed, 38 insertions(+), 4 deletions(-)

