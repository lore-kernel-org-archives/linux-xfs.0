Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83FD157A5A;
	Mon, 12 Oct 2026 05:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784555; cv=none; b=Gga1tXNNp/1WC3YRIHjPhv4gU7ljb6DW8CtxOwy3hWDsLJP2xzVGgijjEBJEkiToorStDkc9EAL4QGB60XDpnoN8cXD5fj3brECtWp85TSf4rnwKVKdBYWYYp+P7tmVhsarBi5Jvv7qJi/znLUtzuYudVAPg/R1FzrpZb5KR/+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784555; c=relaxed/simple;
	bh=Nfuiw+H1pVMDkq9GVdTH1l9au4QrccxMAEPG5q9Khs0=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=L3GZJ7ngEemb6c11X12k39sIzZE+RtW3OlS+RAFlTbzICFe6LxLq4E7pRPRgQX52ju0IpO7ByoGUnfjrDCF+9H2tk5jhsFyd2TjQACMhVMWqzzEnE8HkKmF5RCh2BpHKN1i/+84Q2oIi8E72pmMwEX6tuQXIBnqsN8qiWFRFm/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=apiCkcyj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="apiCkcyj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 900BA1F0089B;
	Mon, 12 Oct 2026 05:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791784554;
	bh=KOeqaLbv2p6/NtmfQWCcMJ/wonFO2yIe2eHU4qsZkdg=;
	h=Date:Subject:From:To:Cc;
	b=apiCkcyjCZenf2AZQcr0Ti3/wpdVQGlJxkkD/K4mN7L0W6aCimtGWhUyWYm1WWYpO
	 1ma9Mh7Po/GAtQ+6Y5JI2ffVN5+WpF70RNjNpsu5PQxKU7dOzvRqP9ic8LSr5aSRcA
	 446xCUsHm99bdhaU/lSiw4QJStwM9UaCma97cB97+hG9gd9pVNUJinXjnNuSRqV/gF
	 Lm3MU/T4MziPV3KizhCarL064GzliIKsWVowmn/K6spI5ruSTgEw+a+ezfoYALxRj5
	 PHpbCPS20CdBiQRRFUC55Qdo99n5jgwPJ0Fi0Ea20Tkn8MUwguiNcrN+2cx7NpJMFR
	 gOd+lXGTNA74g==
Date: Sun, 11 Oct 2026 22:55:53 -0700
Subject: [PATCHSET 2/2] xfs: LLM-inspired bug fixes, part 23
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a twenty-third batch of xfs fixes resulting from a LLaMma.  Mwa
mwa mwa...

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-23
---
Commits in this patchset:
 * xfs: don't set a metadata directory's parent to sb_rootino
 * xfs: don't rescan ifree and icount when frozen
 * xfs: rescan the AGs if incore delalloc counter is negative
 * xfs: don't try to repair rtsummary if the summary file isn't computed
 * xfs: update quota flags on secondary supers when metadir enabled
 * xfs: refactor directory data block walking loops in scrub
 * xfs: improve dirent bounds checking in scrub and repair
 * xfs: drop unnecessary sa parameter from the xrep_ag init functions
 * xfs: drop unnecessary sr parameter from xrep_rtgroup init functions
 * xfs: drop unnecessary sa parameter from xchk_ag init functions
 * xfs: drop unnecessary sr parameter from xchk_rtgroup init functions
 * xfs: refactor inode forkoff to byte conversions
---
 fs/xfs/libxfs/xfs_bmap.h         |    6 ++
 fs/xfs/libxfs/xfs_format.h       |    6 ++
 fs/xfs/scrub/common.h            |   46 +++++++---------
 fs/xfs/scrub/repair.h            |   11 ++--
 fs/xfs/scrub/rtsummary.h         |    1 
 fs/xfs/xfs_inode.h               |    2 -
 fs/xfs/libxfs/xfs_attr_leaf.c    |   12 ++--
 fs/xfs/libxfs/xfs_bmap.c         |    4 +
 fs/xfs/libxfs/xfs_inode_buf.c    |    4 +
 fs/xfs/libxfs/xfs_inode_util.c   |    2 -
 fs/xfs/scrub/agheader.c          |   16 +++---
 fs/xfs/scrub/alloc_repair.c      |    4 +
 fs/xfs/scrub/bmap.c              |   13 ++---
 fs/xfs/scrub/bmap_repair.c       |   15 ++---
 fs/xfs/scrub/btree.c             |    4 +
 fs/xfs/scrub/common.c            |   50 ++++++++++-------
 fs/xfs/scrub/cow_repair.c        |   12 ++--
 fs/xfs/scrub/dir.c               |  109 +++++++++++++++++++++++++++++++++++---
 fs/xfs/scrub/dir_repair.c        |  102 +++++++++++++++++++++++++++++-------
 fs/xfs/scrub/fscounters.c        |   21 ++++++-
 fs/xfs/scrub/ialloc_repair.c     |    4 +
 fs/xfs/scrub/inode.c             |    6 +-
 fs/xfs/scrub/inode_repair.c      |   10 ++-
 fs/xfs/scrub/refcount_repair.c   |    4 +
 fs/xfs/scrub/repair.c            |   23 ++++----
 fs/xfs/scrub/rgsuper.c           |    4 +
 fs/xfs/scrub/rmap_repair.c       |    8 +--
 fs/xfs/scrub/rtbitmap.c          |    4 +
 fs/xfs/scrub/rtbitmap_repair.c   |    4 +
 fs/xfs/scrub/rtrefcount.c        |    8 +--
 fs/xfs/scrub/rtrefcount_repair.c |    8 +--
 fs/xfs/scrub/rtrmap.c            |    4 +
 fs/xfs/scrub/rtrmap_repair.c     |   12 ++--
 fs/xfs/scrub/rtsummary.c         |   13 +++--
 fs/xfs/scrub/rtsummary_repair.c  |    2 -
 fs/xfs/scrub/scrub.c             |    6 +-
 fs/xfs/xfs_mount.c               |   17 ++++++
 fs/xfs/xfs_qm.c                  |   25 ++++++++-
 38 files changed, 412 insertions(+), 190 deletions(-)

