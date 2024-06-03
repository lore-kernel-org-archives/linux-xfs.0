Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF3E127B62
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440989; cv=none; b=MouqGk5YhObDjjhpIhjkSxeDKK+DkSzdpzffEue0n72eio+Tz49w+dDLLIAg4rXxZIwxlOlscUBpZg7q6bj6lRHK4KWYTbtbJJruMlULo4JSK0Q/flpXR/CmBZWHNe+wzwoQJAHsMLBfof5Ck9wV62QZRuK17HBcfCZjidmspc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440989; c=relaxed/simple;
	bh=jnYbNgg12sRx3GV5IpOb+hbdUJF3g0fTVg2Zbt5hkD4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KVUFAsGyNjsTsRt0NReC516KL9jZYMdNGYASPjb7yMyosQGderyxoPfFv3qi5LgSjNKZ84T321UK3PgJcHYV3rl4Q4lGuN1NVSdedU+/x0niziBs5CLKlIDP0Ntz4EBF5Giww7OtbAG+mSQ7YMouNVlDfTtEOJFKC6S+TfY6rIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UJENkNCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UJENkNCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCFEC32786;
	Mon,  3 Jun 2024 18:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440989;
	bh=jnYbNgg12sRx3GV5IpOb+hbdUJF3g0fTVg2Zbt5hkD4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UJENkNCokr5OqmBjIMRWOm1tUdZD/HvKKQkapitL1DdHiNZiiOFb2yPpl86wL0XBW
	 n0I8m5QeInW8mfOwoPAbbjYFAps0Z19tWbfY3nRQNBiKlpybRFFl/vpDp2A+wZUB2m
	 0l7muaisFU/lUH5NQcc56WTCEU9vHc1UkvisgtYlcvdtGQnCfXCVDg2d64u1O8oShe
	 u08mBrJt4ay5rQVbIaAQRwY+IdvLm8Trqg9Xw+jfif2bSu0KfwKir0KeH2z+zLQua+
	 WwzmOgNVi95vwjT90sxAqSuuZXNCXLk4UzqvqT45pH9QoaNzyN9Si+a9+p3QqEg4om
	 pT4XSIKPcaufQ==
Date: Mon, 03 Jun 2024 11:56:29 -0700
Subject: [PATCH 017/111] xfs: report fs corruption errors to the health
 tracking system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039623.1443973.3743432359823421276.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 50645ce8822d23ae3e002d3bee775fa8c315f957

Whenever we encounter corrupt fs metadata, we should report that to the
health monitoring system for later reporting.  A convenient program for
identifying places to insert xfs_*_mark_sick calls is as follows:

#!/bin/bash

# Detect missing calls to xfs_*_mark_sick

filter=cat
tty -s && filter=less

git grep -B3 EFSCORRUPTED fs/xfs/*.[ch] fs/xfs/libxfs/*.[ch] fs/xfs/scrub/*.[ch] | awk '
BEGIN {
ignore = 0;
lineno = 0;
delete lines;
}
{
if ($0 == "--") {
if (!ignore) {
for (i = 0; i < lineno; i++) {
print(lines[i]);
}
printf("--\n");
}
delete lines;
lineno = 0;
ignore = 0;
} else if ($0 ~ /mark_sick/) {
ignore = 1;
} else if ($0 ~ /if .fa/) {
ignore = 1;
} else if ($0 ~ /failaddr/) {
ignore = 1;
} else if ($0 ~ /_verifier_error/) {
ignore = 1;
} else if ($0 ~ /^ \* .*EFSCORRUPTED/) {
ignore = 1;
} else if ($0 ~ /== -EFSCORRUPTED/) {
ignore = 1;
} else if ($0 ~ /!= -EFSCORRUPTED/) {
ignore = 1;
} else {
lines[lineno++] = $0;
}
}
' | $filter

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/util.c   |    1 +
 libxfs/xfs_ag.c |    1 +
 2 files changed, 2 insertions(+)


diff --git a/libxfs/util.c b/libxfs/util.c
index 8cea0c150..26339171f 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -728,3 +728,4 @@ xfs_fs_mark_healthy(
 }
 
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo) { }
+void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask) { }
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 86024ddfd..e001ac11c 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -215,6 +215,7 @@ xfs_initialize_perag_data(
 	 */
 	if (fdblocks > sbp->sb_dblocks || ifree > ialloc) {
 		xfs_alert(mp, "AGF corruption. Please run xfs_repair.");
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
 		error = -EFSCORRUPTED;
 		goto out;
 	}

