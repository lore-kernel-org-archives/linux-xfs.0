Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46BC188596
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992970; cv=none; b=r553XFpgWAy01gqKVKuyKbxmqV6XAXatP1M7UXfn3uNyEdhkRyTgBuDX6lX/zH9+F5sMG6Qrppzij8YgsqEfq0+O7NtvBuWoLiHKnApCulZWB4hzjHIBuJxBXtdwTOc0j/S0iqt9Lia56Q1PQdeDp7MFuVA7nTCuHN4BgO+u5tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992970; c=relaxed/simple;
	bh=9ns8deQX/6eCS6InGJY/Me5fpjqT2bzVz1nsGIlJzOo=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=Bn726w7G5cQAoqyQGjYIS2zMGGUYuUpEWs99krMvAxBjnT8cK6MCVyqQSdqu1zPxzylJAkMCC6IEfd8pbkIPlnQDTSOUwACKaWh6wbFMSOt70Pqxw4gbJZP/BrYAZddgNk3jmeV25+ahAR6EzlmoZin6J7VVon5mRF6W9qtLWeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZ7YBu1R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZ7YBu1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC74C4CED3;
	Mon, 23 Dec 2024 22:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992969;
	bh=9ns8deQX/6eCS6InGJY/Me5fpjqT2bzVz1nsGIlJzOo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AZ7YBu1RsV9hvN8yccANJWMhVT8y7LmtmNL9b6J+btlz4hUMGUF52xBG22ZSUQr0+
	 CWar6D8PXxd+VlOZp2mnUMuZTKJ1f0djJ9dtmzjTElfcunHtn2DaOHmSyN2sneBSFK
	 QYyp9uX4nvuVZgOyGmGD7gvyM3B3yvHVhFQwIMnGJg29hJ+KwjY1uaJt6nOCmFh00I
	 TmJQkyKQ+t0VpWCmyaMz7PE/Pb1JU/8ed1pkiO1YD31SAeF8lTMgphS2Q+Wg389Jh+
	 /eCXNwXSxnvEQamE6+qH0beOsfaDdn2oxT4zYFbCGVIvxsV7vMMel2tCA2f7fJmpPf
	 C8cEMMSomYLFA==
Date: Mon, 23 Dec 2024 14:29:29 -0800
Subject: [GIT PULL 8/8] xfsprogs: enable quota for realtime volumes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498954736.2301496.15859444898047960022.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241223212904.GQ6174@frogsfrogsfrogs>
References: <20241223212904.GQ6174@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.11-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 6ec6c38c96d4427f12e214181a1bb8547fb4c355:

mkfs: add quota flags when setting up filesystem (2024-12-23 13:05:17 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/realtime-quotas_2024-12-23

for you to fetch changes up to c9b7f40736bde7633a84f40cd56cf707cda9925e:

mkfs: enable rt quota options (2024-12-23 13:05:17 -0800)

----------------------------------------------------------------
xfsprogs: enable quota for realtime volumes [v6.2 08/23]

At some point, I realized that I've refactored enough of the quota code
in XFS that I should evaluate whether or not quota actually works on
realtime volumes.  It turns out that it nearly works: the only broken
pieces are chown and delayed allocation, and reporting of project
quotas in the statvfs output for projinherit+rtinherit directories.

Fix these things and we can have realtime quotas again after 20 years.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs_quota: report warning limits for realtime space quotas
mkfs: enable rt quota options

include/xqm.h   | 5 ++++-
mkfs/xfs_mkfs.c | 6 ------
quota/state.c   | 1 +
3 files changed, 5 insertions(+), 7 deletions(-)

