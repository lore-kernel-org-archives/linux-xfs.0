Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96210947E
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929744; cv=none; b=r22fpH5FAI7xByG/z7J44Zndhz/2d9nZFgnCjGafqauaX0wyYuk30a3kIVe9I4qkOPgZPySLGgoIA8oaoy6iRfe5iuimeIIrh+IoHv2wN4dutlkiZIFvv4H6oBqm7tag0M3W9whZ/oRWEnLOLpTHZ4N+sxj8JzBLGz8SMLLttnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929744; c=relaxed/simple;
	bh=cvUpwSY3GYjNdEe1Opr0v5SvE01dAg4c3mo02QVHxZI=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=psH6t7gcYLASbmTQt5AGjAIeeoN++767SSwV5AfrUbE3ygfTG5oOXPwZGaAuFF1td4OrSY5L83SjhvuQ/5+PoPYaTzgCLP68KZggkPBTpchjMjwil7I74hy8S4BEcbFq1bRhgGZTX8mhDjOTfgwCIxiDxDfine/DeU8QRESYHmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lsg3I0qv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lsg3I0qv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B335C116B1;
	Wed, 24 Apr 2024 03:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929744;
	bh=cvUpwSY3GYjNdEe1Opr0v5SvE01dAg4c3mo02QVHxZI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Lsg3I0qv2bHpD+1+Nu6h2GqMb7qkVkehXFcgYv/fqMnAs0kCAeMVUjL7H83PTo1Yv
	 JTJuXj4auDJ6prOXNleZz2Apze1C8SREvPkGrFGa59lAHhD2wOZnr763twSNTAy/H9
	 xIgxOHpmgNrXGziAhKFLagSQREPQxH6usPGn9n6HTowaKGuj/mgHHIrCFsaptI5U2H
	 mtXPDkigcNiyOn3hfc5xxBRD+xscdl5QhmBiFu6uJMdhpkdTSS1+ybjCdEUTvPNkc+
	 DLVv9I118ui016xrha8GxJPojhESdwgD8mWEPeTDWixeI2aO/DvH6lx79Jk8rxNzJs
	 CBAf00mpQgNQQ==
Date: Tue, 23 Apr 2024 20:35:44 -0700
Subject: [GIT PULL 8/9] xfs: reduce iget overhead in scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392953196.1941278.2628285121167396370.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240424033018.GB360940@frogsfrogsfrogs>
References: <20240424033018.GB360940@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit c77b37584c2d1054452853e47e42c7350b8fe687:

xfs: introduce vectored scrub mode (2024-04-23 16:55:18 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/reduce-scrub-iget-overhead-6.10_2024-04-23

for you to fetch changes up to 4ad350ac58627bfe81f71f43f6738e36b4eb75c6:

xfs: only iget the file once when doing vectored scrub-by-handle (2024-04-23 16:55:18 -0700)

----------------------------------------------------------------
xfs: reduce iget overhead in scrub [v13.4 8/9]

This patchset looks to reduce iget overhead in two ways: First, a
previous patch conditionally set DONTCACHE on inodes during xchk_irele
on the grounds that we knew better at irele time if an inode should be
dropped.  Unfortunately, over time that patch morphed into a call to
d_mark_dontcache, which resulted in inodes being dropped even if they
were referenced by the dcache.  This actually caused *more* recycle
overhead than if we'd simply called xfs_iget to set DONTCACHE only on
misses.

The second patch reduces the cost of untrusted iget for a vectored scrub
call by having the scrubv code maintain a separate refcount to the inode
so that the cache will always hit.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: use dontcache for grabbing inodes during scrub
xfs: only iget the file once when doing vectored scrub-by-handle

fs/xfs/scrub/common.c | 12 +++---------
fs/xfs/scrub/iscan.c  | 13 +++++++++++--
fs/xfs/scrub/scrub.c  | 45 +++++++++++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/scrub.h  |  7 +++++++
4 files changed, 66 insertions(+), 11 deletions(-)

