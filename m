Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F046ADF42
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Br0ulkxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE6AC433C7;
	Sun, 31 Dec 2023 21:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059637;
	bh=DDNO4FndOxDLHSPKZP/cOZqLcB8hXXNNY+W37XP+w9c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Br0ulkxrnChKKnaBcl8di8ALeWeenG0eRgYX2owaLM3AVTteIcRkAEaURFw2d9kKB
	 +y38+ufvpJiuBBcEO/33Ei4TDI9fCyKd8vc6K2hvTOaAGFrZETerHIM256aBnXX9Il
	 pNu5CtgfDdC57FHCeiKjq1jAagdFZGuZogcf4Z3e+aNGx7oaf03yYwCi2k9PHH2T4+
	 uHApcX+xyKuiIiKN8nAPssveiOJF+YIglK15KnEa+lcpZyhvSrittUS5oHe4+mv/wo
	 fhbE4C8oPrszPebZsvzNuKtdD2M188KrLRUfP5E8jz8CLnGJal8w0ZdhdnXY84V/Wj
	 v0b9JDKTT34DA==
Date: Sun, 31 Dec 2023 13:53:57 -0800
Subject: [PATCH 36/44] xfs: don't flag quota rt block usage on rtreflink
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852160.1766284.10569753561139191538.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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

Quota space usage is allowed to exceed the size of the physical storage
when reflink is enabled.  Now that we have reflink for the realtime
volume, apply this same logic to the rtb repair logic.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/quota_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index 0bab4c30cb85a..4e7198073a64a 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -236,7 +236,7 @@ xrep_quota_item(
 		rqi->need_quotacheck = true;
 		dirty = true;
 	}
-	if (dq->q_rtb.count > mp->m_sb.sb_rblocks) {
+	if (!xfs_has_reflink(mp) && dq->q_rtb.count > mp->m_sb.sb_rblocks) {
 		dq->q_rtb.reserved -= dq->q_rtb.count;
 		dq->q_rtb.reserved += mp->m_sb.sb_rblocks;
 		dq->q_rtb.count = mp->m_sb.sb_rblocks;

