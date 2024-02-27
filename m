Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC39200DA
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000275; cv=none; b=no/LqcmDlNhBt14BlGzDsrIBXEuzBr5d0Wor0OOaCz2oeVE3pg/y4jhcjPo+YQ5FCwFJplP/slNjSBRzcIqo5AETv9qcyHKXBzR3xPrAJd0s1pfkGngYjCE3O7tXKOnNEF3oWQ0DXX2FLRoUgmbdfsZLtXVMzcXr8HOMAgjwbuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000275; c=relaxed/simple;
	bh=YYEB9HQb0TMKQD4E2dOJKQw2NqjiFXFHvfXBSnqF5Lg=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=EowWmfoRwyBHbKoUbevifTyUA3XNJbFhUO1FL1DS4JQyXyo+C2b7/zpHvNs3UKCto9GUkbVAx2yv5vx2lQvewJf1imIMwp17MKrmTPzCBISqZgRFz6wrMFZF/A0bYdgw8D/PyeNsAJpp13+94iwST/IT1pe+q5LC0KOjiePVULU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s2ymyP+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s2ymyP+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3277EC433F1;
	Tue, 27 Feb 2024 02:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000275;
	bh=YYEB9HQb0TMKQD4E2dOJKQw2NqjiFXFHvfXBSnqF5Lg=;
	h=Date:Subject:From:To:Cc:From;
	b=s2ymyP+LlX6yTCxgirdi9f9JdF7BF26YAgcGp3FjLwj2LfiGxScGddm0jnEuq4Rps
	 xbG3LxO9PIXFGMqI8rJ3S1VO8pRK07rc7bWbwdig0sV/gsC3vePI3R30e0th5Wr0z2
	 OqpqoOt32kW3+zGGKI9D8TZGJO3SImWXwoIzETnRNUbTYsJ01C6B9g/f+DZGaGNMPG
	 kyz6tn6u1KeW+P3SMLoxzTJiLZgYyWAe05tgliGk7fjjfzefa3RPFbmwJWS+3agmtk
	 a1UZmOVFwwaqAPbhHxveCyfCUWL74WshdmuLRvQEWgWkfGcWg+29mRwaW1eNgxhesY
	 iIMA9ALzFh/6w==
Date: Mon, 26 Feb 2024 18:17:54 -0800
Subject: [PATCHSET v29.4 02/13] xfs: refactorings for atomic file content
 exchanges
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900011118.938068.16371783443726140795.stgit@frogsfrogsfrogs>
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
---
Commits in this patchset:
 * xfs: move inode lease breaking functions to xfs_inode.c
 * xfs: move xfs_iops.c declarations out of xfs_inode.h
 * xfs: declare xfs_file.c symbols in xfs_file.h
 * xfs: create a new helper to return a file's allocation unit
 * xfs: hoist multi-fsb allocation unit detection to a helper
 * xfs: refactor non-power-of-two alignment checks
---
 fs/xfs/xfs_bmap_util.c |    4 +-
 fs/xfs/xfs_file.c      |   88 ++++--------------------------------------------
 fs/xfs/xfs_file.h      |   15 ++++++++
 fs/xfs/xfs_inode.c     |   75 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h     |   12 +++----
 fs/xfs/xfs_ioctl.c     |    1 +
 fs/xfs/xfs_iops.c      |    1 +
 fs/xfs/xfs_iops.h      |    7 ++--
 fs/xfs/xfs_linux.h     |    5 +++
 9 files changed, 116 insertions(+), 92 deletions(-)
 create mode 100644 fs/xfs/xfs_file.h

