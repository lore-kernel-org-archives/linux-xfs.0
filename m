Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFAF43A7F5;
	Wed, 23 Sep 2026 05:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143153; cv=none; b=TZveW7PJspebptbu8auuad84BOvN89fhmbYAgvA65zEgiD/zEHucTZo97DzZOTHsUTCmPsNqG6x1Jkcb11APmvMUM4jWZM+IAcRM3jEkKELe4IiewQG+kkP/b1keGSEM8ehG1jcgCY48ObTpgDzgviFK8JaicaIfepIVlMXz9m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143153; c=relaxed/simple;
	bh=DIsYpoisZIuSRrQ7vdhk/RxzbPKaMQY1RyccvFUfXlY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=saWaLW/FQihu/+l/JCVUhKMvOrZRRiWhfsESTa0QDvWJdkRoLVysFYJ3+wsRxrM/zb3mRoVxg8TXXKoOogPVuHakO6s97EsTjysex/Ecqln1sRxmjrZMBhW7TJ3KQzKTadpBRkooTlVEGu8EcHcipSb1Iz60Fzct7WQL5sMtOTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=otnh6pFm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="otnh6pFm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 653F51F000FF;
	Wed, 23 Sep 2026 05:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143151;
	bh=RHa9dgw3FWJ3HDw5tq3vuAt4ZNkUWSG4pV5oL/BC0BE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=otnh6pFmSMAzickBbbs2FvZLwc4wUgjd+Yk6RwrwBXpxl89KywJcV4vt0hg1C/R65
	 /XOCLGxxOjLQPes3lu7rpM+LAzOCVFWYZ7pWV5kN87J57Dx5ZGikQZNsNDbgnsVAcM
	 OoHleUUDzcE2exWlQc2PMtXx/n4j/HTTw04IZKkYL5lYYRPK+Bt1uUFR89afnQKJ7W
	 MglFTlIzXZ2pz/T7JYiM6oYH+kqYaenRdUlJlUYQLqXl5819YNM9ycjmw76HCZjrI5
	 OGOQsDD9dHxUPB1bVvR05gHFMMcEZUicW8O5W2YASuZjaUMPGtNnQT0lybJVUnXMe7
	 S0IiYsjRAaMQw==
Date: Tue, 22 Sep 2026 22:59:11 -0700
Subject: [PATCH 07/13] xfs: fix ondisk symlink target validation in
 xrep_dinode_check_dfork
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: dgc@kernel.org, hch@lst.de, stable@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <179014159076.1874904.11745428983081091628.stgit@frogsfrogsfrogs>
In-Reply-To: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
References: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that online repair of a broken symlink file could fail
unnecessarily if a local-format symlink target isn't null terminated.
The ondisk target isn't required to be null terminated, but repair
enforces that anyway because it uses the validator for the incore
symlink target.  (The incore buffer is always null-terminated).  Fix
this by reverting the changes to xfs_symlink_shortform_verify and adding
an ondisk-specific helper in inode_repair.c.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: e744cef2060559 ("xfs: zap broken inode forks")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_symlink_remote.h |    2 +-
 fs/xfs/libxfs/xfs_inode_fork.c     |    4 +---
 fs/xfs/libxfs/xfs_symlink_remote.c |    8 ++++++--
 fs/xfs/scrub/inode_repair.c        |   26 +++++++++++++++++++++++++-
 4 files changed, 33 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_symlink_remote.h b/fs/xfs/libxfs/xfs_symlink_remote.h
index c1672fe1f17bb2..3f6590602473d0 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.h
+++ b/fs/xfs/libxfs/xfs_symlink_remote.h
@@ -18,7 +18,7 @@ bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
 void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
 				 struct xfs_inode *ip, struct xfs_ifork *ifp,
 				 void *priv);
-xfs_failaddr_t xfs_symlink_shortform_verify(void *sfp, int64_t size);
+xfs_failaddr_t xfs_symlink_shortform_verify(struct xfs_inode *ip);
 int xfs_symlink_remote_read(struct xfs_inode *ip, char *link);
 int xfs_symlink_write_target(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_ino_t owner, const char *target_path, int pathlen,
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 606a36526ce245..486fe7ab8b6110 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -683,9 +683,7 @@ xfs_ifork_verify_local_data(
 		break;
 	}
 	case S_IFLNK: {
-		struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
-
-		fa = xfs_symlink_shortform_verify(ifp->if_data, ifp->if_bytes);
+		fa = xfs_symlink_shortform_verify(ip);
 		break;
 	}
 	default:
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index b0dc3888bf1b40..0201a3d59b1a24 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -208,11 +208,15 @@ xfs_symlink_local_to_remote(
  */
 xfs_failaddr_t
 xfs_symlink_shortform_verify(
-	void			*sfp,
-	int64_t			size)
+	struct xfs_inode	*ip)
 {
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+	char			*sfp = (char *)ifp->if_data;
+	int			size = ifp->if_bytes;
 	char			*endp = sfp + size;
 
+	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
+
 	/*
 	 * Zero length symlinks should never occur in memory as they are
 	 * never allowed to exist on disk.
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index b87c2214623383..fab4015f6a9506 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1024,6 +1024,30 @@ xrep_dinode_bad_metabt_fork(
 	return false;
 }
 
+static xfs_failaddr_t
+xrep_symlink_shortform_verify(
+	void			*sfp,
+	int64_t			size)
+{
+	/*
+	 * Zero length symlinks should never occur in memory as they are
+	 * never allowed to exist on disk.
+	 */
+	if (!size)
+		return __this_address;
+
+	/* No negative sizes or overly long symlink targets. */
+	if (size < 0 || size > XFS_SYMLINK_MAXLEN)
+		return __this_address;
+
+	/* No NULLs in the target either. */
+	if (memchr(sfp, 0, size))
+		return __this_address;
+
+	/* ondisk symlink target isn't null terminated, unlike incore */
+	return NULL;
+}
+
 /*
  * Check the data fork for things that will fail the ifork verifiers or the
  * ifork formatters.
@@ -1099,7 +1123,7 @@ xrep_dinode_check_dfork(
 			return true;
 		/* symlink structure must pass verification. */
 		if (S_ISLNK(mode) &&
-		    xfs_symlink_shortform_verify(dfork_ptr, data_size) != NULL)
+		    xrep_symlink_shortform_verify(dfork_ptr, data_size) != NULL)
 			return true;
 		break;
 	case XFS_DINODE_FMT_EXTENTS:

