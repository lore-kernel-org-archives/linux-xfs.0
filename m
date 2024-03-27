Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDBF171AA
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504480; cv=none; b=l33gj+eWLPYMr6KDD3QhPTCSkMZyAD1v6pK0mK/PRaIvdg3naLAgH5vx+NvjtCFaYhR41wKhLnZNnLGd1WeGHF/5oI8cOswqo0EvyljW/jTRiLMcJAFx207WFCUfQL6re13+O82sY2g5srgcXitV9+F3x1W7ISsVNdo25ltcz1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504480; c=relaxed/simple;
	bh=d7ZQztzhv8NHZqQ9G3o53cTsLXEWNmxHYQP58H/0zu0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BP9Q9wgWD2fj+qkI6nzYJ9ZT+5Jd5CAkHATDcTaXIFk7dxkA/GZJJt5YqwwNtk/fWrQSDAwLEjL9vva9zow+ZLBmkXrSiU7rbBJFKBUYi6TQo1H0iw6fcVWeNEp+orQ8zvUJzWRMI+85t3qyFH5YPszJmVuOw5ahScOkpcJQCVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p1Ie0fwm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p1Ie0fwm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35003C433C7;
	Wed, 27 Mar 2024 01:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504480;
	bh=d7ZQztzhv8NHZqQ9G3o53cTsLXEWNmxHYQP58H/0zu0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p1Ie0fwm6nUuCeR9XCjrIkpfT4mCVrj/DpRid8QUwoYREy8IZ6N7QUoSozD50vYtE
	 UJvGvAVDQ9ME0eHJ5dkW3Z0ToxnaSZDFuJviwcHHKXhD+zRKljIBB58S6+wXA2BFXM
	 u7QUd39zQkfVcgy0/kYMX2ir1Bl49kvntm3EVL48lh/b+xobvNlXh8EDtLG2BpwY13
	 jypTO739HUdJ1G5oPCDWAKhjzTbyNIBU31c2a1qgSWIdK0RZ2D2pD1hJ6oMlGeeufF
	 lZgQcEVIpi16CYY2q8ctuhrkZukejL6dlUK7O0IR6xVZFO4D1TD05gHFFYTOG6Ir/b
	 /n8Lx/oCz2mMA==
Date: Tue, 26 Mar 2024 18:54:39 -0700
Subject: [PATCH 07/15] xfs: add error injection to test file mapping exchange
 recovery
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150380784.3216674.9801897546133053068.stgit@frogsfrogsfrogs>
In-Reply-To: <171150380628.3216674.10385855831925961243.stgit@frogsfrogsfrogs>
References: <171150380628.3216674.10385855831925961243.stgit@frogsfrogsfrogs>
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

Add an errortag so that we can test recovery of exchmaps log items.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_errortag.h |    4 +++-
 fs/xfs/libxfs/xfs_exchmaps.c |    3 +++
 fs/xfs/xfs_error.c           |    3 +++
 3 files changed, 9 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 01a9e86b30379..7002d7676a788 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -63,7 +63,8 @@
 #define XFS_ERRTAG_ATTR_LEAF_TO_NODE			41
 #define XFS_ERRTAG_WB_DELAY_MS				42
 #define XFS_ERRTAG_WRITE_DELAY_MS			43
-#define XFS_ERRTAG_MAX					44
+#define XFS_ERRTAG_EXCHMAPS_FINISH_ONE			44
+#define XFS_ERRTAG_MAX					45
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -111,5 +112,6 @@
 #define XFS_RANDOM_ATTR_LEAF_TO_NODE			1
 #define XFS_RANDOM_WB_DELAY_MS				3000
 #define XFS_RANDOM_WRITE_DELAY_MS			3000
+#define XFS_RANDOM_EXCHMAPS_FINISH_ONE			1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index df53103b98785..7b51771f81968 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -437,6 +437,9 @@ xfs_exchmaps_finish_one(
 			return error;
 	}
 
+	if (XFS_TEST_ERROR(false, tp->t_mountp, XFS_ERRTAG_EXCHMAPS_FINISH_ONE))
+		return -EIO;
+
 	/* If we still have work to do, ask for a new transaction. */
 	if (xmi_has_more_exchange_work(xmi) || xmi_has_postop_work(xmi)) {
 		trace_xfs_exchmaps_defer(tp->t_mountp, xmi);
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 7ad0e92c6b5b8..78cdc5064a8c4 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -62,6 +62,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_ATTR_LEAF_TO_NODE,
 	XFS_RANDOM_WB_DELAY_MS,
 	XFS_RANDOM_WRITE_DELAY_MS,
+	XFS_RANDOM_EXCHMAPS_FINISH_ONE,
 };
 
 struct xfs_errortag_attr {
@@ -179,6 +180,7 @@ XFS_ERRORTAG_ATTR_RW(da_leaf_split,	XFS_ERRTAG_DA_LEAF_SPLIT);
 XFS_ERRORTAG_ATTR_RW(attr_leaf_to_node,	XFS_ERRTAG_ATTR_LEAF_TO_NODE);
 XFS_ERRORTAG_ATTR_RW(wb_delay_ms,	XFS_ERRTAG_WB_DELAY_MS);
 XFS_ERRORTAG_ATTR_RW(write_delay_ms,	XFS_ERRTAG_WRITE_DELAY_MS);
+XFS_ERRORTAG_ATTR_RW(exchmaps_finish_one, XFS_ERRTAG_EXCHMAPS_FINISH_ONE);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -224,6 +226,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(attr_leaf_to_node),
 	XFS_ERRORTAG_ATTR_LIST(wb_delay_ms),
 	XFS_ERRORTAG_ATTR_LIST(write_delay_ms),
+	XFS_ERRORTAG_ATTR_LIST(exchmaps_finish_one),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_errortag);

