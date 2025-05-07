Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE10C28EA67
	for <linux-xfs@vger.kernel.org>; Wed,  7 May 2025 21:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746655183; cv=none; b=nzvANdEKg00pRnj+7FS0vEyD8idhR8pzqz9kZG2tmjXhr73S7bOIJuiEf8qE03JlmN0i7UEwAD7tc1RhfEHJngSCds/DsZxMNvfnm4MHfujoNx7t07a/DUoZRtOAc8vizoR7nSsOE0vNc4QtDMs5aeLObVC8tBmKxhS+h+lBLnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746655183; c=relaxed/simple;
	bh=om4YiYxcjLk9Q8CIbR/q3A5/TNrL8v6i2t4z8hDB8so=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=SkZLRlFa2PmtEgn20AgkAWdFgRA+ScQtGe2beVlZMlbUVxIdJGXfcfGFvUBSsK/54vjxKU+cNX4RJQoG6uZoT7g1z5T+SClzOspP11Aq2ZfgG7BIQZ8XmofE9+QTKZxWd/hQSPyg/iN23vCCCciDek+RxWpgUtnIDz7KfAvtGgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u5blVLG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u5blVLG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA87C4CEE8;
	Wed,  7 May 2025 21:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746655183;
	bh=om4YiYxcjLk9Q8CIbR/q3A5/TNrL8v6i2t4z8hDB8so=;
	h=Date:Subject:From:To:Cc:From;
	b=u5blVLG2QE2fa9lU3yi3uu2fwk5ES+onNtR+ugLd+GDtm92N8wx013B14KZv5pQKD
	 v8qZ5j2A3/CKSdzGKdzWBiEMTJ9F2tg1NXRsweKgj+fWrAbf8HoiOHTTyqI35qoOPc
	 os+8eMZ9Lo6zDQA2MwutBWlUMKajCrfZogBLRcakPj7+h07O2TKU89DuskLdnzwOnw
	 0staOekAWd2h5ypNDwFW1747Tk266j0RdadaoKvg1pwmc1JQsUPqYu6GwN7UcPxtAI
	 aOzk2fx19D3m5nf7Oz2nSV85WmsPW2Gd3ljJwnlNm7/7jj228srbL2Gu1qazz00LCq
	 6+nRqcdiEaktw==
Date: Wed, 07 May 2025 14:59:43 -0700
Subject: [PATCHSET] xfsprogs: various bug fixes for 6.15
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, cmaiolino@redhat.com, cem@kernel.org, dchinner@redhat.com,
 linux-xfs@vger.kernel.org
Message-ID: <174665514924.2713379.3228083459035002170.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series ports a few late-arriving libxfs changes and strengthens a
manual page sentence.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * xfs: kill XBF_UNMAPPED
 * xfs: remove the flags argument to xfs_buf_get_uncached
 * man: adjust description of the statx manpage
---
 libxfs/libxfs_io.h        |    2 +-
 libxfs/libxfs_priv.h      |    1 -
 libxfs/rdwr.c             |    1 -
 libxfs/xfs_ag.c           |    2 +-
 libxfs/xfs_ialloc.c       |    2 +-
 libxfs/xfs_inode_buf.c    |    2 +-
 libxlog/xfs_log_recover.c |    2 +-
 man/man8/xfs_io.8         |    4 +++-
 mkfs/xfs_mkfs.c           |    4 ++--
 repair/rt.c               |    2 +-
 10 files changed, 11 insertions(+), 11 deletions(-)

