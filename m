Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4343138E12B
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 19:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783021331; cv=none; b=Yz/f2OXhHen/AUf/r5aFLuJaJUQ0WimibZiZFhA/9B7UyXv+x4AaJc9i3zVm36YT86H2cw5F8YfOxcv0XAZ+cWdP1P+Za2dDelm1z/7o4hDasRet/9necDNqwxeQqnngKSW/BgSo684tCnFAyDZeIf9k6RY4yaLXEmvQEd0mpK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783021331; c=relaxed/simple;
	bh=G6MAMJGtgqa8+W9KvlrAup+p2/45cd/QMIiRnNm3FO0=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=oTTqJ0goyrK48R9gml4PvGk6UKPHv7tpsCpQmLvatrpGBPNd+9ecpEeeFhFS38tYMpLQpBX4xb6sab37Vj5GzUtNYvyp/wn+1JjnexMmMBvcmoCFRq+vkTntF7F/rFjX63UqSHVM8SkW2HyDF7Un5op3UiTpi+alOvXqhIijfds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DQc6xKNN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DQc6xKNN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D25D21F000E9;
	Thu,  2 Jul 2026 19:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783021329;
	bh=0NQDRdvLTY0kfF+8mL/JcGUNGKR5tvimnFbu1EYnL2o=;
	h=Date:Subject:From:To:Cc;
	b=DQc6xKNNNVFq9Cu8BOJKmDmBk594pEC/QgvbjR7lC8IavfJ7J+OBlKEND2Msq46HA
	 WGpkAQe0ZhDGpvoGOXpa4Homq2eJxPKW7f5YCKsBJtG3ejs23SmDlq+/BVaI1ndhuS
	 otxsL2L1lPsR9QG9sY42Ff/BdXb0VLVdjhPaKDp+8gJH0NBMu0nlj9XpkzYTf/eUOM
	 3M1jO1nWhVn2o0NTkO0I4Xn54klA1+k2iJH9PFjJnLIw8BaeKfYMMTaur3afclJvvb
	 4+e15n8AakihB6VrCaFRwCNUuc7nI5eUfmFZxkRvo9kLPM8I+1jJjgcv6R0TMRdkVV
	 /pbQaN87v+igw==
Date: Thu, 02 Jul 2026 12:42:09 -0700
Subject: [GIT PULL 3/3] xfs_scrub: codex-inspired bug fixes, part 5
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178302114913.828394.9290073519402547866.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 7.1-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 8c6bf6721ac440c806d5da0d0fc93ec7ccf98da1:

mkfs: PQUOTA shouldn't conflict with GQNOENFORCE (2026-07-02 12:38:24 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-codex-fixes5_2026-07-02

for you to fetch changes up to 892743f0f955427a89a911b96baa998cd7b549b8:

xfs_scrub: fix spacemap scan for internal rt devices (2026-07-02 12:38:24 -0700)

----------------------------------------------------------------
xfs_scrub: codex-inspired bug fixes, part 5 [3/7]

Here's a fifth batch of xfs_scrub fixes resulting from Codex reviews.

With a bit of luck, this should all go splendidly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
xfs_scrub: fix spacemap scan for internal rt devices

scrub/spacemap.c | 13 +++++++++++++
1 file changed, 13 insertions(+)

