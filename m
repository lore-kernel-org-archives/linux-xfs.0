Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359DCB645
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QfDNbvx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0527BC433C8;
	Sun, 31 Dec 2023 19:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051207;
	bh=34WnpDbdlNeMrjhGX3ULILF2mhRS+z3BWyE9ljVQAU0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QfDNbvx25Vya8VJkbwQfZEGYU1cFxECPkczGnjBafygHyZ2wgrl7ChdonXfWxkKRl
	 ymmqFJ6CFUnvPZnWikEWc9Luf6ypWSoOOSLXjjXAY3GrN3octxZRNAbSpUjzPx1L+A
	 iEW21lNb9mxTjqrXV7nNGac82w66BjceV6IA4oByPZFASo2fGnclRXJS1wwa5nDkFW
	 7Y8gMSzv1Gi0SLkun+n3N2fPUfzieZZJMf5BvclJXUnqtcUK3dayRwAVneqJrVplvT
	 Co0FCrC8H8CA72j8OKmOfQvdgvhlihA7cToMrHPzQxhqXzEUOfzgUWS5EP96Qwh2AL
	 j4AofTdbiOBGw==
Date: Sun, 31 Dec 2023 11:33:26 -0800
Subject: [PATCHSET v13.0 3/7] xfs: name-value xattr lookups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404840374.1756514.8610142613907153469.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181849.GT361584@frogsfrogsfrogs>
References: <20231231181849.GT361584@frogsfrogsfrogs>
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

Directory parent pointers are stored as namespaced extended attributes
of a file.  Because parent pointers can consume up to 267 bytes of
space and xattr names are 255 bytes at most, we cannot use the usual
attr name lookup functions to find a parent pointer.  This is solvable
by introducing a new lookup mode that checks both the name and the
value of the xattr.

Therefore, introduce this new lookup mode.  Because all parent pointer
updates are logged, we must extend the xattr logging code to capture the
VLOOKUP variants, and restore them when recovering logged operations.
These new log formats are protected by the sb_incompat PARENT flag, so
they do not need a separate log_incompat feature flag.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-attr-nvlookups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-attr-nvlookups

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=pptrs-attr-nvlookups
---
 fs/xfs/libxfs/xfs_attr.c       |   52 ++++--
 fs/xfs/libxfs/xfs_attr.h       |   32 +++-
 fs/xfs/libxfs/xfs_attr_leaf.c  |   45 ++++-
 fs/xfs/libxfs/xfs_da_btree.h   |   10 +
 fs/xfs/libxfs/xfs_format.h     |    6 +
 fs/xfs/libxfs/xfs_log_format.h |   29 +++
 fs/xfs/xfs_attr_item.c         |  349 ++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_attr_item.h         |    2 
 fs/xfs/xfs_xattr.c             |   15 ++
 9 files changed, 460 insertions(+), 80 deletions(-)

