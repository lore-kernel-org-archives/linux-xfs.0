Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E35C1EB22
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000326; cv=none; b=FWacygCNDcyHoJlauXBxco1f/vP56aNzV90uAbePZet7CYjHukweTKQdxNjNeBCcKKKLOqOHH2TAwmOah0zPoWeYYJ+VRc2x03h435RB3GVTvIyIsRBPWwy4ouTZJ5yqe9DqU1A5s2Bu/4AQTueDFfQegkTk98sbmj1oouejYlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000326; c=relaxed/simple;
	bh=EsBck0ZIrpAr1c9LGmHlzMnFpV+LaFo9dM5OJ5DyD9Q=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=OgOdiXDLFzzsY4SNLGS1kgXDvX8Dur8BR/Kjxzcppz5YckgZ3HWYUf1UR7w55YbEweXJQmjheU4o8mng8aeOAZnJlZup2oFhgd4SlipaZB6tQDEVMCQvEDXsZkXSQcyrl+X3dq/OWnMrD+vhxU3aICY+rPI5zB9Lz4GxkF6SrS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gF9SU8T4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gF9SU8T4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051D3C433F1;
	Tue, 27 Feb 2024 02:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000326;
	bh=EsBck0ZIrpAr1c9LGmHlzMnFpV+LaFo9dM5OJ5DyD9Q=;
	h=Date:Subject:From:To:Cc:From;
	b=gF9SU8T4/9k513DcKKhEgmK6I8wbURdNHebiOFXcRDoVn017DAptweQqgqiLq08Z7
	 eeRjdlWA+hiwu8pA19Wfe87web7JKlAYJ3oRgMleYeY07IssIfZ5lAclOk61Y1+DG0
	 xftXJjC8RG3C0dJxH7Amlkj0G6qpDPds404DqVsBkvUq9ZakFe5DtvnGFXqXxleIf5
	 s+E7iIav1PBN71cnpWxoIpKs7QTS9Sye3OECicm7SV9bLUIygeYLDejKmpmzW6zn/A
	 uxpzVuM1Ub0bduBRBlh8RCyaupFjhf9zGkAPRpVjxzGzpa8L9Twj331IK+4V+t3iie
	 gdnz9BFd41CHQ==
Date: Mon, 26 Feb 2024 18:18:45 -0800
Subject: [PATCHSET v29.['hch@lst.de'] 11/13] xfs: online repair of symbolic
 links
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170900015254.939796.8033314539322473598.stgit@frogsfrogsfrogs>
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

The sole patch in this set adds the ability to repair the target buffer
of a symbolic link, using the same salvage, rebuild, and swap strategy
used everywhere else.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-symlink

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-symlink
---
Commits in this patchset:
 * xfs: online repair of symbolic links
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_bmap.c           |   11 -
 fs/xfs/libxfs/xfs_bmap.h           |    6 
 fs/xfs/libxfs/xfs_symlink_remote.c |    9 -
 fs/xfs/libxfs/xfs_symlink_remote.h |   22 +-
 fs/xfs/scrub/repair.h              |    8 +
 fs/xfs/scrub/scrub.c               |    2 
 fs/xfs/scrub/symlink.c             |   13 +
 fs/xfs/scrub/symlink_repair.c      |  491 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.c            |    5 
 fs/xfs/scrub/trace.h               |   46 +++
 11 files changed, 599 insertions(+), 15 deletions(-)
 create mode 100644 fs/xfs/scrub/symlink_repair.c

