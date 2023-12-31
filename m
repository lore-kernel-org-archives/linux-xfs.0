Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB34BA30
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZB1t5FCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAC4C433C8;
	Sun, 31 Dec 2023 20:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055600;
	bh=TkCOToRJtogkYuJtdAOWGgiT5yTPP9B9oYW2WsL8sUo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZB1t5FCSE7mrszCtXm89uFkPvqoR0VjEopbSYyNQXd1ZnZ/UohS6TYKOU47Q1jbUI
	 wC8zJ4b/e7QuvWAB7N9RBNkbGlwYruG/ruPuEllViuqgqLGBib6QrOBVCR2D+Pd+8p
	 uLBQr4A0rVzj2ca80/VK3mDvIDrCt/wrIfdZUfiOSUAkVu+C4O+me9NUYlUdS/Eigb
	 f8zDJvFTzsFepN8BVytwujIf2LGv3aCWxBWs3dAedab4Xj8FPZ5Pkn2PGrRgqi0cKZ
	 ZLDgGi6TWdV5je9OqikQ313GPMaVDCbM01JGGPKZ/xtAzkz0Fwlz3Y0LtrJkNTE0Yz
	 /IUZvxP9OqMaQ==
Date: Sun, 31 Dec 2023 12:46:40 -0800
Subject: [PATCH 07/14] xfs: restructure xfs_attr_complete_op a bit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404840514.1756514.4245756369419113020.stgit@frogsfrogsfrogs>
In-Reply-To: <170404840374.1756514.8610142613907153469.stgit@frogsfrogsfrogs>
References: <170404840374.1756514.8610142613907153469.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_attr.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d1f228c67857f..1d4cd8a8ac9ab 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -421,11 +421,11 @@ xfs_attr_complete_op(
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

