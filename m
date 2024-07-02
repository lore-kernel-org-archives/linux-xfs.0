Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67169B661
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881453; cv=none; b=rmpXpRJktbe0JY0Dg7gx6PXALFgLwBqnjNMUkdyATA9V64M8m39jXkly27CwfWYSQs5VdkBaqXd+GKuLAyUuYM7ycKmUWYFAN9zOpUOx6VYRZgFN9wSMkccQ8pvjBDMeR35YJFcklhwTMYYeiAPI1nxv5AyXFK5jvXhF2Bsy8CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881453; c=relaxed/simple;
	bh=/6wkXdzCWL1qBzwDagD55/zUbkjV3FtKdbLno6tA0Io=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iim7/Vx7Ueg3M2TYircO6R2CFdEGHGXtShIfeODy46cQ75z0zCoVzj6mGoseGCdiZXly5bSywgypeh9TMt4XaCtXCr8d3tz3lcQeydHjZCWiVJMdUak8/K0Q1CteFeXXP1q8uYVxKqx626rjzAYMks5jDdEiVS9tXSnfyDcXUC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UhHpu8+l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UhHpu8+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1D8C116B1;
	Tue,  2 Jul 2024 00:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881453;
	bh=/6wkXdzCWL1qBzwDagD55/zUbkjV3FtKdbLno6tA0Io=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UhHpu8+la2vab5IFxjFR9JqHgDSx49LfJOXAR5VwiC+ny4XzDFInw1PIbm5LJBmay
	 khqNbQg38nWZQVuSJ4G6limLxojR70eJqDCH2CJqaIMIh+jF3S8w8yZNaq8jKtqfy6
	 2Or5G08uyOUcP9OJH9dSPtYVQCIkB+oHRcwgFkD5Tp8v6o6tr7r/j9Ka1DFvOuEihu
	 CFj8rhMBnj+a2yaaGbVvONHS8ok194UkpSsNB1GSarik7x3ayQ4abyG7xhP+ojuweZ
	 YCNNgwqRMf2syUhe34HfIhYjWXwu/zydVPjneXWtapKBp4INNbUfdJcicfmwQ6IEwf
	 hzT09OJJ6j9Dg==
Date: Mon, 01 Jul 2024 17:50:52 -0700
Subject: [PATCHSET v30.7 06/16] xfs_scrub: tighten security of systemd
 services
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Helle Vaanzinn <glitsj16@riseup.net>,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988118996.2008208.13502268616736256245.stgit@frogsfrogsfrogs>
In-Reply-To: <20240702004322.GJ612460@frogsfrogsfrogs>
References: <20240702004322.GJ612460@frogsfrogsfrogs>
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

To reduce the risk of the online fsck service suffering some sort of
catastrophic breach that results in attackers reconfiguring the running
system, I embarked on a security audit of the systemd service files.
The result should be that all elements of the background service
(individual scrub jobs, the scrub_all initiator, and the failure
reporting) run with as few privileges and within as strong of a sandbox
as possible.

Granted, this does nothing about the potential for the /kernel/ screwing
up, but at least we could prevent obvious container escapes.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-service-security
---
Commits in this patchset:
 * xfs_scrub: allow auxiliary pathnames for sandboxing
 * xfs_scrub.service: reduce background CPU usage to less than one core if possible
 * xfs_scrub: use dynamic users when running as a systemd service
 * xfs_scrub: tighten up the security on the background systemd service
 * xfs_scrub_fail: tighten up the security on the background systemd service
 * xfs_scrub_all: tighten up the security on the background systemd service
---
 man/man8/xfs_scrub.8             |    9 +++-
 scrub/Makefile                   |    7 ++-
 scrub/phase1.c                   |    4 +-
 scrub/system-xfs_scrub.slice     |   30 ++++++++++++
 scrub/vfs.c                      |    2 -
 scrub/xfs_scrub.c                |   11 +++-
 scrub/xfs_scrub.h                |    5 ++
 scrub/xfs_scrub@.service.in      |   97 ++++++++++++++++++++++++++++++++++----
 scrub/xfs_scrub_all.service.in   |   66 ++++++++++++++++++++++++++
 scrub/xfs_scrub_fail@.service.in |   59 +++++++++++++++++++++++
 10 files changed, 270 insertions(+), 20 deletions(-)
 create mode 100644 scrub/system-xfs_scrub.slice

