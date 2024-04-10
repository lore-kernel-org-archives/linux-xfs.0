Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7429E621
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710536; cv=none; b=M9uOZU7Lun4Ka69M1ksxNeD6OFyAWj5vR1CmsYKu9rCML/yrT2wv6RkCh/vnqoYzkKl1/X3LonopS0wC/45vw6kskPByVfRutOj/FG6m4uLbSn0+jQfkKTPPqWXxAc21WZPnhuJNEhZ463ZcD4EuIjJhGVPGhz8VA87u3czsZ6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710536; c=relaxed/simple;
	bh=Rq3d4BieCM/c//9fMVm/pTz9Kd4VlppaVN+NHq1Mbp8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EXu3VkOhKaQWFnX053FTWfhViuYbMwPjyAIZAUJbdrEIV6m/uXkT3wFQh2AjLRJMd95GKwlErQub3+ZQBSvlk7HWiCKFIIEHj4OseC8WYNCVCvlLWyopj8+L74CtZVis7dNbGs9BGK4InTya8BNnGl9pGzgCaJSl1y8K+8gOSkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AEvUZDgb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AEvUZDgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D11C433C7;
	Wed, 10 Apr 2024 00:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710536;
	bh=Rq3d4BieCM/c//9fMVm/pTz9Kd4VlppaVN+NHq1Mbp8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AEvUZDgbQM3PQmEX26Z0f9xLilUbN+RT0FzbqtrpUhhmIHYXMw1vw9dmWaKGaNrG4
	 msVAKpWOg9ynLZDUiZ7PoaklcGWZZ8SRwOFM9ULZ3Sryxu6VIq7vEzifwTOJV7aG65
	 itLBrG1yvAyg43i50piYd4E/cLYobwYKQHq3pnXWs7khYLTUz8EDP6wj71OM9jKa0o
	 +QjO4BuIKkM5MwLwzOSZRjYEEkgLP1BDjS6TUG9/qwjvVMMX0iiT7Kj0pZAITXRO9R
	 jHGRRVjEML5tvcBQPdjdIhBfvQiAUzyPOFGzkZJwOeElNjdj9Xie3N26+0u5J9MwAj
	 TCcyXO9wBkXnw==
Date: Tue, 09 Apr 2024 17:55:35 -0700
Subject: [PATCH 08/32] xfs: allow logged xattr operations if parent pointers
 are enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270969690.3631889.15408823864477343629.stgit@frogsfrogsfrogs>
In-Reply-To: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
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

Don't trip this assertion about attr log items if we have parent
pointers enabled.  Parent pointers are an incompat feature that doesn't
use any of the functionality protected by
XFS_SB_FEAT_INCOMPAT_LOG_XATTRS, which is why this is ok.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 8f91016fc3cf8..c509bf841949f 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -474,7 +474,7 @@ xfs_attri_validate(
 {
 	unsigned int			op = xfs_attr_log_item_op(attrp);
 
-	if (!xfs_is_using_logged_xattrs(mp))
+	if (!xfs_is_using_logged_xattrs(mp) && !xfs_has_parent(mp))
 		return false;
 
 	if (attrp->__pad != 0)

