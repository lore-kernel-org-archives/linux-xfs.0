Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC40D128379
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 02:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711421809; cv=none; b=QkqFue5WSQrwIOE12H2t/83NdUgUpH/rBK6HA+b++ZW+NmNPWr3WtvPu3SppV8YE9wV4OQpTgfFS7D/SCsfmFfSN9tSrl+0VITS3N3d74eX6DlTH7i+4S33EGEuHwlMjzHuUQBSqhKztASNE6+tjgTTvAgiwvoKDRhBycglZNu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711421809; c=relaxed/simple;
	bh=oEzGU0e/z/oc0uPY059Bqe+K1pJ1pYwxdo9sDqP0M7Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J9fxvfN0CzN47nuZ+qOXI11v6MU6CSZU2Xhsrmcgh2o05SxLSXqSamqpMhXBo6JxGrOpVDmPOrv5g+gngv07wvn+b9JrN5NDk2cfUR0JrA5pM0HvGgsLPm3tOcexl47TIgkx6PWkKahjS/PCaqEdRPJHpKxUBCFxTa+XWIcnlAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qqka9djT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qqka9djT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9042EC433C7;
	Tue, 26 Mar 2024 02:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711421809;
	bh=oEzGU0e/z/oc0uPY059Bqe+K1pJ1pYwxdo9sDqP0M7Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qqka9djT8Q6L4lZk9npa0ItwNQVJHyWPYJyXiMDcqBblpptWiK4/Y8XafGj0yYYuF
	 YUvS2lRQohFdjQ6uWEUgoZqGWOo3fy9jOkMQRFbcWz3Zm4S9vnFaGhWtws9XMdUZAD
	 FZdYSZsQfrjhD1g+mAIOv9w8FCZgc1rtmnLeWDX8l0uKs3Nh9SZyUm7yOlTBO9kiLI
	 jBKHe1POTmrmZk8IsA8bts7LD6+hUjmMM7Pm3TLY01PXFZGc2nMxgPXDWpLIQ1J0G4
	 YGjL4DBjPbCCbkYZxIcNXkz3cH4xf6BouFQfldqQaGTdtlTZuW/Oviq19wN7fFhgxU
	 Q+yE9yBSVqjUA==
Date: Mon, 25 Mar 2024 19:56:49 -0700
Subject: [PATCHSET v29.4 08/18] xfs_repair: rebuild inode fork mappings
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142129996.2214666.4453203940040588605.stgit@frogsfrogsfrogs>
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

Add the ability to regenerate inode fork mappings if the rmapbt
otherwise looks ok.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-rebuild-forks
---
Commits in this patchset:
 * xfs_repair: push inode buf and dinode pointers all the way to inode fork processing
 * xfs_repair: sync bulkload data structures with kernel newbt code
 * xfs_repair: rebuild block mappings from rmapbt data
---
 include/xfs_trans.h      |    2 
 libfrog/util.h           |    5 
 libxfs/libxfs_api_defs.h |   16 +
 libxfs/trans.c           |   48 +++
 repair/Makefile          |    2 
 repair/agbtree.c         |   24 +
 repair/bmap_repair.c     |  748 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/bmap_repair.h     |   13 +
 repair/bulkload.c        |  260 +++++++++++++++-
 repair/bulkload.h        |   34 ++
 repair/dino_chunks.c     |    5 
 repair/dinode.c          |  142 ++++++---
 repair/dinode.h          |    7 
 repair/phase5.c          |    2 
 repair/rmap.c            |    2 
 repair/rmap.h            |    1 
 16 files changed, 1231 insertions(+), 80 deletions(-)
 create mode 100644 repair/bmap_repair.c
 create mode 100644 repair/bmap_repair.h

