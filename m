Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA241FF7B4
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 22:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738621839; cv=none; b=LGbsJP+d/m2Hjsvbpy/vuBHrvIG67O/a00L2eZZNOGBTfNYkTIiu/Wnu3GVQQU7iVd4KM7bwFn3EuMjwcWGLb146L+mi5Yug7Cb6LloHMxmrNQKIfrMvHRIbhyqs8rDn2PtKl4FvhlZgbE0TJ/W2PoBqPhk3SqplNlHXh85qsEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738621839; c=relaxed/simple;
	bh=WexICuABYHyzbaYcmu/ADLDbgCAXeGxHkDJEGSKD7rw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=uK1JfByr8/0G5eEHd14Ld4DXH09FrSFP1MJKdTUBu6pPOqF5Ymo8Iakr2Sh3ZRhGlIbM/QBVtVXHT+PZ7Atvl+R4PkqJPuudvI94yZBFNY3Bz5r672/wj3U6ocvvxsd+gN8EU3X8Kcm2WLg3kMbiZ7MtlPp7XoUCLN6KPMHkV7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DiOEvPmU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DiOEvPmU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C5CC4CEE0;
	Mon,  3 Feb 2025 22:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738621839;
	bh=WexICuABYHyzbaYcmu/ADLDbgCAXeGxHkDJEGSKD7rw=;
	h=Date:Subject:From:To:Cc:From;
	b=DiOEvPmUNWAMBhXqlCRdIVd8r5KdwlIcDgiv8CHaEnvA1MiO9fOoVlEKlbLgJY1qH
	 pd3wzfbOp1McYZIuC/nkViymC8Oh4TEkkKsONVJ/I2sVVk+ncR7TdC2i4ntE8zgl0E
	 obh8Anz0J3IllgT5WEjSheR5bD9zuFV8xyNk0xJrJ2QeMcrbsLmofVvRyftLMkqkt9
	 Cj0CuCL1KKshWJMCb+dV5vPiJf9xxnZGNCOb+G9K5+oCWMuzvU9Ix4u9tJrEe/AIdG
	 +e4Qt6+lHQdiHusfwFKyqptcddC8+ZSSBMF7DR6m05NCEp5p9Y1hzlXlxCI6Crmnhz
	 9khZg7dU0rKYQ==
Date: Mon, 03 Feb 2025 14:30:38 -0800
Subject: [PATCHSET] xfs: bug fixes for 6.14
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, david.flynn@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <173862180286.2446958.14882849425955853980.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here are a couple of bugfixes for 6.14.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fixes-6.14
---
Commits in this patchset:
 * xfs: fix online repair probing when CONFIG_XFS_ONLINE_REPAIR=n
 * xfs: fix data fork format filtering during inode repair
---
 fs/xfs/scrub/common.h       |    5 -----
 fs/xfs/scrub/inode_repair.c |   12 ++++++++++--
 fs/xfs/scrub/repair.h       |   11 ++++++++++-
 fs/xfs/scrub/scrub.c        |   12 ++++++++++++
 4 files changed, 32 insertions(+), 8 deletions(-)

