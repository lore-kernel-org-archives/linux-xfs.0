Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1F2188596
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992907; cv=none; b=LBsUe1TV6Zr3OeROwooSaChTVi5WJryNoYcdQX9+RfvfRNPlFZzVNlG+3zNQaIaeyumS3KjpUieGIxEesh/YfZS2oSysHhepCG/Vl7uKZp7dKKZhYt/O2rzeH7T70rjExWfK91mFcHT+Cet+7NWJxrj9nJFqq/fbkh9fLg2AV4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992907; c=relaxed/simple;
	bh=fbCjqVUtpEwp7HZRhbKCfXTSIuKkRK9CCDqdHa39u7A=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=cTGiMmF2lBepCpa7yCoWF2+KgmHFxdvCWcS2/p4+8RlVBEaSkVTLSxmG4eDQiqFLG2673xtDW/Fdrgj0fp9OPVuVK0lVszNxlbuhPXJJWqtU4n30Uew/rcza5xGS6ApN2JNETdC32xRjg+/abrwJQ67CWeg2apbQ9RUMiUK2I18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eEEe1TPu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eEEe1TPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5275FC4CED3;
	Mon, 23 Dec 2024 22:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992907;
	bh=fbCjqVUtpEwp7HZRhbKCfXTSIuKkRK9CCDqdHa39u7A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eEEe1TPuWNO70ewNdBvhGhCgtTAahCSeI77JqVYpyRcSA6fkfF8qgSmyH0lY79qN4
	 uilKrAdymDEX2gfRF1Ttd8XF+UDKOW5MJfhxlfzmzxK/v1k6hvppnAyIp0ayHdXNYO
	 o+l/pGIb64rav0PVhnyTXMPZCZb8tMT+sFp1zRbeMsUIG0iLMpbV9qd7LRBqJtPt2G
	 dQJtz9CxVrFlTHz7tFjIyGMAe9gAARbwpaMycQ94ePItnJtKMhHB/oUfo1sTCQYZYU
	 /YAd1gSE9j1h8GhcYqvgwDEmoJkG98EVZlVJ06kCUJK+GLHFPqb+zv9lLnkuqB4a1v
	 fTI5bhURfsRYA==
Date: Mon, 23 Dec 2024 14:28:26 -0800
Subject: [GIT PULL 4/8] mkfs: make protofiles less janky
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498954369.2301496.13273620410007793210.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241223212904.GQ6174@frogsfrogsfrogs>
References: <20241223212904.GQ6174@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.11-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit cbb4fe589532389c8ae6a4e3018707d493b8c5f3:

mkfs.xfs: enable metadata directories (2024-12-23 13:05:10 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/protofiles_2024-12-23

for you to fetch changes up to 513300e9565b0d446ac8e6a3a990444d766c728b:

mkfs: add a utility to generate protofiles (2024-12-23 13:05:10 -0800)

----------------------------------------------------------------
mkfs: make protofiles less janky [v6.2 04/23]

Here are some minor improvements to the protofile code in mkfs.  First,
we improve the file copy-in code to avoid allocating gigantic heap
buffers by replacing it with a SEEK_{DATA,HOLE} loop and only copying
a fixed size buffer.  Next, we add the ability to pull in extended
attributes.  Finally, we add a program to generate a protofile from a
directory tree.

Originally this code refactoring was intended to support more efficient
construction of rt bitmap and summary files, but that was subsequently
refactored into libxfs.  However, the cleanups still make the protofile
code less disgusting, so they're being submitted anyway.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
libxfs: resync libxfs_alloc_file_space interface with the kernel
mkfs: support copying in large or sparse files
mkfs: support copying in xattrs
mkfs: add a utility to generate protofiles

include/libxfs.h         |   6 +-
libxfs/util.c            | 207 +++++++++++++++++++++++++++---------
man/man8/xfs_protofile.8 |  33 ++++++
mkfs/Makefile            |  10 +-
mkfs/proto.c             | 269 +++++++++++++++++++++++++++++++++++------------
mkfs/xfs_protofile.in    | 152 ++++++++++++++++++++++++++
6 files changed, 557 insertions(+), 120 deletions(-)
create mode 100644 man/man8/xfs_protofile.8
create mode 100644 mkfs/xfs_protofile.in

