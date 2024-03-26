Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FDE1292F5
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423846; cv=none; b=bkLYESxYInzql9ORpdcfN3/xWUdCBuAqusbpFjQj+7g3Lo2pbQzZo65qLKtsbTcQ4jyjLWmPAt95LKqSD0XABbNBjs/i5lzXpfiXlOIXGn9netO3dgd1uLHAwCODE9Y2Mfnr51TRP8xRmWQTcamMl5X6AmOT9/8WaBYPryfX0dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423846; c=relaxed/simple;
	bh=rdjo6J0pPlBt75GFgrTJaU6CvYW1fVikCnC1ssaAtWQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H6ws1akYgA36UlnVzyFc4cMKvs2MXuVbD5W17CsX8xbRV67NL23pCrwcJ4bfqMEl9AaisBe8Z6oqHN+zOKZyBD9ADlgKdoWiZ04XLrh26I38Q7ujngbsTEOLuL5wg65vd8+XNXRT0m1JID10RGb/uQcONiSRAHbg93SgdcQZVyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=psPFlku7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="psPFlku7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C73C433C7;
	Tue, 26 Mar 2024 03:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423845;
	bh=rdjo6J0pPlBt75GFgrTJaU6CvYW1fVikCnC1ssaAtWQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=psPFlku7GjxUqk3JrfeQR4GaUiNxL+MdtuYCgdDYwnZAoS3WfV95gHwXGrtMRYXhH
	 XhQkMrWvA5MG8H/1NJpU3U36InnhKw2a/o1pe+10iSFvd/AShTPwVaJfi9fpWUjgSn
	 jSZoFJ3sFQyLxj8wdZKtTlQZbtJGGejbt8836Pg+63W8yoGbnDKT47HwQBe3cwf+rZ
	 VRjBykTEUu3ECYIY4viIgyHxciLxXg5phN6xsuwoYIUprXLxizE7wlZa2WV5o1Ktfr
	 Y+eJzO5BTwnz+0qBdxjVyNmOgkmTZrksMrlnxCUs+CTwYZYcMrT3D4mgKCq3WE+c12
	 vLMiNtMCVE2PA==
Date: Mon, 25 Mar 2024 20:30:45 -0700
Subject: [PATCH 009/110] xfs: create a static name for the dot entry too
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131516.2215168.3429149257695984321.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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
---
 libxfs/xfs_dir2.c |    6 ++++++
 libxfs/xfs_dir2.h |    1 +
 repair/phase6.c   |    4 ----
 3 files changed, 7 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 914c75107753..ac372bf2aa32 100644
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
index 19af22a16c41..7d7cd8d808e4 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -22,6 +22,7 @@ struct xfs_dir3_icfree_hdr;
 struct xfs_dir3_icleaf_hdr;
 
 extern const struct xfs_name	xfs_name_dotdot;
+extern const struct xfs_name	xfs_name_dot;
 
 /*
  * Convert inode mode to directory entry filetype
diff --git a/repair/phase6.c b/repair/phase6.c
index 43a4c1406372..bc61cbd16be8 100644
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

