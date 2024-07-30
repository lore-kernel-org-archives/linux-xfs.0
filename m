Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348CF12E1C2
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 02:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722307344; cv=none; b=QgTgqiZDcsX1CW1sQ7LLaQBBBTbNy+TA9I9XKgxWpBIBicPOpktCuYh1/6EMQG322cdmdMLoKKnQkPJ5Oj79ZTukiPfpVjWiCOmd+LSEthP1LINRAtU7zEzyOa5Fdo3RexnyESIy4EHFn5/AFSQEAqWW/Ze/pMx5gRxWR7g/Z8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722307344; c=relaxed/simple;
	bh=J8++nZCZAtlXU7XGfEOTqMX+bs2WJK0J3XmlbAMHYAE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=A7oWxBWZ2ZWLnQtfQagsS8CY4TFaIbmFyk/tEoYxlVPbSSIJLnvNR/b2XOH2QtTVIv3HjESgb4+UBTcvNO/F14z6M9XtGOdpz1ji6zeDPrseOKkLhuLbSGFDSy7eLeMR0sUEf9uOiDIsuhRQvLXgeC35u+eOTs6Ti5ec8MEJoLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TPmNlVoL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TPmNlVoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC80BC32786;
	Tue, 30 Jul 2024 02:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722307343;
	bh=J8++nZCZAtlXU7XGfEOTqMX+bs2WJK0J3XmlbAMHYAE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TPmNlVoLu0kNtlIMyKzpa7ZDxpvTwDk9EB+EBnwM15v48GnWR5jjHkU324YhRBoUz
	 adRfRRYFdOhgYFYvcGB0lVoQYYhJ1vJrtaW7qHc1MhWdyBD399nVhoKQoHxxVXhVJw
	 fkJwcYI91XpiK6peoZ8fJBVnLKlsQy2khS8azD+f4gJSMofzesUuBbBENJDcqNljBa
	 PJL85YVLczA0UKAw1pYR3+pIYoRdwj9QULH0S0ZP7LWWJEdAeXiz0hXmwiYBpJHcnM
	 KYPRQQBqaDhaNYnLaN0rG6/wmp+jI6PCwnlmx24Axa3gQM8q4KQh5d1yZp8d+WuQ/D
	 sehTAURSD4SLA==
Date: Mon, 29 Jul 2024 19:42:23 -0700
Subject: [GIT PULL 08/23] xfs_scrub: track data dependencies for repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172230458555.1455085.3083483586761912777.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240730013626.GF6352@frogsfrogsfrogs>
References: <20240730013626.GF6352@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit bf15d7766e3dd63eda56f6b2f7976e529cd07575:

xfs_scrub: enable users to bump information messages to warnings (2024-07-29 17:01:07 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-repair-data-deps-6.10_2024-07-29

for you to fetch changes up to 81bfd0ad04a58892e2c153a22c361e7ff959f3fd:

xfs_scrub: remove unused action_list fields (2024-07-29 17:01:07 -0700)

----------------------------------------------------------------
xfs_scrub: track data dependencies for repairs [v30.9 08/28]

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

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (9):
xfs_scrub: track repair items by principal, not by individual repairs
xfs_scrub: use repair_item to direct repair activities
xfs_scrub: remove action lists from phaseX code
xfs_scrub: remove scrub_metadata_file
xfs_scrub: boost the repair priority of dependencies of damaged items
xfs_scrub: clean up repair_item_difficulty a little
xfs_scrub: check dependencies of a scrub type before repairing
xfs_scrub: retry incomplete repairs
xfs_scrub: remove unused action_list fields

libfrog/scrub.c       |   1 +
scrub/phase1.c        |   9 +-
scrub/phase2.c        |  46 +++--
scrub/phase3.c        |  77 ++++----
scrub/phase4.c        |  17 +-
scrub/phase5.c        |   9 +-
scrub/phase7.c        |   9 +-
scrub/repair.c        | 530 ++++++++++++++++++++++++++++++++++----------------
scrub/repair.h        |  47 +++--
scrub/scrub.c         | 136 ++++++-------
scrub/scrub.h         | 108 ++++++++--
scrub/scrub_private.h |  37 ++++
12 files changed, 664 insertions(+), 362 deletions(-)

