Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE2BEEB3;
	Tue, 25 Aug 2026 05:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787636070; cv=none; b=D3M9Pre9xHNvLXqXPvIjgdOEKZztFts0Wt+iZc9ndQV5FhZrmjrBHmfQGiSpjU1/S1MfFmtKFLJkNWEnMtPpeIhsLmqzqqdOiIMCBnE673ce8jcrubuWyrgvlbg2EaKTeKwa4wfJYXDdP4dKlhgdaqbnz2/3AZWuuw9G+bJJutA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787636070; c=relaxed/simple;
	bh=ggaKiQg+I0bPhHxGtvXUrf85k1GcD+j7o5IzKxZRQjM=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=IaTlhIkc1xHiLjqmg/YGs63PfjrU32Hhn5vzUW8Psm77/Noa46VrGnaCc48KBkMCmfx7LX1td7HNwjYFrt7Z00ZDLNRai/ompjQs5tVJLg+6e/Qt+xCE5MD2IY792ZFy3FqDfVGrRMsOvSBPoyUHk4iuU3SRftOgqdMJCZIrdpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gBYvQ17n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gBYvQ17n"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AD8BE1F000E9;
	Tue, 25 Aug 2026 05:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787636068;
	bh=NFHGz1Wqo6vQw9XvsO70Kw4ZB4xKNeoUkK8Ah3TXWWQ=;
	h=Date:Subject:From:To:Cc;
	b=gBYvQ17nYZ9hHt3yO4/wYLkPOYZrbRt1c0d0VuUkH+nRD9eeG4k9aUm+Yc0rvoQtg
	 ykjgiFAEigYokhKci3LTETAmOQD0LRhI6RWAeL0jcOM84G0wKeWl6jmvi+B8Oi+Mvz
	 mC51b878rykjf0rJYROE5MCkxaXx/mlUdWvatBXeQLPvLuH/dUgujFScSObc/X2hc7
	 s4prmqf6wab9I3xHv9hidRzVgxKsOj8fxZ3Vv3E6LvmkenSiVQ+qg6aVrdIUbXNrY4
	 i19ykoZCL1nezkSenOBQE/7wy+GykgulAsU49Pfm0biuixvYveq1K/xIwkOYNaSxl6
	 0S0tpfk/0SfZg==
Date: Mon, 24 Aug 2026 22:34:28 -0700
Subject: [PATCHSET 1/2] xfs: LLM-inspired bug fixes, part 7
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a seventh batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-7
---
Commits in this patchset:
 * xfs: don't spin forever on zero-length dirents when salvaging them
 * xfs: don't stash removename operations with unknown ftype
 * xfs: log the tempip after we convert it to extents format
 * xfs: fix parent rec lookup initialization in xrep_metapath_unlink
 * xfs: handle reconnecting metadir subdirectories
 * xfs: lock the healthmon when inserting unmount event
---
 fs/xfs/scrub/dir_repair.c     |   27 +++++++++++++-
 fs/xfs/scrub/metapath.c       |   78 ++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/symlink_repair.c |    2 +
 fs/xfs/xfs_healthmon.c        |    2 +
 4 files changed, 103 insertions(+), 6 deletions(-)

