Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3284BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N6UAM8+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72034C433C8;
	Sun, 31 Dec 2023 20:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055256;
	bh=cCDUjytcFBUdQ26SGfn5f6eZVd7uU5ZbRjT1Isud8Q0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=N6UAM8+Qgbnp71MoU2AZlJGgir4lZ7uU0nmwyxCHgt4ROilcpAAmfwKOPs2k91jcd
	 dZMHhWIkpvTe81L8TwAhjfaCnH2lcMzh6q16XCV/RQiEDwpFTImrQq5HPw0UtzCncy
	 JER3fH1mlB8E2IVc5fAPzMIiuSCwRuFZ1YOcPqyGy/tmMDEgJmiigJhfREMIaPeDjz
	 kJM2CtvY90UuunGn8FN+fFzG6id1FgJ572EMhobE0sKMcwouvY+uwYp6j6dB9vn9ti
	 2OH+Oiu9+62crrYCQOXEXIt5a5+1pCZqm6LhSZhusv256vuOkFfa+vfSGxM4Zp3jhm
	 qIMhT1In+WQGw==
Date: Sun, 31 Dec 2023 12:40:55 -0800
Subject: [PATCH 1/4] xfs: check unused nlink fields in the ondisk inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404838015.1754231.16073556991126326060.stgit@frogsfrogsfrogs>
In-Reply-To: <170404837990.1754231.2175141512934229542.stgit@frogsfrogsfrogs>
References: <170404837990.1754231.2175141512934229542.stgit@frogsfrogsfrogs>
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
index e46b1256b0851..5867617c00cd8 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -468,6 +468,17 @@ xrep_dinode_mode(
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
@@ -1329,6 +1340,7 @@ xrep_dinode_core(
 	iget_error = xrep_dinode_mode(ri, dip);
 	if (iget_error)
 		goto write;
+	xrep_dinode_nlinks(dip);
 	xrep_dinode_flags(sc, dip, ri->rt_extents > 0);
 	xrep_dinode_size(ri, dip);
 	xrep_dinode_extsize_hints(sc, dip);

