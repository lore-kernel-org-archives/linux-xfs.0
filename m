Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C4F376EA
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706590992; cv=none; b=mhgHonJUexeYszgJpGrYsy7YSqZ6V8MVvJtN/Vf0QTbA5KAy2eJkw1QLhMm+PfOePT4do8fwYbQFHI/oBquLOfn9NanCPSkeZOZBoBes/4LiG5reKncGJN+Leci5U0YLG8SRTB74b3F6+v78+7zuGuIVPkKtwDHYBPA6FoSPSeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706590992; c=relaxed/simple;
	bh=0vzUw+KzfhoGlMneo5+kmHSB87oS6Gw37K/oJ3PwPqI=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=fnTbJV8qLbKJaJG9U522NT5piXREbmKQ7zj0PCY+gJcxzOzz5yRgC+nF+sI1hZ63lgjBMyPFTGVGNWmoBUVhtAbpARFHPzGmsQXDe7XE//toDZb3M2CG/mDnlbxcFCw2WKT7W9+Wq+N42ZrenrnUgf7dvRR0R/L42EGlHLgFtSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lLatNLRH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lLatNLRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D7AC433C7;
	Tue, 30 Jan 2024 05:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706590991;
	bh=0vzUw+KzfhoGlMneo5+kmHSB87oS6Gw37K/oJ3PwPqI=;
	h=Date:Subject:From:To:Cc:From;
	b=lLatNLRHhs3qT+jqissEcOVYKbM00UqbS1lDlsX//4z70LXBILPphi58CCeyiMpA1
	 2hzw/MMJ8SirbwH9qeS5jSxHeKztUGDRto9SUV0RwHzpyjg1xisEd2WxPnfd4efp8s
	 MgxQ5FductEptUoViyY1CE5OetGtuBYvt1d03bny99inRqEiFaZ/fK1J7orKc5njvy
	 3F4dAv8YwB+SD/nEH+XjYJNnYqItGGT/Kr0s/syYNPKfC/ROOCRUBv+Jk7358BnUv4
	 x/Wd7p2jsNiYrDSua3GkQUCK5xoNWL+/Vtbdu9CP3GWj/7D0Hm5B6KaB2GtiGmufli
	 AjosD1wO5O5BQ==
Date: Mon, 29 Jan 2024 21:03:11 -0800
Subject: [PATCHSET v29.2 2/7] xfs: repair inode mode by scanning dirs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659062291.3353217.5863545637238096219.stgit@frogsfrogsfrogs>
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

One missing piece of functionality in the inode record repair code is
figuring out what to do with a file whose mode is so corrupt that we
cannot tell us the type of the file.  Originally this was done by
guessing the mode from the ondisk inode contents, but Christoph didn't
like that because it read from data fork block 0, which could be user
controlled data.

Therefore, I've replaced all that with a directory scanner that looks
for any dirents that point to the file with the garbage mode.  If so,
the ftype in the dirent will tell us exactly what mode to set on the
file.  Since users cannot directly write to the ftype field of a dirent,
this should be safe.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-inode-mode

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-inode-mode
---
Commits in this patchset:
 * xfs: create a static name for the dot entry too
 * xfs: create a predicate to determine if two xfs_names are the same
 * xfs: create a macro for decoding ftypes in tracepoints
 * xfs: repair file modes by scanning for a dirent pointing to us
---
 fs/xfs/libxfs/xfs_da_format.h |   11 ++
 fs/xfs/libxfs/xfs_dir2.c      |    6 +
 fs/xfs/libxfs/xfs_dir2.h      |   13 ++
 fs/xfs/scrub/dir.c            |    4 -
 fs/xfs/scrub/inode_repair.c   |  236 ++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/iscan.c          |   29 +++++
 fs/xfs/scrub/iscan.h          |    3 +
 fs/xfs/scrub/trace.c          |    1 
 fs/xfs/scrub/trace.h          |   49 +++++++++
 9 files changed, 344 insertions(+), 8 deletions(-)

