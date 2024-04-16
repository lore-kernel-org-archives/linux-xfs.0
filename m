Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C58A1C10
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230419; cv=none; b=l1upLoAvVPPvIXJJPR3y7N5CyhWbTNofnBvt2dyJTHnjpsYIPfV6V3GP9/++V86Usa8byweWhh+KyGHp+Ru37nc4zPnGLKLJH3EXibykvigvu/ku9xYl0Fd62gxXBZJnBvAz7/2yrhje2Uum/IDhe4qisvhQywZlJfPoxe9YYDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230419; c=relaxed/simple;
	bh=r2ezKVvhp49OsG72JyUStHr10jVBfco8v21b22pv8zQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e+nJqzVz1DLwUC9+jhMBoycRtNgdxvEPEVfHNG+dWiGL9vPCsAOGWD00l4UKSTnjVpIFrQIllR8lrjN9uAnqdB/Y2tgPh+Sd18BDptH9hn8rTVZY1+it56arrcRGthuyXFuU1lhQ5nEZl6wwaZjNHYJvdvmrMMH2jhP60wFU7Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SIcu5sMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SIcu5sMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D243EC113CC;
	Tue, 16 Apr 2024 01:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230418;
	bh=r2ezKVvhp49OsG72JyUStHr10jVBfco8v21b22pv8zQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SIcu5sMoZ8dH+Y5CtqOlFHhwEIsegYrUUy+UnbKqF6A4twbN/SsH6pqKP9cDHr3G1
	 J56uUBkVzirAwm7OUayIeHyoy8rE2GuAYsSIoUR6e+lSHRwy2sRSMZyhXRQSZA1Jip
	 LzrItev4aQ5uah83OnR3x3RdSjft/FnC6h+qW8XWfbMkxUaDPZ89We5JM7mIJqjXew
	 5q35XF3yG5Bmb9hJfaI322P1KpbE5xQBa2X8hVriBMf8aMswxlcVjQPbt2i5dYZhDg
	 0slDjZYmeYCw0iGypQNadSrrAqj/J+3+9n92kOwjEtsUR1+nZrPzfVRXWY/G8JVXVI
	 5qN8Loc2PsMCQ==
Date: Mon, 15 Apr 2024 18:20:18 -0700
Subject: [PATCHSET v13.2 4/7] xfs: scrubbing for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323028648.252774.8320615230798893063.stgit@frogsfrogsfrogs>
In-Reply-To: <20240416011640.GG11948@frogsfrogsfrogs>
References: <20240416011640.GG11948@frogsfrogsfrogs>
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

Teach online fsck to use parent pointers to assist in checking
directories, parent pointers, extended attributes, and link counts.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-pptrs

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-pptrs
---
Commits in this patchset:
 * xfs: revert commit 44af6c7e59b12
 * xfs: check dirents have parent pointers
 * xfs: deferred scrub of dirents
 * xfs: scrub parent pointers
 * xfs: deferred scrub of parent pointers
 * xfs: walk directory parent pointers to determine backref count
 * xfs: check parent pointer xattrs when scrubbing
---
 fs/xfs/Makefile              |    2 
 fs/xfs/libxfs/xfs_parent.c   |   22 +
 fs/xfs/libxfs/xfs_parent.h   |    5 
 fs/xfs/scrub/attr.c          |   27 +-
 fs/xfs/scrub/common.h        |    1 
 fs/xfs/scrub/dir.c           |  342 +++++++++++++++++++++
 fs/xfs/scrub/nlinks.c        |   85 +++++
 fs/xfs/scrub/nlinks_repair.c |    2 
 fs/xfs/scrub/parent.c        |  685 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/readdir.c       |   78 +++++
 fs/xfs/scrub/readdir.h       |    3 
 fs/xfs/scrub/trace.c         |    1 
 fs/xfs/scrub/trace.h         |   65 ++++
 13 files changed, 1307 insertions(+), 11 deletions(-)

