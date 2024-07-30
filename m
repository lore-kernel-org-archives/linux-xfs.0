Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617671361
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298729; cv=none; b=cQHn2KrVx91ew4ZfQv6QVROz84lELPjSOZGHyhf4WEooRYbDkCn4cBpWbUTDCT6cbHxPPxZ3tOS6YVj4Xe53ntpmBE8oQD6OTCx7WB6tM/tTK6vtCdM+nqAX8758Fz22JBiYFB6CyQ4rleB9/k00vLej4+iSA58XbRD6FIbCNWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298729; c=relaxed/simple;
	bh=4hzh8zTH6/QsMRpVNFf6KLoPwk9k+RdtFuNp0bBuagI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R+Ti3fyeFH4nOeKPNddk1UsTI3b2PU/wAO93hF4IzL3FKHA/EN9TdorC69DfjZMsJSo/MCyu4V5qw5XcvTLf2EKLMCKVUGuydVJKcbyeXwQncq5NV/3chTEWwHpiwziLYpaJjTs2O4LHHRsbSHfxQCPrwCgcuLYxbK623WznCtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qqAFv8MZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qqAFv8MZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE411C32786;
	Tue, 30 Jul 2024 00:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298729;
	bh=4hzh8zTH6/QsMRpVNFf6KLoPwk9k+RdtFuNp0bBuagI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qqAFv8MZXekPSgov+NYyJSVcwWKa0eN/nFskT/fTPs884c2JYYR4SR4XpQvFt0giJ
	 T2sb0h3+FVp9vTXg3Brd7nMu4h/2oXgP5r6M0QofPUucQae/K55mBLLATS12iKp0F8
	 w58Zo4BugFIMsCujIkDlQvXIqPa2yQMK+IsKxe03Dj954tpGnuG3j1W910x9x7RKWP
	 5OmYZfcaWqniZ8Dh+RuDRhbVeMRfo4m5tHz8TMcQOjFQ85NFpr/3kzvkwMqeJYoX1x
	 Y92HmPgJFRD9m5pLN1NFq2CZLltJ+1kkU8pEO2pCctHYQ+UqSuUnhZzmSKNAxz8ANd
	 bgyokBx1sZD6A==
Date: Mon, 29 Jul 2024 17:18:48 -0700
Subject: [PATCHSET v30.9 09/23] xfs_scrub: use scrub_item to track check
 progress
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229846763.1348436.17732340268176889954.stgit@frogsfrogsfrogs>
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

Now that we've introduced tickets to track the status of repairs to a
specific principal XFS object (fs, ag, file), use them to track the
scrub state of those same objects.  Ultimately, we want to make it easy
to introduce vectorized repair, where we send a batch of repair requests
to the kernel instead of making millions of ioctl calls.  For now,
however, we'll settle for easier bookkeepping.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-object-tracking-6.10
---
Commits in this patchset:
 * xfs_scrub: start tracking scrub state in scrub_item
 * xfs_scrub: remove enum check_outcome
 * xfs_scrub: refactor scrub_meta_type out of existence
 * xfs_scrub: hoist repair retry loop to repair_item_class
 * xfs_scrub: hoist scrub retry loop to scrub_item_check_file
---
 scrub/phase1.c        |    3 
 scrub/phase2.c        |   12 +-
 scrub/phase3.c        |   41 ++----
 scrub/phase4.c        |   16 +-
 scrub/phase5.c        |    5 -
 scrub/phase7.c        |    5 +
 scrub/repair.c        |   71 +++++------
 scrub/scrub.c         |  321 ++++++++++++++++++++++---------------------------
 scrub/scrub.h         |   40 ++++--
 scrub/scrub_private.h |   14 ++
 10 files changed, 257 insertions(+), 271 deletions(-)

