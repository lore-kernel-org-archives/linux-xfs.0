Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDB535E1B0;
	Mon, 27 Jul 2026 05:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785129776; cv=none; b=Y9kw48+yWP8c1ZIcTByUeNmVMa8CWMZGP+WsfJzMQ4Cfz18dj6QzuU02mh0bRaVzmpVmQ7Jjryd+Pbrmu6ZrLU3duOdmwzxXmLPv9wr2qPxeREEAYdyWZaVCQULdUrGNwpE4zyqrqNkMBYav9wkvvynMrC4lXDnDt/ha24aLYYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785129776; c=relaxed/simple;
	bh=ieVAkqFp2YVM4cBTXrYrYG6gvTgCRZsiKYrrGAez36E=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=W9Vmtto/ZtZYQl/OdftecdE9Dt/mBPPYdZSk4BmHqCoi4giifrCwdeEKxdk3yEDuPwzmP1KJnai+byJqAI7UhMC1uaPXouOge1i0tFV1eoNMTF6z7mQ7+hWKHF5uo3iuxt+/5wjKc8N4CxxGLFIJYVYRkTXbQLzwiImqshMPeog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/3q0QqS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/3q0QqS"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 988D81F000E9;
	Mon, 27 Jul 2026 05:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785129774;
	bh=GrKyuAwpp8RAwRSJtwhB0ZCVcBJ2lGf10atwYk7WPuU=;
	h=Date:Subject:From:To:Cc;
	b=h/3q0QqSn4BQGwDkpoYSEw5tlKtdLK8HNWHdaG427wOLcVLOvNxUmoTJMYdW4rMON
	 WcNACSlhUbFDr8+d5eCbiIcePDV7M2/gmkbhuein7NGKb3AxVXNTRAgTsv0UIEm127
	 yd13WM3bgGQ2h+1Z8mL/+Ph8QOhYWLpMPYymw6CDU1g3GJ9dPkQLZN6B6Ui0ucRwcI
	 e0OukhvlhjCtFurANcpSWNB8N4RcohK3m9Crf6h4WN090afmXu/nXtZqEM+z7qRQ/P
	 8Aestx0iADbbYJkOH5Q6SROpPBf/oTKEM7HOHYrlmsG0C/sbZYNMzoi1JgpBnAybI1
	 2ihqKGfKDoSqg==
Date: Sun, 26 Jul 2026 22:22:54 -0700
Subject: [PATCHSET v2 2/2] xfs: LLM-inspired iunlink repair bug fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178512389537.1495075.1621818931849629575.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

These bugfixes got started as part of a series of assorted bug fixes.
However, in writing a test case to exercise weird corruption scenarios
I discovered a few more fixes, so I decided to collect them all in a
targeted series.

v2: add rvbs, fix a few minor coding errors, strengthen loop detection

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

The remaining unreviewed patches in this series are:

  [PATCH 08/10] xfs: fix another iunlink infinite loop bug in online
  [PATCH 10/10] xfs: don't ignore runtime errors in

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-iunlink
---
Commits in this patchset:
 * xfs: hoist per-bucket unlinked list check to helper
 * xfs: don't livelock in scrub on a circular unlinked list
 * xfs: don't walk off the end of a null sc->sa.agi_bp in AGI repair
 * xfs: load next_agino from the correct xfarray in xrep_iunlink_relink_prev
 * xfs: pass runtime errors from xrep_iunlink_mark_ondisk_rec up to callers
 * xfs: check xfarray iteration errors when committing unlinked inode lists
 * xfs: fix allocated inodes that show up in the unlinked list
 * xfs: fix another iunlink infinite loop bug in online fsck
 * xfs: set the prev pointer when reinserting an inode on the unlinked list
 * xfs: don't ignore runtime errors in xrep_iunlink_reload_next
---
 fs/xfs/scrub/trace.h           |    2 
 fs/xfs/scrub/agheader.c        |   94 +++++++++++++++++-----
 fs/xfs/scrub/agheader_repair.c |  169 +++++++++++++++++++++++++++++++++-------
 3 files changed, 213 insertions(+), 52 deletions(-)
