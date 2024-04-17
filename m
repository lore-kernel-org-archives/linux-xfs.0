Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14D248CCD
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388766; cv=none; b=TwxjAnKc0zYeO8KlArVErRLDh7m61V2dkmBGDfW9FCYRZ9HAf2RjlIBRZ2L75bi0TeY00t0VCcQTEs8WP6ihUitFx7sT2MsdVArnTzdRBVXEWHHvk7lhqkwuSU5Jg5bh49Mc4lcy5A4Kq5YSxIlB4XOFGEfqdMP7QvfLwksDG+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388766; c=relaxed/simple;
	bh=pIiHhpTxFs4Zvo8N85UpKY8dnWtKG67m7xI8FLHPJgc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h/+GMcLZavPXDFmet7SC8XgdrVK0OhnhkSmYhWjD/0thksZ0jUy8Vq2+ghuY04XpREVs9JTje9Z1/AAUvtn4sPLkXM7kP7frIRxGiAabnkFVmk3L2QBb4NqctPWlXcvB/qTUwfg6G5n00oGFz1k9Zw9FpainHbmFJA9Na9BKOcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JjE5Y4HW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JjE5Y4HW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F76C072AA;
	Wed, 17 Apr 2024 21:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388765;
	bh=pIiHhpTxFs4Zvo8N85UpKY8dnWtKG67m7xI8FLHPJgc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JjE5Y4HWVtbBg174Ii7GvdiMfbcUngRV2J1g4F2nzKyzIDwRARIqeuhRdX04wP+dj
	 HjZZ7K0JAtPnRPmIt3xguw/+6DJoBT34OKJtpB2A+Jsjo1/cNcZml2QhqJW35MluRV
	 rDjOUdBzkNSMYB8wvJY1EXQneo63iaBANPNh1iywqm5jupNx/WRpPw70qLbzDCuLeB
	 VbN7d4jfm9mUcDDx4MSSjiAP2RSCL+KmOKP0FeSjWccK4U9+ozHgRMj4j663F1Fjyv
	 TfZaoDKUJJsxMYIaQO0vv9Q0pXxktGTwrrJCgRZa0xKCpcrLAa2/MhHIUXkPIvUF7l
	 GTW2mC79j2o8w==
Date: Wed, 17 Apr 2024 14:19:25 -0700
Subject: [PATCH 02/11] libxfs: create a helper to compute leftovers of
 realtime extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338841767.1853034.2871831194051599567.stgit@frogsfrogsfrogs>
In-Reply-To: <171338841726.1853034.8225385129852277375.stgit@frogsfrogsfrogs>
References: <171338841726.1853034.8225385129852277375.stgit@frogsfrogsfrogs>
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
index 48928f322..3ce2d7574 100644
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

