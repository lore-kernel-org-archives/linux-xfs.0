Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CCCB666
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f0OdS0hg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7C4C433C7;
	Sun, 31 Dec 2023 19:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052020;
	bh=cPi4AdTpQeaDyWL4q+4tppHVfCqS4X3IPOQKP1yvhTs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=f0OdS0hgfxjHibSYQeCr71XdtWBqwq6DWFQUHmujnfYdxpW3X+Y3DWLZou8En/9pZ
	 DkVnvjrynKkOMDedpwcFXYAiG1N7RJa6XaSMjjbjaprruDqf/Wq18xAuKDJOHY+rye
	 XFTnw/ocPVXdqjAxzecMrW/JpclIdwdBkT/IFsZMflnByPhIvD+KMF6JwCpvnnRbU8
	 ZIkGiuOrWHH+tCkH18XkLgbN4XVC38OfraYpjUAg/iUs4q6nCEl3f5QBrplK/xwjJI
	 dcXvXMo036T+boiHd8PvHC9rrS69b6KqkvBpjCS6//zjpfdgcUP/2kBrmzyP3xVYu3
	 k8VK+ht1fidVA==
Date: Sun, 31 Dec 2023 11:46:59 -0800
Subject: [PATCHSET v29.0 28/40] xfs_scrub: track data dependencies for repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404999439.1797790.8016278650267736019.stgit@frogsfrogsfrogs>
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

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-repair-data-deps
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

