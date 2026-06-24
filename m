Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23AC2FB97B
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 18:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782324882; cv=none; b=QeuBusBbaGrVJZQqidGmr+3oXkEgCDi6H6vCLHZsvw9SYwV9mTcdQHTD+EG0jcHORur7UZ/ZdhRsEBQc1OxDpJPgrT6K+hiRwJ9gdYgQZEHSFAY/dWcTFO1dooiLRiOLVd+YehDR0NBC/rplhf6sCeuoMTu/IsIoEUrwc8AMte8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782324882; c=relaxed/simple;
	bh=sSkbcJ+QaRAAU49CjygxjXWqfVAuS9FTNWp0irstudc=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=uG58vmnG2yr70+uSCYDvkrbXPcJWZ14gH3Tgxm9DR0Smq0iPqdEdSiyByl9u4x0iVtNovzFMSZq6GTDnJ0DmiaTkjLCNkvMi0c9gLgx5BCCkm2vfCrYfDUU3TXWeHmXh8Xij/sz7Q+VlLNwFtqmtHrW+W8FHo/O+Yjw0pxgcmLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hViUaPyE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hViUaPyE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7B2B91F000E9;
	Wed, 24 Jun 2026 18:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782324881;
	bh=riJIfTxM0gqrgGd3qi9HEK6U/nIPWCDGQsByKSWXq+A=;
	h=Date:Subject:From:To:Cc;
	b=hViUaPyEIkyyDyySCFgcag2mDEBPiPKu06DqwhO/1rJ0VJp2YO6O+yf4BfvEs77+e
	 zcmNefbQfr3HEs/nxq5qZWEmMZrA8PwFuUCq6QByBxCMi08dVyYwSz+cPtcf+nOUh7
	 Ffo/lO2lgD4egmaNMLJ55p4DBc2ltT2es19gcqb5msdOgF0aKyzfIZuG18z5lUZ5xQ
	 vdx0wYQDrngEMBYWUMNLtnONfJnMOmCnmwZJqgpr1zSekDdTFV787PLnePrrIo5K+e
	 cihbkQ+n2Nrji0h5+ftEXH0masTmhDzAJurZWwdEsruO3Dg+xP+f84UJcsRzQ7qWLV
	 DcspQLvdMqQyw==
Date: Wed, 24 Jun 2026 11:14:41 -0700
Subject: [PATCHSET] xfs_scrub: codex-inspired bug fixes, part 2
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a second batch of xfs_scrub fixes resulting from Codex reviews.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-codex-fixes2
---
Commits in this patchset:
 * xfs_scrub: handle missing media verify ioctl failure return codes
 * xfs_scrub: report bad file ranges correctly
 * xfs_scrub: handle media scans of internal rt devices correctly
 * xfs_scrub: track inode scan abort state with an enum
 * xfs_scrub: don't skip bulkstat batch when scrub_scan_user_files helper returns ESTALE
 * xfs_scrub: warn about incomplete repairs if we never get to them
 * xfs_scrub: report external log space usage in phase 7
 * xfs_scrub: account only data extent tail after an overlap
 * xfs_scrub: account for reflinked realtime file data
 * xfs_scrub: don't leak the autofsck fsproperty handle
 * xfs_scrub: warn about difficult rtgroup repairs
---
 scrub/inodes.c      |   66 ++++++++++++++++++++++++++------------
 scrub/phase1.c      |   10 +++---
 scrub/phase2.c      |    8 +++++
 scrub/phase6.c      |   10 ++++--
 scrub/phase7.c      |   89 ++++++++++++++++++++++++++++++++++-----------------
 scrub/read_verify.c |    8 ++++-
 scrub/repair.c      |    5 ++-
 scrub/spacemap.c    |    2 +
 8 files changed, 137 insertions(+), 61 deletions(-)

