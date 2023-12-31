Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE8DC8C8
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XTSX/qeI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BFCDC433C8;
	Sun, 31 Dec 2023 23:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063813;
	bh=z8BatE9FewisiqDsb5reT86EmlAxOg5abdH9TP/32FY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XTSX/qeI+ctQh/HaBTCP9Ph+bxPR711rrxe/zpSvTx5vrYSYXM3eqPlmD2x/s1tdj
	 IR5hcBDAviY6Ro5ohEFHGr/ih5PCRV1SS5pSKvND+XdIJynWJCrc0JH1f3EN73eJdB
	 BlWcF/e0T7uQzw1K/89MK3K9mGuLqhiSkBYWlxDUsGCwGZk7J4jksQvCtwvcJxSZO+
	 OceVHtJixoARdBMyB0PTr8D0niQcrol+Tu/svIzT/RIaac3//a8tw5LW3EQAeTiSQv
	 a4js3Z8HilVPelo86G4vdc6K/MB6x/UuRXlC4T4B6nsOzrCCSOYX8hT0jcnY1uwMwX
	 fxdnCK009/E8g==
Date: Sun, 31 Dec 2023 15:03:32 -0800
Subject: [PATCH 05/11] xfs: restructure xfs_attr_complete_op a bit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405005663.1804370.12667483093904991965.stgit@frogsfrogsfrogs>
In-Reply-To: <170405005590.1804370.14232373294131770998.stgit@frogsfrogsfrogs>
References: <170405005590.1804370.14232373294131770998.stgit@frogsfrogsfrogs>
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

Reduce the indentation in this function by flattening the nested if
statements.  We're going to add more code later to this function later,
hence the early cleanup.  No functional changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index e714ea60319..3f9c504e755 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -419,11 +419,11 @@ xfs_attr_complete_op(
 	bool			do_replace = args->op_flags & XFS_DA_OP_REPLACE;
 
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
-	if (do_replace) {
-		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
-		return replace_state;
-	}
-	return XFS_DAS_DONE;
+	if (!do_replace)
+		return XFS_DAS_DONE;
+
+	args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+	return replace_state;
 }
 
 static int

