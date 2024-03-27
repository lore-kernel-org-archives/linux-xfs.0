Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2083FD4
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504057; cv=none; b=JCFD8pk/CuHL+UA2aHn30EP2gLXaKPLVLxztpygN0b8BTYki9uBA0ilD7HmsEVoHivGCgzmMgtmf7A8A0qo6t4wR/ruLjDg/yuKAhLVenLn+6DGCXPlHkH2exZ1qMWzatBlqVrSiA/RMhdu8Dhjv1rzpHWOXxECpaLWftfmfiyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504057; c=relaxed/simple;
	bh=dRffNjICutfGp6/4ThDDPUj/zErDYbtXtsFa5u/Hr2Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X6Jv3uhZ1VvjNZZIBhByLeg/YBgpa6qjeU0c6PJGGSyWVBHNcZvPJoT2ZmirjSDlXcpHXDVpGPNpfiqFG0Sz2R0bc9zklqiwdBOBG/bzSlcgu9tGlG/waG3FYTCjrCzQKlIbZiZ4mvx9ll86Tmd9WFol726U05yc1RWupRmKRvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DC7PAGJj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DC7PAGJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499CEC433F1;
	Wed, 27 Mar 2024 01:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504057;
	bh=dRffNjICutfGp6/4ThDDPUj/zErDYbtXtsFa5u/Hr2Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DC7PAGJjLtfs5PPPAQNzx78e1sWhTqQRPRuf3FCeBdF8Xi0TEjC9m7yBe2NzcAIfJ
	 16zE3239f+WkXW+LQqJ/+ER93qnuZxdaSbvhpMu7UhXTL38LBhgukSNW67AVnToV6q
	 qRIV/rH8kssxRujU2eVOMaGv8/BUMB4ZikkIpEUnRtPu5Jnl16njNRf0JyKLBnkeGR
	 RPrOaV/5Y4AwqwH0VW32mkoTPHGrz4Q9dNZFVNGExk3IVLwwKug42LpKD8YmPFOzgG
	 iVUvJGLk1nVpLhWZtAGHPGzJbVKdaAO21HXkPJZgx6KGsd7DCFZckWA/LSydH+1h/u
	 PvFlPdfRbFeIg==
Date: Tue, 26 Mar 2024 18:47:36 -0700
Subject: [PATCHSET v30.1 05/15] xfs: create temporary files for online repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171150381244.3217090.9947909454314511808.stgit@frogsfrogsfrogs>
In-Reply-To: <20240327014040.GU6390@frogsfrogsfrogs>
References: <20240327014040.GU6390@frogsfrogsfrogs>
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

As mentioned earlier, the repair strategy for file-based metadata is to
build a new copy in a temporary file and swap the file fork mappings
with the metadata inode.  We've built the atomic extent swap facility,
so now we need to build a facility for handling private temporary files.

The first step is to teach the filesystem to ignore the temporary files.
We'll mark them as PRIVATE in the VFS so that the kernel security
modules will leave it alone.  The second step is to add the online
repair code the ability to create a temporary file and reap extents from
the temporary file after the extent swap.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-tempfiles
---
Commits in this patchset:
 * xfs: hide private inodes from bulkstat and handle functions
 * xfs: create temporary files and directories for online repair
 * xfs: refactor live buffer invalidation for repairs
 * xfs: add the ability to reap entire inode forks
---
 fs/xfs/Makefile         |    1 
 fs/xfs/scrub/parent.c   |    2 
 fs/xfs/scrub/reap.c     |  445 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/reap.h     |   21 ++
 fs/xfs/scrub/scrub.c    |    3 
 fs/xfs/scrub/scrub.h    |    4 
 fs/xfs/scrub/tempfile.c |  251 +++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.h |   28 +++
 fs/xfs/scrub/trace.h    |   96 ++++++++++
 fs/xfs/xfs_export.c     |    2 
 fs/xfs/xfs_inode.c      |    3 
 fs/xfs/xfs_inode.h      |    2 
 fs/xfs/xfs_iops.c       |    3 
 fs/xfs/xfs_itable.c     |    8 +
 14 files changed, 843 insertions(+), 26 deletions(-)
 create mode 100644 fs/xfs/scrub/tempfile.c
 create mode 100644 fs/xfs/scrub/tempfile.h

