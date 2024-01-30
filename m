Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FE0376EA
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591015; cv=none; b=mA1rtGZNeq77F6xOzhu4MKzS5L0gaCO2xDLBGx86eK9zGnPQRxUBoHEAXbyKo8iDd49qmMvQ0+EpAk2+NqTXnVwThifppjNnFgqW25DcSiETZZyFI3CenXfPwsRJ2UiQRwsVtiOZJI1fLqjr8WA37+mD3SfNNVJyUkDLHrqeWtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591015; c=relaxed/simple;
	bh=Mo0quDsCFFwMKIE/EEMZmcsQqzHDgP9gsVkeDpPXe7c=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=gVLjmarW/msCXcdLpo2vp+BQDsnYpnYJYVcQS+jMuYrR8oJWpsf69iSG52fMjqMWHZtUBbGvJFSBq6B6sMi5v6At8O2zRtR50tx87Nw/tQ739y1vqPYdxSJK9gSZAYuYgBA9Yk9tXnX3mTdIVihB2Cs0j9Mteq2BP9jivUA1/oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rwm90Qf3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rwm90Qf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3EAC433C7;
	Tue, 30 Jan 2024 05:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591014;
	bh=Mo0quDsCFFwMKIE/EEMZmcsQqzHDgP9gsVkeDpPXe7c=;
	h=Date:Subject:From:To:Cc:From;
	b=rwm90Qf31WsM/X8exT+M41LpwnfqrZyGxC3pGwQRvejoyrlW5BmT+ZsJER4S8UhUj
	 9UbmNrL5RfWXPnAOG41Q3XnqKG/xUFGQQbpG6GAeN6lCa//ByN5tLNk0TCI5NvpJVu
	 p76c2T9KFf2Oc4lyCD0XUEuWJp1T2DoLfmgnbZZxs9p1emGdcSVqd34Dnmb731uRxD
	 FpfOSWzM1PkMYChUINzRfsHG6utQzDSBijTAmRsj9oDoB8H/wonh98cmjCc8sqkR8r
	 VnTUB+KpsGq131ax3F1Qmsyjdufi5Nu/0Zb1feJHuSdr8DepkVcN1ZuR2dnN5r1PvI
	 LBzzbhVSqRzcg==
Date: Mon, 29 Jan 2024 21:03:34 -0800
Subject: [PATCHSET v29.2 6/7] xfs: indirect health reporting
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659064262.3354229.596649174411799386.stgit@frogsfrogsfrogs>
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
Commits in this patchset:
 * xfs: add secondary and indirect classes to the health tracking system
 * xfs: remember sick inodes that get inactivated
 * xfs: update health status if we get a clean bill of health
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

