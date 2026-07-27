Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E14331F9BC;
	Mon, 27 Jul 2026 05:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785129770; cv=none; b=ubZ47uN8g2LwPD6Jk6kczQSTnp/LHVNB80qJE90B0mveq142oFwltnkgh8CJft0Rdlh8HfSGUGm5xKWS5bGqC0upCGob9J37xkezLWJt3uKQGrPu53zja4H5c6iB/HLzdaEhpFwOB1Ll01hUorjus+PfeRcq/W6xHkTCPwJEdbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785129770; c=relaxed/simple;
	bh=aCA8lO80bR8RLZFSk9c4orCaRb6bCWflFbTjywLfuUA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=pm0Qecd6PXOArdsDpclpO4GQszmLQLjK+HKmcWc0UsloKihlQGb/aB3BsZUqRXO12zjH5+uRb+5jNhj5ozHP23iQt1+KpyF7DR3L9i6s7x21/wgWDZIeHrOGP87lIDCfemOG1J17NQ/ffhXRz74C+roJVoe82+ehsJHNYOcrF8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BEUBDs7V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BEUBDs7V"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 12B4C1F000E9;
	Mon, 27 Jul 2026 05:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785129769;
	bh=o4OE1uxn76VVrybt60Ig9zNQ65JGIOVmbQg4/ycqz7A=;
	h=Date:Subject:From:To:Cc;
	b=BEUBDs7VGFa7ZhpTbowfPrSXVBhIaLmjltedfxnEI377ES3SPmx80gAe1kChIgWZX
	 0fdLAtfoH5ZwrQuGLz1y6gImhST/y1YtrSMpO76zJB2OWQME64L8asa4rLP2vwEzID
	 yk9vKVUTnEDY1DNqRi6iE6CmlOs93qvOsjhVnX7uiEyLBk0HU1ms9cB9d/eUzjwWEf
	 1zYiBAFptPtT5TBvfhGxns0YmKdfPSTBjmUj51w2eEeeoeXUcxnABP0Hv23IAynlXW
	 GIa8JQKCUJBUzExcl1H5h4oncYrf4kaq5ZQr7lPBgs+kc9j1qw5XFCsrD5sXV2ATIB
	 ASmQuAzbqHfMQ==
Date: Sun, 26 Jul 2026 22:22:48 -0700
Subject: [PATCHSET 1/2] xfs: LLM-inspired bug fixes, part 4
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178512389129.1494795.16117444961252720216.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a fourth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-4
---
Commits in this patchset:
 * xfs: only check mergeability of bnobt records
 * xfs: don't double-lock when deleting a self-referential directory
 * xfs: don't return EFSCORRUPTED when scrubbing corrupt parent pointers
 * xfs: don't zap the attr fork on repair when there are queued pptr updates
 * xfs: nlink scrub must take IOLOCK before determining ILOCK state
 * xfs: avoid UAF on sc->tempip in xrep_tempfile_create
---
 fs/xfs/scrub/alloc.c          |    5 +++--
 fs/xfs/scrub/attr_repair.c    |    3 ++-
 fs/xfs/scrub/dirtree_repair.c |   22 ++++++++++++++++++----
 fs/xfs/scrub/nlinks.c         |   13 +++++++------
 fs/xfs/scrub/parent.c         |    2 +-
 fs/xfs/scrub/tempfile.c       |    1 +
 6 files changed, 32 insertions(+), 14 deletions(-)

