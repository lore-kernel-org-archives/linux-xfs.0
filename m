Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE50159200
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224198; cv=none; b=ctzvrOipwkfFlg4kL09aAnFNIM5GT7ZBHeMSqoAL5Yj5qiNzzS+xNHD/I7MJJCbCPyNMxJyHWzWbdN68f/7Knk9Q87W0TthB79s3fNWut9SK0H5NFz5DAKLVDKKbzadjWHHcDIi9xzbRo4b9xVWu8+LKQfqN1hjbvR3ExIU+cYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224198; c=relaxed/simple;
	bh=pRRHEGYyAVTEwXD69WaIno6wi7HvoUPumCsaNjv1esA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jLLR0gZStohHtu5ET2moku6taAfSOJJ4oHQvD+uIZAz2qmbbc4odWwhWKkyvfmjx3yzg5/59qp0R7i70uXvaJqKl6BTnmoDRYISobjBnMrWfsNTN0dN0AqWwU+eGJCR2QoYwYhKbb6R3GxK3HrzgT1sP9Mkpzb+dG4tH+Cf0U2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qef5JcnY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qef5JcnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC2AC113CC;
	Mon, 15 Apr 2024 23:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224198;
	bh=pRRHEGYyAVTEwXD69WaIno6wi7HvoUPumCsaNjv1esA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qef5JcnYvdWHwNTCeUBmEKzY7xI30FIpbqspNJFM88ZJAMAY1t8AvQdsUqqzp9w5t
	 T2NJaIVFyY2zqVMdme7QAfQ+uMe5WbmkEMgG4d+ekFfxTGUhjD2Bvuapyqr5Tgv6kd
	 3Y3j7iFIXls9+d6/Knzl3gbsZjzlKKG5WO53FPQ2vUBZbWm/so5c8znRC840Dcuyc0
	 ZSzyvYwo7iWT07T4/9NAZ50E7ulWFGOjpb6PdV+SArOhDMmejPdVyy3xCVnIqD389F
	 AUdI3VfKNWFZgj3DkBiQy7PttuT0zqBwMgoxBI+SgZx1xwPliErJBdudAZ5XuIM3df
	 LQjKWKpRv3ZmQ==
Date: Mon, 15 Apr 2024 16:36:38 -0700
Subject: [PATCHSET v30.3 12/16] xfs: online fsck of iunlink buckets
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322385012.91285.3470147913307339944.stgit@frogsfrogsfrogs>
In-Reply-To: <20240415232853.GE11948@frogsfrogsfrogs>
References: <20240415232853.GE11948@frogsfrogsfrogs>
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

This series enhances the AGI scrub code to check the unlinked inode
bucket lists for errors, and fixes them if necessary.  Now that iunlink
pointer updates are virtual log items, we can batch updates pretty
efficiently in the logging code.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-iunlink-6.10
---
Commits in this patchset:
 * xfs: check AGI unlinked inode buckets
 * xfs: hoist AGI repair context to a heap object
 * xfs: repair AGI unlinked inode bucket lists
---
 fs/xfs/scrub/agheader.c        |   40 ++
 fs/xfs/scrub/agheader_repair.c |  879 ++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/agino_bitmap.h    |   49 ++
 fs/xfs/scrub/trace.h           |  255 ++++++++++++
 fs/xfs/xfs_inode.c             |    2 
 fs/xfs/xfs_inode.h             |    1 
 6 files changed, 1179 insertions(+), 47 deletions(-)
 create mode 100644 fs/xfs/scrub/agino_bitmap.h

