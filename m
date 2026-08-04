Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517A634FF45;
	Tue,  4 Aug 2026 09:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785836769; cv=none; b=m2sxPcAFy3Y3/1TBHUAKLygV+oV5hmPEeQ7QfPWC2eyCXaMxtm/9Gq0CM76+1mr1pk9nE7MsRjcSe60KYQzl2VvEtB/xMbIeStWzRrZgpZXbU/0Afl4a1TXrC4xPUvbFn90lbgh7s76ykv0yx2tWWL72gq7dVgu0XmJfNXEzh+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785836769; c=relaxed/simple;
	bh=1cpOOFjPqpdtLwLMyrZHSM7wkG6T2fvfpTtWe/ehlj4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PSSCi8g/222gge7bHCekWLIGbkKMM2TnpJag8QMtwIKgbQu9XUzIYFGlDCBBVh9VBk2mjY+/BXzFdyz2Tgmp3mlzk/bl5sdCmocuYBa1N47O2s9ZpknpFD1Gk6j45E//yK6BNl9JWvlwHyjZwHZj9tmu6E2JH938SXZBy2I7WW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H3Mi1ehm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H3Mi1ehm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9661F00A3D;
	Tue,  4 Aug 2026 09:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785836767;
	bh=cjwEh3+3XL+srZEORngXmw++Ua2CgZKmX9Mj3c6GUeo=;
	h=From:To:Cc:Subject:Date;
	b=H3Mi1ehmCa3I/tW5AldkI2p7MtRKTg+5QlKOUUbeo5udBJV3ZvZInCsIFPwrjFZaP
	 lVi9Szo4pxyaI9KczpylSYEOTRp25YTfpfWmY9C/+r7g98Ad4RyJsNZaWML9AXQ/0G
	 ZCWKasTesAuHrNHrHp7xE1bs2+LGTagNnnOrjNW7j/uQYfYl2zxZ3X/5yPiiNNf3NT
	 IBzISziLqMmBRIuciq8FUbPk0RLxzzgamwtrjm5oflWQo5K8cBAqQJGnytAi/8ifTD
	 aNUKJwFQm/+0daENSFaPglqV5OoqCDQKhvYpfgSOTfK9PcWQDALHpVitL7acFGBl8J
	 OmAYG+pob48xA==
From: cem@kernel.org
To: cem@kernel.org
Cc: jack@suse.cz,
	djwong@kernel.org,
	hch@lst.de,
	serge@hallyn.com,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 0/5] Fix quota evasion on xfs and add capable_noaudit
Date: Tue,  4 Aug 2026 11:45:50 +0200
Message-ID: <20260804094602.84766-1-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Hi there.

This is the a new version of the series I've been working on
to fix a quota evasion issue on xfs. I've got to jump to more urgent
matters before the previous one so my apologies for the time it took to
cook this new version.

The changes to this version compared to the previous one are minor, only
comments and indentation related. This new version has also been rebased
on top of current xfs's for-next branch. A description of the changes
between this and the V3 version are below and more detailed on individual
patches.

This bug has originally been introduced by accident while turning off audit
messages while checking quota limits in xfs by replacing capable() calls by
as_capability_noaudit().

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

Also I kept most of the RwB tags from previous versions as there were no
code changes but minor context updates to fix the conflicts.

Serge, I removed your RwB on purpose from the patch 2 as I updated the
comment, so I want to make sure you are ok with the new comment.

Changelog from the last state of these patches:

Patch2: Add more details to the capable_noaudit documentation specifying
	it checks for the process effective capabilities.

Patch4: Fix identation changes introduced in previous versions

Carlos Maiolino (5):
  xfs: fix capability check in xfs
  capability: Add new capable_noaudit
  quota: Don't issue audit messages on quota enforcing
  xfs: replace ns_capable_noaudit
  capability: unexport has_capability_noaudit

 fs/quota/dquot.c           |  2 +-
 fs/xfs/xfs_fsmap.c         |  3 +--
 fs/xfs/xfs_ioctl.c         |  2 +-
 fs/xfs/xfs_iops.c          |  2 +-
 include/linux/capability.h |  5 +++++
 kernel/capability.c        | 19 ++++++++++++++++++-
 6 files changed, 27 insertions(+), 6 deletions(-)

-- 
2.55.0

