Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123B3C129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZeMmh6gW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84016C433C8;
	Sun, 31 Dec 2023 22:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060701;
	bh=HPkw+/7QCulqDcxFKWT3IBQu0FqMMdC/JuwbYyU3yI4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZeMmh6gWXEPQhC+MWMQO7tk+Jl61JadqoyZoM6i7rey62ixpJ6VmDfJrw+gITWcqg
	 QLLnnVDIAxqiEx1npB7BDbz80Ypguu0Ei3dCeCg0JxqlUaNK+9RlJ/FYyDYSMEW5yI
	 k0+KeA5Ngd4IgPmRCzWWcmh1IHK+g5csjDzUFqc3BoBYvgJ2kAHOXPzPh9eVAPWK2F
	 WLljv9IptO2LOiT4d5TmMhzaL+JppBiV81TgzKMEh/Wq/wyHyTguOtH4X7v6DrTela
	 IGYZ2Jyry8i6kaTUhxRt6pwtO/TM0y0JAet9j6pXGIgqX9zECwstaPRhjepZWywovd
	 HxAy9Y4QueTsA==
Date: Sun, 31 Dec 2023 14:11:40 -0800
Subject: [PATCH 2/9] xfs: report fs corruption errors to the health tracking
 system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404991978.1794070.10725651203316707883.stgit@frogsfrogsfrogs>
In-Reply-To: <170404991943.1794070.7853125417143732405.stgit@frogsfrogsfrogs>
References: <170404991943.1794070.7853125417143732405.stgit@frogsfrogsfrogs>
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
 libxfs/util.c   |    1 +
 libxfs/xfs_ag.c |    1 +
 2 files changed, 2 insertions(+)


diff --git a/libxfs/util.c b/libxfs/util.c
index e01edf0202d..931cb78eaef 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -728,3 +728,4 @@ xfs_fs_mark_healthy(
 }
 
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo) { }
+void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask) { }
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index bdb8a08bbea..9e638413df4 100644
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

