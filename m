Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F057C6C1
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816374; cv=none; b=YS763kbNE1rP9D2QOevb7hhoC6zATPy6iEzvXsR3Wurg5QQ+/5f6CEKgv7RjGez9f5y/8f/aJDpVYyCosUv0nJlo3Pp4Spom92f+Fyfa44MxwC1u59y6epTZCnAAzD0oMmTPwtMYLPkxfsv82l/lqUe99gPtkS6udWjtxmlk5vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816374; c=relaxed/simple;
	bh=VyWdN0jjt6JgaT2t2yUFFeg/eYrQwu1omOrjd/x2kiY=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=QXe+cpjd4Tppd1iKn/n/oBN+G9oy7PVSisYCqQ17Oey4Q2yaM3VXyxg9cTebtuAr6yloaCbDHOLuBaU6JjS85O4ysQi0e4vfFETNul3yrhwaUo2Jwddma5mbMAVz8Z3t+UJEqq6X0LPze8rwqpu4YnLxqE10l9dcMYs7e/tjOOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OKmbHHc4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OKmbHHc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1105C433C7;
	Thu,  1 Feb 2024 19:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816373;
	bh=VyWdN0jjt6JgaT2t2yUFFeg/eYrQwu1omOrjd/x2kiY=;
	h=Date:Subject:From:To:Cc:From;
	b=OKmbHHc4pO1MZaRTm8kdAa+WkKqrAQKNmuzXg/ePpN0++DST2pjOAJP9MivLUYCPV
	 P97keAlv+4Gpqguhw2nyijc3wKNSqw3nRj/uM9vfKfRGqzldiTjvKho0ewTnAIzA3+
	 qcIV9fMmdWZexLFk0AYpYgb72lIpHnV6eCSVwl7wWYYzz8+sIdZK+W81x1eLvlVZWN
	 2vVJArQplBZxyxXw2PsTzYJlCZ78phPb0uBTzzFkx+xj8YI9YwS49AI+7Xq7cKpTTc
	 ljIyeQzWeHZYumF2V5r5BJ1ZBnPGlV8CYf1t6aFaXUMSmfLc3OCkt+200lLJ1a5sPw
	 fr6lMDYH2e/Mw==
Date: Thu, 01 Feb 2024 11:39:33 -0800
Subject: [PATCHSET v29.2 5/8] xfs: buftarg cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681336524.1608248.13038535665701540297.stgit@frogsfrogsfrogs>
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

Clean up the buffer target code in preparation for adding the ability to
target tmpfs files.  That will enable the creation of in memory btrees.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=buftarg-cleanups
---
Commits in this patchset:
 * xfs: make GFP_ usage consistent when allocating buftargs
 * xfs: remove the xfs_buftarg_t typedef
 * xfs: remove xfs_setsize_buftarg_early
 * xfs: move setting bt_logical_sectorsize out of xfs_setsize_buftarg
---
 fs/xfs/xfs_buf.c   |   43 ++++++++++++++++++-------------------------
 fs/xfs/xfs_buf.h   |    4 ++--
 fs/xfs/xfs_log.c   |   14 +++++++-------
 fs/xfs/xfs_mount.h |    6 +++---
 4 files changed, 30 insertions(+), 37 deletions(-)

