Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FE6B64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eioIHa/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815CDC433C8;
	Sun, 31 Dec 2023 19:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052348;
	bh=udvsFUou2/lvz7kPMxzoNoGeGiSCHN3amaV7TClJiAU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eioIHa/AGjkS6uyPUTzixmaEgMhHhxB3OnLAjPE0Q7qXAd7D4U6GOczuQEDtLY2wn
	 iD1R/qToJj8KIHfiQLnpOdjnIiX07RKYfMWiprLwm01i0Vm3jfjNeA3MYLbz9qONrl
	 bye5I7p/Y5PMycCD+c5Oi/j9FvpA5DDwu/E4P6dHPMVMi0By/b8v0ZkEQ0MruUef/C
	 53RuyF59cdMp9QZ2RHFGehYcpvJIpo6LTPpnX7J/ExHSXcrgLW4H4LosFRq34QtPhi
	 evOXoAUgthkKCII/8x40gxyRvo/3L6BeSljkir7Yod2EX4MhEUqTiJQEjJyFbdoDgi
	 qb2pGC55/PFcg==
Date: Sun, 31 Dec 2023 11:52:27 -0800
Subject: [PATCHSET v2.0 03/17] xfs_db: debug realtime geometry
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405011015.1810817.17512390006888048389.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182323.GU361584@frogsfrogsfrogs>
References: <20231231182323.GU361584@frogsfrogsfrogs>
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

Before we start modernizing the realtime device, let's first make a few
improvements to the XFS debugger to make our lives easier.  First up is
making it so that users can point the debugger at the block device
containing the realtime section, and augmenting the io cursor code to be
able to read blocks from the rt device.  Next, we add a new geometry
conversion command (rtconvert) to make it easier to go back and forth
between rt blocks, rt extents, and the corresponding locations within
the rt bitmap and summary files.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=debug-realtime-geometry
---
 db/block.c        |  167 +++++++++++++++++++++-
 db/convert.c      |  409 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 db/faddr.c        |    4 -
 db/init.c         |    7 +
 db/io.c           |   39 ++++-
 db/io.h           |    3 
 db/xfs_admin.sh   |    4 -
 man/man8/xfs_db.8 |  129 +++++++++++++++++
 8 files changed, 722 insertions(+), 40 deletions(-)

