Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A9CF9E9
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440864; cv=none; b=MoxVw2H+Dcyc2JOFbfc3+z+ORfQRq8kOozcYZ4qJ9OP/fvuUpkSztf50o+2xFV2VEY+yk9ixeYCJsSY93Wz9oIEwPGlQrG1i/5LWrrr5oqy9lfZl9mHOffxPxGTlXr0TDrHgicewQbeGm5Ny6sJbtfv7JfwfeYJXA9k717LvY7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440864; c=relaxed/simple;
	bh=LJlmC3mJRbdkKFa2BBtqAQasTJdQp6z9A9dKxZF+kL4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XD1BVScXycTOPhUJDXnoeHI63zGI/Iu1ktlmgo8iVesxwfLCFFCPlmNif+Gsoyi45eWCetixD2sVl+UAR9Egk43x6U2RBtruOOu5lgsVAp9z5bqFXSmDS17/pZtx8mYm/rTDwRhG1cunGyRShe+FaK/HNWiye7FeSkvpMzp4ano=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HDOPVy8x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HDOPVy8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC65C2BD10;
	Mon,  3 Jun 2024 18:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440864;
	bh=LJlmC3mJRbdkKFa2BBtqAQasTJdQp6z9A9dKxZF+kL4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HDOPVy8xHvmcYkFsIFYbSbg8d6GqTabxM3+9bVHfq8gXXaPDMkjfPhtRozjvPnLPo
	 pISB+Eh6qdiniMzSO961QQ1V3U0d0bltKB4sPhAZ0L4/JmkoC2mXYFTn4du4QftIO3
	 HFx4SBHPNjN3++1An07NPXhL/H33d80DHlA5lSbBAwD6+CD4MKh1anWBfGCtn60v/B
	 /sX9C6/ifns/qyUSt21RNIaUmy+TgvPQPjvC3F6xykrChv3C2FOaotu91w9k2k67iJ
	 bgnq5jbWqVIMjPhyyyIO1AVLG10GkGZsj3wMxfD59mYLwOweauDpNZCVFvMydvqXnG
	 IcpE9xV7opagQ==
Date: Mon, 03 Jun 2024 11:54:24 -0700
Subject: [PATCH 009/111] xfs: create a static name for the dot entry too
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039502.1443973.17872389791565935131.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: e99bfc9e687e208d4ba7e85167b8753e80cf4169

Create an xfs_name_dot object so that upcoming scrub code can compare
against that.  Offline repair already has such an object, so we're
really just hoisting it to the kernel.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_dir2.c |    6 ++++++
 libxfs/xfs_dir2.h |    1 +
 repair/phase6.c   |    4 ----
 3 files changed, 7 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 914c75107..ac372bf2a 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -24,6 +24,12 @@ const struct xfs_name xfs_name_dotdot = {
 	.type	= XFS_DIR3_FT_DIR,
 };
 
+const struct xfs_name xfs_name_dot = {
+	.name	= (const unsigned char *)".",
+	.len	= 1,
+	.type	= XFS_DIR3_FT_DIR,
+};
+
 /*
  * Convert inode mode to directory entry filetype
  */
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 19af22a16..7d7cd8d80 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -22,6 +22,7 @@ struct xfs_dir3_icfree_hdr;
 struct xfs_dir3_icleaf_hdr;
 
 extern const struct xfs_name	xfs_name_dotdot;
+extern const struct xfs_name	xfs_name_dot;
 
 /*
  * Convert inode mode to directory entry filetype
diff --git a/repair/phase6.c b/repair/phase6.c
index 36e71857f..ae8935a26 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -23,10 +23,6 @@ static struct cred		zerocr;
 static struct fsxattr 		zerofsx;
 static xfs_ino_t		orphanage_ino;
 
-static struct xfs_name		xfs_name_dot = {(unsigned char *)".",
-						1,
-						XFS_DIR3_FT_DIR};
-
 /*
  * Data structures used to keep track of directories where the ".."
  * entries are updated. These must be rebuilt after the initial pass

