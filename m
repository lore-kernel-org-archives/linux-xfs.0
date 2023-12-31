Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A71B645
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N6k3LJpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43929C433C8;
	Sun, 31 Dec 2023 19:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704050815;
	bh=JHrTNXanW9BOlnGxnD9L3KuH5qNx3ERlxaac+TnZY08=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=N6k3LJpEwGiYqJJtn56PTl2P98kOwN90Rmsn6RShULw0vkLpC8PF+UQ5mkhe0En/L
	 IsOL2acNNslASD6+AvlhrTsGP506S8EAy3im7Xo2BvVhdKsdW00mdPn4LTmI4wQQLu
	 Xo5Eqm3oQxPBIiGzYasxKlNCdLBhs8H8ASMmTAzdrMtweMxIavNoGirNR3YrZVz920
	 o2VehRKhYOA4X57KRPeaOSRozixwA7+fbpzJzZFw43aTmPLqEUZCEEEaIBE8jVkRaO
	 hNLz7ln1D2/4Z/0t5eevCDWIvV/A6o62fBOi9g2dgvjOUgFjuASOtVUJqy0rtfgjOs
	 CiM+cE4FTN24g==
Date: Sun, 31 Dec 2023 11:26:54 -0800
Subject: [PATCHSET v29.0 06/28] xfs: indirect health reporting
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404828806.1748648.14558047021297001140.stgit@frogsfrogsfrogs>
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

This series enables the XFS health reporting infrastructure to remember
indirect health concerns when resources are scarce.  For example, if a
scrub notices that there's something wrong with an inode's metadata but
memory reclaim needs to free the incore inode, we want to record in the
perag data the fact that there was some inode somewhere with an error.
The perag structures never go away.

The first two patches in this series set that up, and the third one
provides a means for xfs_scrub to tell the kernel that it can forget the
indirect problem report.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=indirect-health-reporting

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=indirect-health-reporting
---
 fs/xfs/libxfs/xfs_fs.h        |    4 ++
 fs/xfs/libxfs/xfs_health.h    |   47 +++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_buf.c |    2 +
 fs/xfs/scrub/health.c         |   76 ++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/health.h         |    1 +
 fs/xfs/scrub/repair.c         |    1 +
 fs/xfs/scrub/scrub.c          |    6 +++
 fs/xfs/scrub/trace.h          |    4 ++
 fs/xfs/xfs_health.c           |   27 ++++++++++-----
 fs/xfs/xfs_inode.c            |   35 +++++++++++++++++++
 fs/xfs/xfs_trace.h            |    1 +
 11 files changed, 191 insertions(+), 13 deletions(-)

