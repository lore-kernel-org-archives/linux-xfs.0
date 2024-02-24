Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC444184E;
	Sat, 24 Feb 2024 01:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708736897; cv=none; b=SjrVBO5izYTABybKwwdACLPg7l4TWGQD6vvo0sST66+QmkPf7Ibs6COxJMM8On7RG8mMfyhvhitmLMYATXT88S4eUKFD2EUkCkLDNz04TG+wiNeOON53vdzqex4Vn3SEx0ZJAxDm7LBJEBlQUAGBVAV0oZQuNCpFPKpR52V/+u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708736897; c=relaxed/simple;
	bh=mOtUKs1fF7YIK54Au+p8vxziPoOMq/LeiWUd5VUrEEk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jHO8c+8xO3MSmGRCCJufIcLAcON4Zx3+oCmxH/9kuYimVYsTJ19cN7Xpk+T/VFl0zuTtRIAH/tzzplAZeyv12R+QXlX6WL1EhSxw32UXlGJtGfcNfjaiKV610IY/F++8DxqcVLMMbbu9PxLzzyI1f/pXgkLl3Y31b0zxiuAN4Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mAmAWfoS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mAmAWfoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC85C433C7;
	Sat, 24 Feb 2024 01:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708736896;
	bh=mOtUKs1fF7YIK54Au+p8vxziPoOMq/LeiWUd5VUrEEk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mAmAWfoSSN8PEFSFQfWS2cyOb8dwXeoRKTX7rVET4S9bhyNubCNU/MpRKw/WClRZI
	 xLEz+B4q0Pzyoni+BOGsOKwLB9UhhPhLpxGkOnsS1D2iCtpyCQOrXlCRTyn+EN5Ir0
	 y1blXI6Eu40NYH3iDA7bDTlKWlK/dSdu5a/hmhYl3IXuehRy8ZMcDw8UKv6BoqkGeu
	 wcIk1nFd+b5mpAABPkfRQIAS/Hdn2Sa7dvmNRiz/rPOwIodemzmTyFWH3A8YKGWdXY
	 URuLFKCTvsavNESiBeMXjHOWgG4tUGxFazwFLUJqR84RDZQNkrgHW/sqW1YwhNjM8C
	 MQv8LzKWTABNw==
Date: Fri, 23 Feb 2024 17:08:16 -0800
Subject: [PATCHSET RFC 3/6] xfs: capture statistics about wait times
From: "Darrick J. Wong" <djwong@kernel.org>
To: kent.overstreet@linux.dev, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org
Message-ID: <170873668436.1861246.6578314737824782019.stgit@frogsfrogsfrogs>
In-Reply-To: <20240224010017.GM6226@frogsfrogsfrogs>
References: <20240224010017.GM6226@frogsfrogsfrogs>
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

This patchset builds off of Kent Overstreet's timestats code to capture
information about the amount of time we spend waiting for buffer, quota,
and inode locks; as well as time spent in the scrub code.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=contention-timestats
---
Commits in this patchset:
 * xfs: present wait time statistics
 * xfs: present time stats for scrubbers
 * xfs: present timestats in json format
 * xfs: create debugfs uuid aliases
---
 fs/xfs/Kconfig         |    8 ++
 fs/xfs/Makefile        |    1 
 fs/xfs/scrub/repair.c  |    6 +-
 fs/xfs/scrub/scrub.c   |    6 +-
 fs/xfs/scrub/stats.c   |  136 +++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/stats.h   |   21 +-----
 fs/xfs/xfs_buf.c       |    4 +
 fs/xfs/xfs_dquot.c     |   11 +++
 fs/xfs/xfs_dquot.h     |    4 +
 fs/xfs/xfs_inode.c     |   12 +++-
 fs/xfs/xfs_linux.h     |    5 ++
 fs/xfs/xfs_log.c       |    9 +++
 fs/xfs/xfs_mount.h     |   14 ++++
 fs/xfs/xfs_super.c     |   17 +++++
 fs/xfs/xfs_timestats.c |  156 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_timestats.h |   37 +++++++++++
 16 files changed, 418 insertions(+), 29 deletions(-)
 create mode 100644 fs/xfs/xfs_timestats.c
 create mode 100644 fs/xfs/xfs_timestats.h

