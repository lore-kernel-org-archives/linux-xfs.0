Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E5D47DF96;
	Thu,  2 Jul 2026 09:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782984830; cv=none; b=XoUYLgya78d2tjEPRp8ihSMlhdpGWN7G/0DVY2czDu64nuZYDzYsGrLSrYN4eAElgMMxpNE/UNssedGwuAqJDsZ6KXsaiPW/JsyaqLQcrGeUZHm3icxPQft+l9UxpubotTzJ2858WKae1St7HCLCZLbxRhaectO1TIlTC6EyDic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782984830; c=relaxed/simple;
	bh=npiKLdN+w6T3goyUViROmCZMeRJmRIyo6Pqg1JQq6QU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dg+/Qt7gT8BmdK4fRO/iCjCpt/Dd7YI6EB6rlx5xHbbdpjLFXtPclt0s/efyXFzvPZI6EmLCgsVHWj5wGgU3uXqFyTBG54Jvb8KU2mlNhOqAiVTgJDYXw58hBsuXh4OooH8uj+ApSMbKEdYnA9psfWmSsX4e9XczTXjTgQAgOOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GBOoypFc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GBOoypFc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444AB1F000E9;
	Thu,  2 Jul 2026 09:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782984828;
	bh=iwKbs9rXzszpSDj408nMEVkROgilQf533CtonCYgF0U=;
	h=From:To:Cc:Subject:Date;
	b=GBOoypFc9hOc8WsmgBc+NzIAsbbukZUgwg4tCdvKGh0LHhqyk8BKECXaE367JYDHg
	 1Zb6xjXjZwcl2PjjvmtinU1s+37TzHj9RhtoYxBbbZaB5VvKg89WkSX2k8F6xH7T/1
	 oXEzcgPrezwySFs3cZB6PGXtm2mb+PJbf4BY/ln8mL6U7mqpAlzgjdDsC8j6NvCF8g
	 9vd3UsYV74t9JgCWffSSkC0JucAoyZUjWVLqBjmvDMU9GNh3npUCUxrYGR9VSHnbh7
	 /R61vMBnmtxuem9zFySH4LItt8z8Jljjt0oWaM36QzuY+Z8K6TT2zRY5c1x3oz2M+/
	 CghMceBKcS9PQ==
From: cem@kernel.org
To: cem@kernel.org
Cc: Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/5] Fix quota evasion on xfs and add capable_noaudit
Date: Thu,  2 Jul 2026 11:33:15 +0200
Message-ID: <20260702093324.127450-1-cem@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Hi there.

This is the (hopefully) final version of the series I've been working on
to fix a quota evasion issue on xfs. This bug has originally been
introduced by accident while turning off audit messages while checking
quota limits in xfs by replacing capable() calls by has_capability_noaudit().

This series concatenates both series I sent for xfs and capabilities
infrastructure as they are dependent.

The first patch fix the xfs bug in a way that makes it easily portable
to older LTS kernels.

From second patch and beyond, it adds a new helper for the capabilities
framework named capable_noaudit() which as the same semantics as
capable() but without generating audit messages.
The following patches then replaces both generic quota call to
capable() and properly update xfs code to use this new helper.

Last but not least this unexport has_capability_noaudit which had been
previously exported.

Giving this affects different subsystems, I think it would be easier to
pull everything from a single tree (as long as everything is properly
reviewed of course).

Serge, Honza, are you guys ok if I pull those patches and send them to
Linus through xfs tree so we don't need to split the series?

Christoph, this series moves back to pass the capable_noaudit() result
straight back to xfs_trans_alloc_ichange() instead of moving the
capability check into xfs_trans_dqresv() as Darrick was not in agreement
with that (patch unreviewed and open for comments).

Changelog from the last state of these patches:

Patch2: removed the redundant external classifier from the declaration
        in include/linux/capability.h.
	Serge, I kept your RwB here as the external is redundant, please
	let me know if you are ok with it or not.

Patch4: Replace all ns_capable_noaudit() calls by capable_noaudit() and
	keep the CAP_FOWNER (instead replacing it by SYS_RESOURCE)


Carlos Maiolino (5):
  xfs: fix capability check in xfs
  capability: Add new capable_noaudit
  quota: Don't issue audit messages on quota enforcing
  xfs: replace ns_capable_noaudit
  capability: unexport has_capability_noaudit

 fs/quota/dquot.c           |  2 +-
 fs/xfs/xfs_fsmap.c         |  3 +--
 fs/xfs/xfs_ioctl.c         |  2 +-
 fs/xfs/xfs_iops.c          |  3 ++-
 include/linux/capability.h |  5 +++++
 kernel/capability.c        | 18 +++++++++++++++++-
 6 files changed, 27 insertions(+), 6 deletions(-)

Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Cc: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

-- 
2.54.0

