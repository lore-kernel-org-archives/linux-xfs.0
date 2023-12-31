Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED45BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u2zTF/f7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4C1C433C8;
	Sun, 31 Dec 2023 20:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053411;
	bh=bMWi8LZ0lgRGqlnzuZcyekvOH5cOvoxzeJ6FbxX89Dk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u2zTF/f7CIBP5KO0ZvZyLhEiqTFKzFMv2pwStdC8/Lz/tzXBJdmmawGrNcyr1Puzo
	 HG0ld4r21BZu6rvFqP4mwxhVRGMewwuF/CISeWisXEpYG+1QXcT3YSCQeIMwn8ovm1
	 0NfcoAwz4InYFq5YsWkGju5Q9k6zl4e9IhF3oD60fCqBvKt9QV/zpdbnl0dJvfqJP0
	 EDqcKFHiBo+Y9dCtGck/H0ZwhNNmCenKwH/edh73NgOphzJyD9YdMJ+hzR/5q6sUWW
	 qbcYVHs8Wku+7hNn8AT1G79FzDJd7IpqNSZA8SwaMyXG3qQRyZkKfsv572+tyK0UIB
	 vdxUwW7iBFY4g==
Date: Sun, 31 Dec 2023 12:10:10 -0800
Subject: [PATCH 02/11] xfs: report fs corruption errors to the health tracking
 system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404828312.1748329.16461521590521058147.stgit@frogsfrogsfrogs>
In-Reply-To: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
References: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_ag.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index f62ff125a50ac..b857fc54562a7 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -217,6 +217,7 @@ xfs_initialize_perag_data(
 	 */
 	if (fdblocks > sbp->sb_dblocks || ifree > ialloc) {
 		xfs_alert(mp, "AGF corruption. Please run xfs_repair.");
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
 		error = -EFSCORRUPTED;
 		goto out;
 	}

