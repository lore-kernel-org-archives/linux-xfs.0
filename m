Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE67C129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b6djbO/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08315C433C7;
	Sun, 31 Dec 2023 22:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061358;
	bh=0vDQTv9n9ptIp1IhtZPs5LXaCZDqQ74C5P0rFa52P3o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b6djbO/G1XzOMtyGxOaicABj1MQi1vWgXdiJ9UnsKpX7ZAZ87cDZLcH5eoEw4da3U
	 VSFisifVFCkVW1IQtGbeWdWzPuEx0J+o6qalJ0YDPLizif96qH+8rkYZez/I4poWrO
	 1qtv+2UogKBqgFgF02kKsorX7rLHuH1fsrRb5DTiMawEwjdRy5WjggTTf5dVXkwlSq
	 ZYeK8DW2CL8wMOPXeNhtIUqkRPy/MgqaO7DCgufnlxhhgvEVMBYdTuo0yj2dzNw8MK
	 VNrXIwtRoJTJuHGg/l4IpBDzg3bYUTsCWF+xP0hJpzS9PNRdkTjms1I6P0W7kyLSR9
	 Pc4KjRP3DmFEA==
Date: Sun, 31 Dec 2023 14:22:37 -0800
Subject: [PATCH 2/6] xfs: define an in-memory btree for storing refcount bag
 info during repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404994452.1795402.7430235273150303325.stgit@frogsfrogsfrogs>
In-Reply-To: <170404994421.1795402.5021109335646815731.stgit@frogsfrogsfrogs>
References: <170404994421.1795402.5021109335646815731.stgit@frogsfrogsfrogs>
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

Create a new in-memory btree type so that we can store refcount bag info
in a much more memory-efficient format.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.h |    1 +
 libxfs/xfs_types.h |    6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index edbcd4f0e98..339b5561e5b 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -62,6 +62,7 @@ union xfs_btree_rec {
 #define	XFS_BTNUM_FINO	((xfs_btnum_t)XFS_BTNUM_FINOi)
 #define	XFS_BTNUM_RMAP	((xfs_btnum_t)XFS_BTNUM_RMAPi)
 #define	XFS_BTNUM_REFC	((xfs_btnum_t)XFS_BTNUM_REFCi)
+#define	XFS_BTNUM_RCBAG	((xfs_btnum_t)XFS_BTNUM_RCBAGi)
 
 struct xfs_btree_ops;
 uint32_t xfs_btree_magic(struct xfs_mount *mp, const struct xfs_btree_ops *ops);
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 035bf703d71..5556615a2ff 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -121,7 +121,8 @@ typedef enum {
  */
 typedef enum {
 	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_RMAPi, XFS_BTNUM_BMAPi,
-	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_MAX
+	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_RCBAGi,
+	XFS_BTNUM_MAX
 } xfs_btnum_t;
 
 #define XFS_BTNUM_STRINGS \
@@ -131,7 +132,8 @@ typedef enum {
 	{ XFS_BTNUM_BMAPi,	"bmbt" }, \
 	{ XFS_BTNUM_INOi,	"inobt" }, \
 	{ XFS_BTNUM_FINOi,	"finobt" }, \
-	{ XFS_BTNUM_REFCi,	"refcbt" }
+	{ XFS_BTNUM_REFCi,	"refcbt" }, \
+	{ XFS_BTNUM_RCBAGi,	"rcbagbt" }
 
 struct xfs_name {
 	const unsigned char	*name;

