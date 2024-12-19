Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2698B1A9B53
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734635970; cv=none; b=us7/oazdX10jSpaPm64PKIhD+UZgwp8giEMvLRR8MGkHBTPRHhs1Pon0qD1zNfFBraKnQl5UDlYrV+Pg5/YMdk1b5aYsf/AIUdBlmB08TiKg1bC+aIah8Kwog9vQ8spgpwqjTurvDttzxbUdt39B6IPFYQNUkgW5owlUH1X13hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734635970; c=relaxed/simple;
	bh=Z9c/euzo2J2tCiy1P1Ku79dD8zSrcFc/Rm4cHAQE+24=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZrezxoTUEedbNSEvpqoy9G+qfXfkKN/d+0s6ohO6mBBGqOu1wMQbBtIfjlLY2j1eyvu9RN8YA53C1rCvKDhFsvrjV1zxjstE2uB6VWQnmRx2O037uaztXaQKzk0UZPIGHhqcELOnuL/NYdGR+OcKqoorIIl2fyu10ghiKk24zRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+VoToOj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+VoToOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDB2C4CECE;
	Thu, 19 Dec 2024 19:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734635969;
	bh=Z9c/euzo2J2tCiy1P1Ku79dD8zSrcFc/Rm4cHAQE+24=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=a+VoToOjPgFRdBPzad1NagIWHA5HgaaiTn7PaYEB7V43F9cMdpngztXDnwVFMXXiW
	 zYzrZcUC2DFJow1hF5igSelU4+tjphfRzWYT6RTK1GAMSPcYIZ3ptL/mxAaLWircbv
	 Fwa/1x2GHehINjmkWHUjx63rKTKQ4QjQXf132QBmFhIy7OthL38Kue76xi0lna+Qem
	 n87U2ss3Rm3u7T/HCeXBb2omOqHziCahHe2mnCT2YMjS4mC50wJqELQH/zYQ+KVdaj
	 n7Z5OznLjN3pZKrIYilcTZAHEGQxQq0inYdUEl3YdVVICmlEIihdOrYBD3b3T702Jf
	 vxMXyEQqIgMFw==
Date: Thu, 19 Dec 2024 11:19:29 -0800
Subject: [PATCHSET v6.1 3/5] xfs: enable in-core block reservation for rt
 metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463579158.1571383.10600787559817251215.stgit@frogsfrogsfrogs>
In-Reply-To: <20241219191553.GI6160@frogsfrogsfrogs>
References: <20241219191553.GI6160@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

In preparation for adding reverse mapping and refcounting to the
realtime device, enhance the metadir code to reserve free space for
btree shape changes as delayed allocation blocks.

This enables us to pre-allocate space for the rmap and refcount btrees
in the same manner as we do for the data device counterparts, which is
how we avoid ENOSPC failures when space is low but we've already
committed to a COW operation.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reserve-rt-metadata-space

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=reserve-rt-metadata-space
---
Commits in this patchset:
 * xfs: prepare to reuse the dquot pointer space in struct xfs_inode
 * xfs: allow inode-based btrees to reserve space in the data device
---
 fs/xfs/libxfs/xfs_ag_resv.c  |    3 +
 fs/xfs/libxfs/xfs_attr.c     |    4 -
 fs/xfs/libxfs/xfs_bmap.c     |    4 -
 fs/xfs/libxfs/xfs_errortag.h |    4 +
 fs/xfs/libxfs/xfs_metadir.c  |    4 +
 fs/xfs/libxfs/xfs_metafile.c |  205 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_metafile.h |   11 ++
 fs/xfs/libxfs/xfs_types.h    |    7 +
 fs/xfs/scrub/tempfile.c      |    1 
 fs/xfs/xfs_dquot.h           |    3 +
 fs/xfs/xfs_error.c           |    3 +
 fs/xfs/xfs_exchrange.c       |    3 +
 fs/xfs/xfs_fsops.c           |   17 +++
 fs/xfs/xfs_inode.h           |   16 +++
 fs/xfs/xfs_mount.c           |   10 ++
 fs/xfs/xfs_mount.h           |    1 
 fs/xfs/xfs_qm.c              |    2 
 fs/xfs/xfs_quota.h           |    5 -
 fs/xfs/xfs_rtalloc.c         |   21 ++++
 fs/xfs/xfs_rtalloc.h         |    5 +
 fs/xfs/xfs_trace.h           |   45 +++++++++
 fs/xfs/xfs_trans.c           |    4 +
 fs/xfs/xfs_trans_dquot.c     |    8 +-
 23 files changed, 367 insertions(+), 19 deletions(-)

