Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E213215885D
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224074; cv=none; b=Xhqv42JkofGj1Iytt7hOMFJ3wixhx32F851xGJ3bDVwe2ryzhmRFXwqtvlbVzfcBcb7YNnZrIVOy6bjHpAabXUBFUSflfWmlZe59AtIagnhDpmPnn5AokE0wV4BpUCijcRle4aJQkz1XesLHfwftzE7m4fWYCTpO7zht89tUHZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224074; c=relaxed/simple;
	bh=hVUBloTCvu+0U1mXg/eZWsB6/yFossml/a15iKTeByo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pDNY06u5YoImSAnM9cLG4OpAL9AoimPl+nJUSIBXj/C+mQQavlmlEXzdiFSUu1zJz+higaIotDNsWuDjFiLVAEqbtA8emxH678CaD3O+7lREqxQs2TAGZxhfmKV3WsAuiQee7+aiyB8f0heogOJYWq4IFKPvVZh28blKeApJPPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ea0GoY90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ea0GoY90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72317C113CC;
	Mon, 15 Apr 2024 23:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224073;
	bh=hVUBloTCvu+0U1mXg/eZWsB6/yFossml/a15iKTeByo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ea0GoY90f/6abbW9q5Hs1irhqVDIZbtS4D1MILu1Xoo7TFfrHy4q87WE/GV7BYqWT
	 krXPhNk3lUXvWaGRyNAiG6U/nSTsfTLfq1CqeVkT5YZ+ifp2NLF700isM8uZ6knHx1
	 iloBuh2vtOm3x6/LB8E3FWx80tuhkGnrBYhGN2DX8DLVPDzsLFf6k1Qh1D4E5Rn3n5
	 KwrPxFOHNPcNfBLfxQWZoaFcBe2Bw6NViXEy7kcA19xGeZXb3KH2iJhq1f8DspzzAp
	 q0QVYoUjmCqhloV2dQ+0X1vxh/GsXqcBbHDGoy/xUx++ghboKvX0RHHzkl5f/Mz85L
	 OKgt37ZjS9Row==
Date: Mon, 15 Apr 2024 16:34:32 -0700
Subject: [PATCHSET v30.3 04/16] xfs: create temporary files for online repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171322381780.87900.770231063979470318.stgit@frogsfrogsfrogs>
In-Reply-To: <20240415232853.GE11948@frogsfrogsfrogs>
References: <20240415232853.GE11948@frogsfrogsfrogs>
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
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-tempfiles-6.10
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

