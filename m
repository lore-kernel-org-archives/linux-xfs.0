Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FBF2582
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 00:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736987798; cv=none; b=aBndfysS/btT5nx0s4rX6yfQ+9r09iutMB+zaO9NR3LfUbORPPEUHqGl7RwjmgI2BfzWNKDQeebbSWjuQ3qvoOnLuikToblDOTCbUflhMyl0QlJfaVpiWzIz5AlxxltWWSz91DlAOLE5q0Pk3UE7XHQzUdyg68ReAXE7HLPQndY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736987798; c=relaxed/simple;
	bh=hBGpWIySb9R19sO8aty/wrviogHZNB0OsrKT3/RcYIw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=KrOTLtey4RGfWfPw8QaFJo2IoOB3ieM+uoE23DtL/1ByZbfA2lI/3LZAhb4KrQ/1pEIEKWuXRhPfJk20/ap6FmDDIX4zefpHftSDtM6dEL7mNSzwAHAjMaZa72oxvfdsTuIYIQtuelgGm2y6Xkz8a1nxjM1gGF0IbNldJETQ94o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZsvCfu68; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZsvCfu68"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC6AC4CED1;
	Thu, 16 Jan 2025 00:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736987798;
	bh=hBGpWIySb9R19sO8aty/wrviogHZNB0OsrKT3/RcYIw=;
	h=Date:From:To:Cc:Subject:From;
	b=ZsvCfu68Vw43Vf0EUcrSyBNaKJTcLupu1QQuWzel2evVKcDsrHPr/PrxLeb3A+GL6
	 D2/1lzvbwpPw/EVUPekj4WbitlDF1mN8OGpYcdDbfR0KWVlTnAn3DM98JjdJQItsaa
	 rlMTGdr39MkKoLqS9bDplmx13/oLiaPYKy5elq3vC8ySBhXnmaSDehG1NA3wIRju7D
	 ePmYwORFamFaW8OtVhfKao+TGkrAzkA2pwNomr6nyOCHqgoQuGDHv52drDhaOjuSNi
	 urU9UQnmqp4rSUfDrKvECwUGHoWiyFU0XWKh9pa3ttlhUccEo8fY7CNZXfg8sZJXqj
	 EM26euNCSUDUQ==
Date: Wed, 15 Jan 2025 16:36:37 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: [PATCH] xfs: fix data fork format filtering during inode repair
Message-ID: <20250116003637.GF3566461@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Coverity noticed that xrep_dinode_bad_metabt_fork never runs because
XFS_DINODE_FMT_META_BTREE is always filtered out in the mode selection
switch of xrep_dinode_check_dfork.

Metadata btrees are allowed only in the data forks of regular files, so
add this case explicitly.  I guess this got fubard during a refactoring
prior to 6.13 and I didn't notice until now. :/

Coverity-id: 1617714
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/inode_repair.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index c8d17dd4fc3246..4299063ffe8749 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1057,9 +1057,17 @@ xrep_dinode_check_dfork(
 			return true;
 		break;
 	case S_IFREG:
-		if (fmt == XFS_DINODE_FMT_LOCAL)
+		switch (fmt) {
+		case XFS_DINODE_FMT_LOCAL:
 			return true;
-		fallthrough;
+		case XFS_DINODE_FMT_EXTENTS:
+		case XFS_DINODE_FMT_BTREE:
+		case XFS_DINODE_FMT_META_BTREE:
+			break;
+		default:
+			return true;
+		}
+		break;
 	case S_IFLNK:
 	case S_IFDIR:
 		switch (fmt) {
