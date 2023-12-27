Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805C7817
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WaMO+I3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159D3C433C7;
	Mon,  1 Jan 2024 00:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069004;
	bh=ALyF+uYYA0UEADfi4sd309OQVB7zXmxSsBg34r79TlE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WaMO+I3PgqP3hh2YV7OHxXvQNj0xmozLzE7Nk6aoM/h8y6xEUGS7yyLa6j918BUot
	 VwqS9F148548EGGTXQhuwQzyxQBhoLxxTe9wz/ZzUstX15Tq7EFDU+rHCpYsQKyZnL
	 ZX3QicBDPlq/4ararhFkONC9Ah7ZuulGuCy+eLx07KoJEL2W6RSh/rJ0hFaRJhdwH1
	 rsSQ3yUAaORasTNS1Kq5OQCBPMIc2Mcm6zLWk6IdZ3LiWuAx5IDWrdiU5gXXiRes03
	 HOS86GVoXXoB+T+Q3cmzP874rE5cy30TZS7JETuMwZZGDJaVNnxWFOngVvZ0NrFvs5
	 1PqDMcozoeDjQ==
Date: Sun, 31 Dec 2023 16:30:03 +9900
Subject: [PATCH 15/42] xfs: allow inodes to have the realtime and reflink
 flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017326.1817107.13738094953101859075.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

Now that we can share blocks between realtime files, allow this
combination.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_inode_buf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 6f4dbe8367b..f4eabd99a60 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -688,7 +688,8 @@ xfs_dinode_verify(
 		return __this_address;
 
 	/* don't let reflink and realtime mix */
-	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME))
+	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME) &&
+	    !xfs_has_rtreflink(mp))
 		return __this_address;
 
 	/* COW extent size hint validation */

