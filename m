Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B84E20326
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 02:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722307485; cv=none; b=UVjnlSjKM1IkTAOrm72CCbdRpC0bDD9XG9i4EWTq4/HZbY2EvvOAgzh92yEBkbRIKatp2c7jiXzd508UoIk73hfomIm8a/NK+KS0ircFZAq5xMqxqkGvc8d/plp4lDCGgDJ3ZuxXV6zlwu6h+h7c8e1QlMABhg+TfQVFFfdfDOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722307485; c=relaxed/simple;
	bh=xoUMfWCSGrsQi84DimIyJzoRfsumGWy7eWS1Os7meH4=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=PS/brusYZtN96F2rbYobfRAX1y8znyjHWvR/900yLfGrrlpGdW6t2UN2gXzy4qSjmKcbA31zp2VqZKeXwCkluFE1JHTdKWcgOC4qPUNUts1HnxIV+C8Q3sftc1F5+omXQ5IZBS2VBhjoIivx/5lc3goDxdNm7FgonOuieH+z+HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NL4Puu8W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NL4Puu8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D49C32786;
	Tue, 30 Jul 2024 02:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722307484;
	bh=xoUMfWCSGrsQi84DimIyJzoRfsumGWy7eWS1Os7meH4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NL4Puu8WGLK7b3l85w3lqVRBInMqhxPv/tv0F8nK7UR6AKk8HO4jMokUC+0htXqz/
	 1i8BXLHFJsuV+w+sDod1KHJiRT9h5ANN1DSg+aTgI3U5cqZYEZwdDQFyEiODj0aLYd
	 G0aGLr+TSMSwno9VqgK+8rU5Q15RZdG5FuWcJcYWIf65RtLkFiqc4ezx7IOuN42/rB
	 5PwhyMgLiOaLSI/MWMs9Hq61w/yJYnBcMAZoIDBV4tb0PE7VmFzaguLUbuwskwK63K
	 PQ+vsMHI7v0C+iOeH1OmJOw8xlluNwTBJsNMsF6rYpw1SBgy7KsgauAs/ffrn9Q63j
	 8ilVX0wGbCrKw==
Date: Mon, 29 Jul 2024 19:44:44 -0700
Subject: [GIT PULL 17/23] xfsprogs: improve extended attribute validation
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: chandan.babu@oracle.com, david@fromorbit.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172230459508.1455085.4400398103646272942.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit e46249ec0b96ac5ced5b49928d3b3865b6d9546c:

xfs_scrub_all: implement retry and backoff for dbus calls (2024-07-29 17:01:10 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/improve-attr-validation-6.10_2024-07-29

for you to fetch changes up to 2823d8ed93da2bd3880abb52a58e91a920961e27:

xfs_repair: check for unknown flags in attr entries (2024-07-29 17:01:11 -0700)

----------------------------------------------------------------
xfsprogs: improve extended attribute validation [v13.8 17/28]

Prior to introducing parent pointer extended attributes, let's spend
some time cleaning up the attr code and strengthening the validation
that it performs on attrs coming in from the disk.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (6):
xfs_scrub_all: fail fast on masked units
xfs_scrub: automatic downgrades to dry-run mode in service mode
xfs_scrub: add an optimization-only mode
xfs_repair: check free space requirements before allowing upgrades
xfs_repair: enforce one namespace bit per extended attribute
xfs_repair: check for unknown flags in attr entries

include/libxfs.h         |   1 +
libxfs/libxfs_api_defs.h |   1 +
man/man8/xfs_scrub.8     |   6 ++-
repair/attr_repair.c     |  30 +++++++++++
repair/phase2.c          | 134 +++++++++++++++++++++++++++++++++++++++++++++++
scrub/Makefile           |   2 +-
scrub/phase1.c           |  13 +++++
scrub/phase4.c           |   6 +++
scrub/repair.c           |  37 ++++++++++++-
scrub/repair.h           |   2 +
scrub/scrub.c            |   4 +-
scrub/xfs_scrub.c        |  21 +++++++-
scrub/xfs_scrub.h        |   1 +
scrub/xfs_scrub_all.in   |  21 ++++++++
14 files changed, 272 insertions(+), 7 deletions(-)

