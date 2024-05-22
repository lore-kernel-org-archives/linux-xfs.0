Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E4B1EA91
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347269; cv=none; b=oYhxlKUZmxuf2/UO4qMxyHR2sMayMEeJJsqnTBC/raTOnmcNtmcPl8/CSQZmtFygj1mPO7wGycMprr3iqL9w6YrDpL5KT+wpj1ymGuBayYhnLevh/znlFzSUw4/nBZWhhlAmvLJ19xAYExIJWBXsREu2iVy9e5F+IOlpuB8zUFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347269; c=relaxed/simple;
	bh=bz2wsYXVzdGVSIxa/DP+J1iWf8jRyEHOJnG8x0oa6Wg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V/9Rc0ZS0azdaIDerjaxscWdc/s0Hnhqz+rgSHTQagSoKZ+i9Cvdjnnc8ST11hh46ND7f1BrJmp+NmZXtxUvWp4uoA0npnx1BWkCfzKnO3yF8O1j4JmSCMj0HKJf34FR82lIfl+wTVJv0V5GmQTRUd+BL6LH1E2cHqMZEhgrK5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p1CQTLFm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p1CQTLFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB64C2BD11;
	Wed, 22 May 2024 03:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347269;
	bh=bz2wsYXVzdGVSIxa/DP+J1iWf8jRyEHOJnG8x0oa6Wg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p1CQTLFmWT6KVxvX1s+A8f53wdKA+tyVmKqL9W9169dUMUPUtk98vdFx2l1ibs+Tk
	 G3FSLJ/vtvuY9Vd9yWlm/LzKEf9lxDEzMVeRpGx5EapKI55B/uF6pclEPm17q/6Lev
	 taxzfZwQihsGN+zK0rlnwK9ZsoHm8J0cppaFaA8KVKgXEF+j09wXhE5L5ULXCY9335
	 e/0w+mFJ0WUfaPYnjql5DI51gGVavbrLm+MVckIOUj6H9R14EhFk5R+78o5I/9Rm5f
	 3bI90r5BSMfGLl3/DKpioKxJj7jXevP0AFI10SbW/nWBiQqRlcC9PvxFre4EpBaf+z
	 M+m1TU4D7+c0w==
Date: Tue, 21 May 2024 20:07:48 -0700
Subject: [PATCH 073/111] xfs: pass a 'bool is_finobt' to xfs_inobt_insert
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532793.2478931.17614922504671952263.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: fbeef4e061ab28bf556af4ee2a5a9848dc4616c5

This is one of the last users of xfs_btnum_t and can only designate
either the inobt or finobt.  Replace it with a simple bool.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ialloc.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 37d014713..296548bc1 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -201,14 +201,14 @@ xfs_inobt_insert(
 	struct xfs_buf		*agbp,
 	xfs_agino_t		newino,
 	xfs_agino_t		newlen,
-	xfs_btnum_t		btnum)
+	bool			is_finobt)
 {
 	struct xfs_btree_cur	*cur;
 	xfs_agino_t		thisino;
 	int			i;
 	int			error;
 
-	if (btnum == XFS_BTNUM_FINO)
+	if (is_finobt)
 		cur = xfs_finobt_init_cursor(pag, tp, agbp);
 	else
 		cur = xfs_inobt_init_cursor(pag, tp, agbp);
@@ -936,14 +936,13 @@ xfs_ialloc_ag_alloc(
 		}
 	} else {
 		/* full chunk - insert new records to both btrees */
-		error = xfs_inobt_insert(pag, tp, agbp, newino, newlen,
-					 XFS_BTNUM_INO);
+		error = xfs_inobt_insert(pag, tp, agbp, newino, newlen, false);
 		if (error)
 			return error;
 
 		if (xfs_has_finobt(args.mp)) {
 			error = xfs_inobt_insert(pag, tp, agbp, newino,
-						 newlen, XFS_BTNUM_FINO);
+						 newlen, true);
 			if (error)
 				return error;
 		}

