Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347B0B667
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kKOPHbH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8759C433C7;
	Sun, 31 Dec 2023 19:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052379;
	bh=rQRjlbeGhQEVLdYwm1d02lUTHW7ZoQxplJAZbTrzf7g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kKOPHbH33NYk6pQtw17ZTdgTSsgP17pC/Gygfq1H1FxopyL7xa+brEptNeHCCD4KX
	 Q2ourfOdUhrx+K54z8yuQ/Wh7O6Uv2Oz+2qGgsMRkHSVYSQJtBc6SWPDN8D6cMTznz
	 LCLjRSDtP8wSVbdJe6FlLF8uvPquf8a3mRDHxNHj2i0fGgtWFC6SNC72rnyM75ZEUe
	 QXqJmKgcdlrdVWc+NHJ36/3pS1+zvRKp7+0lQA8MqMNXLY74jjOZaQa3HLvGOVgQ+2
	 8UVu86v+1KRN65VyN7lv/Hcutc8L6Cz1ST5Ubn9DzF+QhH1sKeqtBR6SwdWJCnIKYq
	 hsW+bY6XpYoOA==
Date: Sun, 31 Dec 2023 11:52:59 -0800
Subject: [PATCHSET v2.0 05/17] xfsprogs: refactor realtime meta inode locking
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405011748.1811141.16068744852666586384.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182323.GU361584@frogsfrogsfrogs>
References: <20231231182323.GU361584@frogsfrogsfrogs>
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

Replace all the open-coded locking of realtime metadata inodes with a
single rtlock function that can lock all the pieces that the caller
wants in a single call.  This will be important for maintaining correct
locking order later when we start adding more realtime metadata inodes.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refactor-rt-locking

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=refactor-rt-locking
---
 libxfs/libxfs_priv.h  |    1 +
 libxfs/xfs_bmap.c     |    7 ++----
 libxfs/xfs_rtbitmap.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtbitmap.h |   17 +++++++++++++++
 4 files changed, 77 insertions(+), 5 deletions(-)

