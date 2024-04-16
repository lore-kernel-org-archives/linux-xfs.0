Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646F45227
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230888; cv=none; b=ABt9NUZ2b1xb8HeFowPePrkOHyioIETyujgz7K4X8IHKlaKv1X/0Vfr82LMAt3TIhk4tLcCv497wEac1rtDa8P0cvqzOrxmYfMBGX124rOdBVbL1fFeIXCtVmEwOa2ztxUvPqqyEuKtSa5SO+a/wKcPOLdLhSmZq82B0wzad9bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230888; c=relaxed/simple;
	bh=fwordYlUU7H5WFuzCKL7H5C4yQ/qx13fikbHOQzvsWI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hia7fgzXqb2tCMVHLC3kWUFItFj+IGCUW0zXv5PnU8vyelqyyYeTLPQoHT6Uo/+8JfkYesuYhvpoP12BzyNga4IiXHSXrMymV6oJk55DKESF8vZJ4K1dJNwgD72wPnCHGUq+fLwP0UTiGcdSM4pQ2IKRxCvaoAryORLMqLYEjpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XtI6svn/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XtI6svn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4386DC113CC;
	Tue, 16 Apr 2024 01:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230888;
	bh=fwordYlUU7H5WFuzCKL7H5C4yQ/qx13fikbHOQzvsWI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XtI6svn/5suVQDdUPZf1BM6rSBvRan/XwFbZ0C6jc7S2hg3LrUp6mFkkKxbr8Qtn3
	 lzFijhRf2iIJvmuz8AfOhIzbDxM+pmeB/bI9pMHyvAX0NOpt60V/iIowvUSkHoHmdG
	 0Ss1ItuJRDssQiZOAqQrC9LrBKI8JKILj8L+fLWJTH5vbomnS0NgTevs0bqOVftAgd
	 KwqthdJzcPD1xacQY2lEgB7ASf6hZR1gLXEfEFKs7TSyU6MNu4tD99Y1v1MWea8jvM
	 zHFJgPV4VB3k8iaIf35/hfLDr0Bzc6XV6OH1quB1/fOAvHTeg1xQadKzj5yQzBLySE
	 i/5TnZHklAPCQ==
Date: Mon, 15 Apr 2024 18:28:07 -0700
Subject: [PATCH 08/31] xfs: refactor xfs_is_using_logged_xattrs checks in attr
 item recovery
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, hch@infradead.org,
 linux-xfs@vger.kernel.org, catherine.hoang@oracle.com, hch@lst.de
Message-ID: <171323027916.251715.1558174624449458545.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
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

Move this feature check down to the per-op checks so that we can ensure
that we never see parent pointer attr items on non-pptr filesystems, and
that logged xattrs are turned on for non-pptr attr items.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 4a57bcff49ebd..413e3d3959a5d 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -480,9 +480,6 @@ xfs_attri_validate(
 {
 	unsigned int			op = xfs_attr_log_item_op(attrp);
 
-	if (!xfs_is_using_logged_xattrs(mp))
-		return false;
-
 	if (attrp->__pad != 0)
 		return false;
 
@@ -499,12 +496,16 @@ xfs_attri_validate(
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		if (!xfs_is_using_logged_xattrs(mp))
+			return false;
 		if (attrp->alfi_value_len > XATTR_SIZE_MAX)
 			return false;
 		if (!xfs_attri_validate_namelen(attrp->alfi_name_len))
 			return false;
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		if (!xfs_is_using_logged_xattrs(mp))
+			return false;
 		if (attrp->alfi_value_len != 0)
 			return false;
 		if (!xfs_attri_validate_namelen(attrp->alfi_name_len))

