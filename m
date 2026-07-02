Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326D63A7826
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 19:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022351; cv=none; b=Dl3fUyFcfdrFG0UfR682gXriMrjTKvu4kQEs2KSNaQdZXAiuD1n1XD6g1wcX8cNdUC9Dof2Ew3bWyBPE47gJ6YJA/4TiHMzLOzJVm6b0lfszP7/5gDiaIQFIsVBT3WTZ+MW4NkoweWcdm5o+4v4PYOevITafo6+e/8z0G0psZ/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022351; c=relaxed/simple;
	bh=uLJg50UofFBN07KLVYa9xgN3uM0o4YLxByWlboZzLjg=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=XAs08SLitMpROULk20QRlatjnpNN8VOHoYbClNfQJ9vw1VSOpU0f2anYh2FJtlUYhFpV/Vw7weSBRSRHrBn2N3ar0SKXQbbaXCewJyfhzfM5lC+OSv+vposItSHdzNzQag5ImKamsFUO6Vl2PZI36METc+AKFfRqC04nctsBMJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MhrHtqUC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MhrHtqUC"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8EFE71F000E9;
	Thu,  2 Jul 2026 19:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022348;
	bh=Y1lO5r/ddQ7CnKTs0T8wLKYRrvr0hmyoiQ010RyZSkI=;
	h=Date:Subject:From:To:Cc;
	b=MhrHtqUCoGKDkyAnbtkLkON2gsi3+qDy6MOUxmC2uX9FZXnipIgJ3yXLTpSjOczQu
	 TqnSi95/XfQ6QQHO+CkTP4fwS7Jfz72ZRB74J6iozZJVJBNTyw6ZfM/x9YmTLyC7RJ
	 28aRTjTt0cQv6zqoXcdfM5jWnGwD39MR7/1huuPY1mUfWaWRjM2PfwIBuJY1tfa1o1
	 qtPfVQvOmdqfFI4zCQIjT/WLk8K7dmgCu+AQN9A3/nj595E5Aj1HfrTGXVhMnWQfTi
	 3rA/otQWzrl+b+dO5fKcyeNj6pEZB7DUb1qkXh3X1mHVzyrOuCWkJ/wA4cGmwaOmqr
	 ztLnM5mb4iyhA==
Date: Thu, 02 Jul 2026 12:59:08 -0700
Subject: [PATCHSET 1/2] xfsprogs: new libxfs code from kernel 7.1
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, alexjlzheng@tencent.com, wilfred.mallawa@wdc.com,
 cem@kernel.org, ytohnuki@amazon.com, bfoster@redhat.com, dgc@kernel.org,
 syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com,
 linux-xfs@vger.kernel.org
Message-ID: <178302225882.845293.16022494313921827307.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series ports kernel libxfs code to userspace from 7.1.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-7.1-sync
---
Commits in this patchset:
 * xfs: add write pointer to xfs_rtgroup_geometry
 * xfs: switch (back) to a per-buftarg buffer hash
 * xfs: remove the meaningless XFS_ALLOC_FLAG_FREEING
 * xfs: zero entire directory data block header region at init
 * xfs: zero directory data block padding on write verification
---
 libxfs/xfs_ag.h        |    2 --
 libxfs/xfs_fs.h        |    5 ++++-
 libxfs/xfs_ag.c        |   13 ++-----------
 libxfs/xfs_dir2_data.c |   18 +++++++++++-------
 libxfs/xfs_refcount.c  |    3 +--
 5 files changed, 18 insertions(+), 23 deletions(-)

