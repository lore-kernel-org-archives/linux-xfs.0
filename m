Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B76C1FBA
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831365; cv=none; b=HqT/dZDB6jtSDg40EcGjY2HLrYNuCx42Ovf7bnglvW1arhtUvFvFG7A6nyCC3neyAteVtRe0QPXSWl7E0hmbdSwi4kSl4oARQlKwERr2ReHZ/JB8RReI574oiUEYkdZTmGngrAsDfsOvjc5sGTDxBmnV7llpuj9Xckv2+QgW6fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831365; c=relaxed/simple;
	bh=LQpK/WCiB8Qh5fMaJijJ5IHaaWjA+xYR1MPetP5jCs4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iUUYT/lfcPc2lBmHY+uwYBFYZTys50fEGKdBjd8d4ZDZnIW+ivJzCM03NjjioGy1RNkglE/XHIRKAm5eG8C8cnSRK4962HObnvAwWvCt7mItcK6HdZ/HSynuFBBp7VHUPsuHpd12DqMfgtl0TFjq0faei3Dacmp47TP77unwDxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TC5RP/NT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TC5RP/NT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DF4C4CEC6;
	Wed,  2 Oct 2024 01:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831365;
	bh=LQpK/WCiB8Qh5fMaJijJ5IHaaWjA+xYR1MPetP5jCs4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TC5RP/NTlsUIbu4hkCtN94YxMqqw22K9OqQ3PRxLv4UZI7ehaA32AH4rd2VqMQDtl
	 WE/EDRauISHQM9WtOgq/TWTbkP3+724PFJHcPAvgE6rzdwy8Lt+LuHFj1RKiLBuCOT
	 v84xAuLi2LiTPthtoDycgcTBF5mtsLhDVk/0l7VBrUZ+6ESz2/P3THcHTfHpj5h3Ik
	 Zs1F4Lr4t0qPW3JTMVrtGTvv/1gnczNCd1L7SM27wrBacfj4o0UjBeZJohkVpX6X+r
	 Rkk9q1wmfBXp9phl7OSP3nhtPGAAMBsDzYPiQonB1ZzG9zzh0A1nJF1UFAV7GGmPeT
	 DftImb/yL1Blw==
Date: Tue, 01 Oct 2024 18:09:24 -0700
Subject: [PATCH 06/64] xfs: hoist project id get/set functions to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783101872.4036371.14985363676574940423.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: fcea5b35f36233c04003ab8b3eb081b5e20e1aa4

Move the project id get and set functions into libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_inode_util.c |   10 ++++++++++
 libxfs/xfs_inode_util.h |    2 ++
 2 files changed, 12 insertions(+)


diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 868a77caf..0a9ea03e2 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -122,3 +122,13 @@ xfs_ip2xflags(
 		flags |= FS_XFLAG_HASATTR;
 	return flags;
 }
+
+prid_t
+xfs_get_initial_prid(struct xfs_inode *dp)
+{
+	if (dp->i_diflags & XFS_DIFLAG_PROJINHERIT)
+		return dp->i_projid;
+
+	/* Assign to the root project by default. */
+	return 0;
+}
diff --git a/libxfs/xfs_inode_util.h b/libxfs/xfs_inode_util.h
index 6ad1898a0..f7e4d5a82 100644
--- a/libxfs/xfs_inode_util.h
+++ b/libxfs/xfs_inode_util.h
@@ -11,4 +11,6 @@ uint64_t	xfs_flags2diflags2(struct xfs_inode *ip, unsigned int xflags);
 uint32_t	xfs_dic2xflags(struct xfs_inode *ip);
 uint32_t	xfs_ip2xflags(struct xfs_inode *ip);
 
+prid_t		xfs_get_initial_prid(struct xfs_inode *dp);
+
 #endif /* __XFS_INODE_UTIL_H__ */

