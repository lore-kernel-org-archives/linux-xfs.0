Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273D23B71A6
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179485; cv=none; b=UVZ0o6yqP+g0KWXYIlGb6Txcuxe8GwFiRsUamo24r0/nASN3VOFk0FartIknbr5hhNC8joQ43WVXz5D9WCw/3DZ+VsJUzIomr5bQepbijVb5WGXXtYS/1TXgFVP2Xj7EEvQg+3CIMu06VabKvbYUH5tO0whNgbalZm5eexgZW9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179485; c=relaxed/simple;
	bh=aJxQj/Txyc8v6qG6tP7S7aYQNxqJOmFCdQUVURalMLA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=RiAY9rmrfi/C5OWSQTBw/ELTfiJzxDdX20El+cNLcFuqvb7iVtNTWSiHSkLo7taOGXxU56E+FEIgf+xFrDqiuLkfqTx/EXWbhsBqiynadiifrLcV96TYRrnXW4n581ItpDXcrzhPZ91VjALMGfWstc4Q4YpP1Mc/8iRF8fV6HiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ayF6fIgY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ayF6fIgY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 72ED21F000C4;
	Fri, 16 Oct 2026 19:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792179481;
	bh=sHCPMbL9hKI3pDWuNpq+sJ5odUIbSWO5j6QFCl/L9yE=;
	h=Date:Subject:From:To:Cc;
	b=ayF6fIgYxHk1bNMl9mf6ZT3YQWKz8w+fPecmv2fvIJCs2s1YaT0/3cR36yey3klwr
	 BEWVj8uNBw4McTW8lY5/2nUgdrD7BijvyGLVEtu3IwOmzAILYD0ohm6AXdUu3wRJrx
	 hB9uHHSUqNWlQVvlpP20nS5UCXcgZL3VL/2kfUhwBS3YsoRmn8gvK37eZ2HaVyEEum
	 vm1w7FNKfc37R3YF/CtaiAuG0k8TTCfNGp9eRSiFg1OAVthzXx1joQoh13xizOlOJ/
	 NUGO8Q9spqBZu7yk3zkTivjJktJuLKQiWSSzWvvsI+mP4EE/jNGDrJ1d1GWfv1k1JO
	 ksWQvCl5m9x1g==
Date: Fri, 16 Oct 2026 12:38:00 -0700
Subject: [PATCHSET] xfs_repair: irresponsible filesystem upgrades
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179217942688.717548.16906066734797910984.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a pile of very sketchy patches that I wrote over the years to
enable upgrading of existing V5 filesystems to have new feature sets.
None of these should ever get merged in upstream because they require
extensive rewrites of filesystem metadata and potentially a lot of space
that the filesystem may not have.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=dangerous-upgrades
---
Commits in this patchset:
 * xfs_repair: allow sysadmins to add free inode btree indexes
 * xfs_repair: allow sysadmins to add reflink
 * xfs_repair: allow sysadmins to add reverse mapping indexes
 * xfs_repair: upgrade an existing filesystem to have parent pointers
 * xfs_repair: allow sysadmins to add metadata directories
 * xfs_repair: upgrade filesystems to support rtgroups when adding metadir
 * xfs_repair: allow sysadmins to add realtime reverse mapping indexes
 * xfs_repair: allow sysadmins to add realtime reflink
 * xfs_repair: skip free space checks when upgrading
 * xfs_repair: allow adding rmapbt to reflink filesystems
---
 libxfs/libxfs_api_defs.h |    1 
 repair/globals.h         |    7 +
 repair/protos.h          |    6 +
 man/man8/xfs_admin.8     |   37 +++++
 repair/dino_chunks.c     |    6 +
 repair/dinode.c          |    5 +
 repair/globals.c         |    7 +
 repair/phase2.c          |  323 +++++++++++++++++++++++++++++++++++++++++++++-
 repair/phase4.c          |    5 +
 repair/pptr.c            |   15 ++
 repair/rmap.c            |   12 +-
 repair/xfs_repair.c      |   77 +++++++++++
 12 files changed, 487 insertions(+), 14 deletions(-)

