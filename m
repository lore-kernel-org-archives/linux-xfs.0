Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35DA3D76
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230497; cv=none; b=oTi8Rqxsu1J8MWVIUjFY7wRaN/bVnHuevH8eiWwS8cH5y+S/gAtkOUD/2eOab0uIEU/gnVQih0Y72pCbC0vokdTS4qlXgN6F7S2b7jdMNYaJJAioY4TimKimtKJbY7zIeZeiRl9mLJ2IEV/s1qubLQ4hWjsvMP+OjgrZAP9Bs1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230497; c=relaxed/simple;
	bh=BNlB6lhAAuqkdmOoYOzhyZiJCAjkJjoVn8KnVAho1Ls=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cMg5FDrHsJZSklxIfEV61KCi090VWsJPDb1idx88VTppvEJm3Z4+7SvRGDNVAHXGk7CuoZ5GlrmNqlBtemkEo/4i860RZ2tqPUTHS1H88CF60K84i0Dl5CiEb3ehIF575FnBHpZg7xOkT0CMpghcqgz/FOn+zqH7toeF6o3df90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GD/Thada; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GD/Thada"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2850AC113CC;
	Tue, 16 Apr 2024 01:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230497;
	bh=BNlB6lhAAuqkdmOoYOzhyZiJCAjkJjoVn8KnVAho1Ls=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GD/Thadatl6EHzALhOXHTh9A7PtviK8fQHCSsXcU0m0m1W/fcG0SjXEyXOs6Ml+0L
	 zCCdYj+ON5iAZkrDzJmRKJoMBLw2SIvk/n/Wmk3Ts+8PwrVilfj7E8FWRG1Sis+xXt
	 e/yBwUBidPeFIWS+O80nfLJwWhNHI/B2DAZwxfc/ovPyZ+7H9640sAvHEIi4aJpDC7
	 X4nStJW4XzosjhzKlIQAITCapZoBN3Dd1FqLTMDCT2tl5ILDYoERMRordO2M11vflx
	 mvNk9LWPmQS36zo+ai+3pJ/Rkh79nMj625awkqN64h6R0j0JyAMujhNCii/OnIAFEk
	 LhPhL5BDvfneA==
Date: Mon, 15 Apr 2024 18:21:36 -0700
Subject: [PATCH 2/5] xfs: remove XFS_DA_OP_NOTIME
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de,
 hch@infradead.org
Message-ID: <171323026620.250975.4922309328779668793.stgit@frogsfrogsfrogs>
In-Reply-To: <171323026574.250975.15677672233833244634.stgit@frogsfrogsfrogs>
References: <171323026574.250975.15677672233833244634.stgit@frogsfrogsfrogs>
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

The only user of this flag sets it prior to an xfs_attr_get_ilocked
call, which doesn't update anything.  Get rid of the flag.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c     |    5 ++---
 fs/xfs/libxfs/xfs_da_btree.h |    6 ++----
 fs/xfs/scrub/attr.c          |    1 -
 3 files changed, 4 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 05d22c5e38855..30e6084122d8b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -365,7 +365,7 @@ xfs_attr_try_sf_addname(
 	 * Commit the shortform mods, and we're done.
 	 * NOTE: this is also the error path (EEXIST, etc).
 	 */
-	if (!error && !(args->op_flags & XFS_DA_OP_NOTIME))
+	if (!error)
 		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
 
 	if (xfs_has_wsync(dp->i_mount))
@@ -1033,8 +1033,7 @@ xfs_attr_set(
 	if (xfs_has_wsync(mp))
 		xfs_trans_set_sync(args->trans);
 
-	if (!(args->op_flags & XFS_DA_OP_NOTIME))
-		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
+	xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
 
 	/*
 	 * Commit the last in the sequence of transactions.
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 76e764080d994..b04a3290ffacc 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -90,9 +90,8 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_ADDNAME	(1u << 2) /* this is an add operation */
 #define XFS_DA_OP_OKNOENT	(1u << 3) /* lookup op, ENOENT ok, else die */
 #define XFS_DA_OP_CILOOKUP	(1u << 4) /* lookup returns CI name if found */
-#define XFS_DA_OP_NOTIME	(1u << 5) /* don't update inode timestamps */
-#define XFS_DA_OP_RECOVERY	(1u << 6) /* Log recovery operation */
-#define XFS_DA_OP_LOGGED	(1u << 7) /* Use intent items to track op */
+#define XFS_DA_OP_RECOVERY	(1u << 5) /* Log recovery operation */
+#define XFS_DA_OP_LOGGED	(1u << 6) /* Use intent items to track op */
 
 #define XFS_DA_OP_FLAGS \
 	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
@@ -100,7 +99,6 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
 	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
 	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
-	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
 	{ XFS_DA_OP_RECOVERY,	"RECOVERY" }, \
 	{ XFS_DA_OP_LOGGED,	"LOGGED" }
 
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 8853e4d0eee3d..5b855d7c98211 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -173,7 +173,6 @@ xchk_xattr_actor(
 	void			*priv)
 {
 	struct xfs_da_args		args = {
-		.op_flags		= XFS_DA_OP_NOTIME,
 		.attr_filter		= attr_flags & XFS_ATTR_NSP_ONDISK_MASK,
 		.geo			= sc->mp->m_attr_geo,
 		.whichfork		= XFS_ATTR_FORK,

