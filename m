Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D403133981
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706590986; cv=none; b=UWIdVyuoqY6yC4GVuU5u/zzLTN8gSRF+7s9SxP9zdGn+xOct+aKMX2e18fB/EKFiRZY6DNSkRAKuyUVYf+mhzPu0dgmlx7I9yf9XUpeUYBQsES6jtt0uXbjJve/roTrEP5V7DwrWxA1/CbSPbZWuItL7kBWkT6UHkN2EvSWJcPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706590986; c=relaxed/simple;
	bh=rxaQRFsAFPudx8AG2U/CHcQfYch456OUq8vvTXRcUlM=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=mOFY7ePpPQYzoOp1AiFXtF78QDRBnJd7bMhpc1qOgeIJIW1milodJIU5Jc2uxNpJpZVdt9n4Q9gL0fzhY9r0Qig5NEEGvIFFOg7VudjEbmLEY0JpKEiMSTiFzjJ4RKsJwr+eIMuW9CUIBq0XLE+G5gR6TgZh4ajJFntrr+QeYBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fE2NOf9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fE2NOf9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47478C433C7;
	Tue, 30 Jan 2024 05:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706590986;
	bh=rxaQRFsAFPudx8AG2U/CHcQfYch456OUq8vvTXRcUlM=;
	h=Date:Subject:From:To:Cc:From;
	b=fE2NOf9JSPXds/7Z/nDVyonORpssEixwsR8mvTikNEfx9i9sn2tBCVJJiDWsyNwEg
	 nzLsvpGB2WQ5R39LtwO3Zb7l6ME0Iz1YaCS22WoH7FbtucqYlciGvq/UA74HRs9nm5
	 F6oburrcNGCTpqgHnZtS0SkZqflhkQcqwJaRqBb7g7RG+o6k/o8gJcAcQgUCTihq+X
	 ZrPCZ5SIppatVPIcK/dsoQbHXPWgEf1ywI9M1+hrutXhI1PyDXle1rwavw4tJISKH0
	 JSDtAVO2MwhC0uRj2BWo5WV3hGBd0t6+jxhTSPihx0hdjiZRJivlXHxnE7Xvkdq4Nn
	 yVenAQHCHUdEw==
Date: Mon, 29 Jan 2024 21:03:05 -0800
Subject: [PATCHSET v29.2 1/7] xfs: live inode scans for online fsck
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659061824.3353019.15854398821862048839.stgit@frogsfrogsfrogs>
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

The design document discusses the need for a specialized inode scan
cursor to manage walking every file on a live filesystem to build
replacement metadata objects while receiving updates about the files
already scanned.  This series adds three pieces of infrastructure -- the
scan cursor, live hooks to deliver information about updates going
on in other parts of the filesystem, and then adds a batching mechanism
to amortize AGI lookups over a batch of inodes to improve performance.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-iscan
---
Commits in this patchset:
 * xfs: speed up xfs_iwalk_adjust_start a little bit
 * xfs: implement live inode scan for scrub
 * xfs: allow scrub to hook metadata updates in other writers
 * xfs: stagger the starting AG of scrub iscans to reduce contention
 * xfs: cache a bunch of inodes for repair scans
 * xfs: iscan batching should handle unallocated inodes too
---
 fs/xfs/Kconfig       |    5 
 fs/xfs/Makefile      |    2 
 fs/xfs/scrub/iscan.c |  738 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/iscan.h |   81 +++++
 fs/xfs/scrub/trace.c |    1 
 fs/xfs/scrub/trace.h |  145 ++++++++++
 fs/xfs/xfs_hooks.c   |   52 ++++
 fs/xfs/xfs_hooks.h   |   65 ++++
 fs/xfs/xfs_iwalk.c   |   13 -
 fs/xfs/xfs_linux.h   |    1 
 10 files changed, 1092 insertions(+), 11 deletions(-)
 create mode 100644 fs/xfs/scrub/iscan.c
 create mode 100644 fs/xfs/scrub/iscan.h
 create mode 100644 fs/xfs/xfs_hooks.c
 create mode 100644 fs/xfs/xfs_hooks.h

