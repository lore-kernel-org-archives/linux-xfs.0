Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C3A19E
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712709942; cv=none; b=pFtUkvyzrTy97l7R67CW1OpcZGDEuAcNVZAVyVM5BIVH7b4V/q+kSqTiXyP8ps88nr/MHaKnaXOCi0fbpwpu8Ut/VK8lOrGQSgwJl+q4sBovH8EF4lKtATSV+2z0rZY5iFIooMQoIFdMRWnv04M2REBfZuxm04n/ojU5y0F0Ek8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712709942; c=relaxed/simple;
	bh=uP8FygeL7nBysCFVPuyOUzgKugNd+SrB/97n3o0NijU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bt1GMTyE8m1xQifshZANwVAgVorZYUtdRjBhhh0fFJpM9b9Q7djgxc0ouyY3Dgtr0EYcvxL2AFecMNFhmYM096GEnIJVGLsLb59r5df7WoFc8hQ3/iptDJ0QyCZWQ1n5nDEIVQQ86GJlW5sV3z/yOy9DcUk5pJFLbIp3VpUDN7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qgp7vLT+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qgp7vLT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41F4C433F1;
	Wed, 10 Apr 2024 00:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712709941;
	bh=uP8FygeL7nBysCFVPuyOUzgKugNd+SrB/97n3o0NijU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qgp7vLT+bF/QQ+QMssvN1QJFR0tnRy9Ll4Ba1SAOX2vCO/E2sLMagEomp8BKL7tkd
	 Y0S0F8wIm4+SnEixG/GtU2HKivLxrzduBj8aapwL6BwroHc4oy9GSeEDfv6K64A+v9
	 slij1iM6cP+idG9s9Wbmck0t/0VnJotUQfd1TChJNxIrgXMBdmOGr+BZvSwpsODzqO
	 76RoVEUnfuxWXr6rhtn2ucnt3Ca/TSsq8+vFi6jb9VvMdqrDAA0ceavoiB3KVUhauy
	 45dbcQ+mpbmL9ljC0Q7PF3Ly/mTUjCwDluLqEgzL60XYqHMn68XBMSzJmyU78H+77t
	 ERQv/08FYgctQ==
Date: Tue, 09 Apr 2024 17:45:41 -0700
Subject: [PATCHSET v13.1 6/9] xfs: scrubbing for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270970449.3632713.16827511408040390390.stgit@frogsfrogsfrogs>
In-Reply-To: <20240410003646.GS6390@frogsfrogsfrogs>
References: <20240410003646.GS6390@frogsfrogsfrogs>
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

Teach online fsck to use parent pointers to assist in checking
directories, parent pointers, extended attributes, and link counts.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-pptrs

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-pptrs
---
Commits in this patchset:
 * xfs: check dirents have parent pointers
 * xfs: deferred scrub of dirents
 * xfs: scrub parent pointers
 * xfs: deferred scrub of parent pointers
 * xfs: walk directory parent pointers to determine backref count
 * xfs: check parent pointer xattrs when scrubbing
 * xfs: salvage parent pointers when rebuilding xattr structures
---
 fs/xfs/Makefile              |    2 
 fs/xfs/libxfs/xfs_parent.c   |   22 +
 fs/xfs/libxfs/xfs_parent.h   |    5 
 fs/xfs/scrub/attr.c          |    8 
 fs/xfs/scrub/attr_repair.c   |   34 ++
 fs/xfs/scrub/common.h        |    1 
 fs/xfs/scrub/dir.c           |  342 +++++++++++++++++++++
 fs/xfs/scrub/nlinks.c        |   82 +++++
 fs/xfs/scrub/nlinks_repair.c |    2 
 fs/xfs/scrub/parent.c        |  678 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/readdir.c       |   78 +++++
 fs/xfs/scrub/readdir.h       |    3 
 fs/xfs/scrub/trace.c         |    1 
 fs/xfs/scrub/trace.h         |  103 ++++++
 14 files changed, 1348 insertions(+), 13 deletions(-)

