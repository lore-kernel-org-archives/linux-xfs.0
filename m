Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6563C49E
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PitT0+J9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A197EC433C8;
	Fri, 24 Nov 2023 23:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700869520;
	bh=Qg5GmLJZRijMf7hOs+fd9D6OiRNWXlqSWN8daSw0+bs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PitT0+J910A/tnJxgHbwf5zx9/sKc2ImRFXNlu/2kOnjxFGStcseLF9SFXlVHSS1S
	 ekYwi/mjl1b6zQBHHQOexi1+fy1dl4fPc9iznGD5HrjY1gwi7oxP6O4Wjq6K8V0kTd
	 iQxWQj9xX2ghbqlsrY6BBWpg7BMO28jQCHiwJgGPJHRrx4W/W3aTe2WrQJosJmtHNR
	 T5qp9jUwJpA1BenhIgLyA2qBT3m/Zng7uMml6c/J7wz61Yc7XtDOFQkgdJnLp0YQ5r
	 kyrHxc5DEeXDsmr4xNkdRJFMSu9icdhMGNvE05m2MYMpz6zE5BaroiaTRE5zRy3PHs
	 4EaIRGMh8c97Q==
Date: Fri, 24 Nov 2023 15:45:20 -0800
Subject: [PATCHSET v28.0 0/4] xfs: prepare repair for bulk loading
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086926569.2770816.7549813820649168963.stgit@frogsfrogsfrogs>
In-Reply-To: <20231124233940.GK36190@frogsfrogsfrogs>
References: <20231124233940.GK36190@frogsfrogsfrogs>
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

Before we start merging the online repair functions, let's improve the
bulk loading code a bit.  First, we need to fix a misinteraction between
the AIL and the btree bulkloader wherein the delwri at the end of the
bulk load fails to queue a buffer for writeback if it happens to be on
the AIL list.

Second, we introduce a defer ops barrier object so that the process of
reaping blocks after a repair cannot queue more than two extents per EFI
log item.  This increases our exposure to leaking blocks if the system
goes down during a reap, but also should prevent transaction overflows,
which result in the system going down.

Third, we change the bulkloader itself to copy multiple records into a
block if possible, and add some debugging knobs so that developers can
control the slack factors, just like they can do for xfs_repair.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-prep-for-bulk-loading

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-prep-for-bulk-loading
---
 fs/xfs/libxfs/xfs_btree.c         |    2 +
 fs/xfs/libxfs/xfs_btree.h         |    3 ++
 fs/xfs/libxfs/xfs_btree_staging.c |   67 +++++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_btree_staging.h |   25 +++++++++++---
 fs/xfs/scrub/newbt.c              |   11 ++++--
 fs/xfs/xfs_buf.c                  |   47 ++++++++++++++++++++++++--
 fs/xfs/xfs_buf.h                  |    1 +
 fs/xfs/xfs_globals.c              |   12 +++++++
 fs/xfs/xfs_sysctl.h               |    2 +
 fs/xfs/xfs_sysfs.c                |   54 ++++++++++++++++++++++++++++++
 10 files changed, 189 insertions(+), 35 deletions(-)

