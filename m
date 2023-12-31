Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D712BBE48
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a9gCpuCt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F6DC433C7;
	Sun, 31 Dec 2023 22:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060404;
	bh=KJxLkUZA3PMu5zrygvVKq7gd7f+6PZH20QPZ91BP5S8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=a9gCpuCtsdCsF+IqOE3FolYIUhUXc3qKGkgJ4177WVNapv36a1Jdf0qaIu/k8cCHy
	 IxMqKb6oMtHDAThWaSCmsOeSZ1SYcGtIEsFDC86BTVKRrey5AgQ0AXcCtpq7mlij8A
	 lYpVcDZW3gsZSwgnYqfPhKQYmKQsP1QxuYsUEzf2GXUagKjY70+Ss6ksH5iLFwy96h
	 Ti4qQLqpkk783MULMzNfElPkhO/xEBL6wVG7ElJ6tCQiVYXThH/w8l+6Z4DGQuSxL0
	 vSQmo/L56zLsxsWaIPi7c+EE+hb04dWmeRlDH36QZ/t+e4jjIv/UnBG9u3yDs3pX9w
	 0OU709iej0miA==
Date: Sun, 31 Dec 2023 14:06:43 -0800
Subject: [PATCH 3/3] xfs: create a macro for decoding ftypes in tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404990142.1793320.4776161040245673665.stgit@frogsfrogsfrogs>
In-Reply-To: <170404990101.1793320.2115612026823880865.stgit@frogsfrogsfrogs>
References: <170404990101.1793320.2115612026823880865.stgit@frogsfrogsfrogs>
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

Create the XFS_DIR3_FTYPE_STR macro so that we can report ftype as
strings instead of numbers in tracepoints.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_da_format.h |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index f9015f88eca..44748f1640e 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -159,6 +159,17 @@ struct xfs_da3_intnode {
 
 #define XFS_DIR3_FT_MAX			9
 
+#define XFS_DIR3_FTYPE_STR \
+	{ XFS_DIR3_FT_UNKNOWN,	"unknown" }, \
+	{ XFS_DIR3_FT_REG_FILE,	"file" }, \
+	{ XFS_DIR3_FT_DIR,	"directory" }, \
+	{ XFS_DIR3_FT_CHRDEV,	"char" }, \
+	{ XFS_DIR3_FT_BLKDEV,	"block" }, \
+	{ XFS_DIR3_FT_FIFO,	"fifo" }, \
+	{ XFS_DIR3_FT_SOCK,	"sock" }, \
+	{ XFS_DIR3_FT_SYMLINK,	"symlink" }, \
+	{ XFS_DIR3_FT_WHT,	"whiteout" }
+
 /*
  * Byte offset in data block and shortform entry.
  */

