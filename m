Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8021DA21
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224230; cv=none; b=ZnFylO+qMEiHh6dpfOyAvqch97reAfQEhGKoCsbmFxiggRj2FD3AvwiHLn6JsDSyO6Y6phnkj+pB+6W56ym3ilRXRZpwtHEymflYooh5l1iwrh0O6MgUDfAIXm4yzDRUGnUZo/Hm0LM6BZ+0CFCwIlkzx6k+mwk4VbYxq8rK4H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224230; c=relaxed/simple;
	bh=3VAzYs0eSJAHiCBk1HJG0BjVyyd+EJhL2Iwc/ccknqQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c03DqsR2z69TI6TBvO2ly5mCt1RAiBZA/S3WdoLujU25RclQmF7jd/gg1My/KOKLqiefrgjOVh7tbhBYTnY/lRfm/Mfjji4lZO42/wvknsLmeSbShiM6oujxXw4cuvGKnwlX0GFJhqVJssN1r7mzgua7R85mjaUQFL3ZikFadgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FiWAza+1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FiWAza+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D01C113CC;
	Mon, 15 Apr 2024 23:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224230;
	bh=3VAzYs0eSJAHiCBk1HJG0BjVyyd+EJhL2Iwc/ccknqQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FiWAza+1R8DmUAcFvPC6KvUrPDaPxoSbh+GC2OoQIbwpb6EONqJFAHPe/PbtiZ6vx
	 +7psdtg2erxdT5YtNwraMEgYWx1dmhBumjIo1s/AOvuNsi9kr1AaaWXLRB2QoBdJ4O
	 ikPKAxaaIl5iO4SIH/LHWHUJRX9kkof0A6lFAfESo4nqDLRl0B9wL41TTCs94NmDEm
	 tVZzTfP1CVNQVl/mLrvat+9f+JzzSdwjW3V2KCk6OiZaP+1ZnjOo7lSPCzkAYG1S3m
	 8s0ohuQhTStJGHvlQ7+imZvXyB/Ly08rtC9ECcedc1RhP+RhcuBffI26XSf6xD3Y+M
	 X3hveZAeY8myA==
Date: Mon, 15 Apr 2024 16:37:09 -0700
Subject: [PATCHSET v30.3 14/16] xfs: less heavy locks during fstrim
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171322385769.91801.8743955175385878183.stgit@frogsfrogsfrogs>
In-Reply-To: <20240415232853.GE11948@frogsfrogsfrogs>
References: <20240415232853.GE11948@frogsfrogsfrogs>
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

Congratulations!  You have made it to the final patchset of the main
online fsck feature!  This patchset fixes some stalling behavior that I
observed when running FITRIM against large flash-based filesystems with
very heavily fragmented free space data.  In summary -- the current
fstrim implementation optimizes for trimming the largest free extents
first, and holds the AGF lock for the duration of the operation.  This
is great if fstrim is being run as a foreground process by a sysadmin.

For xfs_scrub, however, this isn't so good -- we don't really want to
block on one huge kernel call while reporting no progress information.
We don't want to hold the AGF so long that background processes stall.
These problems are easily fixable by issuing smaller FITRIM calls, but
there's still the problem of walking the entire cntbt.  To solve that
second problem, we introduce a new sub-AG FITRIM implementation.  To
solve the first problem, make it relax the AGF periodically.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=discard-relax-locks-6.10
---
Commits in this patchset:
 * xfs: fix performance problems when fstrimming a subset of a fragmented AG
---
 fs/xfs/xfs_discard.c |  153 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 93 insertions(+), 60 deletions(-)

