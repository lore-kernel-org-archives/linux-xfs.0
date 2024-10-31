Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501531BD9DC
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730417138; cv=none; b=Y2qUztAA1/si76VrZRAK97Xr3Tino8vkByhDpczMBdzlvd6gtjRsWDiUelBEHCGxmuBj0oiVrkKGlbbq4I611X192tt1uytURs0NHgXRhoWhGRHFmzoHsJeaaRriDs0GDZSpMGBQOS7TB4KAcHjTtZZ9QsFwKJYy8mffjTkzn3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730417138; c=relaxed/simple;
	bh=xr0yNfUf5FARD2y6tiNSIjWTEhGONQegMGTjh4pnxNk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lez/Ob4a04IIGQuL7XxofaA04OxhuKjvObrL5iGFsOvV7rLbDXePWQWmiY0t0D+kgYpwzG3h9PQadWi+cmrYhMtHt5FkueDuwQPvWsqIaDkZliFj80be/2sJ2it0OokkPgcYUBtbq3VXGHwl0/xizhlS5kjcX/4cMJZJTz38tPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AfoDctuD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AfoDctuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2755AC4CEC3;
	Thu, 31 Oct 2024 23:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730417138;
	bh=xr0yNfUf5FARD2y6tiNSIjWTEhGONQegMGTjh4pnxNk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AfoDctuDOH+z4nL/BVybmU3rNkOzn/E7kcHuoeouz9qR9pgAsm1jXEOXB/hKOxTZo
	 FSsWUG1l5gPW0JsSvJd+x51uM/Gx3ZuMmgCFyCY9zr729pqk+inDtPa19rHwImUbh5
	 NLYftbrcd5r4R7oriTgVLtrQw0y6xOWpcMUSAI8CgQ9CgdDlHsnF0Bi59O8g5gO2/h
	 I8P0T7fMjGUYKcOQcznpHB0lcxX4+HIUInx+29KYIb1RQ1hoEfppb30BYbK7ZcUqtK
	 RvO1qr+PF9VfmX+PRurKIH04vN1DSugglbPXc6uqIXpLbCXnDFLaNyRi+VscBbBDHe
	 ij8z3l/pM1O7Q==
Date: Thu, 31 Oct 2024 16:25:37 -0700
Subject: [PATCH 1/1] mkfs: add a config file for 6.12 LTS kernels
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041568843.964970.10735220457004030737.stgit@frogsfrogsfrogs>
In-Reply-To: <173041568827.964970.16858014331188799642.stgit@frogsfrogsfrogs>
References: <173041568827.964970.16858014331188799642.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We didn't add any new ondisk features in 2023, so the config file is the
same.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/Makefile      |    3 ++-
 mkfs/lts_6.12.conf |   19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)
 create mode 100644 mkfs/lts_6.12.conf


diff --git a/mkfs/Makefile b/mkfs/Makefile
index a6173083e4c2d4..754a17ea5137b7 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -16,7 +16,8 @@ CFGFILES = \
 	lts_5.10.conf \
 	lts_5.15.conf \
 	lts_6.1.conf \
-	lts_6.6.conf
+	lts_6.6.conf \
+	lts_6.12.conf
 
 LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBBLKID) \
 	$(LIBUUID) $(LIBINIH) $(LIBURCU) $(LIBPTHREAD)
diff --git a/mkfs/lts_6.12.conf b/mkfs/lts_6.12.conf
new file mode 100644
index 00000000000000..35b79082495d24
--- /dev/null
+++ b/mkfs/lts_6.12.conf
@@ -0,0 +1,19 @@
+# V5 features that were the mkfs defaults when the upstream Linux 6.12 LTS
+# kernel was released at the end of 2024.
+
+[metadata]
+bigtime=1
+crc=1
+finobt=1
+inobtcount=1
+reflink=1
+rmapbt=1
+autofsck=0
+
+[inode]
+sparse=1
+nrext64=1
+exchange=0
+
+[naming]
+parent=0

