Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F35F8814;
	Tue, 18 Jun 2024 00:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671595; cv=none; b=OLILDfJfEgJKyRillexmCXQ7tj7qqCu+bjnJDFjqRqbmGupt/2hLAgu7RajlEdVpEqghjr93gQYWdksyoVlrbSz3GpAow7ZlrqJxngaREIc4iVX3oJ6dNNxDcegParMOzn/qTgmBcCEsDZSQUdfU5ZOscQ5t+GKf3tIABrrzQC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671595; c=relaxed/simple;
	bh=wf7R1ORnurTAZP9wWfMnUf2F6Fg4KJumz1Jn7j2fhcI=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=gMCAChfdERhfzkETsY1AA9gErrGS9jvKrO8dOM1dNGcUF32FDuCebPSIPaADoGz+Cs+jdQ4ISqbW8rY8se2WXoJzo8fAZX3WVgvGbAawkVLW6yna2f5sS9h2wriFjSWa1RFwAso9ePwtgQqNE3HiyAUk85otte1Z5P0vXvUwfuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gi0yZ0zJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gi0yZ0zJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C71C2BD10;
	Tue, 18 Jun 2024 00:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718671594;
	bh=wf7R1ORnurTAZP9wWfMnUf2F6Fg4KJumz1Jn7j2fhcI=;
	h=Date:Subject:From:To:Cc:From;
	b=gi0yZ0zJGJCJCXaBixmfiulmLmnIED3Y5NCqzVLR8U6g9tmD/UgHqFpKEarJXxgbD
	 lJ2pVdBNshU+WN53gtx93ecilQJvJcY6AkcnIrffuyVKFc6g5d+kmC4/zKGVD/sHq/
	 olCfkBSVd/ZU5cdmD7dAgxhJijKAiPi230RsGaPMjfafq24i/+tO8Bq+ZIQdWMlnrA
	 vuEMFFBNOzPSgWplZmyWr1cgmuKa5K/hKJiE/m+sK1rvMHIfW/jNhkP9x4g0TLOkOT
	 KLYsxW5NARWxH+Ozo9q598XyEg8kBmjCvoXOGvy/yHSkYeulP/5BiAAHik8bos6oB5
	 7xQndLZWVOYMQ==
Date: Mon, 17 Jun 2024 17:46:34 -0700
Subject: [PATCHSET v30.6 5/6] xfs_scrub: vectorize kernel calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org
Message-ID: <171867146683.794493.16529472298540078897.stgit@frogsfrogsfrogs>
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

Create a vectorized version of the metadata scrub and repair ioctl, and
adapt xfs_scrub to use that.  This is an experiment to measure overhead
and to try refactoring xfs_scrub.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=vectorized-scrub

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=vectorized-scrub

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=vectorized-scrub
---
Commits in this patchset:
 * xfs/122: update for vectored scrub
---
 tests/xfs/122.out |    2 ++
 1 file changed, 2 insertions(+)

