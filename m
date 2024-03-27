Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7003FD4
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504089; cv=none; b=H7UFAN6a5XJVamRApSpakGeCvzYm1Hi7m22XlLTVWqqA6Rb2+QszjYR7VrLqKqAwLjM9fnBXOBJX2gnj3SkquEoc1Y0n2WHEC3sScI+h78kF6OZ9IcYkQLHRabf7UIq8xBOfZLlkmSR018GfXiUXWGLM8/4pZ0/sGqoIbnzuIOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504089; c=relaxed/simple;
	bh=06A05n9pS39LKfBvjjMzOO3API6OB54fnj4xSnTEQfs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=scLT/OHdcrQ1Zm8QK+IlgTRnSMWOjfnV1uknxUdry9YilxxeWOP0bwBtL63PKrtQf6ljWDv1iZPTFvfM0yLjP00nhEgRJiiKlI1T4UfrCcGX0o7gMirXYJ7dnvA091TB4r4qvrCwHVWox7C1KLZ79fJ51/GmeZf8/uNHNwebhqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m1megV2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m1megV2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC7BC433C7;
	Wed, 27 Mar 2024 01:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504088;
	bh=06A05n9pS39LKfBvjjMzOO3API6OB54fnj4xSnTEQfs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=m1megV2tg+s/gUkvY2Wv2FqruIWrSS4tmVEwZa5iVTOZNRn2ucUEo5hEdVL4rWb+W
	 TOP02486aYjV57L4b3y0r+Vuk0sfa5upOYDSCXVd0nTW54l1LXu0CEErr9mkZeIBkS
	 ulN3j9HbsVhCf5c9bP+UUi3fSNuTvJMmDE/QKr2ADFJZigmx8UUdQUDkaUFJAOPXi7
	 Sp+nbkiovxAEIPV9Fv/Tlm9BiutKEZAOAnL842601JPr4zhTCkFoTjCimdxkHjYOpV
	 jb/wJPioQALaV8naJQuC1CCCILlsTHwnHBkY/6fbqp1Vc7JTbp5apnlLQzBzzFD7DT
	 MFNu68lcKSXGQ==
Date: Tue, 26 Mar 2024 18:48:08 -0700
Subject: [PATCHSET v30.1 07/15] xfs: set and validate dir/attr block owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150382098.3217370.5208665628669220587.stgit@frogsfrogsfrogs>
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

There are a couple of significant changes that need to be made to the
directory and xattr code before we can support online repairs of those
data structures.

The first change is because online repair is designed to use libxfs to
create a replacement dir/xattr structure in a temporary file, and use
atomic extent swapping to commit the corrected structure.  To avoid the
performance hit of walking every block of the new structure to rewrite
the owner number before the swap, we instead change libxfs to allow
callers of the dir and xattr code the ability to set an explicit owner
number to be written into the header fields of any new blocks that are
created.  For regular operation this will be the directory inode number.

The second change is to update the dir/xattr code to actually *check*
the owner number in each block that is read off the disk, since we don't
currently do that.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=dirattr-validate-owners

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=dirattr-validate-owners
---
Commits in this patchset:
 * xfs: add an explicit owner field to xfs_da_args
 * xfs: use the xfs_da_args owner field to set new dir/attr block owner
 * xfs: reduce indenting in xfs_attr_node_list
 * xfs: validate attr leaf buffer owners
 * xfs: validate attr remote value buffer owners
 * xfs: validate dabtree node buffer owners
 * xfs: validate directory leaf buffer owners
 * xfs: validate explicit directory data buffer owners
 * xfs: validate explicit directory block buffer owners
 * xfs: validate explicit directory free block owners
---
 fs/xfs/libxfs/xfs_attr.c        |   14 ++-
 fs/xfs/libxfs/xfs_attr_leaf.c   |   59 +++++++++++---
 fs/xfs/libxfs/xfs_attr_leaf.h   |    4 +
 fs/xfs/libxfs/xfs_attr_remote.c |   13 +--
 fs/xfs/libxfs/xfs_bmap.c        |    1 
 fs/xfs/libxfs/xfs_da_btree.c    |  168 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_da_btree.h    |    3 +
 fs/xfs/libxfs/xfs_dir2.c        |    5 +
 fs/xfs/libxfs/xfs_dir2.h        |    4 +
 fs/xfs/libxfs/xfs_dir2_block.c  |   44 ++++++----
 fs/xfs/libxfs/xfs_dir2_data.c   |   17 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c   |   99 ++++++++++++++++++-----
 fs/xfs/libxfs/xfs_dir2_node.c   |   44 ++++++----
 fs/xfs/libxfs/xfs_dir2_priv.h   |   15 ++-
 fs/xfs/libxfs/xfs_exchmaps.c    |    7 +-
 fs/xfs/scrub/attr.c             |    1 
 fs/xfs/scrub/dabtree.c          |    8 ++
 fs/xfs/scrub/dir.c              |   23 +++--
 fs/xfs/scrub/readdir.c          |    6 +
 fs/xfs/xfs_attr_item.c          |    1 
 fs/xfs/xfs_attr_list.c          |   89 ++++++++++++++-------
 fs/xfs/xfs_dir2_readdir.c       |    6 +
 fs/xfs/xfs_trace.h              |    7 +-
 23 files changed, 490 insertions(+), 148 deletions(-)

