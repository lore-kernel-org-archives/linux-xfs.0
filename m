Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF06189BBB
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688018; cv=none; b=gI7GkAvBMlNdZXW2+jQECBXiSKsq0vj7/uJ46BmX7uPRERw8r8E0ymDaq6Oz+GXwH+Vo8/4xUA5KNLMk+BJudor0K8f48KHN4XhckWjKf/bGH+MAVVfNxqHE0a1Cp6QuRS8Fl9NpHwnJrLAjPe7UhfE/1BH0SrqjVqbLu774twk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688018; c=relaxed/simple;
	bh=kf9JYrVPpozezWjRxdxpfmxbJlmmZdbeoxh4qS9tBxA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gGv+m8UN5byYKzgp/OBH7PMOkyMrh2p9liC2xruC0XcRjK4jbq5wlOHnFR1rVUQFsHDzSj8egvP54CZ+qvkHcr42xMMcSd8PI4S+ZI7R7siwMo5YCjUxuCpk0jkIEPcKTgAX8W9FH2AgTWBQCYcL+dbSx4hXIDmL4ohvYzuTLR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WzyOcZcc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WzyOcZcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90765C4CED2;
	Tue, 31 Dec 2024 23:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688018;
	bh=kf9JYrVPpozezWjRxdxpfmxbJlmmZdbeoxh4qS9tBxA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WzyOcZccJf3o1Et18UAoUUja0Z0z4q4ZAWA+2SaX6QZJrs1dOjoOFDflVcVWuvL9f
	 m4vcMQuRv9EIWsqn4ogqO8/It3cRpCNWy7yNMQ1PANF7qSHnqh1Gwl4PnWPWaRouZM
	 ugbiwF5nIM8TubEmx9A1fzb7FjBntj/udP1ATC1xUno8uaHMouEwG1QSJQ5Xm6cx9W
	 4WRNd6+5huTglc8w8B3mw49pXt2oB63B9uyXgB33qnkInb/5moE7Y/wkGXjZKwZVxx
	 npVhIJxCGyYf0d20PRGTswSsNN/fs7w+HLerH2IfIk4LgFPYd7EoiDEdc9lt0mqBQb
	 voxuvZEHkiNwQ==
Date: Tue, 31 Dec 2024 15:33:38 -0800
Subject: [PATCHSET RFC 1/5] xfsprogs: noalloc allocation groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568777001.2709441.13781927144429990672.stgit@frogsfrogsfrogs>
In-Reply-To: <20241231232503.GU6174@frogsfrogsfrogs>
References: <20241231232503.GU6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series creates a new NOALLOC flag for allocation groups that causes
the block and inode allocators to look elsewhere when trying to
allocate resources.  This is either the first part of a patchset to
implement online shrinking (set noalloc on the last AGs, run fsr to move
the files and directories) or freeze-free rmapbt rebuilding (set
noalloc to prevent creation of new mappings, then hook deletion of old
mappings).  This is still totally a research project.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=noalloc-ags

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=noalloc-ags
---
Commits in this patchset:
 * xfs: track deferred ops statistics
 * xfs: create a noalloc mode for allocation groups
 * xfs: enable userspace to hide an AG from allocation
 * xfs: apply noalloc mode to inode allocations too
 * xfs_io: enhance the aginfo command to control the noalloc flag
---
 include/xfs_trace.h  |    2 +
 include/xfs_trans.h  |    4 ++
 io/aginfo.c          |   45 ++++++++++++++++++--
 libxfs/xfs_ag.c      |  114 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_ag.h      |    8 ++++
 libxfs/xfs_ag_resv.c |   28 +++++++++++-
 libxfs/xfs_defer.c   |   18 +++++++-
 libxfs/xfs_fs.h      |    5 ++
 libxfs/xfs_ialloc.c  |    3 +
 man/man8/xfs_io.8    |    6 ++-
 10 files changed, 223 insertions(+), 10 deletions(-)

