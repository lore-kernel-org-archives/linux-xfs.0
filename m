Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA3FBA34
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hlwK/eHE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E2DC433C8;
	Sun, 31 Dec 2023 19:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052551;
	bh=7fsrvM4yi2IMovI1mGkMB4ZHIhFcr1SsHTVBFmuydqA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hlwK/eHE3yXNSrFBpOLku0AbkMZKLoEICjx7EVCCy9PPGoylZ5P5dei0v7rwcTTNc
	 4qAzAH25m6wQXJKrceCXpoiXuD/XqKntc7mNmqrqt94F/t/rl+AjUStthcSlNtVoVy
	 bHQLSR59HoVEZhKKkUgwHvgOnPgs+x9YWH1gQ2UhXPUUzsj15iqrW8FZ4WPV27VYnE
	 k0XadduxMHwZEHN+YEjbbYrrdP/TLWL6e+jE6tF2m20J61QUYTJLo0hMX3w4e+zq4w
	 J8SOw+OOY1GzITAMOXl+LfqvIeihArVW8xiLwVNfDj7N0rS2slRRr0Hc4e/28WFwiL
	 lWIcXo2Wdl5aQ==
Date: Sun, 31 Dec 2023 11:55:51 -0800
Subject: [PATCHSET v2.0 16/17] xfsprogs: reflink with large realtime extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405018010.1818169.15531409874864543325.stgit@frogsfrogsfrogs>
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

Now that we've landed support for reflink on the realtime device for
cases where the rt extent size is the same as the fs block size, enhance
the reflink code further to support cases where the rt extent size is a
power-of-two multiple of the fs block size.  This enables us to do data
block sharing (for example) for much larger allocation units by dirtying
pagecache around shared extents and expanding writeback to write back
shared extents fully.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-reflink-extsize

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-reflink-extsize

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-reflink-extsize
---
 libxfs/init.c          |    7 -------
 libxfs/xfs_bmap.c      |   22 ++++++++++++++++++++++
 libxfs/xfs_inode_buf.c |   20 ++++++--------------
 mkfs/xfs_mkfs.c        |   37 -------------------------------------
 4 files changed, 28 insertions(+), 58 deletions(-)

