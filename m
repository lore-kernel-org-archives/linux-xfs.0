Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B29635E94F
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 06:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971227; cv=none; b=aWyZzASP5VmxwjOCZlNUi1Gq1bv3XgS6dEmet5XQicXSyHKRBzaoCDnFaiAQK1u9qJB0sD8bGgZGohfjipc54oZMtf7oFc4NviT++d+/Ngrr3HvF2ASpPEjOKyn4VfsUL2hydP0aWjvnnI5Kq1gCTRHXFXwZYbgseSAZal0lces=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971227; c=relaxed/simple;
	bh=JoREMZXZOMcFG5xfa2URKBn5n/0x2hW1z2+xWO5Hw78=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=kRcOUMc9yecGXWCVdXUlmTXuJlPl8oRlqBDSPxsW8vUkO86QotJPuFj+lmTZMde08Rf2tvnH6K4F+ghJqcoEqG7xUWiZXDoQDRrf0EglbOu67Oir0GqEM4G/iRBTgI6G9Usx3hRFAF1om/ezue2YBRof60TU7kQ0UgUmmwGKmCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kQYrTVO8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kQYrTVO8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5D6891F000FF;
	Mon, 21 Sep 2026 06:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971225;
	bh=1U2WgTyKOV3WmsfiZJOIK4CEbuxlo1CtwkxZeFgoFZE=;
	h=Date:Subject:From:To:Cc;
	b=kQYrTVO8TWfhdhLYVXDbjxEycoTEX50x02dUyd3dxCNAA9zJqph2MGEMJcwtlXqlh
	 qvx996nwHBe2aiaYDlGMhYHMaM63LdUeelzCGQwdz9KS5hKYs4Z1Fgrr6xT2AfK8Q0
	 NGI6YC0ce0f0oggKVfgxehoGEKUalFKkF7G+Zuu3mR8vlyHons6eUJ+G+yV3bCe+ZB
	 ef6hfAR5/bNkZ5Fcetng4nj+M+vaBu5pzBsnBn5474iNmyypPAy4B74aIFkzuJbqqQ
	 kUSd+kqlkCn4A+rFurWz2RsMqOvOdzuHRcHuekjYpMFcMWBsjjbiebb9eQZcz1b8vX
	 29asbw6E1akDA==
Date: Sun, 20 Sep 2026 23:13:44 -0700
Subject: [PATCHSET 2/2] xfsprogs: enable metadir by default
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178996057889.169776.13298686198868661581.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Metadata directory trees were added to the codebase two years ago, and
we dropped the EXPERIMENTAL tag almost a year ago.  We haven't gotten
any serious complaints about it in that year, so let's turn it on by
default.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=enable-metadir
---
Commits in this patchset:
 * mkfs: add config file for the 2026 LTS kernel
 * mkfs: enable metadata directory trees by default
---
 man/man8/mkfs.xfs.8.in |    6 +++++-
 mkfs/Makefile          |    3 ++-
 mkfs/lts_7.3.conf      |   29 +++++++++++++++++++++++++++++
 mkfs/xfs_mkfs.c        |    1 +
 4 files changed, 37 insertions(+), 2 deletions(-)
 create mode 100644 mkfs/lts_7.3.conf

