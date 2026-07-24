Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5504B3890E0;
	Fri, 24 Jul 2026 06:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784874074; cv=none; b=k9hwCwyBQ1MsnQDmR5eUuZskSFfqIcbUpv0zVC6IA2Iwfz+51fpMKCb2TGZlCJwuT+MJTVcWKkBr/you24et2tQS3VjSWCAH1vUFBCghrb/xqWFxi0AAboKTv2Lxo1Y68cQRxNI/YZ9CfCsSC7GMl+75jyPyryMApUQibd1GZh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784874074; c=relaxed/simple;
	bh=aCA8lO80bR8RLZFSk9c4orCaRb6bCWflFbTjywLfuUA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=Vo6RHtLjonqKbXzQoz/CKcsMxZZDJ6S8wIumzmi8m4XNPMXLNsV260MNtvbM4k6LIOt55wyVbEohLlqrlyGXXT4sU8iMDEoQ0C0W9XKzy13ZgSmb2UdO6ZJrQetYbFEdFcAWxpHNi3OlNATgqZceouAAKV3dkP7vNKQvAHhKRSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KS+4/Ae+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KS+4/Ae+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1D3B91F000E9;
	Fri, 24 Jul 2026 06:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784874071;
	bh=o4OE1uxn76VVrybt60Ig9zNQ65JGIOVmbQg4/ycqz7A=;
	h=Date:Subject:From:To:Cc;
	b=KS+4/Ae+2h95N4soARFyB/jTY3XYHFI7qdXv/6Uerqp+eDPoF3aMtdqqluOiTsk5B
	 8oIKRDG0ugtYPObrzkveNq3Gh43YE3qpvsNdAkTf1BXEtT+Vlw+Rifv9OW/tppGnMl
	 dVZTB+02UW0G7U1Yy7fJKWFLHsJLvaSe7jSheHjjkV7R0oTTRiFaAG+eEmkwbUWteF
	 WXzdZz3XiopjVZC8vG09CbOJa8XSDNSP2gahULRbYDauTdlarecUJve0IlHQXPHfm3
	 f6h6MTVO+kc0h5WhpQjJtUo0fWNuAyUJwYEmu0Is/X5AKX7usXwuz+Bf+C/L2bIXQH
	 bmZ1O9W1LPPFA==
Date: Thu, 23 Jul 2026 23:21:10 -0700
Subject: [PATCHSET] xfs: LLM-inspired bug fixes, part 4
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178487405343.3442778.10258954219942220821.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a fourth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-4
---
Commits in this patchset:
 * xfs: only check mergeability of bnobt records
 * xfs: don't double-lock when deleting a self-referential directory
 * xfs: don't return EFSCORRUPTED when scrubbing corrupt parent pointers
 * xfs: don't zap the attr fork on repair when there are queued pptr updates
 * xfs: nlink scrub must take IOLOCK before determining ILOCK state
 * xfs: avoid UAF on sc->tempip in xrep_tempfile_create
---
 fs/xfs/scrub/alloc.c          |    5 +++--
 fs/xfs/scrub/attr_repair.c    |    3 ++-
 fs/xfs/scrub/dirtree_repair.c |   22 ++++++++++++++++++----
 fs/xfs/scrub/nlinks.c         |   13 +++++++------
 fs/xfs/scrub/parent.c         |    2 +-
 fs/xfs/scrub/tempfile.c       |    1 +
 6 files changed, 32 insertions(+), 14 deletions(-)

