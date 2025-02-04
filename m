Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948E2166F32;
	Tue,  4 Feb 2025 18:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738695076; cv=none; b=nhyvwmGVGcF1JpWb3aNJtWiWIQkIwjeWKndaDEoaQhg/AAo0gsx9lrfp5wOgXppYu/PSSQi0oM8ckx8nJly5WmKHhx3oifhnKtWdPvO6LXWG7DpCiVVMsBwqndTI+S891bsLtokC61EURATWXmQJZjBybTUkYS4JHn3S+Usrzd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738695076; c=relaxed/simple;
	bh=3HW/pOuhZFkHzfwfzmG5ZFGgRPQsIG8kpmUN1xyoasc=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=nTVvU55NsHWLM/Le/dJ57EIFPj0ZVDnAsu65i0mhUcGKGrUwQWwJphlC0aQxhq7AvqLYQfOhCDnaQIjfYbdO4yzhzmr8Dds/ud714gqFLODxmLyzECAbz+yid0ouxXfGRSmVHuB8Mps5mj9iJ2Lqybm008vnAGuWT8OCwq7hTO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WloXzMUT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WloXzMUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13A0C4CEDF;
	Tue,  4 Feb 2025 18:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738695076;
	bh=3HW/pOuhZFkHzfwfzmG5ZFGgRPQsIG8kpmUN1xyoasc=;
	h=Date:Subject:From:To:Cc:From;
	b=WloXzMUT48Qk7rGPd8o92A3i9hhouEyZP2FEd0V8N62gePBFxRXtvaRVhaJZEERS+
	 A1Drkc3K2Y6ESLU7qSFvdCHWjvtjIt03vkmX8T2DJhaM2tcg02zZ2R1NQ1NCwhldNH
	 pm3jatY/w+6eMJgqzmMyTE9Yjjmt75Rq/yQYVCJIRdF50NQxCvcqor3sXnFgG7jnIp
	 WMXYFOQ7HijTqGCmm7bcx4cvO3PQWqwcL5TigxzPvByB+56dIWuHjgDgotL+xt1hl4
	 wmrz0o9RjJpP4VuwKgzvHm/871hqd1f4jCFrfKDfGgUk/qe0jfu3dVLbwBzjo+ugFT
	 PfBBSpjbQeSfQ==
Date: Tue, 04 Feb 2025 10:51:15 -0800
Subject: [PATCHSET RFC 6.12] xfs: bug fixes for 6.12.y LTS
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, xfs-stable@lists.linux.dev, linux-xfs@vger.kernel.org
Cc: syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com,
 eflorac@intellique.com, hch@lst.de, cem@kernel.org, stable@vger.kernel.org
Message-ID: <173869499323.410229.9898612619797978336.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a bunch of bespoke hand-ported bug fixes for 6.12 LTS.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=next-6.12.y
---
Commits in this patchset:
 * xfs: avoid nested calls to __xfs_trans_commit
 * xfs: don't lose solo superblock counter update transactions
 * xfs: don't lose solo dquot update transactions
 * xfs: separate dquot buffer reads from xfs_dqflush
 * xfs: clean up log item accesses in xfs_qm_dqflush{,_done}
 * xfs: attach dquot buffer to dquot log item buffer
 * xfs: convert quotacheck to attach dquot buffers
 * xfs: don't over-report free space or inodes in statvfs
 * xfs: release the dquot buf outside of qli_lock
 * xfs: lock dquot buffer before detaching dquot from b_li_list
---
 fs/xfs/xfs_dquot.c       |  199 +++++++++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_dquot.h       |    6 +
 fs/xfs/xfs_dquot_item.c  |   51 +++++++++---
 fs/xfs/xfs_dquot_item.h  |    7 ++
 fs/xfs/xfs_qm.c          |   48 +++++++++--
 fs/xfs/xfs_qm_bhv.c      |   27 ++++--
 fs/xfs/xfs_quota.h       |    7 +-
 fs/xfs/xfs_trans.c       |   39 +++++----
 fs/xfs/xfs_trans_ail.c   |    2 
 fs/xfs/xfs_trans_dquot.c |   31 ++++++-
 10 files changed, 328 insertions(+), 89 deletions(-)

