Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB7A1E7C0A;
	Mon, 18 Nov 2024 23:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731970888; cv=none; b=aa1jFbbvCJR6SSVMERE073s92O4yyf/QA8USBRR+KFLlyskUOBJLO2KAdImFpgOIyabs305HXENv6pInkQpC7ld5iBcosoGpPx/nzbCTbP15zPnKuAdwbZqqDv8QmqcSrAOIrbT+2bvCl1vJpU/3/2ePfS8AbW6Bj4T29PSlYAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731970888; c=relaxed/simple;
	bh=8rBtGUaLn9fzY7hZzzdE571gYYsXALSfwybdG1Mkglc=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=hWpJow+ESyGtvi8Cqr6c+P0bHKgWOza1Yxc8QGBMojh3YtiK9MHmt6tpPSDPOAY2+0L75AMnJdkQSyt7CdZEhMnDkzeWBf9i5x/GHhrs9Ev2TSaKpMsxGW0NOQ3C2lRISuA/+qAl32aFr1+fJCTShrjAXMtVzSBOujDEu90PsgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hS05dhW7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hS05dhW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA50C4CECC;
	Mon, 18 Nov 2024 23:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731970888;
	bh=8rBtGUaLn9fzY7hZzzdE571gYYsXALSfwybdG1Mkglc=;
	h=Date:Subject:From:To:Cc:From;
	b=hS05dhW7cDpx5U4eruLWKFRFN3ZfAWmTBEUAr0r4CfpyEMmUsMm7kSO4CU2Jy1uKB
	 n9YRbvuuCcKi12aKeT/HD2mSlCJdQdsxESCzORxh9clRXPVmvuoHUe072lrhL4EVfY
	 kj5e7LlBPvOtph8WGfPUL6Z108+ZlU+d8A7tsYevO0P+GB7L+XvWryICNSzgC/QOlZ
	 wJltQ54kuwRESnDyCfhU/WvpbZtiejc+BeKVutPQBWQbBjqprzq2wEymol/Kn2Aicn
	 5eIhf3WHXzr1GUJ2sbN2UTyhNOqyugzrDSu3RCP7dXju+k3M1Tcn8bDWLMNyk7OV0h
	 nIv7r4qXWSnXw==
Date: Mon, 18 Nov 2024 15:01:27 -0800
Subject: [PATCHSET] fstests: random fixes for v2024.11.17
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: zlang@kernel.org, fstests@vger.kernel.org, hch@lst.de,
 linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's the usual odd fixes for fstests.  Most of these are cleanups and
bug fixes that have been aging in my djwong-wtf branch forever.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * generic/757: fix various bugs in this test
 * xfs/113: fix failure to corrupt the entire directory
 * xfs/508: fix test for 64k blocksize
 * common/rc: capture dmesg when oom kills happen
 * generic/562: handle ENOSPC while cloning gracefully
 * xfs/163: skip test if we can't shrink due to enospc issues
 * xfs/009: allow logically contiguous preallocations
 * generic/251: use sentinel files to kill the fstrim loop
 * generic/251: constrain runtime via time/load/soak factors
 * common/rc: _scratch_mkfs_sized supports extra arguments
 * xfs/157: do not drop necessary mkfs options
 * xfs/157: fix test failures when MKFS_OPTIONS has -L options
---
 common/rc         |   35 +++++++++++++++++++----------------
 tests/generic/251 |   34 ++++++++++++++++++----------------
 tests/generic/562 |   10 ++++++++--
 tests/generic/757 |    7 ++++++-
 tests/xfs/009     |   29 ++++++++++++++++++++++++++++-
 tests/xfs/113     |   33 +++++++++++++++++++++++++++------
 tests/xfs/157     |   30 +++++++++++++++++++++++++++---
 tests/xfs/163     |    9 ++++++++-
 tests/xfs/508     |    4 ++--
 9 files changed, 143 insertions(+), 48 deletions(-)

