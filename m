Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AD5B645
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kk+dexcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9431C433C7;
	Sun, 31 Dec 2023 19:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704050736;
	bh=+6VVCXM4qTtoS5ai7TUCrkmcB7omg+/iMoLU6chBaqk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kk+dexcDKmz20TWDkHk3wU+qJg12tF2Vizq3gn+XNPuXRwOBjoKDU2IiBexzJlmro
	 tPGxsDOcKzvBZhHW/FKKAtTkVtL/1Z+XnD6Ej2f+eYUO+jP3HZwjrYmoMwAIPedqZh
	 WgFsgypd7nV4UwzF2K7ZcAcSvmZ04g/4ujRVRY1VmoO1BouplOLlbbFWL6YbXb5vAi
	 mXjvy7nBiC3Qkvh8IPIKh5aS9lLfNkir8ntnSk5Tz56pHUyo6ouTDjjzr/6YnyAPdW
	 yk3SuQWXAzvZYg94Tpbd8ydGPivQGJ5IwQWI18jlQHqwaNU7N/qa81A1KSHV5jL8Um
	 asU3zlKtZKPNg==
Date: Sun, 31 Dec 2023 11:25:36 -0800
Subject: [PATCHSET v29.0 01/28] xfs: live inode scans for online fsck
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404826492.1747630.1053076578437373265.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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

The design document discusses the need for a specialized inode scan
cursor to manage walking every file on a live filesystem to build
replacement metadata objects while receiving updates about the files
already scanned.  This series adds three pieces of infrastructure -- the
scan cursor, live hooks to deliver information about updates going
on in other parts of the filesystem, and then adds a batching mechanism
to amortize AGI lookups over a batch of inodes to improve performance.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-iscan
---
 fs/xfs/Kconfig       |   36 ++
 fs/xfs/Makefile      |    2 
 fs/xfs/scrub/iscan.c |  738 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/iscan.h |   81 +++++
 fs/xfs/scrub/trace.c |    1 
 fs/xfs/scrub/trace.h |  145 ++++++++++
 fs/xfs/xfs_hooks.c   |   94 ++++++
 fs/xfs/xfs_hooks.h   |   72 +++++
 fs/xfs/xfs_iwalk.c   |   13 -
 fs/xfs/xfs_linux.h   |    1 
 10 files changed, 1172 insertions(+), 11 deletions(-)
 create mode 100644 fs/xfs/scrub/iscan.c
 create mode 100644 fs/xfs/scrub/iscan.h
 create mode 100644 fs/xfs/xfs_hooks.c
 create mode 100644 fs/xfs/xfs_hooks.h

