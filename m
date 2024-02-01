Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC48B8526E
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816362; cv=none; b=X+6ingnJn1jpJCAKun8w7VCzM4SY9V62XwVt8Z48K7anaNV4CPqjozbFu3z4hf6yJzviNIpe5R5Aqk/36SqyQeEnfhejIN6VlNCD0IFoXB+J/3g2w6GkCznIdBU/hQsx0p12+06l5J2FmQQJ7EDCpxDQuFfM+FlWwA+sSyXsoH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816362; c=relaxed/simple;
	bh=vOCBv4wPJBbXcJLWL8IE98EMmPYRqsVSDyBOkx3TTUc=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=ckBcZvs7mndrtjZk0vwoJpdq3bqZnmyTXQtfVV+Klvlz2W0rv5py6EGGi9GVvWOF+ei8Kf3n5cRtIhBP6va/WmwEaHiiZbwjusnCIvrVZBwxPvGXm4otpOvgijJlY9qrAvmsW+ILiL1MSj3fyMZr42ugWibqMP5jxw3YwsoAGXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jIV/ieQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jIV/ieQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88213C433C7;
	Thu,  1 Feb 2024 19:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816362;
	bh=vOCBv4wPJBbXcJLWL8IE98EMmPYRqsVSDyBOkx3TTUc=;
	h=Date:Subject:From:To:Cc:From;
	b=jIV/ieQFgzuNieGAjDoijBTVgzrf4jd48kpvAcUXguMNQ6X5lIxYyBCeHrcCXHqsQ
	 4ls3DPkTEL5dmQzC8nQGTQSD1ugZlbxs7b7RD3j+yYFqMrNzaCnaGfzX3tP5AZoKrt
	 CvGUka8eqsOG7/NE5olSTH3eAyu3mdZpXXdZbYBZ0etfKgwAbK1RTQVnBUpemHaSKy
	 mIb9v53jLMf75zzX1L+w8g37eV0kkxA5S3sPpw14gDgGHXc0ZvaLR0ElsoJmE6U8BZ
	 Tb9J0QqZeTbgX8KnDNtq+dub9LszJA7SA6K04dsn5UufWtHp+6ZM6UG65r5H78OmrB
	 vdPJO/zXhJ6fQ==
Date: Thu, 01 Feb 2024 11:39:22 -0800
Subject: [PATCHSET v29.2 3/8] xfs: btree check cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335588.1606142.6111968277910779056.stgit@frogsfrogsfrogs>
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

Minor cleanups for the btree block pointer checking code.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-check-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=btree-check-cleanups
---
Commits in this patchset:
 * xfs: simplify xfs_btree_check_sblock_siblings
 * xfs: simplify xfs_btree_check_lblock_siblings
 * xfs: open code xfs_btree_check_lptr in xfs_bmap_btree_to_extents
 * xfs: consolidate btree ptr checking
 * xfs: misc cleanups for __xfs_btree_check_sblock
 * xfs: remove the crc variable in __xfs_btree_check_lblock
 * xfs: tighten up validation of root block in inode forks
 * xfs: consolidate btree block verification
 * xfs: rename btree helpers that depends on the block number representation
 * xfs: factor out a __xfs_btree_check_lblock_hdr helper
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    8 +
 fs/xfs/libxfs/xfs_bmap.c           |    2 
 fs/xfs/libxfs/xfs_bmap_btree.c     |    8 +
 fs/xfs/libxfs/xfs_btree.c          |  252 +++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_btree.h          |   44 ++----
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    8 +
 fs/xfs/libxfs/xfs_refcount_btree.c |    8 +
 fs/xfs/libxfs/xfs_rmap_btree.c     |    8 +
 fs/xfs/scrub/btree.c               |   21 +--
 9 files changed, 159 insertions(+), 200 deletions(-)

