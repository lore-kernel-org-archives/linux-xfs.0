Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7B6B65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SXP/fS5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA4CC433C7;
	Sun, 31 Dec 2023 19:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052051;
	bh=XH2kw/kiBmLBEdPCGGvVFnIkXTrZlTATXjZ50XcY6WY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SXP/fS5tbv5Y5OGl6+0x0vrg2+LdNYTyHjD3uw6xWgXANGoTZGJjM3O9DSrwA8aGK
	 YFpx2cJje+L5+HM8O3psTwaGltbaJ2prVvLWdJgLCG8+8P5TH52M/APy7+fKMmM8vz
	 W4+iPwfzuzSbYX6ZObU9PQreJe+GLfqRmmfPuQozvlazzYmyVFGFJhKCDeHV4jz2+2
	 DbkNx02m4fnh+lzMqbLFKuEgwq7GtBBbTNd0/MI+qWHxUt3kmol2Rugfs6MiIKVE4j
	 C/osutLFygjrdGUF8hbuJl+byN2vdGeZvzdxH47EHAY0iJsn2jkHVHyLL/5Mbf3vPX
	 XacRMvqmrZFNQ==
Date: Sun, 31 Dec 2023 11:47:30 -0800
Subject: [PATCHSET v29.0 30/40] xfs_scrub: improve scheduling of repair items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405000222.1798235.1301416875511824495.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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

Currently, phase 4 of xfs_scrub uses per-AG repair item lists to
schedule repair work across a thread pool.  This scheme is suboptimal
when most of the repairs involve a single AG because all the work gets
dumped on a single pool thread.

Instead, we should create a thread pool with the same number of workers
as CPUs, and dispatch individual repair tickets as separate work items
to maximize parallelization.

However, we also need to ensure that repairs to space metadata and file
metadata are kept in separate queues because file repairs generally
depend on correctness of space metadata.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-repair-scheduling
---
 libfrog/ptvar.c       |    9 ++
 libfrog/ptvar.h       |    4 +
 scrub/counter.c       |    2 
 scrub/descr.c         |    2 
 scrub/phase1.c        |   15 ++-
 scrub/phase2.c        |   23 ++++-
 scrub/phase3.c        |  106 ++++++++++++++-------
 scrub/phase4.c        |  244 ++++++++++++++++++++++++++++++++++++-------------
 scrub/phase7.c        |    2 
 scrub/read_verify.c   |    2 
 scrub/repair.c        |  172 ++++++++++++++++++++++-------------
 scrub/repair.h        |   37 ++++++-
 scrub/scrub.c         |    5 +
 scrub/scrub.h         |   10 ++
 scrub/scrub_private.h |    2 
 scrub/xfs_scrub.h     |    3 -
 16 files changed, 455 insertions(+), 183 deletions(-)

