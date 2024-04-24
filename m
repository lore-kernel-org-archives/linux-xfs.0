Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9748F47
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928480; cv=none; b=jWrRn4NZzFQHgFogeDkLnLDW116d46CjmTxZXFue/0+ipp9gK5/788nlvJNrwW+CkwZpvqoXwKf0W6XksxPfz2Atnc3qT3DPCjstIqpx3eZJDgSVj1IeODW8OuP5tnLrEhdr7bac55WRFLfvxtg8/fazeAjJacvoYFQ/07ctPA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928480; c=relaxed/simple;
	bh=9dQKWzfxi/TbZ+3UFAnZetW+7e9D5IaU3YfAT33FTTs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jY/4ywUguWlDBHkDvi4sDXFmxIZfxCP9HvO8biOVnpVCO6vpCIXC0aarfB92Zpw5V+hq5IPIPWpXAzIRwoMkbCtpTx0lhE/TFkbOVk9Uq7PMU/gw3ZjjNKvv4TYYFZs7vpuopgAXsHkVeE9I8EUrv8nToWORDP14THuYNj0yq8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ex/aEH+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ex/aEH+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4323C116B1;
	Wed, 24 Apr 2024 03:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928480;
	bh=9dQKWzfxi/TbZ+3UFAnZetW+7e9D5IaU3YfAT33FTTs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ex/aEH+r6mOeh3ak6wrWijtpHfsaGlCXa80+1XgsFFe1RqG1tluyVq5Ro4+L+kbqo
	 hekA+edV8o4rgYIMzh1fOltuXwwip1gwX6wWfavIS+9H1ys/SZ/6OF6v67ODN2p9+n
	 ss+JxCOdXSZXBxzkGVJCeCWzTauN9cKJIMJAXMGanPhl6VM/0PV2ff8uYGZLNUhwC2
	 0pYihQFvUrmMLylQx0SNxJOEzNXWD0W1Dzdd/RxF+U5zO0RkzEqcj90zwmjU+7ziZc
	 mMtrLWrEisN7tqkxPVNheYfzowBMbK5bxbCeSUtIqg6MPIjD0NNMY+Tn4IGiITgXUR
	 TstADfPYZnNgQ==
Date: Tue, 23 Apr 2024 20:14:40 -0700
Subject: [PATCH 08/30] xfs: refactor xfs_is_using_logged_xattrs checks in attr
 item recovery
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392783401.1905110.745513040348283039.stgit@frogsfrogsfrogs>
In-Reply-To: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
References: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr_item.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 4a57bcff49eb..413e3d3959a5 100644
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

