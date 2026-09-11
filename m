Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6C049E13D;
	Fri, 11 Sep 2026 05:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789106016; cv=none; b=Zrkz6qnxhGV5+iW6MQJrnaHLMYPk3rCwsYDbMT5bA8V9Wsy7GsLt55BBTmeZIdd/jNvRCqbaItu5/1CZ3ryPP9o7CG8xYrHnSGFJZbQ7QRtaRl1ZAv+LlriuWTqE2BKi2p6yJIRdi3qEXns0kAq/Q+znwczFjvypoktFTDLXXdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789106016; c=relaxed/simple;
	bh=D8JDb0jN12znCOqM9EZxahvVkpn9OD1Q+r4zc2bL0Xw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=KYM8uVu5lNpsDdsfe+dE4IMK1rocxBtpQ6IP/AmhLbpEmzCCr8hRlH1T181ZEv7XSBlfnK+gWyeENn4Ai/S3r2/0plgoBSb95mh36uv4DJIglD9Hbrj5OrihSuprGM9w+UQFxt9SGnyI6IZBinagPBS4duK+2kVVbQAKH8c3Uls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=epo3e++/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="epo3e++/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A30961F000FF;
	Fri, 11 Sep 2026 05:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789106014;
	bh=iIepxeTYepXCTrv1KTKDw/hVXLSlHxGbaqY3xpKfgn4=;
	h=Date:Subject:From:To:Cc;
	b=epo3e++/u57GvYuXKuUITZGOEZVNfy7wSMuA6PMmlcr8EQFaYGsApNa+/nwE878fq
	 sB2NJYsiImffbIrus0xdCPbeWtUrfFfEJnU4fEjHSQKguYdydrnc9d4sYexPN2fIiN
	 nxpS8rgHrgMne81D/juf8Xqd4UTayYwM/QfGhzRv+8OHWInWt2AZEVoa+dhYjZ63Ts
	 jaPtBsarS719Lu1aQCQvdQ5+dgV3mvBywyW2zXhF2XmEj6GXP1LnprxC/FCro5nsPS
	 7n2rBzlIV+KLgG+mw2q5CzygHMK9MlzRQkz08ocJJMSavn5N1oNmdWuT+SmKVq8iB9
	 0b5cJG6a6j13Q==
Date: Thu, 10 Sep 2026 22:53:34 -0700
Subject: [PATCHSET] xfs: LLM-inspired bug fixes, part 14
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178910161988.174887.8958318922224347752.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a fourteenth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-14
---
Commits in this patchset:
 * xfs: check padding field in xfs_ioc_commit_range
 * xfs: don't call xfs_exchange_range_finish for a dry run
 * xfs: use the correct reservations for rtrmap/refcount recovery
 * xfs: fix integer overflows in xbitmap set functions
 * xfs: only flag zero padding for dir3 data blocks, not dir3 block blocks
 * xfs: check di_forkoff correctly in scrub
---
 fs/xfs/scrub/bitmap.c      |   26 ++++++++++++++++++--------
 fs/xfs/scrub/dir.c         |    2 +-
 fs/xfs/scrub/inode.c       |    2 +-
 fs/xfs/xfs_exchrange.c     |   13 +++++++++----
 fs/xfs/xfs_refcount_item.c |    8 ++++++--
 fs/xfs/xfs_rmap_item.c     |    8 ++++++--
 6 files changed, 41 insertions(+), 18 deletions(-)

