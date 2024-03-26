Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3853128387
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 02:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711421919; cv=none; b=Ecd9f4j1KkUaamoAa/MlYuNfzvwbscfSMgBd21pQupVbZOV/oN8UhmkTdLsyGj7tC5XXbpE1NXubqvIsdPfruZVobN7bmsbbBUREKy80+WLj+w3cHVe7yUopEN5teFvKH9oBJj00rmwFn/LCJbS4Z3LFKdJzllCI/aaCnGUJF10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711421919; c=relaxed/simple;
	bh=t4b6FqXMcYYlfdASueTIkw+fmKE/YmQ+dogefvdJGsY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZYmV2pieAvb8yhKXqOKeCNijiYSELqaujiQgMKzky4oRUhoKnQ0OYhQWriDBRcHI27EEgrxaHDzwaSxmkoGh0STWWtplrzF8Vkas7k54cXJqWxgfn2XRbJMilUCSTL0ZiRccJn+nM8b66XEBQjomnwYBRwF3KQUcAyQIpm0aaUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A1Jnk1lm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A1Jnk1lm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61114C433C7;
	Tue, 26 Mar 2024 02:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711421919;
	bh=t4b6FqXMcYYlfdASueTIkw+fmKE/YmQ+dogefvdJGsY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A1Jnk1lmDzkAlHLEtBb9L37hGKzkSNU48HNJwSpkyGEmN5XZmGwopJsqOQZ9aC/TJ
	 IJYUUpSaTp/ayGc4E1NKkZdVUWKLmCGx1EETN0Azlt9OZUsaLkoYjGkVGOR+xiXzCz
	 2Bo/Z2CuOKsHIguN1zAcJLfVNAS1JnFUBWndDOUobVmleBRPo01cwlUndm4OJFWear
	 rmAHBEgQjFb6/sCCDgKE/QjlzZFTqkM6wHvQcvt3K76F0v6US0iLpEA3YvHU8B1bBD
	 3b5Y8kz+B+TORn4FJFuXaifjxIrxyh/E389kYEf9DosYM6kvCnYcQLhYtBtu1ZTHRd
	 XWyD9SSMSpLNw==
Date: Mon, 25 Mar 2024 19:58:38 -0700
Subject: [PATCHSET v29.4 15/18] xfs_scrub: updates for 6.9
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142134302.2218196.4456442187285422971.stgit@frogsfrogsfrogs>
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

Now that the kernel has the code for userspace to upload a clean bill of
health (which clears out all the secondary markers of ill health that
hint at forgotten sicknesses), let's make xfs_scrub do that if the
filesystem is actually clean.

Second, restructure the xfs_scrub program so that it scrubs file link
counts and quotacheck in parallel.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-6.9-fixes
---
Commits in this patchset:
 * xfs_scrub: implement live quotacheck inode scan
 * xfs_scrub: check file link counts
 * xfs_scrub: update health status if we get a clean bill of health
 * xfs_scrub: use multiple threads to run in-kernel metadata scrubs that scan inodes
 * xfs_scrub: upload clean bills of health
---
 libfrog/scrub.c                     |   15 ++++
 man/man2/ioctl_xfs_scrub_metadata.2 |   10 ++
 scrub/phase1.c                      |   38 +++++++++
 scrub/phase4.c                      |   17 ++++
 scrub/phase5.c                      |  150 ++++++++++++++++++++++++++++++++---
 scrub/repair.c                      |   18 ++++
 scrub/repair.h                      |    1 
 scrub/scrub.c                       |   43 +++++++---
 scrub/scrub.h                       |    3 +
 9 files changed, 265 insertions(+), 30 deletions(-)

