Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A418B53365
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844342; cv=none; b=dJ36SEjJgbWNLOlSQajtv4rPJYeZhFxSrQA0e9NWevKB++rLxqKG1GKiYnX7KB19r0qGJOAZMCPLUSq/Wxh6W0bJlJAaZ3iGQwg4DGHb86uIFUnEoj9A7wcF0yeG+PupdC+iofdJjqBZZ904prIOh332uHIOrSFhCQQwOocRUo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844342; c=relaxed/simple;
	bh=2AgeSRU81XkPLw4M7tAUJo4WhqHPh+QGIZZLqMBjRe8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s89E0wq3N/DKdwcguFLC9h0htTNHdVGYUp1e8HrQ6PfEWSZrWqoBd1Mlod4sYW3rPoNdYZt//BmR04zJ74p5t4vdhyW7EQZ+xnGOlP+IJZW9r1SpW0jwJF19Kz1tzxPxZANwOr1jzLuGvRG7Qi3cLumoA75sFnOhWRle2rjj0pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LEkEHJsE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LEkEHJsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E769C4CECF;
	Tue,  5 Nov 2024 22:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844342;
	bh=2AgeSRU81XkPLw4M7tAUJo4WhqHPh+QGIZZLqMBjRe8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LEkEHJsERLk5nFwZVo2yn3u6FdQPOysjseZ4YxaCXreOAB39Em6BjfD9SZ7Dl7pPF
	 /rCysdSQc9ESFSYZl19oZiinBrkGQFw0loGLyHImcJggQjxqqb5Ow6y1+tCpBmqIBg
	 0q4Qg4lbzoVRlmk/jk6RTXZliwI//lQDXAATuYrOOmEK+a3CMsX8HDemaKjeQ+Z6eo
	 id8ZDU4K3gaCQ96LitfwlZrRc+lXL/Gq4uLbSUJajF9HOOe/RvpR2M/JmsNh2QSIBd
	 zMLNOrLtr3rGfSmLMcFYVq4XpDZeU8M+sLvh6vVayE+lqt2o1IbIAZn3+QFndq++w1
	 bgQSOs5FW0i8g==
Date: Tue, 05 Nov 2024 14:05:42 -0800
Subject: [PATCHSET v5.5 07/10] xfs: persist quota options with metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084399117.1873039.18256038294248428421.stgit@frogsfrogsfrogs>
In-Reply-To: <20241105215840.GK2386201@frogsfrogsfrogs>
References: <20241105215840.GK2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Store the quota files in the metadata directory tree instead of the
superblock.  Since we're introducing a new incompat feature flag, let's
also make the mount process bring up quotas in whatever state they were
when the filesystem was last unmounted, instead of requiring sysadmins
to remember that themselves.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir-quotas-6.13
---
Commits in this patchset:
 * xfs: refactor xfs_qm_destroy_quotainos
 * xfs: use metadir for quota inodes
 * xfs: scrub quota file metapaths
 * xfs: persist quota flags with metadir
---
 fs/xfs/libxfs/xfs_dquot_buf.c  |  190 ++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_fs.h         |    6 +
 fs/xfs/libxfs/xfs_quota_defs.h |   43 +++++++
 fs/xfs/libxfs/xfs_sb.c         |    1 
 fs/xfs/scrub/metapath.c        |   76 ++++++++++++
 fs/xfs/xfs_mount.c             |   15 ++
 fs/xfs/xfs_mount.h             |   21 +++
 fs/xfs/xfs_qm.c                |  250 +++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_qm_bhv.c            |   18 +++
 fs/xfs/xfs_quota.h             |    2 
 fs/xfs/xfs_super.c             |   25 ++++
 11 files changed, 586 insertions(+), 61 deletions(-)

