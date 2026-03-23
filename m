Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAE1329373
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291654; cv=none; b=qCUtfKU6QdEf9rXkjAWZBuxyjpcyglXmmSaZYOITwCdd8WxXB0e2EhE+NekpnW8c09aILpmSJUlpFSOcL+rXf07vwsYbcmfcAqhtGNEm17BXmTL66NM67tdP0TdoONqxbhBn2jPtB8yMYWqxZL88uPGIQYPng6SfZXWzgyBe+ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291654; c=relaxed/simple;
	bh=O6T0JzH4mxM5o7cHfXj/nJnzEjzGCa9FKhM5FSil7tI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MXOr5nzquku42ByYIvVoEbRkdExg+uGIDBNdnVJYY4AVSsi3vjR8waY241p/Oq+6NY+jFfr0c+USWwcHPlZGJXH83nQFyxPDP/rYYCC3MkxVVbL9rkIq1c6J+xJkBDlsEeNreusdSqP7Cs8P7KSMaQl9f7ESFRNQHE9Tm8TfcMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ggAEauhs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ggAEauhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEACC2BC87;
	Mon, 23 Mar 2026 18:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291654;
	bh=O6T0JzH4mxM5o7cHfXj/nJnzEjzGCa9FKhM5FSil7tI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ggAEauhsFj16vWyszFvLTo8u7lpUZA2bShid49rrLOn4Ch17wM+/yyVAKqKqYkVLW
	 8IkDQlIxHWCR6QWtL6M+H2mTKqE45DA5VDFUHGSFKFTEKlr7szBRcxOqSUgRImEdtw
	 XXKC97CS5itFWS6mQSQrzimNL8kXr2Al3Mu1oaS1Tb9DSaTFXZSmbag4B6XhwizrH8
	 sM5L+Tn2V3dV8sdtcOdvfiYW6dwkpCIH7B4thqGbtiB1qxggozsUmitJutdo8lSJLv
	 3XTDvsnPdEb5cqvsBrLg74h+w03OPs9B5c3ZIBk9pbsoUizEYAN7+PfXzqKLuc5yUJ
	 4sCDWurgYUGMg==
Date: Mon, 23 Mar 2026 11:47:33 -0700
Subject: [PATCH 24/40] xfs: reduce xfs_attr_try_sf_addname parameters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177429121181.2266274.17157195926637473510.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 1ef7729df1f0c5f7bb63a121164f54d376d35835

The dp parameter to this function is an alias of args->dp, so remove it
for clarity before we go adding new callers.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index baf617cfeabe00..175f8572b0f930 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -349,16 +349,14 @@ xfs_attr_set_resv(
  */
 STATIC int
 xfs_attr_try_sf_addname(
-	struct xfs_inode	*dp,
 	struct xfs_da_args	*args)
 {
-
 	int			error;
 
 	/*
 	 * Build initial attribute list (if required).
 	 */
-	if (dp->i_af.if_format == XFS_DINODE_FMT_EXTENTS)
+	if (args->dp->i_af.if_format == XFS_DINODE_FMT_EXTENTS)
 		xfs_attr_shortform_create(args);
 
 	error = xfs_attr_shortform_addname(args);
@@ -370,9 +368,9 @@ xfs_attr_try_sf_addname(
 	 * NOTE: this is also the error path (EEXIST, etc).
 	 */
 	if (!error)
-		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
+		xfs_trans_ichgtime(args->trans, args->dp, XFS_ICHGTIME_CHG);
 
-	if (xfs_has_wsync(dp->i_mount))
+	if (xfs_has_wsync(args->dp->i_mount))
 		xfs_trans_set_sync(args->trans);
 
 	return error;
@@ -383,10 +381,9 @@ xfs_attr_sf_addname(
 	struct xfs_attr_intent		*attr)
 {
 	struct xfs_da_args		*args = attr->xattri_da_args;
-	struct xfs_inode		*dp = args->dp;
 	int				error = 0;
 
-	error = xfs_attr_try_sf_addname(dp, args);
+	error = xfs_attr_try_sf_addname(args);
 	if (error != -ENOSPC) {
 		ASSERT(!error || error == -EEXIST);
 		attr->xattri_dela_state = XFS_DAS_DONE;

