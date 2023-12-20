Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33FE4778C
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 17:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mDolyc76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA1BC433C7;
	Wed, 20 Dec 2023 17:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703092286;
	bh=PPO+3yLGAxMm8A4ioCAC+3bGmKHHFba7N81TjYela6M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mDolyc76uMOIns1S6Hvvw7g7QXC/ioH1+h5RLI585buwdWatV5iqDkxrmrfkMPMHx
	 nVXSGvD8gxZVh/MmjaRJaBn/o75fZmUnPDBAEo6ZQVyVqW7VqM15M5DQAOBW50PNcU
	 ngCwv5st+iRc6xr1FchBqjCSnlSwkHxe5G/9qIR1JWcyL+A/SDOT4B4FZuL4tGXNSG
	 Tyf2c4uSVLFBbxHeEx+YEdP+J5giC0/9c9H2fUMIqnsEaSTTnsZl65MpPHG4pRY8pp
	 DsR8vm788UdCPS2/VGHHGLIvT5QnABI2Fxh0J+aIkvseCIBSFVHmh6YWXWJ1M3aSNT
	 aSbMFqvWpMuXQ==
Date: Wed, 20 Dec 2023 09:11:25 -0800
Subject: [PATCHSET v28.3 4/4] xfsprogs: force rebuilding of metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Carlos Maiolino <cmaiolino@redhat.com>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <170309219443.1608293.8210327879201043663.stgit@frogsfrogsfrogs>
In-Reply-To: <20231220170641.GQ361584@frogsfrogsfrogs>
References: <20231220170641.GQ361584@frogsfrogsfrogs>
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

This patchset adds a new IFLAG to the scrub ioctl so that userspace can
force a rebuild of an otherwise consistent piece of metadata.  This will
eventually enable the use of online repair to relocate metadata during a
filesystem reorganization (e.g. shrink).  For now, it facilitates stress
testing of online repair without needing the debugging knobs to be
enabled.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-force-rebuild-6.6

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-force-rebuild-6.6
---
 scrub/phase1.c    |   28 ++++++++++++++++++++++++
 scrub/scrub.c     |   61 ++++++++++++++++++++++++++++-------------------------
 scrub/scrub.h     |    1 +
 scrub/vfs.c       |    2 +-
 scrub/xfs_scrub.c |    3 +++
 scrub/xfs_scrub.h |    1 +
 6 files changed, 66 insertions(+), 30 deletions(-)

