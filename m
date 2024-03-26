Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6CB5788E
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 02:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711421825; cv=none; b=oNym6yBW/w5S5iZ4HMDgdydtXo5bz+SxdKfax3fnE8J0j8HA3MqpGjs9ZCfgHQdvHWl/jHTXtu+HwVe3g3pkLB7TU0ZucMk1yX254g3inJQsrVmpSfnQIN3Xe9bxT54N7Ng4rkX9UmituWQ53egKcaNP2QowMDL9YL9wSnaczTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711421825; c=relaxed/simple;
	bh=AuW01mtEkRKwRYP93AYnBvgZZ8ifVIevpZ+mpOGuTMU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KFyzZj2eXswMVxv7rSj8pPDR070QqC1WmtiwY4ODNKvePul8zCg+4hE5PJwnGpYhZJMunG8cMH7ZtVMfq1RKHYFA5n1b6U7mrrZHnOmlz2LXewYbgKhIivQ0+n0uaMl7hHpPwYoEJCZG5F0Ntix4iB8nXo6P1TQbTch3sSC3qsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rxPL78ss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rxPL78ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0D5C433F1;
	Tue, 26 Mar 2024 02:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711421825;
	bh=AuW01mtEkRKwRYP93AYnBvgZZ8ifVIevpZ+mpOGuTMU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rxPL78ssAVhAqApeTMvGoYYfKjNLQD7xvAbPO+GV//bM2srtz8HxqEBkW5az9QUo2
	 CAniUqOwM3vBLjAEuQjsx1//PZ5PP7NwCXDrjSLLOjyTdRV2RmdFtPFjmtgOJLejq+
	 zf/XAM/EOMMUHEGV0BfNzIB4r6HeCe1ZpAjbgmaUyzavtS8ROERketamf3GYodi2n/
	 mnszRIfHfTIsWy/F3pKR6wiQX5ablcFDQMw/RWNmD/hdclCCNjog04NfFwh1qD0OJH
	 VDyQN0oJ4MnvG7oOmiyPswRke2fBbSaV/Fz6ml6kSNLBKepAQHRm3sMlVnKTBApf33
	 JPMAFSFmAmXcQ==
Date: Mon, 25 Mar 2024 19:57:04 -0700
Subject: [PATCHSET 09/18] xfs_repair: support more than 4 billion records
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@djwong.org>,
 linux-xfs@vger.kernel.org
Message-ID: <171142130345.2214793.404306215329902244.stgit@frogsfrogsfrogs>
In-Reply-To: <20240326024549.GE6390@frogsfrogsfrogs>
References: <20240326024549.GE6390@frogsfrogsfrogs>
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

I started looking through all the places where XFS has to deal with the
rc_refcount attribute of refcount records, and noticed that offline
repair doesn't handle the situation where there are more than 2^32
reverse mappings in an AG, or that there are more than 2^32 owners of a
particular piece of AG space.  I've estimated that it would take several
months to produce a filesystem with this many records, but we really
ought to do better at handling them than crashing or (worse) not
crashing and writing out corrupt btrees due to integer truncation.

Once I started using the bmap_inflate debugger command to create extreme
reflink scenarios, I noticed that the memory usage of xfs_repair was
astronomical.  This I observed to be due to the fact that it allocates a
single huge block mapping array for all files on the system, even though
it only uses that array for data and attr forks that map metadata blocks
(e.g. directories, xattrs, symlinks) and does not use it for regular
data files.

So I got rid of the 2^31-1 limits on the block map array and turned off
the block mapping for regular data files.  This doesn't answer the
question of what to do if there are a lot of extents, but it kicks the
can down the road until someone creates a maximally sized xattr tree,
which so far nobody's ever stuck to long enough to complain about.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-support-4bn-records
---
Commits in this patchset:
 * xfs_db: add a bmbt inflation command
 * xfs_repair: slab and bag structs need to track more than 2^32 items
 * xfs_repair: support more than 2^32 rmapbt records per AG
 * xfs_repair: support more than 2^32 owners per physical block
 * xfs_repair: clean up lock resources
 * xfs_repair: constrain attr fork extent count
 * xfs_repair: don't create block maps for data files
 * xfs_repair: support more than INT_MAX block maps
---
 db/Makefile       |   65 +++++-
 db/bmap_inflate.c |  551 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/command.c      |    1 
 db/command.h      |    1 
 man/man8/xfs_db.8 |   23 ++
 repair/bmap.c     |   23 +-
 repair/bmap.h     |    7 -
 repair/dinode.c   |   18 +-
 repair/dir2.c     |    2 
 repair/incore.c   |    9 +
 repair/rmap.c     |   25 +-
 repair/rmap.h     |    4 
 repair/slab.c     |   36 ++-
 repair/slab.h     |   36 ++-
 14 files changed, 725 insertions(+), 76 deletions(-)
 create mode 100644 db/bmap_inflate.c

