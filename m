Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E57F84FCC
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816380; cv=none; b=L7uJ9iGd23N8Rd4AkEwHX7Zz1EF21lx+JqgCdc6GGy6yRuUcCpQbxFmWHC8LjxqKAUj3ykIyu26dUQ8yNIBiJ5m3DgtPSQSgp1bzB5PXeRhJG0uLoe7WTyDLWlUVJoXEabqyuy7jHCRR/xEbqkftpJyL5UPe/4UiFyu903iS84U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816380; c=relaxed/simple;
	bh=+21aAuZELcT68lkXMH3S9KunvQ5pPUgrUKQ1TLqKrPQ=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=IlWL3GByuluuzFU4tgMSD2d6THzkDKsmtPqZrmSVeuAQSCp7O28nIDDhM/7q/9aPyNzIm2OqOoVraZe7CddZFWW2UfAIQWOOhMgMaT/MBMAQf9battqEbf0R5IinJOOQQP6JSzinaWBG/C2R+lRtRQ9vFCkHzdT+2FJq6oyirpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BUUjCqoF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BUUjCqoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C072C433F1;
	Thu,  1 Feb 2024 19:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816379;
	bh=+21aAuZELcT68lkXMH3S9KunvQ5pPUgrUKQ1TLqKrPQ=;
	h=Date:Subject:From:To:Cc:From;
	b=BUUjCqoFP8WOD6o9vY/RUjvP+3XR4YFeGeZbysuCbzEppu5vqtwpF24MKBeswyiYj
	 yooePaWlTaNgzn7b6VpX3U37++YHxm43KKkul863S4E37FA8OiAXrx4GbS/ox4ywe4
	 iJqrg+LlEqu6SyxTy6zZV7Zz7QkNEXdVVoCqPi1eV7RJLlwMe7iEHQDjSMGqdsiE8n
	 4jgknUt2cul5r43gXbcuMw2M+cHUxrEuAAZzgyGVcKrYQ0QV3PMPbfqZ0y9KP7MsZ7
	 RRSmBBv4ATLbMupGLYIU8NjsJVEtOAPMcM5bNIcN2W8QhqB8R1N+/E7EXomhKY7QnC
	 mD3n98LdZfQYA==
Date: Thu, 01 Feb 2024 11:39:39 -0800
Subject: [PATCHSET v29.2 6/8] xfs: support in-memory btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org,
 willy@infradead.org
Message-ID: <170681336944.1608400.1205655215836749591.stgit@frogsfrogsfrogs>
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

Online repair of the reverse-mapping btrees presens some unique
challenges.  To construct a new reverse mapping btree, we must scan the
entire filesystem, but we cannot afford to quiesce the entire filesystem
for the potentially lengthy scan.

For rmap btrees, therefore, we relax our requirements of totally atomic
repairs.  Instead, repairs will scan all inodes, construct a new reverse
mapping dataset, format a new btree, and commit it before anyone trips
over the corruption.  This is exactly the same strategy as was used in
the quotacheck and nlink scanners.

Unfortunately, the xfarray cannot perform key-based lookups and is
therefore unsuitable for supporting live updates.  Luckily, we already a
data structure that maintains an indexed rmap recordset -- the existing
rmap btree code!  Hence we port the existing btree and buffer target
code to be able to create a btree using the xfile we developed earlier.
Live hooks keep the in-memory btree up to date for any resources that
have already been scanned.

This approach is not maximally memory efficient, but we can use the same
rmap code that we do everywhere else, which provides improved stability
without growing the code base even more.  Note that in-memory btree
blocks are always page sized.

This patchset modifies the kernel xfs buffer cache to be capable of
using a xfile (aka a shmem file) as a backing device.  It then augments
the btree code to support creating btree cursors with buffers that come
from a buftarg other than the data device (namely an xfile-backed
buftarg).  For the userspace xfs buffer cache, we instead use a memfd or
an O_TMPFILE file as a backing device.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=in-memory-btrees

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=in-memory-btrees
---
Commits in this patchset:
 * xfs: teach buftargs to maintain their own buffer hashtable
 * xfs: support in-memory buffer cache targets
 * xfs: add a xfs_btree_ptrs_equal helper
 * xfs: support in-memory btrees
 * xfs: launder in-memory btree buffers before transaction commit
---
 .../filesystems/xfs/xfs-online-fsck-design.rst     |    5 
 fs/xfs/Kconfig                                     |    8 
 fs/xfs/Makefile                                    |    2 
 fs/xfs/libxfs/xfs_ag.c                             |    6 
 fs/xfs/libxfs/xfs_ag.h                             |    4 
 fs/xfs/libxfs/xfs_btree.c                          |  286 ++++++++++++++--
 fs/xfs/libxfs/xfs_btree.h                          |    7 
 fs/xfs/libxfs/xfs_btree_mem.c                      |  347 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree_mem.h                      |   75 ++++
 fs/xfs/scrub/scrub.c                               |    5 
 fs/xfs/scrub/scrub.h                               |    3 
 fs/xfs/xfs_buf.c                                   |  214 ++++++++----
 fs/xfs/xfs_buf.h                                   |   17 +
 fs/xfs/xfs_buf_mem.c                               |  270 ++++++++++++++++
 fs/xfs/xfs_buf_mem.h                               |   34 ++
 fs/xfs/xfs_health.c                                |    3 
 fs/xfs/xfs_mount.h                                 |    3 
 fs/xfs/xfs_trace.c                                 |    2 
 fs/xfs/xfs_trace.h                                 |  167 ++++++++++
 fs/xfs/xfs_trans.h                                 |    1 
 fs/xfs/xfs_trans_buf.c                             |   42 ++
 21 files changed, 1363 insertions(+), 138 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_btree_mem.c
 create mode 100644 fs/xfs/libxfs/xfs_btree_mem.h
 create mode 100644 fs/xfs/xfs_buf_mem.c
 create mode 100644 fs/xfs/xfs_buf_mem.h

