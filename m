Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA35197A87
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416060; cv=none; b=ASKirVb9I6TrHQJ/HU88ITb6KjuMH6/YedUqMflyoqgZdhpkO7LsQq+gBcMkrvBjIWfgBk7/LeKviKQWHy7zQPItzBNNOPHMJ9ZYMQyp2fW5bXvYDlM0AR7Q1SbEk9U8j17WMFIJEBerzAv8ItZU3+kFVaqgAGUDoUGg25cTXYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416060; c=relaxed/simple;
	bh=9zqzewbgMBhzktj3ZscnTbx02duxjRcSMpYrtwveZXU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HGTIc7KW1l9aq4maTH9fhCVwI4WrVnmCQyDCNOPvM1bB1qkfHhhJE+IU3VpdWlZxg50JlgVJvBy3h98ieGGomD1lDt/IpOlf5CmCWDvUkVtKFLcrFNLre93EoED+wRt5grYtkzb3afrnvvq+qAPkwQsHPj0Fa5CHP0cyZVwaZPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J/9+2clH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J/9+2clH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF51C4CEC3;
	Thu, 31 Oct 2024 23:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416059;
	bh=9zqzewbgMBhzktj3ZscnTbx02duxjRcSMpYrtwveZXU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=J/9+2clHhzxVyi/xQRqsgjsjnfXdb95ldjL1Ok7aequz8rqpzhrh0uphZWoSKpFBq
	 Sumk91kBm7tsxssIofLkWGzMsZnXLYzriOG9W80v2XvwBSHf3higwBLClObOGkSoWo
	 DHVh8uB4JR6+Pm8Pm0qzwCfbUAvCix1NlGj3zq1MBW3p1U1obhp2odFvSUbOlirJ0v
	 6YaZNVewLKFfHNw1AXB9kMO1Ey0uX3KPyBMISNRPkQGIyv5DQ0GxJr2LoamQfxGfe6
	 o+58rgl6RSs/S+o3jm6yaesr58UXFXiK8y9OSW46FzZ3Bf/l2xhxRcL+c/wQq7Fou0
	 2X06XYYKEFVzg==
Date: Thu, 31 Oct 2024 16:07:39 -0700
Subject: [PATCHSET v5.3 3/7] xfs_db: debug realtime geometry
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041567330.964205.623580785256778088.stgit@frogsfrogsfrogs>
In-Reply-To: <20241031225721.GC2386201@frogsfrogsfrogs>
References: <20241031225721.GC2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Before we start modernizing the realtime device, let's first make a few
improvements to the XFS debugger to make our lives easier.  First up is
making it so that users can point the debugger at the block device
containing the realtime section, and augmenting the io cursor code to be
able to read blocks from the rt device.  Next, we add a new geometry
conversion command (rtconvert) to make it easier to go back and forth
between rt blocks, rt extents, and the corresponding locations within
the rt bitmap and summary files.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=debug-realtime-geometry-6.12
---
Commits in this patchset:
 * xfs_db: support passing the realtime device to the debugger
 * xfs_db: report the realtime device when associated with each io cursor
 * xfs_db: make the daddr command target the realtime device
 * xfs_db: access realtime file blocks
 * xfs_db: access arbitrary realtime blocks and extents
 * xfs_db: enable conversion of rt space units
 * xfs_db: convert rtbitmap geometry
 * xfs_db: convert rtsummary geometry
---
 db/block.c        |  171 ++++++++++++++++++++-
 db/block.h        |   20 ++
 db/convert.c      |  438 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 db/faddr.c        |    5 -
 db/init.c         |    7 +
 db/io.c           |   39 ++++-
 db/io.h           |    3 
 db/xfs_admin.sh   |    4 
 man/man8/xfs_db.8 |  131 ++++++++++++++++
 9 files changed, 778 insertions(+), 40 deletions(-)

