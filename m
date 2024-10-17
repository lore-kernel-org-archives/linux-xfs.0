Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5335221C164
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191671; cv=none; b=CY2Z/kpeHGcKOT0sHrVD4E6J6WRF4Ot8FD+TYyvgdU4WVqjSGn3x3bW3hNISpKBgTzW1tnbJIFOJv/QUhqxDJLXnMTq78Xyn99l0pM8uUDcllynWV0NmF8l09nfKBm4UP4RQcLngMw0sTTD/NoPVYEexN7H5zDVPsMToFVNWEV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191671; c=relaxed/simple;
	bh=tiT81Z46aWVUeqOMMtrmRKIZGl92kzdSOrdG6N95Y9c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dz0uKRhU+ndl31ZjJTSOWNxBlu8YnFsVvkIbGkADBubt6NupG56lJvJ7hpozeB897Ia9BWY2cB0wl1ukPyrQnKPorq+PfoCyjRXnd5U0B79IFGexaTkwdnyDc0LfVHuLyg8OF0sYXcURhnnmpb+lX9dPu4brY+Y1u3IYaCHo6Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZkitsKOU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZkitsKOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02F0C4CED0;
	Thu, 17 Oct 2024 19:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191670;
	bh=tiT81Z46aWVUeqOMMtrmRKIZGl92kzdSOrdG6N95Y9c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZkitsKOUahV9CPhcDdpNqshZ6QlR+E4cJJepb//JKt3kua77hFRoLQTLVMzSK95NY
	 NL2Uz+4qvxUkzjm/RLbNukIuWQZCBn7y4TPNeMAcwculGCyhrY0C9rskBMS5s+92ko
	 roF5PoAiEsqSuykwLs/1lsrr5IMoB3MxyXEDruDAeI3BRbNSxGIbybp2wh7/QWQ0WS
	 EtzAT/cNIfiEGbyFSpYZ04BB6jhdKI61u2epxmPPgnTFzxvYyYdaSaQAVXUJpAA1FO
	 7XXUE8S3Vs/sWbpa90PynzgjIOR4gxPHhKUF3Ya9IoTCVaoCPjnmFROfuHZanhGGVE
	 o/aEY5s7XNfAw==
Date: Thu, 17 Oct 2024 12:01:10 -0700
Subject: [PATCH 08/21] xfs: add a xfs_qm_unmount_rt helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919070535.3452315.1670347294453458272.stgit@frogsfrogsfrogs>
In-Reply-To: <172919070339.3452315.8623007849785117687.stgit@frogsfrogsfrogs>
References: <172919070339.3452315.8623007849785117687.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

RT group enabled file systems fix the bug where we pointlessly attach
quotas to the RT bitmap and summary files.  Split the code to detach the
quotas into a helper, make it conditional and document the differing
behavior for RT group and pre-RT group file systems.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b94d6f192e7258..3663c4f89ed8a1 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -29,6 +29,7 @@
 #include "xfs_health.h"
 #include "xfs_da_format.h"
 #include "xfs_metafile.h"
+#include "xfs_rtgroup.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -210,6 +211,16 @@ xfs_qm_unmount(
 	}
 }
 
+static void
+xfs_qm_unmount_rt(
+	struct xfs_mount	*mp)
+{
+	if (mp->m_rbmip)
+		xfs_qm_dqdetach(mp->m_rbmip);
+	if (mp->m_rsumip)
+		xfs_qm_dqdetach(mp->m_rsumip);
+}
+
 /*
  * Called from the vfsops layer.
  */
@@ -223,10 +234,13 @@ xfs_qm_unmount_quotas(
 	 */
 	ASSERT(mp->m_rootip);
 	xfs_qm_dqdetach(mp->m_rootip);
-	if (mp->m_rbmip)
-		xfs_qm_dqdetach(mp->m_rbmip);
-	if (mp->m_rsumip)
-		xfs_qm_dqdetach(mp->m_rsumip);
+
+	/*
+	 * For pre-RTG file systems, the RT inodes have quotas attached,
+	 * detach them now.
+	 */
+	if (!xfs_has_rtgroups(mp))
+		xfs_qm_unmount_rt(mp);
 
 	/*
 	 * Release the quota inodes.

