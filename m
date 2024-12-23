Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973F81AE01E
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991969; cv=none; b=XgZojC4vUqmUI3DMTNUTeG1wXSAv+s9BQW/wZH9fB27CxBTvb42TwLhsJ8L/UDZ0j85aVE1x7ocmZM9uN3UgRSQqYqDzTFi/b6o7bhJVcOWcOFvLG8A+VKHBUe3cZ6psTLjwo+R01t5XkSHGwKJ9BH5E8s3LyxQdmGM2pCKL9JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991969; c=relaxed/simple;
	bh=nGZitKSXFUpcYP6YVnkdJjmB5rudbsJA2GxWbp3rlL4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OXC2MV0nR93EIE+w6lbvJuIve4OY0MTrte40yhlF+ugmn3X2dWKCdCoCHqiknULifRm9kC02y3/J6t5B+KS5fy/1CuC8tHaHOIK3Ohrk9zUaB2RGwTyJO1XBCBXCURdS0V0LrvMRnqhD2WtDQX8l6TdZ3U/o7d+jC4m/v090Ih4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MNAluxox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MNAluxox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F58C4CED3;
	Mon, 23 Dec 2024 22:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991969;
	bh=nGZitKSXFUpcYP6YVnkdJjmB5rudbsJA2GxWbp3rlL4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MNAluxoxOj6jh7NUYr50enLNDb17NXvxVSdeCwO9ufMougVoHivTGb4Ryutte4EaU
	 KGHnHpiXJMRvI+0F2Rhrcol4cLjFjc/fjpHl2756cLxXsA6TdqHB+Ch28uyw+MuJeU
	 21XKBGjwJqVToO+7HNMgiJ3xvy7e8GmB9r0Y7VyfUYRMVqE7+ycz/4am5GCodj+Y65
	 V6gAqC3XtlK8OjsLdAeooABCChovUMQtAbdr+E0FqjnY3LWS+3D+LY9yD5cdviSz4p
	 59Y9/PuzbG4B5YAWIa00P8nbUmSaXJ27G9CyWq8oCumzcuFAlDBrPzPFoKb7F2vL+N
	 Uxx8DFwGzE/Tg==
Date: Mon, 23 Dec 2024 14:12:48 -0800
Subject: [PATCH 04/51] libxfs: use correct rtx count to block count conversion
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943864.2297565.3880168792039008642.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Fix a place where we use the wrong conversion functions to convert
between a number of rt extents and a number of rt blocks.  This isn't
really necessary since userspace cannot allocate rt extents, but let's
not leave a logic bomb.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/trans.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/trans.c b/libxfs/trans.c
index 01834eff4b77ca..5c896ba1661b10 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -1202,7 +1202,7 @@ libxfs_trans_alloc_inode(
 	int			error;
 
 	error = libxfs_trans_alloc(mp, resv, dblocks,
-			xfs_rtb_to_rtx(mp, rblocks),
+			xfs_extlen_to_rtxlen(mp, rblocks),
 			force ? XFS_TRANS_RESERVE : 0, &tp);
 	if (error)
 		return error;

