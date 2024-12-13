Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01721DDDC
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 00:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051417; cv=none; b=AqT5XQLRnIu+eBKb2sBMDpQr5bddaazEf05oZXoOo/aqx00V37VNK+JuZ8Q02b1md5n8biP5Ku+ObnrmGk0VdDPgdysPdtxySWeBYvm99C6kNLdCDrcf8LPP1uvgL5TnKroEDqPFKfkf8aZmbNZDzpvmeszkM723ftmjrNe4r4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051417; c=relaxed/simple;
	bh=C/XOGSdSbpUAEywrKlik0fKfRUxSCT8PT43unXM0+iA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CQ1uNZQ/8QCzDOwTyOrMhzrrHMjqgl6cCmeHxS94d9lm71Y3PGC26HylPQt2qGJJUNajlZjj4FIOS3cjjm0TQPqYwARZEKQAne2k07XPP/WIE+zRMK/lfQv9jrY0VBhyYTpOqRX6Xx6ZNtbuIQhlV2RzwTrATwE+Sh3aljgGEy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JazyVdXS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JazyVdXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA64C4CED4;
	Fri, 13 Dec 2024 00:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734051416;
	bh=C/XOGSdSbpUAEywrKlik0fKfRUxSCT8PT43unXM0+iA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JazyVdXSkL6SwSil+B+87GzJr6JpD5MsCaKQkuWfg33c3voRcQ6CDOYXJzWVg9U/c
	 46BjEkPFtB0PQz/P7qHtmGVZT5H9ETR5Y2GhGo4BpqEhSHitjss2V01VkIiyY4X6rG
	 IysbpKXHQfvlM3czHB3sE5NB3yJ37AsaJnbjofO0H1AAgEt7Itpz4aXdVNvhTGQ0cL
	 aUSO9xKpToKZ4s3lWZrlWMS9/Wbqq0y6J4VTPuAhj+fKUm5qSEKRyQ456MLPn9ZDAR
	 7v1MR12h/N2OjECng5wxs90LT75jY8Bnv4IIhdBVEzNCQwihu2mhnBs/VF/XTqD9nR
	 HahW+FBgAX5og==
Date: Thu, 12 Dec 2024 16:56:55 -0800
Subject: [PATCHSET v6.0 1/5] xfs: refactor btrees to support records in inode
 root
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405122140.1180922.1477850791026540480.stgit@frogsfrogsfrogs>
In-Reply-To: <20241213005314.GJ6678@frogsfrogsfrogs>
References: <20241213005314.GJ6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Amend the btree code to support storing btree rcords in the inode root,
because the current bmbt code does not support this.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-ifork-records

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=btree-ifork-records
---
Commits in this patchset:
 * xfs: tidy up xfs_iroot_realloc
 * xfs: refactor the inode fork memory allocation functions
 * xfs: make xfs_iroot_realloc take the new numrecs instead of deltas
 * xfs: make xfs_iroot_realloc a bmap btree function
 * xfs: tidy up xfs_bmap_broot_realloc a bit
 * xfs: hoist the node iroot update code out of xfs_btree_new_iroot
 * xfs: hoist the node iroot update code out of xfs_btree_kill_iroot
 * xfs: support storing records in the inode core root
---
 fs/xfs/libxfs/xfs_bmap.c          |    7 -
 fs/xfs/libxfs/xfs_bmap_btree.c    |  111 ++++++++++++
 fs/xfs/libxfs/xfs_bmap_btree.h    |    3 
 fs/xfs/libxfs/xfs_btree.c         |  333 ++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_btree.h         |   18 ++
 fs/xfs/libxfs/xfs_btree_staging.c |    9 +
 fs/xfs/libxfs/xfs_inode_fork.c    |  171 ++++++-------------
 fs/xfs/libxfs/xfs_inode_fork.h    |    6 +
 8 files changed, 446 insertions(+), 212 deletions(-)

