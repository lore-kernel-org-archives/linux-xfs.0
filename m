Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8A1653
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298854; cv=none; b=EnJUJC1qxsjc/98EaoUw68mWui5dBS8f7kK4+UkKd10JKOWWxPeaqjD3djd4JcJNDx9qDJoS4DCtWPbZ9DCw15iG7u4woVCP//+ZvIulpOunqXRwHyzcvKrJgwffJd5Jn/c5IQ3uRcbnxcpi0abA+BwDCSX1nWawNdk4+wAhmsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298854; c=relaxed/simple;
	bh=5PVdtbwrAdVK+RRrbiUVH75E7tJihutKKJxwvDNAOxQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eupdYcbtMeZ/Mjtg1EXU1wGFzntNfGTNKzUWG954yQOOMX0Is5OTlTU5zqW05SxHyiS/UrLV+FU5brYLD5ALc86VcH8BX/pUxX/Y6vM0SY1kzUH+ubBKc45SHJuBXWp9PbRUsCZ2FKeWT5uxxFCsenTQAQ2MGUWLX/p6pMCgqFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zizt+8dc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zizt+8dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B68C32786;
	Tue, 30 Jul 2024 00:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298854;
	bh=5PVdtbwrAdVK+RRrbiUVH75E7tJihutKKJxwvDNAOxQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Zizt+8dcuZBzvfc2Bhkzxu20TQUNNNekfzD5hygFUlmRs/ZIvWpb1uHvcmaRNC4E8
	 VxlCK9wO7kmcM/J1L1hy4Vmrm/AD1tvGhJERbfMEu/PyXiVqQyGtDWYVd6BrZLbQqe
	 cgiQ2nqeJdVNr1rems82Xy/rpg79EpzMqEJEMEUyj0th9H6dZdKpMjoXsoJlSSxtqs
	 BMQcMrg33co7rPqXbtbZn5p86r02Nbo7tLlIBBy18YWiE538KYIQT+7MKmBr2STxj1
	 pEnBN1n0P8rkaPmITYYbTirq0mRD/LdEwEiCwpd51vgp7AERhinXjHulp7pRXWtrDk
	 Jp5+CzC2plUkw==
Date: Mon, 29 Jul 2024 17:20:54 -0700
Subject: [PATCHSET v13.8 17/23] xfsprogs: improve extended attribute
 validation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <david@fromorbit.com>,
 Chandan Babu R <chandan.babu@oracle.com>, Christoph Hellwig <hch@lst.de>,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172229850048.1350643.5520120825070703831.stgit@frogsfrogsfrogs>
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

Prior to introducing parent pointer extended attributes, let's spend
some time cleaning up the attr code and strengthening the validation
that it performs on attrs coming in from the disk.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=improve-attr-validation-6.10

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=improve-attr-validation-6.10
---
Commits in this patchset:
 * xfs_scrub_all: fail fast on masked units
 * xfs_scrub: automatic downgrades to dry-run mode in service mode
 * xfs_scrub: add an optimization-only mode
 * xfs_repair: check free space requirements before allowing upgrades
 * xfs_repair: enforce one namespace bit per extended attribute
 * xfs_repair: check for unknown flags in attr entries
---
 include/libxfs.h         |    1 
 libxfs/libxfs_api_defs.h |    1 
 man/man8/xfs_scrub.8     |    6 ++
 repair/attr_repair.c     |   30 ++++++++++
 repair/phase2.c          |  134 ++++++++++++++++++++++++++++++++++++++++++++++
 scrub/Makefile           |    2 -
 scrub/phase1.c           |   13 ++++
 scrub/phase4.c           |    6 ++
 scrub/repair.c           |   37 ++++++++++++-
 scrub/repair.h           |    2 +
 scrub/scrub.c            |    4 +
 scrub/xfs_scrub.c        |   21 +++++++
 scrub/xfs_scrub.h        |    1 
 scrub/xfs_scrub_all.in   |   21 +++++++
 14 files changed, 272 insertions(+), 7 deletions(-)

