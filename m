Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CE7522F
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298823; cv=none; b=rH9vOCZfgAOdWcSqOsJ8L4BSmM1Xc3kXqPmpPXJfYmDTnPXwUtLpciejZcCtOgNJST+M1AWA0409SvCD5rSLRqKFcG3JANJJnRWgeheHhk5w/VeNn5KM3Uak5REmWtT5TuU3b2mn8cqkUwrvNK2p0FIolIleSeWrOfKSa0xh8fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298823; c=relaxed/simple;
	bh=njaujcnx87mUpmi2SOaN6Z1ZkOb+xCQP3FK+b+pw5e8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UQ1YWWIfY+N4YdDo1tZnmblI3ZUBrO7KJZ4jc5HDtu50J8q9Z/tza//Zx8mFl5U0IuT2j+v103f+RJj58JxMmSaERWnA+A/FvLd3ZxF59SwvaJ8ih8MYgjNruCUu11AOG9JWUH6KJz6di5UUWLVWSSbGoOCzhdQ3dWxvFXyTD30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a4x1WI3Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a4x1WI3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C41C32786;
	Tue, 30 Jul 2024 00:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298823;
	bh=njaujcnx87mUpmi2SOaN6Z1ZkOb+xCQP3FK+b+pw5e8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=a4x1WI3YE3CMaQsJt72t9d1z+4koLfcrMfEeDRvYBIt790Swyl0beNckVYUMwPhBy
	 2UxMQ8tQ4XbYBd757HDk+cG8yP2D1Dp+LyhE7QNiiBrCrm3AEEGvKqXb3zJSxtzKNX
	 KCjVViZsEZC/fDUWLUgwdzA9Yu/c7edEK17MriC2zvP9aXY4hDvDdfuUddqxNzjqor
	 TfQ3vcENqk93nx/nf1pYaPjDY16CIXlu7rmpqBEYlgGDfJGS3z9y8AKyhvQu0445k2
	 RhllupcyVLpJOYCVs8zJWZuAewDa6eXjnqsIsbB1HfTeB6LwsO7Nbh0qIp/H89AU+6
	 UqAkCPKC/yWpw==
Date: Mon, 29 Jul 2024 17:20:22 -0700
Subject: [PATCHSET v30.9 15/23] xfs_scrub_all: automatic media scan service
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229849240.1350165.13200329618269649031.stgit@frogsfrogsfrogs>
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

Now that we've completed the online fsck functionality, there are a few
things that could be improved in the automatic service.  Specifically,
we would like to perform a more intensive metadata + media scan once per
month, to give the user confidence that the filesystem isn't losing data
silently.  To accomplish this, enhance xfs_scrub_all to be able to
trigger media scans.  Next, add a duplicate set of system services that
start the media scans automatically.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-media-scan-service-6.10
---
Commits in this patchset:
 * xfs_scrub_all: only use the xfs_scrub@ systemd services in service mode
 * xfs_scrub_all: remove journalctl background process
 * xfs_scrub_all: support metadata+media scans of all filesystems
 * xfs_scrub_all: enable periodic file data scrubs automatically
 * xfs_scrub_all: trigger automatic media scans once per month
 * xfs_scrub_all: failure reporting for the xfs_scrub_all job
---
 debian/rules                           |    3 +
 include/builddefs.in                   |    3 +
 man/man8/Makefile                      |    7 ++
 man/man8/xfs_scrub_all.8.in            |   20 +++++
 scrub/Makefile                         |   21 +++++
 scrub/xfs_scrub@.service.in            |    2 -
 scrub/xfs_scrub_all.cron.in            |    2 -
 scrub/xfs_scrub_all.in                 |  126 ++++++++++++++++++++++++++------
 scrub/xfs_scrub_all.service.in         |    9 ++
 scrub/xfs_scrub_all_fail.service.in    |   71 ++++++++++++++++++
 scrub/xfs_scrub_fail.in                |   46 +++++++++---
 scrub/xfs_scrub_fail@.service.in       |    2 -
 scrub/xfs_scrub_media@.service.in      |  100 +++++++++++++++++++++++++
 scrub/xfs_scrub_media_fail@.service.in |   76 +++++++++++++++++++
 14 files changed, 443 insertions(+), 45 deletions(-)
 rename man/man8/{xfs_scrub_all.8 => xfs_scrub_all.8.in} (59%)
 create mode 100644 scrub/xfs_scrub_all_fail.service.in
 create mode 100644 scrub/xfs_scrub_media@.service.in
 create mode 100644 scrub/xfs_scrub_media_fail@.service.in

