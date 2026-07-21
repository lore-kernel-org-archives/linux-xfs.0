Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C27B357D11;
	Tue, 21 Jul 2026 03:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784604217; cv=none; b=ujASbvftLcLLqHdFglKwsiIXdMmuacL1kEr7pHP5m3DyiLfhqpYgo2f6M6AUdlZCnRJXQ6m+SfkdDxqOsOJSqLZCxQtVZ9X8w/y+CFtelNOI/1Cgi1V4knuOw8Zdn4Ycyj9lIH+913vh2+EY1R4UCaVyJ7kIGBMjv3H/iyWVdK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784604217; c=relaxed/simple;
	bh=eMrU4+nUQvqV3IOz4bPqoOxwhigmtq6FMEV4vsxvOjk=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=qfhbvvP+j4zTQfXuaGdU7Axo+OXrmuqMIiP9gCJT1YxanruVFLYji2+14yHP13WGN9pB5acxSYworKCtb9qK0zJulTxvlBlUAJygriqbPvxKkgOnmWyNnk/REgNGh4v3b33noLPYbTGKA6KP2/aL2vsKed7tG/oGkHBkbsSV7I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hS1sprT+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hS1sprT+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E52BA1F000E9;
	Tue, 21 Jul 2026 03:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784604216;
	bh=SALHgvKpiO3LzVflN6o+ZiwJjBscI4pZ00AY4Q1jKwg=;
	h=Date:Subject:From:To:Cc;
	b=hS1sprT+XEw6eK3wuLYz/J4HsgUtumM/ca0ag1qeSokkX6SiZMpFMV/O2JY2puqt3
	 JdXx9Muyb9q2gyr2fzyINbVZ/pCorSTsnNo/5QmYBDS4L6C5SbRUGueNYluIhC+Qnb
	 BCw0roOnQGa9szdqkAnsCh1friZGRp25cc2QqduXY9E0wrrHrY9oI4KeaV55gmmNhV
	 5okyWtQeyGAyaS+7FOyVB+4rrV2nQApUcqYAGdJvGdJjRn8uATOvf/FVhvTCL21R5H
	 qnKs/BGwcz0e9WHfkthcVRs1nHGZDYgKxq4sXozsKouLSoein5nGvcNxxAF1o2TZt6
	 aGj7lTJ2yJ10Q==
Date: Mon, 20 Jul 2026 20:23:35 -0700
Subject: [PATCHSET v2 1/2] xfs: LLM-inspired bug fixes, part 3
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178460419060.830618.6327864598367400225.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a third batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

v2: apply rvb tags, split out unlinked inode list repair fixes

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-3
---
Commits in this patchset:
 * xfs: check cowextsize in xrep_inode_cowextsize
 * xfs: fix transaction block reservation in xrep_rtbitmap
 * xfs: rtsummary scrub should treat rtbitmap corruption errors as an xref error
 * xfs: zero i_nlink before repair puts inode on unlinked list
 * xfs: mark nonzero sb_gquotino as corrupt on metadir filesystems
---
 fs/xfs/scrub/agheader.c        |    2 +-
 fs/xfs/scrub/inode_repair.c    |    2 +-
 fs/xfs/scrub/nlinks_repair.c   |    7 +++++-
 fs/xfs/scrub/rtbitmap_repair.c |   46 ++++++++++++++++++++++++----------------
 fs/xfs/scrub/rtsummary.c       |    2 +-
 5 files changed, 37 insertions(+), 22 deletions(-)

