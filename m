Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A112F51A
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817147; cv=none; b=mbohwpd51Yo0FRn55zehqCFW7zfVHDLkiEGvzE6NsubA3vUWgeXwysdQbPlX08FAdogEStkkNBsslXf+oprkc0lrKLL3qUIJf5c6y4XU84/q4WDOuT9dMemE0d0Ygl4wYOUU+EGA01joINKqaYmYl91rbg412GciTdSl5wkABnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817147; c=relaxed/simple;
	bh=GSz6bZ652RpOTsYfX2KmeEEcCFtgSKDreIP965LRDoI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l5A//XRgV+OBj6F+KjxCcvstV6jTlAaZM/Yt2h9YrWc+YwjPLmjT8CGxkdq/ryU5flhd1ltMWP/8JKSz1yxvzr3zGac28r1XECNd3B/uIHwS3LTs23oBOEdww3HK3hejf21pcmOGeQ7nA9rFzhYpMU/sdTwX7DzlwXM1VbHRFqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ddifkw6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ddifkw6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D830FC43394;
	Thu,  1 Feb 2024 19:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817146;
	bh=GSz6bZ652RpOTsYfX2KmeEEcCFtgSKDreIP965LRDoI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ddifkw6NxQ+mHYoD2WHyrHTLaaYuAvPIE1d4TaqgLfuqBQ35+txxZXtaTHttm5B1P
	 o0sYFDUzf0/9oT6HrHIM+u7/4eaW3dh4vGShlmgdorDjWbTodqQ6p0J0Nm6flm9O3b
	 rIVc+IwR1FXFPv6VSHjrc4AHafX8QbT1P+vyFHUcOp4ATEL+xdKdTBMNeay6KSMD8G
	 RxSquWc5UMhMh/ChP3c+2erndl7Z5fn9WudSyDQD+NFdz755hxrx/TNNYGC89ZRlSN
	 YvYpvDEXTQIhUfo/aaxr/HrJz327nlGvMF+/TIVUWwgB1PkaT4xYf/lO/uJSLjSZe1
	 6IcUKKZzRbFYg==
Date: Thu, 01 Feb 2024 11:52:26 -0800
Subject: [PATCH 26/27] xfs: pass a 'bool is_finobt' to xfs_inobt_insert
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335211.1605438.3049996043256623709.stgit@frogsfrogsfrogs>
In-Reply-To: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
References: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
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

This is one of the last users of xfs_btnum_t and can only designate
either the inobt or finobt.  Replace it with a simple bool.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 03af7a729980b..e6decc37ff18b 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -206,14 +206,14 @@ xfs_inobt_insert(
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
@@ -941,14 +941,13 @@ xfs_ialloc_ag_alloc(
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

