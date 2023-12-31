Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F2BB64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YR6zegMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BFAC433C7;
	Sun, 31 Dec 2023 19:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051675;
	bh=vjRc/XiF8kSOSU4uq73FHpordPpLbLFwWC3lyRCakmA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YR6zegMHH9yiXaZyDVP8K5YhSZldlwm11kXUquT2mL1rxJUbMg5CoVKA1DClIwfSb
	 PRKyNtgJt/e/lu9XfL6nvu5SSEJnJJ6o1afqFavd0/Xx7xYNHjgAV0NTOK0b/Qr67R
	 r381Fl0Btad94SND09teWq6NIinML9Pr0IjK6LiICewGwNFkL6OuI/6JCV2USyZuOb
	 gag+X5N8l223q2ATM5kym2imasIB1bEELDlFjtDIIMDvj3n66vAm2+d051hIJ0n6HX
	 DoVe6TQwhfjsX5naTFczj5xQTrbH9a0AL5Q4+j5Idx9uwsjTzx1fkcMsifGjmlQVRj
	 F/5rhLMhMcIdQ==
Date: Sun, 31 Dec 2023 11:41:15 -0800
Subject: [PATCHSET v29.0 06/40] xfs_repair: rebuild inode fork mappings
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404990800.1793572.4237173751599480312.stgit@frogsfrogsfrogs>
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

Add the ability to regenerate inode fork mappings if the rmapbt
otherwise looks ok.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-rebuild-forks
---
 include/xfs_trans.h      |    2 
 libxfs/libxfs_api_defs.h |   16 +
 libxfs/trans.c           |   48 +++
 repair/Makefile          |    2 
 repair/agbtree.c         |   24 +
 repair/bmap_repair.c     |  749 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/bmap_repair.h     |   13 +
 repair/bulkload.c        |  260 +++++++++++++++-
 repair/bulkload.h        |   34 ++
 repair/dino_chunks.c     |    5 
 repair/dinode.c          |  142 ++++++---
 repair/dinode.h          |    7 
 repair/phase5.c          |    2 
 repair/rmap.c            |    2 
 repair/rmap.h            |    1 
 15 files changed, 1227 insertions(+), 80 deletions(-)
 create mode 100644 repair/bmap_repair.c
 create mode 100644 repair/bmap_repair.h

