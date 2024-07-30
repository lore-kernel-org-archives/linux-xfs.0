Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D7910E3
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298713; cv=none; b=SnW+p+TrpclsRs4f1BejbaCliaVnbivL4Oabc6flQjPVMa8DzhRv8/gsADnEi50DWqSS0CnFFtYpmIdm4j2uOITaOtDRVtLsq38BBJMqcCQxOkBgmJANXHBA7XcHWaKPqURyPxSjApSMx0CBRaNWC8ItMn48OqQPHF2YSBiMf1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298713; c=relaxed/simple;
	bh=k1TcXX4YdkBYXNgsaIgploikRzWvQN58v78lOO7U0NE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d67iRbv2uyapHdbqa5wMyXH30m312sqQdoT3jNC1bpXeIVMDFUKTp9S2TOShP2TNbhxcfOEcU8mu1QTa5KageJH/+Vb1o+uxM47GVNeImBczeTyyMYGDXIj1SNkuW8Toqs82MZpmqpR3zlNcjnyysX9J8ktf5vopKof/QK4ArYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jCi/w7GP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jCi/w7GP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5195AC32786;
	Tue, 30 Jul 2024 00:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298713;
	bh=k1TcXX4YdkBYXNgsaIgploikRzWvQN58v78lOO7U0NE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jCi/w7GPAOWHvzTXxU0OsEEF5PaSdlKNWh3yGYd4k+gHOg9mZCdhPor5GoRwOmIXA
	 3oknMRrI393scGor7Yhn18C9HWWqtsl4rRoNOvOR997aHyPheoCwVr/4wIc55GHZLG
	 fQdYtFdtACAJvHdKtYKtH/lnW2WdEmdwbe6fLP9ddFe1a/SC8+eNh2ecjG7B1W3S9Z
	 kxRoWd5DzzdAgNzeMKXbXJiZY4OrE5vmvL850OMhCP2BwABbkko6xVL3yOsv2mpkaD
	 SijT4FP4DihWr/8Ga3XS3AxylSV1fBVZiFpTBOx4B5eLxBuUkk6MArRHsoo0kqrQKo
	 4YWrk0dN+zgGQ==
Date: Mon, 29 Jul 2024 17:18:32 -0700
Subject: [PATCHSET v30.9 08/23] xfs_scrub: track data dependencies for repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229846343.1348067.12285575950038094861.stgit@frogsfrogsfrogs>
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

Certain kinds of XFS metadata depend on the correctness of lower level
metadata.  For example, directory indexes depends on the directory data
fork, which in turn depend on the directory inode to be correct.  The
current scrub code does not strictly preserve these dependencies if it
has to defer a repair until phase 4, because phase 4 prioritizes repairs
by type (corruption, then cross referencing, and then preening) and
loses the ordering of in the previous phases.  This leads to absurd
things like trying to repair a directory before repairing its corrupted
fork, which is absurd.

To solve this problem, introduce a repair ticket structure to track all
the repairs pending for a principal object (inode, AG, etc).  This
reduces memory requirements if an object requires more than one type of
repair and makes it very easy to track the data dependencies between
sub-objects of a principal object.  Repair dependencies between object
types (e.g.  bnobt before inodes) must still be encoded statically into
phase 4.

A secondary benefit of this new ticket structure is that we can decide
to attempt a repair of an object A that was flagged for a cross
referencing error during the scan if a different object B depends on A
but only B showed definitive signs of corruption.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-repair-data-deps-6.10
---
Commits in this patchset:
 * xfs_scrub: track repair items by principal, not by individual repairs
 * xfs_scrub: use repair_item to direct repair activities
 * xfs_scrub: remove action lists from phaseX code
 * xfs_scrub: remove scrub_metadata_file
 * xfs_scrub: boost the repair priority of dependencies of damaged items
 * xfs_scrub: clean up repair_item_difficulty a little
 * xfs_scrub: check dependencies of a scrub type before repairing
 * xfs_scrub: retry incomplete repairs
 * xfs_scrub: remove unused action_list fields
---
 libfrog/scrub.c       |    1 
 scrub/phase1.c        |    9 -
 scrub/phase2.c        |   46 ++--
 scrub/phase3.c        |   77 ++++---
 scrub/phase4.c        |   17 +-
 scrub/phase5.c        |    9 -
 scrub/phase7.c        |    9 -
 scrub/repair.c        |  530 +++++++++++++++++++++++++++++++++----------------
 scrub/repair.h        |   47 +++-
 scrub/scrub.c         |  136 ++++++-------
 scrub/scrub.h         |  108 ++++++++--
 scrub/scrub_private.h |   37 +++
 12 files changed, 664 insertions(+), 362 deletions(-)

