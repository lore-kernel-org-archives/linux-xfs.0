Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD791B85FD
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 05:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752556551; cv=none; b=d2xKYcxuDsHRWtObAZim64hoDM5ijuwbyA/c9ZuLNTkfhmqK3RcYOV9QqL0qi/Eq2aUxPjZiAaC1zbFMnVASJmx98dJYJhtZktf7aNQV9iAMNJnd6mTprREh9pDmJMD7DdCu7Qvz5aIToQ2FNEP1M7RB6SJl46fEndX+3lwKnd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752556551; c=relaxed/simple;
	bh=lj7og8+cc+svuQxvG3S2Cdoe559Upney2rSdaYNJgwE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jEKmf+DSPnzXhQsiORyydR+VDCNNSHgsYqCoSAvPeKghF6XNgr6P6gx13tTHmV/CYosGX+oqXEgyEEhJaHPcDD/jdvsCOYQGPHpmBPyWl0FQx+Y+Htdd2Ed2uY+SIRDrLujodlQZq60EB6mqdmg3MtlzkP2GnrQdmZIsWntmYh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tgBr+4dD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tgBr+4dD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D76FC4CEE3;
	Tue, 15 Jul 2025 05:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752556551;
	bh=lj7og8+cc+svuQxvG3S2Cdoe559Upney2rSdaYNJgwE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tgBr+4dDYeJQ+x6zdn/LUKeOz/i9hJrZ9+L31Y9frHFThUPYJKlXsMJC7nOTY8wKu
	 7kBGc3fOD0Vd6nqZNUxwTHf1aZv2zR6++aomsOfPHky2n+ZBKZ+lArNfNMHEN/LIZ7
	 Rtdq9VeGl3BWbusux4uJoIX6nKxyKoqJNlA/kYUE9gVHOR7/XxLnTSaysLzDxDhh7s
	 UUirHWQfRvbhm/Gk2fwJQTiE6SkELZSnknh5zChPMM8bvHN43QqgvX067utmnLkyl/
	 2eV8+Le07/AyZ1lk2yrVpZauRMaJISD7NJsdzzgC5iKj/C2apBzh/lJXV1W7jcSwA7
	 TEQwQYN/6n8iQ==
Date: Mon, 14 Jul 2025 22:15:50 -0700
Subject: [PATCHSET 1/3] xfsprogs: new libxfs code from kernel 6.16
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: john.g.garry@oracle.com, hch@lst.de, catherine.hoang@oracle.com,
 john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <175255652087.1830720.17606543077660806130.stgit@frogsfrogsfrogs>
In-Reply-To: <20250715051328.GL2672049@frogsfrogsfrogs>
References: <20250715051328.GL2672049@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Port kernel libxfs code to userspace.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-sync-6.16
---
Commits in this patchset:
 * xfs: add helpers to compute transaction reservation for finishing intent items
 * xfs: allow block allocator to take an alignment hint
 * xfs: commit CoW-based atomic writes atomically
 * libxfs: add helpers to compute log item overhead
 * xfs: add xfs_calc_atomic_write_unit_max()
 * xfs: allow sysadmins to specify a maximum atomic write limit at mount time
---
 include/platform_defs.h |   14 ++
 include/xfs_trace.h     |    3 
 libxfs/defer_item.h     |   14 ++
 libxfs/xfs_bmap.h       |    6 +
 libxfs/xfs_trans_resv.h |   25 +++
 libxfs/defer_item.c     |   51 +++++++
 libxfs/xfs_bmap.c       |    5 +
 libxfs/xfs_log_rlimit.c |    4 +
 libxfs/xfs_trans_resv.c |  339 +++++++++++++++++++++++++++++++++++++++++++----
 9 files changed, 429 insertions(+), 32 deletions(-)

