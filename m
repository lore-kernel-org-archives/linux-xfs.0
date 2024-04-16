Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5576FE545
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231717; cv=none; b=j3dVNtfMuAuYqe/GevYrbkhXNDNq5ChNpK1N1iTptV61OHhKU4KLsaVElSJ5UKxESHYQawTbO+NhMuaRdJirp7t3uKcj46Mot1MQi5SRyQIUOmShtrR9h/NlBd48JqA1Ogtbq+a/B2wB9uSTTOCYobTj9CLWnAxlhvt9Sp1Kcjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231717; c=relaxed/simple;
	bh=z6zhJT0U1xUzup3vwjjF5s0syDGfEghiBAORKW/Sr2U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kOEriyWHtKH3FaRa5/w0H0q+2Mj0zBFfrmxB4GoeI8Nn1M9MINKKJrqj+BwFFXi1/Kk8eTTFLediIRw02hZogPvm44dkIo5+bsf45KaptBQYA0OvaGaKiHtFetHYbvElYE40HWrx81RGpO9qlloI5b6N2mBhhmxIci3+YzSjYao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=husROhD4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="husROhD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2714C113CC;
	Tue, 16 Apr 2024 01:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231716;
	bh=z6zhJT0U1xUzup3vwjjF5s0syDGfEghiBAORKW/Sr2U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=husROhD4l7Ng1crObwl2YnqOD81d/fR0dUKk2uKD1PTnA1gaYM/UoKjmJBZinOiJU
	 kqojW75p8QzaiiAOyeKH3O7kmbiKo8GzxfmfogsB0hKDOx3woNRMrXQzEgMxRvPL9K
	 lfS3NVw7YEE3kmCmHc/kBWZ4ry+SVEPDor2eEiEJbAwRWI7vLawuKlyuKCmKuV4r1V
	 itYs0FE/vi1eoNRT/qYPoRQdhpv1twKIYrzhVkOMXNfav7DsIeRDWGB5r5TuagzUll
	 hpbM+ujNv5G8aTxkSyxqNDZKeS/28tp2Ohb4ThuL2ZykqLjeosA//3kDFMZhs7mA7T
	 i+ndoDfbG2Rgg==
Date: Mon, 15 Apr 2024 18:41:56 -0700
Subject: [PATCH 2/4] xfs: move xfs_ioc_scrub_metadata to scrub.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, hch@infradead.org
Message-ID: <171323030277.253873.12950334854150989191.stgit@frogsfrogsfrogs>
In-Reply-To: <171323030233.253873.6726826444851242926.stgit@frogsfrogsfrogs>
References: <171323030233.253873.6726826444851242926.stgit@frogsfrogsfrogs>
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

Move the scrub ioctl handler to scrub.c to keep the code together and to
reduce unnecessary code when CONFIG_XFS_ONLINE_SCRUB=n.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/scrub.c     |   27 ++++++++++++++++++++++++++-
 fs/xfs/scrub/xfs_scrub.h |    4 ++--
 fs/xfs/xfs_ioctl.c       |   24 ------------------------
 3 files changed, 28 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 4a81f828f9f13..1456cc11c406d 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -578,7 +578,7 @@ xchk_scrub_create_subord(
 }
 
 /* Dispatch metadata scrubbing. */
-int
+STATIC int
 xfs_scrub_metadata(
 	struct file			*file,
 	struct xfs_scrub_metadata	*sm)
@@ -724,3 +724,28 @@ xfs_scrub_metadata(
 	run.retries++;
 	goto retry_op;
 }
+
+/* Scrub one aspect of one piece of metadata. */
+int
+xfs_ioc_scrub_metadata(
+	struct file			*file,
+	void				__user *arg)
+{
+	struct xfs_scrub_metadata	scrub;
+	int				error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (copy_from_user(&scrub, arg, sizeof(scrub)))
+		return -EFAULT;
+
+	error = xfs_scrub_metadata(file, &scrub);
+	if (error)
+		return error;
+
+	if (copy_to_user(arg, &scrub, sizeof(scrub)))
+		return -EFAULT;
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/xfs_scrub.h b/fs/xfs/scrub/xfs_scrub.h
index a39befa743ce0..02c930f175d0b 100644
--- a/fs/xfs/scrub/xfs_scrub.h
+++ b/fs/xfs/scrub/xfs_scrub.h
@@ -7,9 +7,9 @@
 #define __XFS_SCRUB_H__
 
 #ifndef CONFIG_XFS_ONLINE_SCRUB
-# define xfs_scrub_metadata(file, sm)	(-ENOTTY)
+# define xfs_ioc_scrub_metadata(f, a)	(-ENOTTY)
 #else
-int xfs_scrub_metadata(struct file *file, struct xfs_scrub_metadata *sm);
+int xfs_ioc_scrub_metadata(struct file *file, void __user *arg);
 #endif /* CONFIG_XFS_ONLINE_SCRUB */
 
 #endif	/* __XFS_SCRUB_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6055053a8f6b2..87a45d4dbbd7c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1055,30 +1055,6 @@ xfs_ioc_getfsmap(
 	return error;
 }
 
-STATIC int
-xfs_ioc_scrub_metadata(
-	struct file			*file,
-	void				__user *arg)
-{
-	struct xfs_scrub_metadata	scrub;
-	int				error;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	if (copy_from_user(&scrub, arg, sizeof(scrub)))
-		return -EFAULT;
-
-	error = xfs_scrub_metadata(file, &scrub);
-	if (error)
-		return error;
-
-	if (copy_to_user(arg, &scrub, sizeof(scrub)))
-		return -EFAULT;
-
-	return 0;
-}
-
 int
 xfs_ioc_swapext(
 	xfs_swapext_t	*sxp)

