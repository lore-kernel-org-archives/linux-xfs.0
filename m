Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2337C26ACB
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 05:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739944020; cv=none; b=mSITGJ4Kpe6x3P6lTKYPUIIfBpQM3PbjdaYGGkoD0hwTb5EPGIhjFtYY65vfrYPhe/WOQq/Y4qz+vfUJgnxOIEm8e8971C8B04/0chk5xrkePi0+geF1Y9wI2ADLdJQ+33bsUGBm++lDtUmpwTScBnciw8cteDVdptrlEX6EXGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739944020; c=relaxed/simple;
	bh=m/TRXXH/QORfP5Waen24LSo8h0rJFhLcL1nQFNKce/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uTyknlwANdenThGeIOifqMW0419yTg3gHJ2Pid/Ot59VXSnat25O2kB5ojo+t2f57NuX6R+fO6H0vDy1Q4KkMJqMUOn7WDEt/gCJNQ8ltr5eotfmxNHvjrBnhzaQl0957fecB4xanpTH4Ej8Uleh9nAt5xE/pOTT1/32KCv5wB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K34G4urc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K34G4urc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A9AC4CED1;
	Wed, 19 Feb 2025 05:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739944019;
	bh=m/TRXXH/QORfP5Waen24LSo8h0rJFhLcL1nQFNKce/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K34G4urcu/sLH8ssqJuZ6okPndRnjgwjyWcKBKXk9DXDCOrK1CgAF6yVVsbvPkDTQ
	 mQW7dcl0g3i6h5Nq/Gps/zQliOjhsjHkK9i1aOxPeMIVedlZxxeRxESbeVlren0dCv
	 x891Nv1Ex4VbaFWsax3ypTpZxUfBWBXmKwtmhAOVSUeN4TeRWh+6aymOa7msWqFi4l
	 kbp+TH98MxSPcbD4yeQN9m0ZFpk9+2iPmV3jwnhy9sBoDul10yqOT7E5s73RWihw99
	 JtAXOhLD4yhWTpCB1mpHRDwki+Y4SKNjfAPB/BszlBMivyvrOlDeNO8A/tzMqfDqAh
	 Wr8zUABsdFSiA==
Date: Tue, 18 Feb 2025 21:46:59 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: [PATCH v1.1 1/2] mkfs,xfs_repair: don't pass a daddr as the flags
 argument
Message-ID: <20250219054659.GO21808@frogsfrogsfrogs>
References: <20250219040813.GL21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219040813.GL21808@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

libxfs_buf_get_uncached doesn't take a daddr argument, so don't pass one
as the flags argument.

Cc: <linux-xfs@vger.kernel.org> # v6.13.0
Fixes: 0d7c490474e5e5 ("mkfs: format realtime groups")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
v1.1: drop the xfs_buf_set_addr change
---
 mkfs/xfs_mkfs.c |    3 +--
 repair/rt.c     |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f5556fcc4040ed..86bc9865b1071e 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4989,8 +4989,7 @@ write_rtsb(
 	}
 
 	error = -libxfs_buf_get_uncached(mp->m_rtdev_targp,
-				XFS_FSB_TO_BB(mp, 1), XFS_RTSB_DADDR,
-				&rtsb_bp);
+				XFS_FSB_TO_BB(mp, 1), 0, &rtsb_bp);
 	if (error) {
 		fprintf(stderr,
  _("%s: couldn't grab realtime superblock buffer\n"), progname);
diff --git a/repair/rt.c b/repair/rt.c
index 5ba04919bc3ccf..e0a4943ee3b766 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -616,7 +616,7 @@ rewrite_rtsb(
  _("couldn't grab primary sb to update realtime sb\n"));
 
 	error = -libxfs_buf_get_uncached(mp->m_rtdev_targp,
-			XFS_FSB_TO_BB(mp, 1), XFS_RTSB_DADDR, &rtsb_bp);
+			XFS_FSB_TO_BB(mp, 1), 0, &rtsb_bp);
 	if (error)
 		do_error(
  _("couldn't grab realtime superblock\n"));
