Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6D0B645
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G4+aL/d4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF16CC433C7;
	Sun, 31 Dec 2023 19:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704050987;
	bh=16OMI2ijysnSmXKqRbQ4zVO7RFkjyAFRKmesGGdwqZg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G4+aL/d4WVFo9IP4ouIDPj2OFut15ATWBgg6BdaMPmLbQX8J2Ykde7iOdvWYRB6MQ
	 wDG1vzIW95Uzil+NSnIGJe5ARlLmdqphXfjuckiVd8BCeShok/H/7EMZ9YR0lVJtag
	 cFQY/uXG35fILAJvcHKv5XivmgOiaePY9hqg5QxezSIwodtla15ooZO6AIW3ZR/uhF
	 VkzYW1VtSfvTLHqovwUV1yCjc1KQDK4XZDLh2JtDuHp/ekauYLHEgyg+f3KfHxw4He
	 CSiyCqO3lmpHPh7rs5fKPSr+tKhulI9+mAGlnm837qKZAR5+CprKcxCAxvPpUsbdqH
	 tCc1x1ocPWdAQ==
Date: Sun, 31 Dec 2023 11:29:47 -0800
Subject: [PATCHSET v29.0 17/28] xfs: create temporary files for online repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833858.1752674.247392515267008994.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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
 fs/xfs/xfs_itable.c     |    8 +
 13 files changed, 840 insertions(+), 26 deletions(-)
 create mode 100644 fs/xfs/scrub/tempfile.c
 create mode 100644 fs/xfs/scrub/tempfile.h

