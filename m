Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46188B652
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294580; cv=none; b=oYU/33ouWkdjkjiLqsa2K9MMun1j8G72kjHRSJHS5kTn6wkefrVDD8S0hO7pkEHDaN2J+Un5dz9Xs3W1JHRWfPMnhnh5W67ZRl1/7DiAdJy7HwYAvVq+kdlrJ+8PeEQzKL3/eD+SXn7cVkuQ2Uz5KvLgcVjABvTSx7J9NUvk0Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294580; c=relaxed/simple;
	bh=Uo1GMwtkGzXnsdQTgd4OgIJRf5fYx32nRDX7svI+sLc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EhIXKk5GZFoon8TN7+EMb1PMuXXwVUzAB+iOtj0luAyM18ASsatKzilFKgSjNFJmD0oFSNqMqzmOQq49qmiNLnf84mwYs2YyiLxC6vZvTpnLnFZSE+mSHQLyuJ9rq9NcnRRf0dUyMooKlgct5nASXCimUAJUJ//4NBKqxm21hFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ufWS2w1i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ufWS2w1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB30C433C7;
	Wed, 13 Mar 2024 01:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294580;
	bh=Uo1GMwtkGzXnsdQTgd4OgIJRf5fYx32nRDX7svI+sLc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ufWS2w1iqjoJwR3a5bPgGmmDX6doN1q5sLsueA8bDkolg4WfO2yxsApestDjHcSI4
	 ou7tbkx0Ybwe2rZlPSO3DWzUJC5QbvlJ5BpNbk7cgbQuApSoPHblVlcLZ61mnmfLkJ
	 IiT40epQHqJvg9EEAHIXDTBfGmIm+U8K7XCdrbHilV4fCG22kD+fdNeyP6rTD3vc2W
	 /kW38mjong1/1mW5M7BGhDgvL6rZHaZF5sKggRwDQkC2iqDTm4mwx01BedTVqRIhZl
	 2l0PCCzm4RogZyA+BWDTNVYaxQykJbkipt3ZbMITYTLVrvcs2U7VpfUMGhTy9IujC3
	 R8827ZQMI/xdQ==
Date: Tue, 12 Mar 2024 18:49:39 -0700
Subject: [PATCHSET v29.4 10/10] libxfs: prepare to sync with 6.9
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029435171.2066071.3261378354922412284.stgit@frogsfrogsfrogs>
In-Reply-To: <20240313014127.GJ1927156@frogsfrogsfrogs>
References: <20240313014127.GJ1927156@frogsfrogsfrogs>
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

Apply some cleanups to libxfs before we synchronize it with the kernel.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-6.9-sync-prep
---
Commits in this patchset:
 * libxfs: actually set m_fsname
 * libxfs: clean up xfs_da_unmount usage
 * libfrog: create a new scrub group for things requiring full inode scans
---
 io/scrub.c        |    1 +
 libfrog/scrub.h   |    1 +
 libxfs/init.c     |   24 +++++++++++++++++-------
 scrub/phase5.c    |   22 ++++++++++++++++++++--
 scrub/scrub.c     |   33 +++++++++++++++++++++++++++++++++
 scrub/scrub.h     |    1 +
 scrub/xfs_scrub.h |    1 +
 7 files changed, 74 insertions(+), 9 deletions(-)

