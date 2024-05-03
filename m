Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424EE1CD26
	for <linux-xfs@vger.kernel.org>; Fri,  3 May 2024 04:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714710823; cv=none; b=FTDZI4lZykVPvtejVhgPGeC/K7y2YDaMujRN3k7SKB/+hNB3e7QoLGhXsl2IZsD8T9RWg3JMt236B6SS9zBGGDy/IUdNizOtJWXk3Im9kfrBgxTMamALW3icLK0qJpU/KnZzqMx7ynoauGSoREUbbDp7bNasMdj9XPpvP6xVW3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714710823; c=relaxed/simple;
	bh=OOuwJNgoS2vTgg9V6rsKzF3rnojSYTonf1P+xasEQXk=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=quAVAmzBoCByVCJkZhLTVDS35zTdc2UzUr58gWREHjiwanvH/brGSRAizfgGqkf0tzvEuPHT+ocbdrIafU2kAe1HQgok3K0R2WZh0TGQabKR8CA8eVoIHkt33OOqHLisVaw49Z3ZthGMNs6Bmf3fKV4n8JkEfwvKLAhEHvMQlAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nljqcn0B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nljqcn0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92BBC116B1;
	Fri,  3 May 2024 04:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714710822;
	bh=OOuwJNgoS2vTgg9V6rsKzF3rnojSYTonf1P+xasEQXk=;
	h=Date:Subject:From:To:Cc:From;
	b=Nljqcn0BUEZbufQG2hiDTMPBF51C978Cs1p3aD1pCEPqHaa5qYtbvA5NxOWlv09yS
	 Bf4hMvLnK06OUqnADlgvDTpzsXZrWdmF1AlpSQLuelniVFPAZ4MSaWus/+4s2+CARU
	 ecD8k2y1nblOWG9z2E+8aUC+UYJ2ESa5qj4VAL6B+Dpz5akSaPmStS6EEiNvgFY9jR
	 d1wE/RevpWTpNsen4czqgFgmEaA+0OUdj5HY3P8E0zvhFKQAbGp7Lc9BaE52S3soft
	 LXhB/PgZzmB9htVl0/2gW0lC5tdJ3nqKQ2ELVwoVHay8D62p+7hoBet6sasx9bt/jk
	 bhmnOs3Q+Iw2g==
Date: Thu, 02 May 2024 21:33:42 -0700
Subject: [PATCHSET] xfs: last round of cleanups for 6.10
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Andrey Albershteyn <aalbersh@redhat.com>,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171471075305.2662283.8498264701525930955.stgit@frogsfrogsfrogs>
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

Here are the reviewed cleanups at the head of the fsverity series.
Apparently there's other work that could use some of these things, so
let's try to get it in for 6.10.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-cleanups-6.10
---
Commits in this patchset:
 * xfs: use unsigned ints for non-negative quantities in xfs_attr_remote.c
 * xfs: turn XFS_ATTR3_RMT_BUF_SPACE into a function
 * xfs: create a helper to compute the blockcount of a max sized remote value
 * xfs: minor cleanups of xfs_attr3_rmt_blocks
 * xfs: widen flags argument to the xfs_iflags_* helpers
---
 fs/xfs/libxfs/xfs_attr.c        |    2 -
 fs/xfs/libxfs/xfs_attr_remote.c |   88 ++++++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_attr_remote.h |    8 +++-
 fs/xfs/libxfs/xfs_da_format.h   |    4 --
 fs/xfs/scrub/reap.c             |    4 +-
 fs/xfs/xfs_icache.c             |    4 --
 fs/xfs/xfs_inode.h              |   14 +++---
 7 files changed, 69 insertions(+), 55 deletions(-)

