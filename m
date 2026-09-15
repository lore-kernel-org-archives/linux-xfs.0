Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BE343DEBD;
	Tue, 15 Sep 2026 05:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789450610; cv=none; b=EK0B9AX3HXkLkY4eCoJ9QtFLSOmmXxzxCJuz+qd8TFjyXf2h3DEPbgezcqcrhHjDpQ/mu8CQESaJqVM34OVHlnCtKvgZMMqCJS6cLnnl9uiKedoCclcpr5u6MpqJg0cJoyjf+t512J0/NBM90cyXHxyj3NWRzdIoniLgxn5BFh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789450610; c=relaxed/simple;
	bh=N52tyfrCS1WBIBiTpmcrqP2KOsoQyV2z+2DTVjRj//o=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=lmP5e9O41UdjG9C+JIkDzXFB4DmDKhjwwTqZu8VaOhaiE208KYJ7IaE3HI7i0/62S3Rnyj32CjUIjQLaAn/bpucmSH4pWmjQQZH1KiFb+1jPVjvUGKo19DhuL/pot4ayhN6UItFox3qsjRTn3iH5L4k9KUz+FSg7/tAuj9fcb7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JSVcoX30; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JSVcoX30"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6E57E1F000FF;
	Tue, 15 Sep 2026 05:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789450604;
	bh=/3lD6o3nxLhhTVe+YBhlzC242wSoiwZD2q61FgBujm8=;
	h=Date:Subject:From:To:Cc;
	b=JSVcoX302sCgVDJaDdr4NhRSevFkMhh3+0VIJbeBIgYJS65T78FapYUNM4RpMsqOx
	 Elpvxurxyq8PbVqDHpkHac/PS9gI68lHE7f3dHay1P6FvlL9CxCuGE4UjxPq1es4nz
	 0Enh+p5RvZky3tprnBSxpYqQ5cm3pJGhbFaQHPrqTwXAf339+E70OAO7oYfHFbp7gM
	 Px881rRfaGbsUgZJY3A3SeGUUP6LeRNfmzeP+VADleEcPmy1oBN4vjAfb1Gc2AzSva
	 4tkKTT08iO30QELOnzZCesA9CKjDVl+NaloCHsNpwZjTFwZA2l3mi9Sov/Z6SIDO3q
	 P2SPTEDBE2f5w==
Date: Mon, 14 Sep 2026 22:36:43 -0700
Subject: [PATCHSET] xfs: LLM-inspired bug fixes, part 15
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a fifteenth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-15
---
Commits in this patchset:
 * xfs: always call xfs_qm_adjust_dqlimits during quotacheck repair
 * xfs: call xfs_dquot_set_prealloc_limits if we installed default rtb limits
 * xfs: fix rtgroup repair estimations
 * xfs: don't cross reference rmapbt with bitmaps if they're incomplete
 * xfs: don't let memory failures leak blocks and kill repairs
 * xfs: don't merge different file IO error types
 * xfs: fix blockgc group quota scanning when usrquota isn't enforced
 * xfs: fix cursor and pointer handling when recovering iunlink buckets
 * xfs: drop dquot flush lock when we can't find a buffer to flush
 * xfs: don't let hidden_space go negative in xfs_metafile_resv_init
 * xfs: fix wild memcpy access when formatting ondisk rtrefcount btree roots
---
 fs/xfs/scrub/trace.h                 |   12 +++++--
 fs/xfs/libxfs/xfs_metafile.c         |    8 ++---
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |    4 +-
 fs/xfs/scrub/newbt.c                 |    8 +++--
 fs/xfs/scrub/quotacheck_repair.c     |   55 +++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/repair.c                |   19 +++++++++++-
 fs/xfs/scrub/rmap.c                  |   20 +++++++++---
 fs/xfs/xfs_dquot.c                   |    8 ++++-
 fs/xfs/xfs_healthmon.c               |    4 ++
 fs/xfs/xfs_icache.c                  |    2 +
 fs/xfs/xfs_log_recover.c             |   13 +++++---
 fs/xfs/xfs_qm.c                      |   10 +++++-
 12 files changed, 130 insertions(+), 33 deletions(-)

