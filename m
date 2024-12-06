Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A5A22C6DC;
	Fri,  6 Dec 2024 23:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733527740; cv=none; b=sTOh5+zLOYOjL8lLUn6vCkRPSWYgVGMq46r51UaZJ4y/cSg8TOxoEKWg1wHRTvhkgXo3uRRRF8gfC6q7WuUEn9LI7rY+zBfKV+l2TqOaVeeW5TOlICXLfrT8vJ0x05O27J8utmz8Jdg2veYW/NQoFsGJpmsb0JN100uk9MaQdLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733527740; c=relaxed/simple;
	bh=RYWePNtpBn+RCbQSwogjWrVFUw65rsh2w1yPLebtyXE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y+udWVM2rzuK1gSgRs7x52RPTd18i/WZ1e5F81FxVHCZ5FMo4vCRD1mxn9J5VckmvTYQ/fIZQqFziLysvLC0SxQ1qfBHUh8uHqYKb0IXQkh/masATAuMwCnU+dfiHq9Ew4xoSTnkywnOICfNUiem5ioUxRSfearukArgcu7URvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eHjcKEI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eHjcKEI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593ECC4CED1;
	Fri,  6 Dec 2024 23:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733527738;
	bh=RYWePNtpBn+RCbQSwogjWrVFUw65rsh2w1yPLebtyXE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eHjcKEI71AApogmeGPoKRwr1G4OFjv8yfUkvpqrd58qsXQ3zFIMywNuZSBsOgYr7E
	 TQ/yDtGXCHytUw1pM3sbWEs79yqyLLh3gXv4EG4Sfim/6WxyCuLAss5oKwTLZe606t
	 wbq+gVHHy3aVMsxPRJCVGAaPmnt4fqt6S6pSA8L77kKR10sZ7zidADjNRsHoBHT7aF
	 +ywRgJ+Iq/Gcb6UDLo+KEE6PgNm9xLaLkJCLYbjpSXzOQiq7yMJVLtNctAgsWpPkp3
	 rvYZ+KQI8vL5sUdNhIy0w/KwEFHFCpiM3qI5ZyQzSoc3WCEEdgq7YzYaq7k/IBWfrb
	 L8cOqDfkGFDjA==
Date: Fri, 06 Dec 2024 15:28:57 -0800
Subject: [PATCHSET 6/9] xfsprogs: bug fixes for 6.13
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: dan.carpenter@linaro.org, hch@lst.de, stable@vger.kernel.org, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <173352751190.126106.5258055486306925523.stgit@frogsfrogsfrogs>
In-Reply-To: <20241206232259.GO7837@frogsfrogsfrogs>
References: <20241206232259.GO7837@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Bug fixes for 6.13.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-6.13-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfs-6.13-fixes
---
Commits in this patchset:
 * xfs: return a 64-bit block count from xfs_btree_count_blocks
 * xfs: fix error bailout in xfs_rtginode_create
 * xfs: update btree keys correctly when _insrec splits an inode root block
 * xfs: don't call xfs_bmap_same_rtgroup in xfs_bmap_add_extent_hole_delay
 * xfs: fix sb_spino_align checks for large fsblock sizes
 * xfs: return from xfs_symlink_verify early on V4 filesystems
---
 libxfs/xfs_bmap.c           |    6 ++----
 libxfs/xfs_btree.c          |   33 +++++++++++++++++++++++++--------
 libxfs/xfs_btree.h          |    2 +-
 libxfs/xfs_ialloc_btree.c   |    4 +++-
 libxfs/xfs_rtgroup.c        |    2 +-
 libxfs/xfs_sb.c             |   11 ++++++-----
 libxfs/xfs_symlink_remote.c |    4 +++-
 7 files changed, 41 insertions(+), 21 deletions(-)

