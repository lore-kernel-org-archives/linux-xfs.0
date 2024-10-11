Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BD54A06
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608266; cv=none; b=hiM9Hxx0KRpEqtfwVokrinwA2bC19KEs5kamV0Tg8xNhuTuLqB7N6IKlkP50TEvqUdby3VpYv/PWp1LRlizev9GUX82xx3C8ZvRIdxQwCQbndW5nqlLTw3x7MBTzIyWWx/VmHbK1o2cHxcfw5FIArDAIeJKKJPN5FxBjRtTq0W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608266; c=relaxed/simple;
	bh=EZDYL0j9DdPjCfgCRbIdkamcmXh/QqkI1kPDkq7J0fk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BNPqdJtYczDT1VUcWYIY8BpgnJbVW5jXc2NrBuhvHylGAuCaf1FRSia2TRVSzWcOFOFEFiCoPlaec+Ni4Uana3kKuq+aYMqqgyWHWRBUsnV3bbG8+NSaJbaDlAMRR5oDjTkKzGncwmaYOBK4p6IoS1xY6ibEQSwin/0U3CVVP4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gmDveEPv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gmDveEPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826ABC4CEC5;
	Fri, 11 Oct 2024 00:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608266;
	bh=EZDYL0j9DdPjCfgCRbIdkamcmXh/QqkI1kPDkq7J0fk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gmDveEPv+NNjxpoAfUjo93aQHFpHhTsd2OLbwoSGUdS/THZklOEuofXKt9zO/SihO
	 foLpI9GU/wanCWV9PjmXkd7CRNdHzGcRgxZxGVZceD9JBuAjt+kVfo9IEvJryRQ0K+
	 /++AuWdfS3bwyymjlNp/5UYvcIN0gIC7GSN2VQ1jyFpSDC5O6kX9g0TT/73HLOMzw1
	 jc5RFqKvY+xEdL1ePS41bPOlPDbjpjXmdgrlrzurJ9rvNRZFPImJrdycEL9tLWEzsf
	 i68PTSnaD7YrcpTn4YTbBACB2HWasB3qDlJ3/GnaBZjEhhlDAEO7fUPIUZYO8dysX6
	 Go0rz1MLd8pdg==
Date: Thu, 10 Oct 2024 17:57:46 -0700
Subject: [PATCH 08/21] xfs: add a xfs_qm_unmount_rt helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860643085.4177836.784622735507950940.stgit@frogsfrogsfrogs>
In-Reply-To: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
References: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

