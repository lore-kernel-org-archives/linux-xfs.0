Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7084B2BB0D
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440614; cv=none; b=EY3SDcN1TfAOvCqJpQWqBCR08KZyMR2gf1GIQ+YN5gANHXKROoSbJR9eao0fcVPqe0jfEDsZw+lAKZ1qE/NgEg3sJSwrdIvJ8AgSAa4LYAFznzlFVUP3reKSmWSFD4icXe56dZ1wB5gxC8CJvrQ0d1sc3ZGSwBlrGqyYpmSPiXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440614; c=relaxed/simple;
	bh=6UmEbsbaaLbnzw3sk4mT9xcHi5sYPvweoGejSE6r1R4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OWAQVv0nfaZVtrisBq7fkDLf9XwC1GYxU0rOQTp0fWiWiEXs2LEI8Eon1e8ni9A6/KSHCvTobrUlGkQdBHKEtVPMVCJUF7JGRu8Uh2nH/qGIy1iyaR80OGA7jYPggOdiYSXHFRqNRHRw344XxlyzjxD9cm4xkZGg/U3yu9ZQ/BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bJ85GT4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bJ85GT4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09952C32786;
	Mon,  3 Jun 2024 18:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440614;
	bh=6UmEbsbaaLbnzw3sk4mT9xcHi5sYPvweoGejSE6r1R4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bJ85GT4bf72zIe/ZJOXxcV4hBp3We3qaSX64Z5MgcQ9bjlyeuzpvPW4FKVyt/qCfg
	 pbi2z4hp2LJOkheIXz+EntmiDi8i9k4Igh7dr3goPKYYMBJwb7L6kCjsQW/7louCxc
	 LqJAQP1bt8B7QnaMMNaqW04bCSFqWIn6Cem2jASTJ7EQOO8LeqAhgsH7gpNt3NkdVU
	 ed3VSsyKJ336wvDCsHnBqwrOqWddY8xdErEOdZtVYDqxt8rOYD90xpmIUaICqC1jrq
	 e9gZImLuHRqYH/DlEmCK4DLOjN+qGXZAzXf3VkIYn6/7J/5V2d3h8MeEXgE/WlbZIQ
	 sPatcAIBd/wLg==
Date: Mon, 03 Jun 2024 11:50:13 -0700
Subject: [PATCHSET v30.5 06/10] xfs_scrub: updates for 6.9
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744042368.1449803.3300792972803173625.stgit@frogsfrogsfrogs>
In-Reply-To: <20240603184512.GD52987@frogsfrogsfrogs>
References: <20240603184512.GD52987@frogsfrogsfrogs>
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

Now that the kernel has the code for userspace to upload a clean bill of
health (which clears out all the secondary markers of ill health that
hint at forgotten sicknesses), let's make xfs_scrub do that if the
filesystem is actually clean.

Second, restructure the xfs_scrub program so that it scrubs file link
counts and quotacheck in parallel.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-fixes-6.9
---
Commits in this patchset:
 * xfs_scrub: implement live quotacheck inode scan
 * xfs_scrub: check file link counts
 * xfs_scrub: update health status if we get a clean bill of health
 * xfs_scrub: use multiple threads to run in-kernel metadata scrubs that scan inodes
 * xfs_scrub: upload clean bills of health
---
 libfrog/scrub.c                     |   15 ++++
 man/man2/ioctl_xfs_scrub_metadata.2 |   10 ++
 scrub/phase1.c                      |   38 +++++++++
 scrub/phase4.c                      |   17 ++++
 scrub/phase5.c                      |  150 ++++++++++++++++++++++++++++++++---
 scrub/repair.c                      |   18 ++++
 scrub/repair.h                      |    1 
 scrub/scrub.c                       |   43 +++++++---
 scrub/scrub.h                       |    3 +
 9 files changed, 265 insertions(+), 30 deletions(-)

