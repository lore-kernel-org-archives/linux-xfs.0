Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162CE79C5
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294643; cv=none; b=j1DWj/kwAZu7Nx+o4wOcBgmhGLV1nJbx8B0RNonH8ADj3vBVaYnCmc7MvWEqXViA8zkEQuj0wEAZodcHTQxacI6KHtPkXud0P8jz3rmYSgVKP0EsWqplzBOOYUUxUBfdTh2K6Q544wnQcuLncsWx/l2PZT5gpDpnYLrXyoNMM3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294643; c=relaxed/simple;
	bh=wEyczEpytirVMt1mDxlOqR/77OkX3joXeFhSGw8DDXQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JfPqXgOOKYPJvTUPIc+AJd2VLr8htGJbGF2klxmzQxk5E56EvcLo0rybqgasNVNOQ6y9b4ZHEaSHwt3P4t6XTnFW1zYlalbCvUszZs+G6xmh/B9Gvn5PYQPEbt68SoCO2Wo7K+cSUwTHl9lxNJIKv9Y3VC8sIkFX14kC0aNG0Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hb3OghCT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hb3OghCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D57C433F1;
	Wed, 13 Mar 2024 01:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294642;
	bh=wEyczEpytirVMt1mDxlOqR/77OkX3joXeFhSGw8DDXQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hb3OghCTir6x9LAyHptt2rGsUk/4lFTIZduoBLv0iE9apIkiLQN92OSo2+sXbFipp
	 DbS+HQ2BEw3r430jn9pOQbJdolJvZBBMK4a/z2eDScWWLl/xs5oD+AzVaB+tAVWiLY
	 bNDE1pCtWAzLEOukIPG7ioteXZll/cQU4pGsiN4rcH64tel6BFC3sjpgVJo01VYg+K
	 JW2b0+Mzj07cVFvBLtacLIxcylnsU2uJsIdnOsj/rBmaqUDjjDBkDNzACnJjiYV8HB
	 iHi0cytZn3tzaL1tfwwkjI63TVBQFbF7nRwnBLhk1DL5ZAJJbbAXwq+2EHgoEjQTCs
	 v2RADDDBfcY1A==
Date: Tue, 12 Mar 2024 18:50:42 -0700
Subject: [PATCH 04/13] libxfs: create a helper to compute leftovers of
 realtime extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029430615.2061422.6487321208394360170.stgit@frogsfrogsfrogs>
In-Reply-To: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
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

