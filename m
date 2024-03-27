Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C80221360
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 02:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711505216; cv=none; b=MAD9Ug22B4i8fGgV4YXrdgyYlbOWWFaaKirGbU+4rg0I0SdQ4nL8ffdXgZQywANQlInEIwoQtS0xCgGXmEzs/yCpMwOzdbX8TxORJ0RXX6zSX3ZYV0Fu8UcAXIVKnl8M18mg0obwM28O34L3KbCN1lqNCi2jiJGcqvhDNMLW88c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711505216; c=relaxed/simple;
	bh=HWLP0LKmv8ayql9ip13c0eZUwl2Dn8kh3p5gHq2MPPg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hLk2wMMb9TchihejB5BnTwsvQqUJbkNYFm2nIzqUXEPCuTLZwOSHcpFxgi85WEdhkliI2ekYHDxoJiVGviKthzzmUTyahkIbOnb0atlvrP54qUaqBW6kL2sa1BOxbYxRTwVdpK/3NLGigPOc5oh56+HLpscmD46+7CTScgA01DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UCWwucZ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UCWwucZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D96BC433F1;
	Wed, 27 Mar 2024 02:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711505216;
	bh=HWLP0LKmv8ayql9ip13c0eZUwl2Dn8kh3p5gHq2MPPg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UCWwucZ3klP6y4ejiazeWiAV4gbmH59toC5BHKzfxNL38fqg/f/kSykSCorHl9oJX
	 iOp9oQBx7RkTu0Bm6hxGfFRbobeRI5Bzt9wPtJAs/NBE8fhZCdF1EXMLPPVP3Rv7IK
	 Bgt523RyMAVQs0fTEAveRQWkcceChOeGPYtrG5J03elgFMZdJNPByz7YKV9XUX8Q/+
	 65vx5Ve8Sr7NXbMPM0phBpm0X+CRQ9UNJRpzEN1ocdPYKCDHtHsUiIdjfnTsuySQu4
	 5Lra32WJ6av5PE9skSaZ4oi140BF6o04WHov2AbUGLfuG7bqoihZWImPpM/G9XMu6n
	 zNHvPTTeuT6mg==
Date: Tue, 26 Mar 2024 19:06:55 -0700
Subject: [PATCH 1/4] xfs: check unused nlink fields in the ondisk inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150385136.3220296.7489617025414489165.stgit@frogsfrogsfrogs>
In-Reply-To: <171150385109.3220296.4235209828218476119.stgit@frogsfrogsfrogs>
References: <171150385109.3220296.4235209828218476119.stgit@frogsfrogsfrogs>
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

v2/v3 inodes use di_nlink and not di_onlink; and v1 inodes use di_onlink
and not di_nlink.  Whichever field is not in use, make sure its contents
are zero, and teach xfs_scrub to fix that if it is.

This clears a bunch of missing scrub failure errors in xfs/385 for
core.onlink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c |    8 ++++++++
 fs/xfs/scrub/inode_repair.c   |   12 ++++++++++++
 2 files changed, 20 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index d0dcce462bf42..d79002343d0b6 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -491,6 +491,14 @@ xfs_dinode_verify(
 			return __this_address;
 	}
 
+	if (dip->di_version > 1) {
+		if (dip->di_onlink)
+			return __this_address;
+	} else {
+		if (dip->di_nlink)
+			return __this_address;
+	}
+
 	/* don't allow invalid i_size */
 	di_size = be64_to_cpu(dip->di_size);
 	if (di_size & (1ULL << 63))
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 1851d17f0f2b7..228317b22bcb3 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -514,6 +514,17 @@ xrep_dinode_mode(
 	return 0;
 }
 
+/* Fix unused link count fields having nonzero values. */
+STATIC void
+xrep_dinode_nlinks(
+	struct xfs_dinode	*dip)
+{
+	if (dip->di_version > 1)
+		dip->di_onlink = 0;
+	else
+		dip->di_nlink = 0;
+}
+
 /* Fix any conflicting flags that the verifiers complain about. */
 STATIC void
 xrep_dinode_flags(
@@ -1375,6 +1386,7 @@ xrep_dinode_core(
 	iget_error = xrep_dinode_mode(ri, dip);
 	if (iget_error)
 		goto write;
+	xrep_dinode_nlinks(dip);
 	xrep_dinode_flags(sc, dip, ri->rt_extents > 0);
 	xrep_dinode_size(ri, dip);
 	xrep_dinode_extsize_hints(sc, dip);

