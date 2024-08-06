Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D485E28DD1;
	Tue,  6 Aug 2024 18:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722968328; cv=none; b=U/iui62nFxWmOHjZSPOGCON3m8LYZa11wRj5CU8QvidvREbQuch3J3/fMky9Ua4/95ez9v9WH+iD/ssunjpto6SMYoyJUNWyzbWk0ONmhYnVfya8IybqENA8ginhj0E8Mxjrf6BVDOzCITRHWa6+vYzQxnwDyRhEn3G/p5A3OMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722968328; c=relaxed/simple;
	bh=0S4fe2U4BWe/78atFw5LbpjVu54FPfLw/mlYgBNNPj0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mtnfoGCJJ9GG/4tRHk8BVpshp0fnMvCAS86mC/zZpCQAkxSE7CnAcF5+fLbVnZSDNJdsRRH35Nt9wZYprzFptmeP9OJOm3gKzuLofYhc0UyABBRKKFB/fDejPYS/2BeX0a8SDQL8PZr0K6f2mMBPL39luHRKgaHDku5krYrlaXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WRE/+87e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WRE/+87e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57649C32786;
	Tue,  6 Aug 2024 18:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722968328;
	bh=0S4fe2U4BWe/78atFw5LbpjVu54FPfLw/mlYgBNNPj0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WRE/+87eBGuXOaBmEuobXsfpuJWfrGDJ5z+IdIhQAt4nyBSSzXV/2w01jlVsldU5Z
	 ivoNcglH5NocGPXwq4xKw25Q1EtPPwBtF/BwCZICfGyr/PnwyvR+oLYz0kk2NC8xpL
	 gX9qVv+4tybYwt2VyXTfy/QUq/FrAi/dFSMLqL+jISrqyfJ+7xp6tIOee/UaA53x+Z
	 SqD3hX76oDc0lzVqsy4DztjOEmpzuUuL74mch5W9v/Qvd9/b9UY2OkNAZQY4GgF5Oh
	 ZtEDkpCU5WhPFJOnE2qfTQ3S3tIKZ475oRh7zR+qEOTHE2QNqF1F7HWGxMbJbdfoNF
	 5FiGEGA2fKGSQ==
Date: Tue, 06 Aug 2024 11:18:47 -0700
Subject: [PATCHSET v30.10 2/3] xfs_scrub: admin control of automatic fsck
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, dchinner@redhat.com, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <172296825594.3193344.4163676649578585462.stgit@frogsfrogsfrogs>
In-Reply-To: <20240806181452.GE623936@frogsfrogsfrogs>
References: <20240806181452.GE623936@frogsfrogsfrogs>
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

Now that we have the ability to set per-filesystem properties, teach the
background xfs_scrub service to pick up advice from the filesystem that it
wants to examine, and pick a mode from that.  We're only going to enable this
by default for newer filesystems.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=autofsck-6.10
---
Commits in this patchset:
 * libfrog: define a autofsck filesystem property
 * xfs_scrub: allow sysadmin to control background scrubs
 * xfs_scrub: use the autofsck fsproperty to select mode
 * mkfs: set autofsck filesystem property
---
 libfrog/fsproperties.c            |   38 ++++++++++++
 libfrog/fsproperties.h            |   13 ++++
 man/man8/mkfs.xfs.8.in            |    6 ++
 man/man8/xfs_property.8           |    8 ++
 man/man8/xfs_scrub.8              |   46 ++++++++++++++
 mkfs/lts_4.19.conf                |    1 
 mkfs/lts_5.10.conf                |    1 
 mkfs/lts_5.15.conf                |    1 
 mkfs/lts_5.4.conf                 |    1 
 mkfs/lts_6.1.conf                 |    1 
 mkfs/lts_6.6.conf                 |    1 
 mkfs/xfs_mkfs.c                   |  122 +++++++++++++++++++++++++++++++++++++
 scrub/Makefile                    |    3 -
 scrub/phase1.c                    |   91 ++++++++++++++++++++++++++++
 scrub/xfs_scrub.c                 |   14 ++++
 scrub/xfs_scrub.h                 |    7 ++
 scrub/xfs_scrub@.service.in       |    2 -
 scrub/xfs_scrub_media@.service.in |    2 -
 18 files changed, 353 insertions(+), 5 deletions(-)

