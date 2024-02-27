Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD0C125B9
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000292; cv=none; b=iRcSfv8yupnj/JKWVWpzOYjuMN0yvjFnqIL9wT6FHShNnJqx10FSB21F2eBYEs0R9pnVS3dNCypwmgOFoz4NbXIpQJyFgvf+PRqsYNXycs6pxuxqqSelYxknhOsa1RROe0cHMhNp8QjJBfXUGHww7pv/VNfPjAJMoRlUflxiGL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000292; c=relaxed/simple;
	bh=cnHf5DDQJYfoX4BdJSWUOlCz4vJhel22KyAkPg6tb4c=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=Jn4AToxjV/hB/zdYzlIwB6r+EbuD8Hg8B1zRMwENBRihFFlod3Kz+bLK+BHdC0hN9OJEBARnMoW5Yl1zLpDIFkTArL8oWd+mpatdPlqmCmgpZs1BdERndYthKA1IVpjFQP3ksSCGxBEf7RkuU1lgPHMNlAzV0pGWzxCcQOjhnn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wz3M0ZZw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wz3M0ZZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371DEC433F1;
	Tue, 27 Feb 2024 02:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000292;
	bh=cnHf5DDQJYfoX4BdJSWUOlCz4vJhel22KyAkPg6tb4c=;
	h=Date:Subject:From:To:Cc:From;
	b=Wz3M0ZZwACfwSUv3xqExjbd/STgcsjShgxoBbCiSZziq4/9NtaZNNLZruFkdoVGU7
	 xAOWmljbBfaTIWVeh5uF6tloAY+TF2EdEs8Norbp0zxeY+7CUetMUa1B78+M0TjrJq
	 FzkWPLWf6CIhMAlHq5Ij61wNoFk5v48e2Vv+U2hDnzn/WyHtGLyBwpPIl1sBVB7gRi
	 +drpwBcj/l5X0mGiIpu152auyO4LgCTGGsd+R343EqKOzjLHqFctXAiJ7u80JGA4C+
	 RuCsnBYs02jTcNzBI+6Fz89BVl3+YTAAOFpWLRXjHZOhfNkSLZRF/HArBAzPKyifJu
	 aYE7pAwwDYvVw==
Date: Mon, 26 Feb 2024 18:18:11 -0800
Subject: [PATCHSET v29.4 05/13] xfs: online repair of realtime summaries
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170900012647.938812.317435406248625314.stgit@frogsfrogsfrogs>
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

We now have all the infrastructure we need to repair file metadata.
We'll begin with the realtime summary file, because it is the least
complex data structure.  To support this we need to add three more
pieces to the temporary file code from the previous patchset --
preallocating space in the temp file, formatting metadata into that
space and writing the blocks to disk, and swapping the fork mappings
atomically.

After that, the actual reconstruction of the realtime summary
information is pretty simple, since we can simply write the incore
copy computed by the rtsummary scrubber to the temporary file, swap the
contents, and reap the old blocks.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-rtsummary

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-rtsummary

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-rtsummary
---
Commits in this patchset:
 * xfs: support preallocating and copying content into temporary files
 * xfs: teach the tempfile to set up atomic file content exchanges
 * xfs: online repair of realtime summaries
---
 fs/xfs/Makefile                 |    1 
 fs/xfs/scrub/common.c           |    1 
 fs/xfs/scrub/repair.h           |    3 
 fs/xfs/scrub/rtsummary.c        |   33 ++-
 fs/xfs/scrub/rtsummary.h        |   37 ++++
 fs/xfs/scrub/rtsummary_repair.c |  177 ++++++++++++++++++
 fs/xfs/scrub/scrub.c            |   11 +
 fs/xfs/scrub/scrub.h            |    7 +
 fs/xfs/scrub/tempexch.h         |   21 ++
 fs/xfs/scrub/tempfile.c         |  391 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.h         |   15 +
 fs/xfs/scrub/trace.h            |   40 ++++
 12 files changed, 718 insertions(+), 19 deletions(-)
 create mode 100644 fs/xfs/scrub/rtsummary.h
 create mode 100644 fs/xfs/scrub/rtsummary_repair.c
 create mode 100644 fs/xfs/scrub/tempexch.h

