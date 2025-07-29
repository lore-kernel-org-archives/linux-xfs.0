Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3B71E51F6;
	Tue, 29 Jul 2025 20:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753819709; cv=none; b=BRo2yzY2TluiiWU9uUqE7yHmj7lBcHMh42NB4b5FjRpyeWF5ashPTthPg4HAx9SNC2yRMvaCUZml0UsCVdZ5zNZOfS28ZywHnOq0RurwIWwedGVpQDBTLWYGIFtpBF6ugImMjCasUXijFdSPjyNwr6GWhrDgf5INABJUnMF4K1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753819709; c=relaxed/simple;
	bh=fsWjrguQEbFLlD+9NMF3vDmIOfUZC+wQaxyCMqZPVHM=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=gKlyMBG2GzWWbTUAoQFj0sX4OW+PtW7iLkMYkcHvVA2mo00XoOxDearz3d7V3Q+KDNFYveTK1++xHIvdzYk0LUNkLTPgmniHppN1I+i+9RbMoBZsXrXJrwdF5aaIbX0ag+lCuXD+PbNIMnAIwyF2tttEk/CbI5oCO+Ttf9OXTSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TxbKeCNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TxbKeCNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1B5C4CEF6;
	Tue, 29 Jul 2025 20:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753819709;
	bh=fsWjrguQEbFLlD+9NMF3vDmIOfUZC+wQaxyCMqZPVHM=;
	h=Date:Subject:From:To:Cc:From;
	b=TxbKeCNIMZBoQVaoAONI8RCPYUiKisWmJpPWeUqsGrPqODXsojrXF8pVr1Swj0bro
	 HvlMMpemsGP6VDtfhLaOtmsaGzf5pxgXTwy2SfOEjpBA03hoOpN/chu9DUTGBB65ny
	 iar0oG5J71BvL8Hzp3j5yaUCvW0o/BXO8qhiWXMrMIyBqNbGJrQu7oF6qxARa1tJOw
	 jaBHwiCab+K3y2fyGAHOxF7rw/NXPMjhzmgJSqQUmzLD0kpdAqGlGzBtv2VGtYecRo
	 OpDiix1CDsdK4zoonU6Bp9FJ3BHEv7nnGXkvYt9flDoFF8dulyFyS/u4mOf8idpO9g
	 x/hfZztaSyl4A==
Date: Tue, 29 Jul 2025 13:08:28 -0700
Subject: [PATCHSET 1/3] fstests: fixes for atomic writes tests
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a pile of bug fixes for the atomic writes tests.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=atomic-writes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=atomic-writes
---
Commits in this patchset:
 * generic/211: don't run on an xfs that can't do inplace writes
 * generic/427: try to ensure there's some free space before we do the aio test
 * generic/767: require fallocate support
 * generic/767: only test the hardware atomic write unit
 * generic/767: allow on any atomic writes filesystem
 * xfs/838: actually force usage of the realtime device
 * common: fix _require_xfs_io_command pwrite -A for various blocksizes
---
 common/atomicwrites |    6 ++++++
 common/rc           |   14 +++++++++++---
 tests/generic/211   |    6 ++++++
 tests/generic/427   |    5 +++++
 tests/generic/767   |   19 +++++++++++++++----
 tests/xfs/838       |    1 +
 6 files changed, 44 insertions(+), 7 deletions(-)

