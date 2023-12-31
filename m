Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCF9BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LitaQnE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD98C433C7;
	Sun, 31 Dec 2023 22:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060373;
	bh=D6A1QMsXWzvNX0qjvsayDullDJVzomKBp7xBPyNnJns=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LitaQnE2HY8UFtAxQJhbJJDrV4v91p497vs2i/vGeJav+KngbksMlN4hIP4e25NJu
	 X9qMtpLti3ZHmnl5IvsPcDXCLHhNPKoMMIaGrw1z1jLkr5xk2TCglBI1qXLRtRN4GK
	 dEfGRxqpAuaECVSqc24j5HTCOi+cDGB42rq0PuI5bWBueuhpdBJ2zm09jIADGQBWXb
	 aOOlb9r5qjI6/4nPNTevBeFUVu/sHjHTcNj/PcqCwhbKykLNrKmUYGqEPjBlF7YK/Q
	 AiNvlpFcyrRGwSWu35q3bfGSrvCX/HDexRh/Pg5OLRsnpQaHw5xgCN1kl8Xj0u1nGH
	 5fqfkni22AXhw==
Date: Sun, 31 Dec 2023 14:06:12 -0800
Subject: [PATCH 1/3] xfs: create a static name for the dot entry too
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404990116.1793320.11265371602874488279.stgit@frogsfrogsfrogs>
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

Create an xfs_name_dot object so that upcoming scrub code can compare
against that.  Offline repair already has such an object, so we're
really just hoisting it to the kernel.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_dir2.c |    6 ++++++
 libxfs/xfs_dir2.h |    1 +
 repair/phase6.c   |    4 ----
 3 files changed, 7 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index c19684b3401..dcbc83c8b00 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -24,6 +24,12 @@ const struct xfs_name xfs_name_dotdot = {
 	.type	= XFS_DIR3_FT_DIR,
 };
 
+const struct xfs_name xfs_name_dot = {
+	.name	= (const unsigned char *)".",
+	.len	= 1,
+	.type	= XFS_DIR3_FT_DIR,
+};
+
 /*
  * Convert inode mode to directory entry filetype
  */
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 19af22a16c4..7d7cd8d808e 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -22,6 +22,7 @@ struct xfs_dir3_icfree_hdr;
 struct xfs_dir3_icleaf_hdr;
 
 extern const struct xfs_name	xfs_name_dotdot;
+extern const struct xfs_name	xfs_name_dot;
 
 /*
  * Convert inode mode to directory entry filetype
diff --git a/repair/phase6.c b/repair/phase6.c
index fcb26d594b1..c681a69017d 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -23,10 +23,6 @@ static struct cred		zerocr;
 static struct fsxattr 		zerofsx;
 static xfs_ino_t		orphanage_ino;
 
-static struct xfs_name		xfs_name_dot = {(unsigned char *)".",
-						1,
-						XFS_DIR3_FT_DIR};
-
 /*
  * Data structures used to keep track of directories where the ".."
  * entries are updated. These must be rebuilt after the initial pass

