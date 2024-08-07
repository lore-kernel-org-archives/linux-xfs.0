Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D6CB646
	for <linux-xfs@vger.kernel.org>; Wed,  7 Aug 2024 19:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723058044; cv=none; b=DpezaF2C722dhgGJfBDUsOwxzeLetTRc3ofizF8meMv6mBzSZXzhTmMcNS5fnRnFaqMuymjY1C1RLspcY1pumSSs3pFEUKrlRcYMHyi+5y7Shf4z0gPpYy827BJMLdaQF2F1PK3+CN0TwIrUIKyHnWQlq47ubvSzWmBnG2llLGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723058044; c=relaxed/simple;
	bh=tDAUMDkEVRV/16MfirmfR5SRRA6BT8w65nBYKVRhk2Q=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=K+vJVQlc/hDaPa9+4Lqz3bM26zaSwABlmnuZ+/ykW4Qi5zeS56tvijGzShmoaVWgPLfN6UTS74djXgAuODrUPPZNWJLgXyfDUnecMqdT5+SglkOIifCYj77TyCFKsMoc2MtowBBdhO7ZleeuSi5vF+5w0hmFu5ierhsr7gGVi6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fYFcZqWi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fYFcZqWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8B0C32781;
	Wed,  7 Aug 2024 19:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723058044;
	bh=tDAUMDkEVRV/16MfirmfR5SRRA6BT8w65nBYKVRhk2Q=;
	h=Date:Subject:From:To:Cc:From;
	b=fYFcZqWiMDytm265wICRpGTfPpirxzQkfKTFd+vVP+6PhixqQPUrO6NyQAZRmLhAB
	 9TPPs0otKCwio1nextEu35eMo+SIDtywM0JGw2piZpafmHXLIxDHDn1hszCrdJo/xB
	 CAzJ7SmsoZaM4USBj91US527RCvHqpRnuyweEdEpfVZrLzmt5rtb8Bq7ebqditOtaW
	 dUsAkXI7WvG8JMwcB+EUsEaDcTFZdO2dOVQ728wFHlhJzr+8Jzl/0HW/tJSA57GbWA
	 oQ+lARTbo0YTEtrfM+hcsYQB6QBSu+9ZLNzgq7Q73FMeJQc/3oan7+cJ5wCqoEZCiW
	 ZjrZz0s6lj96Q==
Date: Wed, 07 Aug 2024 12:14:03 -0700
Subject: [PATCHSET] xfs-documentation: updates for 6.10
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172305794084.969463.781862996787293755.stgit@frogsfrogsfrogs>
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

Here's a pile of updates detailing the changes made during 2023 and 2024 for
kernel 6.10.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=xfsdocs-6.10-updates
---
Commits in this patchset:
 * design: document atomic file mapping exchange log intent structures
 * design: document new name-value logged attribute variants
 * design: document the parent pointer ondisk format
 * design: document the metadump v2 format
 * design: fix the changelog to reflect the new changes
---
 .../allocation_groups.asciidoc                     |   14 ++
 design/XFS_Filesystem_Structure/docinfo.xml        |   32 ++++
 .../extended_attributes.asciidoc                   |   95 +++++++++++
 .../journaling_log.asciidoc                        |  177 +++++++++++++++++++-
 design/XFS_Filesystem_Structure/magic.asciidoc     |    2 
 design/XFS_Filesystem_Structure/metadump.asciidoc  |  112 ++++++++++++-
 6 files changed, 423 insertions(+), 9 deletions(-)

