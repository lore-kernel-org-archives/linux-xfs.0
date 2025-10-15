Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1A3139579;
	Wed, 15 Oct 2025 16:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760546213; cv=none; b=vACQP4iJf8oyiznr94nQPp+K6/iLCimzVRTOC0sLuKPHJ4O7rbyo+i5YM5tY0PVihlEyddwwyKFxI1bby7Zz+Mc2Z8vx+YjlHb1z8XbXeqLaf4/Kw8l0ll8KYWE6w1jfP3mqy1AZfKVXAlPIQBjg2q9xKDbOeZg1SgpxL5R9xhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760546213; c=relaxed/simple;
	bh=rfIFeF4rFeWLB9MxTDixDmUWQRXHW4Ts2NeB6IAAXQk=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=sXbcOwz9XhSHQH9ITiECufN6iA8wZyxy99nuQc7bDYVCSWv66DQgl1WGVi2FXu7l94TxgmgiolG98Q7FAZiL2IUPvnM+qguIjuC0qSi2hPIO4s4Qia17C7qT+snqJ44NAQPyhiJjCIqTXw2xrQiGJG6DuJveiPYvSkiGB/Nsy3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ovWU6o5W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ovWU6o5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26851C4CEF8;
	Wed, 15 Oct 2025 16:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760546213;
	bh=rfIFeF4rFeWLB9MxTDixDmUWQRXHW4Ts2NeB6IAAXQk=;
	h=Date:Subject:From:To:Cc:From;
	b=ovWU6o5Wq2Kf3LsI5MnTffNHKiRNHCNGPUoTKUoTyJkdovq6/Qkx0gVG5e9n7/nn5
	 fZGOmydDvPcSytrfsN0KglXzK4pzQLJCnfpm5+jMSXp7wjx107oXATnnYUp7GOMn/U
	 9WIbxZOui+9LOXRaQ3d0Xwx3o2ajoQcFExgr07NnCr3KWBrJ/cRIQw/diqjCR5dEaA
	 Ta3WJ8dUpQQOlC8e2uUks5RBOIPxyZJPIQKBB3mPrLLZTKi7eyeHo0X+Fh8eypjIdT
	 Sqsn4fpMC/vJf7y/ocyoIgXr+LXQHAqv6+QEa5VVZH6yak6qVUFLD0Fu7urZhPLZcz
	 PvQkZwU02Z7rQ==
Date: Wed, 15 Oct 2025 09:36:52 -0700
Subject: [PATCHSET] fstests: more random fixes for v2025.10.05
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's the usual odd fixes for fstests.

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
 * generic/427: try to ensure there's some free space before we do the aio test
 * common/rc: fix _require_xfs_io_shutdown
 * generic/742: avoid infinite loop if no fiemap results
 * generic/{482,757}: skip test if there are no FUA writes
 * generic/772: actually check for file_getattr special file support
 * common/filter: fix _filter_file_attributes to handle xfs file flags
 * common/attr: fix _require_noattr2
 * common: fix _require_xfs_io_command pwrite -A for various blocksizes
---
 common/attr        |    4 ++++
 common/filter      |    3 ++-
 common/rc          |   21 +++++++++++++++++----
 src/fiemap-fault.c |   14 +++++++++++++-
 tests/generic/427  |    3 +++
 tests/generic/482  |    2 +-
 tests/generic/757  |    2 +-
 tests/generic/772  |    3 +++
 tests/xfs/648      |    3 +++
 9 files changed, 47 insertions(+), 8 deletions(-)

