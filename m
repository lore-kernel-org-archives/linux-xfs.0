Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA0A17997
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372893; cv=none; b=QLpqTrkJnm4cVmMoxcaXcSN3tDk300jbRgNrdBv9NEOwgDWxilqeU2nl5YJGwXxrRollcnxpNd5HAN5nC2RiQQWBPCmDSIafAAUzNAfu+RAgcYL2KhW/wqBLtpu8mv04A0GCwcty4+0bJ3uqYQTDj4za3FdVSxGgkXMlq/0tQAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372893; c=relaxed/simple;
	bh=ZdVutQB3GDrydhvI4zJjHcYQYmne8bVnBoc8GHCFfA4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L3dBtn00ODj2bsDukUqHsu6OgzW59Pps2F1wRFjAxCzFiRoUmFrA+ji9OqW4vt6t0Vshhl/aEBETWCtzdiHmAkgj/i8cla+7NE1hbccm222W5gMIR/akKz85QAwN+4K3JYDvy2C7oupnQCvObFCOCyu8wpiZfMbiwW14oaUdwLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mg3Wgqzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mg3Wgqzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24AB1C32782;
	Fri, 23 Aug 2024 00:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372893;
	bh=ZdVutQB3GDrydhvI4zJjHcYQYmne8bVnBoc8GHCFfA4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mg3WgqzlPMNWVHHRh+qHOMCqiGfk6WgFSwQHfDNlUpNIZ4SYhHdR5F+O2CBBwq0Wz
	 c0uwWvdGiy0EB+sxIVHLTC6hf/B++2CR0IMx0p3LDOD6pJUKQS8w41rP9eXrOM+J8O
	 zvffij4IiswqcLV7abyrP02AQBxa8z0giRgwGpTzYTFgVrhj3sUVI/FRqyK8QBWUzs
	 eUa1iNzuhe+vazkvgcv+wEW2esDANSmV0IlpgAZK/s+wFYFHUMNGfBuR7K4K2Jv9pJ
	 qGW6oIgRJ3SGzi4LvPMSMXUgBH6H8I7y5QenlapoqIgkJT6Jwe4C2AP4XR/ofwpIMD
	 08Ka3yIGqSGeA==
Date: Thu, 22 Aug 2024 17:28:12 -0700
Subject: [PATCH 1/6] xfs: refactor xfs_qm_destroy_quotainos
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437089380.61495.10149120499984603964.stgit@frogsfrogsfrogs>
In-Reply-To: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
References: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
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

Reuse this function instead of open-coding the logic.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c |   53 ++++++++++++++++++++---------------------------------
 1 file changed, 20 insertions(+), 33 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 28b1420bac1dd..b37e80fe7e86a 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -40,7 +40,6 @@
 STATIC int	xfs_qm_init_quotainos(struct xfs_mount *mp);
 STATIC int	xfs_qm_init_quotainfo(struct xfs_mount *mp);
 
-STATIC void	xfs_qm_destroy_quotainos(struct xfs_quotainfo *qi);
 STATIC void	xfs_qm_dqfree_one(struct xfs_dquot *dqp);
 /*
  * We use the batch lookup interface to iterate over the dquots as it
@@ -226,6 +225,24 @@ xfs_qm_unmount_rt(
 	xfs_rtgroup_rele(rtg);
 }
 
+STATIC void
+xfs_qm_destroy_quotainos(
+	struct xfs_quotainfo	*qi)
+{
+	if (qi->qi_uquotaip) {
+		xfs_irele(qi->qi_uquotaip);
+		qi->qi_uquotaip = NULL; /* paranoia */
+	}
+	if (qi->qi_gquotaip) {
+		xfs_irele(qi->qi_gquotaip);
+		qi->qi_gquotaip = NULL;
+	}
+	if (qi->qi_pquotaip) {
+		xfs_irele(qi->qi_pquotaip);
+		qi->qi_pquotaip = NULL;
+	}
+}
+
 /*
  * Called from the vfsops layer.
  */
@@ -250,20 +267,8 @@ xfs_qm_unmount_quotas(
 	/*
 	 * Release the quota inodes.
 	 */
-	if (mp->m_quotainfo) {
-		if (mp->m_quotainfo->qi_uquotaip) {
-			xfs_irele(mp->m_quotainfo->qi_uquotaip);
-			mp->m_quotainfo->qi_uquotaip = NULL;
-		}
-		if (mp->m_quotainfo->qi_gquotaip) {
-			xfs_irele(mp->m_quotainfo->qi_gquotaip);
-			mp->m_quotainfo->qi_gquotaip = NULL;
-		}
-		if (mp->m_quotainfo->qi_pquotaip) {
-			xfs_irele(mp->m_quotainfo->qi_pquotaip);
-			mp->m_quotainfo->qi_pquotaip = NULL;
-		}
-	}
+	if (mp->m_quotainfo)
+		xfs_qm_destroy_quotainos(mp->m_quotainfo);
 }
 
 STATIC int
@@ -1712,24 +1717,6 @@ xfs_qm_init_quotainos(
 	return error;
 }
 
-STATIC void
-xfs_qm_destroy_quotainos(
-	struct xfs_quotainfo	*qi)
-{
-	if (qi->qi_uquotaip) {
-		xfs_irele(qi->qi_uquotaip);
-		qi->qi_uquotaip = NULL; /* paranoia */
-	}
-	if (qi->qi_gquotaip) {
-		xfs_irele(qi->qi_gquotaip);
-		qi->qi_gquotaip = NULL;
-	}
-	if (qi->qi_pquotaip) {
-		xfs_irele(qi->qi_pquotaip);
-		qi->qi_pquotaip = NULL;
-	}
-}
-
 STATIC void
 xfs_qm_dqfree_one(
 	struct xfs_dquot	*dqp)

