Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF644BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p+eMncnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FDEC433C7;
	Sun, 31 Dec 2023 20:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053223;
	bh=BcbI/K+0ln/LjeFU4TEcwesJWPQBcwyNQeCNW8AS9G4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p+eMncnG4WwKUy/C45jfThNAjRhBHxmJPJSHbu1PseImYsRNJfeLMBC5i/rnBDM8o
	 q7DQoAiyc6x2fWSFTW0/wmYhx8kBObN0gKsahpHFRk34qOjk3eue9G3/5kITIfVSgX
	 a82qd4v9XOKj0qwAAXU8ShEX149KevqHJrH+ksfn4X+/X4o0D9PlkwmIqL14bPI9HV
	 8q15G18oxPIRyjU9SyGz2xAxv5RE9zp+MSpdBLUgg5TPeTTrqV9JnSKK3ynsIT/OXd
	 rqYOCWVjBDlXJo/83n1GVba3lVxFPQUpDzmnLWuKt1znUGhg/6p/taDsmJPArD3bzO
	 23OiMMpmlz0bw==
Date: Sun, 31 Dec 2023 12:07:03 -0800
Subject: [PATCH 3/4] xfs: create a macro for decoding ftypes in tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404827020.1747851.3610479881365181597.stgit@frogsfrogsfrogs>
In-Reply-To: <170404826964.1747851.15684326001874060927.stgit@frogsfrogsfrogs>
References: <170404826964.1747851.15684326001874060927.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_da_format.h |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index f9015f88eca70..44748f1640e53 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
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

