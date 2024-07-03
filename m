Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EB717F51A
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 21:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720042853; cv=none; b=PcttPFkmxgSp6nJ957x0e+tNX9VQ1k8akUjnS4P5YsR+WQcbLv4uvh4OpNNvHtjIfULqFxI/fGk3juH5ZEOPq4W1Cdz3ypjRrh7hYG+RixyfY9JRMCVirsjb30cyUbVWQ58JFzUSLOXFJaiMf18dvjm9Aa9NWtVT2eJ15qmRBkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720042853; c=relaxed/simple;
	bh=LnN1HeQ32gUw6SOOcYF/Q3EfcGRpcRpswATEhn2UGkw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=QRh3+FHHmyiS/WJLdWL/tYEbNAefXTEsbpngTx9Tr1bVIZA5ExL8AFiHYecVkWVOG22S8cUbMH69GpTZYVVme3fEpWm76iYRIrAQe5aILjyeTBIFuH1mqY1J7kjI1wecjqG3roYAEEn7XLWAftQOcaWhiCOvjI9JiUD1LjHynaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GrNMJkcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GrNMJkcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E24C2BD10;
	Wed,  3 Jul 2024 21:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720042852;
	bh=LnN1HeQ32gUw6SOOcYF/Q3EfcGRpcRpswATEhn2UGkw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GrNMJkcF4eG0zNN6BlEH+RgpaW01AuGziAauSCSemQR6OXbtPHbfrgQdcQ/P9M6fW
	 oF2Kt0DXnS2siPRv8D5aSTMv4jCp6fYw3TAqrzBpCrROLJh5XOMP/qSHZbs60d3NWd
	 D+yvtFjDtK7VUHoHmWLy1CRklv5Q7JWuNoYMqjfvst0wBBi70MHqOEZwD87g5yALiN
	 5D1q/v7qCuMtOlVYVTgQkswXqRQpMKM+zyii4uzi3onFfmLvM/oYEnU3zE8DDywFVo
	 z4rjToi7I72fJCot0aFGo5oWmJzfta/gLc4Tu1C+cLh0pJB3k9yBceLDEQVEST6e2h
	 xdeH95M1tDUSg==
Date: Wed, 03 Jul 2024 14:40:52 -0700
Subject: [GIT PULL 3/4] xfs: rmap log intent cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172004279470.3366224.8258582233442951272.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240703211310.GJ612460@frogsfrogsfrogs>
References: <20240703211310.GJ612460@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.11-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 84a3c1576c5aade32170fae6c61d51bd2d16010f:

xfs: move xfs_extent_free_defer_add to xfs_extfree_item.c (2024-07-02 11:37:03 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/rmap-intent-cleanups-6.11_2024-07-02

for you to fetch changes up to ea7b0820d960d5a3ee72bc67cbd8b5d47c67aa4c:

xfs: move xfs_rmap_update_defer_add to xfs_rmap_item.c (2024-07-02 11:37:05 -0700)

----------------------------------------------------------------
xfs: rmap log intent cleanups [v3.0 3/4]

This series cleans up the rmap intent code before we start adding
support for realtime devices.  Similar to previous intent cleanup
patchsets, we start transforming the tracepoints so that the data
extraction are done inside the tracepoint code, and then we start
passing the intent itself to the _finish_one function.  This reduces the
boxing and unboxing of parameters.

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (4):
xfs: add a ri_entry helper
xfs: reuse xfs_rmap_update_cancel_item
xfs: don't bother calling xfs_rmap_finish_one_cleanup in xfs_rmap_finish_one
xfs: simplify usage of the rcur local variable in xfs_rmap_finish_one

Darrick J. Wong (5):
xfs: give rmap btree cursor error tracepoints their own class
xfs: pass btree cursors to rmap btree tracepoints
xfs: clean up rmap log intent item tracepoint callsites
xfs: remove xfs_trans_set_rmap_flags
xfs: move xfs_rmap_update_defer_add to xfs_rmap_item.c

fs/xfs/libxfs/xfs_rmap.c | 268 ++++++++++++++++-------------------------------
fs/xfs/libxfs/xfs_rmap.h |  15 ++-
fs/xfs/xfs_rmap_item.c   | 148 +++++++++++++-------------
fs/xfs/xfs_rmap_item.h   |   4 +
fs/xfs/xfs_trace.c       |   1 +
fs/xfs/xfs_trace.h       | 198 +++++++++++++++++++++++-----------
6 files changed, 321 insertions(+), 313 deletions(-)

