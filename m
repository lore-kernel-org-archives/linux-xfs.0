Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230E97462;
	Mon, 23 Dec 2024 22:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994350; cv=none; b=DoMdmxL9iWvg1qbJ8oEKuwVWvKwwKYje9i5ZIqWJu9Jw1dlmH0GhbD8SyB21wKkrWVxuCnUj0Ur58ZBHpT/4xunbHtt3DkrQfvtmYc33Mpvk+cnL3XmaVTyKMuHV58C6ny3C0Fozgv4g8F1VJNCw9PWLdBX4WeXdbsTBv+otpZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994350; c=relaxed/simple;
	bh=PiEDJmRgJ7E0oJScUKnekyqnsf1u7h8/HbTR1w56YKw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZL+pTfSNIMR3rgQWPcX/7w1gQQ8Pq7HdPkbgzUzbGqmHSoBULskjH6Ar525oG/rORlDnXJV/PCQWLGVwhZcvuktdanpvE/oZaEeEjEdMRpuLeEs9c+R3Vv9hgg41BlOTXTkSeteGJDgK33NFtGQu/LngojjgdkUJeZAtk6dM4c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NWWVJUha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NWWVJUha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB35C4CED3;
	Mon, 23 Dec 2024 22:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994349;
	bh=PiEDJmRgJ7E0oJScUKnekyqnsf1u7h8/HbTR1w56YKw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NWWVJUhalsKNqqWUIwMjYkPjAF9vyfLL1QGSCAggTGDTC6sNE3N0AhVd/twhE+65Y
	 PQ0r/EQAmcy7WxpthT+ViQk5WNvfWBciyVM1Ze61aR7DQlmqM4LftWA4MFaXlN2+RX
	 0zSmX51Q0FBTVvABvQUMc19+FRo8KcAQSsOKsUwFR2BtIu6XM6mCVEvosHixLWqO7a
	 XGWuKVJM0kP2mP/MDaCGpjZKTkD9qr0oVEY4ACRl9kjcyMHcp4i6t9TNRbCo8qfsqx
	 ZkDsgDZuYnNjk9M/2crUSATtudW9sLRSSEnWysh5eqpyRfYW9rGpWb3fH50AxRw28r
	 dEyBhSoWF9mTQ==
Date: Mon, 23 Dec 2024 14:52:28 -0800
Subject: [PATCHSET 1/5] xfs: bug fixes for 6.13
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, eflorac@intellique.com,
 syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com,
 linux-xfs@vger.kernel.org
Message-ID: <173499417129.2379546.10223550496728939171.stgit@frogsfrogsfrogs>
In-Reply-To: <20241223224906.GS6174@frogsfrogsfrogs>
References: <20241223224906.GS6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Bug fixes for 6.13.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-6.13-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfs-6.13-fixes
---
Commits in this patchset:
 * xfs: don't over-report free space or inodes in statvfs
 * xfs: release the dquot buf outside of qli_lock
---
 fs/xfs/xfs_dquot.c  |   12 ++++++++----
 fs/xfs/xfs_qm_bhv.c |   27 +++++++++++++++++----------
 2 files changed, 25 insertions(+), 14 deletions(-)

