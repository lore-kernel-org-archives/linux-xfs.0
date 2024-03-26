Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288311D53C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423971; cv=none; b=iGjlVo+hfLusLYJLoCqQNbuOv4QojcRyYbi9VgXJmEOwaJoeysd+bjNqSLqGJuFzwLKGp7CW8bAgLXvPYXmpB9Q1HWkqKrY6aus4bTPvelJHFvc9jn3Zvx1EdlFysuiOFrgul0OZISXd98NlfpiXdcChxQ+WUgl+PkqTPS96FHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423971; c=relaxed/simple;
	bh=7ByFAT0l1H9nIO3/PQeWkc0epVP+Z9xz2UsOkhN65gE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ujk79ZGZ7N3TS5/vgdS+Kx6P6kt5ojbz0LT8VPi2copmVyf88XA/YV8YHwBY3LNrGnqZ+Cu2XV0VhBz3kDA+pbZX2j9ybLUrSysu5dbOwbV6I3oyzU4HNR51yL+4afrmrMrOlsyuniPwJS661Dh9djKIh1fZHoHTfH7E0hvRDvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JKUAH7L3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JKUAH7L3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DB0C433F1;
	Tue, 26 Mar 2024 03:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423971;
	bh=7ByFAT0l1H9nIO3/PQeWkc0epVP+Z9xz2UsOkhN65gE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JKUAH7L3qk4qGyUcCiULuydbyUh4StcXY+GDst3R9y4XDFBwTSK87H3aF5e6JqwpG
	 Rb6d+mhPPAq1bJigpmTpwLl5tjPfddZhGHTQHuGKpnS6WgPzz39aqwo4iUZK+1zfH+
	 T5PCuRw8S8I4Q1OV59UeFnAj+zB6q3nYcbirbiH117rbm4/32gTGW4JftIkOKA8t4u
	 iRpgIkSgaG/MpAklgqhWEB13HFNXV+BnfyTpTZnZxC2eVr5mQTt2zjFyEp2l9LKN2m
	 mJw6y1fMZbkpgVg9Us+uNEbZPQt1UloGXJiAqTNBEXAPf35EXGQlh/29kYAhNINLCc
	 hKQ6HZ9H7zJoQ==
Date: Mon, 25 Mar 2024 20:32:50 -0700
Subject: [PATCH 017/110] xfs: report fs corruption errors to the health
 tracking system
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131630.2215168.16267857064153117222.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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
index 8cea0c1500b4..26339171ff82 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -728,3 +728,4 @@ xfs_fs_mark_healthy(
 }
 
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo) { }
+void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask) { }
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 86024ddfd74a..e001ac11ca85 100644
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

