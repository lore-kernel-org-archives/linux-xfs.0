Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5C7BE4D
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928167; cv=none; b=ksFGVFdq/RR9IKOs7VnTFR11uCc6PTtAj9+Rn+x6CksRAS2b0XKuHMY+BK6wQGciIukOyNNU2yiXe93x/fQNKzRw2yBhdP8Rv6R8NP25mo798AqABAwrV0Xori9TsVE7iaE65q4MgJzajBKblHEkO/0cLXwSARJqQsliJ06+2eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928167; c=relaxed/simple;
	bh=vWN/ijRkLcPRrO7VQ1ryD+3nkebvQZh7L6xqrl82czQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CqBGNRQ4Bv6p/s4kP0imDl+PiDmsgr0Hu9KkT0BW5nIV06SEpUo/1ovGl9QIMGBx992fNQVweUhvjZIaboxmHk992PU1U0DkWVy0n5zbOIFeEUxwFfUFF93rx0gd2MtzSH2tKIrwY+4Ppscx4H7hzeUj5uLisfr8+EIEpQj1DDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AW3x7P++; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AW3x7P++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0AFC116B1;
	Wed, 24 Apr 2024 03:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928167;
	bh=vWN/ijRkLcPRrO7VQ1ryD+3nkebvQZh7L6xqrl82czQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AW3x7P++wAPMpX2MHgHinKXb5q8sWCquJ5sy4uCJZP4iRRWmanVfwL0tLn18e2dhr
	 qUHjn1UBRiD5w63/99hhKUJZzOMFPV0PgL4X2CUo6znscVAmNH4regiNvSV/ppyf6n
	 l4xpPtv+/1DikXT0HqY3GFc8tQMCycQvruMNOnrdoS9DguWLtXoX467ZVwzMXQbJTl
	 trvhTvY4INQxwJEtl6DLymIkzrIiypGgRqiAb9XFKVjpzw6wjCxNjmmoVPST2tA4xc
	 4Gy2l5BOCidXlJTO62qOLgbe+MWGYHsWOgWKrauS/xubm/d1RwCeKc4m+ZZjzH1kbb
	 Gk8UTNWn3/fqA==
Date: Tue, 23 Apr 2024 20:09:27 -0700
Subject: [PATCH 02/14] xfs: require XFS_SB_FEAT_INCOMPAT_LOG_XATTRS for attr
 log intent item recovery
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392782607.1904599.6411799293904787575.stgit@frogsfrogsfrogs>
In-Reply-To: <171392782539.1904599.4346314665349138617.stgit@frogsfrogsfrogs>
References: <171392782539.1904599.4346314665349138617.stgit@frogsfrogsfrogs>
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

The XFS_SB_FEAT_INCOMPAT_LOG_XATTRS feature bit protects a filesystem
from old kernels that do not know how to recover extended attribute log
intent items.  Make this check mandatory instead of a debugging assert.

Fixes: fd920008784ea ("xfs: Set up infrastructure for log attribute replay")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr_item.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 541455731618..dfe7039dac98 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -469,6 +469,9 @@ xfs_attri_validate(
 	unsigned int			op = attrp->alfi_op_flags &
 					     XFS_ATTRI_OP_FLAGS_TYPE_MASK;
 
+	if (!xfs_sb_version_haslogxattrs(&mp->m_sb))
+		return false;
+
 	if (attrp->__pad != 0)
 		return false;
 
@@ -570,8 +573,6 @@ xfs_attri_recover_work(
 			 XFS_DA_OP_LOGGED;
 	args->owner = args->dp->i_ino;
 
-	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
-
 	switch (attr->xattri_op_flags) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:

