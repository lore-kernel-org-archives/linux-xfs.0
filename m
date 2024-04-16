Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C620CA7A
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231388; cv=none; b=ThvnE7FCB3p9SjtdtgxllW4wzTOiRAxtl/a4FYP/fOGLVqPEUrIHAn0b/QmIWRNWheD9twgTYFdSBxeCIWL3aNiYGkXVZ8c3wWyI3BT0BETSEz/TBQUgM2m4pocn7RRTM6qeIQ8/SwQc0m9L/PpPHD/dbE109xTEzFzfvrLSHOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231388; c=relaxed/simple;
	bh=LQR8aW4nbtsPVI/YFXIuETcqJMVOULWfjk1pWuj9lw0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kUVJOAk2364nqaVNOHMiohU74XNlqmpmHgZmCrlm9i2X/ZpnPmAi/ROMz7y6Yfe4wic3Kc+IS1wnJmtAML8XYG+P1nLfGeKg8YN2508DE23o5sWEfUHWIvVleBxlQY7uY3pilX+1SucXnJEZtiL3FbgT/wYZueWhQmZOPKbREvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lQZ9mhoY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lQZ9mhoY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693F1C113CC;
	Tue, 16 Apr 2024 01:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231388;
	bh=LQR8aW4nbtsPVI/YFXIuETcqJMVOULWfjk1pWuj9lw0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lQZ9mhoY4JJO8W/w3gO0H9292MGsWy1udDKB4pPNNlk+GwYGRAbiA8M5DUUngJyC4
	 k/iXqerBb3cUjTA1LK+DyiDSGlTf+529oJ6kr/swumNIJSGXiwyn9xkfLSaa+/7chN
	 /IGwrhZG238uVyViltlTdTsKdmjRfUo3QGDFT/Lif8fwimmtKmWxFfPXVN/9NMr3o8
	 mTuqeOv2Om2Xk/Vep6Ol+gmZjPQmb8I7fTOWNypywSlLBBLw2oHZqcWMo3pb7o0e+Z
	 sAJ5ZQmZGHwdNniVgbiAdibM6U9g8+PlWUMh+pNylfvQ/Dn02zqmFLkGO5dkpS7B3+
	 WDZCAqTsk1blA==
Date: Mon, 15 Apr 2024 18:36:27 -0700
Subject: [PATCH 02/17] xfs: make the reserved block permission flag explicit
 in xfs_attr_set
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, hch@infradead.org,
 linux-xfs@vger.kernel.org, catherine.hoang@oracle.com, hch@lst.de
Message-ID: <171323029218.253068.3901233919366892527.stgit@frogsfrogsfrogs>
In-Reply-To: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
References: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
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

Make the use of reserved blocks an explicit parameter to xfs_attr_set.
Userspace setting XFS_ATTR_ROOT attrs should continue to be able to use
it, but for online repairs we can back out and therefore do not care.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c   |    6 +++---
 fs/xfs/libxfs/xfs_attr.h   |    2 +-
 fs/xfs/scrub/attr_repair.c |    2 +-
 fs/xfs/xfs_xattr.c         |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index df8418671c379..c98145596f029 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -952,7 +952,7 @@ xfs_attr_lookup(
  * Make a change to the xattr structure.
  *
  * The caller must have initialized @args, attached dquots, and must not hold
- * any ILOCKs.
+ * any ILOCKs.  Reserved data blocks may be used if @rsvd is set.
  *
  * Returns -EEXIST for XFS_ATTRUPDATE_CREATE if the name already exists.
  * Returns -ENOATTR for XFS_ATTRUPDATE_REMOVE if the name does not exist.
@@ -961,12 +961,12 @@ xfs_attr_lookup(
 int
 xfs_attr_set(
 	struct xfs_da_args	*args,
-	enum xfs_attr_update	op)
+	enum xfs_attr_update	op,
+	bool			rsvd)
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans_res	tres;
-	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index d12583dd7eecb..43dee4cbaab25 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -558,7 +558,7 @@ enum xfs_attr_update {
 	XFS_ATTRUPDATE_REPLACE,	/* set value, fail if attr does not exist */
 };
 
-int xfs_attr_set(struct xfs_da_args *args, enum xfs_attr_update op);
+int xfs_attr_set(struct xfs_da_args *args, enum xfs_attr_update op, bool rsvd);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
 bool xfs_attr_check_namespace(unsigned int attr_flags);
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 67c0ec0d1dbba..cbcc446d5119b 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -606,7 +606,7 @@ xrep_xattr_insert_rec(
 	 * already exists, we'll just drop it during the rebuild.
 	 */
 	xfs_attr_sethash(&args);
-	error = xfs_attr_set(&args, XFS_ATTRUPDATE_CREATE);
+	error = xfs_attr_set(&args, XFS_ATTRUPDATE_CREATE, false);
 	if (error == -EEXIST)
 		error = 0;
 
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index bf0cbcd7567e8..d7092efe284a7 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -110,7 +110,7 @@ xfs_attr_change(
 	args->whichfork = XFS_ATTR_FORK;
 	xfs_attr_sethash(args);
 
-	return xfs_attr_set(args, op);
+	return xfs_attr_set(args, op, args->attr_filter & XFS_ATTR_ROOT);
 }
 
 

