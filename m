Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2034274B3B;
	Mon, 26 Jan 2026 07:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769412149; cv=none; b=a3tl1vkSs6QS9zsoRwc+Uj+aXjO4V5ESZVbxM39g8lZnhST2uoo6bHMy+twNMvcYTvq6aGC/R/gzGOA5Xf5MRhjNlRkUnUfhVQkzdwg6kMpX/LPzrgG/tcLT6oTaYB4cck3/w6gBYZL/YDJcF7OCov6QP8G028uzSuE0T+quO4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769412149; c=relaxed/simple;
	bh=/pa3ehxCGOtU0rIgkJYVCAynKMJiuYNF7zS9UYzPslw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=DNlKnltwU1mU0/VrU4cTxMZpl6tq2TzlAN1Puiqi/8reE4y+QwKZYTwtkUnTYXy/o3rz3Z0mxoQYnzOq1EElJpLe+spvn/vhAN9GoThRUtEo80rkrD48cTinGlueYyzPtoYCf1uTwcnsoBkl4pXC4ddaPaAhKlqPNImBjR1Uekk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dXoBH5xB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dXoBH5xB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB82C116C6;
	Mon, 26 Jan 2026 07:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769412148;
	bh=/pa3ehxCGOtU0rIgkJYVCAynKMJiuYNF7zS9UYzPslw=;
	h=Date:Subject:From:To:Cc:From;
	b=dXoBH5xBrZjahFdWSNXV4Br2IDWGVD2P9hoCk3iqH3LKP0ryam0PkFQqJoldtjOi6
	 TPgJC/kClJbc2vk149OciBePmzV0IXVv/IVyV5BvOAzHiahFfj7VgDEry+DIODYlBc
	 5g3jSzAxDUGA1llQkHPX7m19btHh/inSHPAUA/euS1vJ1Zlwf4lKgU6ZXpbMnDBcU1
	 xrZxSJ4SKXDPW3fwxIlJVYHhOoWwTd8XbkiOmPB5At/qjJleIcULQTbtUPVnM4f7OC
	 Tpf4zFbxal0vifGQs0WNZVlOkA09p6MWFAZALT9y7AlEXYmwM2Piebg4O9P3sCsIag
	 It6JIhV0QDMPg==
Date: Sun, 25 Jan 2026 23:22:28 -0800
Subject: [GIT PULL 4/4] xfs: syzbot fixes for online fsck
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, r772577952@gmail.com, stable@vger.kernel.org
Message-ID: <176939848276.2856414.2422046318877467815.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 7.0-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit eaec8aeff31d0679eadb27a13a62942ddbfd7b87:

xfs: add a method to replace shortform attrs (2026-01-23 09:27:36 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-syzbot-fixes-7.0_2026-01-25

for you to fetch changes up to 55e03b8cbe2783ec9acfb88e8adb946ed504e117:

xfs: check for deleted cursors when revalidating two btrees (2026-01-24 08:46:43 -0800)

----------------------------------------------------------------
xfs: syzbot fixes for online fsck [3/3]

Fix various syzbot complaints about scrub that Jiaming Zhang found.

With a bit of luck, this should all go splendidly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (5):
xfs: get rid of the xchk_xfile_*_descr calls
xfs: only call xf{array,blob}_destroy if we have a valid pointer
xfs: check return value of xchk_scrub_create_subord
xfs: fix UAF in xchk_btree_check_block_owner
xfs: check for deleted cursors when revalidating two btrees

fs/xfs/scrub/common.h            | 25 -------------------------
fs/xfs/scrub/agheader_repair.c   | 21 ++++++++++-----------
fs/xfs/scrub/alloc_repair.c      | 20 ++++++++++++++++----
fs/xfs/scrub/attr_repair.c       | 26 +++++++++-----------------
fs/xfs/scrub/bmap_repair.c       |  6 +-----
fs/xfs/scrub/btree.c             |  7 +++++--
fs/xfs/scrub/common.c            |  3 +++
fs/xfs/scrub/dir.c               | 13 ++++---------
fs/xfs/scrub/dir_repair.c        | 19 +++++++++----------
fs/xfs/scrub/dirtree.c           | 19 +++++++++----------
fs/xfs/scrub/ialloc_repair.c     | 25 ++++++++++++++++++-------
fs/xfs/scrub/nlinks.c            |  9 ++++-----
fs/xfs/scrub/parent.c            | 11 +++--------
fs/xfs/scrub/parent_repair.c     | 23 ++++++-----------------
fs/xfs/scrub/quotacheck.c        | 13 +++----------
fs/xfs/scrub/refcount_repair.c   | 13 ++-----------
fs/xfs/scrub/repair.c            |  3 +++
fs/xfs/scrub/rmap_repair.c       |  5 +----
fs/xfs/scrub/rtbitmap_repair.c   |  6 ++----
fs/xfs/scrub/rtrefcount_repair.c | 15 +++------------
fs/xfs/scrub/rtrmap_repair.c     |  5 +----
fs/xfs/scrub/rtsummary.c         |  7 ++-----
fs/xfs/scrub/scrub.c             |  2 +-
23 files changed, 115 insertions(+), 181 deletions(-)

