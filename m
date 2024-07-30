Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD21E17FD
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298744; cv=none; b=DxrK83vY8SMh8MiQe5pmJ6qVYXSEtdUufDgdn5i3Mpp88HCWEgZXA5x5Ztq4YOwj1mtqgcJjo/6hVZeiKzlSaCCEmNBBpsj1iut9MIo4Qssy9S/P2S2aawgWX9FwXBbG++VxuOR1NOsTYx46hSWsbTXgGMBaeFm2usROr90dQMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298744; c=relaxed/simple;
	bh=yCLq0i6tMUe0LXZ5kTZdFsjMe2FLhBSCIgSfYf8LkW0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a2gw3RQKL64ZmAdT9Dic3OnpH+l/PB+U5dG7thnleogtTQYjPQq4i8gVN2FzVQZcFGt1hohpgdAVGa0+jB0ff4lwcmDkTsyp9P5S6g57gVbIxrR5JKf1PlmYblN6yyATBxIe4pCjwGOo6crhnAf08VRhqcg3qRqa9k317mOHLZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C/rXAmF/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C/rXAmF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF86C32786;
	Tue, 30 Jul 2024 00:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298744;
	bh=yCLq0i6tMUe0LXZ5kTZdFsjMe2FLhBSCIgSfYf8LkW0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C/rXAmF/TPAN+XcFXd730TjykL1sF3FFGxoh6Je94Q8jOnADP/B6KbQI1HdhAaCNd
	 0yX4+gdhe+UD6+jXo+BJtG3Hi2MNR8m+d7Qf9zg4iYN9hslOZxqIK3IfMySl3LouOu
	 RXFM7sU1IfA60V8wo7HLCsWytB1Ht7sc6BvPWvvydCr0tDofZOUE5KUUiOyWTlldc/
	 O6/BUFzNG5hKz15Vi2rE1PjA/S5BqmpEeLwQ90z7HduEEbv59gMTTxn4wX1C0AZFJ0
	 eAmluVgftPqhh0Exj1oGDQCAzL6fkNt7tDqFs+WYSB5vNujZGpqkLPMarBnK+bwDYX
	 pqRj6ozecHFZQ==
Date: Mon, 29 Jul 2024 17:19:04 -0700
Subject: [PATCHSET v30.9 10/23] xfs_scrub: improve scheduling of repair items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229847145.1348659.7832915816905920685.stgit@frogsfrogsfrogs>
In-Reply-To: <20240730001021.GD6352@frogsfrogsfrogs>
References: <20240730001021.GD6352@frogsfrogsfrogs>
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

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-repair-scheduling-6.10
---
Commits in this patchset:
 * libfrog: enhance ptvar to support initializer functions
 * xfs_scrub: improve thread scheduling repair items during phase 4
 * xfs_scrub: recheck entire metadata objects after corruption repairs
 * xfs_scrub: try to repair space metadata before file metadata
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

