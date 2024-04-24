Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A66E8627C
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929279; cv=none; b=uJLylX1yvfuStLS1sQ7cG2gdMB+Q1f1hzsjPEZozSVUyDBIbiRJ4ZKbtBwyfM57kupd9OBcpuOUpfFX9z8fEOcbwdU85nK/62lVJ69YeDcgTZGW9BZR1xsbdVNmbS0EDLye6ZwWPaZCqJscCQo9hp6gm1S2enxdxJK0NlAx7R2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929279; c=relaxed/simple;
	bh=v+sdTod3paVB3RxMfSJAEf7IHjsur72vvjzQ44J+zlk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tc74Gtl0W0pLOSfto8WR3GrGL02PRT7j2oI186zIl17UxUtWpeuHaMur8RgZ17pON4vJ7GY8h1P3c5zeMWieRfy74nWzvAqxOjv6CvklW0nsf6dikf3RIQXFz0Z16vuYVpdNSvh/ITtmJraPZ6Qrr4hsFv1EWgAca6LCzeo3ZcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o2P82/EL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o2P82/EL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6851AC2BD11;
	Wed, 24 Apr 2024 03:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929279;
	bh=v+sdTod3paVB3RxMfSJAEf7IHjsur72vvjzQ44J+zlk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=o2P82/EL9DpRzdOmgi+xeUL2xwG53mZM7pWI9SUP1HhPFYhq07hhziNUr3DVVrmty
	 mSrfpwji95f8mDOcbbxD/egoGUZaS67KMTZfBwqahGpTto1YtAM2HbR/ZWOx0jxSlP
	 PJVEfto0xEYK/Kjb2lcUPZMHfWl/Z5q5lBUMqSSg7cOZ4EHxOW1bBpmVnD7+A+13V7
	 lVA5UVERrrDYCDi11+lG/5jAv7Zo2eC9Kx3OvkhwmrG4kBDKtN3bZXtknaLqW5xNuY
	 6EeQdNuReR9SMVcXUCYjKX7KZelyPGzp9lfRxoGpmfYRs3PC29HsR5rYiPPKiigKAo
	 7ZKOwZMyo2Hag==
Date: Tue, 23 Apr 2024 20:27:58 -0700
Subject: [PATCH 2/3] xfs: move xfs_ioc_scrub_metadata to scrub.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392785690.1907196.11826279589821432424.stgit@frogsfrogsfrogs>
In-Reply-To: <171392785649.1907196.827031134623701813.stgit@frogsfrogsfrogs>
References: <171392785649.1907196.827031134623701813.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/scrub.c     |   27 ++++++++++++++++++++++++++-
 fs/xfs/scrub/xfs_scrub.h |    4 ++--
 fs/xfs/xfs_ioctl.c       |   24 ------------------------
 3 files changed, 28 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 4a81f828f9f1..1456cc11c406 100644
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
index a39befa743ce..02c930f175d0 100644
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
index 0e97070abe80..857b19428984 100644
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

