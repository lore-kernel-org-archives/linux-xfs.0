Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177EC1CF96
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729837901; cv=none; b=KiZxLA9Weazpl/npAODm4H6rKlEuqhoM2GKgmv7ZY5csZEhMsVfLxq6oj52YdvDV7iIPRR66dzp3FucGuPgb3C6u9cgtK4TqI4Gp+91KCRDqLx6eJtZyOvj2Oe01hQFyXqCbYAUJsCHBTQ+dE25mJI3P/WqnSOJoVPUDtimh2LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729837901; c=relaxed/simple;
	bh=VwQxmhc1kP0IhMbpyzw3/m63y7E2R6QcRECAmNV2fkM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sZEphFVD39u42mKjvzFwGl2folyxPkBmChLeM1peIsQiiW14BlrzDrP2vTqRRljOzng973+Y1h63wgsgfEWu2ISimhoCX6SZjygTfm9a3UqEL3OqFSm7OcLH22gqcSzS4OOJi2/IgxJuftNr2otpiuu9BE6rn1qVRlv0neOM4n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bx31PjHK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bx31PjHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D759CC4CEC3;
	Fri, 25 Oct 2024 06:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729837900;
	bh=VwQxmhc1kP0IhMbpyzw3/m63y7E2R6QcRECAmNV2fkM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bx31PjHK2QZwLYbkA6SL899GAnM4BmCUhP7QivQuKggAR6ZegbSxuVXFp1ZqeAY68
	 tf+CDlRuMUrba+cBJ/i40pGkym7iArMZl5lIP0EWDLFAwHxHZ0tmsVSmkwUyYezcnj
	 oufqvyRns7EhbDMNy/MLXXgcrjMJRanrRv6o9P4A+69s6pBTAybwCf+52o1e2jYX4C
	 Xj8bejJN0K1ytHntrleiqsPq2d+1Ws+PikAMjIupVw7cmWXoNxgRB6VqsQbUKyQici
	 cBxmcAYwTzDG8BzrKJ6yL+h8eRYXqwKTBrAVDPCCy6Nid0zeqkZS+2osRxZxd/AkvC
	 gx4/iBZVjB9Yg==
Date: Thu, 24 Oct 2024 23:31:40 -0700
Subject: [PATCHSET v2.6 2/5] xfs_db: debug realtime geometry
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172983773721.3041229.1240437778522879907.stgit@frogsfrogsfrogs>
In-Reply-To: <20241025062602.GH2386201@frogsfrogsfrogs>
References: <20241025062602.GH2386201@frogsfrogsfrogs>
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
 db/block.c        |  167 +++++++++++++++++++++-
 db/convert.c      |  409 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 db/faddr.c        |    4 -
 db/init.c         |    7 +
 db/io.c           |   39 ++++-
 db/io.h           |    3 
 db/xfs_admin.sh   |    4 -
 man/man8/xfs_db.8 |  129 +++++++++++++++++
 8 files changed, 722 insertions(+), 40 deletions(-)

