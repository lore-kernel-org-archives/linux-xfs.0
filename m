Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14D6C2DA
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ua8ol7Xx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F149C433C7;
	Sun, 31 Dec 2023 23:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066548;
	bh=e8dnf9Fa1qvA6dQSdeWwt6eJCQhhQbVXxXlRhwq11t0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ua8ol7XxKwg7R2Z+l4X6gVFz50Mz8htbWjLpBAmcbqlSeMjrpTgZfB4txrulMeRxJ
	 QVT83pUt3mjKEuT4sb6qEx1wFWZN9Ye8u9ciKVWX0gvbaRxpo79fSVCYAiKgNjftlt
	 WKljeOHa5fokr1tXv14V69xIP3WG7cX+YOaSi5QfIG1qDA+zb53K4p3sWtq7GQ++wA
	 B9nqy7BfcI6HtaJePk5HY2Co7/tALDykiiw98BlVhEyOXj2kU2de0NDUi/u0Wy2kwQ
	 LjW0o/QCo+DL+0kKtf82PqY3KM+4lJ27yb3hYkRFFoktpb7e7QZiafvucsRXo1KTn4
	 X/OIdU+dJvvBA==
Date: Sun, 31 Dec 2023 15:49:08 -0800
Subject: [PATCH 06/52] xfs: grow the realtime section when realtime groups are
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012249.1811243.8600558992674210309.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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

Enable growing the rt section when realtime groups are enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_shared.h |    1 +
 1 file changed, 1 insertion(+)


diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index f76d2789e1c..65691af0488 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -111,6 +111,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_TRANS_SB_RBLOCKS		0x00000800
 #define	XFS_TRANS_SB_REXTENTS		0x00001000
 #define	XFS_TRANS_SB_REXTSLOG		0x00002000
+#define XFS_TRANS_SB_RGCOUNT		0x00004000
 
 /*
  * Here we centralize the specification of XFS meta-data buffer reference count

