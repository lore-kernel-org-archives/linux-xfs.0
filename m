Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF748175A85
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291904; cv=none; b=IXnZYPathTFKtHTpG5Kq5dYbL7xYOERMbE+UFaAKBmWyZv03sEgyY7GnYdtOXnFTDvacTK9/TT4wQSdxpl+UV4zEoHgflTxdw4n0yq2cODpQiz2LxRHM0W1hccvstm1WEXwdbx+5UzIOmVpPscFkHswgHb6yam5Aba4H0ByoyiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291904; c=relaxed/simple;
	bh=siAwkY6JYMLWgzMwr4BP8MB0tr5Jyhi42VxXX8yfQDI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EW8X8idWsxpwgRS7W1rRRkmCU3GjV/blu5X1BM4nv7WX5OxMXZN6VuPZ751sImZbtaSR+OzWuyLc+vqEhf2DOgQSbiVJd5qu3jjwWYeuOrmSG3d16d/bJMLjhG1nBLn0uEpZmLjWqkGebORKqQGGxxN4pUyrdkZkE/iwioHqSJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uCco3cJv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uCco3cJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B307C2BC87;
	Mon, 23 Mar 2026 18:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291904;
	bh=siAwkY6JYMLWgzMwr4BP8MB0tr5Jyhi42VxXX8yfQDI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uCco3cJvbL5na5revqLJEdzUqW5w+9E9oYEHBSqFzXyUs/rc/uOqvEI4eYJYQkLbs
	 S/5fkP5M5n+NVLw6+En4vLusjEDNMRXdUuIm76u72lgDYdFZ/8rVgy07aqpwobQGvT
	 3xN5tpJBkp0GZ5ANKpVEeiNF/YyuJARIfCviEWiGJ+EyOyhhmiW8Eol8zFXY18vbpv
	 055sGTQZ3kHL8zQXSWFXjWnf2QKI/MENXd7tbALeNK4tf/b67n6Wd5EKwQE6WQmebb
	 0Xvp9FelmkFx5uSrMpZamhbQ/4sv2p4Yix9Sc+0gilEitUT5mWgSjt6YdWu6F0k3Er
	 GxexIZl2ipcPg==
Date: Mon, 23 Mar 2026 11:51:44 -0700
Subject: [PATCH 40/40] xfs: fix returned valued from xfs_defer_can_append
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, souptick.joarder@hpe.com,
 linux-xfs@vger.kernel.org
Message-ID: <177429121476.2266274.13848381355768911802.stgit@frogsfrogsfrogs>
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

From: Carlos Maiolino <cem@kernel.org>

Source kernel commit: 54fcd2f95f8d216183965a370ec69e1aab14f5da

xfs_defer_can_append returns a bool, it shouldn't be returning
a NULL.

Found by code inspection.

Fixes: 4dffb2cbb483 ("xfs: allow pausing of pending deferred work items")
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Acked-by: Souptick Joarder <souptick.joarder@hpe.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index e4d17177f67faf..3e36865fd1279f 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -802,7 +802,7 @@ xfs_defer_can_append(
 
 	/* Paused items cannot absorb more work */
 	if (dfp->dfp_flags & XFS_DEFER_PAUSED)
-		return NULL;
+		return false;
 
 	/* Already full? */
 	if (ops->max_items && dfp->dfp_count >= ops->max_items)

