Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCD2128387
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422029; cv=none; b=P4BaZu8nKwI19UTVUoATsVlBD3d75UfWsWDMjcZW3JZKCLpI9RESmejNHs1GlWHtV7LxmJDvoHZOV5Kv4IziigGQvIvGfLA0n0f7C27T2xphhe88d6NIrjauhzSQFnkCQd2jeJDm7k66rWGkByHR5OIp5AG191ZIrjsb7rcheUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422029; c=relaxed/simple;
	bh=NcFnKISJaFmpxBpfnWAPEvWsWdem4m5jojTDmZwr8k8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZktAn5WK1qlThN/xogNLSWeczPT3WxEd43kcBpi96VMLe63VWwqxGhAQxoOicxkrdZqfgGqtngtbq1LbmH7VrMywqUwZNMVduyI5eUi9fwvHFatepCGSbd4bOZUq60dOlKx0lPTnkI2DcSa0eNy6c0lv4R0At5WlEutbd72r6mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oqImQx+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oqImQx+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053F1C433F1;
	Tue, 26 Mar 2024 03:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422029;
	bh=NcFnKISJaFmpxBpfnWAPEvWsWdem4m5jojTDmZwr8k8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oqImQx+Nlo0KLK7ROlEuuf2JzUbZzunY58ur1+35YSr+J8D0t/61tn+7ZwKn550xr
	 Cx1dLjaZTbsItXy027zo1IM6028/gu+NdgbP1fNhkmvDbyp5jhLtM+WzOGuOGZNvNM
	 Mbd0/sqts5h1JMg/1m9WBLr8k+S3gtRJIDvbfR3jpoNR0jHqGLZUVfpgB3XbGqvDNR
	 dT6OxosRXUeo+1djzXgXTknwWDnBlTCMr22vsrfuoB4dd7UBar7hP8LebjI2sjiVHG
	 Y5N9VQo1yu9X5ZyFo8APYI37k9TjGo9+ZpylbOTsZjg60QhiUmi4pC83OGbPwA/hDa
	 x5SaY4RY3w5Hw==
Date: Mon, 25 Mar 2024 20:00:28 -0700
Subject: [PATCH 04/13] libxfs: create a helper to compute leftovers of
 realtime extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142126366.2211955.7781387463785521195.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs>
References: <171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs>
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

Port the inode item precommunt function to use a helper to compute the
misalignment between a file extent (xfs_extlen_t) and a realtime extent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/logitem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 48928f322113..3ce2d7574a37 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -15,6 +15,7 @@
 #include "xfs_inode_fork.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
+#include "xfs_rtbitmap.h"
 
 struct kmem_cache	*xfs_buf_item_cache;
 struct kmem_cache	*xfs_ili_cache;		/* inode log item cache */
@@ -213,7 +214,7 @@ xfs_inode_item_precommit(
 	 */
 	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
 	    (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
-	    (ip->i_extsize % ip->i_mount->m_sb.sb_rextsize) > 0) {
+	    xfs_extlen_to_rtxmod(ip->i_mount, ip->i_extsize) > 0) {
 		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
 				   XFS_DIFLAG_EXTSZINHERIT);
 		ip->i_extsize = 0;

