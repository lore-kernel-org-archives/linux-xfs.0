Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE838F54
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609079; cv=none; b=ajtrEtTMNxiTkrWrd820iIoCF6iCEAzhMFR6cm5xTdDzBuSwT5HXsZb/fLaAQB/7X61IlPQHUH2GmxZ7Kmy4gtVjb1JwOPHGdd5AMfkgTj1RMQquONVrgqzAQwJjCM1svrKxCEc08dSttDhPZevG+0AFIM9xM3YNzks+/KkPBwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609079; c=relaxed/simple;
	bh=Ghg8E08pjCYzdcD2fnG9nduoTiOPZud0RlUBIwmjog4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NBIEahp97jPF4XLCkzZQqd6l9hf3rw1yxX0ugKir4Jlqwq71yWSjbhmg6Jw9V4WFaVY5e5ZnkU+aTj7M6oYrjGZa22f0yOQ+q6sTGM3Wlw+omus62jYdn9PD1tK7KA/IH+6S1Ue6v15IusP2ifwPb9bCitOp42jmS05++uD1sJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j8NVIh+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j8NVIh+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290E5C4CEC5;
	Fri, 11 Oct 2024 01:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609079;
	bh=Ghg8E08pjCYzdcD2fnG9nduoTiOPZud0RlUBIwmjog4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=j8NVIh+YjumZbg+uK+RblzNBgYzAqkNz9ZEvnbEYQGIhwsBcKzLTBGtZaAv/chwtV
	 1O9Gj3Rl/9Gwyf7HJtpPPT2RiXyFK/bL+Qw9POMOi3RKSXFFd8EYdt8kSVhk933MqH
	 Fn37tN2TSKAGKsPhnIV8e0tXXWqjP9fv/nuwjMdzE1c4mewrN9vx8XTE53N+leS26o
	 zr1u3ue2rjKq4Mbo+xeZqJLk1oaS9J6mR8ES2z8mbxxPhr3+n1e1AmEuKzZwAQOKkX
	 udrXSZ81O5ux4qMwj8YulkhCLXGLmhBNR7aTAXf+UzSlOs1ho0PD8InuJ2YqbgGdZD
	 vbAXAjED4k7cw==
Date: Thu, 10 Oct 2024 18:11:18 -0700
Subject: [PATCH 1/4] xfs: refactor xfs_qm_destroy_quotainos
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860645249.4179917.14135410245319602913.stgit@frogsfrogsfrogs>
In-Reply-To: <172860645220.4179917.14075452764287165701.stgit@frogsfrogsfrogs>
References: <172860645220.4179917.14075452764287165701.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm.c |   53 ++++++++++++++++++++---------------------------------
 1 file changed, 20 insertions(+), 33 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 28b1420bac1dd2..b37e80fe7e86a6 100644
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

