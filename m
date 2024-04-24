Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30FD13B5AC
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928966; cv=none; b=sEUEpsjMsM9k4yBKPKjEuEvPpDSUpgdrt9vkPHPEZkj9tGe98xbTJdvhRBmB/W8O0t46YGVuEEtQ5ufzmZVyavdtxbdMmx/tvThqZt53HXIuORy5E+LnH7LCd6HQrHB6XR7I4OTW4dKDuhEYkJj650d5fH67ojnx3Wla89Ir3KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928966; c=relaxed/simple;
	bh=eQBToONpcCM7Kin+9GOF8oa/TwWfOh/ixxbCCRx2TxA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F2XrJmUP9AH+myNPMapOxbNxa7oyZm5w65cd/icjF95ok6PG73z0fpG6mY7DjS9sSPCkXLShEBRH3lqiqwvR2/uc1a+wkjlxp4O/9rnKECsSGUitv7DIYzn7D3XKuSpCI9I/2xfRNXKcDXb4s+aOtKVqjM0Exwj6tHyTK6D0wpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jH0Acr8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jH0Acr8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6CFC116B1;
	Wed, 24 Apr 2024 03:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928966;
	bh=eQBToONpcCM7Kin+9GOF8oa/TwWfOh/ixxbCCRx2TxA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jH0Acr8FCBVrbTuzpz/poPdFZIKoCAJq5E6eO/8NPs04eUVuOMsRGdVokeNtwvY9v
	 gIk98AuuGcOjceJQ+sqIgZpDRN49r5NR+OXTvEWOWwCjC+DqY91A8CW3uz8IOBB/2l
	 CGj72yLLx+aaZb+D2OzgwX4244XF/noe18cYwgeNxo/ISykg1prxEwOur/Y31MSbR4
	 A3eTrLtXyRAt28daXuKF9G6rF1g9LUO3DKdTQeV9DsoBOSdHlju7GZyNOqzFtFsLPw
	 LH+o8CzDKHE6GPaY11dQfZIYUzWJ/iSWRa05UGL8/1TH1XxEt8/zB8XU0IcNSwmNxA
	 l4pVzuzU32ezg==
Date: Tue, 23 Apr 2024 20:22:45 -0700
Subject: [PATCH 02/16] xfs: make the reserved block permission flag explicit
 in xfs_attr_set
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392784684.1906420.14364946667967275991.stgit@frogsfrogsfrogs>
In-Reply-To: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
References: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c   |    6 +++---
 fs/xfs/libxfs/xfs_attr.h   |    2 +-
 fs/xfs/scrub/attr_repair.c |    2 +-
 fs/xfs/xfs_xattr.c         |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index df8418671c37..c98145596f02 100644
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
index d12583dd7eec..43dee4cbaab2 100644
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
index 67c0ec0d1dbb..cbcc446d5119 100644
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
index bbdbe9026658..ab3d22f662f2 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -110,7 +110,7 @@ xfs_attr_change(
 	args->whichfork = XFS_ATTR_FORK;
 	xfs_attr_sethash(args);
 
-	return xfs_attr_set(args, op);
+	return xfs_attr_set(args, op, args->attr_filter & XFS_ATTR_ROOT);
 }
 
 

