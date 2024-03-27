Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737B818C36
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504026; cv=none; b=ptVpAI9sXHKALQEejXRFSmpKTbZw6dTk54/4XKZLpZ2IlNMPCAMQmYE/w9Tqo0r/hsxx2PrAqTSRh0viy0OicLwlcgIKq5HaNU1zuR1SN6Z/FO0JvQPrhzOl6MNR+Xi99uhBcHlV0cvAHi0EbPfMmS4tkW+f6pchbYuaxnhgCF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504026; c=relaxed/simple;
	bh=hUd52lpDHs06ciCStsdcRdKUFk+rqIsqdbZmalOyjI8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GFG4GGB6Q1R+5S+9QvYt8EBMrO86jHs7Up3JyTtoBjPUzX6q/XJ7koK4oWQFtjnTYxa545ysM4vaKFyIJ/ct87JRiIT+Rx/c2+qVxhRoeIqjXFcpus9xJ3GcS9OYUdfwigJVdIpKzBLdiMCfxoO8Usu2zi1GHGGi6mr+0rFOTcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bTXGVvve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bTXGVvve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00343C433C7;
	Wed, 27 Mar 2024 01:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504026;
	bh=hUd52lpDHs06ciCStsdcRdKUFk+rqIsqdbZmalOyjI8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bTXGVvve3WR+3tIAMBNchGa/JarlwyW4CPnYzq1gc+hATVtPbIuySWRuXiFMyu1V+
	 bucDaKH1WU7fuZFm6D/zRIb8YBDF18I5/gWSJ5aSsYjOHzmLjV4TXh80CjLcRY/Ia1
	 86KzbyTEw0hjA+ZtxMfI5Q5RAyufvRgtN0XvVkfcUKIpWZvrgZdx5ETO7DhO5ssg8w
	 Slb/rR9UfirBO55oPUK8G+B7IRNACNhcCpLZ0dHTlk8EeuZPWcZCIplUblKxz4QOro
	 2DPbk7nJv4Ku2MMsIO5Jo/ZDlr1+qtJl1waXWMuAxNGv9dm7IsnchXkqKcqpQTKnRW
	 3AiMWlPUHHFIA==
Date: Tue, 26 Mar 2024 18:47:05 -0700
Subject: [PATCHSET v30.1 03/15] xfs: refactorings for atomic file content
 exchanges
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150380117.3216450.660937377362010507.stgit@frogsfrogsfrogs>
In-Reply-To: <20240327014040.GU6390@frogsfrogsfrogs>
References: <20240327014040.GU6390@frogsfrogsfrogs>
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

This series applies various cleanups and refactorings to file IO
handling code ahead of the main series to implement atomic file content
exchanges.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=file-exchange-refactorings

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=file-exchange-refactorings
---
Commits in this patchset:
 * xfs: move inode lease breaking functions to xfs_inode.c
 * xfs: move xfs_iops.c declarations out of xfs_inode.h
 * xfs: declare xfs_file.c symbols in xfs_file.h
 * xfs: create a new helper to return a file's allocation unit
 * xfs: hoist multi-fsb allocation unit detection to a helper
 * xfs: refactor non-power-of-two alignment checks
 * xfs: constify xfs_bmap_is_written_extent
---
 fs/xfs/libxfs/xfs_bmap.h |    2 +
 fs/xfs/xfs_bmap_util.c   |    4 +-
 fs/xfs/xfs_file.c        |   88 ++++------------------------------------------
 fs/xfs/xfs_file.h        |   15 ++++++++
 fs/xfs/xfs_inode.c       |   75 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h       |   16 +++++---
 fs/xfs/xfs_ioctl.c       |    1 +
 fs/xfs/xfs_iops.c        |    1 +
 fs/xfs/xfs_iops.h        |    7 ++--
 fs/xfs/xfs_linux.h       |    5 +++
 10 files changed, 121 insertions(+), 93 deletions(-)
 create mode 100644 fs/xfs/xfs_file.h

