Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DC81DFD0
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346267; cv=none; b=avlllR9HxWjVPZqkMQFE04zeL5Fr+lYbwLHJSIVkqJSNvXuOQiOw0KP+rDirEhqJKH3J2NnWHcoh30XqQtbpLo5cudhkALbDyklUZPBbGUGkblNSdLKk/JIHpE9lFibUAcoX8hrg9qh3J9inUxf0STvh8BmPxU0fVMvZIH0djmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346267; c=relaxed/simple;
	bh=1B5H1jXmD8jSXzqn8yebGI7FTOQAUAXRjQ7FAIIzLlM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tzGG4RkZqbbZcAa3GiU/Ajqrj+3w2guq3G8fNIRJMP1g4qQug9Uc3MPt1XoDvMCmHc3EWtCFw1rCoNPlsIN5vrB5eWCti9SqJZchJdzUCwfZ39SfdBoYGk2LorIwCn7oht10U7BHFz+XXsgpMNUKmzO7v6CVkhi6Bp75M6W2v3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b5nys68Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b5nys68Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422DAC2BD11;
	Wed, 22 May 2024 02:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346267;
	bh=1B5H1jXmD8jSXzqn8yebGI7FTOQAUAXRjQ7FAIIzLlM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b5nys68QopMr5xNZJoe6uAKwE7xFQaasBzkcQ3DvDWQuJsDccV1+BbLxuwNXbNVmA
	 WRtdigfTAUYO/2TITTS+OsOkcS+1zJKXjqK4EQMsvrb9qAZrBWASG9A1izz/0nSTVN
	 G7gnvOJOZOzEaR+TOk1dpKKGn8Bp78FHNOkvHlJh+CuUQZKsk8NbP66XCNdiAyZFQ5
	 vvnZ9RX/8UxnzmO/rECJBFZfzAwPBIYt6+9XcM2RHRaJX9QHCwSfECJGdktmP5pU4i
	 9V+mYHthBMV1dyjQbpAddrctnp3048ehpyraMlpXFCbmI5t0vgUSmQfmwX1YJ6Y00a
	 mnhYMHg78KUVQ==
Date: Tue, 21 May 2024 19:51:06 -0700
Subject: [PATCH 009/111] xfs: create a static name for the dot entry too
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634531846.2478931.9600196610345445548.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

