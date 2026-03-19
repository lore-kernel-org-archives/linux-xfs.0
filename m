Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAAD2E541F;
	Thu, 19 Mar 2026 17:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773939765; cv=none; b=hfieLr3Oq4podZ338/vhdr3iaQ36OilY6mvsH34QGzO7N63MOPcWJEvemWKMw/FqxOfGbuPPiHoFc1nDiH3D20n0TFwfrWdLjBOEfEZeBXduRyX9Ta/0nUJyAU5lCsyrr4x2LSXf7sQJb8Om6hpkJcsZedUToddZHfgW1YfyWjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773939765; c=relaxed/simple;
	bh=pNHdBOW55LkBe0BiZ2NtLLPmFVSJ8bnWMqD9JSLDKkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFIgNhrptO6MtoljGap9a6c9Y4fHh1FVCK7AUdPEJyLYJP+6cYMTYdcta5JTpyKV+RCUvMg2JAqk1W0evmz/zdCyWSPHbvt2c3FvN1sqrrWR/kvstu3/BIINAj8t/BAGu3g0UvYyAUiDNnb8ONA8OZKFOpojS0dkIlwSceniaJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TTGMdoca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TTGMdoca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F013C19424;
	Thu, 19 Mar 2026 17:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773939765;
	bh=pNHdBOW55LkBe0BiZ2NtLLPmFVSJ8bnWMqD9JSLDKkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTGMdocaxYVdU887hPWohvm8XvDKK5I8zw/kgpWC68XkQF+b8Rkp26/HLwkdwlHrx
	 M8OhTk2/2B6D0cOfQ5L0wUTp8Jbb/UEq99UI8Z2ebRamofksVOLD1TCpdsJRZl0f1/
	 O5Wsy3+hRPwJdlgCuY2sDadahY60z2RkTZ0L4YFYBpciT6UAO2wTBmRuSmW4Q4wq8f
	 mPWFYc91B7Znx0cf1x+3g8XuEg7lxbX4wjlYX8XNmRA9LVFbW0lvq7pBoVECRTcDOj
	 vd+O422CMh9dw6sOUsT3b2wigqVzFwrZr9/J+J0v0rsg4hjBzqvYyevs08LlnI0vfk
	 mcJBeMkpznLiA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v5 02/25] fsverity: expose ensure_fsverity_info()
Date: Thu, 19 Mar 2026 18:01:49 +0100
Message-ID: <20260319170231.1455553-3-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260319170231.1455553-1-aalbersh@kernel.org>
References: <20260319170231.1455553-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This function will be used by XFS's scrub to force fsverity activation,
therefore, to read fsverity context.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/verity/open.c         | 5 +++--
 include/linux/fsverity.h | 7 +++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/verity/open.c b/fs/verity/open.c
index dfa0d1afe0fe..0483db672526 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -344,7 +344,7 @@ int fsverity_get_descriptor(struct inode *inode,
 	return 0;
 }
 
-static int ensure_verity_info(struct inode *inode)
+int fsverity_ensure_verity_info(struct inode *inode)
 {
 	struct fsverity_info *vi = fsverity_get_info(inode), *found;
 	struct fsverity_descriptor *desc;
@@ -380,12 +380,13 @@ static int ensure_verity_info(struct inode *inode)
 	kfree(desc);
 	return err;
 }
+EXPORT_SYMBOL_GPL(fsverity_ensure_verity_info);
 
 int __fsverity_file_open(struct inode *inode, struct file *filp)
 {
 	if (filp->f_mode & FMODE_WRITE)
 		return -EPERM;
-	return ensure_verity_info(inode);
+	return fsverity_ensure_verity_info(inode);
 }
 EXPORT_SYMBOL_GPL(__fsverity_file_open);
 
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index a8f9aa75b792..8ba7806b225e 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -188,6 +188,7 @@ int fsverity_get_digest(struct inode *inode,
 /* open.c */
 
 int __fsverity_file_open(struct inode *inode, struct file *filp);
+int fsverity_ensure_verity_info(struct inode *inode);
 
 /* read_metadata.c */
 
@@ -281,6 +282,12 @@ static inline void fsverity_enqueue_verify_work(struct work_struct *work)
 	WARN_ON_ONCE(1);
 }
 
+static inline int fsverity_ensure_verity_info(struct inode *inode)
+{
+	WARN_ON_ONCE(1);
+	return -EOPNOTSUPP;
+}
+
 #endif	/* !CONFIG_FS_VERITY */
 
 static inline bool fsverity_verify_folio(struct fsverity_info *vi,
-- 
2.51.2

