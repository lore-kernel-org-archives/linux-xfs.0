Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E7F42070
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346393; cv=none; b=bCM8rv3V7HaNoefjHslxsO55smNtVhGTitlwHbPfi8dud803TBXvtMCuP1+91rZIjLFbc5wZzOiWhD0FnIFa3LGyuIRyq2A1b2wxzguxJ7rx/POWdmnkSldlHwdtKytqnpmp6HgIpwFFtLyZRTZqzHc/Pz3Eiv7pJwjUOaWfIj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346393; c=relaxed/simple;
	bh=0TXaIqVR3XZrzh5DbpTkGfhqmzEYWLXFYUww/UJZTb8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UAWyNQGpCvYCHroHg3DbiNHHhPRLNzFMRuyec62vIXzvPyg5dANGHCcvSyR87B6GODLfsrJjh7iHSG0lVAdNCDjZnDWLLK26pdTjczs9xOx5RKaqpb5cuIHsRAsQvyrj0MVGR3dnjmIha9O5mmnhlofyio4hE0b8xyQGb1PuM5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g1ND9IKT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g1ND9IKT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F605C2BD11;
	Wed, 22 May 2024 02:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346392;
	bh=0TXaIqVR3XZrzh5DbpTkGfhqmzEYWLXFYUww/UJZTb8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g1ND9IKT5b2tBFQp9tS2j5JAs5h8Oj4OCMtKLTkUr44KyaEdE/wmkoYjjmZwXJ21g
	 FmNGF7UIQGmg1PaysTWVWtfw+qNWYYY4YXUD9ZTFyE2hozE4b9rmbkiePEhV8KisRg
	 Y8dpQxW0vWChr4eJ2rtcJjavoQRIctIxZTGhRzi0xclnqAbQYl+0YAoYBO5ZweNnQt
	 8fZsu6AuikCbMfNig9iqxV7MZPFpko1zEYuavVr17dx1E+xwJVTchihs4Tl/VMchoF
	 2J7rxWuRqDXX3VqtIBPyOgIxHiCrbTBsWnLkPH8F4WaB8Wphbo+6QmCbDddX1ffLw0
	 gIEYMLh2pKhgQ==
Date: Tue, 21 May 2024 19:53:11 -0700
Subject: [PATCH 017/111] xfs: report fs corruption errors to the health
 tracking system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634531966.2478931.6533467613128398929.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

