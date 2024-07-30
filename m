Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18E77464
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300263; cv=none; b=LqH23axrI56itssbwEgV9VRBmd9Ti0lcPGQFZf4alQit6hIVGbkskLSLK23/jYuitqs0wfOFFh8knH4NnL41nWSOoCePJeAkP4G3v+zMn7d53Cbk2tmPvISVtKy7pwj3YQefudJRxHyeTfywWfUHbguslKQtgnccnC4reEfjnrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300263; c=relaxed/simple;
	bh=QehzYRNJsQct/7VL7lk7XSEQLyuRMNW73amHXmQJOFk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R8FvgC7rRCVcvf+Ff335mfnUaXntNBB27hlt4Tsb1xGjesbK0yWUFLEXojlS0Jzx25N21m2/3wXXTtywWovbJiSimFqRTjBGXiXphUvGh2aChbbmOh9OFerAeRnKgUbjGUcQ6ASUY6tqctQRMGAqtTs//uGlka/tl2COQrQMRhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lxHOKHrp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lxHOKHrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943FDC32786;
	Tue, 30 Jul 2024 00:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300263;
	bh=QehzYRNJsQct/7VL7lk7XSEQLyuRMNW73amHXmQJOFk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lxHOKHrpcrbTeomaRKtsHnirOPwLi76lRuEVFNlA13eAsK6OhIjqMvv6okzIDxk6j
	 UuKXTCwHUyW5+Cb9Vs5rJJSyw+Nj3bPpbzTnB1F7Q/WEMySJVvGAy5+3M0Y6QTxBIQ
	 mz8iXEBH99MQBoiON8a6nBZjdAyOcsB/wAPiLrfzBL01WzKDcqgEO4+ZTx4GxBqSmX
	 Dkxtxrz5skdPW5n3EAMvrKWE1Kzus9GYC7qP+0mLlBORwCFoSxPeviJO5tvynamAnp
	 IpvCMJ+ol1sXRWkpxduh0MqB6qafaO4iPLtiRCEc2YJ8nJyUVgWNsrRoF9XGcstjSC
	 gtYRBNLKSsQQA==
Date: Mon, 29 Jul 2024 17:44:23 -0700
Subject: [PATCH 079/115] xfs: make the reserved block permission flag explicit
 in xfs_attr_set
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843560.1338752.13394120078833193917.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: bf61c36a45d4c215994699a7a06a00c58d22e8a2

Make the use of reserved blocks an explicit parameter to xfs_attr_set.
Userspace setting XFS_ATTR_ROOT attrs should continue to be able to use
it, but for online repairs we can back out and therefore do not care.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/attrset.c      |    4 ++--
 libxfs/xfs_attr.c |    6 +++---
 libxfs/xfs_attr.h |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/db/attrset.c b/db/attrset.c
index a59d5473e..3b5db7c2a 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -161,7 +161,7 @@ attr_set_f(
 		goto out;
 	}
 
-	if (libxfs_attr_set(&args, op)) {
+	if (libxfs_attr_set(&args, op, false)) {
 		dbprintf(_("failed to set attr %s on inode %llu\n"),
 			args.name, (unsigned long long)iocur_top->ino);
 		goto out;
@@ -247,7 +247,7 @@ attr_remove_f(
 		goto out;
 	}
 
-	if (libxfs_attr_set(&args, XFS_ATTRUPDATE_REMOVE)) {
+	if (libxfs_attr_set(&args, XFS_ATTRUPDATE_REMOVE, false)) {
 		dbprintf(_("failed to remove attr %s from inode %llu\n"),
 			(unsigned char *)args.name,
 			(unsigned long long)iocur_top->ino);
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 1034579a1..32dd7bcf5 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -951,7 +951,7 @@ xfs_attr_lookup(
  * Make a change to the xattr structure.
  *
  * The caller must have initialized @args, attached dquots, and must not hold
- * any ILOCKs.
+ * any ILOCKs.  Reserved data blocks may be used if @rsvd is set.
  *
  * Returns -EEXIST for XFS_ATTRUPDATE_CREATE if the name already exists.
  * Returns -ENOATTR for XFS_ATTRUPDATE_REMOVE if the name does not exist.
@@ -960,12 +960,12 @@ xfs_attr_lookup(
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
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index d12583dd7..43dee4cba 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -558,7 +558,7 @@ enum xfs_attr_update {
 	XFS_ATTRUPDATE_REPLACE,	/* set value, fail if attr does not exist */
 };
 
-int xfs_attr_set(struct xfs_da_args *args, enum xfs_attr_update op);
+int xfs_attr_set(struct xfs_da_args *args, enum xfs_attr_update op, bool rsvd);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
 bool xfs_attr_check_namespace(unsigned int attr_flags);

