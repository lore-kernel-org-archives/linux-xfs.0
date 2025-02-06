Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB6A2417C2
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882653; cv=none; b=gTIDjQIRArbjdDLhL+eeWuaobz2eJhueZd2ey8NFd4czx5pFJUeFSqr8mDspeOcpQze/vDmMgYpNkTXYr8qObW7ZYoRNW1iRwgHdbMP1++JTffN+45Zma5ezgCwIe/Pn5oaZCPVkvcpS7IfLkwarmsCHRO448nRKuZ4Od2PXyUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882653; c=relaxed/simple;
	bh=/0ATUlKOBOUBlzUtNCIjajKYiEN1NsNdRHRo21rysmM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WVgUYbZOSItQLpA+OqBWFPsRnml7co0HnIj2E+sA3Z7Y1gEN7P0pqtGk3tlM95edWRSEbL17Gaeppm22m3gUOZzyhSCarp4FntvIa0phkN2/Q2dbi24w+0sLyYhV4yG71tKBZnJ/NcxfT0lfIe2uQFMV2NTZLLTvLQiH3e+v83g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NkMr1mIK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NkMr1mIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8401AC4CEDD;
	Thu,  6 Feb 2025 22:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882653;
	bh=/0ATUlKOBOUBlzUtNCIjajKYiEN1NsNdRHRo21rysmM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NkMr1mIKgWbffAR2Weg2WnBSn+VcC7WbAUuV6XMbj7HW4l7UJQpnc5McO7UKmGkKQ
	 IeZMKlADsEktI91ipYj8zQ+XSTUv8WeoTCH95dZJMmmEAdGuqOQWIlADK+wXMS4Ckh
	 gklnIF1zWdKp2+OwDmqQ+x1+bUWY+c4yp73EChcX5DVUgHOr1iB6FST3AbaQeq1lrr
	 vvd7ZTC89PmRuevHDXFHd//oLtqziJIq5/Vfz89JVWgHhGhB+3nXky/xcQMLYddnCl
	 nFT9+ouA3Z1t/7xzi8EVPrYoDeGb3RC6dOTFU62XvUEDT35mMjlLjYSQi0Add4HXIy
	 wBu4LTyZkjCVQ==
Date: Thu, 06 Feb 2025 14:57:33 -0800
Subject: [PATCH 03/22] libxfs: apply rt extent alignment constraints to CoW
 extsize hint
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088980.2741962.5884510369918809895.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The copy-on-write extent size hint is subject to the same alignment
constraints as the regular extent size hint.  Since we're in the process
of adding reflink (and therefore CoW) to the realtime device, we must
apply the same scattered rextsize alignment validation strategies to
both hints to deal with the possibility of rextsize changing.

Therefore, fix the inode validator to perform rextsize alignment checks
on regular realtime files, and to remove misaligned directory hints.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/logitem.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 7757259dfc5e42..062d6311b942ae 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -233,6 +233,20 @@ xfs_inode_item_precommit(
 	if (flags & XFS_ILOG_IVERSION)
 		flags = ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CORE);
 
+	/*
+	 * Inode verifiers do not check that the CoW extent size hint is an
+	 * integer multiple of the rt extent size on a directory with both
+	 * rtinherit and cowextsize flags set.  If we're logging a directory
+	 * that is misconfigured in this way, clear the hint.
+	 */
+	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
+	    (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) &&
+	    xfs_extlen_to_rtxmod(ip->i_mount, ip->i_cowextsize) > 0) {
+		ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
+		ip->i_cowextsize = 0;
+		flags |= XFS_ILOG_CORE;
+	}
+
 	if (!iip->ili_item.li_buf) {
 		struct xfs_buf	*bp;
 		int		error;

