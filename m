Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA911433D5
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992860; cv=none; b=MuPhkmnXXK4RhgdJg34qPwoM1x/EnJ/4ficFW8+r2z1ioymKessBEWozYgMcQe7MLKcVT1HxlYVq6LfSyD2lylGS7D89Pga1+dzaz5r9J7VTuo/eLRmcEySpD9EZ/xPMAhgnqGLlwsTbTaE/xVFvgN3ZqN5FSflZRFJByvE2Qt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992860; c=relaxed/simple;
	bh=IMPtteFBW2JORIBr7BkSz7wy3ScLQMs7IAtYMxkB+NU=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=axFSOv9bmS5LQkH8IsRGpOAc8SHnIOb6ERKguB5ddb2ABRuNS1J3Te55bCRwONCnO2lo276utJFARcY0QTs4uRL/563otaTs67TmuG9EMXCfrmDYVWlaMYCZYMiXat9DZU3+Ywbo/mQqjoTIe+BSEzNmX5aDQJQ5GFSpB6B4+jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ApDzQzK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ApDzQzK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80870C4CED3;
	Mon, 23 Dec 2024 22:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992860;
	bh=IMPtteFBW2JORIBr7BkSz7wy3ScLQMs7IAtYMxkB+NU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ApDzQzK2iJassxJwmwdOlY+DrDq2Fp24rk5+UamwJ6y2iKK3d17QUAenpF69NKG0x
	 bAbOV0aW2CmWrIZlVJtS+9YO5mKwo1tNcv+9+EfeSa3QTK0N1WNbc7uwB9LBlUg4Ee
	 WsXn8A5SRlG22RsXFPMGVjkUpnNsMsqmXBqNDzxMxm0quILYRPbeI6N/OcNzAVwNQe
	 qTLpNum7TBynhnVuXeBcoue4QXHUBHsijcp+lO9d2lDknUPFIx0RcWInV7LYq37MdL
	 3pkmNe5JXaLPFEK0sA10ZJCH4YOx5XebCkTptoSogWTR/M2LXP8jCxWos67HduYkLh
	 zBdThOA04uQAQ==
Date: Mon, 23 Dec 2024 14:27:40 -0800
Subject: [GIT PULL 1/8] xfsprogs: bug fixes for 6.12
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, jpalus@fastmail.com, linux-xfs@vger.kernel.org
Message-ID: <173498954095.2301496.13379830574839883381.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241223212904.GQ6174@frogsfrogsfrogs>
References: <20241223212904.GQ6174@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.11-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 409477af604f465169be9b2cbe259fe382f052ae:

xfs_io: add support for atomic write statx fields (2024-11-21 14:43:58 +0100)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/xfs-6.12-fixes_2024-12-23

for you to fetch changes up to 50e3f6684fe5adb4138ec5882b316c00524a6051:

man: document the -n parent mkfs option (2024-12-23 13:05:06 -0800)

----------------------------------------------------------------
xfsprogs: bug fixes for 6.12 [01/23]

Bug fixes for 6.12.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Andrey Albershteyn (1):
xfsprogs: Release v6.12.0

Darrick J. Wong (2):
xfs_repair: fix maximum file offset comparison
man: document the -n parent mkfs option

Jan Palus (1):
man: fix ioctl_xfs_commit_range man page install

VERSION                           |  2 +-
configure.ac                      |  2 +-
debian/changelog                  |  6 ++++++
doc/CHANGES                       | 21 +++++++++++++++++++++
man/man2/ioctl_xfs_commit_range.2 |  2 +-
man/man8/mkfs.xfs.8.in            | 12 ++++++++++++
repair/dinode.c                   |  2 +-
repair/globals.c                  |  1 -
repair/globals.h                  |  1 -
repair/prefetch.c                 |  2 +-
repair/versions.c                 |  7 +------
11 files changed, 45 insertions(+), 13 deletions(-)

