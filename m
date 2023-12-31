Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AD1C12D
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FSUG9rpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D2BC433C8;
	Sun, 31 Dec 2023 22:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061670;
	bh=km9QJpkM0NpW/whmktokrqvVsUgm5KWaZ3UNuV4WyBM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FSUG9rpZESnmll9ZtBlxiBXU/fLfZLIyfnZpGKNsAnG425aua3C09Cc1XPU/GqzBW
	 MeSCAwRVtPeXpfsK0ScozpmattTlbrpr/7+8JsI0fZWa5PfcCrY5+5BlH2yn4AGXRv
	 WYUAT1VT6YrnyZOO5pFFjD1i/ZbehbbvycySQ3kJhadZyg+ALHyJRiI3s6d4se/b3E
	 dQxvD6AqRftTrS1CqN70kvrtktLTLAXUVnb/fOnQZZnIYtbz/syEKSpWFoaJxtLTJ0
	 9krnZaGRlwUuT8s3aSRjmu9P7FbwdUi/5+VUS2bHl+yu8Nt//U/wasAvVMqKnknq8H
	 dAdvFv35xHNvQ==
Date: Sun, 31 Dec 2023 14:27:50 -0800
Subject: [PATCH 03/20] xfs: parameterize all the incompat log feature helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996314.1796128.156094362141521193.stgit@frogsfrogsfrogs>
In-Reply-To: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
References: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
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

We're about to define a new XFS_SB_FEAT_INCOMPAT_LOG_ bit, which means
that callers will soon require the ability to toggle on and off
different log incompat feature bits.  Parameterize the
xlog_{use,drop}_incompat_feat and xfs_sb_remove_incompat_log_features
functions so that callers can specify which feature they're trying to
use and so that we can clear individual log incompat bits as needed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_format.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index e6ca188e227..4baafff6197 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -404,9 +404,10 @@ xfs_sb_has_incompat_log_feature(
 
 static inline void
 xfs_sb_remove_incompat_log_features(
-	struct xfs_sb	*sbp)
+	struct xfs_sb	*sbp,
+	uint32_t	feature)
 {
-	sbp->sb_features_log_incompat &= ~XFS_SB_FEAT_INCOMPAT_LOG_ALL;
+	sbp->sb_features_log_incompat &= ~feature;
 }
 
 static inline void

