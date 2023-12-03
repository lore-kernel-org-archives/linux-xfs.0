Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633B92FB3
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 19:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KNxYreEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03AAC433C7;
	Sun,  3 Dec 2023 19:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701630046;
	bh=fm9fP5gLxag7gI+22YJCFM2igyW8z/jzPeisfDXFBTk=;
	h=Date:Subject:From:To:Cc:From;
	b=KNxYreEGaSIDUaiSn0MlFs0WpX83LG1Etg+euXS/nRlYm9Ndsa7e++E77TlmUgSPU
	 RNcayHrLiUoRLVH1OfkUq9/gH04OyzabWTwzD5Gmdx+pZYessQfuvc+zpBwHTadwUN
	 CIH8+E5/wdT51rvZ8uXL0bqAXHcyp1CY6Z8HPp/N+6KxttmwAc3aK1crN9rBzU2kDm
	 aO+XKtYIjGgB8mxK11KgKZ05izc/ZASPjXRLqyWgAW8DcU5W+N6zApQFLBq6tBpzop
	 qepmDXOVZRAiTvOZfwJ6gykSTIFfqR9eR8S8WKPiuUVU4gDCgcg+4vh/6Yr0lPtdwY
	 AnHAmFmNpopJA==
Date: Sun, 03 Dec 2023 11:00:45 -0800
Subject: [PATCHSET 0/3] xfs: fix realtime geometry integer overflows
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <170162990622.3038044.5313475096294285406.stgit@frogsfrogsfrogs>
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

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-rtmount-overflows-6.7
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   12 ++++++++++++
 fs/xfs/libxfs/xfs_rtbitmap.h |   14 ++++++++++++++
 fs/xfs/libxfs/xfs_sb.c       |    6 ++++--
 fs/xfs/xfs_rtalloc.c         |    6 ++++--
 4 files changed, 34 insertions(+), 4 deletions(-)

