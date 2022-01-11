Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B986EC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jan 2022 21:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245528AbiAKVu5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jan 2022 16:50:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37370 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245524AbiAKVu4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jan 2022 16:50:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E2FEB81D56;
        Tue, 11 Jan 2022 21:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B568CC36AEF;
        Tue, 11 Jan 2022 21:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641937852;
        bh=ViaH3qp49nvAJsw9cpvkSBehRIFbk1oJIUnJTuv08LI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PVAD6sDLMiBW9FSslwfleEEAQ6otNYtx9sZLhSFpLBSUbvkrxbxGsxmy5mqTR5tVb
         zjw27ImquKHhL6FUjpSq5o0DgoLTry6S7nm0wvsJGekUtS1ZLm80D1g+lX+TjDfEEV
         5H+GrovGwWkBwg9ywI3wod0sgWsasDp8O81IS+gI4qV5OOvihaaCgPPxu0ppJsE9PH
         QuEqH6JT/b/YlEPzRSCUNmBYP6b8qy/WXGYbBHLb9eHAcWydnEmYsMnVXJBr0Pd0ve
         dT0BI+ivMVtjgT/9stfaUTS6g5jTzcjfQbclyCFPnIjhK5Ihz05/+Z29nNV/X0UHpT
         dLd59dM56MfUg==
Subject: [PATCH 8/8] alloc: upgrade to fallocate
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 Jan 2022 13:50:52 -0800
Message-ID: <164193785240.3008286.9036820694976867986.stgit@magnolia>
In-Reply-To: <164193780808.3008286.598879710489501860.stgit@magnolia>
References: <164193780808.3008286.598879710489501860.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update this utility to use fallocate to preallocate/reserve space to a
file so that we're not so dependent on legacy XFS ioctls.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 src/alloc.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 55 insertions(+), 11 deletions(-)


diff --git a/src/alloc.c b/src/alloc.c
index 57a91f81..4a446ca8 100644
--- a/src/alloc.c
+++ b/src/alloc.c
@@ -118,6 +118,50 @@ bozo!
     }
 }
 
+#ifdef HAVE_FALLOCATE
+# define USE_LINUX_PREALLOCATE
+enum linux_opno {
+	FREESP = 0,
+	ALLOCSP,
+	UNRESVSP,
+	RESVSP,
+};
+
+/* emulate the irix preallocation functions with linux vfs calls */
+static int
+linux_preallocate(
+	int			fd,
+	enum linux_opno		opno,
+	const struct flock64	*f)
+{
+	struct stat		sbuf;
+	int			ret;
+
+	assert(f->l_whence == SEEK_SET);
+
+	switch (opno) {
+	case FREESP:
+		return ftruncate(fd, f->l_start);
+	case ALLOCSP:
+		ret = fstat(fd, &sbuf);
+		if (ret)
+			return ret;
+
+		return fallocate(fd, 0, sbuf.st_size,
+				f->l_start - sbuf.st_size);
+	case UNRESVSP:
+		return fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+				f->l_start, f->l_len);
+	case RESVSP:
+		return fallocate(fd, FALLOC_FL_KEEP_SIZE, f->l_start, f->l_len);
+	}
+
+	/* should never get here */
+	errno = EINVAL;
+	return -1;
+}
+#endif
+
 int
 main(int argc, char **argv)
 {
@@ -136,23 +180,23 @@ main(int argc, char **argv)
 				       "resvsp" };
 	int		opno;
 
-	/* Assume that if we have FREESP64 then we have the rest */
-#ifdef XFS_IOC_FREESP64
+#if defined(HAVE_FALLOCATE)
+	/* see static function above */
+#elif defined(XFS_IOC_FREESP64)
 #define USE_XFSCTL
+	/* Assume that if we have FREESP64 then we have the rest */
 	static int	optab[] = { XFS_IOC_FREESP64,
 				    XFS_IOC_ALLOCSP64,
 				    XFS_IOC_UNRESVSP64,
 				    XFS_IOC_RESVSP64 };
-#else
-#ifdef F_FREESP64
+#elif defined(F_FREESP64)
 #define USE_FCNTL
 	static int	optab[] = { F_FREESP64,
 				    F_ALLOCSP64,
 				    F_UNRESVSP64,
 				    F_RESVSP64 };
 #else
-bozo!
-#endif
+# error Dont know how to preallocate space!
 #endif
 	int		rflag = 0;
 	struct statvfs64	svfs;
@@ -311,14 +355,14 @@ bozo!
                                 opnames[opno], (long long)off, (long long)len);
                         
 			f.l_len = len;
-#ifdef USE_XFSCTL
+#if defined(USE_LINUX_PREALLOCATE)
+			c = linux_preallocate(fd, opno, &f);
+#elif defined(USE_XFSCTL)
 			c = xfsctl(filename, fd, optab[opno], &f);
-#else
-#ifdef USE_FCNTL
+#elif defined(USE_FCNTL)
 			c = fcntl(fd, optab[opno], &f);
 #else
-bozo!
-#endif
+# error Dont know how to preallocate space!
 #endif
 			if (c < 0) {
 				perror(opnames[opno]);

