Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8AA1B0406;
	Wed, 12 Mar 2025 23:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741821015; cv=none; b=ETcrL6X1YA1twfT5qnjW0o/wpqHkQWgRclCNCzK4QtCi5Y3cmePGcqwUnGSmZEaFRafJcE8CtGligDXEh1jKPm882NES8kVixLxjF8uim2yCtPzdAkTpnzFHh8mJooERz+KXeGoYoHQPGano9vWF2QtPb+2+v3kfEc5kCXpAhIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741821015; c=relaxed/simple;
	bh=628Yg7HRHNU8WEXTG1C7sESkvQBQqRCzYDJEJcwSULM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AKy9xm7dyo0KBzpzVseuUzxOy8b75ZRwNm9KVnxP+2KIaAVzz27oZdurn2hK4thZ97oS/XxTcx8d5lXhzPsUlefiKp995bArF77ZQUdd9KkuGqfiQ6ST+QWsOoHvzPLpbl63PqMa0gJ+kQpXzyyeHRvsP0aKXMoN6hYQQi0bHLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=erujN11e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="erujN11e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2913C4CEDD;
	Wed, 12 Mar 2025 23:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741821015;
	bh=628Yg7HRHNU8WEXTG1C7sESkvQBQqRCzYDJEJcwSULM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=erujN11eg6vWEJADx8kSflp5gjG6yo+F7RkEJx3EKS2n2ThGs3NXP4QYr00hSSMzs
	 2GfJBWz29FB3Jb62jsz5a+AheRqTeFL+h5y0Z/8se1pJxeLJ0ZHTe7n31RuEFrtbtj
	 3EqoBc5rkNe5SweHHoLH1gfpdx6ZZ1BgyZCyCOH8mPs/0fozricf8ZiehtGyuako3l
	 DHL2vvim4anXj1t6FhaVwya7PFEEFuveEnkTMvxlIEm7OzPKM3AhQaSPBIBeQUC6ZD
	 52uyV5t4quQk/cn6cLbMCjAG/a0EmkJA6ZA4Fd9ok5ixvLM2FKZO/1z+AY4N/0UFsB
	 jn6dLKXOdvquw==
Date: Wed, 12 Mar 2025 16:10:13 -0700
Subject: [PATCHSET 1/3] fstests: test dumping fs directory trees
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <174182088682.1400513.386501106506158468.stgit@frogsfrogsfrogs>
In-Reply-To: <20250312230736.GS2803749@frogsfrogsfrogs>
References: <20250312230736.GS2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a functional test for recovering parts or entire filesystem
trees with xfs_db.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=rdump

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=rdump
---
Commits in this patchset:
 * xfs: test filesystem recovery with rdump
---
 tests/xfs/1895     |  153 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1895.out |    6 ++
 2 files changed, 159 insertions(+)
 create mode 100755 tests/xfs/1895
 create mode 100644 tests/xfs/1895.out

