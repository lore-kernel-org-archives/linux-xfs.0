Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17998B65D
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c52qaYFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85048C433C8;
	Sun, 31 Dec 2023 19:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051050;
	bh=7a3qyFv8Gzl3ZuRCQAGmF1ybpXdmTEsMgxbmR6dD9Lo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=c52qaYFN8sFL/I5gdtPNTZ64Hq1hO4hKlI99QJ3EL6btTt7SYts1HojThVZqT7bAq
	 J8tXMZIKFPHecoVfMl9n+E5oLd8SLdhaknveXA5Zjn6grNGn+lg9Id2LybpveL/q8K
	 /by+0e7XLIomNAzaIBTA5s/wKKyRH3ARRW62GNg4NUYCLVDFn6tgofJiDJzzOSRS9Z
	 ICjSKmfzcXgt/yfzycJxXcRBtZx43FEvgIops0rmWoKK9QjKVDd4ngpBAZgSc5zUOi
	 DSDuPMRTwUdSa2K++VfybR5E38nQsoZYN9ckQVnOGHvrW0XxvQbvKCH3eXd3ahhHy/
	 gHKCGg2upUX/g==
Date: Sun, 31 Dec 2023 11:30:50 -0800
Subject: [PATCHSET v29.0 21/28] xfs: online repair of inode unlinked state
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404835635.1753516.7102734968917257897.stgit@frogsfrogsfrogs>
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

This series adds some logic to the inode scrubbers so that they can
detect and deal with consistency errors between the link count and the
per-inode unlinked list state.  The helpers needed to do this are
presented here because they are a prequisite for rebuildng directories,
since we need to get a rebuilt non-empty directory off the unlinked
list.

Note that this patchset does not provide comprehensive reconstruction of
the AGI unlinked list; that is coming in a subsequent patchset.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-unlinked-inode-state
---
 fs/xfs/scrub/inode.c         |   19 ++++++++++++++++++
 fs/xfs/scrub/inode_repair.c  |   45 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/nlinks_repair.c |   42 +++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_inode.c           |    5 +----
 fs/xfs/xfs_inode.h           |    2 ++
 5 files changed, 100 insertions(+), 13 deletions(-)

