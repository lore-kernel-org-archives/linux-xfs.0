Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30AF13A3E0
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441083; cv=none; b=Qudtv5I8bgpFHePmEQWiwdOB3qjUEkdR7m5LYbOpObQO7d3W+Zt2cPS/BLjgOZGojv62NCFhw14rUcsoG0uQqtopnQd2i7FJb/56i3FGVRHusV/IBxp4A4zTfDhEQHaYXQIBLNDflzSFpvW4iXw5hJ/FO6ida6yB/1IYDB1oO7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441083; c=relaxed/simple;
	bh=B64mJM7npPf/wHOFTh5udyRj1Gro6oqX1I82+6q4ASY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DqNV8yz7N0GQsPD+l0iw6AESHQqpfUh8izIUrP3PgQJ0MQMFPnFPkrynWPtYC8h4F1WIvj9T+A/Ap5fzBKCcLq4Vx3uALd6iyMFi0g2A9q0eKF2iqBf5nRvCLaKb/HNRVyZ/UxMLR+T7r6jUNii6O0hDUoiEvV+P3CCl4clUs+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TvOvjGst; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TvOvjGst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C330C2BD10;
	Mon,  3 Jun 2024 18:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441083;
	bh=B64mJM7npPf/wHOFTh5udyRj1Gro6oqX1I82+6q4ASY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TvOvjGstKG9q+I2+v+Iy6lgJrVN4Msi8QmFRR32B1wtgh9RSDoDcHuYZ5q8hbIzAL
	 vjQWbx0gim+M41fg4BbGSAypVENMnH86FKK6CeVQJY1oQiZsk1bPzunhcWgxoi384q
	 PMdF5f27nuPEmJ+e+zdEDGp33PiZOarhjkEoHMEb0q7xZDUvEtbek2gWwk2ncj76/j
	 6ptv7bXBEGYfenwNp5xxvv35U29d+fz8aQfskLVzSUMe+1El+dTC29zTVwZRcDk+C/
	 VPcQkA5fq4otMx4oFHYN+VHI2v41umeqXPfCV6kXialnV8iw6TZz3aVxsAbBoF4jcJ
	 R+eKrjCeppeqg==
Date: Mon, 03 Jun 2024 11:58:02 -0700
Subject: [PATCH 023/111] xfs: report realtime metadata corruption errors to
 the health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039715.1443973.13467170297139566638.stgit@frogsfrogsfrogs>
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

Source kernel commit: 8368ad49aaf771a6283840140149440b958b20fb

Whenever we encounter corrupt realtime metadat blocks, we should report
that to the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/util.c         |    1 +
 libxfs/xfs_rtbitmap.c |    9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index 6d8847363..841f4b963 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -737,3 +737,4 @@ void xfs_btree_mark_sick(struct xfs_btree_cur *cur) { }
 void xfs_dirattr_mark_sick(struct xfs_inode *ip, int whichfork) { }
 void xfs_da_mark_sick(struct xfs_da_args *args) { }
 void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask) { }
+void xfs_rt_mark_sick(struct xfs_mount *mp, unsigned int mask) { }
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 146e06bd8..543cfd2fb 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -15,6 +15,7 @@
 #include "xfs_bmap.h"
 #include "xfs_trans.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_health.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
@@ -113,13 +114,19 @@ xfs_rtbuf_get(
 	if (error)
 		return error;
 
-	if (XFS_IS_CORRUPT(mp, nmap == 0 || !xfs_bmap_is_written_extent(&map)))
+	if (XFS_IS_CORRUPT(mp, nmap == 0 || !xfs_bmap_is_written_extent(&map))) {
+		xfs_rt_mark_sick(mp, issum ? XFS_SICK_RT_SUMMARY :
+					     XFS_SICK_RT_BITMAP);
 		return -EFSCORRUPTED;
+	}
 
 	ASSERT(map.br_startblock != NULLFSBLOCK);
 	error = xfs_trans_read_buf(mp, args->tp, mp->m_ddev_targp,
 				   XFS_FSB_TO_DADDR(mp, map.br_startblock),
 				   mp->m_bsize, 0, &bp, &xfs_rtbuf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_rt_mark_sick(mp, issum ? XFS_SICK_RT_SUMMARY :
+					     XFS_SICK_RT_BITMAP);
 	if (error)
 		return error;
 

