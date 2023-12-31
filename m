Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49874C154
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k6EflWdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B63C433C7;
	Sun, 31 Dec 2023 23:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064110;
	bh=H4fKnseCpgsoOL3dW+9IVo2l0KfXyfTkXYDD7xISvoQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=k6EflWdxY5nxT65S34dy88FqJwyDQ3ntcOQt57XeF0CPMV5igacft5wHcxa1CrGlv
	 a8PJh3y6rOuUXRFqM9LYugXQZH+xJ+MzDrj/cfEeCBfRRQTrlEvzeA9oGeksR13mtG
	 y5+u70gmB6CJdrjLaLsPJRb2SRWoYA580cOHUercJqXo2FSochF23OeIC1ESzh4Hjd
	 BZO8HfjiS2TVZxcT+X4gHMgrBWs17dTkkRyJ7Xx3gESMOnusycJM35krYcOC72XAHw
	 EjXclExymKS1eAkjjBz6TAmD8NQhzxQ32vOnvaQSlTHvOeTRxq+38vKHzPOMO2tY1g
	 sL+1obNms4IMw==
Date: Sun, 31 Dec 2023 15:08:29 -0800
Subject: [PATCH 13/32] xfs: drop compatibility minimum log size computations
 for reflink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006276.1804688.17164442662917384498.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
References: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
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

Having established that we can reduce the minimum log size computation
for filesystems with parent pointers or any newer feature, we should
also drop the compat minlogsize code that we added when we reduced the
transaction reservation size for rmap and reflink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_log_rlimit.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/libxfs/xfs_log_rlimit.c b/libxfs/xfs_log_rlimit.c
index 096e3ee4b6a..2a5fa3334c8 100644
--- a/libxfs/xfs_log_rlimit.c
+++ b/libxfs/xfs_log_rlimit.c
@@ -81,6 +81,16 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 {
 	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
 
+	/*
+	 * Starting with the parent pointer feature, every new fs feature
+	 * drops the oversized minimum log size computation introduced by the
+	 * original reflink code.
+	 */
+	if (xfs_has_parent_or_newer_feature(mp)) {
+		xfs_trans_resv_calc(mp, resv);
+		return;
+	}
+
 	/*
 	 * In the early days of rmap+reflink, we always set the rmap maxlevels
 	 * to 9 even if the AG was small enough that it would never grow to

