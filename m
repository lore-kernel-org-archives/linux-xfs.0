Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D5E184E
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298682; cv=none; b=fVWZcv0TEaPm5Xj+u4KHTy2DLhpkozXLdhHh4EWTHNpI9SS+lldKN8k66SxJWgbpBLczuTz7rEIXgKYpn+g0VLqB3X/GHXcsdG7gIqsRwmSB3FImGzPifNjAlis3RYj62C6CLLYE61zv7WwyN32Mu3Ghq9TAibk7hIKzFHdCqlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298682; c=relaxed/simple;
	bh=RncqzSYLq0RXwL2PJLDihmRCBDfTUTbVDxaDxO3GoeE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R6hj3pQ0xZcHVOfjW8t1aXB9bRhAa4qauLppWt/rRZ22W/0ebeF5QnLrZPHTOfkE9mUr75ASHBeb6UoAibPQ71ZxpSFC+o6Mk39izRxaknHnnkBWNAutnOJvzEK67MUqS0Bp6bpMqb1mYusKsbR+pSTkIEf6PViwV+9bCWZ687w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EGNSv0lJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EGNSv0lJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9E3C32786;
	Tue, 30 Jul 2024 00:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298682;
	bh=RncqzSYLq0RXwL2PJLDihmRCBDfTUTbVDxaDxO3GoeE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EGNSv0lJUAK9Dv7mjcqdjY4HHSznZEsrEI1wHvytgrHHeb4DQnS+xRdzIA0DBZCaE
	 52B7SHex0hoBeL6MMtBr7HTByjqdKZvFp2sqArJdimRogtyVKrqjH0bV1z5b8hcFy/
	 GL3orRWcm8wgDk7e33/rr2GRdyDhWgQLE3ookPcG09MpBuW7s0vIbT7C4PsbSDVbvT
	 pE6ds57CQiHKX9SfGjms4MU1cyFjQT0OArAm3n3V/OFrhCUSO/2YFQBisaAW6GEU54
	 reNDox0KBGs0rsY96WbWQ2npzSYZE8HbQXwWNhOCn99Q6zoyuCy/toWJArVseQ55qd
	 0epHwKcOzWeaQ==
Date: Mon, 29 Jul 2024 17:18:01 -0700
Subject: [PATCHSET v30.9 06/23] xfs_scrub: fixes to the repair code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229845539.1345742.12185001279081616156.stgit@frogsfrogsfrogs>
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

Now that we've landed the new kernel code, it's time to reorganize the
xfs_scrub code that handles repairs.  Clean up various naming warts and
misleading error messages.  Move the repair code to scrub/repair.c as
the first step.  Then, fix various issues in the repair code before we
start reorganizing things.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-repair-fixes-6.10
---
Commits in this patchset:
 * xfs_scrub: remove ALP_* flags namespace
 * xfs_scrub: move repair functions to repair.c
 * xfs_scrub: log when a repair was unnecessary
 * xfs_scrub: require primary superblock repairs to complete before proceeding
 * xfs_scrub: actually try to fix summary counters ahead of repairs
---
 scrub/phase1.c        |    2 
 scrub/phase2.c        |    3 -
 scrub/phase3.c        |    2 
 scrub/phase4.c        |   22 ++++-
 scrub/phase5.c        |    2 
 scrub/phase7.c        |    2 
 scrub/repair.c        |  177 ++++++++++++++++++++++++++++++++++++++++++-
 scrub/repair.h        |   16 +++-
 scrub/scrub.c         |  204 +------------------------------------------------
 scrub/scrub.h         |   16 ----
 scrub/scrub_private.h |   55 +++++++++++++
 11 files changed, 269 insertions(+), 232 deletions(-)
 create mode 100644 scrub/scrub_private.h

