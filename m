Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1803012E1DE
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 22:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713391719; cv=none; b=oO2hG8L+XNlzyhvyNpqh7K2scO+GYPd7v9GdwMIpEyzxx3uxzg+3ILrwj9rwDeMjIAxHiVB1/7sj3+sTsyQyrZiNdNcsnyZKbO5u5UxR2jFlQy8zv+/SGGRRWYPST/2P0uRmX0faN4hzozZ63choDwUdujYR2BlEKZ+q5CERMLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713391719; c=relaxed/simple;
	bh=wOyAZpmUlLHO3QaP2On6ANpie8tka3U+cv4NgCYpUGw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=HRyyQcjxlBw6kQeKCUVkl5V13blBawhFUuoUNHo5ripQvvRUg1HIJHA2oVpW+7EkZtaPta79oYMIz4yt4II0H0bFrRVeln0IyHPwvacOzgVreC73XQj7gIi+meHal1w4re59qMJC6mDqPMcJGmamrXuQdCHdgTlmKCV1h/fMjUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EyNIJKXj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EyNIJKXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89312C072AA;
	Wed, 17 Apr 2024 22:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713391718;
	bh=wOyAZpmUlLHO3QaP2On6ANpie8tka3U+cv4NgCYpUGw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EyNIJKXjlPFwy5cT5Awu8Jz7QKMv7mYHIRsKpgcFMi6h6o5c8NAseFMbt6s7fOFWY
	 qsPKWpFQOF02+K3HJ5XlCDh2Jr8jIb5gJLGQJQ/X/ZzUcPIULKf6C0PDbVR7up3DHc
	 q02ZGlqCaUKux6xp5ccoZEAtEU2A0BuJhc3Cw64ipZxtjW84FCSj8CjAVsgbwXsOOc
	 yu7x9grd2cLuJ1NyeRSpYO/w1R1PYi3tMnxerHMQfnfymixmqJuAXMW1iBgkLXxe2b
	 PNd3hGejhL6He8gV+v6w8H+tE3gkV8X4kP6y22kDSLNMzF9YwvUjFPV47E1Z/Dr49J
	 cqEGd6Oqr6koQ==
Date: Wed, 17 Apr 2024 15:08:37 -0700
Subject: [GIT PULL 05/11] xfs_repair: faster btree bulkloading
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: bodonnel@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171339159902.1911630.14890230360619141823.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240417220440.GB11948@frogsfrogsfrogs>
References: <20240417220440.GB11948@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit a6e7d369929423b10df05d11dddd1dd9550e4f20:

xfs: remove conditional building of rt geometry validator functions (2024-04-17 14:06:27 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/repair-bulkload-faster-6.8_2024-04-17

for you to fetch changes up to 2f2e6b36a22c510964fa920b15726526aa102e2c:

xfs_repair: bulk load records into new btree blocks (2024-04-17 14:06:27 -0700)

----------------------------------------------------------------
xfs_repair: faster btree bulkloading [05/20]

Two improvements for xfs_repair: first, we adjust the btree bulk
loader's slack computation to match the kernel.  Second, we make the
bulk loader write as many records as w can per ->get_records call.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs_repair: adjust btree bulkloading slack computations to match online repair
xfs_repair: bulk load records into new btree blocks

repair/agbtree.c  | 161 ++++++++++++++++++++++++++++++------------------------
repair/bulkload.c |   9 +--
2 files changed, 95 insertions(+), 75 deletions(-)

